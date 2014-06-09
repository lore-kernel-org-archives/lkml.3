Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbaFINEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:04:12 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:55880 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbaFIM7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:31 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 08/25] KVM: emulate: abstract handling of memory operands
Date: Mon,  9 Jun 2014 14:58:56 +0200
Message-Id: <1402318753-23362-9-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract the pre-execution processing and writeback of memory operands
in new functions.  We will soon do some work before execution even for
move destination, so call the function in that case too; but not for
the memory operand of lea, invlpg etc.

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a1daf52fae58..7e9dc2d6fd44 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1564,6 +1564,29 @@ static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	return __load_segment_descriptor(ctxt, selector, seg, cpl, false);
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
@@ -1591,16 +1614,9 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
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
@@ -4622,16 +4638,14 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
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
@@ -4642,8 +4656,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
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


