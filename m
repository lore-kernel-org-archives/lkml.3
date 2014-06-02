Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaFBPgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:36:45 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:51781 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaFBPef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHFoQqBIofi1yPMIs9gWo
X-IPAS-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHFoQqBIofi1yPMIs9gWo
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853160"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 5/9] KVM: x86: cmpxchg emulation should compare in reverse order
Date: Mon,  2 Jun 2014 18:34:07 +0300
Message-Id: <1401723251-8034-6-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of cmpxchg does not update the flags correctly,
since the accumulator should be compared with the destination and not the other
way around. The current implementation does not update the flags correctly.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a16bf22..4cb0da6 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2052,8 +2052,10 @@ static int em_ret_far_imm(struct x86_emulate_ctxt *ctxt)
 static int em_cmpxchg(struct x86_emulate_ctxt *ctxt)
 {
 	/* Save real source value, then compare EAX against destination. */
+	ctxt->dst.orig_val = ctxt->dst.val;
+	ctxt->dst.val = reg_read(ctxt, VCPU_REGS_RAX);
 	ctxt->src.orig_val = ctxt->src.val;
-	ctxt->src.val = reg_read(ctxt, VCPU_REGS_RAX);
+	ctxt->src.val = ctxt->dst.orig_val;
 	fastop(ctxt, em_cmp);
 
 	if (ctxt->eflags & EFLG_ZF) {
@@ -2063,6 +2065,7 @@ static int em_cmpxchg(struct x86_emulate_ctxt *ctxt)
 		/* Failure: write the value we saw to EAX. */
 		ctxt->dst.type = OP_REG;
 		ctxt->dst.addr.reg = reg_rmw(ctxt, VCPU_REGS_RAX);
+		ctxt->dst.val = ctxt->dst.orig_val;
 	}
 	return X86EMUL_CONTINUE;
 }
-- 
1.9.1

