Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3JRRgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:36:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61618 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3JRRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:36:06 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-d6-526171843b89
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dave.jiang@intel.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        Dan Williams <djbw@fb.com>
Subject: [PATCH v2 02/13] dmaengine: consolidate memcpy apis
Date: Fri, 18 Oct 2013 19:35:22 +0200
Message-id: <1382117733-16720-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd2WwsQgg1371C02zljPajF96gVG
	ixM3G9ksNvc/YLM42/SG3eLyrjlsFrcv81qsn/GaxeJl334WB06PluYeNo+Jze/YPRbvecnk
	0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBmrLkxlL1hvUTHt0T+2Bsb3el2MnBwSAiYSa2av
	YISwxSQu3FvPBmILCSxilFg4wa6LkQvI7mKSOLl4JliCTcBKYmL7KrAGEQEZiQ3/tzODFDEL
	nGeUWH1gJVhCWMBG4ndnPzuIzSKgKjH7zBOgOAcHr4CHRM9FL4hl8hJP7/eBzeQU8JSYtm85
	1GIPiXNnXrJNYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4zJ5J72Bc1WBxiFGA
	g1GJh7fDJjFIiDWxrLgy9xCjBAezkghvmTNQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutA
	IYH0xJLU7NTUgtQimCwTB6dUA2PkWvmcnfr/Y00WBoo3B2s/MxU/e6bPSZS7SZpn+pS+ckPL
	/sm1bMe9Tp89oLtEUSt9Urj53R6GqrzaOytkysx7kt/VzyqUWhNWftlT5pWhWkyPK69YUrVg
	744ozsXBhUGf4u9XvNwmYBp3uiF+6db3K4Ps5vGHFeuvWJ9koCT8viWv+VK/EktxRqKhFnNR
	cSIA5jpQoC8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <djbw@fb.com>

Copying from page to page (dma_async_memcpy_pg_to_pg) is the superset,
make the other two apis use that one in preparation for providing a
common dma unmap implementation.  The common implementation just wants
to assume all buffers are mapped with dma_map_page().

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <djbw@fb.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/dmaengine.c | 137 ++++++++++++++++--------------------------------
 1 file changed, 45 insertions(+), 92 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9162ac8..bbc89df 100644
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
-- 
1.8.2.3

