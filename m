Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbaFIND1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:03:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58229 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378AbaFIM7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:35 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 11/25] KVM: emulate: activate memory access optimization
Date: Mon,  9 Jun 2014 14:58:59 +0200
Message-Id: <1402318753-23362-12-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory_prepare lets us replace segmented_read/segmented_write with direct
calls to __copy_from_user/__copy_to_user.  For RMW instructions, we also
avoid double walking of the page tables.

This saves about 50 cycles (5%) on arithmetic with a memory source
operand, and up to 300 cycles (20%) on arithmetic with a memory
destination operand.

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  2 ++
 arch/x86/kvm/emulate.c             | 72 +++++++++++++++++++++++++++++++++++---
 2 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 1aa2adf0bb1a..f596976a3ab2 100644
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
index 7e9dc2d6fd44..594cb560947c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1260,6 +1260,29 @@ read_cached:
 	return X86EMUL_CONTINUE;
 }
 
+static int read_from_user(struct x86_emulate_ctxt *ctxt,
+			  unsigned long hva, void *dest, unsigned size)
+{
+	int rc;
+	struct read_cache *mc = &ctxt->mem_read;
+
+	if (mc->pos < mc->end)
+		goto read_cached;
+
+	WARN_ON((mc->end + size) >= sizeof(mc->data));
+
+	rc = __copy_from_user(mc->data + mc->end, (void __user *)hva, size);
+	if (rc < 0)
+		return X86EMUL_UNHANDLEABLE;
+
+	mc->end += size;
+
+read_cached:
+	memcpy(dest, mc->data + mc->pos, size);
+	mc->pos += size;
+	return X86EMUL_CONTINUE;
+}
+
 static int segmented_read(struct x86_emulate_ctxt *ctxt,
 			  struct segmented_address addr,
 			  void *data,
@@ -1565,9 +1588,36 @@ static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
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
+		rc = read_from_user(ctxt, op->hva, &op->val, size);
+		if (!write)
+			ctxt->ops->memory_finish(ctxt, op->opaque, op->hva);
+
+		if (likely(rc == X86EMUL_CONTINUE))
+			return X86EMUL_CONTINUE;
+
+		/* Should not happen.  */
+		op->hva = KVM_HVA_ERR_BAD;
+	}
+
+	return read_emulated(ctxt, gva, &op->val, size);
 }
 
 static int cmpxchg_memory_operand(struct x86_emulate_ctxt *ctxt,
@@ -1582,6 +1632,17 @@ static int cmpxchg_memory_operand(struct x86_emulate_ctxt *ctxt,
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
@@ -4638,14 +4699,14 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
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
@@ -4656,7 +4717,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
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


