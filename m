Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3HWUCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:02:50 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:53220 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab3HWUBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:01:47 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>,
        Joy Latten <jmlatten@linux.vnet.ibm.com>
Subject: [PATCH 07/10] crypto: nx - fix limits to sg lists for AES-CCM
Date: Fri, 23 Aug 2013 17:01:11 -0300
Message-Id: <1377288074-18998-8-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082320-2362-0000-0000-00000B92FEED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fionnuala Gunter <fin@linux.vnet.ibm.com>

This patch updates the NX driver to perform several hyper calls when necessary
so that the length limits of scatter/gather lists are respected.

Reviewed-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Signed-off-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-ccm.c | 297 +++++++++++++++++++++++++++++------------
 1 file changed, 215 insertions(+), 82 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index 666a35b..5ecd4c2 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -179,13 +179,26 @@ static int generate_pat(u8                   *iv,
 	struct nx_sg *nx_insg = nx_ctx->in_sg;
 	struct nx_sg *nx_outsg = nx_ctx->out_sg;
 	unsigned int iauth_len = 0;
-	struct vio_pfo_op *op = NULL;
 	u8 tmp[16], *b1 = NULL, *b0 = NULL, *result = NULL;
 	int rc;
 
 	/* zero the ctr value */
 	memset(iv + 15 - iv[0], 0, iv[0] + 1);
 
+	/* page 78 of nx_wb.pdf has,
+	 * Note: RFC3610 allows the AAD data to be up to 2^64 -1 bytes
+	 * in length. If a full message is used, the AES CCA implementation
+	 * restricts the maximum AAD length to 2^32 -1 bytes.
+	 * If partial messages are used, the implementation supports
+	 * 2^64 -1 bytes maximum AAD length.
+	 *
+	 * However, in the cryptoapi's aead_request structure,
+	 * assoclen is an unsigned int, thus it cannot hold a length
+	 * value greater than 2^32 - 1.
+	 * Thus the AAD is further constrained by this and is never
+	 * greater than 2^32.
+	 */
+
 	if (!req->assoclen) {
 		b0 = nx_ctx->csbcpb->cpb.aes_ccm.in_pat_or_b0;
 	} else if (req->assoclen <= 14) {
@@ -195,7 +208,46 @@ static int generate_pat(u8                   *iv,
 		b0 = nx_ctx->csbcpb->cpb.aes_ccm.in_pat_or_b0;
 		b1 = nx_ctx->priv.ccm.iauth_tag;
 		iauth_len = req->assoclen;
+	} else if (req->assoclen <= 65280) {
+		/* if associated data is less than (2^16 - 2^8), we construct
+		 * B1 differently and feed in the associated data to a CCA
+		 * operation */
+		b0 = nx_ctx->csbcpb_aead->cpb.aes_cca.b0;
+		b1 = nx_ctx->csbcpb_aead->cpb.aes_cca.b1;
+		iauth_len = 14;
+	} else {
+		b0 = nx_ctx->csbcpb_aead->cpb.aes_cca.b0;
+		b1 = nx_ctx->csbcpb_aead->cpb.aes_cca.b1;
+		iauth_len = 10;
+	}
 
+	/* generate B0 */
+	rc = generate_b0(iv, req->assoclen, authsize, nbytes, b0);
+	if (rc)
+		return rc;
+
+	/* generate B1:
+	 * add control info for associated data
+	 * RFC 3610 and NIST Special Publication 800-38C
+	 */
+	if (b1) {
+		memset(b1, 0, 16);
+		if (req->assoclen <= 65280) {
+			*(u16 *)b1 = (u16)req->assoclen;
+			scatterwalk_map_and_copy(b1 + 2, req->assoc, 0,
+					 iauth_len, SCATTERWALK_FROM_SG);
+		} else {
+			*(u16 *)b1 = (u16)(0xfffe);
+			*(u32 *)&b1[2] = (u32)req->assoclen;
+			scatterwalk_map_and_copy(b1 + 6, req->assoc, 0,
+					 iauth_len, SCATTERWALK_FROM_SG);
+		}
+	}
+
+	/* now copy any remaining AAD to scatterlist and call nx... */
+	if (!req->assoclen) {
+		return rc;
+	} else if (req->assoclen <= 14) {
 		nx_insg = nx_build_sg_list(nx_insg, b1, 16, nx_ctx->ap->sglen);
 		nx_outsg = nx_build_sg_list(nx_outsg, tmp, 16,
 					    nx_ctx->ap->sglen);
@@ -210,56 +262,74 @@ static int generate_pat(u8                   *iv,
 		NX_CPB_FDM(nx_ctx->csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 		NX_CPB_FDM(nx_ctx->csbcpb) |= NX_FDM_INTERMEDIATE;
 
-		op = &nx_ctx->op;
 		result = nx_ctx->csbcpb->cpb.aes_ccm.out_pat_or_mac;
-	} else if (req->assoclen <= 65280) {
-		/* if associated data is less than (2^16 - 2^8), we construct
-		 * B1 differently and feed in the associated data to a CCA
-		 * operation */
-		b0 = nx_ctx->csbcpb_aead->cpb.aes_cca.b0;
-		b1 = nx_ctx->csbcpb_aead->cpb.aes_cca.b1;
-		iauth_len = 14;
-
-		/* remaining assoc data must have scatterlist built for it */
-		nx_insg = nx_walk_and_build(nx_insg, nx_ctx->ap->sglen,
-					    req->assoc, iauth_len,
-					    req->assoclen - iauth_len);
-		nx_ctx->op_aead.inlen = (nx_ctx->in_sg - nx_insg) *
+
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		if (rc)
+			return rc;
+
+		atomic_inc(&(nx_ctx->stats->aes_ops));
+		atomic64_add(req->assoclen, &(nx_ctx->stats->aes_bytes));
+
+	} else {
+		u32 max_sg_len;
+		unsigned int processed = 0, to_process;
+
+		/* page_limit: number of sg entries that fit on one page */
+		max_sg_len = min_t(u32,
+				   nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+				   nx_ctx->ap->sglen);
+
+		processed += iauth_len;
+
+		do {
+			to_process = min_t(u32, req->assoclen - processed,
+					   nx_ctx->ap->databytelen);
+			to_process = min_t(u64, to_process,
+					   NX_PAGE_SIZE * (max_sg_len - 1));
+
+			if ((to_process + processed) < req->assoclen) {
+				NX_CPB_FDM(nx_ctx->csbcpb_aead) |=
+					NX_FDM_INTERMEDIATE;
+			} else {
+				NX_CPB_FDM(nx_ctx->csbcpb_aead) &=
+					~NX_FDM_INTERMEDIATE;
+			}
+
+			nx_insg = nx_walk_and_build(nx_ctx->in_sg,
+						    nx_ctx->ap->sglen,
+						    req->assoc, processed,
+						    to_process);
+
+			nx_ctx->op_aead.inlen = (nx_ctx->in_sg - nx_insg) *
 						sizeof(struct nx_sg);
 
-		op = &nx_ctx->op_aead;
+			result = nx_ctx->csbcpb_aead->cpb.aes_cca.out_pat_or_b0;
+
+			rc = nx_hcall_sync(nx_ctx, &nx_ctx->op_aead,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+			if (rc)
+				return rc;
+
+			memcpy(nx_ctx->csbcpb_aead->cpb.aes_cca.b0,
+				nx_ctx->csbcpb_aead->cpb.aes_cca.out_pat_or_b0,
+				AES_BLOCK_SIZE);
+
+			NX_CPB_FDM(nx_ctx->csbcpb_aead) |= NX_FDM_CONTINUATION;
+
+			atomic_inc(&(nx_ctx->stats->aes_ops));
+			atomic64_add(req->assoclen,
+					&(nx_ctx->stats->aes_bytes));
+
+			processed += to_process;
+		} while (processed < req->assoclen);
+
 		result = nx_ctx->csbcpb_aead->cpb.aes_cca.out_pat_or_b0;
-	} else {
-		/* if associated data is less than (2^32), we construct B1
-		 * differently yet again and feed in the associated data to a
-		 * CCA operation */
-		pr_err("associated data len is %u bytes (returning -EINVAL)\n",
-		       req->assoclen);
-		rc = -EINVAL;
 	}
 
-	rc = generate_b0(iv, req->assoclen, authsize, nbytes, b0);
-	if (rc)
-		goto done;
+	memcpy(out, result, AES_BLOCK_SIZE);
 
-	if (b1) {
-		memset(b1, 0, 16);
-		*(u16 *)b1 = (u16)req->assoclen;
-
-		scatterwalk_map_and_copy(b1 + 2, req->assoc, 0,
-					 iauth_len, SCATTERWALK_FROM_SG);
-
-		rc = nx_hcall_sync(nx_ctx, op,
-				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
-		if (rc)
-			goto done;
-
-		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(req->assoclen, &(nx_ctx->stats->aes_bytes));
-
-		memcpy(out, result, AES_BLOCK_SIZE);
-	}
-done:
 	return rc;
 }
 
@@ -272,15 +342,12 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 	unsigned int authsize = crypto_aead_authsize(crypto_aead_reqtfm(req));
 	struct nx_ccm_priv *priv = &nx_ctx->priv.ccm;
 	unsigned long irq_flags;
+	unsigned int processed = 0, to_process;
+	u32 max_sg_len;
 	int rc = -1;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	if (nbytes > nx_ctx->ap->databytelen) {
-		rc = -EINVAL;
-		goto out;
-	}
-
 	nbytes -= authsize;
 
 	/* copy out the auth tag to compare with later */
@@ -293,22 +360,56 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 	if (rc)
 		goto out;
 
-	rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src, nbytes, 0,
-			       csbcpb->cpb.aes_ccm.iv_or_ctr);
-	if (rc)
-		goto out;
+	/* page_limit: number of sg entries that fit on one page */
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+			   nx_ctx->ap->sglen);
 
-	NX_CPB_FDM(nx_ctx->csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
-	NX_CPB_FDM(nx_ctx->csbcpb) &= ~NX_FDM_INTERMEDIATE;
+	do {
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+		/* to_process: the AES_BLOCK_SIZE data chunk to process in this
+		 * update. This value is bound by sg list limits.
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
+		NX_CPB_FDM(nx_ctx->csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
+
+		rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
+					to_process, processed,
+					csbcpb->cpb.aes_ccm.iv_or_ctr);
+		if (rc)
+			goto out;
+
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
 			   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (rc)
-		goto out;
+		if (rc)
+			goto out;
 
-	atomic_inc(&(nx_ctx->stats->aes_ops));
-	atomic64_add(csbcpb->csb.processed_byte_count,
-		     &(nx_ctx->stats->aes_bytes));
+		/* for partial completion, copy following for next
+		 * entry into loop...
+		 */
+		memcpy(desc->info, csbcpb->cpb.aes_ccm.out_ctr, AES_BLOCK_SIZE);
+		memcpy(csbcpb->cpb.aes_ccm.in_pat_or_b0,
+			csbcpb->cpb.aes_ccm.out_pat_or_mac, AES_BLOCK_SIZE);
+		memcpy(csbcpb->cpb.aes_ccm.in_s0,
+			csbcpb->cpb.aes_ccm.out_s0, AES_BLOCK_SIZE);
+
+		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
+
+		/* update stats */
+		atomic_inc(&(nx_ctx->stats->aes_ops));
+		atomic64_add(csbcpb->csb.processed_byte_count,
+			     &(nx_ctx->stats->aes_bytes));
+
+		processed += to_process;
+	} while (processed < nbytes);
 
 	rc = memcmp(csbcpb->cpb.aes_ccm.out_pat_or_mac, priv->oauth_tag,
 		    authsize) ? -EBADMSG : 0;
@@ -325,41 +426,73 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 	unsigned int nbytes = req->cryptlen;
 	unsigned int authsize = crypto_aead_authsize(crypto_aead_reqtfm(req));
 	unsigned long irq_flags;
+	unsigned int processed = 0, to_process;
+	u32 max_sg_len;
 	int rc = -1;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	if (nbytes > nx_ctx->ap->databytelen) {
-		rc = -EINVAL;
-		goto out;
-	}
-
 	rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes,
 			  csbcpb->cpb.aes_ccm.in_pat_or_b0);
 	if (rc)
 		goto out;
 
-	rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src, nbytes, 0,
-			       csbcpb->cpb.aes_ccm.iv_or_ctr);
-	if (rc)
-		goto out;
-
-	NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
-	NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
-
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (rc)
-		goto out;
-
-	atomic_inc(&(nx_ctx->stats->aes_ops));
-	atomic64_add(csbcpb->csb.processed_byte_count,
-		     &(nx_ctx->stats->aes_bytes));
+	/* page_limit: number of sg entries that fit on one page */
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+			   nx_ctx->ap->sglen);
+
+	do {
+		/* to process: the AES_BLOCK_SIZE data chunk to process in this
+		 * update. This value is bound by sg list limits.
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
+		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
+
+		rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
+					to_process, processed,
+				       csbcpb->cpb.aes_ccm.iv_or_ctr);
+		if (rc)
+			goto out;
+
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		if (rc)
+			goto out;
+
+		/* for partial completion, copy following for next
+		 * entry into loop...
+		 */
+		memcpy(desc->info, csbcpb->cpb.aes_ccm.out_ctr, AES_BLOCK_SIZE);
+		memcpy(csbcpb->cpb.aes_ccm.in_pat_or_b0,
+			csbcpb->cpb.aes_ccm.out_pat_or_mac, AES_BLOCK_SIZE);
+		memcpy(csbcpb->cpb.aes_ccm.in_s0,
+			csbcpb->cpb.aes_ccm.out_s0, AES_BLOCK_SIZE);
+
+		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
+
+		/* update stats */
+		atomic_inc(&(nx_ctx->stats->aes_ops));
+		atomic64_add(csbcpb->csb.processed_byte_count,
+			     &(nx_ctx->stats->aes_bytes));
+
+		processed += to_process;
+
+	} while (processed < nbytes);
 
 	/* copy out the auth tag */
 	scatterwalk_map_and_copy(csbcpb->cpb.aes_ccm.out_pat_or_mac,
 				 req->dst, nbytes, authsize,
 				 SCATTERWALK_TO_SG);
+
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
-- 
1.7.12

