Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbaEFGTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:19:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934006AbaEFGTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:19:37 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: nVMX: move vmclear and vmptrld pre-checks to nested_vmx_check_vmptr
Date: Tue,  6 May 2014 02:19:18 -0400
Message-Id: <1399357158-8305-5-git-send-email-bsd@redhat.com>
In-Reply-To: <1399357158-8305-1-git-send-email-bsd@redhat.com>
References: <1399357158-8305-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some checks are common to all, and moreover,
according to the spec, the check for whether any bits
beyond the physical address width are set are also
applicable to all of them

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/vmx.c | 83 ++++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6c125ff..9b36057 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5833,8 +5833,10 @@ static int get_vmx_mem_address(struct kvm_vcpu *vcpu,
  * - if it's 4KB aligned
  * - No bits beyond the physical address width are set
  * - Returns 0 on success or else 1
+ * (Intel SDM Section 30.3)
  */
-static int nested_vmx_check_vmptr(struct kvm_vcpu *vcpu, int exit_reason)
+static int nested_vmx_check_vmptr(struct kvm_vcpu *vcpu, int exit_reason,
+				  gpa_t *vmpointer)
 {
 	gva_t gva;
 	gpa_t vmptr;
@@ -5882,11 +5884,42 @@ static int nested_vmx_check_vmptr(struct kvm_vcpu *vcpu, int exit_reason)
 		kunmap(page);
 		vmx->nested.vmxon_ptr = vmptr;
 		break;
+	case EXIT_REASON_VMCLEAR:
+		if (!IS_ALIGNED(vmptr, PAGE_SIZE) || (vmptr >> maxphyaddr)) {
+			nested_vmx_failValid(vcpu,
+					     VMXERR_VMCLEAR_INVALID_ADDRESS);
+			skip_emulated_instruction(vcpu);
+			return 1;
+		}
 
+		if (vmptr == vmx->nested.vmxon_ptr) {
+			nested_vmx_failValid(vcpu,
+					     VMXERR_VMCLEAR_VMXON_POINTER);
+			skip_emulated_instruction(vcpu);
+			return 1;
+		}
+		break;
+	case EXIT_REASON_VMPTRLD:
+		if (!IS_ALIGNED(vmptr, PAGE_SIZE) || (vmptr >> maxphyaddr)) {
+			nested_vmx_failValid(vcpu,
+					     VMXERR_VMPTRLD_INVALID_ADDRESS);
+			skip_emulated_instruction(vcpu);
+			return 1;
+		}
+
+		if (vmptr == vmx->nested.vmxon_ptr) {
+			nested_vmx_failValid(vcpu,
+					     VMXERR_VMCLEAR_VMXON_POINTER);
+			skip_emulated_instruction(vcpu);
+			return 1;
+		}
+		break;
 	default:
 		return 1; /* shouldn't happen */
 	}
 
+	if (vmpointer)
+		*vmpointer = vmptr;
 	return 0;
 }
 
@@ -5929,7 +5962,7 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	if (nested_vmx_check_vmptr(vcpu, EXIT_REASON_VMON))
+	if (nested_vmx_check_vmptr(vcpu, EXIT_REASON_VMON, NULL))
 		return 1;
 
 	if (vmx->nested.vmxon) {
@@ -6058,37 +6091,16 @@ static int handle_vmoff(struct kvm_vcpu *vcpu)
 static int handle_vmclear(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	gva_t gva;
 	gpa_t vmptr;
 	struct vmcs12 *vmcs12;
 	struct page *page;
-	struct x86_exception e;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmcs_read32(VMX_INSTRUCTION_INFO), &gva))
+	if (nested_vmx_check_vmptr(vcpu, EXIT_REASON_VMCLEAR, &vmptr))
 		return 1;
 
-	if (kvm_read_guest_virt(&vcpu->arch.emulate_ctxt, gva, &vmptr,
-				sizeof(vmptr), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
-		return 1;
-	}
-
-	if (!IS_ALIGNED(vmptr, PAGE_SIZE)) {
-		nested_vmx_failValid(vcpu, VMXERR_VMCLEAR_INVALID_ADDRESS);
-		skip_emulated_instruction(vcpu);
-		return 1;
-	}
-
-	if (vmptr == vmx->nested.vmxon_ptr) {
-		nested_vmx_failValid(vcpu, VMXERR_VMCLEAR_VMXON_POINTER);
-		skip_emulated_instruction(vcpu);
-		return 1;
-	}
-
 	if (vmptr == vmx->nested.current_vmptr) {
 		nested_release_vmcs12(vmx);
 		vmx->nested.current_vmptr = -1ull;
@@ -6408,35 +6420,14 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 static int handle_vmptrld(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	gva_t gva;
 	gpa_t vmptr;
-	struct x86_exception e;
 	u32 exec_control;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
-			vmcs_read32(VMX_INSTRUCTION_INFO), &gva))
-		return 1;
-
-	if (kvm_read_guest_virt(&vcpu->arch.emulate_ctxt, gva, &vmptr,
-				sizeof(vmptr), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
-		return 1;
-	}
-
-	if (!IS_ALIGNED(vmptr, PAGE_SIZE)) {
-		nested_vmx_failValid(vcpu, VMXERR_VMPTRLD_INVALID_ADDRESS);
-		skip_emulated_instruction(vcpu);
+	if (nested_vmx_check_vmptr(vcpu, EXIT_REASON_VMPTRLD, &vmptr))
 		return 1;
-	}
-
-	if (vmptr == vmx->nested.vmxon_ptr) {
-		nested_vmx_failValid(vcpu, VMXERR_VMCLEAR_VMXON_POINTER);
-		skip_emulated_instruction(vcpu);
-		return 1;
-	}
 
 	if (vmx->nested.current_vmptr != vmptr) {
 		struct vmcs12 *new_vmcs12;
-- 
1.8.3.1

