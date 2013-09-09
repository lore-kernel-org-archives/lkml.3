Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3IIXwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:52:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:39816 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab3IIXwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:52:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,874,1371106800"; 
   d="scan'208";a="400901141"
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dmadevices: dma_sync_wait and dma_find_channel undefined
Date: Mon,  9 Sep 2013 16:51:59 -0700
Message-Id: <1378770719-24070-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_sync_wait and dma_find_channel are declared regardless of whether
CONFIG_DMA_ENGINE is enabled, but calling the function without
CONFIG_DMA_ENGINE enabled results "undefined reference" errors.

To get around this, declare dma_sync_wait and dma_find_channel as inline
functions if CONFIG_DMA_ENGINE is undefined.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 include/linux/dmaengine.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index cb286b1..cd4d1ca 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -958,8 +958,9 @@ dma_set_tx_state(struct dma_tx_state *st, dma_cookie_t last, dma_cookie_t used,
 	}
 }
 
-enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
+struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
+enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
 struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
@@ -967,6 +968,14 @@ struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name);
 void dma_release_channel(struct dma_chan *chan);
 #else
+static inline struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type)
+{
+	return NULL;
+}
+static inline enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
+{
+	return DMA_SUCCESS;
+}
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
 	return DMA_SUCCESS;
@@ -994,7 +1003,6 @@ static inline void dma_release_channel(struct dma_chan *chan)
 int dma_async_device_register(struct dma_device *device);
 void dma_async_device_unregister(struct dma_device *device);
 void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
-struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
 struct dma_chan *net_dma_find_channel(void);
 #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
 #define dma_request_slave_channel_compat(mask, x, y, dev, name) \
-- 
1.7.9.5

