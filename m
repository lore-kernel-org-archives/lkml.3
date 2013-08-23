Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3HWUBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:01:41 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:53176 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3HWUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:01:37 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 02/10] crypto: nx - fix limits to sg lists for AES-ECB
Date: Fri, 23 Aug 2013 17:01:06 -0300
Message-Id: <1377288074-18998-3-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082320-2362-0000-0000-00000B92FECE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the nx-aes-ecb implementation to perform several
hyper calls if needed in order to always respect the length limits for
scatter/gather lists.

Two different limits are considered:

 - "ibm,max-sg-len": maximum number of bytes of each scatter/gather
   list.

 - "ibm,max-sync-cop":
    - The total number of bytes that a scatter/gather list can hold.
    - The maximum number of elements that a scatter/gather list can have.

Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-ecb.c | 48 ++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
index fe0d803..85a8d23 100644
--- a/drivers/crypto/nx/nx-aes-ecb.c
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -71,37 +71,49 @@ static int ecb_aes_nx_crypt(struct blkcipher_desc *desc,
 	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	unsigned long irq_flags;
+	unsigned int processed = 0, to_process;
+	u32 max_sg_len;
 	int rc;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	if (nbytes > nx_ctx->ap->databytelen) {
-		rc = -EINVAL;
-		goto out;
-	}
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+			   nx_ctx->ap->sglen);
 
 	if (enc)
 		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 	else
 		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
-	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes, 0, NULL);
-	if (rc)
-		goto out;
+	do {
+		to_process = min_t(u64, nbytes - processed,
+				   nx_ctx->ap->databytelen);
+		to_process = min_t(u64, to_process,
+				   NX_PAGE_SIZE * (max_sg_len - 1));
+		to_process = to_process & ~(AES_BLOCK_SIZE - 1);
 
-	if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
-		rc = -EINVAL;
-		goto out;
-	}
+		rc = nx_build_sg_lists(nx_ctx, desc, dst, src, to_process,
+				processed, NULL);
+		if (rc)
+			goto out;
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (rc)
-		goto out;
+		if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+				   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		if (rc)
+			goto out;
+
+		atomic_inc(&(nx_ctx->stats->aes_ops));
+		atomic64_add(csbcpb->csb.processed_byte_count,
+			     &(nx_ctx->stats->aes_bytes));
+
+		processed += to_process;
+	} while (processed < nbytes);
 
-	atomic_inc(&(nx_ctx->stats->aes_ops));
-	atomic64_add(csbcpb->csb.processed_byte_count,
-		     &(nx_ctx->stats->aes_bytes));
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
-- 
1.7.12

