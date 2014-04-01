Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaDAP2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:28:22 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63580 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaDAP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:27:04 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 6/6] KVM: emulate: extend memory access optimization to stores
Date: Tue,  1 Apr 2014 17:26:46 +0200
Message-Id: <1396366006-22227-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
References: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even on a store, the optimization saves about 20 clock cycles (4-5%),
mostly because the jump in write_memory_operand becomes much more
predictable.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2c881e5cf5ad..541296f62b40 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1547,7 +1547,7 @@ exception:
 
 static int prepare_memory_operand(struct x86_emulate_ctxt *ctxt,
 				  struct operand *op,
-				  bool write)
+				  bool read, bool write)
 {
 	int rc;
 	unsigned long gva;
@@ -1563,6 +1563,10 @@ static int prepare_memory_operand(struct x86_emulate_ctxt *ctxt,
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
+	/* optimisation - avoid slow emulated read if Mov */
+	if (!read)
+		return X86EMUL_CONTINUE;
+
 	if (likely(!kvm_is_error_hva(op->hva))) {
 		rc = __copy_from_user(&op->val, (void __user *)op->hva,
 				      size);
@@ -4643,14 +4647,14 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
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
@@ -4659,9 +4663,9 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
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
