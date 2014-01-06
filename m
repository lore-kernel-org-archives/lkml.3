Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaAFTeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:34:25 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:31411
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421AbaAFTeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:34:18 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MYZVO4-07-DAE-02
X-M-MSG: 
Subject: [PATCH 3/6] crypto: ccp - Check for caller result area before using it
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jan 2014 13:34:11 -0600
Message-ID: <20140106193411.26918.88765.stgit@tlendack-t1.amdoffice.net>
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

For a hash operation, the caller doesn't have to supply a result
area on every call so don't use it / update it if it hasn't
been supplied.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    4 +++-
 drivers/crypto/ccp/ccp-crypto-sha.c      |    7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 646c8d1..c6b8f9e 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -43,7 +43,9 @@ static int ccp_aes_cmac_complete(struct crypto_async_request *async_req,
 	} else
 		rctx->buf_count = 0;
 
-	memcpy(req->result, rctx->iv, digest_size);
+	/* Update result area if supplied */
+	if (req->result)
+		memcpy(req->result, rctx->iv, digest_size);
 
 e_free:
 	sg_free_table(&rctx->data_sg);
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index bf913cb..183d16e 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -74,6 +74,7 @@ static int ccp_sha_finish_hmac(struct crypto_async_request *async_req)
 	struct ahash_request *req = ahash_request_cast(async_req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct ccp_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
 	struct scatterlist sg[2];
 	unsigned int block_size =
 		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
@@ -81,7 +82,7 @@ static int ccp_sha_finish_hmac(struct crypto_async_request *async_req)
 
 	sg_init_table(sg, ARRAY_SIZE(sg));
 	sg_set_buf(&sg[0], ctx->u.sha.opad, block_size);
-	sg_set_buf(&sg[1], req->result, digest_size);
+	sg_set_buf(&sg[1], rctx->ctx, digest_size);
 
 	return ccp_sync_hash(ctx->u.sha.hmac_tfm, req->result, sg,
 			     block_size + digest_size);
@@ -106,7 +107,9 @@ static int ccp_sha_complete(struct crypto_async_request *async_req, int ret)
 	} else
 		rctx->buf_count = 0;
 
-	memcpy(req->result, rctx->ctx, digest_size);
+	/* Update result area if supplied */
+	if (req->result)
+		memcpy(req->result, rctx->ctx, digest_size);
 
 	/* If we're doing an HMAC, we need to perform that on the final op */
 	if (rctx->final && ctx->u.sha.key_len)


