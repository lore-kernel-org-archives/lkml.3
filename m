Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbaFINBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:01:51 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35805 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbaFIM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:51 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 19/25] KVM: emulate: speed up do_insn_fetch
Date: Mon,  9 Jun 2014 14:59:07 +0200
Message-Id: <1402318753-23362-20-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hoist the common case up from do_insn_fetch_byte to do_insn_fetch,
and prime the fetch_cache in x86_decode_insn.  This helps a bit the
compiler and the branch predictor, but above all it lays the
ground for further changes in the next few patches.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 67 +++++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 32f38a3467a0..aee124a4cc6c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -704,51 +704,51 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
 }
 
 /*
- * Fetch the next byte of the instruction being emulated which is pointed to
- * by ctxt->_eip, then increment ctxt->_eip.
- *
- * Also prefetch the remaining bytes of the instruction without crossing page
+ * Prefetch the remaining bytes of the instruction without crossing page
  * boundary if they are not in fetch_cache yet.
  */
-static int do_insn_fetch_byte(struct x86_emulate_ctxt *ctxt, u8 *dest)
+static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt)
 {
 	struct fetch_cache *fc = &ctxt->fetch;
 	int rc;
 	int size, cur_size;
-
-	if (ctxt->_eip == fc->end) {
-		unsigned long linear;
-		struct segmented_address addr = { .seg = VCPU_SREG_CS,
-						  .ea  = ctxt->_eip };
-		cur_size = fc->end - fc->start;
-		size = min(15UL - cur_size,
-			   PAGE_SIZE - offset_in_page(ctxt->_eip));
-		rc = __linearize(ctxt, addr, size, false, true, &linear);
-		if (unlikely(rc != X86EMUL_CONTINUE))
-			return rc;
-		rc = ctxt->ops->fetch(ctxt, linear, fc->data + cur_size,
-				      size, &ctxt->exception);
-		if (unlikely(rc != X86EMUL_CONTINUE))
-			return rc;
-		fc->end += size;
-	}
-	*dest = fc->data[ctxt->_eip - fc->start];
-	ctxt->_eip++;
+	unsigned long linear;
+
+	struct segmented_address addr = { .seg = VCPU_SREG_CS,
+					  .ea  = fc->end };
+	cur_size = fc->end - fc->start;
+	size = min(15UL - cur_size,
+		   PAGE_SIZE - offset_in_page(fc->end));
+	if (unlikely(size == 0))
+		return X86EMUL_UNHANDLEABLE;
+	rc = __linearize(ctxt, addr, size, false, true, &linear);
+	if (unlikely(rc != X86EMUL_CONTINUE))
+		return rc;
+	rc = ctxt->ops->fetch(ctxt, linear, fc->data + cur_size,
+			      size, &ctxt->exception);
+	if (unlikely(rc != X86EMUL_CONTINUE))
+		return rc;
+	fc->end += size;
 	return X86EMUL_CONTINUE;
 }
 
 static int do_insn_fetch(struct x86_emulate_ctxt *ctxt,
-			 void *dest, unsigned size)
+			 void *__dest, unsigned size)
 {
 	int rc;
+	struct fetch_cache *fc = &ctxt->fetch;
+	u8 *dest = __dest;
+	u8 *src = &fc->data[ctxt->_eip - fc->start];
 
-	/* x86 instructions are limited to 15 bytes. */
-	if (unlikely(ctxt->_eip + size - ctxt->eip > 15))
-		return X86EMUL_UNHANDLEABLE;
 	while (size--) {
-		rc = do_insn_fetch_byte(ctxt, dest++);
-		if (rc != X86EMUL_CONTINUE)
-			return rc;
+		if (unlikely(ctxt->_eip == fc->end)) {
+			rc = do_insn_fetch_bytes(ctxt);
+			if (rc != X86EMUL_CONTINUE)
+				return rc;
+		}
+		*dest++ = *src++;
+		ctxt->_eip++;
+		continue;
 	}
 	return X86EMUL_CONTINUE;
 }
@@ -4301,6 +4301,11 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	ctxt->opcode_len = 1;
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
+	else {
+		rc = do_insn_fetch_bytes(ctxt);
+		if (rc != X86EMUL_CONTINUE)
+			return rc;
+	}
 
 	switch (mode) {
 	case X86EMUL_MODE_REAL:
-- 
1.8.3.1


