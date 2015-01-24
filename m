Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbbAXKYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 05:24:54 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:51914 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbAXKYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 05:24:51 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Sat, 24 Jan 2015 18:24:29 +0800
Message-ID: <CACzj_yWZSJkfn0JAJr9w6hLWtMbr3PpHQVxH_GkwmY8g3x1x8w@mail.gmail.com>
Subject: [PATCH v3 6/6] KVM: nVMX: Enable nested posted interrupt processing.
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

If vcpu has a interrupt in vmx non-root mode, we will
kick that vcpu to inject interrupt timely. With posted
interrupt processing, the kick intr is not needed, and
interrupts are fully taken care of by hardware.

In nested vmx, this feature avoids much more vmexits
than non-nested vmx.

This patch use L0's POSTED_INTR_NV to avoid unexpected
interrupt if L1's vector is different with L0's. If vcpu
is in hardware's non-root mode, we use a physical ipi to
deliver posted interrupts, otherwise we will deliver that
interrupt to L1 and kick that vcpu out of nested
non-root mode.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/kvm/vmx.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5d8500c..4e4b64e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -215,6 +215,7 @@ struct __packed vmcs12 {
        u64 tsc_offset;
        u64 virtual_apic_page_addr;
        u64 apic_access_addr;
+       u64 posted_intr_desc_addr;
        u64 ept_pointer;
        u64 eoi_exit_bitmap0;
        u64 eoi_exit_bitmap1;
@@ -334,6 +335,7 @@ struct __packed vmcs12 {
        u32 vmx_preemption_timer_value;
        u32 padding32[7]; /* room for future expansion */
        u16 virtual_processor_id;
+       u16 posted_intr_nv;
        u16 guest_es_selector;
        u16 guest_cs_selector;
        u16 guest_ss_selector;
@@ -406,6 +408,8 @@ struct nested_vmx {
         */
        struct page *apic_access_page;
        struct page *virtual_apic_page;
+       struct page *pi_desc_page;
+       u16 posted_intr_nv;
        u64 msr_ia32_feature_control;

        struct hrtimer preemption_timer;
@@ -621,6 +625,7 @@ static int max_shadow_read_write_fields =

 static const unsigned short vmcs_field_to_offset_table[] = {
        FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
+       FIELD(POSTED_INTR_NV, posted_intr_nv),
        FIELD(GUEST_ES_SELECTOR, guest_es_selector),
        FIELD(GUEST_CS_SELECTOR, guest_cs_selector),
        FIELD(GUEST_SS_SELECTOR, guest_ss_selector),
@@ -646,6 +651,7 @@ static const unsigned short vmcs_field_to_offset_table[] = {
        FIELD64(TSC_OFFSET, tsc_offset),
        FIELD64(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr),
        FIELD64(APIC_ACCESS_ADDR, apic_access_addr),
+       FIELD64(POSTED_INTR_DESC_ADDR, posted_intr_desc_addr),
        FIELD64(EPT_POINTER, ept_pointer),
        FIELD64(EOI_EXIT_BITMAP0, eoi_exit_bitmap0),
        FIELD64(EOI_EXIT_BITMAP1, eoi_exit_bitmap1),
@@ -798,6 +804,7 @@ static void kvm_cpu_vmxon(u64 addr);
 static void kvm_cpu_vmxoff(void);
 static bool vmx_mpx_supported(void);
 static bool vmx_xsaves_supported(void);
+static int vmx_vm_has_apicv(struct kvm *kvm);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 static void vmx_set_segment(struct kvm_vcpu *vcpu,
                            struct kvm_segment *var, int seg);
@@ -1150,6 +1157,11 @@ static inline bool nested_cpu_has_vid(struct
vmcs12 *vmcs12)
        return nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 }

+static inline bool nested_cpu_has_posted_intr(struct vmcs12 *vmcs12)
+{
+       return vmcs12->pin_based_vm_exec_control & PIN_BASED_POSTED_INTR;
+}
+
 static inline bool is_exception(u32 intr_info)
 {
        return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
@@ -2353,6 +2365,9 @@ static void nested_vmx_setup_ctls_msrs(struct
vcpu_vmx *vmx)
        vmx->nested.nested_vmx_pinbased_ctls_high |=
                PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |
                PIN_BASED_VMX_PREEMPTION_TIMER;
+       if (vmx_vm_has_apicv(vmx->vcpu.kvm))
+               vmx->nested.nested_vmx_pinbased_ctls_high |=
+                       PIN_BASED_POSTED_INTR;

        /* exit controls */
        rdmsr(MSR_IA32_VMX_EXIT_CTLS,
@@ -4302,6 +4317,19 @@ static int vmx_vm_has_apicv(struct kvm *kvm)
        return enable_apicv && irqchip_in_kernel(kvm);
 }

+static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
+                                               int vector)
+{
+       if (is_guest_mode(vcpu) &&
+           vector == to_vmx(vcpu)->nested.posted_intr_nv &&
+           vcpu->mode == IN_GUEST_MODE) {
+               /* the PIR and ON have been set by L1. */
+               apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
+                               POSTED_INTR_VECTOR);
+               return 0;
+       }
+       return -1;
+}
 /*
  * Send interrupt to vcpu via posted interrupt way.
  * 1. If target vcpu is running(non-root mode), send posted interrupt
@@ -4314,6 +4342,10 @@ static void vmx_deliver_posted_interrupt(struct
kvm_vcpu *vcpu, int vector)
        struct vcpu_vmx *vmx = to_vmx(vcpu);
        int r;

+       r = vmx_deliver_nested_posted_interrupt(vcpu, vector);
+       if (!r)
+               return;
+
        if (pi_test_and_set_pir(vector, &vmx->pi_desc))
                return;

@@ -6553,6 +6585,7 @@ static inline void nested_release_vmcs12(struct
vcpu_vmx *vmx)
                vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
                vmcs_write64(VMCS_LINK_POINTER, -1ull);
        }
+       vmx->nested.posted_intr_nv = -1;
        kunmap(vmx->nested.current_vmcs12_page);
        nested_release_page(vmx->nested.current_vmcs12_page);
        vmx->nested.current_vmptr = -1ull;
@@ -6581,6 +6614,10 @@ static void free_nested(struct vcpu_vmx *vmx)
                nested_release_page(vmx->nested.virtual_apic_page);
                vmx->nested.virtual_apic_page = NULL;
        }
+       if (vmx->nested.pi_desc_page) {
+               nested_release_page(vmx->nested.pi_desc_page);
+               vmx->nested.pi_desc_page = NULL;
+       }

        nested_free_all_saved_vmcss(vmx);
 }
@@ -8174,6 +8211,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct
kvm *kvm, unsigned int id)
        if (nested)
                nested_vmx_setup_ctls_msrs(vmx);

+       vmx->nested.posted_intr_nv = -1;
        vmx->nested.current_vmptr = -1ull;
        vmx->nested.current_vmcs12 = NULL;

@@ -8407,6 +8445,19 @@ static bool nested_get_vmcs12_pages(struct
kvm_vcpu *vcpu,
                        return false;
        }

+       if (nested_cpu_has_posted_intr(vmcs12)) {
+               if (!IS_ALIGNED(vmcs12->posted_intr_desc_addr, 64))
+                       return false;
+
+               if (vmx->nested.pi_desc_page) { /* shouldn't happen */
+                       nested_release_page(vmx->nested.pi_desc_page);
+               }
+               vmx->nested.pi_desc_page =
+                       nested_get_page(vcpu, vmcs12->posted_intr_desc_addr);
+               if (!vmx->nested.pi_desc_page)
+                       return false;
+       }
+
        return true;
 }

@@ -8530,6 +8581,21 @@ static inline int nested_vmx_check_vid(struct
kvm_vcpu *vcpu,
        return 0;
 }

+static inline int nested_vmx_check_posted_intr(struct kvm_vcpu *vcpu,
+                                              struct vmcs12 *vmcs12)
+{
+       /*
+        * bits 15:8 should be zero in posted_intr_nv,
+        * the descriptor address has been already checked
+        * in nested_get_vmcs12_pages.
+        */
+       if (!nested_cpu_has_vid(vmcs12) ||
+           !nested_exit_intr_ack_set(vcpu) ||
+           vmcs12->posted_intr_nv & 0xff00)
+               return -EINVAL;
+       return 0;
+}
+
 static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
                                           struct vmcs12 *vmcs12)
 {
@@ -8537,13 +8603,16 @@ static int
nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,

        if (!nested_cpu_has_virt_x2apic_mode(vmcs12) &&
            !nested_cpu_has_apic_reg_virt(vmcs12) &&
-           !nested_cpu_has_vid(vmcs12))
+           !nested_cpu_has_vid(vmcs12) &&
+           !nested_cpu_has_posted_intr(vmcs12))
                return 0;

        if (nested_cpu_has_virt_x2apic_mode(vmcs12))
                r = nested_vmx_check_virt_x2apic(vcpu, vmcs12);
        if (nested_cpu_has_vid(vmcs12))
                r |= nested_vmx_check_vid(vcpu, vmcs12);
+       if (nested_cpu_has_posted_intr(vmcs12))
+               r |= nested_vmx_check_posted_intr(vcpu, vmcs12);

        if (r)
                goto fail;
@@ -8795,8 +8864,19 @@ static void prepare_vmcs02(struct kvm_vcpu
*vcpu, struct vmcs12 *vmcs12)

        exec_control = vmcs12->pin_based_vm_exec_control;
        exec_control |= vmcs_config.pin_based_exec_ctrl;
-       exec_control &= ~(PIN_BASED_VMX_PREEMPTION_TIMER |
-                          PIN_BASED_POSTED_INTR);
+       exec_control &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
+
+       if (nested_cpu_has_posted_intr(vmcs12)) {
+               /* Note that we use L0's vector to avoid unexpected intr. */
+               vmx->nested.posted_intr_nv = vmcs12->posted_intr_nv;
+               vmcs_write64(POSTED_INTR_NV, POSTED_INTR_VECTOR);
+               vmcs_write64(POSTED_INTR_DESC_ADDR,
+                       page_to_phys(vmx->nested.pi_desc_page) +
+                       (unsigned long)(vmcs12->posted_intr_desc_addr &
+                       (PAGE_SIZE - 1)));
+       } else
+               exec_control &= ~PIN_BASED_POSTED_INTR;
+
        vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, exec_control);

        vmx->nested.preemption_timer_expired = false;
@@ -9712,6 +9792,10 @@ static void nested_vmx_vmexit(struct kvm_vcpu
*vcpu, u32 exit_reason,
                nested_release_page(vmx->nested.virtual_apic_page);
                vmx->nested.virtual_apic_page = NULL;
        }
+       if (vmx->nested.pi_desc_page) {
+               nested_release_page(vmx->nested.pi_desc_page);
+               vmx->nested.pi_desc_page = NULL;
+       }

        /*
         * We are now running in L2, mmu_notifier will force to reload the
--
1.7.1
