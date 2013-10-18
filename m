Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3JRRjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:39:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61632 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3JRRgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:36:16 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-e1-5261718fc419
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dave.jiang@intel.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        Dan Williams <djbw@fb.com>
Subject: [PATCH v2 05/13] async_memcpy: convert to dmaengine_unmap_data
Date: Fri, 18 Oct 2013 19:35:25 +0200
Message-id: <1382117733-16720-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd3+wsQgg547ZhYbZ6xntZg+9QKj
	xYmbjWwWm/sfsFmcbXrDbnF51xw2i9uXeS3Wz3jNYvGybz+LA6dHS3MPm8fE5nfsHov3vGTy
	6NuyitHj8ya5ANYoLpuU1JzMstQifbsErowfk+QKtilWPN62la2BcYN0FyMnh4SAicTDl3NY
	IWwxiQv31rN1MXJxCAksYpR4feUlM4TTxSRx5PE7ZpAqNgEriYntqxhBbBEBGYkN/7eDFTEL
	nGeUWH1gJVhCWMBdYlHbLhYQm0VAVeLjzgtgcV4BD4kvK1+zQayTl3h6vw/M5hTwlJi2bzmY
	LQRUc+7MS7YJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH2jPpHYyrGiwOMQpw
	MCrx8HbYJAYJsSaWFVfmHmKU4GBWEuEtcwYK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0o
	JJCeWJKanZpakFoEk2Xi4JRqYGTgP7zpdPb/Z7NWlG2cLXP/tIT2s5yobRcX3PUy7ufK+3eo
	RPDVNJGNq5Ymyd94ZDTt8F7LLRULFyssfPdT2bzJ+mLH7nP7S0zeMD/wvce7uvSW6RHFzdOq
	Ku7quB6JuMC7dkYUQ8CBWVYVOtafk6WyFU3/JYaHN4TKF55t52RZxv6i9YV7VKoSS3FGoqEW
	c1FxIgAsLhX/MAIAAA==
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
[bzolnier: add missing unmap->len initialization]
[bzolnier: fix whitespace damage]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_memcpy.c | 40 +++++++++++++++++++++++-----------------
 drivers/dma/dmaengine.c        |  3 ++-
 include/linux/dmaengine.h      |  2 ++
 3 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 9e62fef..7275021 100644
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
index e721a1c..54138b5 100644
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
index 2fe855a..dc98bc5 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -464,6 +464,8 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
 	tx->unmap = unmap;
 }
 
+struct dmaengine_unmap_data *
+dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags);
 void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap);
 
 static inline void dma_descriptor_unmap(struct dma_async_tx_descriptor *tx)
-- 
1.8.2.3

