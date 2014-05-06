Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098AbaEFGUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:20:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933948AbaEFGTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:19:35 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] KVM: nVMX: additional checks on vmxon region
Date: Tue,  6 May 2014 02:19:16 -0400
Message-Id: <1399357158-8305-3-git-send-email-bsd@redhat.com>
In-Reply-To: <1399357158-8305-1-git-send-email-bsd@redhat.com>
References: <1399357158-8305-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the vmxon region isn't used in the nested case.
However, according to the spec, the vmxon instruction performs
additional sanity checks on this region and the associated
pointer. Modify emulated vmxon to better adhere to the spec
requirements

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/cpuid.c |  1 +
 arch/x86/kvm/vmx.c   | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f47a104..da9894b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -726,6 +726,7 @@ int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 not_found:
 	return 36;
 }
+EXPORT_SYMBOL_GPL(cpuid_maxphyaddr);
 
 /*
  * If no match is found, check whether we exceed the vCPU's limit
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c18fe9a4..059906a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -354,6 +354,7 @@ struct vmcs02_list {
 struct nested_vmx {
 	/* Has the level1 guest done vmxon? */
 	bool vmxon;
+	gpa_t vmxon_ptr;
 
 	/* The guest-physical address of the current VMCS L1 keeps for L2 */
 	gpa_t current_vmptr;
@@ -5828,6 +5829,68 @@ static int get_vmx_mem_address(struct kvm_vcpu *vcpu,
 }
 
 /*
+ * This function performs the various checks including
+ * - if it's 4KB aligned
+ * - No bits beyond the physical address width are set
+ * - Returns 0 on success or else 1
+ */
+static int nested_vmx_check_vmptr(struct kvm_vcpu *vcpu, int exit_reason)
+{
+	gva_t gva;
+	gpa_t vmptr;
+	struct x86_exception e;
+	struct page *page;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int maxphyaddr = cpuid_maxphyaddr(vcpu);
+
+	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
+			vmcs_read32(VMX_INSTRUCTION_INFO), &gva))
+		return 1;
+
+	if (kvm_read_guest_virt(&vcpu->arch.emulate_ctxt, gva, &vmptr,
+				sizeof(vmptr), &e)) {
+		kvm_inject_page_fault(vcpu, &e);
+		return 1;
+	}
+
+	switch (exit_reason) {
+	case EXIT_REASON_VMON:
+		/*
+		 * SDM 3: 24.11.5
+		 * The first 4 bytes of VMXON region contain the supported
+		 * VMCS revision identifier
+		 *
+		 * Note - IA32_VMX_BASIC[48] will never be 1
+		 * for the nested case;
+		 * which replaces physical address width with 32
+		 *
+		 */
+		if (!IS_ALIGNED(vmptr, PAGE_SIZE) || (vmptr >> maxphyaddr)) {
+			nested_vmx_failInvalid(vcpu);
+			skip_emulated_instruction(vcpu);
+			return 1;
+		}
+
+		page = nested_get_page(vcpu, vmptr);
+		if (page == NULL ||
+		    *(u32 *)kmap(page) != VMCS12_REVISION) {
+			nested_vmx_failInvalid(vcpu);
+			kunmap(page);
+			skip_emulated_instruction(vcpu);
+			return 1;
+		}
+		kunmap(page);
+		vmx->nested.vmxon_ptr = vmptr;
+		break;
+
+	default:
+		return 1; /* shouldn't happen */
+	}
+
+	return 0;
+}
+
+/*
  * Emulate the VMXON instruction.
  * Currently, we just remember that VMX is active, and do not save or even
  * inspect the argument to VMXON (the so-called "VMXON pointer") because we
@@ -5865,6 +5928,10 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
+
+	if (nested_vmx_check_vmptr(vcpu, EXIT_REASON_VMON))
+		return 1;
+
 	if (vmx->nested.vmxon) {
 		nested_vmx_failValid(vcpu, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
 		skip_emulated_instruction(vcpu);
-- 
1.8.3.1

