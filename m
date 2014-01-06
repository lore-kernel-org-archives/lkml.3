Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbaAFTee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:34:34 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:22533
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462AbaAFTeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:34:24 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MYZVOD-08-96L-02
X-M-MSG: 
Subject: [PATCH 4/6] crypto: ccp - Change data length declarations to u64
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jan 2014 13:34:17 -0600
Message-ID: <20140106193417.26918.68325.stgit@tlendack-t1.amdoffice.net>
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

When performing a hash operation if the amount of data buffered and a
request at or near the maximum data length is received then the length
calcuation could wrap causing an error in executing the hash operation.
Fix this by using a u64 type for the input and output data lengths in
all CCP operations.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   21 +++++++++++--------
 drivers/crypto/ccp/ccp-crypto-sha.c      |   21 +++++++++++--------
 drivers/crypto/ccp/ccp-crypto.h          |   10 +++++++--
 drivers/crypto/ccp/ccp-ops.c             |   34 +++++++++++++++++-------------
 include/linux/ccp.h                      |    8 ++++---
 5 files changed, 57 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index c6b8f9e..a52b97a 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -37,8 +37,9 @@ static int ccp_aes_cmac_complete(struct crypto_async_request *async_req,
 
 	if (rctx->hash_rem) {
 		/* Save remaining data to buffer */
-		scatterwalk_map_and_copy(rctx->buf, rctx->cmd.u.aes.src,
-					 rctx->hash_cnt, rctx->hash_rem, 0);
+		unsigned int offset = rctx->nbytes - rctx->hash_rem;
+		scatterwalk_map_and_copy(rctx->buf, rctx->src,
+					 offset, rctx->hash_rem, 0);
 		rctx->buf_count = rctx->hash_rem;
 	} else
 		rctx->buf_count = 0;
@@ -62,8 +63,9 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	struct scatterlist *sg, *cmac_key_sg = NULL;
 	unsigned int block_size =
 		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
-	unsigned int len, need_pad, sg_count;
+	unsigned int need_pad, sg_count;
 	gfp_t gfp;
+	u64 len;
 	int ret;
 
 	if (!ctx->u.aes.key_len)
@@ -72,7 +74,9 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	if (nbytes)
 		rctx->null_msg = 0;
 
-	if (!final && ((nbytes + rctx->buf_count) <= block_size)) {
+	len = (u64)rctx->buf_count + (u64)nbytes;
+
+	if (!final && (len <= block_size)) {
 		scatterwalk_map_and_copy(rctx->buf + rctx->buf_count, req->src,
 					 0, nbytes, 0);
 		rctx->buf_count += nbytes;
@@ -80,12 +84,13 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 		return 0;
 	}
 
-	len = rctx->buf_count + nbytes;
+	rctx->src = req->src;
+	rctx->nbytes = nbytes;
 
 	rctx->final = final;
-	rctx->hash_cnt = final ? len : len & ~(block_size - 1);
-	rctx->hash_rem = final ?   0 : len &  (block_size - 1);
-	if (!final && (rctx->hash_cnt == len)) {
+	rctx->hash_rem = final ? 0 : len & (block_size - 1);
+	rctx->hash_cnt = len - rctx->hash_rem;
+	if (!final && !rctx->hash_rem) {
 		/* CCP can't do zero length final, so keep some data around */
 		rctx->hash_cnt -= block_size;
 		rctx->hash_rem = block_size;
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 183d16e..d30f6c8 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -101,8 +101,9 @@ static int ccp_sha_complete(struct crypto_async_request *async_req, int ret)
 
 	if (rctx->hash_rem) {
 		/* Save remaining data to buffer */
-		scatterwalk_map_and_copy(rctx->buf, rctx->cmd.u.sha.src,
-					 rctx->hash_cnt, rctx->hash_rem, 0);
+		unsigned int offset = rctx->nbytes - rctx->hash_rem;
+		scatterwalk_map_and_copy(rctx->buf, rctx->src,
+					 offset, rctx->hash_rem, 0);
 		rctx->buf_count = rctx->hash_rem;
 	} else
 		rctx->buf_count = 0;
@@ -129,11 +130,14 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	struct scatterlist *sg;
 	unsigned int block_size =
 		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
-	unsigned int len, sg_count;
+	unsigned int sg_count;
 	gfp_t gfp;
+	u64 len;
 	int ret;
 
-	if (!final && ((nbytes + rctx->buf_count) <= block_size)) {
+	len = (u64)rctx->buf_count + (u64)nbytes;
+
+	if (!final && (len <= block_size)) {
 		scatterwalk_map_and_copy(rctx->buf + rctx->buf_count, req->src,
 					 0, nbytes, 0);
 		rctx->buf_count += nbytes;
@@ -141,12 +145,13 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 		return 0;
 	}
 
-	len = rctx->buf_count + nbytes;
+	rctx->src = req->src;
+	rctx->nbytes = nbytes;
 
 	rctx->final = final;
-	rctx->hash_cnt = final ? len : len & ~(block_size - 1);
-	rctx->hash_rem = final ?   0 : len &  (block_size - 1);
-	if (!final && (rctx->hash_cnt == len)) {
+	rctx->hash_rem = final ? 0 : len & (block_size - 1);
+	rctx->hash_cnt = len - rctx->hash_rem;
+	if (!final && !rctx->hash_rem) {
 		/* CCP can't do zero length final, so keep some data around */
 		rctx->hash_cnt -= block_size;
 		rctx->hash_rem = block_size;
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 13ea6ea..b222231 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -110,7 +110,10 @@ struct ccp_aes_cmac_req_ctx {
 	unsigned int null_msg;
 	unsigned int final;
 
-	unsigned int hash_cnt;
+	struct scatterlist *src;
+	unsigned int nbytes;
+
+	u64 hash_cnt;
 	unsigned int hash_rem;
 
 	struct sg_table data_sg;
@@ -149,7 +152,10 @@ struct ccp_sha_req_ctx {
 	unsigned int first;
 	unsigned int final;
 
-	unsigned int hash_cnt;
+	struct scatterlist *src;
+	unsigned int nbytes;
+
+	u64 hash_cnt;
 	unsigned int hash_rem;
 
 	struct sg_table data_sg;
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 4be0910..71ed3ad 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -60,9 +60,9 @@ struct ccp_sg_workarea {
 	unsigned int dma_count;
 	enum dma_data_direction dma_dir;
 
-	u32 sg_used;
+	unsigned int sg_used;
 
-	u32 bytes_left;
+	u64 bytes_left;
 };
 
 struct ccp_data {
@@ -466,7 +466,7 @@ static void ccp_sg_free(struct ccp_sg_workarea *wa)
 }
 
 static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
-				struct scatterlist *sg, unsigned int len,
+				struct scatterlist *sg, u64 len,
 				enum dma_data_direction dma_dir)
 {
 	memset(wa, 0, sizeof(*wa));
@@ -499,7 +499,7 @@ static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
 
 static void ccp_update_sg_workarea(struct ccp_sg_workarea *wa, unsigned int len)
 {
-	unsigned int nbytes = min(len, wa->bytes_left);
+	unsigned int nbytes = min_t(u64, len, wa->bytes_left);
 
 	if (!wa->sg)
 		return;
@@ -653,7 +653,7 @@ static void ccp_free_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q)
 }
 
 static int ccp_init_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q,
-			 struct scatterlist *sg, unsigned int sg_len,
+			 struct scatterlist *sg, u64 sg_len,
 			 unsigned int dm_len,
 			 enum dma_data_direction dir)
 {
@@ -691,17 +691,20 @@ static unsigned int ccp_queue_buf(struct ccp_data *data, unsigned int from)
 	if (!sg_wa->sg)
 		return 0;
 
-	/* Perform the copy operation */
-	nbytes = min(sg_wa->bytes_left, dm_wa->length);
+	/* Perform the copy operation
+	 *   nbytes will always be <= UINT_MAX because dm_wa->length is
+	 *   an unsigned int
+	 */
+	nbytes = min_t(u64, sg_wa->bytes_left, dm_wa->length);
 	scatterwalk_map_and_copy(dm_wa->address, sg_wa->sg, sg_wa->sg_used,
 				 nbytes, from);
 
 	/* Update the structures and generate the count */
 	buf_count = 0;
 	while (sg_wa->bytes_left && (buf_count < dm_wa->length)) {
-		nbytes = min3(sg_wa->sg->length - sg_wa->sg_used,
-			      dm_wa->length - buf_count,
-			      sg_wa->bytes_left);
+		nbytes = min(sg_wa->sg->length - sg_wa->sg_used,
+			     dm_wa->length - buf_count);
+		nbytes = min_t(u64, sg_wa->bytes_left, nbytes);
 
 		buf_count += nbytes;
 		ccp_update_sg_workarea(sg_wa, nbytes);
@@ -728,14 +731,15 @@ static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
 
 	/* The CCP can only DMA from/to one address each per operation. This
 	 * requires that we find the smallest DMA area between the source
-	 * and destination.
+	 * and destination. The resulting len values will always be <= UINT_MAX
+	 * because the dma length is an unsigned int.
 	 */
-	sg_src_len = min(sg_dma_len(src->sg_wa.sg) - src->sg_wa.sg_used,
-			 src->sg_wa.bytes_left);
+	sg_src_len = sg_dma_len(src->sg_wa.sg) - src->sg_wa.sg_used;
+	sg_src_len = min_t(u64, src->sg_wa.bytes_left, sg_src_len);
 
 	if (dst) {
-		sg_dst_len = min(sg_dma_len(dst->sg_wa.sg) - dst->sg_wa.sg_used,
-				 src->sg_wa.bytes_left);
+		sg_dst_len = sg_dma_len(dst->sg_wa.sg) - dst->sg_wa.sg_used;
+		sg_dst_len = min_t(u64, src->sg_wa.bytes_left, sg_dst_len);
 		op_len = min(sg_src_len, sg_dst_len);
 	} else
 		op_len = sg_src_len;
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index e8c2349..12f1cfd 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -133,7 +133,7 @@ struct ccp_aes_engine {
 	u32 iv_len;		/* In bytes */
 
 	struct scatterlist *src, *dst;
-	u32 src_len;		/* In bytes */
+	u64 src_len;		/* In bytes */
 
 	u32 cmac_final;		/* Indicates final cmac cmd */
 	struct scatterlist *cmac_key;	/* K1/K2 cmac key required for
@@ -190,7 +190,7 @@ struct ccp_xts_aes_engine {
 	u32 iv_len;		/* In bytes */
 
 	struct scatterlist *src, *dst;
-	u32 src_len;		/* In bytes */
+	u64 src_len;		/* In bytes */
 
 	u32 final;
 };
@@ -237,7 +237,7 @@ struct ccp_sha_engine {
 	u32 ctx_len;		/* In bytes */
 
 	struct scatterlist *src;
-	u32 src_len;		/* In bytes */
+	u64 src_len;		/* In bytes */
 
 	u32 final;		/* Indicates final sha cmd */
 	u64 msg_bits;		/* Message length in bits required for
@@ -328,7 +328,7 @@ struct ccp_passthru_engine {
 	u32 mask_len;		/* In bytes */
 
 	struct scatterlist *src, *dst;
-	u32 src_len;		/* In bytes */
+	u64 src_len;		/* In bytes */
 
 	u32 final;
 };


