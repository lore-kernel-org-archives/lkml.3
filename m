Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaLCBCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:02:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:64640 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaLCBCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:02:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="492634594"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v4 1/3] kvm: vmx: Intel XSAVES vmx and msr handle
Date: Wed,  3 Dec 2014 09:01:52 +0800
Message-Id: <1417568514-7180-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417568514-7180-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1417568514-7180-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel xsaves vmx and msr handle.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/asm/vmx.h      |  3 +++
 arch/x86/include/uapi/asm/vmx.h |  6 +++++-
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx.c              | 31 ++++++++++++++++++++++++++++++-
 5 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2896dbc..0c4c88c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -362,6 +362,7 @@ struct kvm_vcpu_arch {
 	int mp_state;
 	u64 ia32_misc_enable_msr;
 	bool tpr_access_reporting;
+	u64 ia32_xss;
 
 	/*
 	 * Paging state of the vcpu
@@ -771,6 +772,7 @@ struct kvm_x86_ops {
 			       enum x86_intercept_stage stage);
 	void (*handle_external_intr)(struct kvm_vcpu *vcpu);
 	bool (*mpx_supported)(void);
+	bool (*xsaves_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index bcbfade..45afaee 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -69,6 +69,7 @@
 #define SECONDARY_EXEC_PAUSE_LOOP_EXITING	0x00000400
 #define SECONDARY_EXEC_ENABLE_INVPCID		0x00001000
 #define SECONDARY_EXEC_SHADOW_VMCS              0x00004000
+#define SECONDARY_EXEC_XSAVES			0x00100000
 
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
@@ -159,6 +160,8 @@ enum vmcs_field {
 	EOI_EXIT_BITMAP3_HIGH           = 0x00002023,
 	VMREAD_BITMAP                   = 0x00002026,
 	VMWRITE_BITMAP                  = 0x00002028,
+	XSS_EXIT_BITMAP                 = 0x0000202C,
+	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 990a2fe..b813bf9 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -72,6 +72,8 @@
 #define EXIT_REASON_XSETBV              55
 #define EXIT_REASON_APIC_WRITE          56
 #define EXIT_REASON_INVPCID             58
+#define EXIT_REASON_XSAVES              63
+#define EXIT_REASON_XRSTORS             64
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -116,6 +118,8 @@
 	{ EXIT_REASON_INVALID_STATE,         "INVALID_STATE" }, \
 	{ EXIT_REASON_INVD,                  "INVD" }, \
 	{ EXIT_REASON_INVVPID,               "INVVPID" }, \
-	{ EXIT_REASON_INVPCID,               "INVPCID" }
+	{ EXIT_REASON_INVPCID,               "INVPCID" }, \
+	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
+	{ EXIT_REASON_XRSTORS,               "XRSTORS" }
 
 #endif /* _UAPIVMX_H */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6b411ad..41dd038 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4127,6 +4127,11 @@ static bool svm_mpx_supported(void)
 	return false;
 }
 
+static bool svm_xsaves_supported(void)
+{
+	return false;
+}
+
 static bool svm_has_wbinvd_exit(void)
 {
 	return true;
@@ -4414,6 +4419,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.rdtscp_supported = svm_rdtscp_supported,
 	.invpcid_supported = svm_invpcid_supported,
 	.mpx_supported = svm_mpx_supported,
+	.xsaves_supported = svm_xsaves_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6a951d8..12915f1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -761,6 +761,7 @@ static u64 construct_eptp(unsigned long root_hpa);
 static void kvm_cpu_vmxon(u64 addr);
 static void kvm_cpu_vmxoff(void);
 static bool vmx_mpx_supported(void);
+static bool vmx_xsaves_supported(void);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 static void vmx_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
@@ -2895,7 +2896,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 			SECONDARY_EXEC_ENABLE_INVPCID |
 			SECONDARY_EXEC_APIC_REGISTER_VIRT |
 			SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
-			SECONDARY_EXEC_SHADOW_VMCS;
+			SECONDARY_EXEC_SHADOW_VMCS |
+			SECONDARY_EXEC_XSAVES;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
@@ -4337,6 +4339,7 @@ static void ept_set_mmio_spte_mask(void)
 	kvm_mmu_set_mmio_spte_mask((0x3ull << 62) | 0x6ull);
 }
 
+#define VMX_XSS_EXIT_BITMAP 0
 /*
  * Sets up the vmcs for emulated real mode.
  */
@@ -4446,6 +4449,9 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
 	set_cr4_guest_host_mask(vmx);
 
+	if (vmx_xsaves_supported())
+		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
+
 	return 0;
 }
 
@@ -5334,6 +5340,20 @@ static int handle_xsetbv(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_xsaves(struct kvm_vcpu *vcpu)
+{
+	skip_emulated_instruction(vcpu);
+	WARN(1, "this should never happen\n");
+	return 1;
+}
+
+static int handle_xrstors(struct kvm_vcpu *vcpu)
+{
+	skip_emulated_instruction(vcpu);
+	WARN(1, "this should never happen\n");
+	return 1;
+}
+
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
 	if (likely(fasteoi)) {
@@ -6951,6 +6971,8 @@ static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_monitor,
 	[EXIT_REASON_INVEPT]                  = handle_invept,
 	[EXIT_REASON_INVVPID]                 = handle_invvpid,
+	[EXIT_REASON_XSAVES]                  = handle_xsaves,
+	[EXIT_REASON_XRSTORS]                 = handle_xrstors,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -7553,6 +7575,12 @@ static bool vmx_mpx_supported(void)
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
 }
 
+static bool vmx_xsaves_supported(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_XSAVES;
+}
+
 static void vmx_recover_nmi_blocking(struct vcpu_vmx *vmx)
 {
 	u32 exit_intr_info;
@@ -9329,6 +9357,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.check_intercept = vmx_check_intercept,
 	.handle_external_intr = vmx_handle_external_intr,
 	.mpx_supported = vmx_mpx_supported,
+	.xsaves_supported = vmx_xsaves_supported,
 
 	.check_nested_events = vmx_check_nested_events,
 
-- 
1.9.1

