Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbbAPF4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 00:56:50 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:35248 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbbAPF4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 00:56:49 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Fri, 16 Jan 2015 13:56:27 +0800
Message-ID: <CACzj_yXGOKew-C5V75z7CCTvE0FKGhC9Oq9fURWJPkpRWVW=KA@mail.gmail.com>
Subject: [PATCH 3/5] KVM: nVMX: Enable nested apic register virtualization.
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

We can reduce apic register virtualization cost with this feature,
it is also a requirement for virtual interrupt delivery and posted
interrupt processing.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/kvm/vmx.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 10183ee..99e19bb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1139,6 +1139,11 @@ static inline bool
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
@@ -2432,6 +2437,7 @@ static void nested_vmx_setup_ctls_msrs(struct
vcpu_vmx *vmx)
        vmx->nested.nested_vmx_secondary_ctls_high &=
                SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
                SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
+               SECONDARY_EXEC_APIC_REGISTER_VIRT |
                SECONDARY_EXEC_WBINVD_EXITING |
                SECONDARY_EXEC_XSAVES;

@@ -8378,10 +8384,12 @@ static int
nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
 {
        int r;

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
