Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaDAP1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:27:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39076 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaDAP1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:27:02 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 5/6] KVM: emulate: activate memory access optimization
Date: Tue,  1 Apr 2014 17:26:45 +0200
Message-Id: <1396366006-22227-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
References: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory_prepare lets us replace segmented_read/segmented_write with direct
calls to __copy_from_user/__copy_to_user.

This saves about 70 cycles (15%) on arithmetic with a memory source
operand, and about 150 cycles (25%) on arithmetic with a memory
destination operand.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  2 ++
 arch/x86/kvm/emulate.c             | 50 ++++++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 4a580be2553e..a572d4fabd4f 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -263,6 +263,8 @@ struct operand {
 		u64 mm_val;
 		void *data;
 	};
+	unsigned long hva;
+	void *opaque;
 };
 
 struct fetch_cache {
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c7ef72c1289e..2c881e5cf5ad 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1546,9 +1546,37 @@ exception:
 }
 
 static int prepare_memory_operand(struct x86_emulate_ctxt *ctxt,
-				  struct operand *op)
+				  struct operand *op,
+				  bool write)
 {
-	return segmented_read(ctxt, op->addr.mem, &op->val, op->bytes);
+	int rc;
+	unsigned long gva;
+	unsigned int size = op->bytes;
+
+	rc = linearize(ctxt, op->addr.mem, size, write, &gva);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	rc = ctxt->ops->memory_prepare(ctxt, gva, size,
+					&ctxt->exception, true,
+					&op->opaque, &op->hva);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	if (likely(!kvm_is_error_hva(op->hva))) {
+		rc = __copy_from_user(&op->val, (void __user *)op->hva,
+				      size);
+		if (!write)
+			ctxt->ops->memory_finish(ctxt, op->opaque, op->hva);
+
+		if (likely(!rc))
+			return X86EMUL_CONTINUE;
+
+		/* Should not happen.  */
+		op->hva = KVM_HVA_ERR_BAD;
+	}
+
+	return read_emulated(ctxt, gva, &op->val, size);
 }
 
 static int cmpxchg_memory_operand(struct x86_emulate_ctxt *ctxt,
@@ -1563,6 +1591,17 @@ static int cmpxchg_memory_operand(struct x86_emulate_ctxt *ctxt,
 static int write_memory_operand(struct x86_emulate_ctxt *ctxt,
 				struct operand *op)
 {
+	int rc;
+
+	if (likely(!kvm_is_error_hva(op->hva))) {
+		rc = __copy_to_user((void __user *)op->hva, &op->val,
+				    op->bytes);
+		ctxt->ops->memory_finish(ctxt, op->opaque, op->hva);
+
+		if (likely(!rc))
+			return X86EMUL_CONTINUE;
+	}
+
 	return segmented_write(ctxt, op->addr.mem,
 			       &op->val,
 			       op->bytes);
@@ -4604,14 +4643,14 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	}
 
 	if ((ctxt->src.type == OP_MEM) && !(ctxt->d & NoAccess)) {
-		rc = prepare_memory_operand(ctxt, &ctxt->src);
+		rc = prepare_memory_operand(ctxt, &ctxt->src, false);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 		ctxt->src.orig_val64 = ctxt->src.val64;
 	}
 
 	if (ctxt->src2.type == OP_MEM) {
-		rc = prepare_memory_operand(ctxt, &ctxt->src2);
+		rc = prepare_memory_operand(ctxt, &ctxt->src2, false);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 	}
@@ -4622,7 +4661,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 	if ((ctxt->dst.type == OP_MEM) && !(ctxt->d & Mov)) {
 		/* optimisation - avoid slow emulated read if Mov */
-		rc = prepare_memory_operand(ctxt, &ctxt->dst);
+		rc = prepare_memory_operand(ctxt, &ctxt->dst,
+					    !(ctxt->d & NoWrite));
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 	}
-- 
1.8.3.1


