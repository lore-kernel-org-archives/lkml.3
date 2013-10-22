Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3JVVKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:10:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:62968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab3JVVIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311285513"
Subject: [PATCH v2 07/13] async_xor_val: convert to dmaengine_unmap_data
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: linux@arm.linux.org.uk, b.zolnierkie@samsung.com, vinod.koul@intel.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, dave.jiang@intel.com
Date: Tue, 22 Oct 2013 14:08:17 -0700
Message-ID: <20131022210817.31250.51674.stgit@viggo.jf.intel.com>
In-Reply-To: <1382117733-16720-8-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-8-git-send-email-b.zolnierkie@samsung.com>
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
[bzolnier: minor cleanups]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

 Resend to:
	1/ add it to the new dmaengine patchwork
	2/ cc maintainers of affected drivers
	3/ fixup some mail addresses

 crypto/async_tx/async_xor.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index f092fa14a745..d2cc77d501c7 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -275,18 +275,17 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 	struct dma_chan *chan = xor_val_chan(submit, dest, src_list, src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
-	dma_addr_t *dma_src = NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(src_cnt <= 1);
 
-	if (submit->scribble)
-		dma_src = submit->scribble;
-	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
-		dma_src = (dma_addr_t *) src_list;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOIO);
 
-	if (dma_src && device && src_cnt <= device->max_xor &&
+	if (unmap && src_cnt <= device->max_xor &&
 	    is_dma_xor_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = 0;
+		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+					       DMA_COMPL_SKIP_DEST_UNMAP;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
@@ -295,11 +294,15 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_prep_flags |= DMA_PREP_FENCE;
-		for (i = 0; i < src_cnt; i++)
-			dma_src[i] = dma_map_page(device->dev, src_list[i],
-						  offset, len, DMA_TO_DEVICE);
 
-		tx = device->device_prep_dma_xor_val(chan, dma_src, src_cnt,
+		for (i = 0; i < src_cnt; i++) {
+			unmap->addr[i] = dma_map_page(device->dev, src_list[i],
+						      offset, len, DMA_TO_DEVICE);
+			unmap->to_cnt++;
+		}
+		unmap->len = len;
+
+		tx = device->device_prep_dma_xor_val(chan, unmap->addr, src_cnt,
 						     len, result,
 						     dma_prep_flags);
 		if (unlikely(!tx)) {
@@ -308,11 +311,11 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 			while (!tx) {
 				dma_async_issue_pending(chan);
 				tx = device->device_prep_dma_xor_val(chan,
-					dma_src, src_cnt, len, result,
+					unmap->addr, src_cnt, len, result,
 					dma_prep_flags);
 			}
 		}
-
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 	} else {
 		enum async_tx_flags flags_orig = submit->flags;
@@ -334,6 +337,7 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 		async_tx_sync_epilog(submit);
 		submit->flags = flags_orig;
 	}
+	dmaengine_unmap_put(unmap);
 
 	return tx;
 }

