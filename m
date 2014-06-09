Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbaFINEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:04:52 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:65016 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbaFIM7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:30 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 07/25] KVM: emulate: simplify writeback
Date: Mon,  9 Jun 2014 14:58:55 +0200
Message-Id: <1402318753-23362-8-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "if/return" checks are useless, because we return X86EMUL_CONTINUE
anyway if we do not return.

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5f902d40740c..a1daf52fae58 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1585,34 +1585,28 @@ static void write_register_operand(struct operand *op)
 
 static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
 {
-	int rc;
-
 	switch (op->type) {
 	case OP_REG:
 		write_register_operand(op);
 		break;
 	case OP_MEM:
 		if (ctxt->lock_prefix)
-			rc = segmented_cmpxchg(ctxt,
+			return segmented_cmpxchg(ctxt,
+						 op->addr.mem,
+						 &op->orig_val,
+						 &op->val,
+						 op->bytes);
+		else
+			return segmented_write(ctxt,
 					       op->addr.mem,
-					       &op->orig_val,
 					       &op->val,
 					       op->bytes);
-		else
-			rc = segmented_write(ctxt,
-					     op->addr.mem,
-					     &op->val,
-					     op->bytes);
-		if (rc != X86EMUL_CONTINUE)
-			return rc;
 		break;
 	case OP_MEM_STR:
-		rc = segmented_write(ctxt,
-				op->addr.mem,
-				op->data,
-				op->bytes * op->count);
-		if (rc != X86EMUL_CONTINUE)
-			return rc;
+		return segmented_write(ctxt,
+				       op->addr.mem,
+				       op->data,
+				       op->bytes * op->count);
 		break;
 	case OP_XMM:
 		write_sse_reg(ctxt, &op->vec_val, op->addr.xmm);
-- 
1.8.3.1


