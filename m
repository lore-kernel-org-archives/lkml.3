Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3DLRVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:21:19 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47606 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3DLRVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:21:17 -0400
Date: Fri, 12 Apr 2013 12:13:59 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] drivers/crypto/nx: fixes for multiple issues
Message-ID: <20130412171357.GA27924@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041217-7408-0000-0000-00000EDA0D5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Fixes a race on driver init with registering algorithms where the
driver status flag wasn't being set before self testing started.

  Added the cra_alignmask field for CBC and ECB modes.

  Fixed a bug in GCM where AES block size was being used instead of
authsize.

  Removed use of blkcipher_walk routines for scatterlist processing.
Corner cases in the code prevent us from processing an entire
scatterlist at a time and walking the buffers in block sized chunks
turns out to be unecessary anyway.

  Fixed off-by-one error in saving off extra data in the sha code.

  Fixed accounting error for number of bytes processed in the sha code.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
Patch v3, was: drivers/crypto/nx: fix init race, alignmasks and GCM bug

Applied to:
git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git#next

 drivers/crypto/nx/nx-aes-cbc.c |  1 +
 drivers/crypto/nx/nx-aes-ecb.c |  1 +
 drivers/crypto/nx/nx-aes-gcm.c |  2 +-
 drivers/crypto/nx/nx-sha256.c  |  8 +++++---
 drivers/crypto/nx/nx-sha512.c  |  7 ++++---
 drivers/crypto/nx/nx.c         | 38 +++++++-------------------------------
 6 files changed, 19 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index a76d4c4..35d483f 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -126,6 +126,7 @@ struct crypto_alg nx_cbc_aes_alg = {
 	.cra_blocksize   = AES_BLOCK_SIZE,
 	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
 	.cra_type        = &crypto_blkcipher_type,
+	.cra_alignmask   = 0xf,
 	.cra_module      = THIS_MODULE,
 	.cra_init        = nx_crypto_ctx_aes_cbc_init,
 	.cra_exit        = nx_crypto_ctx_exit,
diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
index ba5f161..7bbc9a8 100644
--- a/drivers/crypto/nx/nx-aes-ecb.c
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -123,6 +123,7 @@ struct crypto_alg nx_ecb_aes_alg = {
 	.cra_priority    = 300,
 	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize   = AES_BLOCK_SIZE,
+	.cra_alignmask   = 0xf,
 	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
 	.cra_type        = &crypto_blkcipher_type,
 	.cra_module      = THIS_MODULE,
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index c8109ed..6cca6c3 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -219,7 +219,7 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 	if (enc)
 		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 	else
-		nbytes -= AES_BLOCK_SIZE;
+		nbytes -= crypto_aead_authsize(crypto_aead_reqtfm(req));
 
 	csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
 
diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
index 9767315..67024f2 100644
--- a/drivers/crypto/nx/nx-sha256.c
+++ b/drivers/crypto/nx/nx-sha256.c
@@ -69,7 +69,7 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 	 *  1: <= SHA256_BLOCK_SIZE: copy into state, return 0
 	 *  2: > SHA256_BLOCK_SIZE: process X blocks, copy in leftover
 	 */
-	if (len + sctx->count <= SHA256_BLOCK_SIZE) {
+	if (len + sctx->count < SHA256_BLOCK_SIZE) {
 		memcpy(sctx->buf + sctx->count, data, len);
 		sctx->count += len;
 		goto out;
@@ -110,7 +110,8 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 	atomic_inc(&(nx_ctx->stats->sha256_ops));
 
 	/* copy the leftover back into the state struct */
-	memcpy(sctx->buf, data + len - leftover, leftover);
+	if (leftover)
+		memcpy(sctx->buf, data + len - leftover, leftover);
 	sctx->count = leftover;
 
 	csbcpb->cpb.sha256.message_bit_length += (u64)
@@ -130,6 +131,7 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 	struct nx_sg *in_sg, *out_sg;
 	int rc;
 
+
 	if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
 		/* we've hit the nx chip previously, now we're finalizing,
 		 * so copy over the partial digest */
@@ -162,7 +164,7 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 
 	atomic_inc(&(nx_ctx->stats->sha256_ops));
 
-	atomic64_add(csbcpb->cpb.sha256.message_bit_length,
+	atomic64_add(csbcpb->cpb.sha256.message_bit_length / 8,
 		     &(nx_ctx->stats->sha256_bytes));
 	memcpy(out, csbcpb->cpb.sha256.message_digest, SHA256_DIGEST_SIZE);
 out:
diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
index 3177b8c..08eee11 100644
--- a/drivers/crypto/nx/nx-sha512.c
+++ b/drivers/crypto/nx/nx-sha512.c
@@ -69,7 +69,7 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 	 *  1: <= SHA512_BLOCK_SIZE: copy into state, return 0
 	 *  2: > SHA512_BLOCK_SIZE: process X blocks, copy in leftover
 	 */
-	if ((u64)len + sctx->count[0] <= SHA512_BLOCK_SIZE) {
+	if ((u64)len + sctx->count[0] < SHA512_BLOCK_SIZE) {
 		memcpy(sctx->buf + sctx->count[0], data, len);
 		sctx->count[0] += len;
 		goto out;
@@ -110,7 +110,8 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 	atomic_inc(&(nx_ctx->stats->sha512_ops));
 
 	/* copy the leftover back into the state struct */
-	memcpy(sctx->buf, data + len - leftover, leftover);
+	if (leftover)
+		memcpy(sctx->buf, data + len - leftover, leftover);
 	sctx->count[0] = leftover;
 
 	spbc_bits = csbcpb->cpb.sha512.spbc * 8;
@@ -168,7 +169,7 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 		goto out;
 
 	atomic_inc(&(nx_ctx->stats->sha512_ops));
-	atomic64_add(csbcpb->cpb.sha512.message_bit_length_lo,
+	atomic64_add(csbcpb->cpb.sha512.message_bit_length_lo / 8,
 		     &(nx_ctx->stats->sha512_bytes));
 
 	memcpy(out, csbcpb->cpb.sha512.message_digest, SHA512_DIGEST_SIZE);
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index c767f23..bbdab6e 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -211,44 +211,20 @@ int nx_build_sg_lists(struct nx_crypto_ctx  *nx_ctx,
 {
 	struct nx_sg *nx_insg = nx_ctx->in_sg;
 	struct nx_sg *nx_outsg = nx_ctx->out_sg;
-	struct blkcipher_walk walk;
-	int rc;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	rc = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
-	if (rc)
-		goto out;
 
 	if (iv)
-		memcpy(iv, walk.iv, AES_BLOCK_SIZE);
+		memcpy(iv, desc->info, AES_BLOCK_SIZE);
 
-	while (walk.nbytes) {
-		nx_insg = nx_build_sg_list(nx_insg, walk.src.virt.addr,
-					   walk.nbytes, nx_ctx->ap->sglen);
-		nx_outsg = nx_build_sg_list(nx_outsg, walk.dst.virt.addr,
-					    walk.nbytes, nx_ctx->ap->sglen);
-
-		rc = blkcipher_walk_done(desc, &walk, 0);
-		if (rc)
-			break;
-	}
-
-	if (walk.nbytes) {
-		nx_insg = nx_build_sg_list(nx_insg, walk.src.virt.addr,
-					   walk.nbytes, nx_ctx->ap->sglen);
-		nx_outsg = nx_build_sg_list(nx_outsg, walk.dst.virt.addr,
-					    walk.nbytes, nx_ctx->ap->sglen);
-
-		rc = 0;
-	}
+	nx_insg = nx_walk_and_build(nx_insg, nx_ctx->ap->sglen, src, 0, nbytes);
+	nx_outsg = nx_walk_and_build(nx_outsg, nx_ctx->ap->sglen, dst, 0, nbytes);
 
 	/* these lengths should be negative, which will indicate to phyp that
 	 * the input and output parameters are scatterlists, not linear
 	 * buffers */
 	nx_ctx->op.inlen = (nx_ctx->in_sg - nx_insg) * sizeof(struct nx_sg);
 	nx_ctx->op.outlen = (nx_ctx->out_sg - nx_outsg) * sizeof(struct nx_sg);
-out:
-	return rc;
+
+	return 0;
 }
 
 /**
@@ -454,6 +430,8 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out;
 
+	nx_driver.of.status = NX_OKAY;
+
 	rc = crypto_register_alg(&nx_ecb_aes_alg);
 	if (rc)
 		goto out;
@@ -498,8 +476,6 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out_unreg_s512;
 
-	nx_driver.of.status = NX_OKAY;
-
 	goto out;
 
 out_unreg_s512:
-- 
1.7.11.7

