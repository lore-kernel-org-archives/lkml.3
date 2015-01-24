Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbbAXKXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 05:23:09 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47740 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbbAXKXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 05:23:08 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Sat, 24 Jan 2015 18:22:45 +0800
Message-ID: <CACzj_yX7ezZ-=QShuXHRFX9udSSc9+2TnM+GEY+rLZu4YHY=5Q@mail.gmail.com>
Subject: [PATCH v3 4/6] KVM: nVMX: Enable nested apic register virtualization.
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

We can reduce apic register virtualization cost with this feature,
it is also a requirement for virtual interrupt delivery and posted
interrupt processing.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/kvm/vmx.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6ec0c2c..d57e370 100644
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

@@ -8435,6 +8441,7 @@ static int
nested_vmx_check_msr_bitmap_controls(struct kvm_vcpu *vcpu,
 static inline bool nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
                                               struct vmcs12 *vmcs12)
 {
+       int msr;
        struct page *page;
        unsigned long *msr_bitmap;

@@ -8455,12 +8462,19 @@ static inline bool
nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,

        memset(vmx_msr_bitmap_nested, 0xff, PAGE_SIZE);

-       if (nested_cpu_has_virt_x2apic_mode(vmcs12))
+       if (nested_cpu_has_virt_x2apic_mode(vmcs12)) {
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
+       }
        kunmap(page);
        nested_release_page_clean(page);

@@ -8478,12 +8492,14 @@ static inline int
nested_vmx_check_virt_x2apic(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
                                           struct vmcs12 *vmcs12)
 {
-       int r;
+       int r = 0;

-       if (!nested_cpu_has_virt_x2apic_mode(vmcs12))
+       if (!nested_cpu_has_virt_x2apic_mode(vmcs12) &&
+           !nested_cpu_has_apic_reg_virt(vmcs12))
                return 0;

-       r = nested_vmx_check_virt_x2apic(vcpu, vmcs12);
+       if (nested_cpu_has_virt_x2apic_mode(vmcs12))
+               r = nested_vmx_check_virt_x2apic(vcpu, vmcs12);
        if (r)
                goto fail;

--
1.7.1
