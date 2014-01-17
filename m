Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaAQTyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:54:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbaAQTyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:54:03 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, joro@8bytes.org, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH] KVM: SVM: fix NMI window after iret
Date: Fri, 17 Jan 2014 20:52:42 +0100
Message-Id: <1389988362-15260-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should open NMI window right after an iret, but SVM exits before it.
We wanted to single step using the trap flag and then open it.
(or we could emulate the iret instead)
We don't do it since commit 3842d135ff2 (likely), because the iret exit
handler does not request an event, so NMI window remains closed until
the next exit.

Fix this by making KVM_REQ_EVENT request in the iret handler.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 (btw. kvm-unit-tests weren't executed on SVM since Nov 2010, at least)

 arch/x86/kvm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c7168a5..b5a735b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2829,6 +2829,7 @@ static int iret_interception(struct vcpu_svm *svm)
 	clr_intercept(svm, INTERCEPT_IRET);
 	svm->vcpu.arch.hflags |= HF_IRET_MASK;
 	svm->nmi_iret_rip = kvm_rip_read(&svm->vcpu);
+	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	return 1;
 }
 
-- 
1.8.5.2

