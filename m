Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbaFINAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:00:01 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:42293 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933555AbaFIM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:51 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 21/25] KVM: emulate: avoid per-byte copying in instruction fetches
Date: Mon,  9 Jun 2014 14:59:09 +0200
Message-Id: <1402318753-23362-22-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need a memory copying loop anymore in insn_fetch; we
can use a byte-aligned pointer to access instruction fields directly
from the fetch_cache.  This eliminates 50-150 cycles (corresponding to
a 5-10% improvement in performance) from each instruction.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f81d7a5bc19b..6ec0be2d2461 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -707,7 +707,7 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
  * Prefetch the remaining bytes of the instruction without crossing page
  * boundary if they are not in fetch_cache yet.
  */
-static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
+static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 {
 	struct fetch_cache *fc = &ctxt->fetch;
 	int rc;
@@ -739,41 +739,39 @@ static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	return X86EMUL_CONTINUE;
 }
 
-static int do_insn_fetch(struct x86_emulate_ctxt *ctxt,
-			 void *__dest, unsigned size)
+static __always_inline int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt,
+					       unsigned size)
 {
-	struct fetch_cache *fc = &ctxt->fetch;
-	u8 *dest = __dest;
-	u8 *src = &fc->data[ctxt->_eip - fc->start];
-
 	/* We have to be careful about overflow! */
-	if (unlikely(ctxt->_eip > fc->end - size)) {
-		int rc = do_insn_fetch_bytes(ctxt, size);
-		if (rc != X86EMUL_CONTINUE)
-			return rc;
-	}
-
-	while (size--) {
-		*dest++ = *src++;
-		ctxt->_eip++;
-		continue;
-	}
-	return X86EMUL_CONTINUE;
+	if (unlikely(ctxt->_eip > ctxt->fetch.end - size))
+		return __do_insn_fetch_bytes(ctxt, size);
+	else
+		return X86EMUL_CONTINUE;
 }
 
 /* Fetch next part of the instruction being emulated. */
 #define insn_fetch(_type, _ctxt)					\
-({	unsigned long _x;						\
-	rc = do_insn_fetch(_ctxt, &_x, sizeof(_type));			\
+({	_type _x;							\
+	struct fetch_cache *_fc;					\
+									\
+	rc = do_insn_fetch_bytes(_ctxt, sizeof(_type));			\
 	if (rc != X86EMUL_CONTINUE)					\
 		goto done;						\
-	(_type)_x;							\
+	_fc = &ctxt->fetch;						\
+	_x = *(_type __aligned(1) *) &_fc->data[ctxt->_eip - _fc->start]; \
+	ctxt->_eip += sizeof(_type);					\
+	_x;								\
 })
 
 #define insn_fetch_arr(_arr, _size, _ctxt)				\
-({	rc = do_insn_fetch(_ctxt, _arr, (_size));			\
+({									\
+	struct fetch_cache *_fc;					\
+	rc = do_insn_fetch_bytes(_ctxt, _size);				\
 	if (rc != X86EMUL_CONTINUE)					\
 		goto done;						\
+	_fc = &ctxt->fetch;						\
+	memcpy(_arr, &_fc->data[ctxt->_eip - _fc->start], _size);	\
+	ctxt->_eip += (_size);						\
 })
 
 /*
@@ -4310,7 +4308,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
 	else {
-		rc = do_insn_fetch_bytes(ctxt, 1);
+		rc = __do_insn_fetch_bytes(ctxt, 1);
 		if (rc != X86EMUL_CONTINUE)
 			return rc;
 	}
-- 
1.8.3.1


