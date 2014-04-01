Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaDAQ0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:26:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44645 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaDAQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 70/86] KVM: SVM: fix cr8 intercept window
Date: Tue,  1 Apr 2014 09:08:23 -0700
Message-Id: <1396368519-12728-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>

commit 596f3142d2b7be307a1652d59e7b93adab918437 upstream.

We always disable cr8 intercept in its handler, but only re-enable it
if handling KVM_REQ_EVENT, so there can be a window where we do not
intercept cr8 writes, which allows an interrupt to disrupt a higher
priority task.

Fix this by disabling intercepts in the same function that re-enables
them when needed. This fixes BSOD in Windows 2008.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/svm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d29d3cd..d42c95c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2999,10 +2999,8 @@ static int cr8_write_interception(struct vcpu_svm *svm)
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
@@ -3564,6 +3562,8 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 	if (is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK))
 		return;
 
+	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+
 	if (irr == -1)
 		return;
 
-- 
1.8.3.2

