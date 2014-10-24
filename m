Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaJXPHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:07:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296AbaJXPHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:07:35 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Nadav Amit <namit@cs.technion.ac.il>, stable@vger.kernel.org
Subject: [PATCH 01/14] KVM: x86: Check non-canonical addresses upon WRMSR
Date: Fri, 24 Oct 2014 17:07:12 +0200
Message-Id: <1414163245-18555-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

Upon WRMSR, the CPU should inject #GP if a non-canonical value (address) is
written to certain MSRs. The behavior is "almost" identical for AMD and Intel
(ignoring MSRs that are not implemented in either architecture since they would
anyhow #GP). However, IA32_SYSENTER_ESP and IA32_SYSENTER_EIP cause #GP if
non-canonical address is written on Intel but not on AMD (which ignores the top
32-bits).

Accordingly, this patch injects a #GP on the MSRs which behave identically on
Intel and AMD.  To eliminate the differences between the architecutres, the
value which is written to IA32_SYSENTER_ESP and IA32_SYSENTER_EIP is turned to
canonical value before writing instead of injecting a #GP.

Some references from Intel and AMD manuals:

According to Intel SDM description of WRMSR instruction #GP is expected on
WRMSR "If the source register contains a non-canonical address and ECX
specifies one of the following MSRs: IA32_DS_AREA, IA32_FS_BASE, IA32_GS_BASE,
IA32_KERNEL_GS_BASE, IA32_LSTAR, IA32_SYSENTER_EIP, IA32_SYSENTER_ESP."

According to AMD manual instruction manual:
LSTAR/CSTAR (SYSCALL): "The WRMSR instruction loads the target RIP into the
LSTAR and CSTAR registers.  If an RIP written by WRMSR is not in canonical
form, a general-protection exception (#GP) occurs."
IA32_GS_BASE and IA32_FS_BASE (WRFSBASE/WRGSBASE): "The address written to the
base field must be in canonical form or a #GP fault will occur."
IA32_KERNEL_GS_BASE (SWAPGS): "The address stored in the KernelGSbase MSR must
be in canonical form."

This patch fixes CVE-2014-3610.

Cc: stable@vger.kernel.org
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 14 ++++++++++++++
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx.c              |  2 +-
 arch/x86/kvm/x86.c              | 27 ++++++++++++++++++++++++++-
 4 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7d603a71ab3a..ccc94de4ac49 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -989,6 +989,20 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 }
 
+static inline u64 get_canonical(u64 la)
+{
+	return ((int64_t)la << 16) >> 16;
+}
+
+static inline bool is_noncanonical_address(u64 la)
+{
+#ifdef CONFIG_X86_64
+	return get_canonical(la) != la;
+#else
+	return false;
+#endif
+}
+
 #define TSS_IOPB_BASE_OFFSET 0x66
 #define TSS_BASE_SIZE 0x68
 #define TSS_IOPB_SIZE (65536 / 8)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 65510f624dfe..00bed2c5e948 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3251,7 +3251,7 @@ static int wrmsr_interception(struct vcpu_svm *svm)
 	msr.host_initiated = false;
 
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
-	if (svm_set_msr(&svm->vcpu, &msr)) {
+	if (kvm_set_msr(&svm->vcpu, &msr)) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(&svm->vcpu, 0);
 	} else {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0acac81f198b..148020a7dd98 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5291,7 +5291,7 @@ static int handle_wrmsr(struct kvm_vcpu *vcpu)
 	msr.data = data;
 	msr.index = ecx;
 	msr.host_initiated = false;
-	if (vmx_set_msr(vcpu, &msr) != 0) {
+	if (kvm_set_msr(vcpu, &msr) != 0) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34c8f94331f8..5a7195573a32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -987,7 +987,6 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
-
 /*
  * Writes msr value into into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -995,8 +994,34 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
  */
 int kvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
+	switch (msr->index) {
+	case MSR_FS_BASE:
+	case MSR_GS_BASE:
+	case MSR_KERNEL_GS_BASE:
+	case MSR_CSTAR:
+	case MSR_LSTAR:
+		if (is_noncanonical_address(msr->data))
+			return 1;
+		break;
+	case MSR_IA32_SYSENTER_EIP:
+	case MSR_IA32_SYSENTER_ESP:
+		/*
+		 * IA32_SYSENTER_ESP and IA32_SYSENTER_EIP cause #GP if
+		 * non-canonical address is written on Intel but not on
+		 * AMD (which ignores the top 32-bits, because it does
+		 * not implement 64-bit SYSENTER).
+		 *
+		 * 64-bit code should hence be able to write a non-canonical
+		 * value on AMD.  Making the address canonical ensures that
+		 * vmentry does not fail on Intel after writing a non-canonical
+		 * value, and that something deterministic happens if the guest
+		 * invokes 64-bit SYSENTER.
+		 */
+		msr->data = get_canonical(msr->data);
+	}
 	return kvm_x86_ops->set_msr(vcpu, msr);
 }
+EXPORT_SYMBOL_GPL(kvm_set_msr);
 
 /*
  * Adapt set_msr() to msr_io()'s calling convention
-- 
1.8.3.1


