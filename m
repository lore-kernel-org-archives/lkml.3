Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbaKROzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:55:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbaKROJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 105/206] KVM: x86: Check non-canonical addresses upon WRMSR
Date: Tue, 18 Nov 2014 15:07:40 +0100
Message-Id: <7e60cb9b5f7ad5a47404db9e7a974ab82a054544.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 854e8bb1aa06c578c2c9145fa6bfe3680ef63b23 upstream.

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

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/kvm_host.h | 14 ++++++++++++++
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx.c              |  2 +-
 arch/x86/kvm/x86.c              | 27 ++++++++++++++++++++++++++-
 4 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7cd6e5af871e..7cb77dd749df 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -974,6 +974,20 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
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
index 612c717747dd..8466c33e5f53 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3204,7 +3204,7 @@ static int wrmsr_interception(struct vcpu_svm *svm)
 	msr.host_initiated = false;
 
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
-	if (svm_set_msr(&svm->vcpu, &msr)) {
+	if (kvm_set_msr(&svm->vcpu, &msr)) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(&svm->vcpu, 0);
 	} else {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f6e13e6bc025..87e910934286 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5116,7 +5116,7 @@ static int handle_wrmsr(struct kvm_vcpu *vcpu)
 	msr.data = data;
 	msr.index = ecx;
 	msr.host_initiated = false;
-	if (vmx_set_msr(vcpu, &msr) != 0) {
+	if (kvm_set_msr(vcpu, &msr) != 0) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c969e93c208c..590fd966b37a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -915,7 +915,6 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
-
 /*
  * Writes msr value into into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -923,8 +922,34 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
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
2.1.3

