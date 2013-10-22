Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3JVVIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:08:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:8268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab3JVVI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:08:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311285540"
Subject: [PATCH v2 09/13] async_pq: convert to dmaengine_unmap_data
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: linux@arm.linux.org.uk, b.zolnierkie@samsung.com, vinod.koul@intel.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, dave.jiang@intel.com
Date: Tue, 22 Oct 2013 14:08:23 -0700
Message-ID: <20131022210823.31296.2823.stgit@viggo.jf.intel.com>
In-Reply-To: <1382117733-16720-10-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-10-git-send-email-b.zolnierkie@samsung.com>
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
[bzolnier: keep temporary dma_dest array in do_async_gen_syndrome()]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

 Resend to:
	1/ add it to the new dmaengine patchwork
	2/ cc maintainers of affected drivers
	3/ fixup some mail addresses

 crypto/async_tx/async_pq.c |  117 ++++++++++++++++++++++++--------------------
 drivers/dma/dmaengine.c    |    5 ++
 2 files changed, 69 insertions(+), 53 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 91d5d385899e..8cdbf33bd046 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -46,49 +46,25 @@ static struct page *pq_scribble_page;
  * do_async_gen_syndrome - asynchronously calculate P and/or Q
  */
 static __async_inline struct dma_async_tx_descriptor *
-do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
-		      const unsigned char *scfs, unsigned int offset, int disks,
-		      size_t len, dma_addr_t *dma_src,
+do_async_gen_syndrome(struct dma_chan *chan,
+		      const unsigned char *scfs, int disks,
+		      struct dmaengine_unmap_data *unmap,
+		      enum dma_ctrl_flags dma_flags,
 		      struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct dma_device *dma = chan->device;
-	enum dma_ctrl_flags dma_flags = 0;
 	enum async_tx_flags flags_orig = submit->flags;
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	dma_async_tx_callback cb_param_orig = submit->cb_param;
 	int src_cnt = disks - 2;
-	unsigned char coefs[src_cnt];
 	unsigned short pq_src_cnt;
 	dma_addr_t dma_dest[2];
 	int src_off = 0;
-	int idx;
-	int i;
 
-	/* DMAs use destinations as sources, so use BIDIRECTIONAL mapping */
-	if (P(blocks, disks))
-		dma_dest[0] = dma_map_page(dma->dev, P(blocks, disks), offset,
-					   len, DMA_BIDIRECTIONAL);
-	else
-		dma_flags |= DMA_PREP_PQ_DISABLE_P;
-	if (Q(blocks, disks))
-		dma_dest[1] = dma_map_page(dma->dev, Q(blocks, disks), offset,
-					   len, DMA_BIDIRECTIONAL);
-	else
-		dma_flags |= DMA_PREP_PQ_DISABLE_Q;
-
-	/* convert source addresses being careful to collapse 'empty'
-	 * sources and update the coefficients accordingly
-	 */
-	for (i = 0, idx = 0; i < src_cnt; i++) {
-		if (blocks[i] == NULL)
-			continue;
-		dma_src[idx] = dma_map_page(dma->dev, blocks[i], offset, len,
-					    DMA_TO_DEVICE);
-		coefs[idx] = scfs[i];
-		idx++;
-	}
-	src_cnt = idx;
+	dma_flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
+	if (submit->flags & ASYNC_TX_FENCE)
+		dma_flags |= DMA_PREP_FENCE;
 
 	while (src_cnt > 0) {
 		submit->flags = flags_orig;
@@ -100,28 +76,25 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 		if (src_cnt > pq_src_cnt) {
 			submit->flags &= ~ASYNC_TX_ACK;
 			submit->flags |= ASYNC_TX_FENCE;
-			dma_flags |= DMA_COMPL_SKIP_DEST_UNMAP;
 			submit->cb_fn = NULL;
 			submit->cb_param = NULL;
 		} else {
-			dma_flags &= ~DMA_COMPL_SKIP_DEST_UNMAP;
 			submit->cb_fn = cb_fn_orig;
 			submit->cb_param = cb_param_orig;
 			if (cb_fn_orig)
 				dma_flags |= DMA_PREP_INTERRUPT;
 		}
-		if (submit->flags & ASYNC_TX_FENCE)
-			dma_flags |= DMA_PREP_FENCE;
 
-		/* Since we have clobbered the src_list we are committed
-		 * to doing this asynchronously.  Drivers force forward
-		 * progress in case they can not provide a descriptor
+		/* Drivers force forward progress in case they can not provide
+		 * a descriptor
 		 */
 		for (;;) {
+			dma_dest[0] = unmap->addr[disks - 2];
+			dma_dest[1] = unmap->addr[disks - 1];
 			tx = dma->device_prep_dma_pq(chan, dma_dest,
-						     &dma_src[src_off],
+						     &unmap->addr[src_off],
 						     pq_src_cnt,
-						     &coefs[src_off], len,
+						     &scfs[src_off], unmap->len,
 						     dma_flags);
 			if (likely(tx))
 				break;
@@ -129,6 +102,7 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 			dma_async_issue_pending(chan);
 		}
 
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 		submit->depend_tx = tx;
 
@@ -188,10 +162,6 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
  * set to NULL those buffers will be replaced with the raid6_zero_page
  * in the synchronous path and omitted in the hardware-asynchronous
  * path.
- *
- * 'blocks' note: if submit->scribble is NULL then the contents of
- * 'blocks' may be overwritten to perform address conversions
- * (dma_map_page() or page_address()).
  */
 struct dma_async_tx_descriptor *
 async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
@@ -202,26 +172,69 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 						      &P(blocks, disks), 2,
 						      blocks, src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
-	dma_addr_t *dma_src = NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(disks > 255 || !(P(blocks, disks) || Q(blocks, disks)));
 
-	if (submit->scribble)
-		dma_src = submit->scribble;
-	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
-		dma_src = (dma_addr_t *) blocks;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
 
-	if (dma_src && device &&
+	if (unmap &&
 	    (src_cnt <= dma_maxpq(device, 0) ||
 	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
 	    is_dma_pq_aligned(device, offset, 0, len)) {
+		struct dma_async_tx_descriptor *tx;
+		enum dma_ctrl_flags dma_flags = 0;
+		unsigned char coefs[src_cnt];
+		int i, j;
+
 		/* run the p+q asynchronously */
 		pr_debug("%s: (async) disks: %d len: %zu\n",
 			 __func__, disks, len);
-		return do_async_gen_syndrome(chan, blocks, raid6_gfexp, offset,
-					     disks, len, dma_src, submit);
+
+		/* convert source addresses being careful to collapse 'empty'
+		 * sources and update the coefficients accordingly
+		 */
+		unmap->len = len;
+		for (i = 0, j = 0; i < src_cnt; i++) {
+			if (blocks[i] == NULL)
+				continue;
+			unmap->addr[j] = dma_map_page(device->dev, blocks[i], offset,
+						      len, DMA_TO_DEVICE);
+			coefs[j] = raid6_gfexp[i];
+			unmap->to_cnt++;
+			j++;
+		}
+
+		/*
+		 * DMAs use destinations as sources,
+		 * so use BIDIRECTIONAL mapping
+		 */
+		unmap->bidi_cnt++;
+		if (P(blocks, disks))
+			unmap->addr[j++] = dma_map_page(device->dev, P(blocks, disks),
+							offset, len, DMA_BIDIRECTIONAL);
+		else {
+			unmap->addr[j++] = 0;
+			dma_flags |= DMA_PREP_PQ_DISABLE_P;
+		}
+
+		unmap->bidi_cnt++;
+		if (Q(blocks, disks))
+			unmap->addr[j++] = dma_map_page(device->dev, Q(blocks, disks),
+						       offset, len, DMA_BIDIRECTIONAL);
+		else {
+			unmap->addr[j++] = 0;
+			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
+		}
+
+		tx = do_async_gen_syndrome(chan, coefs, j, unmap, dma_flags, submit);
+		dmaengine_unmap_put(unmap);
+		return tx;
 	}
 
+	dmaengine_unmap_put(unmap);
+
 	/* run the pq synchronously */
 	pr_debug("%s: (sync) disks: %d len: %zu\n", __func__, disks, len);
 
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 54138b57b37c..f878c808466e 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -953,9 +953,12 @@ static void dmaengine_unmap(struct kref *kref)
 		dma_unmap_page(dev, unmap->addr[i], unmap->len,
 			       DMA_FROM_DEVICE);
 	cnt += unmap->bidi_cnt;
-	for (; i < cnt; i++)
+	for (; i < cnt; i++) {
+		if (unmap->addr[i] == 0)
+			continue;
 		dma_unmap_page(dev, unmap->addr[i], unmap->len,
 			       DMA_BIDIRECTIONAL);
+	}
 	mempool_free(unmap, __get_unmap_pool(cnt)->pool);
 }
 

