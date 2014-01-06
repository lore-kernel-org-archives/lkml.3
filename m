Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaAFTgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:36:22 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:35472 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755899AbaAFTeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:34:12 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MYZVNY-07-DA8-02
X-M-MSG: 
Subject: [PATCH 2/6] crypto: ccp - Cleanup scatterlist usage
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jan 2014 13:34:05 -0600
Message-ID: <20140106193405.26918.91782.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
References: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup up the usage of scatterlists to make the code cleaner
and avoid extra memory allocations when not needed.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    6 ++-
 drivers/crypto/ccp/ccp-crypto-sha.c      |   53 ++++++++++++++++--------------
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 398832c..646c8d1 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -125,8 +125,10 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 		sg_init_one(&rctx->pad_sg, rctx->pad, pad_length);
 		sg = ccp_crypto_sg_table_add(&rctx->data_sg, &rctx->pad_sg);
 	}
-	if (sg)
+	if (sg) {
 		sg_mark_end(sg);
+		sg = rctx->data_sg.sgl;
+	}
 
 	/* Initialize the K1/K2 scatterlist */
 	if (final)
@@ -143,7 +145,7 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	rctx->cmd.u.aes.key_len = ctx->u.aes.key_len;
 	rctx->cmd.u.aes.iv = &rctx->iv_sg;
 	rctx->cmd.u.aes.iv_len = AES_BLOCK_SIZE;
-	rctx->cmd.u.aes.src = (sg) ? rctx->data_sg.sgl : NULL;
+	rctx->cmd.u.aes.src = sg;
 	rctx->cmd.u.aes.src_len = rctx->hash_cnt;
 	rctx->cmd.u.aes.dst = NULL;
 	rctx->cmd.u.aes.cmac_key = cmac_key_sg;
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 0571940..bf913cb 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -122,7 +122,6 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 			     unsigned int final)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ccp_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
 	struct scatterlist *sg;
 	unsigned int block_size =
@@ -153,35 +152,32 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	/* Initialize the context scatterlist */
 	sg_init_one(&rctx->ctx_sg, rctx->ctx, sizeof(rctx->ctx));
 
-	/* Build the data scatterlist table - allocate enough entries for all
-	 * possible data pieces (hmac ipad, buffer, input data)
-	 */
-	sg_count = (nbytes) ? sg_nents(req->src) + 2 : 2;
-	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
-		GFP_KERNEL : GFP_ATOMIC;
-	ret = sg_alloc_table(&rctx->data_sg, sg_count, gfp);
-	if (ret)
-		return ret;
-
 	sg = NULL;
-	if (rctx->first && ctx->u.sha.key_len) {
-		rctx->hash_cnt += block_size;
-
-		sg_init_one(&rctx->pad_sg, ctx->u.sha.ipad, block_size);
-		sg = ccp_crypto_sg_table_add(&rctx->data_sg, &rctx->pad_sg);
-	}
+	if (rctx->buf_count && nbytes) {
+		/* Build the data scatterlist table - allocate enough entries
+		 * for both data pieces (buffer and input data)
+		 */
+		gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+			GFP_KERNEL : GFP_ATOMIC;
+		sg_count = sg_nents(req->src) + 1;
+		ret = sg_alloc_table(&rctx->data_sg, sg_count, gfp);
+		if (ret)
+			return ret;
 
-	if (rctx->buf_count) {
 		sg_init_one(&rctx->buf_sg, rctx->buf, rctx->buf_count);
 		sg = ccp_crypto_sg_table_add(&rctx->data_sg, &rctx->buf_sg);
-	}
-
-	if (nbytes)
 		sg = ccp_crypto_sg_table_add(&rctx->data_sg, req->src);
-
-	if (sg)
 		sg_mark_end(sg);
 
+		sg = rctx->data_sg.sgl;
+	} else if (rctx->buf_count) {
+		sg_init_one(&rctx->buf_sg, rctx->buf, rctx->buf_count);
+
+		sg = &rctx->buf_sg;
+	} else if (nbytes) {
+		sg = req->src;
+	}
+
 	rctx->msg_bits += (rctx->hash_cnt << 3);	/* Total in bits */
 
 	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
@@ -190,7 +186,7 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	rctx->cmd.u.sha.type = rctx->type;
 	rctx->cmd.u.sha.ctx = &rctx->ctx_sg;
 	rctx->cmd.u.sha.ctx_len = sizeof(rctx->ctx);
-	rctx->cmd.u.sha.src = (sg) ? rctx->data_sg.sgl : NULL;
+	rctx->cmd.u.sha.src = sg;
 	rctx->cmd.u.sha.src_len = rctx->hash_cnt;
 	rctx->cmd.u.sha.final = rctx->final;
 	rctx->cmd.u.sha.msg_bits = rctx->msg_bits;
@@ -205,9 +201,12 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 static int ccp_sha_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ccp_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
 	struct ccp_crypto_ahash_alg *alg =
 		ccp_crypto_ahash_alg(crypto_ahash_tfm(tfm));
+	unsigned int block_size =
+		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 
 	memset(rctx, 0, sizeof(*rctx));
 
@@ -215,6 +214,12 @@ static int ccp_sha_init(struct ahash_request *req)
 	rctx->type = alg->type;
 	rctx->first = 1;
 
+	if (ctx->u.sha.key_len) {
+		/* Buffer the HMAC key for first update */
+		memcpy(rctx->buf, ctx->u.sha.ipad, block_size);
+		rctx->buf_count = block_size;
+	}
+
 	return 0;
 }
 


