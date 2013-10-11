Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3JKKCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:02:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:21042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab3JKKCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:02:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1079,1371106800"; 
   d="scan'208";a="373396936"
From: Youquan Song <youquan.song@intel.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, gregkh@linuxfoundation.org
Cc: andriy.shevchenko@intel.com, mika.westerberg@intel.com,
        linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 1/2] dma: Add interface to calculate data transferred
Date: Fri, 11 Oct 2013 17:42:17 -0400
Message-Id: <1381527738-9339-2-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the DMA channel calculates its data transferred only at network
device driver. When other devices like UART or SPI etc, transfers data by DMA 
mode, but it always shows 0 at /sys/class/dma/dma0chan*/bytes_transferred.

This patch add a new function which will calculate how many the data has been
transferred after doing it by DMA mode. It can be used by other modules and
also simplify current duplicated code.

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/dma/dmaengine.c   |   35 +++++++++++++++++++----------------
 include/linux/dmaengine.h |    3 +++
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9162ac8..4356a7e 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -901,6 +901,23 @@ void dma_async_device_unregister(struct dma_device *device)
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
 
+dma_cookie_t
+dma_tx_submit_cal(struct dma_async_tx_descriptor *tx,
+		struct dma_chan *chan, size_t len)
+{
+
+	dma_cookie_t cookie;
+	cookie = tx->tx_submit(tx);
+
+	preempt_disable();
+	__this_cpu_add(chan->local->bytes_transferred, len);
+	__this_cpu_inc(chan->local->memcpy_count);
+	preempt_enable();
+
+	return cookie;
+
+}
+
 /**
  * dma_async_memcpy_buf_to_buf - offloaded copy between virtual addresses
  * @chan: DMA channel to offload copy to
@@ -920,7 +937,6 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 	struct dma_device *dev = chan->device;
 	struct dma_async_tx_descriptor *tx;
 	dma_addr_t dma_dest, dma_src;
-	dma_cookie_t cookie;
 	unsigned long flags;
 
 	dma_src = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
@@ -937,14 +953,8 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 	}
 
 	tx->callback = NULL;
-	cookie = tx->tx_submit(tx);
-
-	preempt_disable();
-	__this_cpu_add(chan->local->bytes_transferred, len);
-	__this_cpu_inc(chan->local->memcpy_count);
-	preempt_enable();
 
-	return cookie;
+	return dma_tx_submit_cal(tx, chan, len);
 }
 EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
 
@@ -968,7 +978,6 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 	struct dma_device *dev = chan->device;
 	struct dma_async_tx_descriptor *tx;
 	dma_addr_t dma_dest, dma_src;
-	dma_cookie_t cookie;
 	unsigned long flags;
 
 	dma_src = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
@@ -983,14 +992,8 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 	}
 
 	tx->callback = NULL;
-	cookie = tx->tx_submit(tx);
 
-	preempt_disable();
-	__this_cpu_add(chan->local->bytes_transferred, len);
-	__this_cpu_inc(chan->local->memcpy_count);
-	preempt_enable();
-
-	return cookie;
+	return dma_tx_submit_cal(tx, chan, len);
 }
 EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0bc7275..0025f8e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1084,4 +1084,7 @@ dma_cookie_t dma_memcpy_pg_to_iovec(struct dma_chan *chan, struct iovec *iov,
 	struct dma_pinned_list *pinned_list, struct page *page,
 	unsigned int offset, size_t len);
 
+dma_cookie_t dma_tx_submit_cal(struct dma_async_tx_descriptor *tx,
+	struct dma_chan *chan, size_t len);
+
 #endif /* DMAENGINE_H */
-- 
1.7.7.4

