Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaC3X1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:27:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36602 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbaC3XZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcelo Tosatti" <mtosatti@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.995748062@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 174/200] KVM: SVM: fix cr8 intercept window
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Radim Krčmář <rkrcmar@redhat.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/svm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2904,10 +2904,8 @@ static int cr8_write_interception(struct
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
@@ -3462,6 +3460,8 @@ static void update_cr8_intercept(struct
 	if (is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK))
 		return;
 
+	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+
 	if (irr == -1)
 		return;
 

