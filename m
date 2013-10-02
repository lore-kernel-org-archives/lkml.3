Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3JBOGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:06:30 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64431 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab3JBOG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:06:26 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@redhat.com
Subject: [PATCH 1/3] KVM: x86: mask unsupported XSAVE entries from leaf 0Dh index 0
Date: Wed,  2 Oct 2013 16:06:14 +0200
Message-Id: <1380722776-12358-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380722776-12358-1-git-send-email-pbonzini@redhat.com>
References: <1380722776-12358-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XSAVE entries that KVM does not support are reported by
KVM_GET_SUPPORTED_CPUID for leaf 0Dh index 0 if the host supports them;
they should be left out unless there is also hypervisor support for them.

Sub-leafs are correctly handled in supported_xcr0_bit, fix index 0
to match.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 4 +++-
 arch/x86/kvm/x86.h   | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b110fe6..a03a9fa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -182,7 +182,7 @@ static bool supported_xcr0_bit(unsigned bit)
 {
 	u64 mask = ((u64)1 << bit);
 
-	return mask & (XSTATE_FP | XSTATE_SSE | XSTATE_YMM) & host_xcr0;
+	return mask & KVM_SUPPORTED_XCR0 & host_xcr0;
 }
 
 #define F(x) bit(X86_FEATURE_##x)
@@ -383,6 +383,8 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 0xd: {
 		int idx, i;
 
+		entry->eax &= host_xcr0 & KVM_SUPPORTED_XCR0;
+		entry->edx &= (host_xcr0 & KVM_SUPPORTED_XCR0) >> 32;
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		for (idx = 1, i = 1; idx < 64; ++idx) {
 			if (*nent >= maxnent)
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


