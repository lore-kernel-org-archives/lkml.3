Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3JVVLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:11:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:26347 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab3JVVIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="378507669"
Subject: [PATCH v2 02/13] dmaengine: consolidate memcpy apis
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: linux@arm.linux.org.uk, b.zolnierkie@samsung.com, vinod.koul@intel.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, dave.jiang@intel.com
Date: Tue, 22 Oct 2013 14:08:04 -0700
Message-ID: <20131022210804.31135.77774.stgit@viggo.jf.intel.com>
In-Reply-To: <1382117733-16720-3-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-3-git-send-email-b.zolnierkie@samsung.com>
User-Agent: StGit/0.17-1-g7c57
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copying from page to page (dma_async_memcpy_pg_to_pg) is the superset,
make the other two apis use that one in preparation for providing a
common dma unmap implementation.  The common implementation just wants
to assume all buffers are mapped with dma_map_page().

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

 Resend to:
	1/ add it to the new dmaengine patchwork
	2/ cc maintainers of affected drivers
	3/ fixup some mail addresses

 drivers/dma/dmaengine.c |  137 +++++++++++++++--------------------------------
 1 files changed, 45 insertions(+), 92 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9162ac80c18f..bbc89df6bc56 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -902,20 +902,23 @@ void dma_async_device_unregister(struct dma_device *device)
 EXPORT_SYMBOL(dma_async_device_unregister);
 
 /**
- * dma_async_memcpy_buf_to_buf - offloaded copy between virtual addresses
+ * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
  * @chan: DMA channel to offload copy to
- * @dest: destination address (virtual)
- * @src: source address (virtual)
+ * @dest_pg: destination page
+ * @dest_off: offset in page to copy to
+ * @src_pg: source page
+ * @src_off: offset in page to copy from
  * @len: length
  *
- * Both @dest and @src must be mappable to a bus address according to the
- * DMA mapping API rules for streaming mappings.
- * Both @dest and @src must stay memory resident (kernel memory or locked
- * user space pages).
+ * Both @dest_page/@dest_off and @src_page/@src_off must be mappable to a bus
+ * address according to the DMA mapping API rules for streaming mappings.
+ * Both @dest_page/@dest_off and @src_page/@src_off must stay memory resident
+ * (kernel memory or locked user space pages).
  */
 dma_cookie_t
-dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
-			void *src, size_t len)
+dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
+	unsigned int dest_off, struct page *src_pg, unsigned int src_off,
+	size_t len)
 {
 	struct dma_device *dev = chan->device;
 	struct dma_async_tx_descriptor *tx;
@@ -923,16 +926,15 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 	dma_cookie_t cookie;
 	unsigned long flags;
 
-	dma_src = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
-	dma_dest = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK |
-		DMA_COMPL_SRC_UNMAP_SINGLE |
-		DMA_COMPL_DEST_UNMAP_SINGLE;
+	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
+	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
+				DMA_FROM_DEVICE);
+	flags = DMA_CTRL_ACK;
 	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
 
 	if (!tx) {
-		dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
-		dma_unmap_single(dev->dev, dma_dest, len, DMA_FROM_DEVICE);
+		dma_unmap_page(dev->dev, dma_src, len, DMA_TO_DEVICE);
+		dma_unmap_page(dev->dev, dma_dest, len, DMA_FROM_DEVICE);
 		return -ENOMEM;
 	}
 
@@ -946,6 +948,29 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 
 	return cookie;
 }
+EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
+
+/**
+ * dma_async_memcpy_buf_to_buf - offloaded copy between virtual addresses
+ * @chan: DMA channel to offload copy to
+ * @dest: destination address (virtual)
+ * @src: source address (virtual)
+ * @len: length
+ *
+ * Both @dest and @src must be mappable to a bus address according to the
+ * DMA mapping API rules for streaming mappings.
+ * Both @dest and @src must stay memory resident (kernel memory or locked
+ * user space pages).
+ */
+dma_cookie_t
+dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
+			    void *src, size_t len)
+{
+	return dma_async_memcpy_pg_to_pg(chan, virt_to_page(dest),
+					 (unsigned long) dest & ~PAGE_MASK,
+					 virt_to_page(src),
+					 (unsigned long) src & ~PAGE_MASK, len);
+}
 EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
 
 /**
@@ -963,86 +988,14 @@ EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
  */
 dma_cookie_t
 dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
-			unsigned int offset, void *kdata, size_t len)
+			   unsigned int offset, void *kdata, size_t len)
 {
-	struct dma_device *dev = chan->device;
-	struct dma_async_tx_descriptor *tx;
-	dma_addr_t dma_dest, dma_src;
-	dma_cookie_t cookie;
-	unsigned long flags;
-
-	dma_src = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
-	dma_dest = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK | DMA_COMPL_SRC_UNMAP_SINGLE;
-	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
-
-	if (!tx) {
-		dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
-		dma_unmap_page(dev->dev, dma_dest, len, DMA_FROM_DEVICE);
-		return -ENOMEM;
-	}
-
-	tx->callback = NULL;
-	cookie = tx->tx_submit(tx);
-
-	preempt_disable();
-	__this_cpu_add(chan->local->bytes_transferred, len);
-	__this_cpu_inc(chan->local->memcpy_count);
-	preempt_enable();
-
-	return cookie;
+	return dma_async_memcpy_pg_to_pg(chan, page, offset,
+					 virt_to_page(kdata),
+					 (unsigned long) kdata & ~PAGE_MASK, len);
 }
 EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
 
-/**
- * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
- * @chan: DMA channel to offload copy to
- * @dest_pg: destination page
- * @dest_off: offset in page to copy to
- * @src_pg: source page
- * @src_off: offset in page to copy from
- * @len: length
- *
- * Both @dest_page/@dest_off and @src_page/@src_off must be mappable to a bus
- * address according to the DMA mapping API rules for streaming mappings.
- * Both @dest_page/@dest_off and @src_page/@src_off must stay memory resident
- * (kernel memory or locked user space pages).
- */
-dma_cookie_t
-dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
-	unsigned int dest_off, struct page *src_pg, unsigned int src_off,
-	size_t len)
-{
-	struct dma_device *dev = chan->device;
-	struct dma_async_tx_descriptor *tx;
-	dma_addr_t dma_dest, dma_src;
-	dma_cookie_t cookie;
-	unsigned long flags;
-
-	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
-	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
-				DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK;
-	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
-
-	if (!tx) {
-		dma_unmap_page(dev->dev, dma_src, len, DMA_TO_DEVICE);
-		dma_unmap_page(dev->dev, dma_dest, len, DMA_FROM_DEVICE);
-		return -ENOMEM;
-	}
-
-	tx->callback = NULL;
-	cookie = tx->tx_submit(tx);
-
-	preempt_disable();
-	__this_cpu_add(chan->local->bytes_transferred, len);
-	__this_cpu_inc(chan->local->memcpy_count);
-	preempt_enable();
-
-	return cookie;
-}
-EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
-
 void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 	struct dma_chan *chan)
 {

