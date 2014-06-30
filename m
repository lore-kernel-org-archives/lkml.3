Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaF3JD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:03:26 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:26606 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaF3JDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:03:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEAKgmsVOERCABjGdsb2JhbABagWwGrWMBAQaaNQGBDRYPAQEBJzyEBAEFJ1IQUVcZiELAZ4V7F4VkiSMHFoQtBYpBp18
X-IPAS-Result: AsgEAKgmsVOERCABjGdsb2JhbABagWwGrWMBAQaaNQGBDRYPAQEBJzyEBAEFJ1IQUVcZiELAZ4V7F4VkiSMHFoQtBYpBp18
X-IronPort-AV: E=Sophos;i="5.01,573,1400014800"; 
   d="scan'208";a="113723300"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2] KVM: x86: Pending interrupt may be delivered after INIT
Date: Mon, 30 Jun 2014 12:03:02 +0300
Message-Id: <1404118982-9429-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140630084707.GJ18167@minantech.com>
References: <20140630084707.GJ18167@minantech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We encountered a scenario in which after an INIT is delivered, a pending
interrupt is delivered, although it was sent before the INIT.  As the SDM
states in section 10.4.7.1, the ISR and the IRR should be cleared after INIT as
KVM does.  This also means that pending interrupts should be cleared.  This
patch clears upon reset (and INIT) the pending interrupts; and at the same
occassion clears the pending exceptions, since they may cause a similar issue.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..6425a31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6835,6 +6835,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu)
 	atomic_set(&vcpu->arch.nmi_queued, 0);
 	vcpu->arch.nmi_pending = 0;
 	vcpu->arch.nmi_injected = false;
+	kvm_clear_interrupt_queue(vcpu);
+	kvm_clear_exception_queue(vcpu);
 
 	memset(vcpu->arch.db, 0, sizeof(vcpu->arch.db));
 	vcpu->arch.dr6 = DR6_FIXED_1;
-- 
1.9.1

