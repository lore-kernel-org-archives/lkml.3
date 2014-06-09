Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbaFIM7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:59:44 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64836 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321AbaFIM7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:38 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 12/25] KVM: emulate: extend memory access optimization to stores
Date: Mon,  9 Jun 2014 14:59:00 +0200
Message-Id: <1402318753-23362-13-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even on a store the optimization saves about 50 clock cycles,
mostly because the jump in write_memory_operand becomes much more
predictable.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 594cb560947c..eaf0853ffaf9 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1589,7 +1589,7 @@ static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 
 static int prepare_memory_operand(struct x86_emulate_ctxt *ctxt,
 				  struct operand *op,
-				  bool write)
+				  bool read, bool write)
 {
 	int rc;
 	unsigned long gva;
@@ -1605,6 +1605,10 @@ static int prepare_memory_operand(struct x86_emulate_ctxt *ctxt,
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
+	/* optimisation - avoid slow emulated read if Mov */
+	if (!read)
+		return X86EMUL_CONTINUE;
+
 	if (likely(!kvm_is_error_hva(op->hva))) {
 		rc = read_from_user(ctxt, op->hva, &op->val, size);
 		if (!write)
@@ -4699,14 +4703,14 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	}
 
 	if ((ctxt->src.type == OP_MEM) && !(ctxt->d & NoAccess)) {
-		rc = prepare_memory_operand(ctxt, &ctxt->src, false);
+		rc = prepare_memory_operand(ctxt, &ctxt->src, true, false);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 		ctxt->src.orig_val64 = ctxt->src.val64;
 	}
 
 	if (ctxt->src2.type == OP_MEM) {
-		rc = prepare_memory_operand(ctxt, &ctxt->src2, false);
+		rc = prepare_memory_operand(ctxt, &ctxt->src2, true, false);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 	}
@@ -4715,9 +4719,9 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		goto special_insn;
 
 
-	if ((ctxt->dst.type == OP_MEM) && !(ctxt->d & Mov)) {
-		/* optimisation - avoid slow emulated read if Mov */
+	if (ctxt->dst.type == OP_MEM) {
 		rc = prepare_memory_operand(ctxt, &ctxt->dst,
+					    !(ctxt->d & Mov),
 					    !(ctxt->d & NoWrite));
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
-- 
1.8.3.1


