Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaDAP2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:28:24 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48380 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaDAP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:26:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 2/6] KVM: emulate: abstract handling of memory operands
Date: Tue,  1 Apr 2014 17:26:42 +0200
Message-Id: <1396366006-22227-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
References: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract the pre-execution processing and writeback of memory operands
in new functions.  We will soon do some work before execution even for
move destination, so call the function in that case too; but not for
the memory operand of lea, invlpg etc.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b42184eccbcc..c7ef72c1289e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1545,6 +1545,29 @@ exception:
 	return X86EMUL_PROPAGATE_FAULT;
 }
 
+static int prepare_memory_operand(struct x86_emulate_ctxt *ctxt,
+				  struct operand *op)
+{
+	return segmented_read(ctxt, op->addr.mem, &op->val, op->bytes);
+}
+
+static int cmpxchg_memory_operand(struct x86_emulate_ctxt *ctxt,
+				  struct operand *op)
+{
+	return segmented_cmpxchg(ctxt, op->addr.mem,
+				 &op->orig_val,
+				 &op->val,
+				 op->bytes);
+}
+
+static int write_memory_operand(struct x86_emulate_ctxt *ctxt,
+				struct operand *op)
+{
+	return segmented_write(ctxt, op->addr.mem,
+			       &op->val,
+			       op->bytes);
+}
+
 static void write_register_operand(struct operand *op)
 {
 	/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
@@ -1572,16 +1595,9 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
 		break;
 	case OP_MEM:
 		if (ctxt->lock_prefix)
-			return segmented_cmpxchg(ctxt,
-						 op->addr.mem,
-						 &op->orig_val,
-						 &op->val,
-						 op->bytes);
+			return cmpxchg_memory_operand(ctxt, op);
 		else
-			return segmented_write(ctxt,
-					       op->addr.mem,
-					       &op->val,
-					       op->bytes);
+			return write_memory_operand(ctxt, op);
 		break;
 	case OP_MEM_STR:
 		return segmented_write(ctxt,
@@ -4588,16 +4604,14 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	}
 
 	if ((ctxt->src.type == OP_MEM) && !(ctxt->d & NoAccess)) {
-		rc = segmented_read(ctxt, ctxt->src.addr.mem,
-				    ctxt->src.valptr, ctxt->src.bytes);
+		rc = prepare_memory_operand(ctxt, &ctxt->src);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 		ctxt->src.orig_val64 = ctxt->src.val64;
 	}
 
 	if (ctxt->src2.type == OP_MEM) {
-		rc = segmented_read(ctxt, ctxt->src2.addr.mem,
-				    &ctxt->src2.val, ctxt->src2.bytes);
+		rc = prepare_memory_operand(ctxt, &ctxt->src2);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 	}
@@ -4608,8 +4622,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 	if ((ctxt->dst.type == OP_MEM) && !(ctxt->d & Mov)) {
 		/* optimisation - avoid slow emulated read if Mov */
-		rc = segmented_read(ctxt, ctxt->dst.addr.mem,
-				   &ctxt->dst.val, ctxt->dst.bytes);
+		rc = prepare_memory_operand(ctxt, &ctxt->dst);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 	}
-- 
1.8.3.1


