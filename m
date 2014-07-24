Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbaGXN6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:58:40 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:55461 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758778AbaGXN6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:58:39 -0400
Date: Thu, 24 Jul 2014 10:58:33 -0300
From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com
Subject: [PATCH 4/8] Replacing spinlocks by nx_copy_ctx on NX-AES-CTR
Message-ID: <20140724135830.GA25269@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072413-2194-0000-0000-000000181F3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces spinlock usage by a simple copy of the crypto context, avoiding
possible bottlenecks.

Signed-off-by: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-ctr.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index a37d009..4a8a196 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -88,34 +88,38 @@ static int ctr_aes_nx_crypt(struct blkcipher_desc *desc,
 {
 	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
-	unsigned long irq_flags;
 	unsigned int processed = 0, to_process;
 	u32 max_sg_len;
 	int rc;
 
-	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
+	struct nx_crypto_ctx curr_nx_ctx;
+
+	if (nx_copy_ctx(&curr_nx_ctx, nx_ctx))
+		return -ENOMEM;
+
+	csbcpb = curr_nx_ctx.csbcpb;
 
 	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
+			   curr_nx_ctx.ap->sglen);
 
 	do {
 		to_process = min_t(u64, nbytes - processed,
-				   nx_ctx->ap->databytelen);
+				   curr_nx_ctx.ap->databytelen);
 		to_process = min_t(u64, to_process,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 		to_process = to_process & ~(AES_BLOCK_SIZE - 1);
 
-		rc = nx_build_sg_lists(nx_ctx, desc, dst, src, to_process,
+		rc = nx_build_sg_lists(&curr_nx_ctx, desc, dst, src, to_process,
 				       processed, csbcpb->cpb.aes_ctr.iv);
 		if (rc)
 			goto out;
 
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
@@ -129,7 +133,7 @@ static int ctr_aes_nx_crypt(struct blkcipher_desc *desc,
 		processed += to_process;
 	} while (processed < nbytes);
 out:
-	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
+	kmem_cache_free(nx_driver.slab, curr_nx_ctx.kmem);
 	return rc;
 }
 
-- 
1.7.1

