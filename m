Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966725AbaFROTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:19:45 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:30911 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966610AbaFROTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiC9kBxaELQSKOacngWs
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiC9kBxaELQSKOacngWs
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034536"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 1/9] KVM: x86: bit-ops emulation ignores offset on 64-bit
Date: Wed, 18 Jun 2014 17:19:18 +0300
Message-Id: <1403101166-23616-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
References: <539F059F.8050501@redhat.com>
 <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current emulation of bit operations ignores the offset from the destination
on 64-bit target memory operands. This patch fixes this behavior.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e4e833d..f0b0a10 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1220,12 +1220,14 @@ static void fetch_bit_operand(struct x86_emulate_ctxt *ctxt)
 	long sv = 0, mask;
 
 	if (ctxt->dst.type == OP_MEM && ctxt->src.type == OP_REG) {
-		mask = ~(ctxt->dst.bytes * 8 - 1);
+		mask = ~((long)ctxt->dst.bytes * 8 - 1);
 
 		if (ctxt->src.bytes == 2)
 			sv = (s16)ctxt->src.val & (s16)mask;
 		else if (ctxt->src.bytes == 4)
 			sv = (s32)ctxt->src.val & (s32)mask;
+		else
+			sv = (s64)ctxt->src.val & (s64)mask;
 
 		ctxt->dst.addr.mem.ea += (sv >> 3);
 	}
-- 
1.9.1

