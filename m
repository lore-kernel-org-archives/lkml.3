Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaJ1Rrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:47:55 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:42401 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaJ1Rrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:47:53 -0400
Date: Tue, 28 Oct 2014 15:47:48 -0200
From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH 5/9] Moving NX-AES-GCM to be processed logic
Message-ID: <20141028174745.GA17638@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102817-0009-0000-0000-000002246721
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous limits were estimated locally in a single step
basead on bound values, however it was not correct since
when given certain scatterlist the function nx_build_sg_lists
was consuming more sg entries than allocated causing a
memory corruption and crashes.

This patch removes the old logic and replace it into nx_sg_build_lists
in order to build a correct nx_sg list using the correct sg_max limit
and bounds.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-gcm.c |   66 ++++++++++++++++++++++-----------------
 1 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 025d9a8..88c5624 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -131,7 +131,7 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 	struct nx_sg *nx_sg = nx_ctx->in_sg;
 	unsigned int nbytes = req->assoclen;
 	unsigned int processed = 0, to_process;
-	u32 max_sg_len;
+	unsigned int max_sg_len;
 
 	if (nbytes <= AES_BLOCK_SIZE) {
 		scatterwalk_start(&walk, req->assoc);
@@ -143,8 +143,10 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 	NX_CPB_FDM(csbcpb_aead) &= ~NX_FDM_CONTINUATION;
 
 	/* page_limit: number of sg entries that fit on one page */
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+	max_sg_len = min_t(u64, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
 			   nx_ctx->ap->sglen);
+	max_sg_len = min_t(u64, max_sg_len,
+			   nx_ctx->ap->databytelen/NX_PAGE_SIZE);
 
 	do {
 		/*
@@ -156,13 +158,14 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 		to_process = min_t(u64, to_process,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 
+		nx_sg = nx_walk_and_build(nx_ctx->in_sg, max_sg_len,
+					  req->assoc, processed, &to_process);
+
 		if ((to_process + processed) < nbytes)
 			NX_CPB_FDM(csbcpb_aead) |= NX_FDM_INTERMEDIATE;
 		else
 			NX_CPB_FDM(csbcpb_aead) &= ~NX_FDM_INTERMEDIATE;
 
-		nx_sg = nx_walk_and_build(nx_ctx->in_sg, nx_ctx->ap->sglen,
-					  req->assoc, processed, to_process);
 		nx_ctx->op_aead.inlen = (nx_ctx->in_sg - nx_sg)
 					* sizeof(struct nx_sg);
 
@@ -195,7 +198,7 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
 	struct nx_sg *nx_sg;
 	unsigned int nbytes = req->assoclen;
 	unsigned int processed = 0, to_process;
-	u32 max_sg_len;
+	unsigned int max_sg_len;
 
 	/* Set GMAC mode */
 	csbcpb->cpb.hdr.mode = NX_MODE_AES_GMAC;
@@ -203,8 +206,10 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
 	NX_CPB_FDM(csbcpb) &= ~NX_FDM_CONTINUATION;
 
 	/* page_limit: number of sg entries that fit on one page */
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+	max_sg_len = min_t(u64, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
 			   nx_ctx->ap->sglen);
+	max_sg_len = min_t(u64, max_sg_len,
+			   nx_ctx->ap->databytelen/NX_PAGE_SIZE);
 
 	/* Copy IV */
 	memcpy(csbcpb->cpb.aes_gcm.iv_or_cnt, desc->info, AES_BLOCK_SIZE);
@@ -219,13 +224,14 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
 		to_process = min_t(u64, to_process,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 
+		nx_sg = nx_walk_and_build(nx_ctx->in_sg, max_sg_len,
+					  req->assoc, processed, &to_process);
+
 		if ((to_process + processed) < nbytes)
 			NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
 		else
 			NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
 
-		nx_sg = nx_walk_and_build(nx_ctx->in_sg, nx_ctx->ap->sglen,
-					  req->assoc, processed, to_process);
 		nx_ctx->op.inlen = (nx_ctx->in_sg - nx_sg)
 					* sizeof(struct nx_sg);
 
@@ -264,6 +270,7 @@ static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	char out[AES_BLOCK_SIZE];
 	struct nx_sg *in_sg, *out_sg;
+	int len;
 
 	/* For scenarios where the input message is zero length, AES CTR mode
 	 * may be used. Set the source data to be a single block (16B) of all
@@ -279,11 +286,22 @@ static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
 	else
 		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
+	len = AES_BLOCK_SIZE;
+
 	/* Encrypt the counter/IV */
 	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) desc->info,
-				 AES_BLOCK_SIZE, nx_ctx->ap->sglen);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *) out, sizeof(out),
+				 &len, nx_ctx->ap->sglen);
+
+	if (len != AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	len = sizeof(out);
+	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *) out, &len,
 				  nx_ctx->ap->sglen);
+
+	if (len != sizeof(out))
+		return -EINVAL;
+
 	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
 	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
@@ -317,7 +335,6 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 	unsigned int nbytes = req->cryptlen;
 	unsigned int processed = 0, to_process;
 	unsigned long irq_flags;
-	u32 max_sg_len;
 	int rc = -EINVAL;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
@@ -354,33 +371,24 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 		nbytes -= crypto_aead_authsize(crypto_aead_reqtfm(req));
 	}
 
-	/* page_limit: number of sg entries that fit on one page */
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
-
 	do {
-		/*
-		 * to_process: the data chunk to process in this update.
-		 * This value is bound by sg list limits.
-		 */
-		to_process = min_t(u64, nbytes - processed,
-				   nx_ctx->ap->databytelen);
-		to_process = min_t(u64, to_process,
-				   NX_PAGE_SIZE * (max_sg_len - 1));
-
-		if ((to_process + processed) < nbytes)
-			NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
-		else
-			NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+		to_process = nbytes - processed;
 
 		csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
 		desc.tfm = (struct crypto_blkcipher *) req->base.tfm;
 		rc = nx_build_sg_lists(nx_ctx, &desc, req->dst,
-				       req->src, to_process, processed,
+				       req->src, &to_process, processed,
 				       csbcpb->cpb.aes_gcm.iv_or_cnt);
+
 		if (rc)
 			goto out;
 
+		if ((to_process + processed) < nbytes)
+			NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
+		else
+			NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+
+
 		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
 				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 		if (rc)
-- 
1.7.1

