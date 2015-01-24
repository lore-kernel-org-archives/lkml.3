Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbbAXKWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 05:22:24 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:51722 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbAXKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 05:22:22 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Sat, 24 Jan 2015 18:22:00 +0800
Message-ID: <CACzj_yW3wysdAA1VrBXakSZSSZW1UOpTnYecaCZcmPPsQ-QJMg@mail.gmail.com>
Subject: [PATCH v3 3/6] KVM: nVMX: Make nested control MSRs per-cpu.
To: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        =?UTF-8?B?6IyD5paH5LiA?= <fanwenyi0529@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To enable nested apicv support, we need per-cpu vmx
control MSRs:
  1. If in-kernel irqchip is enabled, we can enable nested
     posted interrupt, we should set posted intr bit in
     the nested_vmx_pinbased_ctls_high.
  2. If in-kernel irqchip is disabled, we can not enable
     nested posted interrupt, the posted intr bit
     in the nested_vmx_pinbased_ctls_high will be cleared.

Since there would be different settings about in-kernel
irqchip between VMs, different nested control MSRs
are needed.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/kvm/vmx.c |  215 +++++++++++++++++++++++++++++++---------------------
 1 files changed, 129 insertions(+), 86 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4d8939d..6ec0c2c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -408,6 +408,23 @@ struct nested_vmx {

        /* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
        u64 vmcs01_debugctl;
+
+       u32 nested_vmx_procbased_ctls_low;
+       u32 nested_vmx_procbased_ctls_high;
+       u32 nested_vmx_true_procbased_ctls_low;
+       u32 nested_vmx_secondary_ctls_low;
+       u32 nested_vmx_secondary_ctls_high;
+       u32 nested_vmx_pinbased_ctls_low;
+       u32 nested_vmx_pinbased_ctls_high;
+       u32 nested_vmx_exit_ctls_low;
+       u32 nested_vmx_exit_ctls_high;
+       u32 nested_vmx_true_exit_ctls_low;
+       u32 nested_vmx_entry_ctls_low;
+       u32 nested_vmx_entry_ctls_high;
+       u32 nested_vmx_true_entry_ctls_low;
+       u32 nested_vmx_misc_low;
+       u32 nested_vmx_misc_high;
+       u32 nested_vmx_ept_caps;
 };

 #define POSTED_INTR_ON  0
@@ -2285,20 +2302,8 @@ static inline bool nested_vmx_allowed(struct
kvm_vcpu *vcpu)
  * if the corresponding bit in the (32-bit) control field *must* be on, and a
  * bit in the high half is on if the corresponding bit in the control field
  * may be on. See also vmx_control_verify().
- * TODO: allow these variables to be modified (downgraded) by module options
- * or other means.
  */
-static u32 nested_vmx_procbased_ctls_low, nested_vmx_procbased_ctls_high;
-static u32 nested_vmx_true_procbased_ctls_low;
-static u32 nested_vmx_secondary_ctls_low, nested_vmx_secondary_ctls_high;
-static u32 nested_vmx_pinbased_ctls_low, nested_vmx_pinbased_ctls_high;
-static u32 nested_vmx_exit_ctls_low, nested_vmx_exit_ctls_high;
-static u32 nested_vmx_true_exit_ctls_low;
-static u32 nested_vmx_entry_ctls_low, nested_vmx_entry_ctls_high;
-static u32 nested_vmx_true_entry_ctls_low;
-static u32 nested_vmx_misc_low, nested_vmx_misc_high;
-static u32 nested_vmx_ept_caps;
-static __init void nested_vmx_setup_ctls_msrs(void)
+static void nested_vmx_setup_ctls_msrs(struct vcpu_vmx *vmx)
 {
        /*
         * Note that as a general rule, the high half of the MSRs (bits in
@@ -2317,57 +2322,71 @@ static __init void nested_vmx_setup_ctls_msrs(void)

        /* pin-based controls */
        rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
-             nested_vmx_pinbased_ctls_low, nested_vmx_pinbased_ctls_high);
-       nested_vmx_pinbased_ctls_low |= PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
-       nested_vmx_pinbased_ctls_high &= PIN_BASED_EXT_INTR_MASK |
-               PIN_BASED_NMI_EXITING | PIN_BASED_VIRTUAL_NMIS;
-       nested_vmx_pinbased_ctls_high |= PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |
+               vmx->nested.nested_vmx_pinbased_ctls_low,
+               vmx->nested.nested_vmx_pinbased_ctls_high);
+       vmx->nested.nested_vmx_pinbased_ctls_low |=
+               PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+       vmx->nested.nested_vmx_pinbased_ctls_high &=
+               PIN_BASED_EXT_INTR_MASK |
+               PIN_BASED_NMI_EXITING |
+               PIN_BASED_VIRTUAL_NMIS;
+       vmx->nested.nested_vmx_pinbased_ctls_high |=
+               PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |
                PIN_BASED_VMX_PREEMPTION_TIMER;

        /* exit controls */
        rdmsr(MSR_IA32_VMX_EXIT_CTLS,
-               nested_vmx_exit_ctls_low, nested_vmx_exit_ctls_high);
-       nested_vmx_exit_ctls_low = VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
+               vmx->nested.nested_vmx_exit_ctls_low,
+               vmx->nested.nested_vmx_exit_ctls_high);
+       vmx->nested.nested_vmx_exit_ctls_low =
+               VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;

-       nested_vmx_exit_ctls_high &=
+       vmx->nested.nested_vmx_exit_ctls_high &=
 #ifdef CONFIG_X86_64
                VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
                VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT;
-       nested_vmx_exit_ctls_high |= VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
+       vmx->nested.nested_vmx_exit_ctls_high |=
+               VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
                VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
                VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT;

        if (vmx_mpx_supported())
-               nested_vmx_exit_ctls_high |= VM_EXIT_CLEAR_BNDCFGS;
+               vmx->nested.nested_vmx_exit_ctls_high |= VM_EXIT_CLEAR_BNDCFGS;

        /* We support free control of debug control saving. */
-       nested_vmx_true_exit_ctls_low = nested_vmx_exit_ctls_low &
+       vmx->nested.nested_vmx_true_exit_ctls_low =
+               vmx->nested.nested_vmx_exit_ctls_low &
                ~VM_EXIT_SAVE_DEBUG_CONTROLS;

        /* entry controls */
        rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
-               nested_vmx_entry_ctls_low, nested_vmx_entry_ctls_high);
-       nested_vmx_entry_ctls_low = VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
-       nested_vmx_entry_ctls_high &=
+               vmx->nested.nested_vmx_entry_ctls_low,
+               vmx->nested.nested_vmx_entry_ctls_high);
+       vmx->nested.nested_vmx_entry_ctls_low =
+               VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
+       vmx->nested.nested_vmx_entry_ctls_high &=
 #ifdef CONFIG_X86_64
                VM_ENTRY_IA32E_MODE |
 #endif
                VM_ENTRY_LOAD_IA32_PAT;
-       nested_vmx_entry_ctls_high |= (VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |
-                                      VM_ENTRY_LOAD_IA32_EFER);
+       vmx->nested.nested_vmx_entry_ctls_high |=
+               (VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
        if (vmx_mpx_supported())
-               nested_vmx_entry_ctls_high |= VM_ENTRY_LOAD_BNDCFGS;
+               vmx->nested.nested_vmx_entry_ctls_high |= VM_ENTRY_LOAD_BNDCFGS;

        /* We support free control of debug control loading. */
-       nested_vmx_true_entry_ctls_low = nested_vmx_entry_ctls_low &
+       vmx->nested.nested_vmx_true_entry_ctls_low =
+               vmx->nested.nested_vmx_entry_ctls_low &
                ~VM_ENTRY_LOAD_DEBUG_CONTROLS;

        /* cpu-based controls */
        rdmsr(MSR_IA32_VMX_PROCBASED_CTLS,
-               nested_vmx_procbased_ctls_low, nested_vmx_procbased_ctls_high);
-       nested_vmx_procbased_ctls_low = CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
-       nested_vmx_procbased_ctls_high &=
+               vmx->nested.nested_vmx_procbased_ctls_low,
+               vmx->nested.nested_vmx_procbased_ctls_high);
+       vmx->nested.nested_vmx_procbased_ctls_low =
+               CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+       vmx->nested.nested_vmx_procbased_ctls_high &=
                CPU_BASED_VIRTUAL_INTR_PENDING |
                CPU_BASED_VIRTUAL_NMI_PENDING | CPU_BASED_USE_TSC_OFFSETING |
                CPU_BASED_HLT_EXITING | CPU_BASED_INVLPG_EXITING |
@@ -2387,18 +2406,21 @@ static __init void nested_vmx_setup_ctls_msrs(void)
         * can use it to avoid exits to L1 - even when L0 runs L2
         * without MSR bitmaps.
         */
-       nested_vmx_procbased_ctls_high |= CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR |
+       vmx->nested.nested_vmx_procbased_ctls_high |=
+               CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR |
                CPU_BASED_USE_MSR_BITMAPS;

        /* We support free control of CR3 access interception. */
-       nested_vmx_true_procbased_ctls_low = nested_vmx_procbased_ctls_low &
+       vmx->nested.nested_vmx_true_procbased_ctls_low =
+               vmx->nested.nested_vmx_procbased_ctls_low &
                ~(CPU_BASED_CR3_LOAD_EXITING | CPU_BASED_CR3_STORE_EXITING);

        /* secondary cpu-based controls */
        rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
-               nested_vmx_secondary_ctls_low, nested_vmx_secondary_ctls_high);
-       nested_vmx_secondary_ctls_low = 0;
-       nested_vmx_secondary_ctls_high &=
+               vmx->nested.nested_vmx_secondary_ctls_low,
+               vmx->nested.nested_vmx_secondary_ctls_high);
+       vmx->nested.nested_vmx_secondary_ctls_low = 0;
+       vmx->nested.nested_vmx_secondary_ctls_high &=
                SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
                SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
                SECONDARY_EXEC_WBINVD_EXITING |
@@ -2406,27 +2428,31 @@ static __init void nested_vmx_setup_ctls_msrs(void)

        if (enable_ept) {
                /* nested EPT: emulate EPT also to L1 */
-               nested_vmx_secondary_ctls_high |= SECONDARY_EXEC_ENABLE_EPT |
+               vmx->nested.nested_vmx_secondary_ctls_high |=
+                       SECONDARY_EXEC_ENABLE_EPT |
                        SECONDARY_EXEC_UNRESTRICTED_GUEST;
-               nested_vmx_ept_caps = VMX_EPT_PAGE_WALK_4_BIT |
+               vmx->nested.nested_vmx_ept_caps = VMX_EPT_PAGE_WALK_4_BIT |
                         VMX_EPTP_WB_BIT | VMX_EPT_2MB_PAGE_BIT |
                         VMX_EPT_INVEPT_BIT;
-               nested_vmx_ept_caps &= vmx_capability.ept;
+               vmx->nested.nested_vmx_ept_caps &= vmx_capability.ept;
                /*
                 * For nested guests, we don't do anything specific
                 * for single context invalidation. Hence, only advertise
                 * support for global context invalidation.
                 */
-               nested_vmx_ept_caps |= VMX_EPT_EXTENT_GLOBAL_BIT;
+               vmx->nested.nested_vmx_ept_caps |= VMX_EPT_EXTENT_GLOBAL_BIT;
        } else
-               nested_vmx_ept_caps = 0;
+               vmx->nested.nested_vmx_ept_caps = 0;

        /* miscellaneous data */
-       rdmsr(MSR_IA32_VMX_MISC, nested_vmx_misc_low, nested_vmx_misc_high);
-       nested_vmx_misc_low &= VMX_MISC_SAVE_EFER_LMA;
-       nested_vmx_misc_low |= VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
+       rdmsr(MSR_IA32_VMX_MISC,
+               vmx->nested.nested_vmx_misc_low,
+               vmx->nested.nested_vmx_misc_high);
+       vmx->nested.nested_vmx_misc_low &= VMX_MISC_SAVE_EFER_LMA;
+       vmx->nested.nested_vmx_misc_low |=
+               VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
                VMX_MISC_ACTIVITY_HLT;
-       nested_vmx_misc_high = 0;
+       vmx->nested.nested_vmx_misc_high = 0;
 }

 static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
@@ -2445,6 +2471,8 @@ static inline u64 vmx_control_msr(u32 low, u32 high)
 /* Returns 0 on success, non-0 otherwise. */
 static int vmx_get_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
+       struct vcpu_vmx *vmx = to_vmx(vcpu);
+
        switch (msr_index) {
        case MSR_IA32_VMX_BASIC:
                /*
@@ -2459,36 +2487,44 @@ static int vmx_get_vmx_msr(struct kvm_vcpu
*vcpu, u32 msr_index, u64 *pdata)
                break;
        case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
        case MSR_IA32_VMX_PINBASED_CTLS:
-               *pdata = vmx_control_msr(nested_vmx_pinbased_ctls_low,
-                                       nested_vmx_pinbased_ctls_high);
+               *pdata = vmx_control_msr(
+                       vmx->nested.nested_vmx_pinbased_ctls_low,
+                       vmx->nested.nested_vmx_pinbased_ctls_high);
                break;
        case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
-               *pdata = vmx_control_msr(nested_vmx_true_procbased_ctls_low,
-                                       nested_vmx_procbased_ctls_high);
+               *pdata = vmx_control_msr(
+                       vmx->nested.nested_vmx_true_procbased_ctls_low,
+                       vmx->nested.nested_vmx_procbased_ctls_high);
                break;
        case MSR_IA32_VMX_PROCBASED_CTLS:
-               *pdata = vmx_control_msr(nested_vmx_procbased_ctls_low,
-                                       nested_vmx_procbased_ctls_high);
+               *pdata = vmx_control_msr(
+                       vmx->nested.nested_vmx_procbased_ctls_low,
+                       vmx->nested.nested_vmx_procbased_ctls_high);
                break;
        case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-               *pdata = vmx_control_msr(nested_vmx_true_exit_ctls_low,
-                                       nested_vmx_exit_ctls_high);
+               *pdata = vmx_control_msr(
+                       vmx->nested.nested_vmx_true_exit_ctls_low,
+                       vmx->nested.nested_vmx_exit_ctls_high);
                break;
        case MSR_IA32_VMX_EXIT_CTLS:
-               *pdata = vmx_control_msr(nested_vmx_exit_ctls_low,
-                                       nested_vmx_exit_ctls_high);
+               *pdata = vmx_control_msr(
+                       vmx->nested.nested_vmx_exit_ctls_low,
+                       vmx->nested.nested_vmx_exit_ctls_high);
                break;
        case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-               *pdata = vmx_control_msr(nested_vmx_true_entry_ctls_low,
-                                       nested_vmx_entry_ctls_high);
+               *pdata = vmx_control_msr(
+                       vmx->nested.nested_vmx_true_entry_ctls_low,
+                       vmx->nested.nested_vmx_entry_ctls_high);
                break;
        case MSR_IA32_VMX_ENTRY_CTLS:
-               *pdata = vmx_control_msr(nested_vmx_entry_ctls_low,
-                                       nested_vmx_entry_ctls_high);
+               *pdata = vmx_control_msr(
+                       vmx->nested.nested_vmx_entry_ctls_low,
+                       vmx->nested.nested_vmx_entry_ctls_high);
                break;
        case MSR_IA32_VMX_MISC:
-               *pdata = vmx_control_msr(nested_vmx_misc_low,
-                                        nested_vmx_misc_high);
+               *pdata = vmx_control_msr(
+                       vmx->nested.nested_vmx_misc_low,
+                       vmx->nested.nested_vmx_misc_high);
                break;
        /*
         * These MSRs specify bits which the guest must keep fixed (on or off)
@@ -2513,12 +2549,13 @@ static int vmx_get_vmx_msr(struct kvm_vcpu
*vcpu, u32 msr_index, u64 *pdata)
                *pdata = 0x2e; /* highest index: VMX_PREEMPTION_TIMER_VALUE */
                break;
        case MSR_IA32_VMX_PROCBASED_CTLS2:
-               *pdata = vmx_control_msr(nested_vmx_secondary_ctls_low,
-                                       nested_vmx_secondary_ctls_high);
+               *pdata = vmx_control_msr(
+                       vmx->nested.nested_vmx_secondary_ctls_low,
+                       vmx->nested.nested_vmx_secondary_ctls_high);
                break;
        case MSR_IA32_VMX_EPT_VPID_CAP:
                /* Currently, no nested vpid support */
-               *pdata = nested_vmx_ept_caps;
+               *pdata = vmx->nested.nested_vmx_ept_caps;
                break;
        default:
                return 1;
@@ -5032,11 +5069,12 @@ vmx_patch_hypercall(struct kvm_vcpu *vcpu,
unsigned char *hypercall)
        hypercall[2] = 0xc1;
 }

-static bool nested_cr0_valid(struct vmcs12 *vmcs12, unsigned long val)
+static bool nested_cr0_valid(struct kvm_vcpu *vcpu, unsigned long val)
 {
        unsigned long always_on = VMXON_CR0_ALWAYSON;
+       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);

-       if (nested_vmx_secondary_ctls_high &
+       if (to_vmx(vcpu)->nested.nested_vmx_secondary_ctls_high &
                SECONDARY_EXEC_UNRESTRICTED_GUEST &&
            nested_cpu_has2(vmcs12, SECONDARY_EXEC_UNRESTRICTED_GUEST))
                always_on &= ~(X86_CR0_PE | X86_CR0_PG);
@@ -5061,7 +5099,7 @@ static int handle_set_cr0(struct kvm_vcpu *vcpu,
unsigned long val)
                val = (val & ~vmcs12->cr0_guest_host_mask) |
                        (vmcs12->guest_cr0 & vmcs12->cr0_guest_host_mask);

-               if (!nested_cr0_valid(vmcs12, val))
+               if (!nested_cr0_valid(vcpu, val))
                        return 1;

                if (kvm_set_cr0(vcpu, val))
@@ -5953,9 +5991,6 @@ static __init int hardware_setup(void)
                kvm_x86_ops->sync_pir_to_irr = vmx_sync_pir_to_irr_dummy;
        }

-       if (nested)
-               nested_vmx_setup_ctls_msrs();
-
        vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
        vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
        vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
@@ -6957,6 +6992,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 /* Emulate the INVEPT instruction */
 static int handle_invept(struct kvm_vcpu *vcpu)
 {
+       struct vcpu_vmx *vmx = to_vmx(vcpu);
        u32 vmx_instruction_info, types;
        unsigned long type;
        gva_t gva;
@@ -6965,8 +7001,9 @@ static int handle_invept(struct kvm_vcpu *vcpu)
                u64 eptp, gpa;
        } operand;

-       if (!(nested_vmx_secondary_ctls_high & SECONDARY_EXEC_ENABLE_EPT) ||
-           !(nested_vmx_ept_caps & VMX_EPT_INVEPT_BIT)) {
+       if (!(vmx->nested.nested_vmx_secondary_ctls_high &
+             SECONDARY_EXEC_ENABLE_EPT) ||
+           !(vmx->nested.nested_vmx_ept_caps & VMX_EPT_INVEPT_BIT)) {
                kvm_queue_exception(vcpu, UD_VECTOR);
                return 1;
        }
@@ -6982,7 +7019,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
        vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
        type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);

-       types = (nested_vmx_ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
+       types = (vmx->nested.nested_vmx_ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;

        if (!(types & (1UL << type))) {
                nested_vmx_failValid(vcpu,
@@ -8108,6 +8145,9 @@ static struct kvm_vcpu *vmx_create_vcpu(struct
kvm *kvm, unsigned int id)
                        goto free_vmcs;
        }

+       if (nested)
+               nested_vmx_setup_ctls_msrs(vmx);
+
        vmx->nested.current_vmptr = -1ull;
        vmx->nested.current_vmcs12 = NULL;

@@ -8254,7 +8294,8 @@ static void nested_ept_init_mmu_context(struct
kvm_vcpu *vcpu)
 {
        WARN_ON(mmu_is_nested(vcpu));
        kvm_init_shadow_ept_mmu(vcpu,
-                       nested_vmx_ept_caps & VMX_EPT_EXECUTE_ONLY_BIT);
+                       to_vmx(vcpu)->nested.nested_vmx_ept_caps &
+                       VMX_EPT_EXECUTE_ONLY_BIT);
        vcpu->arch.mmu.set_cr3           = vmx_set_cr3;
        vcpu->arch.mmu.get_cr3           = nested_ept_get_cr3;
        vcpu->arch.mmu.inject_page_fault = nested_ept_inject_page_fault;
@@ -8974,18 +9015,20 @@ static int nested_vmx_run(struct kvm_vcpu
*vcpu, bool launch)
        }

        if (!vmx_control_verify(vmcs12->cpu_based_vm_exec_control,
-                               nested_vmx_true_procbased_ctls_low,
-                               nested_vmx_procbased_ctls_high) ||
+                               vmx->nested.nested_vmx_true_procbased_ctls_low,
+                               vmx->nested.nested_vmx_procbased_ctls_high) ||
            !vmx_control_verify(vmcs12->secondary_vm_exec_control,
-             nested_vmx_secondary_ctls_low, nested_vmx_secondary_ctls_high) ||
+                               vmx->nested.nested_vmx_secondary_ctls_low,
+                               vmx->nested.nested_vmx_secondary_ctls_high) ||
            !vmx_control_verify(vmcs12->pin_based_vm_exec_control,
-             nested_vmx_pinbased_ctls_low, nested_vmx_pinbased_ctls_high) ||
+                               vmx->nested.nested_vmx_pinbased_ctls_low,
+                               vmx->nested.nested_vmx_pinbased_ctls_high) ||
            !vmx_control_verify(vmcs12->vm_exit_controls,
-                               nested_vmx_true_exit_ctls_low,
-                               nested_vmx_exit_ctls_high) ||
+                               vmx->nested.nested_vmx_true_exit_ctls_low,
+                               vmx->nested.nested_vmx_exit_ctls_high) ||
            !vmx_control_verify(vmcs12->vm_entry_controls,
-                               nested_vmx_true_entry_ctls_low,
-                               nested_vmx_entry_ctls_high))
+                               vmx->nested.nested_vmx_true_entry_ctls_low,
+                               vmx->nested.nested_vmx_entry_ctls_high))
        {
                nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
                return 1;
@@ -8998,7 +9041,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu,
bool launch)
                return 1;
        }

-       if (!nested_cr0_valid(vmcs12, vmcs12->guest_cr0) ||
+       if (!nested_cr0_valid(vcpu, vmcs12->guest_cr0) ||
            ((vmcs12->guest_cr4 & VMXON_CR4_ALWAYSON) != VMXON_CR4_ALWAYSON)) {
                nested_vmx_entry_failure(vcpu, vmcs12,
                        EXIT_REASON_INVALID_STATE, ENTRY_FAIL_DEFAULT);
--
1.7.1
