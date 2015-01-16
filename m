Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbbAPFzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 00:55:24 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42056 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbbAPFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 00:55:23 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Fri, 16 Jan 2015 13:55:01 +0800
Message-ID: <CACzj_yV+FTFVevjGbJ3Ord7CPbCw7kPMLhQxRaCjZe0uXkYmew@mail.gmail.com>
Subject: [PATCH 2/5] KVM: nVMX: Enable nested virtualize x2apic mode.
To: Paolo Bonzini <pbonzini@redhat.com>, gleb@kernel.org,
        yang.z.zhang@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        =?UTF-8?B?6IyD5paH5LiA?= <fanwenyi0529@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When L2 is using x2apic, we can use virtualize x2apic mode to
gain higher performance.

This patch also introduces nested_vmx_check_apicv_controls
for the nested apicv patches.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/kvm/vmx.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 954dd54..10183ee 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1134,6 +1134,11 @@ static inline bool nested_cpu_has_xsaves(struct
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
@@ -2426,6 +2431,7 @@ static void nested_vmx_setup_ctls_msrs(struct
vcpu_vmx *vmx)
        vmx->nested.nested_vmx_secondary_ctls_low = 0;
        vmx->nested.nested_vmx_secondary_ctls_high &=
                SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
+               SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
                SECONDARY_EXEC_WBINVD_EXITING |
                SECONDARY_EXEC_XSAVES;

@@ -7333,6 +7339,9 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
        case EXIT_REASON_APIC_ACCESS:
                return nested_cpu_has2(vmcs12,
                        SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
+       case EXIT_REASON_APIC_WRITE:
+               /* apic_write should exit unconditionally. */
+               return 1;
        case EXIT_REASON_EPT_VIOLATION:
                /*
                 * L0 always deals with the EPT violation. If nested EPT is
@@ -8356,6 +8365,38 @@ static void vmx_start_preemption_timer(struct
kvm_vcpu *vcpu)
                      ns_to_ktime(preemption_timeout), HRTIMER_MODE_REL);
 }

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
+}
+
 static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
                                       unsigned long count_field,
                                       unsigned long addr_field,
@@ -8649,7 +8690,8 @@ static void prepare_vmcs02(struct kvm_vcpu
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
@@ -8856,6 +8898,11 @@ static int nested_vmx_run(struct kvm_vcpu
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
