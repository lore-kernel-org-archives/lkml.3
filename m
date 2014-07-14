Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaGNLlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:41:15 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:46443 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaGNLjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:39:21 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 15/19] KVM: emulate: avoid repeated calls to do_insn_fetch_bytes
Date: Mon, 14 Jul 2014 13:38:39 +0200
Message-Id: <1405337923-4776-16-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_insn_fetch_bytes will only be called once in a given insn_fetch and
insn_fetch_arr, because in fact it will only be called at most twice
for any instruction and the first call is explicit in x86_decode_insn.
This observation lets us hoist the call out of the memory copying loop.
It does not buy performance, because most fetches are one byte long
anyway, but it prepares for the next patch.

The overflow check is tricky, but correct.  Because do_insn_fetch_bytes
has already been called once, we know that fc->end is at least 15.  So
it is okay to subtract the number of bytes we want to read.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ea188a338afb..ca82ec9c5ffe 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -708,7 +708,7 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
  * Prefetch the remaining bytes of the instruction without crossing page
  * boundary if they are not in fetch_cache yet.
  */
-static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt)
+static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 {
 	struct fetch_cache *fc = &ctxt->fetch;
 	int rc;
@@ -720,7 +720,14 @@ static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt)
 	cur_size = fc->end - fc->start;
 	size = min(15UL - cur_size,
 		   PAGE_SIZE - offset_in_page(fc->end));
-	if (unlikely(size == 0))
+
+	/*
+	 * One instruction can only straddle two pages,
+	 * and one has been loaded at the beginning of
+	 * x86_decode_insn.  So, if not enough bytes
+	 * still, we must have hit the 15-byte boundary.
+	 */
+	if (unlikely(size < op_size))
 		return X86EMUL_UNHANDLEABLE;
 	rc = __linearize(ctxt, addr, size, false, true, &linear);
 	if (unlikely(rc != X86EMUL_CONTINUE))
@@ -736,17 +743,18 @@ static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt)
 static int do_insn_fetch(struct x86_emulate_ctxt *ctxt,
 			 void *__dest, unsigned size)
 {
-	int rc;
 	struct fetch_cache *fc = &ctxt->fetch;
 	u8 *dest = __dest;
 	u8 *src = &fc->data[ctxt->_eip - fc->start];
 
+	/* We have to be careful about overflow! */
+	if (unlikely(ctxt->_eip > fc->end - size)) {
+		int rc = do_insn_fetch_bytes(ctxt, size);
+		if (rc != X86EMUL_CONTINUE)
+			return rc;
+	}
+
 	while (size--) {
-		if (unlikely(ctxt->_eip == fc->end)) {
-			rc = do_insn_fetch_bytes(ctxt);
-			if (rc != X86EMUL_CONTINUE)
-				return rc;
-		}
 		*dest++ = *src++;
 		ctxt->_eip++;
 		continue;
@@ -4228,7 +4236,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
 	else {
-		rc = do_insn_fetch_bytes(ctxt);
+		rc = do_insn_fetch_bytes(ctxt, 1);
 		if (rc != X86EMUL_CONTINUE)
 			return rc;
 	}
-- 
1.8.3.1


