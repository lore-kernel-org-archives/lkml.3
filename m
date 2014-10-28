Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaJ1Rsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:48:54 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:56589 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaJ1Rsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:48:52 -0400
Date: Tue, 28 Oct 2014 15:48:47 -0200
From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH 6/9] Moving NX-AES-XCBC to be processed logic
Message-ID: <20141028174845.GA17838@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102817-0017-0000-0000-000000D90464
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous limits were estimated locally in a single step
basead on bound values, however it was not correct since
when given certain scatterlist the function nx_build_sg_lists
was consuming more sg entries than allocated causing a
memory corruption and crashes.

This patch removes the old logic and replaces it into nx_sg_build_lists
in order to build a correct nx_sg list using the correct sg_max limit
and bounds.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-xcbc.c |   81 ++++++++++++++++++++++++++++++---------
 1 files changed, 63 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-xcbc.c b/drivers/crypto/nx/nx-aes-xcbc.c
index 03c4bf5..8c2faff 100644
--- a/drivers/crypto/nx/nx-aes-xcbc.c
+++ b/drivers/crypto/nx/nx-aes-xcbc.c
@@ -75,6 +75,7 @@ static int nx_xcbc_empty(struct shash_desc *desc, u8 *out)
 	u8 keys[2][AES_BLOCK_SIZE];
 	u8 key[32];
 	int rc = 0;
+	int len;
 
 	/* Change to ECB mode */
 	csbcpb->cpb.hdr.mode = NX_MODE_AES_ECB;
@@ -86,11 +87,20 @@ static int nx_xcbc_empty(struct shash_desc *desc, u8 *out)
 	memset(keys[0], 0x01, sizeof(keys[0]));
 	memset(keys[1], 0x03, sizeof(keys[1]));
 
+	len = sizeof(keys);
 	/* Generate K1 and K3 encrypting the patterns */
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) keys, sizeof(keys),
+	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) keys, &len,
 				 nx_ctx->ap->sglen);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *) keys, sizeof(keys),
+
+	if (len != sizeof(keys))
+		return -EINVAL;
+
+	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *) keys, &len,
 				  nx_ctx->ap->sglen);
+
+	if (len != sizeof(keys))
+		return -EINVAL;
+
 	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
 	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
@@ -103,12 +113,23 @@ static int nx_xcbc_empty(struct shash_desc *desc, u8 *out)
 	/* XOr K3 with the padding for a 0 length message */
 	keys[1][0] ^= 0x80;
 
+	len = sizeof(keys[1]);
+
 	/* Encrypt the final result */
 	memcpy(csbcpb->cpb.aes_ecb.key, keys[0], AES_BLOCK_SIZE);
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) keys[1], sizeof(keys[1]),
+	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) keys[1], &len,
 				 nx_ctx->ap->sglen);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, out, AES_BLOCK_SIZE,
+
+	if (len != sizeof(keys[1]))
+		return -EINVAL;
+
+	len = AES_BLOCK_SIZE;
+	out_sg = nx_build_sg_list(nx_ctx->out_sg, out, &len,
 				  nx_ctx->ap->sglen);
+
+	if (len != AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
 	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
@@ -133,6 +154,7 @@ static int nx_xcbc_init(struct shash_desc *desc)
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct nx_sg *out_sg;
+	int len;
 
 	nx_ctx_init(nx_ctx, HCOP_FC_AES);
 
@@ -144,8 +166,13 @@ static int nx_xcbc_init(struct shash_desc *desc)
 	memcpy(csbcpb->cpb.aes_xcbc.key, nx_ctx->priv.xcbc.key, AES_BLOCK_SIZE);
 	memset(nx_ctx->priv.xcbc.key, 0, sizeof *nx_ctx->priv.xcbc.key);
 
+	len = AES_BLOCK_SIZE;
 	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *)sctx->state,
-				  AES_BLOCK_SIZE, nx_ctx->ap->sglen);
+				  &len, nx_ctx->ap->sglen);
+
+	if (len != AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
 	return 0;
@@ -159,10 +186,11 @@ static int nx_xcbc_update(struct shash_desc *desc,
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct nx_sg *in_sg;
-	u32 to_process, leftover, total;
-	u32 max_sg_len;
+	u32 to_process = 0, leftover, total;
+	unsigned int max_sg_len;
 	unsigned long irq_flags;
 	int rc = 0;
+	int data_len;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
@@ -180,17 +208,15 @@ static int nx_xcbc_update(struct shash_desc *desc,
 	}
 
 	in_sg = nx_ctx->in_sg;
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+	max_sg_len = min_t(u64, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
 				nx_ctx->ap->sglen);
+	max_sg_len = min_t(u64, max_sg_len,
+				nx_ctx->ap->databytelen/NX_PAGE_SIZE);
 
 	do {
-
-		/* to_process: the AES_BLOCK_SIZE data chunk to process in this
-		 * update */
-		to_process = min_t(u64, total, nx_ctx->ap->databytelen);
-		to_process = min_t(u64, to_process,
-					NX_PAGE_SIZE * (max_sg_len - 1));
+		to_process = total - to_process;
 		to_process = to_process & ~(AES_BLOCK_SIZE - 1);
+
 		leftover = total - to_process;
 
 		/* the hardware will not accept a 0 byte operation for this
@@ -204,15 +230,24 @@ static int nx_xcbc_update(struct shash_desc *desc,
 		}
 
 		if (sctx->count) {
+			data_len = sctx->count;
 			in_sg = nx_build_sg_list(nx_ctx->in_sg,
 						(u8 *) sctx->buffer,
-						sctx->count,
+						&data_len,
 						max_sg_len);
+			if (data_len != sctx->count)
+				return -EINVAL;
 		}
+
+		data_len = to_process - sctx->count;
 		in_sg = nx_build_sg_list(in_sg,
 					(u8 *) data,
-					to_process - sctx->count,
+					&data_len,
 					max_sg_len);
+
+		if (data_len != to_process - sctx->count)
+			return -EINVAL;
+
 		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) *
 					sizeof(struct nx_sg);
 
@@ -263,6 +298,7 @@ static int nx_xcbc_final(struct shash_desc *desc, u8 *out)
 	struct nx_sg *in_sg, *out_sg;
 	unsigned long irq_flags;
 	int rc = 0;
+	int len;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
@@ -285,11 +321,20 @@ static int nx_xcbc_final(struct shash_desc *desc, u8 *out)
 	 * this is not an intermediate operation */
 	NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
 
+	len = sctx->count;
 	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *)sctx->buffer,
-				 sctx->count, nx_ctx->ap->sglen);
-	out_sg = nx_build_sg_list(nx_ctx->out_sg, out, AES_BLOCK_SIZE,
+				 &len, nx_ctx->ap->sglen);
+
+	if (len != sctx->count)
+		return -EINVAL;
+
+	len = AES_BLOCK_SIZE;
+	out_sg = nx_build_sg_list(nx_ctx->out_sg, out, &len,
 				  nx_ctx->ap->sglen);
 
+	if (len != AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
 	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
-- 
1.7.1

