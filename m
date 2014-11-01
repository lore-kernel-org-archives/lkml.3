Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaKAXD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:03:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60033 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jun Nakajima" <jun.nakajima@intel.com>,
        "Xinhao Xu" <xinhao.xu@intel.com>,
        "Yang Zhang" <yang.z.zhang@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Xiao Guangrong" <xiaoguangrong@linux.vnet.ibm.com>,
        "Gleb Natapov" <gleb@redhat.com>, "Nadav Har'El" <nyh@il.ibm.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.12343835@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 087/102] nEPT: Nested INVEPT
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Har'El <nyh@il.ibm.com>

commit bfd0a56b90005f8c8a004baf407ad90045c2b11e upstream.

If we let L1 use EPT, we should probably also support the INVEPT instruction.

In our current nested EPT implementation, when L1 changes its EPT table
for L2 (i.e., EPT12), L0 modifies the shadow EPT table (EPT02), and in
the course of this modification already calls INVEPT. But if last level
of shadow page is unsync not all L1's changes to EPT12 are intercepted,
which means roots need to be synced when L1 calls INVEPT. Global INVEPT
should not be different since roots are synced by kvm_mmu_load() each
time EPTP02 changes.

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Nadav Har'El <nyh@il.ibm.com>
Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Xinhao Xu <xinhao.xu@intel.com>
Signed-off-by: Yang Zhang <yang.z.zhang@Intel.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context, filename
 - Add definition of nested_ept_get_cr3(), added upstream by commit
   155a97a3d7c7 ("nEPT: MMU context for nested EPT")]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -279,6 +279,7 @@ enum vmcs_field {
 #define EXIT_REASON_APIC_ACCESS         44
 #define EXIT_REASON_EPT_VIOLATION       48
 #define EXIT_REASON_EPT_MISCONFIG       49
+#define EXIT_REASON_INVEPT              50
 #define EXIT_REASON_WBINVD		54
 #define EXIT_REASON_XSETBV		55
 
@@ -397,6 +398,7 @@ enum vmcs_field {
 #define VMX_EPT_EXTENT_INDIVIDUAL_ADDR		0
 #define VMX_EPT_EXTENT_CONTEXT			1
 #define VMX_EPT_EXTENT_GLOBAL			2
+#define VMX_EPT_EXTENT_SHIFT			24
 
 #define VMX_EPT_EXECUTE_ONLY_BIT		(1ull)
 #define VMX_EPT_PAGE_WALK_4_BIT			(1ull << 6)
@@ -404,6 +406,7 @@ enum vmcs_field {
 #define VMX_EPTP_WB_BIT				(1ull << 14)
 #define VMX_EPT_2MB_PAGE_BIT			(1ull << 16)
 #define VMX_EPT_1GB_PAGE_BIT			(1ull << 17)
+#define VMX_EPT_INVEPT_BIT			(1ull << 20)
 #define VMX_EPT_EXTENT_INDIVIDUAL_BIT		(1ull << 24)
 #define VMX_EPT_EXTENT_CONTEXT_BIT		(1ull << 25)
 #define VMX_EPT_EXTENT_GLOBAL_BIT		(1ull << 26)
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2869,6 +2869,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu
 	mmu_sync_roots(vcpu);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_sync_roots);
 
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 				  u32 access, struct x86_exception *exception)
@@ -3131,6 +3132,7 @@ void kvm_mmu_flush_tlb(struct kvm_vcpu *
 	++vcpu->stat.tlb_flush;
 	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_flush_tlb);
 
 static void paging_new_cr3(struct kvm_vcpu *vcpu)
 {
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -602,6 +602,7 @@ static void nested_release_page_clean(st
 	kvm_release_page_clean(page);
 }
 
+static unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu);
 static u64 construct_eptp(unsigned long root_hpa);
 static void kvm_cpu_vmxon(u64 addr);
 static void kvm_cpu_vmxoff(void);
@@ -1899,6 +1900,7 @@ static u32 nested_vmx_secondary_ctls_low
 static u32 nested_vmx_pinbased_ctls_low, nested_vmx_pinbased_ctls_high;
 static u32 nested_vmx_exit_ctls_low, nested_vmx_exit_ctls_high;
 static u32 nested_vmx_entry_ctls_low, nested_vmx_entry_ctls_high;
+static u32 nested_vmx_ept_caps;
 static __init void nested_vmx_setup_ctls_msrs(void)
 {
 	/*
@@ -5550,6 +5552,74 @@ static int handle_vmptrst(struct kvm_vcp
 	return 1;
 }
 
+/* Emulate the INVEPT instruction */
+static int handle_invept(struct kvm_vcpu *vcpu)
+{
+	u32 vmx_instruction_info, types;
+	unsigned long type;
+	gva_t gva;
+	struct x86_exception e;
+	struct {
+		u64 eptp, gpa;
+	} operand;
+	u64 eptp_mask = ((1ull << 51) - 1) & PAGE_MASK;
+
+	if (!(nested_vmx_secondary_ctls_high & SECONDARY_EXEC_ENABLE_EPT) ||
+	    !(nested_vmx_ept_caps & VMX_EPT_INVEPT_BIT)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	if (!nested_vmx_check_permission(vcpu))
+		return 1;
+
+	if (!kvm_read_cr0_bits(vcpu, X86_CR0_PE)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
+
+	types = (nested_vmx_ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
+
+	if (!(types & (1UL << type))) {
+		nested_vmx_failValid(vcpu,
+				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+		return 1;
+	}
+
+	/* According to the Intel VMX instruction reference, the memory
+	 * operand is read even if it isn't needed (e.g., for type==global)
+	 */
+	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
+			vmx_instruction_info, &gva))
+		return 1;
+	if (kvm_read_guest_virt(&vcpu->arch.emulate_ctxt, gva, &operand,
+				sizeof(operand), &e)) {
+		kvm_inject_page_fault(vcpu, &e);
+		return 1;
+	}
+
+	switch (type) {
+	case VMX_EPT_EXTENT_CONTEXT:
+		if ((operand.eptp & eptp_mask) !=
+				(nested_ept_get_cr3(vcpu) & eptp_mask))
+			break;
+	case VMX_EPT_EXTENT_GLOBAL:
+		kvm_mmu_sync_roots(vcpu);
+		kvm_mmu_flush_tlb(vcpu);
+		nested_vmx_succeed(vcpu);
+		break;
+	default:
+		BUG_ON(1);
+		break;
+	}
+
+	skip_emulated_instruction(vcpu);
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5591,6 +5661,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_PAUSE_INSTRUCTION]       = handle_pause,
 	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_invalid_op,
 	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_invalid_op,
+	[EXIT_REASON_INVEPT]                  = handle_invept,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -5775,6 +5846,7 @@ static bool nested_vmx_exit_handled(stru
 	case EXIT_REASON_VMPTRST: case EXIT_REASON_VMREAD:
 	case EXIT_REASON_VMRESUME: case EXIT_REASON_VMWRITE:
 	case EXIT_REASON_VMOFF: case EXIT_REASON_VMON:
+	case EXIT_REASON_INVEPT:
 		/*
 		 * VMX instructions trap unconditionally. This allows L1 to
 		 * emulate them for its L2 guest, i.e., allows 3-level nesting!
@@ -6436,6 +6508,12 @@ static void vmx_set_supported_cpuid(u32
 		entry->ecx |= bit(X86_FEATURE_VMX);
 }
 
+static unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu)
+{
+	/* return the page table to be shadowed - in our case, EPT12 */
+	return get_vmcs12(vcpu)->ept_pointer;
+}
+
 /*
  * prepare_vmcs02 is called when the L1 guest hypervisor runs its nested
  * L2 guest. L1 has a vmcs for L2 (vmcs12), and this function "merges" it

