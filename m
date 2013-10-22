Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3JVVIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:08:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:20593 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3JVVIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="378507752"
Subject: [PATCH v2 06/13] async_xor: convert to dmaengine_unmap_data
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: linux@arm.linux.org.uk, b.zolnierkie@samsung.com, vinod.koul@intel.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, dave.jiang@intel.com
Date: Tue, 22 Oct 2013 14:08:14 -0700
Message-ID: <20131022210814.31227.33272.stgit@viggo.jf.intel.com>
In-Reply-To: <1382117733-16720-7-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-7-git-send-email-b.zolnierkie@samsung.com>
User-Agent: StGit/0.17-1-g7c57
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic unmap object to unmap dma buffers.

Later we can push this unmap object up to the raid layer and get rid of
the 'scribble' parameter.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[bzolnier: minor cleanups]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

 Resend to:
	1/ add it to the new dmaengine patchwork
	2/ cc maintainers of affected drivers
	3/ fixup some mail addresses

 crypto/async_tx/async_xor.c |   95 +++++++++++++++++++++++--------------------
 1 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 8ade0a0481c6..f092fa14a745 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -33,48 +33,32 @@
 
 /* do_async_xor - dma map the pages and perform the xor with an engine */
 static __async_inline struct dma_async_tx_descriptor *
-do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
-	     unsigned int offset, int src_cnt, size_t len, dma_addr_t *dma_src,
+do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 	     struct async_submit_ctl *submit)
 {
 	struct dma_device *dma = chan->device;
 	struct dma_async_tx_descriptor *tx = NULL;
-	int src_off = 0;
-	int i;
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	void *cb_param_orig = submit->cb_param;
 	enum async_tx_flags flags_orig = submit->flags;
 	enum dma_ctrl_flags dma_flags;
-	int xor_src_cnt = 0;
-	dma_addr_t dma_dest;
-
-	/* map the dest bidrectional in case it is re-used as a source */
-	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
-	for (i = 0; i < src_cnt; i++) {
-		/* only map the dest once */
-		if (!src_list[i])
-			continue;
-		if (unlikely(src_list[i] == dest)) {
-			dma_src[xor_src_cnt++] = dma_dest;
-			continue;
-		}
-		dma_src[xor_src_cnt++] = dma_map_page(dma->dev, src_list[i], offset,
-						      len, DMA_TO_DEVICE);
-	}
-	src_cnt = xor_src_cnt;
+	int src_cnt = unmap->to_cnt;
+	int xor_src_cnt;
+	dma_addr_t dma_dest = unmap->addr[unmap->to_cnt];
+	dma_addr_t *src_list = unmap->addr;
 
 	while (src_cnt) {
+		dma_addr_t tmp;
+
 		submit->flags = flags_orig;
-		dma_flags = 0;
 		xor_src_cnt = min(src_cnt, (int)dma->max_xor);
-		/* if we are submitting additional xors, leave the chain open,
-		 * clear the callback parameters, and leave the destination
-		 * buffer mapped
+		/* if we are submitting additional xors, leave the chain open
+		 * and clear the callback parameters
 		 */
+		dma_flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 		if (src_cnt > xor_src_cnt) {
 			submit->flags &= ~ASYNC_TX_ACK;
 			submit->flags |= ASYNC_TX_FENCE;
-			dma_flags = DMA_COMPL_SKIP_DEST_UNMAP;
 			submit->cb_fn = NULL;
 			submit->cb_param = NULL;
 		} else {
@@ -85,12 +69,18 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 			dma_flags |= DMA_PREP_INTERRUPT;
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		/* Since we have clobbered the src_list we are committed
-		 * to doing this asynchronously.  Drivers force forward progress
-		 * in case they can not provide a descriptor
+
+		/* Drivers force forward progress in case they can not provide a
+		 * descriptor
 		 */
-		tx = dma->device_prep_dma_xor(chan, dma_dest, &dma_src[src_off],
-					      xor_src_cnt, len, dma_flags);
+		tmp = src_list[0];
+		if (src_list > unmap->addr)
+			src_list[0] = dma_dest;
+		tx = dma->device_prep_dma_xor(chan, dma_dest, src_list,
+					      xor_src_cnt, unmap->len,
+					      dma_flags);
+		src_list[0] = tmp;
+
 
 		if (unlikely(!tx))
 			async_tx_quiesce(&submit->depend_tx);
@@ -99,22 +89,21 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 		while (unlikely(!tx)) {
 			dma_async_issue_pending(chan);
 			tx = dma->device_prep_dma_xor(chan, dma_dest,
-						      &dma_src[src_off],
-						      xor_src_cnt, len,
+						      src_list,
+						      xor_src_cnt, unmap->len,
 						      dma_flags);
 		}
 
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 		submit->depend_tx = tx;
 
 		if (src_cnt > xor_src_cnt) {
 			/* drop completed sources */
 			src_cnt -= xor_src_cnt;
-			src_off += xor_src_cnt;
-
 			/* use the intermediate result a source */
-			dma_src[--src_off] = dma_dest;
 			src_cnt++;
+			src_list += xor_src_cnt - 1;
 		} else
 			break;
 	}
@@ -189,22 +178,40 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR,
 						      &dest, 1, src_list,
 						      src_cnt, len);
-	dma_addr_t *dma_src = NULL;
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(src_cnt <= 1);
 
-	if (submit->scribble)
-		dma_src = submit->scribble;
-	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
-		dma_src = (dma_addr_t *) src_list;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, src_cnt+1, GFP_NOIO);
+
+	if (unmap && is_dma_xor_aligned(device, offset, 0, len)) {
+		struct dma_async_tx_descriptor *tx;
+		int i, j;
 
-	if (dma_src && chan && is_dma_xor_aligned(chan->device, offset, 0, len)) {
 		/* run the xor asynchronously */
 		pr_debug("%s (async): len: %zu\n", __func__, len);
 
-		return do_async_xor(chan, dest, src_list, offset, src_cnt, len,
-				    dma_src, submit);
+		unmap->len = len;
+		for (i = 0, j = 0; i < src_cnt; i++) {
+			if (!src_list[i])
+				continue;
+			unmap->to_cnt++;
+			unmap->addr[j++] = dma_map_page(device->dev, src_list[i],
+							offset, len, DMA_TO_DEVICE);
+		}
+
+		/* map it bidirectional as it may be re-used as a source */
+		unmap->addr[j] = dma_map_page(device->dev, dest, offset, len,
+					      DMA_BIDIRECTIONAL);
+		unmap->bidi_cnt = 1;
+
+		tx = do_async_xor(chan, unmap, submit);
+		dmaengine_unmap_put(unmap);
+		return tx;
 	} else {
+		dmaengine_unmap_put(unmap);
 		/* run the xor synchronously */
 		pr_debug("%s (sync): len: %zu\n", __func__, len);
 		WARN_ONCE(chan, "%s: no space for dma address conversion\n",

