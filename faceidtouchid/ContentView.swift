import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @AppStorage("status") var logged = false
    var body: some View {
        NavigationView {
//            if logged {
//             Text("User logged in...")
//                .navigationTitle("Home")
//                .navigationBarHidden(false)
////                .preferredColorScheme(.light)
//                .padding(.top, 8)
//            }else {
                Home()
//                    .preferredColorScheme(.dark)
                    .navigationBarHidden(false)
//            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: - Home
struct Home: View {
    @State var userName = ""
    @State var password = ""
    // when first time user logged in via email store this for future biometric login...
    @AppStorage("stored_User") var user = "723125@gmail.com"
    @AppStorage("status") var logged = false
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            Image("lightalien")
                .resizable()
                .aspectRatio(contentMode: .fit)
                
                //Dynamic Frame ...
                
                .padding(.horizontal, 100)
                .padding(.vertical)
            HStack {
                VStack(alignment: .leading, spacing: 12, content: {
                    Text("login")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("Please sign in to continue")
                        .foregroundColor(Color.primary.opacity(0.5))
                })
                Spacer(minLength: 0)
            } //hstack
            .padding()
            .padding(.leading, 35)
            HStack {
                Image(systemName: "envelope")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(width: 35)
                
                TextField("Email", text: $userName)
                    .autocapitalization(.none)
            } //hstack
            .padding()
            .background(Color.primary.opacity(userName == "" ? 0 : 0.10))
            .cornerRadius(15)
            .padding(.horizontal)
            
            HStack {
                Image(systemName: "lock")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(width: 35)
                
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
            } //hstack
            .padding()
            .background(Color.primary.opacity(userName == "" ? 0 : 0.10))
            .cornerRadius(15)
            .padding(.horizontal)
            .padding(.top)
            
            HStack(spacing: 15) {
                Button(action: {}, label: {
                    Text("LOGIN")
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 150)
                        .background(Color("green"))
                        .clipShape(Capsule())
                })
                .opacity(userName != "" && password != "" ? 1 : 1)
                .disabled(userName != "" && password != "" ? false : true)
                
                if getBiometricStatus() {
                    Button(action: authenticateUser, label: {
                        // getting biometrictype ...
                        Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                            .font(.title)
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color("greem"))
                            .clipShape(Circle())
                    })
                }
            } //hstack
            .padding(.top)
            
            //forget button
            Button(action: {}, label: {
                Text("Forget password?")
                    .foregroundColor(Color("green"))
            })
            .padding(.top, 8)
            
            //signUp
            Spacer(minLength: 0)
            HStack(spacing: 6) {
                Text("Don't have an account yet ?")
                    .foregroundColor(Color.primary.opacity(0.6))
                
                Button(action: {}, label: {
                    Text("SignUp")
                        .fontWeight(.heavy)
                        .foregroundColor(Color("green"))
                })
                
            }
            .padding(.vertical)
            
        }//vstack
        .background(Color("bg").ignoresSafeArea(.all, edges: .all))
        .animation(.easeOut)
    }// body
    
    // getting biometricType....
    func getBiometricStatus()-> Bool {
        let scanner = LAContext()
        if userName == user && scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
            return true
        }
        return false
    }
    
    // authenticate user ...
    func authenticateUser() {
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Unlock \(userName)") {(status, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            // setting logged status as true
            withAnimation(.easeOut){logged = true }
        }
    }
}

