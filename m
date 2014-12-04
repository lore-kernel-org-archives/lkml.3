Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaLDIYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:24:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:14908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaLDIYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:24:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,514,1413270000"; 
   d="scan'208";a="642209481"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 1/4] kvm: vmx: add nested virtualization support for xsaves
Date: Thu,  4 Dec 2014 16:24:25 +0800
Message-Id: <1417681468-7165-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nested virtualization support for xsaves.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/vmx.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6e3a448..e5bc349 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -216,6 +216,7 @@ struct __packed vmcs12 {
 	u64 virtual_apic_page_addr;
 	u64 apic_access_addr;
 	u64 ept_pointer;
+	u64 xss_exit_bitmap;
 	u64 guest_physical_address;
 	u64 vmcs_link_pointer;
 	u64 guest_ia32_debugctl;
@@ -618,6 +619,7 @@ static const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD64(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr),
 	FIELD64(APIC_ACCESS_ADDR, apic_access_addr),
 	FIELD64(EPT_POINTER, ept_pointer),
+	FIELD64(XSS_EXIT_BITMAP, xss_exit_bitmap),
 	FIELD64(GUEST_PHYSICAL_ADDRESS, guest_physical_address),
 	FIELD64(VMCS_LINK_POINTER, vmcs_link_pointer),
 	FIELD64(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl),
@@ -1104,6 +1106,12 @@ static inline int nested_cpu_has_ept(struct vmcs12 *vmcs12)
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_EPT);
 }
 
+static inline bool nested_cpu_has_xsaves(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES) &&
+		vmx_xsaves_supported();
+}
+
 static inline bool is_exception(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
@@ -2392,7 +2400,8 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 	nested_vmx_secondary_ctls_high &=
 		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
 		SECONDARY_EXEC_UNRESTRICTED_GUEST |
-		SECONDARY_EXEC_WBINVD_EXITING;
+		SECONDARY_EXEC_WBINVD_EXITING |
+		SECONDARY_EXEC_XSAVES;
 
 	if (enable_ept) {
 		/* nested EPT: emulate EPT also to L1 */
@@ -7285,6 +7294,8 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
 		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_WBINVD_EXITING);
 	case EXIT_REASON_XSETBV:
 		return 1;
+	case EXIT_REASON_XSAVES: case EXIT_REASON_XRSTORS:
+		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);
 	default:
 		return 1;
 	}
@@ -8341,6 +8352,8 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs_writel(GUEST_SYSENTER_ESP, vmcs12->guest_sysenter_esp);
 	vmcs_writel(GUEST_SYSENTER_EIP, vmcs12->guest_sysenter_eip);
 
+	if (nested_cpu_has_xsaves(vmcs12))
+		vmcs_write64(XSS_EXIT_BITMAP, vmcs12->xss_exit_bitmap);
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
 
 	exec_control = vmcs12->pin_based_vm_exec_control;
@@ -8981,6 +8994,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
 	if (vmx_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (nested_cpu_has_xsaves(vmcs12))
+		vmcs12->xss_exit_bitmap = vmcs_read64(XSS_EXIT_BITMAP);
 
 	/* update exit information fields: */
 
-- 
1.9.1

