Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaKAWxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:53:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60113 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbaKAWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paolo Bonzini" <pbonzini@redhat.com>,
        "Nadav Amit" <namit@cs.technion.ac.il>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.634207762@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 085/102] KVM: x86: Check non-canonical addresses upon
 WRMSR
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

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
[bwh: Backported to 3.2:
 - The various set_msr() functions all separate msr_index and data parameters]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/kvm_host.h | 14 ++++++++++++++
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx.c              |  2 +-
 arch/x86/kvm/x86.c              | 27 ++++++++++++++++++++++++++-
 4 files changed, 42 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -821,6 +821,20 @@ static inline void kvm_inject_gp(struct
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
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3109,7 +3109,7 @@ static int wrmsr_interception(struct vcp
 
 
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
-	if (svm_set_msr(&svm->vcpu, ecx, data)) {
+	if (kvm_set_msr(&svm->vcpu, ecx, data)) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(&svm->vcpu, 0);
 	} else {
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4544,7 +4544,7 @@ static int handle_wrmsr(struct kvm_vcpu
 	u64 data = (vcpu->arch.regs[VCPU_REGS_RAX] & -1u)
 		| ((u64)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 
-	if (vmx_set_msr(vcpu, ecx, data) != 0) {
+	if (kvm_set_msr(vcpu, ecx, data) != 0) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -893,7 +893,6 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
-
 /*
  * Writes msr value into into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -901,8 +900,34 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
  */
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
+	switch (msr_index) {
+	case MSR_FS_BASE:
+	case MSR_GS_BASE:
+	case MSR_KERNEL_GS_BASE:
+	case MSR_CSTAR:
+	case MSR_LSTAR:
+		if (is_noncanonical_address(data))
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
+		data = get_canonical(data);
+	}
 	return kvm_x86_ops->set_msr(vcpu, msr_index, data);
 }
+EXPORT_SYMBOL_GPL(kvm_set_msr);
 
 /*
  * Adapt set_msr() to msr_io()'s calling convention

