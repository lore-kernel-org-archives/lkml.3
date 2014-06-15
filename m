Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaFONOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:14:08 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:34693 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFONNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:13:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgECAPuanVOERCABjGdsb2JhbABariIBAQaZJAGBABYPAQEBJzyEBAEFJ1IQUVcZG4gnyViFJheFY4kTBxaELQSKOacl
X-IPAS-Result: AgECAPuanVOERCABjGdsb2JhbABariIBAQaZJAGBABYPAQEBJzyEBAEFJ1IQUVcZG4gnyViFJheFY4kTBxaELQSKOacl
X-IronPort-AV: E=Sophos;i="5.01,481,1400014800"; 
   d="scan'208";a="111523996"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 2/6] KVM: x86: Wrong emulation on 'xadd X, X'
Date: Sun, 15 Jun 2014 16:12:58 +0300
Message-Id: <1402837982-24959-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The emulator does not emulate the xadd instruction correctly if the two
operands are the same.  In this (unlikely) situation the result should be the
sum of X and X (2X) when it is currently X.  The solution is to first perform
writeback to the source, before writing to the destination.  The only
instruction which should be affected is xadd, as the other instructions that
perform writeback to the source use the extended accumlator (e.g., RAX:RDX).

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f0b0a10..3c8d867 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4711,17 +4711,17 @@ special_insn:
 		goto done;
 
 writeback:
-	if (!(ctxt->d & NoWrite)) {
-		rc = writeback(ctxt, &ctxt->dst);
-		if (rc != X86EMUL_CONTINUE)
-			goto done;
-	}
 	if (ctxt->d & SrcWrite) {
 		BUG_ON(ctxt->src.type == OP_MEM || ctxt->src.type == OP_MEM_STR);
 		rc = writeback(ctxt, &ctxt->src);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 	}
+	if (!(ctxt->d & NoWrite)) {
+		rc = writeback(ctxt, &ctxt->dst);
+		if (rc != X86EMUL_CONTINUE)
+			goto done;
+	}
 
 	/*
 	 * restore dst type in case the decoding will be reused
-- 
1.9.1

