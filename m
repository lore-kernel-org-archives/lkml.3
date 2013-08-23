Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3HWUBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:01:53 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:53232 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3HWUBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:01:50 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 09/10] crypto: nx - fix GCM for zero length messages
Date: Fri, 23 Aug 2013 17:01:13 -0300
Message-Id: <1377288074-18998-10-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082320-2362-0000-0000-00000B92FEF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NX CGM implementation doesn't support zero length messages and the
current implementation has two flaws:

 - When the input data length is zero, it ignores the associated data.
 - Even when both lengths are zero, it uses the Crypto API to encrypt a
   zeroed block using ctr(aes) and because of this it allocates a new
   transformation and sets the key for this new tfm. Both operations are
   intended to be used only in user context, while the cryptographic
   operations can be called in both user and softirq contexts.

This patch replaces the nested Crypto API use and adds two special
cases:

 - When input data and associated data lengths are zero: it uses NX ECB
   mode to emulate the encryption of a zeroed block using ctr(aes).
 - When input data is zero and associated data is available: it uses NX
   GMAC mode to calculate the associated data MAC.

Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-gcm.c | 132 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 112 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 9e89bdf..025d9a8 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -187,40 +187,125 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 	return rc;
 }
 
+static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
+{
+	int rc;
+	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
+	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+	struct nx_sg *nx_sg;
+	unsigned int nbytes = req->assoclen;
+	unsigned int processed = 0, to_process;
+	u32 max_sg_len;
+
+	/* Set GMAC mode */
+	csbcpb->cpb.hdr.mode = NX_MODE_AES_GMAC;
+
+	NX_CPB_FDM(csbcpb) &= ~NX_FDM_CONTINUATION;
+
+	/* page_limit: number of sg entries that fit on one page */
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+			   nx_ctx->ap->sglen);
+
+	/* Copy IV */
+	memcpy(csbcpb->cpb.aes_gcm.iv_or_cnt, desc->info, AES_BLOCK_SIZE);
+
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
+			NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
+		else
+			NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+
+		nx_sg = nx_walk_and_build(nx_ctx->in_sg, nx_ctx->ap->sglen,
+					  req->assoc, processed, to_process);
+		nx_ctx->op.inlen = (nx_ctx->in_sg - nx_sg)
+					* sizeof(struct nx_sg);
+
+		csbcpb->cpb.aes_gcm.bit_length_data = 0;
+		csbcpb->cpb.aes_gcm.bit_length_aad = 8 * nbytes;
+
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+				req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		if (rc)
+			goto out;
+
+		memcpy(csbcpb->cpb.aes_gcm.in_pat_or_aad,
+			csbcpb->cpb.aes_gcm.out_pat_or_mac, AES_BLOCK_SIZE);
+		memcpy(csbcpb->cpb.aes_gcm.in_s0,
+			csbcpb->cpb.aes_gcm.out_s0, AES_BLOCK_SIZE);
+
+		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
+
+		atomic_inc(&(nx_ctx->stats->aes_ops));
+		atomic64_add(req->assoclen, &(nx_ctx->stats->aes_bytes));
+
+		processed += to_process;
+	} while (processed < nbytes);
+
+out:
+	/* Restore GCM mode */
+	csbcpb->cpb.hdr.mode = NX_MODE_AES_GCM;
+	return rc;
+}
+
 static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
 		     int enc)
 {
 	int rc;
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+	char out[AES_BLOCK_SIZE];
+	struct nx_sg *in_sg, *out_sg;
 
 	/* For scenarios where the input message is zero length, AES CTR mode
 	 * may be used. Set the source data to be a single block (16B) of all
 	 * zeros, and set the input IV value to be the same as the GMAC IV
 	 * value. - nx_wb 4.8.1.3 */
-	char src[AES_BLOCK_SIZE] = {};
-	struct scatterlist sg;
 
-	desc->tfm = crypto_alloc_blkcipher("ctr(aes)", 0, 0);
-	if (IS_ERR(desc->tfm)) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	crypto_blkcipher_setkey(desc->tfm, csbcpb->cpb.aes_gcm.key,
-		NX_CPB_KEY_SIZE(csbcpb) == NX_KS_AES_128 ? 16 :
-		NX_CPB_KEY_SIZE(csbcpb) == NX_KS_AES_192 ? 24 : 32);
-
-	sg_init_one(&sg, src, AES_BLOCK_SIZE);
+	/* Change to ECB mode */
+	csbcpb->cpb.hdr.mode = NX_MODE_AES_ECB;
+	memcpy(csbcpb->cpb.aes_ecb.key, csbcpb->cpb.aes_gcm.key,
+			sizeof(csbcpb->cpb.aes_ecb.key));
 	if (enc)
-		rc = crypto_blkcipher_encrypt_iv(desc, req->dst, &sg,
-						 AES_BLOCK_SIZE);
+		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 	else
-		rc = crypto_blkcipher_decrypt_iv(desc, req->dst, &sg,
-						 AES_BLOCK_SIZE);
-	crypto_free_blkcipher(desc->tfm);
+		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
+	/* Encrypt the counter/IV */
+	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) desc->info,
+				 AES_BLOCK_SIZE, nx_ctx->ap->sglen);
+	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *) out, sizeof(out),
+				  nx_ctx->ap->sglen);
+	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
+	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
+
+	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+	if (rc)
+		goto out;
+	atomic_inc(&(nx_ctx->stats->aes_ops));
+
+	/* Copy out the auth tag */
+	memcpy(csbcpb->cpb.aes_gcm.out_pat_or_mac, out,
+			crypto_aead_authsize(crypto_aead_reqtfm(req)));
 out:
+	/* Restore XCBC mode */
+	csbcpb->cpb.hdr.mode = NX_MODE_AES_GCM;
+
+	/*
+	 * ECB key uses the same region that GCM AAD and counter, so it's safe
+	 * to just fill it with zeroes.
+	 */
+	memset(csbcpb->cpb.aes_ecb.key, 0, sizeof(csbcpb->cpb.aes_ecb.key));
+
 	return rc;
 }
 
@@ -242,8 +327,14 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 	*(u32 *)(desc.info + NX_GCM_CTR_OFFSET) = 1;
 
 	if (nbytes == 0) {
-		rc = gcm_empty(req, &desc, enc);
-		goto out;
+		if (req->assoclen == 0)
+			rc = gcm_empty(req, &desc, enc);
+		else
+			rc = gmac(req, &desc);
+		if (rc)
+			goto out;
+		else
+			goto mac;
 	}
 
 	/* Process associated data */
@@ -310,6 +401,7 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 		processed += to_process;
 	} while (processed < nbytes);
 
+mac:
 	if (enc) {
 		/* copy out the auth tag */
 		scatterwalk_map_and_copy(csbcpb->cpb.aes_gcm.out_pat_or_mac,
-- 
1.7.12

