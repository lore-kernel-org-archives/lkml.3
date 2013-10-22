Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3JVVI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:08:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:54738 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab3JVVI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:08:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="423109310"
Subject: [PATCH v2 10/13] async_pq_val: convert to dmaengine_unmap_data
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: linux@arm.linux.org.uk, b.zolnierkie@samsung.com, vinod.koul@intel.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, dave.jiang@intel.com
Date: Tue, 22 Oct 2013 14:08:26 -0700
Message-ID: <20131022210826.31319.42782.stgit@viggo.jf.intel.com>
In-Reply-To: <1382117733-16720-11-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-11-git-send-email-b.zolnierkie@samsung.com>
User-Agent: StGit/0.17-1-g7c57
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic unmap object to unmap dma buffers.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

 Resend to:
	1/ add it to the new dmaengine patchwork
	2/ cc maintainers of affected drivers
	3/ fixup some mail addresses

 crypto/async_tx/async_pq.c |   58 +++++++++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 8cdbf33bd046..4126b56fbc01 100644
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

