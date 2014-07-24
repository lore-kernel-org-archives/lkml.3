Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbaGXOAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:00:35 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:55835 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945AbaGXOAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:00:33 -0400
Date: Thu, 24 Jul 2014 11:00:29 -0300
From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com
Subject: [PATCH 6/8] Replacing spinlocks by nx_copy_ctx on NX-AES-GCM
Message-ID: <20140724140023.GA26022@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072414-2194-0000-0000-000000182087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces spinlock usage by a simple copy of the crypto context, avoiding
possible bottlenecks.

Signed-off-by: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-gcm.c |   64 ++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 025d9a8..6b212a9 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -187,11 +187,12 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 	return rc;
 }
 
-static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
+static int gmac(struct aead_request *req, struct blkcipher_desc *desc,
+	struct nx_crypto_ctx *curr_nx_ctx)
 {
 	int rc;
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
-	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+	struct nx_csbcpb *csbcpb = curr_nx_ctx->csbcpb;
 	struct nx_sg *nx_sg;
 	unsigned int nbytes = req->assoclen;
 	unsigned int processed = 0, to_process;
@@ -204,7 +205,7 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
 
 	/* page_limit: number of sg entries that fit on one page */
 	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
+			   curr_nx_ctx->ap->sglen);
 
 	/* Copy IV */
 	memcpy(csbcpb->cpb.aes_gcm.iv_or_cnt, desc->info, AES_BLOCK_SIZE);
@@ -215,7 +216,7 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
 		 * This value is bound by sg list limits.
 		 */
 		to_process = min_t(u64, nbytes - processed,
-				   nx_ctx->ap->databytelen);
+				   curr_nx_ctx->ap->databytelen);
 		to_process = min_t(u64, to_process,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 
@@ -224,15 +225,15 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
 		else
 			NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
 
-		nx_sg = nx_walk_and_build(nx_ctx->in_sg, nx_ctx->ap->sglen,
+		nx_sg = nx_walk_and_build(curr_nx_ctx->in_sg, curr_nx_ctx->ap->sglen,
 					  req->assoc, processed, to_process);
-		nx_ctx->op.inlen = (nx_ctx->in_sg - nx_sg)
+		curr_nx_ctx->op.inlen = (curr_nx_ctx->in_sg - nx_sg)
 					* sizeof(struct nx_sg);
 
 		csbcpb->cpb.aes_gcm.bit_length_data = 0;
 		csbcpb->cpb.aes_gcm.bit_length_aad = 8 * nbytes;
 
-		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+		rc = nx_hcall_sync(curr_nx_ctx, &curr_nx_ctx->op,
 				req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 		if (rc)
 			goto out;
@@ -257,14 +258,15 @@ out:
 }
 
 static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
-		     int enc)
+		     int enc, struct nx_crypto_ctx *curr_nx_ctx)
 {
 	int rc;
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
-	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+	struct nx_csbcpb *csbcpb = curr_nx_ctx->csbcpb;
 	char out[AES_BLOCK_SIZE];
 	struct nx_sg *in_sg, *out_sg;
 
+
 	/* For scenarios where the input message is zero length, AES CTR mode
 	 * may be used. Set the source data to be a single block (16B) of all
 	 * zeros, and set the input IV value to be the same as the GMAC IV
@@ -280,14 +282,14 @@ static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
 		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
 	/* Encrypt the counter/IV */
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) desc->info,
-				 AES_BLOCK_SIZE, nx_ctx->ap->sglen);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *) out, sizeof(out),
-				  nx_ctx->ap->sglen);
-	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
-	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
-
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+	in_sg = nx_build_sg_list(curr_nx_ctx->in_sg, (u8 *) desc->info,
+				 AES_BLOCK_SIZE, curr_nx_ctx->ap->sglen);
+	out_sg = nx_build_sg_list(curr_nx_ctx->out_sg, (u8 *) out, sizeof(out),
+				  curr_nx_ctx->ap->sglen);
+	curr_nx_ctx->op.inlen = (curr_nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
+	curr_nx_ctx->op.outlen = (curr_nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
+
+	rc = nx_hcall_sync(curr_nx_ctx, &curr_nx_ctx->op,
 			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 	if (rc)
 		goto out;
@@ -316,21 +318,25 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 	struct blkcipher_desc desc;
 	unsigned int nbytes = req->cryptlen;
 	unsigned int processed = 0, to_process;
-	unsigned long irq_flags;
 	u32 max_sg_len;
 	int rc = -EINVAL;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
+
+	csbcpb = curr_nx_ctx.csbcpb;
 
-	desc.info = nx_ctx->priv.gcm.iv;
+	desc.info = curr_nx_ctx.priv.gcm.iv;
 	/* initialize the counter */
 	*(u32 *)(desc.info + NX_GCM_CTR_OFFSET) = 1;
 
 	if (nbytes == 0) {
 		if (req->assoclen == 0)
-			rc = gcm_empty(req, &desc, enc);
+			rc = gcm_empty(req, &desc, enc, &curr_nx_ctx);
 		else
-			rc = gmac(req, &desc);
+			rc = gmac(req, &desc, &curr_nx_ctx);
 		if (rc)
 			goto out;
 		else
@@ -340,7 +346,7 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 	/* Process associated data */
 	csbcpb->cpb.aes_gcm.bit_length_aad = req->assoclen * 8;
 	if (req->assoclen) {
-		rc = nx_gca(nx_ctx, req, csbcpb->cpb.aes_gcm.in_pat_or_aad);
+		rc = nx_gca(&curr_nx_ctx, req, csbcpb->cpb.aes_gcm.in_pat_or_aad);
 		if (rc)
 			goto out;
 	}
@@ -356,7 +362,7 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 
 	/* page_limit: number of sg entries that fit on one page */
 	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
+			   curr_nx_ctx.ap->sglen);
 
 	do {
 		/*
@@ -364,7 +370,7 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 		 * This value is bound by sg list limits.
 		 */
 		to_process = min_t(u64, nbytes - processed,
-				   nx_ctx->ap->databytelen);
+				   curr_nx_ctx.ap->databytelen);
 		to_process = min_t(u64, to_process,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 
@@ -375,13 +381,13 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 
 		csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
 		desc.tfm = (struct crypto_blkcipher *) req->base.tfm;
-		rc = nx_build_sg_lists(nx_ctx, &desc, req->dst,
+		rc = nx_build_sg_lists(&curr_nx_ctx, &desc, req->dst,
 				       req->src, to_process, processed,
 				       csbcpb->cpb.aes_gcm.iv_or_cnt);
 		if (rc)
 			goto out;
 
-		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+		rc = nx_hcall_sync(&curr_nx_ctx, &curr_nx_ctx.op,
 				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 		if (rc)
 			goto out;
@@ -409,7 +415,7 @@ mac:
 				 crypto_aead_authsize(crypto_aead_reqtfm(req)),
 				 SCATTERWALK_TO_SG);
 	} else {
-		u8 *itag = nx_ctx->priv.gcm.iauth_tag;
+		u8 *itag = curr_nx_ctx.priv.gcm.iauth_tag;
 		u8 *otag = csbcpb->cpb.aes_gcm.out_pat_or_mac;
 
 		scatterwalk_map_and_copy(itag, req->src, nbytes,
@@ -420,7 +426,7 @@ mac:
 		     -EBADMSG : 0;
 	}
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
-- 
1.7.1

