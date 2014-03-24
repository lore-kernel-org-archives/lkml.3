Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaCXKyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:54:45 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53258 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaCXKyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:54:43 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: robert.hu@intel.com, jinsong.liu@intel.com, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: handle missing MPX in nested virtualization
Date: Mon, 24 Mar 2014 11:54:35 +0100
Message-Id: <1395658475-1976-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing nested virtualization, we may be able to read BNDCFGS but
still not be allowed to write to GUEST_BNDCFGS in the VMCS.  Guard
writes to the field with vmx_mpx_supported(), and similarly hide the
MSR from userspace if the processor does not support the field.

We could work around this with the generic MSR save/load machinery,
but there is only a limited number of MSR save/load slots and it is
not really worthwhile to waste one for a scenario that should not
happen except in the nested virtualization case.

Based on a patch from Liu Jinsong, who reported it can also fix
problems with buggy VMX microcode.

Reported-by: Robert Hu <robert.hu@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c |  5 ++---
 arch/x86/kvm/svm.c   |  6 ++++++
 arch/x86/kvm/vmx.c   |  5 +++++
 arch/x86/kvm/x86.c   | 17 +++++++++++++++++
 4 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 18aefb4d0927..64fae65730f3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -47,7 +47,7 @@ u64 kvm_supported_xcr0(void)
 {
 	u64 xcr0 = KVM_SUPPORTED_XCR0 & host_xcr0;
 
-	if (!kvm_x86_ops->mpx_supported || !kvm_x86_ops->mpx_supported())
+	if (!kvm_x86_ops->mpx_supported())
 		xcr0 &= ~(XSTATE_BNDREGS | XSTATE_BNDCSR);
 
 	return xcr0;
@@ -259,8 +259,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 #endif
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
 	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
-	unsigned f_mpx = kvm_x86_ops->mpx_supported ?
-			 (kvm_x86_ops->mpx_supported() ? F(MPX) : 0) : 0;
+	unsigned f_mpx = kvm_x86_ops->mpx_supported() ? F(MPX) : 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_supported_word0_x86_features =
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a449c3d76cba..2136cb6ab132 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4089,6 +4089,11 @@ static bool svm_invpcid_supported(void)
 	return false;
 }
 
+static bool svm_mpx_supported(void)
+{
+	return false;
+}
+
 static bool svm_has_wbinvd_exit(void)
 {
 	return true;
@@ -4371,6 +4376,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.rdtscp_supported = svm_rdtscp_supported,
 	.invpcid_supported = svm_invpcid_supported,
+	.mpx_supported = svm_mpx_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c95bea17fc1e..1320e0f8e611 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -729,6 +729,7 @@ static unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu);
 static u64 construct_eptp(unsigned long root_hpa);
 static void kvm_cpu_vmxon(u64 addr);
 static void kvm_cpu_vmxoff(void);
+static bool vmx_mpx_supported(void);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 static void vmx_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
@@ -2501,6 +2502,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 		data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
 	case MSR_IA32_BNDCFGS:
+		if (!vmx_mpx_supported())
+			return 1;
 		data = vmcs_read64(GUEST_BNDCFGS);
 		break;
 	case MSR_IA32_FEATURE_CONTROL:
@@ -2572,6 +2575,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_BNDCFGS:
+		if (!vmx_mpx_supported())
+			return 1;
 		vmcs_write64(GUEST_BNDCFGS, data);
 		break;
 	case MSR_IA32_TSC:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f5fb4535f9c..aa986959f237 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3937,6 +3937,23 @@ static void kvm_init_msr_list(void)
 	for (i = j = KVM_SAVE_MSRS_BEGIN; i < ARRAY_SIZE(msrs_to_save); i++) {
 		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
 			continue;
+
+		/*
+		 * Even MSRs that are valid in the host may not be exposed
+		 * to the guests in some cases.  We could work around this
+		 * in VMX with the generic MSR save/load machinery, but it
+		 * is not really worthwhile since it will really only
+		 * happen with nested virtualization.
+		 */
+		switch (msrs_to_save[i]) {
+		case MSR_IA32_BNDCFGS:
+			if (!kvm_x86_ops->mpx_supported())
+				continue;
+			break;
+		default:
+			break;
+		}
+
 		if (j < i)
 			msrs_to_save[j] = msrs_to_save[i];
 		j++;
-- 
1.8.3.1

