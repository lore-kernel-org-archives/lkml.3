Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbaJ1Rtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:49:55 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:55279 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaJ1Rtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:49:52 -0400
Date: Tue, 28 Oct 2014 15:49:46 -0200
From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH 7/9] Fix SHA concurrence issue and sg limit bounds
Message-ID: <20141028174942.GA18035@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102817-1524-0000-0000-000000E26154
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NX SHA algorithms stores the message digest into tfm what
cause a concurrence issue where hashes may be replaced by others.
This patch cleans up the cases where it's handling unnecessarily shared
variables in nx context and copies the current msg digest to a sctx->state
in order to safetly handle with the hashe's state.

Also fixes and does some clean ups regarding the right sg max limit
and bounds to the sg list avoind a memory crash.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-sha256.c |  208 ++++++++++++++++++--------------------
 drivers/crypto/nx/nx-sha512.c |  222 ++++++++++++++++++----------------------
 2 files changed, 200 insertions(+), 230 deletions(-)

diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
index da0b24a..23621da 100644
--- a/drivers/crypto/nx/nx-sha256.c
+++ b/drivers/crypto/nx/nx-sha256.c
@@ -23,6 +23,7 @@
 #include <crypto/sha.h>
 #include <linux/module.h>
 #include <asm/vio.h>
+#include <asm/byteorder.h>
 
 #include "nx_csbcpb.h"
 #include "nx.h"
@@ -32,7 +33,8 @@ static int nx_sha256_init(struct shash_desc *desc)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
-	struct nx_sg *out_sg;
+	int len;
+	int rc;
 
 	nx_ctx_init(nx_ctx, HCOP_FC_SHA);
 
@@ -41,10 +43,28 @@ static int nx_sha256_init(struct shash_desc *desc)
 	nx_ctx->ap = &nx_ctx->props[NX_PROPS_SHA256];
 
 	NX_CPB_SET_DIGEST_SIZE(nx_ctx->csbcpb, NX_DS_SHA256);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *)sctx->state,
-				  SHA256_DIGEST_SIZE, nx_ctx->ap->sglen);
-	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
+	len = SHA256_DIGEST_SIZE;
+	rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->out_sg,
+				  &nx_ctx->op.outlen,
+				  &len,
+				  (u8 *) sctx->state,
+				  NX_DS_SHA256);
+
+	if (rc)
+		goto out;
+
+	sctx->state[0] = __cpu_to_be32(SHA256_H0);
+	sctx->state[1] = __cpu_to_be32(SHA256_H1);
+	sctx->state[2] = __cpu_to_be32(SHA256_H2);
+	sctx->state[3] = __cpu_to_be32(SHA256_H3);
+	sctx->state[4] = __cpu_to_be32(SHA256_H4);
+	sctx->state[5] = __cpu_to_be32(SHA256_H5);
+	sctx->state[6] = __cpu_to_be32(SHA256_H6);
+	sctx->state[7] = __cpu_to_be32(SHA256_H7);
+	sctx->count = 0;
+
+out:
 	return 0;
 }
 
@@ -54,11 +74,11 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
-	struct nx_sg *in_sg;
-	u64 to_process, leftover, total;
-	u32 max_sg_len;
+	u64 to_process = 0, leftover, total;
 	unsigned long irq_flags;
 	int rc = 0;
+	int data_len;
+	u64 buf_len = (sctx->count % SHA256_BLOCK_SIZE);
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
@@ -66,16 +86,16 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 	 *  1: < SHA256_BLOCK_SIZE: copy into state, return 0
 	 *  2: >= SHA256_BLOCK_SIZE: process X blocks, copy in leftover
 	 */
-	total = sctx->count + len;
+	total = (sctx->count % SHA256_BLOCK_SIZE) + len;
 	if (total < SHA256_BLOCK_SIZE) {
-		memcpy(sctx->buf + sctx->count, data, len);
+		memcpy(sctx->buf + buf_len, data, len);
 		sctx->count += len;
 		goto out;
 	}
 
-	in_sg = nx_ctx->in_sg;
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
+	memcpy(csbcpb->cpb.sha256.message_digest, sctx->state, SHA256_DIGEST_SIZE);
+	NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
+	NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 	do {
 		/*
@@ -83,34 +103,42 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 		 * this update. This value is also restricted by the sg list
 		 * limits.
 		 */
-		to_process = min_t(u64, total, nx_ctx->ap->databytelen);
-		to_process = min_t(u64, to_process,
-				   NX_PAGE_SIZE * (max_sg_len - 1));
+		to_process = total - to_process;
 		to_process = to_process & ~(SHA256_BLOCK_SIZE - 1);
-		leftover = total - to_process;
 
-		if (sctx->count) {
-			in_sg = nx_build_sg_list(nx_ctx->in_sg,
-						 (u8 *) sctx->buf,
-						 sctx->count, max_sg_len);
+		if (buf_len) {
+			data_len = buf_len;
+			rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->in_sg,
+						  &nx_ctx->op.inlen,
+						  &data_len,
+						  (u8 *) sctx->buf,
+						  NX_DS_SHA256);
+
+			if (rc || data_len != buf_len)
+				goto out;
 		}
-		in_sg = nx_build_sg_list(in_sg, (u8 *) data,
-					 to_process - sctx->count,
-					 max_sg_len);
-		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) *
-					sizeof(struct nx_sg);
-
-		if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
-			/*
-			 * we've hit the nx chip previously and we're updating
-			 * again, so copy over the partial digest.
-			 */
-			memcpy(csbcpb->cpb.sha256.input_partial_digest,
+
+		data_len = to_process - buf_len;
+		rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->in_sg,
+					  &nx_ctx->op.inlen,
+					  &data_len,
+					  (u8 *) data,
+					  NX_DS_SHA256);
+
+		if (rc)
+			goto out;
+
+		to_process = (data_len + buf_len);
+		leftover = total - to_process;
+
+		/*
+		 * we've hit the nx chip previously and we're updating
+		 * again, so copy over the partial digest.
+		 */
+		memcpy(csbcpb->cpb.sha256.input_partial_digest,
 			       csbcpb->cpb.sha256.message_digest,
 			       SHA256_DIGEST_SIZE);
-		}
 
-		NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
 		if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
 			rc = -EINVAL;
 			goto out;
@@ -122,22 +150,19 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 			goto out;
 
 		atomic_inc(&(nx_ctx->stats->sha256_ops));
-		csbcpb->cpb.sha256.message_bit_length += (u64)
-			(csbcpb->cpb.sha256.spbc * 8);
-
-		/* everything after the first update is continuation */
-		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 		total -= to_process;
-		data += to_process - sctx->count;
-		sctx->count = 0;
-		in_sg = nx_ctx->in_sg;
+		data += to_process - buf_len;
+		buf_len = 0;
+
 	} while (leftover >= SHA256_BLOCK_SIZE);
 
 	/* copy the leftover back into the state struct */
 	if (leftover)
 		memcpy(sctx->buf, data, leftover);
-	sctx->count = leftover;
+
+	sctx->count += len;
+	memcpy(sctx->state, csbcpb->cpb.sha256.message_digest, SHA256_DIGEST_SIZE);
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
@@ -148,34 +173,46 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
-	struct nx_sg *in_sg, *out_sg;
-	u32 max_sg_len;
 	unsigned long irq_flags;
 	int rc;
+	int len;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len, nx_ctx->ap->sglen);
-
-	if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
+	/* final is represented by continuing the operation and indicating that
+	 * this is not an intermediate operation */
+	if (sctx->count >= SHA256_BLOCK_SIZE) {
 		/* we've hit the nx chip previously, now we're finalizing,
 		 * so copy over the partial digest */
-		memcpy(csbcpb->cpb.sha256.input_partial_digest,
-		       csbcpb->cpb.sha256.message_digest, SHA256_DIGEST_SIZE);
+		memcpy(csbcpb->cpb.sha256.input_partial_digest, sctx->state, SHA256_DIGEST_SIZE);
+		NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
+	} else {
+		NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+		NX_CPB_FDM(csbcpb) &= ~NX_FDM_CONTINUATION;
 	}
 
-	/* final is represented by continuing the operation and indicating that
-	 * this is not an intermediate operation */
-	NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+	csbcpb->cpb.sha256.message_bit_length = (u64) (sctx->count * 8);
 
-	csbcpb->cpb.sha256.message_bit_length += (u64)(sctx->count * 8);
+	len = sctx->count & (SHA256_BLOCK_SIZE - 1);
+	rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->in_sg,
+				  &nx_ctx->op.inlen,
+				  &len,
+				  (u8 *) sctx->buf,
+				  NX_DS_SHA256);
 
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *)sctx->buf,
-				 sctx->count, max_sg_len);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, out, SHA256_DIGEST_SIZE,
-				  max_sg_len);
-	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
-	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
+	if (rc || len != (sctx->count & (SHA256_BLOCK_SIZE - 1)))
+		goto out;
+
+	len = SHA256_DIGEST_SIZE;
+	rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->out_sg,
+				  &nx_ctx->op.outlen,
+				  &len,
+				  out,
+				  NX_DS_SHA256);
+
+	if (rc || len != SHA256_DIGEST_SIZE)
+		goto out;
 
 	if (!nx_ctx->op.outlen) {
 		rc = -EINVAL;
@@ -189,8 +226,7 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 
 	atomic_inc(&(nx_ctx->stats->sha256_ops));
 
-	atomic64_add(csbcpb->cpb.sha256.message_bit_length / 8,
-		     &(nx_ctx->stats->sha256_bytes));
+	atomic64_add(sctx->count, &(nx_ctx->stats->sha256_bytes));
 	memcpy(out, csbcpb->cpb.sha256.message_digest, SHA256_DIGEST_SIZE);
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
@@ -200,62 +236,18 @@ out:
 static int nx_sha256_export(struct shash_desc *desc, void *out)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
-	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
-	struct sha256_state *octx = out;
-	unsigned long irq_flags;
-
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	octx->count = sctx->count +
-		      (csbcpb->cpb.sha256.message_bit_length / 8);
-	memcpy(octx->buf, sctx->buf, sizeof(octx->buf));
-
-	/* if no data has been processed yet, we need to export SHA256's
-	 * initial data, in case this context gets imported into a software
-	 * context */
-	if (csbcpb->cpb.sha256.message_bit_length)
-		memcpy(octx->state, csbcpb->cpb.sha256.message_digest,
-		       SHA256_DIGEST_SIZE);
-	else {
-		octx->state[0] = SHA256_H0;
-		octx->state[1] = SHA256_H1;
-		octx->state[2] = SHA256_H2;
-		octx->state[3] = SHA256_H3;
-		octx->state[4] = SHA256_H4;
-		octx->state[5] = SHA256_H5;
-		octx->state[6] = SHA256_H6;
-		octx->state[7] = SHA256_H7;
-	}
+	memcpy(out, sctx, sizeof(*sctx));
 
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return 0;
 }
 
 static int nx_sha256_import(struct shash_desc *desc, const void *in)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
-	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
-	const struct sha256_state *ictx = in;
-	unsigned long irq_flags;
-
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
+	memcpy(sctx, in, sizeof(*sctx));
 
-	sctx->count = ictx->count & 0x3f;
-	csbcpb->cpb.sha256.message_bit_length = (ictx->count & ~0x3f) * 8;
-
-	if (csbcpb->cpb.sha256.message_bit_length) {
-		memcpy(csbcpb->cpb.sha256.message_digest, ictx->state,
-		       SHA256_DIGEST_SIZE);
-
-		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
-		NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
-	}
-
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return 0;
 }
 
diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
index 4ae5b0f..b3adf10 100644
--- a/drivers/crypto/nx/nx-sha512.c
+++ b/drivers/crypto/nx/nx-sha512.c
@@ -32,7 +32,8 @@ static int nx_sha512_init(struct shash_desc *desc)
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
-	struct nx_sg *out_sg;
+	int len;
+	int rc;
 
 	nx_ctx_init(nx_ctx, HCOP_FC_SHA);
 
@@ -41,10 +42,28 @@ static int nx_sha512_init(struct shash_desc *desc)
 	nx_ctx->ap = &nx_ctx->props[NX_PROPS_SHA512];
 
 	NX_CPB_SET_DIGEST_SIZE(nx_ctx->csbcpb, NX_DS_SHA512);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *)sctx->state,
-				  SHA512_DIGEST_SIZE, nx_ctx->ap->sglen);
-	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
+	len = SHA512_DIGEST_SIZE;
+	rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->out_sg,
+				  &nx_ctx->op.outlen,
+				  &len,
+				  (u8 *)sctx->state,
+				  NX_DS_SHA512);
+
+	if (rc || len != SHA512_DIGEST_SIZE)
+		goto out;
+
+	sctx->state[0] = __cpu_to_be64(SHA512_H0);
+	sctx->state[1] = __cpu_to_be64(SHA512_H1);
+	sctx->state[2] = __cpu_to_be64(SHA512_H2);
+	sctx->state[3] = __cpu_to_be64(SHA512_H3);
+	sctx->state[4] = __cpu_to_be64(SHA512_H4);
+	sctx->state[5] = __cpu_to_be64(SHA512_H5);
+	sctx->state[6] = __cpu_to_be64(SHA512_H6);
+	sctx->state[7] = __cpu_to_be64(SHA512_H7);
+	sctx->count[0] = 0;
+
+out:
 	return 0;
 }
 
@@ -54,11 +73,11 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 	struct sha512_state *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
-	struct nx_sg *in_sg;
-	u64 to_process, leftover, total, spbc_bits;
-	u32 max_sg_len;
+	u64 to_process, leftover = 0, total;
 	unsigned long irq_flags;
 	int rc = 0;
+	int data_len;
+	u64 buf_len = (sctx->count[0] % SHA512_BLOCK_SIZE);
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
@@ -66,16 +85,16 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 	 *  1: < SHA512_BLOCK_SIZE: copy into state, return 0
 	 *  2: >= SHA512_BLOCK_SIZE: process X blocks, copy in leftover
 	 */
-	total = sctx->count[0] + len;
+	total = (sctx->count[0] % SHA512_BLOCK_SIZE) + len;
 	if (total < SHA512_BLOCK_SIZE) {
-		memcpy(sctx->buf + sctx->count[0], data, len);
+		memcpy(sctx->buf + buf_len, data, len);
 		sctx->count[0] += len;
 		goto out;
 	}
 
-	in_sg = nx_ctx->in_sg;
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
+	memcpy(csbcpb->cpb.sha512.message_digest, sctx->state, SHA512_DIGEST_SIZE);
+	NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
+	NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 	do {
 		/*
@@ -83,34 +102,43 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 		 * this update. This value is also restricted by the sg list
 		 * limits.
 		 */
-		to_process = min_t(u64, total, nx_ctx->ap->databytelen);
-		to_process = min_t(u64, to_process,
-				   NX_PAGE_SIZE * (max_sg_len - 1));
+		to_process = total - leftover;
 		to_process = to_process & ~(SHA512_BLOCK_SIZE - 1);
 		leftover = total - to_process;
 
-		if (sctx->count[0]) {
-			in_sg = nx_build_sg_list(nx_ctx->in_sg,
-						 (u8 *) sctx->buf,
-						 sctx->count[0], max_sg_len);
+		if (buf_len) {
+			data_len = buf_len;
+			rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->in_sg,
+						  &nx_ctx->op.inlen,
+						  &data_len,
+						  (u8 *) sctx->buf,
+						  NX_DS_SHA512);
+
+			if (rc || data_len != buf_len)
+				goto out;
 		}
-		in_sg = nx_build_sg_list(in_sg, (u8 *) data,
-					 to_process - sctx->count[0],
-					 max_sg_len);
-		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) *
-					sizeof(struct nx_sg);
-
-		if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
-			/*
-			 * we've hit the nx chip previously and we're updating
-			 * again, so copy over the partial digest.
-			 */
-			memcpy(csbcpb->cpb.sha512.input_partial_digest,
+
+		data_len = to_process - buf_len;
+		rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->in_sg,
+					  &nx_ctx->op.inlen,
+					  &data_len,
+					  (u8 *) data,
+					  NX_DS_SHA512);
+
+		if (rc || data_len != (to_process - buf_len))
+			goto out;
+
+		to_process = (data_len + buf_len);
+		leftover = total - to_process;
+
+		/*
+		 * we've hit the nx chip previously and we're updating
+		 * again, so copy over the partial digest.
+		 */
+		memcpy(csbcpb->cpb.sha512.input_partial_digest,
 			       csbcpb->cpb.sha512.message_digest,
 			       SHA512_DIGEST_SIZE);
-		}
 
-		NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
 		if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
 			rc = -EINVAL;
 			goto out;
@@ -122,24 +150,18 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 			goto out;
 
 		atomic_inc(&(nx_ctx->stats->sha512_ops));
-		spbc_bits = csbcpb->cpb.sha512.spbc * 8;
-		csbcpb->cpb.sha512.message_bit_length_lo += spbc_bits;
-		if (csbcpb->cpb.sha512.message_bit_length_lo < spbc_bits)
-			csbcpb->cpb.sha512.message_bit_length_hi++;
-
-		/* everything after the first update is continuation */
-		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 		total -= to_process;
-		data += to_process - sctx->count[0];
-		sctx->count[0] = 0;
-		in_sg = nx_ctx->in_sg;
+		data += to_process - buf_len;
+		buf_len = 0;
+
 	} while (leftover >= SHA512_BLOCK_SIZE);
 
 	/* copy the leftover back into the state struct */
 	if (leftover)
 		memcpy(sctx->buf, data, leftover);
-	sctx->count[0] = leftover;
+	sctx->count[0] += len;
+	memcpy(sctx->state, csbcpb->cpb.sha512.message_digest, SHA512_DIGEST_SIZE);
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
@@ -150,39 +172,52 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 	struct sha512_state *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
-	struct nx_sg *in_sg, *out_sg;
-	u32 max_sg_len;
 	u64 count0;
 	unsigned long irq_flags;
 	int rc;
+	int len;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len, nx_ctx->ap->sglen);
-
-	if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
+	/* final is represented by continuing the operation and indicating that
+	 * this is not an intermediate operation */
+	if (sctx->count[0] >= SHA512_BLOCK_SIZE) {
 		/* we've hit the nx chip previously, now we're finalizing,
 		 * so copy over the partial digest */
-		memcpy(csbcpb->cpb.sha512.input_partial_digest,
-		       csbcpb->cpb.sha512.message_digest, SHA512_DIGEST_SIZE);
+		memcpy(csbcpb->cpb.sha512.input_partial_digest, sctx->state,
+							SHA512_DIGEST_SIZE);
+		NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
+	} else {
+		NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+		NX_CPB_FDM(csbcpb) &= ~NX_FDM_CONTINUATION;
 	}
 
-	/* final is represented by continuing the operation and indicating that
-	 * this is not an intermediate operation */
 	NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
 
 	count0 = sctx->count[0] * 8;
 
-	csbcpb->cpb.sha512.message_bit_length_lo += count0;
-	if (csbcpb->cpb.sha512.message_bit_length_lo < count0)
-		csbcpb->cpb.sha512.message_bit_length_hi++;
+	csbcpb->cpb.sha512.message_bit_length_lo = count0;
 
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, sctx->buf, sctx->count[0],
-				 max_sg_len);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, out, SHA512_DIGEST_SIZE,
-				  max_sg_len);
-	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
-	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
+	len = sctx->count[0] & (SHA512_BLOCK_SIZE - 1);
+	rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->in_sg,
+				  &nx_ctx->op.inlen,
+				  &len,
+				  (u8 *)sctx->buf,
+				  NX_DS_SHA512);
+
+	if (rc || len != (sctx->count[0] & (SHA512_BLOCK_SIZE - 1)))
+		goto out;
+
+	len = SHA512_DIGEST_SIZE;
+	rc = nx_sha_build_sg_list(nx_ctx, nx_ctx->out_sg,
+				  &nx_ctx->op.outlen,
+				  &len,
+				  out,
+				  NX_DS_SHA512);
+
+	if (rc)
+		goto out;
 
 	if (!nx_ctx->op.outlen) {
 		rc = -EINVAL;
@@ -195,8 +230,7 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 		goto out;
 
 	atomic_inc(&(nx_ctx->stats->sha512_ops));
-	atomic64_add(csbcpb->cpb.sha512.message_bit_length_lo / 8,
-		     &(nx_ctx->stats->sha512_bytes));
+	atomic64_add(sctx->count[0], &(nx_ctx->stats->sha512_bytes));
 
 	memcpy(out, csbcpb->cpb.sha512.message_digest, SHA512_DIGEST_SIZE);
 out:
@@ -207,74 +241,18 @@ out:
 static int nx_sha512_export(struct shash_desc *desc, void *out)
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
-	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
-	struct sha512_state *octx = out;
-	unsigned long irq_flags;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	memcpy(out, sctx, sizeof(*sctx));
 
-	/* move message_bit_length (128 bits) into count and convert its value
-	 * to bytes */
-	octx->count[0] = csbcpb->cpb.sha512.message_bit_length_lo >> 3 |
-			 ((csbcpb->cpb.sha512.message_bit_length_hi & 7) << 61);
-	octx->count[1] = csbcpb->cpb.sha512.message_bit_length_hi >> 3;
-
-	octx->count[0] += sctx->count[0];
-	if (octx->count[0] < sctx->count[0])
-		octx->count[1]++;
-
-	memcpy(octx->buf, sctx->buf, sizeof(octx->buf));
-
-	/* if no data has been processed yet, we need to export SHA512's
-	 * initial data, in case this context gets imported into a software
-	 * context */
-	if (csbcpb->cpb.sha512.message_bit_length_hi ||
-	    csbcpb->cpb.sha512.message_bit_length_lo)
-		memcpy(octx->state, csbcpb->cpb.sha512.message_digest,
-		       SHA512_DIGEST_SIZE);
-	else {
-		octx->state[0] = SHA512_H0;
-		octx->state[1] = SHA512_H1;
-		octx->state[2] = SHA512_H2;
-		octx->state[3] = SHA512_H3;
-		octx->state[4] = SHA512_H4;
-		octx->state[5] = SHA512_H5;
-		octx->state[6] = SHA512_H6;
-		octx->state[7] = SHA512_H7;
-	}
-
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return 0;
 }
 
 static int nx_sha512_import(struct shash_desc *desc, const void *in)
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
-	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
-	const struct sha512_state *ictx = in;
-	unsigned long irq_flags;
-
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
-
-	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
-	sctx->count[0] = ictx->count[0] & 0x3f;
-	csbcpb->cpb.sha512.message_bit_length_lo = (ictx->count[0] & ~0x3f)
-							<< 3;
-	csbcpb->cpb.sha512.message_bit_length_hi = ictx->count[1] << 3 |
-						   ictx->count[0] >> 61;
-
-	if (csbcpb->cpb.sha512.message_bit_length_hi ||
-	    csbcpb->cpb.sha512.message_bit_length_lo) {
-		memcpy(csbcpb->cpb.sha512.message_digest, ictx->state,
-		       SHA512_DIGEST_SIZE);
 
-		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
-		NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
-	}
+	memcpy(sctx, in, sizeof(*sctx));
 
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return 0;
 }
 
-- 
1.7.1

