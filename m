Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaDRAh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:37:56 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:13916 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDRAhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:37:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkkCAERzUFOERM5ejGdsb2JhbABZyACBIxYOAQEBJzyCJgEFJ1IQQBFXBxKHfMYNhhQXjX5kB4Q4BIlcpRM6gSw
X-IPAS-Result: AkkCAERzUFOERM5ejGdsb2JhbABZyACBIxYOAQEBJzyCJgEFJ1IQQBFXBxKHfMYNhhQXjX5kB4Q4BIlcpRM6gSw
X-IronPort-AV: E=Sophos;i="4.97,882,1389736800"; 
   d="scan'208";a="102882852"
From: Nadav Amit <namit@cs.technion.ac.il>
To: gleb@kernel.org, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 3/5] KVM: x86: IN instruction emulation should ignore REP-prefix
Date: Fri, 18 Apr 2014 03:35:10 +0300
Message-Id: <1397781312-6885-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397781312-6885-1-git-send-email-namit@cs.technion.ac.il>
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
 <1397781312-6885-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IN instruction is not be affected by REP-prefix as INS is.  Therefore, the
emulation should ignore the REP prefix as well.  The current emulator
implementation tries to perform writeback when IN instruction with REP-prefix
is emulated. This causes it to perform wrong memory write or spurious #GP
exception to be injected to the guest.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
:100644 100644 1d60374... 69e2636... M	arch/x86/kvm/emulate.c
 arch/x86/kvm/emulate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1d60374..69e2636 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1324,7 +1324,8 @@ static int pio_in_emulated(struct x86_emulate_ctxt *ctxt,
 		rc->end = n * size;
 	}
 
-	if (ctxt->rep_prefix && !(ctxt->eflags & EFLG_DF)) {
+	if (ctxt->rep_prefix && (ctxt->d & String) &&
+	    !(ctxt->eflags & EFLG_DF)) {
 		ctxt->dst.data = rc->data + rc->pos;
 		ctxt->dst.type = OP_MEM_STR;
 		ctxt->dst.count = (rc->end - rc->pos) / size;
-- 
1.7.10.4

