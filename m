Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3JQOu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:50:59 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55177 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3JQOu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:50:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, agraf@suse.de, chao.zhou@intel.com, magnus@boden.cx,
        kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: fix KVM_SET_XCRS for CPUs that do not support XSAVE
Date: Thu, 17 Oct 2013 16:50:46 +0200
Message-Id: <1382021447-20216-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382021447-20216-1-git-send-email-pbonzini@redhat.com>
References: <1382021447-20216-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KVM_SET_XCRS ioctl must accept anything that KVM_GET_XCRS
could return.  XCR0's bit 0 is always 1 in real processors with
XSAVE, and KVM_GET_XCRS will always leave bit 0 set even if the
emulated processor does not have XSAVE.  So, KVM_SET_XCRS must
ignore that bit when checking for attempts to enable unsupported
save states.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Introduced between v2 and v3, when I stopped hardcoding
	XSTATE_FPSSE in guest_supported_xcr0.

 arch/x86/kvm/x86.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c951c71..f4e1391 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -577,6 +577,7 @@ static void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
 int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
 	u64 xcr0;
+	u64 valid_bits;
 
 	/* Only support XCR_XFEATURE_ENABLED_MASK(xcr0) now  */
 	if (index != XCR_XFEATURE_ENABLED_MASK)
@@ -586,8 +587,16 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 		return 1;
 	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
 		return 1;
-	if (xcr0 & ~vcpu->arch.guest_supported_xcr0)
+
+	/*
+	 * Do not allow the guest to set bits that we do not support
+	 * saving.  However, xcr0 bit 0 is always set, even if the
+	 * emulated CPU does not support XSAVE (see fx_init).
+	 */
+	valid_bits = vcpu->arch.guest_supported_xcr0 | XSTATE_FP;
+	if (xcr0 & ~valid_bits)
 		return 1;
+
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->arch.xcr0 = xcr0;
 	return 0;
-- 
1.8.3.1


