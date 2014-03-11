Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaCKSY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbaCKSYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:24:25 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, gleb@kernel.org,
        mtosatti@redhat.com, stable@vger.kernel.org
Subject: [PATCH] KVM: SVM: fix cr8 intercept window
Date: Tue, 11 Mar 2014 19:11:18 +0100
Message-Id: <1394561478-8815-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always disable cr8 intercept in its handler, but only re-enable it
if handling KVM_REQ_EVENT, so there can be a window where we do not
intercept cr8 writes, which allows an interrupt to disrupt a higher
priority task.

Fix this by disabling intercepts in the same function that re-enables
them when needed. This fixes BSOD in Windows 2008.

Cc: <stable@vger.kernel.org>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/svm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 64d9bb9..f676c18 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3003,10 +3003,8 @@ static int cr8_write_interception(struct vcpu_svm *svm)
 	u8 cr8_prev = kvm_get_cr8(&svm->vcpu);
 	/* instruction emulation calls kvm_set_cr8() */
 	r = cr_interception(svm);
-	if (irqchip_in_kernel(svm->vcpu.kvm)) {
-		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+	if (irqchip_in_kernel(svm->vcpu.kvm))
 		return r;
-	}
 	if (cr8_prev <= kvm_get_cr8(&svm->vcpu))
 		return r;
 	kvm_run->exit_reason = KVM_EXIT_SET_TPR;
@@ -3568,6 +3566,8 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 	if (is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK))
 		return;
 
+	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+
 	if (irr == -1)
 		return;
 
-- 
1.8.5.3

