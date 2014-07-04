Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbaGDOE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:04:27 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47173 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbaGDOEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:04:25 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 1/2] crypto: qce: fix sparse warnings
Date: Fri,  4 Jul 2014 17:03:29 +0300
Message-Id: <1404482610-25608-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1404482610-25608-1-git-send-email-svarbanov@mm-sol.com>
References: <1404482610-25608-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix few sparse warnings of type:
- sparse: incorrect type in argument
- sparse: incorrect type in initializer

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/qce/common.c |   15 +++++++++------
 drivers/crypto/qce/common.h |    2 +-
 drivers/crypto/qce/sha.c    |   20 ++++++++++----------
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 1cd4d5e..1fb5fde 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -201,7 +201,8 @@ static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
 	unsigned int xtsklen = enckeylen / (2 * sizeof(u32));
 	unsigned int xtsdusize;
 
-	qce_cpu_to_be32p_array(xtskey, enckey + enckeylen / 2, enckeylen / 2);
+	qce_cpu_to_be32p_array((__be32 *)xtskey, enckey + enckeylen / 2,
+			       enckeylen / 2);
 	qce_write_array(qce, REG_ENCR_XTS_KEY0, xtskey, xtsklen);
 
 	/* xts du size 512B */
@@ -262,7 +263,8 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req,
 		u32 authkey_words = rctx->authklen / sizeof(u32);
 
 		qce_cpu_to_be32p_array(mackey, rctx->authkey, rctx->authklen);
-		qce_write_array(qce, REG_AUTH_KEY0, mackey, authkey_words);
+		qce_write_array(qce, REG_AUTH_KEY0, (u32 *)mackey,
+				authkey_words);
 	}
 
 	if (IS_CMAC(rctx->flags))
@@ -274,12 +276,13 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req,
 		qce_cpu_to_be32p_array(auth, rctx->digest, digestsize);
 
 	iv_words = (IS_SHA1(rctx->flags) || IS_SHA1_HMAC(rctx->flags)) ? 5 : 8;
-	qce_write_array(qce, REG_AUTH_IV0, auth, iv_words);
+	qce_write_array(qce, REG_AUTH_IV0, (u32 *)auth, iv_words);
 
 	if (rctx->first_blk)
 		qce_clear_array(qce, REG_AUTH_BYTECNT0, 4);
 	else
-		qce_write_array(qce, REG_AUTH_BYTECNT0, rctx->byte_count, 2);
+		qce_write_array(qce, REG_AUTH_BYTECNT0,
+				(u32 *)rctx->byte_count, 2);
 
 	auth_cfg = qce_auth_cfg(rctx->flags, 0);
 
@@ -354,7 +357,7 @@ static int qce_setup_regs_ablkcipher(struct crypto_async_request *async_req,
 		return -EINVAL;
 	}
 
-	qce_write_array(qce, REG_ENCR_KEY0, enckey, enckey_words);
+	qce_write_array(qce, REG_ENCR_KEY0, (u32 *)enckey, enckey_words);
 
 	if (!IS_ECB(flags)) {
 		if (IS_XTS(flags))
@@ -362,7 +365,7 @@ static int qce_setup_regs_ablkcipher(struct crypto_async_request *async_req,
 		else
 			qce_cpu_to_be32p_array(enciv, rctx->iv, ivsize);
 
-		qce_write_array(qce, REG_CNTR0_IV0, enciv, enciv_words);
+		qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);
 	}
 
 	if (IS_ENCRYPT(flags))
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 411b1fc..a4addd4 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -85,7 +85,7 @@ struct qce_alg_template {
 	struct list_head entry;
 	u32 crypto_alg_type;
 	unsigned long alg_flags;
-	const __be32 *std_iv;
+	const u32 *std_iv;
 	union {
 		struct crypto_alg crypto;
 		struct ahash_alg ahash;
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 3c33ac9..f338593 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -25,11 +25,11 @@
 
 static LIST_HEAD(ahash_algs);
 
-static const __be32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(__be32)] = {
+static const u32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(u32)] = {
 	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4, 0, 0, 0
 };
 
-static const __be32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(__be32)] = {
+static const u32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(u32)] = {
 	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
 	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
 };
@@ -132,7 +132,7 @@ static int qce_ahash_init(struct ahash_request *req)
 {
 	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
 	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
-	const __be32 *std_iv = tmpl->std_iv;
+	const u32 *std_iv = tmpl->std_iv;
 
 	memset(rctx, 0, sizeof(*rctx));
 	rctx->first_blk = true;
@@ -156,15 +156,15 @@ static int qce_ahash_export(struct ahash_request *req, void *out)
 		struct sha1_state *out_state = out;
 
 		out_state->count = rctx->count;
-		qce_cpu_to_be32p_array(out_state->state, rctx->digest,
-				       digestsize);
+		qce_cpu_to_be32p_array((__be32 *)out_state->state,
+				       rctx->digest, digestsize);
 		memcpy(out_state->buffer, rctx->buf, blocksize);
 	} else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags)) {
 		struct sha256_state *out_state = out;
 
 		out_state->count = rctx->count;
-		qce_cpu_to_be32p_array(out_state->state, rctx->digest,
-				       digestsize);
+		qce_cpu_to_be32p_array((__be32 *)out_state->state,
+				       rctx->digest, digestsize);
 		memcpy(out_state->buf, rctx->buf, blocksize);
 	} else {
 		return -EINVAL;
@@ -199,8 +199,8 @@ static int qce_import_common(struct ahash_request *req, u64 in_count,
 			count += SHA_PADDING;
 	}
 
-	rctx->byte_count[0] = (__be32)(count & ~SHA_PADDING_MASK);
-	rctx->byte_count[1] = (__be32)(count >> 32);
+	rctx->byte_count[0] = (__force __be32)(count & ~SHA_PADDING_MASK);
+	rctx->byte_count[1] = (__force __be32)(count >> 32);
 	qce_cpu_to_be32p_array((__be32 *)rctx->digest, (const u8 *)state,
 			       digestsize);
 	rctx->buflen = (unsigned int)(in_count & (blocksize - 1));
@@ -454,7 +454,7 @@ struct qce_ahash_def {
 	unsigned int digestsize;
 	unsigned int blocksize;
 	unsigned int statesize;
-	const __be32 *std_iv;
+	const u32 *std_iv;
 };
 
 static const struct qce_ahash_def ahash_def[] = {
-- 
1.7.0.4

