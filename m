Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab3HWUBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:01:49 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:53205 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3HWUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:01:44 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 05/10] crypto: nx - fix limits to sg lists for AES-GCM
Date: Fri, 23 Aug 2013 17:01:09 -0300
Message-Id: <1377288074-18998-6-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082320-2362-0000-0000-00000B92FEE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the nx-aes-gcm implementation to perform several
hyper calls if needed in order to always respect the length limits for
scatter/gather lists.

Two different limits are considered:

 - "ibm,max-sg-len": maximum number of bytes of each scatter/gather
   list.

 - "ibm,max-sync-cop":
    - The total number of bytes that a scatter/gather list can hold.
    - The maximum number of elements that a scatter/gather list can have.

Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-gcm.c | 202 +++++++++++++++++++++++++++--------------
 1 file changed, 136 insertions(+), 66 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index c2d6f76..9e89bdf 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -125,37 +125,101 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 		  struct aead_request   *req,
 		  u8                    *out)
 {
+	int rc;
 	struct nx_csbcpb *csbcpb_aead = nx_ctx->csbcpb_aead;
-	int rc = -EINVAL;
 	struct scatter_walk walk;
 	struct nx_sg *nx_sg = nx_ctx->in_sg;
+	unsigned int nbytes = req->assoclen;
+	unsigned int processed = 0, to_process;
+	u32 max_sg_len;
 
-	if (req->assoclen > nx_ctx->ap->databytelen)
-		goto out;
-
-	if (req->assoclen <= AES_BLOCK_SIZE) {
+	if (nbytes <= AES_BLOCK_SIZE) {
 		scatterwalk_start(&walk, req->assoc);
-		scatterwalk_copychunks(out, &walk, req->assoclen,
-				       SCATTERWALK_FROM_SG);
+		scatterwalk_copychunks(out, &walk, nbytes, SCATTERWALK_FROM_SG);
 		scatterwalk_done(&walk, SCATTERWALK_FROM_SG, 0);
-
-		rc = 0;
-		goto out;
+		return 0;
 	}
 
-	nx_sg = nx_walk_and_build(nx_sg, nx_ctx->ap->sglen, req->assoc, 0,
-				  req->assoclen);
-	nx_ctx->op_aead.inlen = (nx_ctx->in_sg - nx_sg) * sizeof(struct nx_sg);
+	NX_CPB_FDM(csbcpb_aead) &= ~NX_FDM_CONTINUATION;
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op_aead,
-			   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (rc)
-		goto out;
+	/* page_limit: number of sg entries that fit on one page */
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+			   nx_ctx->ap->sglen);
 
-	atomic_inc(&(nx_ctx->stats->aes_ops));
-	atomic64_add(req->assoclen, &(nx_ctx->stats->aes_bytes));
+	do {
+		/*
+		 * to_process: the data chunk to process in this update.
+		 * This value is bound by sg list limits.
+		 */
+		to_process = min_t(u64, nbytes - processed,
+				   nx_ctx->ap->databytelen);
+		to_process = min_t(u64, to_process,
+				   NX_PAGE_SIZE * (max_sg_len - 1));
+
+		if ((to_process + processed) < nbytes)
+			NX_CPB_FDM(csbcpb_aead) |= NX_FDM_INTERMEDIATE;
+		else
+			NX_CPB_FDM(csbcpb_aead) &= ~NX_FDM_INTERMEDIATE;
+
+		nx_sg = nx_walk_and_build(nx_ctx->in_sg, nx_ctx->ap->sglen,
+					  req->assoc, processed, to_process);
+		nx_ctx->op_aead.inlen = (nx_ctx->in_sg - nx_sg)
+					* sizeof(struct nx_sg);
+
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op_aead,
+				req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		if (rc)
+			return rc;
+
+		memcpy(csbcpb_aead->cpb.aes_gca.in_pat,
+				csbcpb_aead->cpb.aes_gca.out_pat,
+				AES_BLOCK_SIZE);
+		NX_CPB_FDM(csbcpb_aead) |= NX_FDM_CONTINUATION;
+
+		atomic_inc(&(nx_ctx->stats->aes_ops));
+		atomic64_add(req->assoclen, &(nx_ctx->stats->aes_bytes));
+
+		processed += to_process;
+	} while (processed < nbytes);
 
 	memcpy(out, csbcpb_aead->cpb.aes_gca.out_pat, AES_BLOCK_SIZE);
+
+	return rc;
+}
+
+static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
+		     int enc)
+{
+	int rc;
+	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
+	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+
+	/* For scenarios where the input message is zero length, AES CTR mode
+	 * may be used. Set the source data to be a single block (16B) of all
+	 * zeros, and set the input IV value to be the same as the GMAC IV
+	 * value. - nx_wb 4.8.1.3 */
+	char src[AES_BLOCK_SIZE] = {};
+	struct scatterlist sg;
+
+	desc->tfm = crypto_alloc_blkcipher("ctr(aes)", 0, 0);
+	if (IS_ERR(desc->tfm)) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	crypto_blkcipher_setkey(desc->tfm, csbcpb->cpb.aes_gcm.key,
+		NX_CPB_KEY_SIZE(csbcpb) == NX_KS_AES_128 ? 16 :
+		NX_CPB_KEY_SIZE(csbcpb) == NX_KS_AES_192 ? 24 : 32);
+
+	sg_init_one(&sg, src, AES_BLOCK_SIZE);
+	if (enc)
+		rc = crypto_blkcipher_encrypt_iv(desc, req->dst, &sg,
+						 AES_BLOCK_SIZE);
+	else
+		rc = crypto_blkcipher_decrypt_iv(desc, req->dst, &sg,
+						 AES_BLOCK_SIZE);
+	crypto_free_blkcipher(desc->tfm);
+
 out:
 	return rc;
 }
@@ -166,79 +230,85 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct blkcipher_desc desc;
 	unsigned int nbytes = req->cryptlen;
+	unsigned int processed = 0, to_process;
 	unsigned long irq_flags;
+	u32 max_sg_len;
 	int rc = -EINVAL;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	if (nbytes > nx_ctx->ap->databytelen)
-		goto out;
-
 	desc.info = nx_ctx->priv.gcm.iv;
 	/* initialize the counter */
 	*(u32 *)(desc.info + NX_GCM_CTR_OFFSET) = 1;
 
-	/* For scenarios where the input message is zero length, AES CTR mode
-	 * may be used. Set the source data to be a single block (16B) of all
-	 * zeros, and set the input IV value to be the same as the GMAC IV
-	 * value. - nx_wb 4.8.1.3 */
 	if (nbytes == 0) {
-		char src[AES_BLOCK_SIZE] = {};
-		struct scatterlist sg;
-
-		desc.tfm = crypto_alloc_blkcipher("ctr(aes)", 0, 0);
-		if (IS_ERR(desc.tfm)) {
-			rc = -ENOMEM;
-			goto out;
-		}
-
-		crypto_blkcipher_setkey(desc.tfm, csbcpb->cpb.aes_gcm.key,
-			NX_CPB_KEY_SIZE(csbcpb) == NX_KS_AES_128 ? 16 :
-			NX_CPB_KEY_SIZE(csbcpb) == NX_KS_AES_192 ? 24 : 32);
-
-		sg_init_one(&sg, src, AES_BLOCK_SIZE);
-		if (enc)
-			crypto_blkcipher_encrypt_iv(&desc, req->dst, &sg,
-						    AES_BLOCK_SIZE);
-		else
-			crypto_blkcipher_decrypt_iv(&desc, req->dst, &sg,
-						    AES_BLOCK_SIZE);
-		crypto_free_blkcipher(desc.tfm);
-
-		rc = 0;
+		rc = gcm_empty(req, &desc, enc);
 		goto out;
 	}
 
-	desc.tfm = (struct crypto_blkcipher *)req->base.tfm;
-
+	/* Process associated data */
 	csbcpb->cpb.aes_gcm.bit_length_aad = req->assoclen * 8;
-
 	if (req->assoclen) {
 		rc = nx_gca(nx_ctx, req, csbcpb->cpb.aes_gcm.in_pat_or_aad);
 		if (rc)
 			goto out;
 	}
 
-	if (enc)
+	/* Set flags for encryption */
+	NX_CPB_FDM(csbcpb) &= ~NX_FDM_CONTINUATION;
+	if (enc) {
 		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
-	else
+	} else {
+		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 		nbytes -= crypto_aead_authsize(crypto_aead_reqtfm(req));
+	}
 
-	csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
+	/* page_limit: number of sg entries that fit on one page */
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+			   nx_ctx->ap->sglen);
 
-	rc = nx_build_sg_lists(nx_ctx, &desc, req->dst, req->src, nbytes, 0,
-			       csbcpb->cpb.aes_gcm.iv_or_cnt);
-	if (rc)
-		goto out;
+	do {
+		/*
+		 * to_process: the data chunk to process in this update.
+		 * This value is bound by sg list limits.
+		 */
+		to_process = min_t(u64, nbytes - processed,
+				   nx_ctx->ap->databytelen);
+		to_process = min_t(u64, to_process,
+				   NX_PAGE_SIZE * (max_sg_len - 1));
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (rc)
-		goto out;
+		if ((to_process + processed) < nbytes)
+			NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
+		else
+			NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
 
-	atomic_inc(&(nx_ctx->stats->aes_ops));
-	atomic64_add(csbcpb->csb.processed_byte_count,
-		     &(nx_ctx->stats->aes_bytes));
+		csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
+		desc.tfm = (struct crypto_blkcipher *) req->base.tfm;
+		rc = nx_build_sg_lists(nx_ctx, &desc, req->dst,
+				       req->src, to_process, processed,
+				       csbcpb->cpb.aes_gcm.iv_or_cnt);
+		if (rc)
+			goto out;
+
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		if (rc)
+			goto out;
+
+		memcpy(desc.info, csbcpb->cpb.aes_gcm.out_cnt, AES_BLOCK_SIZE);
+		memcpy(csbcpb->cpb.aes_gcm.in_pat_or_aad,
+			csbcpb->cpb.aes_gcm.out_pat_or_mac, AES_BLOCK_SIZE);
+		memcpy(csbcpb->cpb.aes_gcm.in_s0,
+			csbcpb->cpb.aes_gcm.out_s0, AES_BLOCK_SIZE);
+
+		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
+
+		atomic_inc(&(nx_ctx->stats->aes_ops));
+		atomic64_add(csbcpb->csb.processed_byte_count,
+			     &(nx_ctx->stats->aes_bytes));
+
+		processed += to_process;
+	} while (processed < nbytes);
 
 	if (enc) {
 		/* copy out the auth tag */
-- 
1.7.12

