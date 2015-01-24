Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbbAXKVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 05:21:40 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:46106 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbbAXKVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 05:21:38 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Sat, 24 Jan 2015 18:21:16 +0800
Message-ID: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com>
Subject: [PATCH v3 2/6] KVM: nVMX: Enable nested virtualize x2apic mode.
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

When L2 is using x2apic, we can use virtualize x2apic mode to
gain higher performance, especially in apicv case.

This patch also introduces nested_vmx_check_apicv_controls
for the nested apicv patches.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/kvm/vmx.c |  121 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 36d0724..4d8939d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1108,6 +1108,11 @@ static inline bool nested_cpu_has_xsaves(struct
vmcs12 *vmcs12)
                vmx_xsaves_supported();
 }

+static inline bool nested_cpu_has_virt_x2apic_mode(struct vmcs12 *vmcs12)
+{
+       return nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
+}
+
 static inline bool is_exception(u32 intr_info)
 {
        return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
@@ -2395,6 +2400,7 @@ static __init void nested_vmx_setup_ctls_msrs(void)
        nested_vmx_secondary_ctls_low = 0;
        nested_vmx_secondary_ctls_high &=
                SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
+               SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
                SECONDARY_EXEC_WBINVD_EXITING |
                SECONDARY_EXEC_XSAVES;

@@ -4155,6 +4161,50 @@ static void
__vmx_enable_intercept_for_msr(unsigned long *msr_bitmap,
        }
 }

+/*
+ * If a msr is allowed by L0, we should check whether it is allowed by L1.
+ * The corresponding bit will be cleared unless both of L0 and L1 allow it.
+ */
+static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
+                                              unsigned long *msr_bitmap_nested,
+                                              u32 msr, int type)
+{
+       int f = sizeof(unsigned long);
+
+       if (!cpu_has_vmx_msr_bitmap())
+               return;
+
+       /*
+        * See Intel PRM Vol. 3, 20.6.9 (MSR-Bitmap Address). Early manuals
+        * have the write-low and read-high bitmap offsets the wrong way round.
+        * We can control MSRs 0x00000000-0x00001fff and 0xc0000000-0xc0001fff.
+        */
+       if (msr <= 0x1fff) {
+               if (type & MSR_TYPE_R &&
+                  !test_bit(msr, msr_bitmap_l1 + 0x000 / f))
+                       /* read-low */
+                       __clear_bit(msr, msr_bitmap_nested + 0x000 / f);
+
+               if (type & MSR_TYPE_W &&
+                  !test_bit(msr, msr_bitmap_l1 + 0x800 / f))
+                       /* write-low */
+                       __clear_bit(msr, msr_bitmap_nested + 0x800 / f);
+
+       } else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
+               msr &= 0x1fff;
+               if (type & MSR_TYPE_R &&
+                  !test_bit(msr, msr_bitmap_l1 + 0x400 / f))
+                       /* read-high */
+                       __clear_bit(msr, msr_bitmap_nested + 0x400 / f);
+
+               if (type & MSR_TYPE_W &&
+                  !test_bit(msr, msr_bitmap_l1 + 0xc00 / f))
+                       /* write-high */
+                       __clear_bit(msr, msr_bitmap_nested + 0xc00 / f);
+
+       }
+}
+
 static void vmx_disable_intercept_for_msr(u32 msr, bool longmode_only)
 {
        if (!longmode_only)
@@ -8344,7 +8394,68 @@ static int
nested_vmx_check_msr_bitmap_controls(struct kvm_vcpu *vcpu,
 static inline bool nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
                                               struct vmcs12 *vmcs12)
 {
-       return false;
+       struct page *page;
+       unsigned long *msr_bitmap;
+
+       if (!nested_cpu_has_virt_x2apic_mode(vmcs12))
+               return false;
+
+       page = nested_get_page(vcpu, vmcs12->msr_bitmap);
+       if (!page) {
+               WARN_ON(1);
+               return false;
+       }
+       msr_bitmap = (unsigned long *)kmap(page);
+       if (!msr_bitmap) {
+               nested_release_page_clean(page);
+               WARN_ON(1);
+               return false;
+       }
+
+       memset(vmx_msr_bitmap_nested, 0xff, PAGE_SIZE);
+
+       if (nested_cpu_has_virt_x2apic_mode(vmcs12))
+               /* TPR is allowed */
+               nested_vmx_disable_intercept_for_msr(msr_bitmap,
+                               vmx_msr_bitmap_nested,
+                               APIC_BASE_MSR + (APIC_TASKPRI >> 4),
+                               MSR_TYPE_R | MSR_TYPE_W);
+       kunmap(page);
+       nested_release_page_clean(page);
+
+       return true;
+}
+
+static inline int nested_vmx_check_virt_x2apic(struct kvm_vcpu *vcpu,
+                                              struct vmcs12 *vmcs12)
+{
+       if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
+               return -EINVAL;
+       return 0;
+}
+
+static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
+                                          struct vmcs12 *vmcs12)
+{
+       int r;
+
+       if (!nested_cpu_has_virt_x2apic_mode(vmcs12))
+               return 0;
+
+       r = nested_vmx_check_virt_x2apic(vcpu, vmcs12);
+       if (r)
+               goto fail;
+
+       /* tpr shadow is needed by all apicv features. */
+       if (!nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
+               r = -EINVAL;
+               goto fail;
+       }
+
+       return 0;
+
+fail:
+       return r;
 }

 static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
@@ -8640,7 +8751,8 @@ static void prepare_vmcs02(struct kvm_vcpu
*vcpu, struct vmcs12 *vmcs12)
                        else
                                vmcs_write64(APIC_ACCESS_ADDR,
                                  page_to_phys(vmx->nested.apic_access_page));
-               } else if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
+               } else if (!(nested_cpu_has_virt_x2apic_mode(vmcs12)) &&
+                           (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm))) {
                        exec_control |=
                                SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
                        kvm_vcpu_reload_apic_access_page(vcpu);
@@ -8851,6 +8963,11 @@ static int nested_vmx_run(struct kvm_vcpu
*vcpu, bool launch)
                return 1;
        }

+       if (nested_vmx_check_apicv_controls(vcpu, vmcs12)) {
+               nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+               return 1;
+       }
+
        if (nested_vmx_check_msr_switch_controls(vcpu, vmcs12)) {
                nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
                return 1;
--
1.7.1
