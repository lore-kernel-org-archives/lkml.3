Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaAXWSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:18:13 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:4755
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbaAXWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:18:08 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h1155h)
X-WSS-ID: 0MZXFA1-08-47V-02
X-M-MSG: 
Subject: [PATCH 2/4] crypto: ccp - Move HMAC calculation down to ccp ops file
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Fri, 24 Jan 2014 16:18:02 -0600
Message-ID: <20140124221802.1894.61609.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
References: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the support to perform an HMAC calculation into
the CCP operations file.  This eliminates the need to
perform a synchronous SHA operation used to calculate
the HMAC.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-sha.c |  130 +++++++----------------------------
 drivers/crypto/ccp/ccp-crypto.h     |    8 +-
 drivers/crypto/ccp/ccp-ops.c        |  104 ++++++++++++++++++++++++++++
 include/linux/ccp.h                 |    7 ++
 4 files changed, 139 insertions(+), 110 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 3867290..873f234 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -24,75 +24,10 @@
 #include "ccp-crypto.h"
 
 
-struct ccp_sha_result {
-	struct completion completion;
-	int err;
-};
-
-static void ccp_sync_hash_complete(struct crypto_async_request *req, int err)
-{
-	struct ccp_sha_result *result = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	result->err = err;
-	complete(&result->completion);
-}
-
-static int ccp_sync_hash(struct crypto_ahash *tfm, u8 *buf,
-			 struct scatterlist *sg, unsigned int len)
-{
-	struct ccp_sha_result result;
-	struct ahash_request *req;
-	int ret;
-
-	init_completion(&result.completion);
-
-	req = ahash_request_alloc(tfm, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
-
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   ccp_sync_hash_complete, &result);
-	ahash_request_set_crypt(req, sg, buf, len);
-
-	ret = crypto_ahash_digest(req);
-	if ((ret == -EINPROGRESS) || (ret == -EBUSY)) {
-		ret = wait_for_completion_interruptible(&result.completion);
-		if (!ret)
-			ret = result.err;
-	}
-
-	ahash_request_free(req);
-
-	return ret;
-}
-
-static int ccp_sha_finish_hmac(struct crypto_async_request *async_req)
-{
-	struct ahash_request *req = ahash_request_cast(async_req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ccp_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct scatterlist sg[2];
-	unsigned int block_size =
-		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
-	unsigned int digest_size = crypto_ahash_digestsize(tfm);
-
-	sg_init_table(sg, ARRAY_SIZE(sg));
-	sg_set_buf(&sg[0], ctx->u.sha.opad, block_size);
-	sg_set_buf(&sg[1], rctx->ctx, digest_size);
-
-	return ccp_sync_hash(ctx->u.sha.hmac_tfm, req->result, sg,
-			     block_size + digest_size);
-}
-
 static int ccp_sha_complete(struct crypto_async_request *async_req, int ret)
 {
 	struct ahash_request *req = ahash_request_cast(async_req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ccp_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
 	unsigned int digest_size = crypto_ahash_digestsize(tfm);
 
@@ -112,10 +47,6 @@ static int ccp_sha_complete(struct crypto_async_request *async_req, int ret)
 	if (req->result)
 		memcpy(req->result, rctx->ctx, digest_size);
 
-	/* If we're doing an HMAC, we need to perform that on the final op */
-	if (rctx->final && ctx->u.sha.key_len)
-		ret = ccp_sha_finish_hmac(async_req);
-
 e_free:
 	sg_free_table(&rctx->data_sg);
 
@@ -126,6 +57,7 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 			     unsigned int final)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ccp_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
 	struct scatterlist *sg;
 	unsigned int block_size =
@@ -196,6 +128,11 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	rctx->cmd.u.sha.ctx_len = sizeof(rctx->ctx);
 	rctx->cmd.u.sha.src = sg;
 	rctx->cmd.u.sha.src_len = rctx->hash_cnt;
+	rctx->cmd.u.sha.opad = ctx->u.sha.key_len ?
+		&ctx->u.sha.opad_sg : NULL;
+	rctx->cmd.u.sha.opad_len = ctx->u.sha.key_len ?
+		ctx->u.sha.opad_count : 0;
+	rctx->cmd.u.sha.first = rctx->first;
 	rctx->cmd.u.sha.final = rctx->final;
 	rctx->cmd.u.sha.msg_bits = rctx->msg_bits;
 
@@ -218,7 +155,6 @@ static int ccp_sha_init(struct ahash_request *req)
 
 	memset(rctx, 0, sizeof(*rctx));
 
-	memcpy(rctx->ctx, alg->init, sizeof(rctx->ctx));
 	rctx->type = alg->type;
 	rctx->first = 1;
 
@@ -261,10 +197,13 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 			  unsigned int key_len)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-	struct scatterlist sg;
-	unsigned int block_size =
-		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
-	unsigned int digest_size = crypto_ahash_digestsize(tfm);
+	struct crypto_shash *shash = ctx->u.sha.hmac_tfm;
+	struct {
+		struct shash_desc sdesc;
+		char ctx[crypto_shash_descsize(shash)];
+	} desc;
+	unsigned int block_size = crypto_shash_blocksize(shash);
+	unsigned int digest_size = crypto_shash_digestsize(shash);
 	int i, ret;
 
 	/* Set to zero until complete */
@@ -277,8 +216,12 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 	if (key_len > block_size) {
 		/* Must hash the input key */
-		sg_init_one(&sg, key, key_len);
-		ret = ccp_sync_hash(tfm, ctx->u.sha.key, &sg, key_len);
+		desc.sdesc.tfm = shash;
+		desc.sdesc.flags = crypto_ahash_get_flags(tfm) &
+			CRYPTO_TFM_REQ_MAY_SLEEP;
+
+		ret = crypto_shash_digest(&desc.sdesc, key, key_len,
+					  ctx->u.sha.key);
 		if (ret) {
 			crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 			return -EINVAL;
@@ -293,6 +236,9 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 		ctx->u.sha.opad[i] = ctx->u.sha.key[i] ^ 0x5c;
 	}
 
+	sg_init_one(&ctx->u.sha.opad_sg, ctx->u.sha.opad, block_size);
+	ctx->u.sha.opad_count = block_size;
+
 	ctx->u.sha.key_len = key_len;
 
 	return 0;
@@ -319,10 +265,9 @@ static int ccp_hmac_sha_cra_init(struct crypto_tfm *tfm)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct ccp_crypto_ahash_alg *alg = ccp_crypto_ahash_alg(tfm);
-	struct crypto_ahash *hmac_tfm;
+	struct crypto_shash *hmac_tfm;
 
-	hmac_tfm = crypto_alloc_ahash(alg->child_alg,
-				      CRYPTO_ALG_TYPE_AHASH, 0);
+	hmac_tfm = crypto_alloc_shash(alg->child_alg, 0, 0);
 	if (IS_ERR(hmac_tfm)) {
 		pr_warn("could not load driver %s need for HMAC support\n",
 			alg->child_alg);
@@ -339,35 +284,14 @@ static void ccp_hmac_sha_cra_exit(struct crypto_tfm *tfm)
 	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (ctx->u.sha.hmac_tfm)
-		crypto_free_ahash(ctx->u.sha.hmac_tfm);
+		crypto_free_shash(ctx->u.sha.hmac_tfm);
 
 	ccp_sha_cra_exit(tfm);
 }
 
-static const __be32 sha1_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
-	cpu_to_be32(SHA1_H0), cpu_to_be32(SHA1_H1),
-	cpu_to_be32(SHA1_H2), cpu_to_be32(SHA1_H3),
-	cpu_to_be32(SHA1_H4), 0, 0, 0,
-};
-
-static const __be32 sha224_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
-	cpu_to_be32(SHA224_H0), cpu_to_be32(SHA224_H1),
-	cpu_to_be32(SHA224_H2), cpu_to_be32(SHA224_H3),
-	cpu_to_be32(SHA224_H4), cpu_to_be32(SHA224_H5),
-	cpu_to_be32(SHA224_H6), cpu_to_be32(SHA224_H7),
-};
-
-static const __be32 sha256_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
-	cpu_to_be32(SHA256_H0), cpu_to_be32(SHA256_H1),
-	cpu_to_be32(SHA256_H2), cpu_to_be32(SHA256_H3),
-	cpu_to_be32(SHA256_H4), cpu_to_be32(SHA256_H5),
-	cpu_to_be32(SHA256_H6), cpu_to_be32(SHA256_H7),
-};
-
 struct ccp_sha_def {
 	const char *name;
 	const char *drv_name;
-	const __be32 *init;
 	enum ccp_sha_type type;
 	u32 digest_size;
 	u32 block_size;
@@ -377,7 +301,6 @@ static struct ccp_sha_def sha_algs[] = {
 	{
 		.name		= "sha1",
 		.drv_name	= "sha1-ccp",
-		.init		= sha1_init,
 		.type		= CCP_SHA_TYPE_1,
 		.digest_size	= SHA1_DIGEST_SIZE,
 		.block_size	= SHA1_BLOCK_SIZE,
@@ -385,7 +308,6 @@ static struct ccp_sha_def sha_algs[] = {
 	{
 		.name		= "sha224",
 		.drv_name	= "sha224-ccp",
-		.init		= sha224_init,
 		.type		= CCP_SHA_TYPE_224,
 		.digest_size	= SHA224_DIGEST_SIZE,
 		.block_size	= SHA224_BLOCK_SIZE,
@@ -393,7 +315,6 @@ static struct ccp_sha_def sha_algs[] = {
 	{
 		.name		= "sha256",
 		.drv_name	= "sha256-ccp",
-		.init		= sha256_init,
 		.type		= CCP_SHA_TYPE_256,
 		.digest_size	= SHA256_DIGEST_SIZE,
 		.block_size	= SHA256_BLOCK_SIZE,
@@ -460,7 +381,6 @@ static int ccp_register_sha_alg(struct list_head *head,
 
 	INIT_LIST_HEAD(&ccp_alg->entry);
 
-	ccp_alg->init = def->init;
 	ccp_alg->type = def->type;
 
 	alg = &ccp_alg->alg;
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index b222231..9aa4ae1 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -137,11 +137,14 @@ struct ccp_aes_cmac_req_ctx {
 #define MAX_SHA_BLOCK_SIZE	SHA256_BLOCK_SIZE
 
 struct ccp_sha_ctx {
+	struct scatterlist opad_sg;
+	unsigned int opad_count;
+
 	unsigned int key_len;
 	u8 key[MAX_SHA_BLOCK_SIZE];
 	u8 ipad[MAX_SHA_BLOCK_SIZE];
 	u8 opad[MAX_SHA_BLOCK_SIZE];
-	struct crypto_ahash *hmac_tfm;
+	struct crypto_shash *hmac_tfm;
 };
 
 struct ccp_sha_req_ctx {
@@ -167,9 +170,6 @@ struct ccp_sha_req_ctx {
 	unsigned int buf_count;
 	u8 buf[MAX_SHA_BLOCK_SIZE];
 
-	/* HMAC support field */
-	struct scatterlist pad_sg;
-
 	/* CCP driver command */
 	struct ccp_cmd cmd;
 };
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 71ed3ad..c3462e5 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -23,6 +23,7 @@
 #include <linux/ccp.h>
 #include <linux/scatterlist.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
 
 #include "ccp-dev.h"
 
@@ -132,6 +133,27 @@ struct ccp_op {
 	} u;
 };
 
+/* SHA initial context values */
+static const __be32 ccp_sha1_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
+	cpu_to_be32(SHA1_H0), cpu_to_be32(SHA1_H1),
+	cpu_to_be32(SHA1_H2), cpu_to_be32(SHA1_H3),
+	cpu_to_be32(SHA1_H4), 0, 0, 0,
+};
+
+static const __be32 ccp_sha224_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
+	cpu_to_be32(SHA224_H0), cpu_to_be32(SHA224_H1),
+	cpu_to_be32(SHA224_H2), cpu_to_be32(SHA224_H3),
+	cpu_to_be32(SHA224_H4), cpu_to_be32(SHA224_H5),
+	cpu_to_be32(SHA224_H6), cpu_to_be32(SHA224_H7),
+};
+
+static const __be32 ccp_sha256_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
+	cpu_to_be32(SHA256_H0), cpu_to_be32(SHA256_H1),
+	cpu_to_be32(SHA256_H2), cpu_to_be32(SHA256_H3),
+	cpu_to_be32(SHA256_H4), cpu_to_be32(SHA256_H5),
+	cpu_to_be32(SHA256_H6), cpu_to_be32(SHA256_H7),
+};
+
 /* The CCP cannot perform zero-length sha operations so the caller
  * is required to buffer data for the final operation.  However, a
  * sha operation for a message with a total length of zero is valid
@@ -1411,7 +1433,27 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	if (ret)
 		return ret;
 
-	ccp_set_dm_area(&ctx, 0, sha->ctx, 0, sha->ctx_len);
+	if (sha->first) {
+		const __be32 *init;
+
+		switch (sha->type) {
+		case CCP_SHA_TYPE_1:
+			init = ccp_sha1_init;
+			break;
+		case CCP_SHA_TYPE_224:
+			init = ccp_sha224_init;
+			break;
+		case CCP_SHA_TYPE_256:
+			init = ccp_sha256_init;
+			break;
+		default:
+			ret = -EINVAL;
+			goto e_ctx;
+		}
+		memcpy(ctx.address, init, CCP_SHA_CTXSIZE);
+	} else
+		ccp_set_dm_area(&ctx, 0, sha->ctx, 0, sha->ctx_len);
+
 	ret = ccp_copy_to_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
 			      CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
@@ -1451,6 +1493,66 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	ccp_get_dm_area(&ctx, 0, sha->ctx, 0, sha->ctx_len);
 
+	if (sha->final && sha->opad) {
+		/* HMAC operation, recursively perform final SHA */
+		struct ccp_cmd hmac_cmd;
+		struct scatterlist sg;
+		u64 block_size, digest_size;
+		u8 *hmac_buf;
+
+		switch (sha->type) {
+		case CCP_SHA_TYPE_1:
+			block_size = SHA1_BLOCK_SIZE;
+			digest_size = SHA1_DIGEST_SIZE;
+			break;
+		case CCP_SHA_TYPE_224:
+			block_size = SHA224_BLOCK_SIZE;
+			digest_size = SHA224_DIGEST_SIZE;
+			break;
+		case CCP_SHA_TYPE_256:
+			block_size = SHA256_BLOCK_SIZE;
+			digest_size = SHA256_DIGEST_SIZE;
+			break;
+		default:
+			ret = -EINVAL;
+			goto e_data;
+		}
+
+		if (sha->opad_len != block_size) {
+			ret = -EINVAL;
+			goto e_data;
+		}
+
+		hmac_buf = kmalloc(block_size + digest_size, GFP_KERNEL);
+		if (!hmac_buf) {
+			ret = -ENOMEM;
+			goto e_data;
+		}
+		sg_init_one(&sg, hmac_buf, block_size + digest_size);
+
+		scatterwalk_map_and_copy(hmac_buf, sha->opad, 0, block_size, 0);
+		memcpy(hmac_buf + block_size, ctx.address, digest_size);
+
+		memset(&hmac_cmd, 0, sizeof(hmac_cmd));
+		hmac_cmd.engine = CCP_ENGINE_SHA;
+		hmac_cmd.u.sha.type = sha->type;
+		hmac_cmd.u.sha.ctx = sha->ctx;
+		hmac_cmd.u.sha.ctx_len = sha->ctx_len;
+		hmac_cmd.u.sha.src = &sg;
+		hmac_cmd.u.sha.src_len = block_size + digest_size;
+		hmac_cmd.u.sha.opad = NULL;
+		hmac_cmd.u.sha.opad_len = 0;
+		hmac_cmd.u.sha.first = 1;
+		hmac_cmd.u.sha.final = 1;
+		hmac_cmd.u.sha.msg_bits = (block_size + digest_size) << 3;
+
+		ret = ccp_run_sha_cmd(cmd_q, &hmac_cmd);
+		if (ret)
+			cmd->engine_error = hmac_cmd.engine_error;
+
+		kfree(hmac_buf);
+	}
+
 e_data:
 	ccp_free_data(&src, cmd_q);
 
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index b941ab9..ebcc9d1 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -232,6 +232,9 @@ enum ccp_sha_type {
  * @ctx_len: length in bytes of hash value
  * @src: data to be used for this operation
  * @src_len: length in bytes of data used for this operation
+ * @opad: data to be used for final HMAC operation
+ * @opad_len: length in bytes of data used for final HMAC operation
+ * @first: indicates first SHA operation
  * @final: indicates final SHA operation
  * @msg_bits: total length of the message in bits used in final SHA operation
  *
@@ -251,6 +254,10 @@ struct ccp_sha_engine {
 	struct scatterlist *src;
 	u64 src_len;		/* In bytes */
 
+	struct scatterlist *opad;
+	u32 opad_len;		/* In bytes */
+
+	u32 first;		/* Indicates first sha cmd */
 	u32 final;		/* Indicates final sha cmd */
 	u64 msg_bits;		/* Message length in bits required for
 				 * final sha cmd */


