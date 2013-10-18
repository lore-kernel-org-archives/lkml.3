Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3JRRij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:38:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17942 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab3JRRg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:36:28 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d5-5261719b9d7f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dave.jiang@intel.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        Dan Williams <djbw@fb.com>
Subject: [PATCH v2 08/13] async_raid6_recov: convert to dmaengine_unmap_data
Date: Fri, 18 Oct 2013 19:35:28 +0200
Message-id: <1382117733-16720-9-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd3ZhYlBBj/Wc1hsnLGe1WL61AuM
	FiduNrJZbO5/wGZxtukNu8XlXXPYLG5f5rVYP+M1i8XLvv0sDpweLc09bB4Tm9+xeyze85LJ
	o2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDI2n7nPVLBIq+Jj9wqmBsYJSl2MHBwSAiYSl/7y
	dTFyApliEhfurWfrYuTiEBJYxCjx4OExRgini0ni67aLTCBVbAJWEhPbVzGC2CICMhIb/m9n
	BiliFjjPKLH6wEqwhLCAj8TOYx1sIDaLgKrEhmMtrCA2r4CHxO/vr1gh1slLPL3fB1bDKeAp
	MW3fcjBbCKjm3JmXbBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA60Z1I7GFc2
	WBxiFOBgVOLhfWCXGCTEmlhWXJl7iFGCg1lJhLfMGSjEm5JYWZValB9fVJqTWnyIUZqDRUmc
	90CrdaCQQHpiSWp2ampBahFMlomDU6qB8aTy5OhH29V/5U9fVvPqosLnOyf60xbVvdn2wCFK
	KjlngsQU/s89ly8aNMjN42Xi6hI7efkNZ+y9Za/Wb3myVWhjLr9i+/47C6fN1DjMcEJJ9F8j
	f9mb5qsmb3V+pvhNKLA59Hntniz/Val/SmuEPq45cc3ru12V2oPMg5OURUtrtie9nu/0S1qJ
	pTgj0VCLuag4EQAIH63aMAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <djbw@fb.com>

Use the generic unmap object to unmap dma buffers.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Dan Williams <djbw@fb.com>
[bzolnier: keep temporary dma_dest array in async_mult()]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_raid6_recov.c | 69 ++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 20 deletions(-)

diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index a9f08a6..a3a72a7 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -26,6 +26,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
+#include <linux/dmaengine.h>
 
 static struct dma_async_tx_descriptor *
 async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
@@ -34,35 +35,47 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, srcs, 2, len);
 	struct dma_device *dma = chan ? chan->device : NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 	const u8 *amul, *bmul;
 	u8 ax, bx;
 	u8 *a, *b, *c;
 
-	if (dma) {
-		dma_addr_t dma_dest[2];
-		dma_addr_t dma_src[2];
+	if (dma)
+		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOIO);
+
+	if (unmap) {
 		struct device *dev = dma->dev;
+		dma_addr_t pq[2];
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+						DMA_COMPL_SKIP_DEST_UNMAP |
+						DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		dma_dest[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
-		dma_src[0] = dma_map_page(dev, srcs[0], 0, len, DMA_TO_DEVICE);
-		dma_src[1] = dma_map_page(dev, srcs[1], 0, len, DMA_TO_DEVICE);
-		tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 2, coef,
+		unmap->addr[0] = dma_map_page(dev, srcs[0], 0, len, DMA_TO_DEVICE);
+		unmap->addr[1] = dma_map_page(dev, srcs[1], 0, len, DMA_TO_DEVICE);
+		unmap->to_cnt = 2;
+
+		unmap->addr[2] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
+		unmap->bidi_cnt = 1;
+		/* engine only looks at Q, but expects it to follow P */
+		pq[1] = unmap->addr[2];
+
+		unmap->len = len;
+		tx = dma->device_prep_dma_pq(chan, pq, unmap->addr, 2, coef,
 					     len, dma_flags);
 		if (tx) {
+			dma_set_unmap(tx, unmap);
 			async_tx_submit(chan, tx, submit);
+			dmaengine_unmap_put(unmap);
 			return tx;
 		}
 
 		/* could not get a descriptor, unmap and fall through to
 		 * the synchronous path
 		 */
-		dma_unmap_page(dev, dma_dest[1], len, DMA_BIDIRECTIONAL);
-		dma_unmap_page(dev, dma_src[0], len, DMA_TO_DEVICE);
-		dma_unmap_page(dev, dma_src[1], len, DMA_TO_DEVICE);
+		dmaengine_unmap_put(unmap);
 	}
 
 	/* run the operation synchronously */
@@ -89,23 +102,40 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, &src, 1, len);
 	struct dma_device *dma = chan ? chan->device : NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 	const u8 *qmul; /* Q multiplier table */
 	u8 *d, *s;
 
-	if (dma) {
+	if (dma)
+		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOIO);
+
+	if (unmap) {
 		dma_addr_t dma_dest[2];
-		dma_addr_t dma_src[1];
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+						DMA_COMPL_SKIP_DEST_UNMAP |
+						DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		dma_dest[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
-		dma_src[0] = dma_map_page(dev, src, 0, len, DMA_TO_DEVICE);
-		tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 1, &coef,
-					     len, dma_flags);
+		unmap->addr[0] = dma_map_page(dev, src, 0, len, DMA_TO_DEVICE);
+		unmap->to_cnt++;
+		unmap->addr[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
+		dma_dest[1] = unmap->addr[1];
+		unmap->bidi_cnt++;
+		unmap->len = len;
+
+		/* this looks funny, but the engine looks for Q at
+		 * dma_dest[1] and ignores dma_dest[0] as a dest
+		 * due to DMA_PREP_PQ_DISABLE_P
+		 */
+		tx = dma->device_prep_dma_pq(chan, dma_dest, unmap->addr,
+					     1, &coef, len, dma_flags);
+
 		if (tx) {
+			dma_set_unmap(tx, unmap);
+			dmaengine_unmap_put(unmap);
 			async_tx_submit(chan, tx, submit);
 			return tx;
 		}
@@ -113,8 +143,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 		/* could not get a descriptor, unmap and fall through to
 		 * the synchronous path
 		 */
-		dma_unmap_page(dev, dma_dest[1], len, DMA_BIDIRECTIONAL);
-		dma_unmap_page(dev, dma_src[0], len, DMA_TO_DEVICE);
+		dmaengine_unmap_put(unmap);
 	}
 
 	/* no channel available, or failed to allocate a descriptor, so
-- 
1.8.2.3

