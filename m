Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835Ab3IEMW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:22:26 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:44314 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab3IEMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:22:05 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH] KVM: x86: prevent setting unsupported XSAVE states
Date: Thu,  5 Sep 2013 14:21:54 +0200
Message-Id: <1378383714-9723-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A guest can still attempt to save and restore XSAVE states even if they
have been masked in CPUID leaf 0Dh.  This usually is not visible to
the guest, but is still wrong: "Any attempt to set a reserved bit (as
determined by the contents of EAX and EDX after executing CPUID with
EAX=0DH, ECX= 0H) in XCR0 for a given processor will result in a #GP
exception".

The patch also performs the same checks as __kvm_set_xcr in KVM_SET_XSAVE.
This catches migration from newer to older kernel/processor before the
guest starts running.

Cc: kvm@vger.kernel.org
Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c |  2 +-
 arch/x86/kvm/x86.c   | 10 ++++++++--
 arch/x86/kvm/x86.h   |  1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a20ecb5..d7c465d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -182,7 +182,7 @@ static bool supported_xcr0_bit(unsigned bit)
 {
 	u64 mask = ((u64)1 << bit);
 
-	return mask & (XSTATE_FP | XSTATE_SSE | XSTATE_YMM) & host_xcr0;
+	return mask & KVM_SUPPORTED_XCR0 & host_xcr0;
 }
 
 #define F(x) bit(X86_FEATURE_##x)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3625798..801a882 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -586,6 +586,8 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 		return 1;
 	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
 		return 1;
+	if (xcr0 & ~KVM_SUPPORTED_XCR0)
+		return 1;
 	if (xcr0 & ~host_xcr0)
 		return 1;
 	kvm_put_guest_xcr0(vcpu);
@@ -2980,10 +2982,14 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 	u64 xstate_bv =
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
 
-	if (cpu_has_xsave)
+	if (cpu_has_xsave) {
+		if (xstate_bv & ~KVM_SUPPORTED_XCR0)
+			return -EINVAL;
+		if (xstate_bv & ~host_xcr0)
+			return -EINVAL;
 		memcpy(&vcpu->arch.guest_fpu.state->xsave,
 			guest_xsave->region, xstate_size);
-	else {
+	} else {
 		if (xstate_bv & ~XSTATE_FPSSE)
 			return -EINVAL;
 		memcpy(&vcpu->arch.guest_fpu.state->fxsave,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e224f7a..587fb9e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -122,6 +122,7 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
 	gva_t addr, void *val, unsigned int bytes,
 	struct x86_exception *exception);
 
+#define KVM_SUPPORTED_XCR0	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
 extern u64 host_xcr0;
 
 extern struct static_key kvm_no_apic_vcpu;
-- 
1.8.3.1

