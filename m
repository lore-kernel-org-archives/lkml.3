Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbaGXOBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:01:51 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:45241 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbaGXOBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:01:47 -0400
Date: Thu, 24 Jul 2014 11:01:42 -0300
From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com
Subject: [PATCH 7/8] Replacing spinlocks by nx_copy_ctx on NX-AES-XCBC
Message-ID: <20140724140139.GA26292@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072414-9564-0000-0000-0000015B9A9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces spinlock usage by a simple copy of the crypto context, avoiding
possible bottlenecks.

Signed-off-by: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-xcbc.c |   51 ++++++++++++++++++++++----------------
 1 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-xcbc.c b/drivers/crypto/nx/nx-aes-xcbc.c
index 03c4bf5..d8a5bdb 100644
--- a/drivers/crypto/nx/nx-aes-xcbc.c
+++ b/drivers/crypto/nx/nx-aes-xcbc.c
@@ -161,11 +161,14 @@ static int nx_xcbc_update(struct shash_desc *desc,
 	struct nx_sg *in_sg;
 	u32 to_process, leftover, total;
 	u32 max_sg_len;
-	unsigned long irq_flags;
 	int rc = 0;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
 
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
+
+	csbcpb = curr_nx_ctx.csbcpb;
 
 	total = sctx->count + len;
 
@@ -179,15 +182,15 @@ static int nx_xcbc_update(struct shash_desc *desc,
 		goto out;
 	}
 
-	in_sg = nx_ctx->in_sg;
+	in_sg = curr_nx_ctx.in_sg;
 	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-				nx_ctx->ap->sglen);
+				curr_nx_ctx.ap->sglen);
 
 	do {
 
 		/* to_process: the AES_BLOCK_SIZE data chunk to process in this
 		 * update */
-		to_process = min_t(u64, total, nx_ctx->ap->databytelen);
+		to_process = min_t(u64, total, curr_nx_ctx.ap->databytelen);
 		to_process = min_t(u64, to_process,
 					NX_PAGE_SIZE * (max_sg_len - 1));
 		to_process = to_process & ~(AES_BLOCK_SIZE - 1);
@@ -204,7 +207,7 @@ static int nx_xcbc_update(struct shash_desc *desc,
 		}
 
 		if (sctx->count) {
-			in_sg = nx_build_sg_list(nx_ctx->in_sg,
+			in_sg = nx_build_sg_list(curr_nx_ctx.in_sg,
 						(u8 *) sctx->buffer,
 						sctx->count,
 						max_sg_len);
@@ -213,7 +216,7 @@ static int nx_xcbc_update(struct shash_desc *desc,
 					(u8 *) data,
 					to_process - sctx->count,
 					max_sg_len);
-		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) *
+		nx_ctx->op.inlen = (curr_nx_ctx.in_sg - in_sg) *
 					sizeof(struct nx_sg);
 
 		/* we've hit the nx chip previously and we're updating again,
@@ -225,12 +228,12 @@ static int nx_xcbc_update(struct shash_desc *desc,
 		}
 
 		NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
-		if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
+		if (!curr_nx_ctx.op.inlen || !curr_nx_ctx.op.outlen) {
 			rc = -EINVAL;
 			goto out;
 		}
 
-		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+		rc = nx_hcall_sync(&curr_nx_ctx, &curr_nx_ctx.op,
 			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 		if (rc)
 			goto out;
@@ -243,7 +246,7 @@ static int nx_xcbc_update(struct shash_desc *desc,
 		total -= to_process;
 		data += to_process - sctx->count;
 		sctx->count = 0;
-		in_sg = nx_ctx->in_sg;
+		in_sg = curr_nx_ctx.in_sg;
 	} while (leftover > AES_BLOCK_SIZE);
 
 	/* copy the leftover back into the state struct */
@@ -251,7 +254,7 @@ static int nx_xcbc_update(struct shash_desc *desc,
 	sctx->count = leftover;
 
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
@@ -261,10 +264,14 @@ static int nx_xcbc_final(struct shash_desc *desc, u8 *out)
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct nx_sg *in_sg, *out_sg;
-	unsigned long irq_flags;
 	int rc = 0;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
+
+	csbcpb = curr_nx_ctx.csbcpb;
 
 	if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
 		/* we've hit the nx chip previously, now we're finalizing,
@@ -285,20 +292,20 @@ static int nx_xcbc_final(struct shash_desc *desc, u8 *out)
 	 * this is not an intermediate operation */
 	NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
 
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *)sctx->buffer,
-				 sctx->count, nx_ctx->ap->sglen);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, out, AES_BLOCK_SIZE,
-				  nx_ctx->ap->sglen);
+	in_sg = nx_build_sg_list(curr_nx_ctx.in_sg, (u8 *)sctx->buffer,
+				 sctx->count, curr_nx_ctx.ap->sglen);
+	out_sg = nx_build_sg_list(curr_nx_ctx.out_sg, out, AES_BLOCK_SIZE,
+				  curr_nx_ctx.ap->sglen);
 
-	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
-	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
+	curr_nx_ctx.op.inlen = (curr_nx_ctx.in_sg - in_sg) * sizeof(struct nx_sg);
+	curr_nx_ctx.op.outlen = (curr_nx_ctx.out_sg - out_sg) * sizeof(struct nx_sg);
 
-	if (!nx_ctx->op.outlen) {
+	if (!curr_nx_ctx.op.outlen) {
 		rc = -EINVAL;
 		goto out;
 	}
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+	rc = nx_hcall_sync(&curr_nx_ctx, &curr_nx_ctx.op,
 			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 	if (rc)
 		goto out;
@@ -307,7 +314,7 @@ static int nx_xcbc_final(struct shash_desc *desc, u8 *out)
 
 	memcpy(out, csbcpb->cpb.aes_xcbc.out_cv_mac, AES_BLOCK_SIZE);
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
-- 
1.7.1

