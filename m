Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab3JRRgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:36:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40577 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab3JRRgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:36:35 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-f1-526171a2685c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dave.jiang@intel.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        Dan Williams <djbw@fb.com>
Subject: [PATCH v2 10/13] async_pq_val: convert to dmaengine_unmap_data
Date: Fri, 18 Oct 2013 19:35:30 +0200
Message-id: <1382117733-16720-11-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd1FhYlBBtPa+S02zljPajF96gVG
	ixM3G9ksNvc/YLM42/SG3eLyrjlsFrcv81qsn/GaxeJl334WB06PluYeNo+Jze/YPRbvecnk
	0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBm3N65lLvgkVfFwWVID4yWRLkZODgkBE4ndP74x
	QthiEhfurWfrYuTiEBJYxCix6dEjFgini0niytGlbCBVbAJWEhPbV4F1iAjISGz4v50ZpIhZ
	4DyjxOoDK8ESwgLuEl+Xb2ICsVkEVCVuv+tnBrF5BTwllqw5ygqxTl7i6f0+sKGcQPFp+5aD
	2UICHhLnzrxkm8DIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcKA9k97BuKrB4hCj
	AAejEg9vh01ikBBrYllxZe4hRgkOZiUR3jJnoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63W
	gUIC6YklqdmpqQWpRTBZJg5OqQZGcYvCDVv3aKgf277j0z3eB9aNRcfWR/2Zwq5f1yyV92DL
	zy8zlq1dr6UhkGax+KmNwDORBZO+PVkWFLq9oWeKmvEG0a97J6j/nVig0pCkfCp027m/1mXu
	26Skkyy/+Ku6dfd927LhyedXtw4s/n6W1atksSpnmntoeFF8kpH/CydzIeZExxudSizFGYmG
	WsxFxYkAAUTrXzACAAA=
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
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_pq.c | 58 ++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 8cdbf33..4126b56 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -290,50 +290,60 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 	struct dma_async_tx_descriptor *tx;
 	unsigned char coefs[disks-2];
 	enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
-	dma_addr_t *dma_src = NULL;
-	int src_cnt = 0;
+	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(disks < 4);
 
-	if (submit->scribble)
-		dma_src = submit->scribble;
-	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
-		dma_src = (dma_addr_t *) blocks;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
 
-	if (dma_src && device && disks <= dma_maxpq(device, 0) &&
+	if (unmap && disks <= dma_maxpq(device, 0) &&
 	    is_dma_pq_aligned(device, offset, 0, len)) {
 		struct device *dev = device->dev;
-		dma_addr_t *pq = &dma_src[disks-2];
-		int i;
+		dma_addr_t pq[2];
+		int i, j = 0, src_cnt = 0;
 
 		pr_debug("%s: (async) disks: %d len: %zu\n",
 			 __func__, disks, len);
-		if (!P(blocks, disks))
+
+		unmap->len = len;
+		for (i = 0; i < disks-2; i++)
+			if (likely(blocks[i])) {
+				unmap->addr[j] = dma_map_page(dev, blocks[i],
+							      offset, len,
+							      DMA_TO_DEVICE);
+				coefs[j] = raid6_gfexp[i];
+				unmap->to_cnt++;
+				src_cnt++;
+				j++;
+			}
+
+		if (!P(blocks, disks)) {
+			pq[0] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_P;
-		else
+		} else {
 			pq[0] = dma_map_page(dev, P(blocks, disks),
 					     offset, len,
 					     DMA_TO_DEVICE);
-		if (!Q(blocks, disks))
+			unmap->addr[j++] = pq[0];
+			unmap->to_cnt++;
+		}
+		if (!Q(blocks, disks)) {
+			pq[1] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
-		else
+		} else {
 			pq[1] = dma_map_page(dev, Q(blocks, disks),
 					     offset, len,
 					     DMA_TO_DEVICE);
+			unmap->addr[j++] = pq[1];
+			unmap->to_cnt++;
+		}
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		for (i = 0; i < disks-2; i++)
-			if (likely(blocks[i])) {
-				dma_src[src_cnt] = dma_map_page(dev, blocks[i],
-								offset, len,
-								DMA_TO_DEVICE);
-				coefs[src_cnt] = raid6_gfexp[i];
-				src_cnt++;
-			}
-
 		for (;;) {
-			tx = device->device_prep_dma_pq_val(chan, pq, dma_src,
+			tx = device->device_prep_dma_pq_val(chan, pq,
+							    unmap->addr,
 							    src_cnt,
 							    coefs,
 							    len, pqres,
@@ -343,6 +353,8 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 			async_tx_quiesce(&submit->depend_tx);
 			dma_async_issue_pending(chan);
 		}
+
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 
 		return tx;
-- 
1.8.2.3

