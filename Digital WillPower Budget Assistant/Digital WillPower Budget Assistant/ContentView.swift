//
//  ContentView.swift
//  Digital WillPower Budget Assistant
//
//  Created by Will Page in Fall 2024.
//

import SwiftUI

struct Category: Identifiable, Codable {
    var id = UUID()
    var catName: String
    var target: Int
    var timeframe: String
}

let name = "Will"
let category = "Eating out"
let target = 100
let timeframe = "week"

struct ContentView: View {
    @AppStorage("categoriesData") private var categoriesData: Data = Data()
    @State private var categories: [Category] = [] //start with array defaulted to empty, need to change to be naive defaults
    @State private var showingAddCategoryForm = false //controls modal visibility
    
    init() {
            loadCategories()
        }
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 0.98, blue: 0.94)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                //Welcome header statement
                VStack(alignment: .leading) {
                    Text("Hey \(name)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    
                    Text("Set your target budget below!")
                        .font(.custom("task_header", fixedSize: 24))
                    
                    
                }
                .padding()
                
                Spacer()
                
                //Categories and targets
                VStack {
                    //Column headers
                    HStack{
                        Text("Category")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Target")
                            .padding(.trailing)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom, 5)
                    
                    // List of categories and targets
                    ForEach(categories) { category in
                        HStack {
                            Text("\(category.catName)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            Text("$\(category.target)")
                                .fontWeight(.bold)
                            Text("per")
                            Text("\(category.timeframe)")
                                .padding(.trailing)
                            }
                            .font(.custom("target", fixedSize: 24))
                            .padding(.bottom, 3)
                        }
                                        
                    Spacer()
                    
                    //Add new button
                    // Add new category button
                    Button(action: {
                        showingAddCategoryForm = true // Show the add category form
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.custom("target", fixedSize: 24))
                            Text("Add New Category")
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 60)
                    }
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .sheet(isPresented: $showingAddCategoryForm) {
                        AddCategoryForm(categories: $categories) {
                            saveCategories()
                        }
                    }
                }
                .padding(.bottom, 500)
            }
            .padding()
        }
    }
    
    // Load categories from UserDefaults
        private func loadCategories() {
            guard let decodedCat = try? JSONDecoder().decode([Category].self, from: categoriesData) else {
                return
            }
            categories = decodedCat
        }
        
        // Save categories to UserDefaults
        private func saveCategories() {
            guard let encodedCat = try? JSONEncoder().encode(categories) else {
                return
            }
            categoriesData = encodedCat
        }
    }

//Add Category Form

struct AddCategoryForm: View {
    @Environment(\.dismiss) var dismiss
    @Binding var categories: [Category]
    var onSave: () -> Void

    @State private var catName = ""
    @State private var target = ""
    @State private var timeframe = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Category Details")) {
                    TextField("Category Name", text: $catName)
                    TextField("Target Amount", text: $target)
                        .keyboardType(.numberPad)
                    TextField("Timeframe (e.g., week, month)", text: $timeframe)
                }
            }
            .navigationBarTitle("Add Category", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    if let targetValue = Int(target) {
                        let newCategory = Category(catName: name, target: targetValue, timeframe: timeframe)
                        categories.append(newCategory)
                        onSave() // Save the updated list to UserDefaults
                        dismiss() // Close the form
                        
                    }
                }.disabled(name.isEmpty || target.isEmpty || timeframe.isEmpty)
            )
        }
    }
}


#Preview {
    ContentView()
}
