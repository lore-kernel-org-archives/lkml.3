Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaJ1Rog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:44:36 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:59116 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaJ1Rof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:44:35 -0400
Date: Tue, 28 Oct 2014 15:44:30 -0200
From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH 2/9] Moving NX-AES-CCM to be processed logic and sg_list
 bounds
Message-ID: <20141028174427.GA16919@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102817-0005-0000-0000-000000E80925
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous limits were estimated locally in a single step
basead on bound values, however it was not correct since
when given certain scatterlist the function nx_build_sg_lists
was consuming more sg entries than allocated causing a
memory corruption and crashes.

This patch removes the old logic and replaces it into nx_sg_build_lists in
order to build a correct nx_sg list using the correct sg_max limit and
bounds.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-ccm.c |   61 +++++++++++++++++----------------------
 1 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index 5ecd4c2..67f8081 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -181,6 +181,7 @@ static int generate_pat(u8                   *iv,
 	unsigned int iauth_len = 0;
 	u8 tmp[16], *b1 = NULL, *b0 = NULL, *result = NULL;
 	int rc;
+	unsigned int max_sg_len;
 
 	/* zero the ctr value */
 	memset(iv + 15 - iv[0], 0, iv[0] + 1);
@@ -248,10 +249,19 @@ static int generate_pat(u8                   *iv,
 	if (!req->assoclen) {
 		return rc;
 	} else if (req->assoclen <= 14) {
-		nx_insg = nx_build_sg_list(nx_insg, b1, 16, nx_ctx->ap->sglen);
-		nx_outsg = nx_build_sg_list(nx_outsg, tmp, 16,
+		unsigned int len = 16;
+
+		nx_insg = nx_build_sg_list(nx_insg, b1, &len, nx_ctx->ap->sglen);
+
+		if (len != 16)
+			return -EINVAL;
+
+		nx_outsg = nx_build_sg_list(nx_outsg, tmp, &len,
 					    nx_ctx->ap->sglen);
 
+		if (len != 16)
+			return -EINVAL;
+
 		/* inlen should be negative, indicating to phyp that its a
 		 * pointer to an sg list */
 		nx_ctx->op.inlen = (nx_ctx->in_sg - nx_insg) *
@@ -273,21 +283,24 @@ static int generate_pat(u8                   *iv,
 		atomic64_add(req->assoclen, &(nx_ctx->stats->aes_bytes));
 
 	} else {
-		u32 max_sg_len;
 		unsigned int processed = 0, to_process;
 
-		/* page_limit: number of sg entries that fit on one page */
-		max_sg_len = min_t(u32,
-				   nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-				   nx_ctx->ap->sglen);
-
 		processed += iauth_len;
 
+		/* page_limit: number of sg entries that fit on one page */
+		max_sg_len = min_t(u64, nx_ctx->ap->sglen,
+				nx_driver.of.max_sg_len/sizeof(struct nx_sg));
+		max_sg_len = min_t(u64, max_sg_len,
+				nx_ctx->ap->databytelen/NX_PAGE_SIZE);
+
 		do {
 			to_process = min_t(u32, req->assoclen - processed,
 					   nx_ctx->ap->databytelen);
-			to_process = min_t(u64, to_process,
-					   NX_PAGE_SIZE * (max_sg_len - 1));
+
+			nx_insg = nx_walk_and_build(nx_ctx->in_sg,
+						    nx_ctx->ap->sglen,
+						    req->assoc, processed,
+						    &to_process);
 
 			if ((to_process + processed) < req->assoclen) {
 				NX_CPB_FDM(nx_ctx->csbcpb_aead) |=
@@ -297,10 +310,6 @@ static int generate_pat(u8                   *iv,
 					~NX_FDM_INTERMEDIATE;
 			}
 
-			nx_insg = nx_walk_and_build(nx_ctx->in_sg,
-						    nx_ctx->ap->sglen,
-						    req->assoc, processed,
-						    to_process);
 
 			nx_ctx->op_aead.inlen = (nx_ctx->in_sg - nx_insg) *
 						sizeof(struct nx_sg);
@@ -343,7 +352,6 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 	struct nx_ccm_priv *priv = &nx_ctx->priv.ccm;
 	unsigned long irq_flags;
 	unsigned int processed = 0, to_process;
-	u32 max_sg_len;
 	int rc = -1;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
@@ -360,19 +368,12 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 	if (rc)
 		goto out;
 
-	/* page_limit: number of sg entries that fit on one page */
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
-
 	do {
 
 		/* to_process: the AES_BLOCK_SIZE data chunk to process in this
 		 * update. This value is bound by sg list limits.
 		 */
-		to_process = min_t(u64, nbytes - processed,
-				   nx_ctx->ap->databytelen);
-		to_process = min_t(u64, to_process,
-				   NX_PAGE_SIZE * (max_sg_len - 1));
+		to_process = nbytes - processed;
 
 		if ((to_process + processed) < nbytes)
 			NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
@@ -382,7 +383,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 		NX_CPB_FDM(nx_ctx->csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
 		rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
-					to_process, processed,
+					&to_process, processed,
 					csbcpb->cpb.aes_ccm.iv_or_ctr);
 		if (rc)
 			goto out;
@@ -427,7 +428,6 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 	unsigned int authsize = crypto_aead_authsize(crypto_aead_reqtfm(req));
 	unsigned long irq_flags;
 	unsigned int processed = 0, to_process;
-	u32 max_sg_len;
 	int rc = -1;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
@@ -437,18 +437,11 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 	if (rc)
 		goto out;
 
-	/* page_limit: number of sg entries that fit on one page */
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
-
 	do {
 		/* to process: the AES_BLOCK_SIZE data chunk to process in this
 		 * update. This value is bound by sg list limits.
 		 */
-		to_process = min_t(u64, nbytes - processed,
-				   nx_ctx->ap->databytelen);
-		to_process = min_t(u64, to_process,
-				   NX_PAGE_SIZE * (max_sg_len - 1));
+		to_process = nbytes - processed;
 
 		if ((to_process + processed) < nbytes)
 			NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
@@ -458,7 +451,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 
 		rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
-					to_process, processed,
+					&to_process, processed,
 				       csbcpb->cpb.aes_ccm.iv_or_ctr);
 		if (rc)
 			goto out;
-- 
1.7.1

