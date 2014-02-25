Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaBYRuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:50:00 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:35482 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaBYRtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:49:47 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, mtosatti@redhat.com, jan.kiszka@siemens.com,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: [PATCH 2/2] KVM: x86: Add nested virtualization support for MPX
Date: Tue, 25 Feb 2014 18:49:37 +0100
Message-Id: <1393350577-11532-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393350577-11532-1-git-send-email-pbonzini@redhat.com>
References: <1393350577-11532-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is simple to do, the "host" BNDCFGS is either 0 or the guest value.
However, both controls have to be present.  We cannot provide MPX if
we only have one of the "load BNDCFGS" or "clear BNDCFGS" controls.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 729b1e42aded..da28ac46ca88 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -202,6 +202,7 @@ struct __packed vmcs12 {
 	u64 guest_pdptr1;
 	u64 guest_pdptr2;
 	u64 guest_pdptr3;
+	u64 guest_bndcfgs;
 	u64 host_ia32_pat;
 	u64 host_ia32_efer;
 	u64 host_ia32_perf_global_ctrl;
@@ -534,6 +535,7 @@ static const unsigned long shadow_read_write_fields[] = {
 	GUEST_CS_LIMIT,
 	GUEST_CS_BASE,
 	GUEST_ES_BASE,
+	GUEST_BNDCFGS,
 	CR0_GUEST_HOST_MASK,
 	CR0_READ_SHADOW,
 	CR4_READ_SHADOW,
@@ -589,6 +591,7 @@ static const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD64(GUEST_PDPTR1, guest_pdptr1),
 	FIELD64(GUEST_PDPTR2, guest_pdptr2),
 	FIELD64(GUEST_PDPTR3, guest_pdptr3),
+	FIELD64(GUEST_BNDCFGS, guest_bndcfgs),
 	FIELD64(HOST_IA32_PAT, host_ia32_pat),
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
@@ -719,6 +722,7 @@ static unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu);
 static u64 construct_eptp(unsigned long root_hpa);
 static void kvm_cpu_vmxon(u64 addr);
 static void kvm_cpu_vmxoff(void);
+static bool vmx_mpx_supported(void);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 static void vmx_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
@@ -2279,6 +2283,8 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 	}
 	nested_vmx_exit_ctls_high |= (VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER);
+	if (vmx_mpx_supported())
+		nested_vmx_exit_ctls_high |= VM_EXIT_CLEAR_BNDCFGS;
 
 	/* entry controls */
 	rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
@@ -2292,6 +2298,8 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 		VM_ENTRY_LOAD_IA32_PAT;
 	nested_vmx_entry_ctls_high |= (VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |
 				       VM_ENTRY_LOAD_IA32_EFER);
+	if (vmx_mpx_supported())
+		nested_vmx_entry_ctls_high |= VM_ENTRY_LOAD_BNDCFGS;
 
 	/* cpu-based controls */
 	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS,
@@ -7847,6 +7855,9 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	set_cr4_guest_host_mask(vmx);
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)
+		vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
+
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING)
 		vmcs_write64(TSC_OFFSET,
 			vmx->nested.vmcs01_tsc_offset + vmcs12->tsc_offset);
@@ -8277,6 +8288,7 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
 	vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
 	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
+	vmcs12->guest_bndcfgs = vmcs_readl(GUEST_BNDCFGS);
 
 	/* update exit information fields: */
 
@@ -8386,6 +8398,10 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	vmcs_writel(GUEST_IDTR_BASE, vmcs12->host_idtr_base);
 	vmcs_writel(GUEST_GDTR_BASE, vmcs12->host_gdtr_base);
 
+	/* If not VM_EXIT_CLEAR_BNDCFGS, the L2 value propagates to L1.  */
+	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
+		vmcs_write64(GUEST_BNDCFGS, 0);
+
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
-- 
1.8.3.1

