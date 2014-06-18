Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967165AbaFRO1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:27:45 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:23258 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbaFROTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZG4gnxxuFXheFYokTBxaELQSKOaVigUU
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZG4gnxxuFXheFYokTBxaELQSKOaVigUU
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034535"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 4/9] KVM: x86: emulation of dword cmov on long-mode should clear [63:32]
Date: Wed, 18 Jun 2014 17:19:21 +0300
Message-Id: <1403101166-23616-5-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
References: <539F059F.8050501@redhat.com>
 <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if the condition of cmov is not satisfied, bits[63:32] should be cleared.
This is clearly stated in Intel's CMOVcc documentation.  The solution is to
reassign the destination onto itself if the condition is unsatisfied.  For that
matter the original destination value needs to be read.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0183350..b354531 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3905,7 +3905,7 @@ static const struct opcode twobyte_table[256] = {
 	N, N,
 	N, N, N, N, N, N, N, N,
 	/* 0x40 - 0x4F */
-	X16(D(DstReg | SrcMem | ModRM | Mov)),
+	X16(D(DstReg | SrcMem | ModRM)),
 	/* 0x50 - 0x5F */
 	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N,
 	/* 0x60 - 0x6F */
@@ -4799,8 +4799,10 @@ twobyte_insn:
 		ops->get_dr(ctxt, ctxt->modrm_reg, &ctxt->dst.val);
 		break;
 	case 0x40 ... 0x4f:	/* cmov */
-		ctxt->dst.val = ctxt->dst.orig_val = ctxt->src.val;
-		if (!test_cc(ctxt->b, ctxt->eflags))
+		if (test_cc(ctxt->b, ctxt->eflags))
+			ctxt->dst.val = ctxt->src.val;
+		else if (ctxt->mode != X86EMUL_MODE_PROT64 ||
+			 ctxt->op_bytes != 4)
 			ctxt->dst.type = OP_NONE; /* no writeback */
 		break;
 	case 0x80 ... 0x8f: /* jnz rel, etc*/
-- 
1.9.1

