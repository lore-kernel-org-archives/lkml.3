Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaLDP5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:57:34 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:46665 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaLDP5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:31 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 4/9] kvm: x86: Add kvm_x86_ops hook that enables XSAVES for guest
Date: Thu,  4 Dec 2014 16:57:09 +0100
Message-Id: <1417708634-24333-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <wanpeng.li@linux.intel.com>

Expose the XSAVES feature to the guest if the kvm_x86_ops say it is
available.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/include/asm/vmx.h      | 1 +
 arch/x86/kvm/cpuid.c            | 3 ++-
 arch/x86/kvm/svm.c              | 6 ++++++
 arch/x86/kvm/vmx.c              | 7 +++++++
 5 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2896dbc18987..0271f6bcf123 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -771,6 +771,7 @@ struct kvm_x86_ops {
 			       enum x86_intercept_stage stage);
 	void (*handle_external_intr)(struct kvm_vcpu *vcpu);
 	bool (*mpx_supported)(void);
+	bool (*xsaves_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index bcbfade26d8d..08dc770bd340 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -69,6 +69,7 @@
 #define SECONDARY_EXEC_PAUSE_LOOP_EXITING	0x00000400
 #define SECONDARY_EXEC_ENABLE_INVPCID		0x00001000
 #define SECONDARY_EXEC_SHADOW_VMCS              0x00004000
+#define SECONDARY_EXEC_XSAVES			0x00100000
 
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 11f09a2b31a0..e24df01ab118 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -267,6 +267,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
 	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
 	unsigned f_mpx = kvm_x86_ops->mpx_supported() ? F(MPX) : 0;
+	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_supported_word0_x86_features =
@@ -322,7 +323,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	/* cpuid 0xD.1.eax */
 	const u32 kvm_supported_word10_x86_features =
-		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
+		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6b411add23b8..41dd0387cccb 100644
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
index 6a951d823c82..dd4fa461454a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7553,6 +7553,12 @@ static bool vmx_mpx_supported(void)
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
@@ -9329,6 +9335,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.check_intercept = vmx_check_intercept,
 	.handle_external_intr = vmx_handle_external_intr,
 	.mpx_supported = vmx_mpx_supported,
+	.xsaves_supported = vmx_xsaves_supported,
 
 	.check_nested_events = vmx_check_nested_events,
 
-- 
1.8.3.1


