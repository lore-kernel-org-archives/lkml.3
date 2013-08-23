Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3HWUBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:01:47 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:59119 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab3HWUBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:01:45 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH 06/10] crypto: nx - fix limits to sg lists for AES-XCBC
Date: Fri, 23 Aug 2013 17:01:10 -0300
Message-Id: <1377288074-18998-7-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082320-9254-0000-0000-00000D6C7BCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fionnuala Gunter <fin@linux.vnet.ibm.com>

This patch updates the NX driver to perform several hyper calls when necessary
so that the length limits of scatter/gather lists are respected.

Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Reviewed-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-xcbc.c | 107 +++++++++++++++++++++++-----------------
 1 file changed, 63 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-xcbc.c b/drivers/crypto/nx/nx-aes-xcbc.c
index 658da0f..1a5d9e3 100644
--- a/drivers/crypto/nx/nx-aes-xcbc.c
+++ b/drivers/crypto/nx/nx-aes-xcbc.c
@@ -88,78 +88,97 @@ static int nx_xcbc_update(struct shash_desc *desc,
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct nx_sg *in_sg;
-	u32 to_process, leftover;
+	u32 to_process, leftover, total;
+	u32 max_sg_len;
 	unsigned long irq_flags;
 	int rc = 0;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
-		/* we've hit the nx chip previously and we're updating again,
-		 * so copy over the partial digest */
-		memcpy(csbcpb->cpb.aes_xcbc.cv,
-		       csbcpb->cpb.aes_xcbc.out_cv_mac, AES_BLOCK_SIZE);
-	}
+
+	total = sctx->count + len;
 
 	/* 2 cases for total data len:
 	 *  1: <= AES_BLOCK_SIZE: copy into state, return 0
 	 *  2: > AES_BLOCK_SIZE: process X blocks, copy in leftover
 	 */
-	if (len + sctx->count <= AES_BLOCK_SIZE) {
+	if (total <= AES_BLOCK_SIZE) {
 		memcpy(sctx->buffer + sctx->count, data, len);
 		sctx->count += len;
 		goto out;
 	}
 
-	/* to_process: the AES_BLOCK_SIZE data chunk to process in this
-	 * update */
-	to_process = (sctx->count + len) & ~(AES_BLOCK_SIZE - 1);
-	leftover = (sctx->count + len) & (AES_BLOCK_SIZE - 1);
+	in_sg = nx_ctx->in_sg;
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+				nx_ctx->ap->sglen);
 
-	/* the hardware will not accept a 0 byte operation for this algorithm
-	 * and the operation MUST be finalized to be correct. So if we happen
-	 * to get an update that falls on a block sized boundary, we must
-	 * save off the last block to finalize with later. */
-	if (!leftover) {
-		to_process -= AES_BLOCK_SIZE;
-		leftover = AES_BLOCK_SIZE;
-	}
+	do {
 
-	if (sctx->count) {
-		in_sg = nx_build_sg_list(nx_ctx->in_sg, sctx->buffer,
-					 sctx->count, nx_ctx->ap->sglen);
-		in_sg = nx_build_sg_list(in_sg, (u8 *)data,
-					 to_process - sctx->count,
-					 nx_ctx->ap->sglen);
-		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) *
-					sizeof(struct nx_sg);
-	} else {
-		in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *)data, to_process,
-					 nx_ctx->ap->sglen);
+		/* to_process: the AES_BLOCK_SIZE data chunk to process in this
+		 * update */
+		to_process = min_t(u64, total, nx_ctx->ap->databytelen);
+		to_process = min_t(u64, to_process,
+					NX_PAGE_SIZE * (max_sg_len - 1));
+		to_process = to_process & ~(AES_BLOCK_SIZE - 1);
+		leftover = total - to_process;
+
+		/* the hardware will not accept a 0 byte operation for this
+		 * algorithm and the operation MUST be finalized to be correct.
+		 * So if we happen to get an update that falls on a block sized
+		 * boundary, we must save off the last block to finalize with
+		 * later. */
+		if (!leftover) {
+			to_process -= AES_BLOCK_SIZE;
+			leftover = AES_BLOCK_SIZE;
+		}
+
+		if (sctx->count) {
+			in_sg = nx_build_sg_list(nx_ctx->in_sg,
+						(u8 *) sctx->buffer,
+						sctx->count,
+						max_sg_len);
+		}
+		in_sg = nx_build_sg_list(in_sg,
+					(u8 *) data,
+					to_process - sctx->count,
+					max_sg_len);
 		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) *
 					sizeof(struct nx_sg);
-	}
 
-	NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
+		/* we've hit the nx chip previously and we're updating again,
+		 * so copy over the partial digest */
+		if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
+			memcpy(csbcpb->cpb.aes_xcbc.cv,
+				csbcpb->cpb.aes_xcbc.out_cv_mac,
+				AES_BLOCK_SIZE);
+		}
 
-	if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
-		rc = -EINVAL;
-		goto out;
-	}
+		NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
+		if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
+			rc = -EINVAL;
+			goto out;
+		}
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
 			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (rc)
-		goto out;
+		if (rc)
+			goto out;
 
-	atomic_inc(&(nx_ctx->stats->aes_ops));
+		atomic_inc(&(nx_ctx->stats->aes_ops));
+
+		/* everything after the first update is continuation */
+		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
+
+		total -= to_process;
+		data += to_process - sctx->count;
+		sctx->count = 0;
+		in_sg = nx_ctx->in_sg;
+	} while (leftover > AES_BLOCK_SIZE);
 
 	/* copy the leftover back into the state struct */
-	memcpy(sctx->buffer, data + len - leftover, leftover);
+	memcpy(sctx->buffer, data, leftover);
 	sctx->count = leftover;
 
-	/* everything after the first update is continuation */
-	NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
-- 
1.7.12

