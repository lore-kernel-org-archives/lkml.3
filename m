Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183AbaLBTWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:22:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaLBTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:22:04 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cristian Stoica <cristian.stoica@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 059/121] crypto: caam - fix missing dma unmap on error path
Date: Tue,  2 Dec 2014 11:18:58 -0800
Message-Id: <1417548000-1794-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Stoica <cristian.stoica@freescale.com>

commit 738459e3f88538f2ece263424dafe5d91799e46b upstream.

If dma mapping for dma_addr_out fails, the descriptor memory is freed
but the previous dma mapping for dma_addr_in remains.
This patch resolves the missing dma unmap and groups resource
allocations at function start.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/crypto/caam/key_gen.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index ea2e406..b872eed 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -51,23 +51,29 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 	u32 *desc;
 	struct split_key_result result;
 	dma_addr_t dma_addr_in, dma_addr_out;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	desc = kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
 	if (!desc) {
 		dev_err(jrdev, "unable to allocate key input memory\n");
-		return -ENOMEM;
+		return ret;
 	}
 
-	init_job_desc(desc, 0);
-
 	dma_addr_in = dma_map_single(jrdev, (void *)key_in, keylen,
 				     DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, dma_addr_in)) {
 		dev_err(jrdev, "unable to map key input memory\n");
-		kfree(desc);
-		return -ENOMEM;
+		goto out_free;
 	}
+
+	dma_addr_out = dma_map_single(jrdev, key_out, split_key_pad_len,
+				      DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, dma_addr_out)) {
+		dev_err(jrdev, "unable to map key output memory\n");
+		goto out_unmap_in;
+	}
+
+	init_job_desc(desc, 0);
 	append_key(desc, dma_addr_in, keylen, CLASS_2 | KEY_DEST_CLASS_REG);
 
 	/* Sets MDHA up into an HMAC-INIT */
@@ -84,13 +90,6 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 	 * FIFO_STORE with the explicit split-key content store
 	 * (0x26 output type)
 	 */
-	dma_addr_out = dma_map_single(jrdev, key_out, split_key_pad_len,
-				      DMA_FROM_DEVICE);
-	if (dma_mapping_error(jrdev, dma_addr_out)) {
-		dev_err(jrdev, "unable to map key output memory\n");
-		kfree(desc);
-		return -ENOMEM;
-	}
 	append_fifo_store(desc, dma_addr_out, split_key_len,
 			  LDST_CLASS_2_CCB | FIFOST_TYPE_SPLIT_KEK);
 
@@ -118,10 +117,10 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 
 	dma_unmap_single(jrdev, dma_addr_out, split_key_pad_len,
 			 DMA_FROM_DEVICE);
+out_unmap_in:
 	dma_unmap_single(jrdev, dma_addr_in, keylen, DMA_TO_DEVICE);
-
+out_free:
 	kfree(desc);
-
 	return ret;
 }
 EXPORT_SYMBOL(gen_split_key);
-- 
1.9.1

