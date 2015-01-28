Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbbA2BYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:24:54 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45802 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbbA2BYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:24:50 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 23:59:26 +0800
Message-ID: <CACzj_yWX6bvkqxuDz6uV2hhRszEhR=yzvVYAqgiZzjEdsLwBaw@mail.gmail.com>
Subject: [PATCH v4 4/6] KVM: nVMX: Enable nested apic register virtualization
To: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        =?UTF-8?B?6IyD5paH5LiA?= <fanwenyi0529@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can reduce apic register virtualization cost with this feature,
it is also a requirement for virtual interrupt delivery and posted
interrupt processing.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/kvm/vmx.c |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 55111ed..68783e0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1130,6 +1130,11 @@ static inline bool
nested_cpu_has_virt_x2apic_mode(struct vmcs12 *vmcs12)
        return nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
 }

+static inline bool nested_cpu_has_apic_reg_virt(struct vmcs12 *vmcs12)
+{
+       return nested_cpu_has2(vmcs12, SECONDARY_EXEC_APIC_REGISTER_VIRT);
+}
+
 static inline bool is_exception(u32 intr_info)
 {
        return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
@@ -2423,6 +2428,7 @@ static void nested_vmx_setup_ctls_msrs(struct
vcpu_vmx *vmx)
        vmx->nested.nested_vmx_secondary_ctls_high &=
                SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
                SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
+               SECONDARY_EXEC_APIC_REGISTER_VIRT |
                SECONDARY_EXEC_WBINVD_EXITING |
                SECONDARY_EXEC_XSAVES;

@@ -8443,6 +8449,7 @@ static int
nested_vmx_check_msr_bitmap_controls(struct kvm_vcpu *vcpu,
 static inline bool nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
                                               struct vmcs12 *vmcs12)
 {
+       int msr;
        struct page *page;
        unsigned long *msr_bitmap;

@@ -8462,16 +8469,35 @@ static inline bool
nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
        }

        if (nested_cpu_has_virt_x2apic_mode(vmcs12)) {
+               if (nested_cpu_has_apic_reg_virt(vmcs12))
+                       for (msr = 0x800; msr <= 0x8ff; msr++)
+                               nested_vmx_disable_intercept_for_msr(
+                                       msr_bitmap,
+                                       vmx_msr_bitmap_nested,
+                                       msr, MSR_TYPE_R);
                /* TPR is allowed */
                nested_vmx_disable_intercept_for_msr(msr_bitmap,
                                vmx_msr_bitmap_nested,
                                APIC_BASE_MSR + (APIC_TASKPRI >> 4),
                                MSR_TYPE_R | MSR_TYPE_W);
-       } else
+       } else {
+               /*
+                * Enable reading intercept of all the x2apic
+                * MSRs. We should not rely on vmcs12 to do any
+                * optimizations here, it may have been modified
+                * by L1.
+                */
+               for (msr = 0x800; msr <= 0x8ff; msr++)
+                       __vmx_enable_intercept_for_msr(
+                               vmx_msr_bitmap_nested,
+                               msr,
+                               MSR_TYPE_R);
+
                __vmx_enable_intercept_for_msr(
                                vmx_msr_bitmap_nested,
                                APIC_BASE_MSR + (APIC_TASKPRI >> 4),
-                               MSR_TYPE_R | MSR_TYPE_W);
+                               MSR_TYPE_W);
+       }
        kunmap(page);
        nested_release_page_clean(page);

@@ -8481,14 +8507,16 @@ static inline bool
nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
                                           struct vmcs12 *vmcs12)
 {
-       if (!nested_cpu_has_virt_x2apic_mode(vmcs12))
+       if (!nested_cpu_has_virt_x2apic_mode(vmcs12) &&
+           !nested_cpu_has_apic_reg_virt(vmcs12))
                return 0;

        /*
         * If virtualize x2apic mode is enabled,
         * virtualize apic access must be disabled.
         */
-       if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
+       if (nested_cpu_has_virt_x2apic_mode(vmcs12) &&
+           nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
                return -EINVAL;

        /* tpr shadow is needed by all apicv features. */
--
1.7.1
