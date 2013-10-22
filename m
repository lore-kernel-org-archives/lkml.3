Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3JVVIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:08:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:16644 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab3JVVIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="423109171"
Subject: [PATCH v2 05/13] async_memcpy: convert to dmaengine_unmap_data
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: linux@arm.linux.org.uk, b.zolnierkie@samsung.com, vinod.koul@intel.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, dave.jiang@intel.com
Date: Tue, 22 Oct 2013 14:08:12 -0700
Message-ID: <20131022210812.31204.90602.stgit@viggo.jf.intel.com>
In-Reply-To: <1382117733-16720-6-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-6-git-send-email-b.zolnierkie@samsung.com>
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
[bzolnier: add missing unmap->len initialization]
[bzolnier: fix whitespace damage]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

 Resend to:
	1/ add it to the new dmaengine patchwork
	2/ cc maintainers of affected drivers
	3/ fixup some mail addresses

 crypto/async_tx/async_memcpy.c |   40 +++++++++++++++++++++++-----------------
 drivers/dma/dmaengine.c        |    3 ++-
 include/linux/dmaengine.h      |    2 ++
 3 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 9e62feffb374..72750214f779 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -50,33 +50,37 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 						      &dest, 1, &src, 1, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 
-	if (device && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
-		dma_addr_t dma_dest, dma_src;
-		unsigned long dma_prep_flags = 0;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOIO);
+
+	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
+		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+					       DMA_COMPL_SKIP_DEST_UNMAP;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_prep_flags |= DMA_PREP_FENCE;
-		dma_dest = dma_map_page(device->dev, dest, dest_offset, len,
-					DMA_FROM_DEVICE);
-
-		dma_src = dma_map_page(device->dev, src, src_offset, len,
-				       DMA_TO_DEVICE);
-
-		tx = device->device_prep_dma_memcpy(chan, dma_dest, dma_src,
-						    len, dma_prep_flags);
-		if (!tx) {
-			dma_unmap_page(device->dev, dma_dest, len,
-				       DMA_FROM_DEVICE);
-			dma_unmap_page(device->dev, dma_src, len,
-				       DMA_TO_DEVICE);
-		}
+
+		unmap->to_cnt = 1;
+		unmap->addr[0] = dma_map_page(device->dev, src, src_offset, len,
+					      DMA_TO_DEVICE);
+		unmap->from_cnt = 1;
+		unmap->addr[1] = dma_map_page(device->dev, dest, dest_offset, len,
+					      DMA_FROM_DEVICE);
+		unmap->len = len;
+
+		tx = device->device_prep_dma_memcpy(chan, unmap->addr[1],
+						    unmap->addr[0], len,
+						    dma_prep_flags);
 	}
 
 	if (tx) {
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
+
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 	} else {
 		void *dest_buf, *src_buf;
@@ -96,6 +100,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 		async_tx_sync_epilog(submit);
 	}
 
+	dmaengine_unmap_put(unmap);
+
 	return tx;
 }
 EXPORT_SYMBOL_GPL(async_memcpy);
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index e721a1caff7f..54138b57b37c 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1009,7 +1009,7 @@ static int __init dmaengine_init_unmap_pool(void)
 	return -ENOMEM;
 }
 
-static struct dmaengine_unmap_data *
+struct dmaengine_unmap_data *
 dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
 {
 	struct dmaengine_unmap_data *unmap;
@@ -1024,6 +1024,7 @@ dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
 
 	return unmap;
 }
+EXPORT_SYMBOL(dmaengine_get_unmap_data);
 
 /**
  * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 2fe855a7cab1..dc98bc5d4929 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -464,6 +464,8 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
 	tx->unmap = unmap;
 }
 
+struct dmaengine_unmap_data *
+dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags);
 void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap);
 
 static inline void dma_descriptor_unmap(struct dma_async_tx_descriptor *tx)

