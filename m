Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaFBPf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:35:58 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:7149 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaFBPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHFoQqBIofpkmBag
X-IPAS-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHFoQqBIofpkmBag
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853169"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 9/9] KVM: x86: smsw emulation is incorrect in 64-bit mode
Date: Mon,  2 Jun 2014 18:34:11 +0300
Message-Id: <1401723251-8034-10-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 64-bit mode, when the destination is a register, the assignment is done
according to the operand size. Otherwise (memory operand or no 64-bit mode), a
16-bit assignment is performed.

Currently, 16-bit assignment is always done to the destination.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a151f8d..9b5d97d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3235,7 +3235,8 @@ static int em_lidt(struct x86_emulate_ctxt *ctxt)
 
 static int em_smsw(struct x86_emulate_ctxt *ctxt)
 {
-	ctxt->dst.bytes = 2;
+	if (ctxt->dst.type == OP_MEM)
+		ctxt->dst.bytes = 2;
 	ctxt->dst.val = ctxt->ops->get_cr(ctxt, 0);
 	return X86EMUL_CONTINUE;
 }
-- 
1.9.1

