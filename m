Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaDAP05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:26:57 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50495 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaDAP0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:26:54 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 1/6] KVM: emulate: simplify writeback
Date: Tue,  1 Apr 2014 17:26:41 +0200
Message-Id: <1396366006-22227-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
References: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "if/return" checks are useless, because we return X86EMUL_CONTINUE
anyway if we do not return.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4a3584d419e5..b42184eccbcc 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1566,34 +1566,28 @@ static void write_register_operand(struct operand *op)
 
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


