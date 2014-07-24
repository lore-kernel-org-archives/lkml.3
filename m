Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbaGXOCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:02:52 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:56740 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758852AbaGXOCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:02:50 -0400
Date: Thu, 24 Jul 2014 11:02:45 -0300
From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com
Subject: [PATCH 8/8] Replacing spinlocks by nx_copy_ctx on NX-SHA256 and
 NX-SHA512
Message-ID: <20140724140243.GA26496@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072414-1820-0000-0000-0000011B8C61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces spinlock usage by a simple copy of the crypto context, avoiding
possible bottlenecks.

Signed-off-by: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-sha256.c |   70 +++++++++++++++++++++++++----------------
 drivers/crypto/nx/nx-sha512.c |   70 +++++++++++++++++++++++++----------------
 2 files changed, 86 insertions(+), 54 deletions(-)

diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
index da0b24a..3182e9f 100644
--- a/drivers/crypto/nx/nx-sha256.c
+++ b/drivers/crypto/nx/nx-sha256.c
@@ -57,10 +57,14 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 	struct nx_sg *in_sg;
 	u64 to_process, leftover, total;
 	u32 max_sg_len;
-	unsigned long irq_flags;
 	int rc = 0;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
+
+	csbcpb = curr_nx_ctx.csbcpb;
 
 	/* 2 cases for total data len:
 	 *  1: < SHA256_BLOCK_SIZE: copy into state, return 0
@@ -73,9 +77,9 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 		goto out;
 	}
 
-	in_sg = nx_ctx->in_sg;
+	in_sg = curr_nx_ctx.in_sg;
 	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
+			   curr_nx_ctx.ap->sglen);
 
 	do {
 		/*
@@ -83,21 +87,21 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 		 * this update. This value is also restricted by the sg list
 		 * limits.
 		 */
-		to_process = min_t(u64, total, nx_ctx->ap->databytelen);
+		to_process = min_t(u64, total, curr_nx_ctx.ap->databytelen);
 		to_process = min_t(u64, to_process,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 		to_process = to_process & ~(SHA256_BLOCK_SIZE - 1);
 		leftover = total - to_process;
 
 		if (sctx->count) {
-			in_sg = nx_build_sg_list(nx_ctx->in_sg,
+			in_sg = nx_build_sg_list(curr_nx_ctx.in_sg,
 						 (u8 *) sctx->buf,
 						 sctx->count, max_sg_len);
 		}
 		in_sg = nx_build_sg_list(in_sg, (u8 *) data,
 					 to_process - sctx->count,
 					 max_sg_len);
-		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) *
+		curr_nx_ctx.op.inlen = (curr_nx_ctx.in_sg - in_sg) *
 					sizeof(struct nx_sg);
 
 		if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
@@ -111,12 +115,12 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
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
@@ -131,7 +135,7 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 		total -= to_process;
 		data += to_process - sctx->count;
 		sctx->count = 0;
-		in_sg = nx_ctx->in_sg;
+		in_sg = curr_nx_ctx.in_sg;
 	} while (leftover >= SHA256_BLOCK_SIZE);
 
 	/* copy the leftover back into the state struct */
@@ -139,7 +143,7 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 		memcpy(sctx->buf, data, leftover);
 	sctx->count = leftover;
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
@@ -150,12 +154,16 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	struct nx_sg *in_sg, *out_sg;
 	u32 max_sg_len;
-	unsigned long irq_flags;
 	int rc;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+	
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
 
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len, nx_ctx->ap->sglen);
+	csbcpb = curr_nx_ctx.csbcpb;
+
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len, curr_nx_ctx.ap->sglen);
 
 	if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
 		/* we've hit the nx chip previously, now we're finalizing,
@@ -170,19 +178,19 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 
 	csbcpb->cpb.sha256.message_bit_length += (u64)(sctx->count * 8);
 
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *)sctx->buf,
+	in_sg = nx_build_sg_list(curr_nx_ctx.in_sg, (u8 *)sctx->buf,
 				 sctx->count, max_sg_len);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, out, SHA256_DIGEST_SIZE,
+	out_sg = nx_build_sg_list(curr_nx_ctx.out_sg, out, SHA256_DIGEST_SIZE,
 				  max_sg_len);
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
@@ -193,7 +201,7 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 		     &(nx_ctx->stats->sha256_bytes));
 	memcpy(out, csbcpb->cpb.sha256.message_digest, SHA256_DIGEST_SIZE);
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
@@ -203,10 +211,14 @@ static int nx_sha256_export(struct shash_desc *desc, void *out)
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	struct sha256_state *octx = out;
-	unsigned long irq_flags;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
 
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
+
+	csbcpb = curr_nx_ctx.csbcpb;
+	
 	octx->count = sctx->count +
 		      (csbcpb->cpb.sha256.message_bit_length / 8);
 	memcpy(octx->buf, sctx->buf, sizeof(octx->buf));
@@ -228,7 +240,7 @@ static int nx_sha256_export(struct shash_desc *desc, void *out)
 		octx->state[7] = SHA256_H7;
 	}
 
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return 0;
 }
 
@@ -238,9 +250,13 @@ static int nx_sha256_import(struct shash_desc *desc, const void *in)
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	const struct sha256_state *ictx = in;
-	unsigned long irq_flags;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
+
+	csbcpb = curr_nx_ctx.csbcpb;
 
 	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
 
@@ -255,7 +271,7 @@ static int nx_sha256_import(struct shash_desc *desc, const void *in)
 		NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
 	}
 
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return 0;
 }
 
diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
index 4ae5b0f..7fc2583 100644
--- a/drivers/crypto/nx/nx-sha512.c
+++ b/drivers/crypto/nx/nx-sha512.c
@@ -57,10 +57,14 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 	struct nx_sg *in_sg;
 	u64 to_process, leftover, total, spbc_bits;
 	u32 max_sg_len;
-	unsigned long irq_flags;
 	int rc = 0;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+        	return -ENOMEM;
+
+        csbcpb = curr_nx_ctx.csbcpb;
 
 	/* 2 cases for total data len:
 	 *  1: < SHA512_BLOCK_SIZE: copy into state, return 0
@@ -73,9 +77,9 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 		goto out;
 	}
 
-	in_sg = nx_ctx->in_sg;
+	in_sg = curr_nx_ctx.in_sg;
 	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
+			   curr_nx_ctx.ap->sglen);
 
 	do {
 		/*
@@ -83,21 +87,21 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 		 * this update. This value is also restricted by the sg list
 		 * limits.
 		 */
-		to_process = min_t(u64, total, nx_ctx->ap->databytelen);
+		to_process = min_t(u64, total, curr_nx_ctx.ap->databytelen);
 		to_process = min_t(u64, to_process,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 		to_process = to_process & ~(SHA512_BLOCK_SIZE - 1);
 		leftover = total - to_process;
 
 		if (sctx->count[0]) {
-			in_sg = nx_build_sg_list(nx_ctx->in_sg,
+			in_sg = nx_build_sg_list(curr_nx_ctx.in_sg,
 						 (u8 *) sctx->buf,
 						 sctx->count[0], max_sg_len);
 		}
 		in_sg = nx_build_sg_list(in_sg, (u8 *) data,
 					 to_process - sctx->count[0],
 					 max_sg_len);
-		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) *
+		curr_nx_ctx.op.inlen = (curr_nx_ctx.in_sg - in_sg) *
 					sizeof(struct nx_sg);
 
 		if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
@@ -111,12 +115,12 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
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
@@ -133,7 +137,7 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 		total -= to_process;
 		data += to_process - sctx->count[0];
 		sctx->count[0] = 0;
-		in_sg = nx_ctx->in_sg;
+		in_sg = curr_nx_ctx.in_sg;
 	} while (leftover >= SHA512_BLOCK_SIZE);
 
 	/* copy the leftover back into the state struct */
@@ -141,7 +145,7 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 		memcpy(sctx->buf, data, leftover);
 	sctx->count[0] = leftover;
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
@@ -153,12 +157,16 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 	struct nx_sg *in_sg, *out_sg;
 	u32 max_sg_len;
 	u64 count0;
-	unsigned long irq_flags;
 	int rc;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
 
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len, nx_ctx->ap->sglen);
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+        	return -ENOMEM;
+	
+        csbcpb = curr_nx_ctx.csbcpb;
+
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len, curr_nx_ctx.ap->sglen);
 
 	if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
 		/* we've hit the nx chip previously, now we're finalizing,
@@ -177,19 +185,19 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 	if (csbcpb->cpb.sha512.message_bit_length_lo < count0)
 		csbcpb->cpb.sha512.message_bit_length_hi++;
 
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, sctx->buf, sctx->count[0],
+	in_sg = nx_build_sg_list(curr_nx_ctx.in_sg, sctx->buf, sctx->count[0],
 				 max_sg_len);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, out, SHA512_DIGEST_SIZE,
+	out_sg = nx_build_sg_list(curr_nx_ctx.out_sg, out, SHA512_DIGEST_SIZE,
 				  max_sg_len);
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
@@ -200,7 +208,7 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 
 	memcpy(out, csbcpb->cpb.sha512.message_digest, SHA512_DIGEST_SIZE);
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
@@ -210,9 +218,13 @@ static int nx_sha512_export(struct shash_desc *desc, void *out)
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	struct sha512_state *octx = out;
-	unsigned long irq_flags;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+
+        if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+                return -ENOMEM;
+
+        csbcpb = curr_nx_ctx.csbcpb;
 
 	/* move message_bit_length (128 bits) into count and convert its value
 	 * to bytes */
@@ -244,7 +256,7 @@ static int nx_sha512_export(struct shash_desc *desc, void *out)
 		octx->state[7] = SHA512_H7;
 	}
 
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return 0;
 }
 
@@ -254,9 +266,13 @@ static int nx_sha512_import(struct shash_desc *desc, const void *in)
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	const struct sha512_state *ictx = in;
-	unsigned long irq_flags;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+
+        if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+                return -ENOMEM;
+
+        csbcpb = curr_nx_ctx.csbcpb;
 
 	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
 	sctx->count[0] = ictx->count[0] & 0x3f;
@@ -274,7 +290,7 @@ static int nx_sha512_import(struct shash_desc *desc, const void *in)
 		NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
 	}
 
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return 0;
 }
 
-- 
1.7.1

