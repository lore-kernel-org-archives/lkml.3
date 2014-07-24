Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbaGXNyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:54:16 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:34858 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758957AbaGXNyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:54:12 -0400
Date: Thu, 24 Jul 2014 10:54:08 -0300
From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com
Subject: [PATCH 3/8] Replacing spinlocks by nx_copy_ctx on NX-AES-CCM
Message-ID: <20140724135405.GA24841@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072413-1524-0000-0000-000000120E10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces spinlock usage by a simple copy of the crypto context, avoiding
possible bottlenecks.

Signed-off-by: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-ccm.c |   42 +++++++++++++++++++++++----------------
 1 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index 5ecd4c2..f1000ad 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -341,12 +341,16 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 	unsigned int nbytes = req->cryptlen;
 	unsigned int authsize = crypto_aead_authsize(crypto_aead_reqtfm(req));
 	struct nx_ccm_priv *priv = &nx_ctx->priv.ccm;
-	unsigned long irq_flags;
 	unsigned int processed = 0, to_process;
 	u32 max_sg_len;
 	int rc = -1;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
+
+	csbcpb = curr_nx_ctx.csbcpb;	
 
 	nbytes -= authsize;
 
@@ -355,14 +359,14 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 				 req->src, nbytes, authsize,
 				 SCATTERWALK_FROM_SG);
 
-	rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes,
+	rc = generate_pat(desc->info, req, &curr_nx_ctx, authsize, nbytes,
 			  csbcpb->cpb.aes_ccm.in_pat_or_b0);
 	if (rc)
 		goto out;
 
 	/* page_limit: number of sg entries that fit on one page */
 	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
+			   curr_nx_ctx.ap->sglen);
 
 	do {
 
@@ -370,7 +374,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 		 * update. This value is bound by sg list limits.
 		 */
 		to_process = min_t(u64, nbytes - processed,
-				   nx_ctx->ap->databytelen);
+				   curr_nx_ctx.ap->databytelen);
 		to_process = min_t(u64, to_process,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 
@@ -379,15 +383,15 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 		else
 			NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
 
-		NX_CPB_FDM(nx_ctx->csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
+		NX_CPB_FDM(curr_nx_ctx.csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
-		rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
+		rc = nx_build_sg_lists(&curr_nx_ctx, desc, req->dst, req->src,
 					to_process, processed,
 					csbcpb->cpb.aes_ccm.iv_or_ctr);
 		if (rc)
 			goto out;
 
-		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+		rc = nx_hcall_sync(&curr_nx_ctx, &curr_nx_ctx.op,
 			   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 		if (rc)
 			goto out;
@@ -414,7 +418,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 	rc = memcmp(csbcpb->cpb.aes_ccm.out_pat_or_mac, priv->oauth_tag,
 		    authsize) ? -EBADMSG : 0;
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
@@ -425,28 +429,32 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	unsigned int nbytes = req->cryptlen;
 	unsigned int authsize = crypto_aead_authsize(crypto_aead_reqtfm(req));
-	unsigned long irq_flags;
 	unsigned int processed = 0, to_process;
 	u32 max_sg_len;
 	int rc = -1;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+	
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
 
-	rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes,
+	csbcpb = curr_nx_ctx.csbcpb;
+
+	rc = generate_pat(desc->info, req, &curr_nx_ctx, authsize, nbytes,
 			  csbcpb->cpb.aes_ccm.in_pat_or_b0);
 	if (rc)
 		goto out;
 
 	/* page_limit: number of sg entries that fit on one page */
 	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
+			   curr_nx_ctx.ap->sglen);
 
 	do {
 		/* to process: the AES_BLOCK_SIZE data chunk to process in this
 		 * update. This value is bound by sg list limits.
 		 */
 		to_process = min_t(u64, nbytes - processed,
-				   nx_ctx->ap->databytelen);
+				   curr_nx_ctx.ap->databytelen);
 		to_process = min_t(u64, to_process,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 
@@ -457,13 +465,13 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 
 		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 
-		rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
+		rc = nx_build_sg_lists(&curr_nx_ctx, desc, req->dst, req->src,
 					to_process, processed,
 				       csbcpb->cpb.aes_ccm.iv_or_ctr);
 		if (rc)
 			goto out;
 
-		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+		rc = nx_hcall_sync(&curr_nx_ctx, &curr_nx_ctx.op,
 				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 		if (rc)
 			goto out;
@@ -494,7 +502,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 				 SCATTERWALK_TO_SG);
 
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
-- 
1.7.1

