Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872Ab3FSArE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:47:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:48054 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173Ab3FSArB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:47:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,892,1363158000"; 
   d="scan'208";a="319141760"
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dmadevices: dma_sync_wait undefined
Date: Tue, 18 Jun 2013 17:46:52 -0700
Message-Id: <1371602813-19828-2-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_sync_wait is declared regardless of whether CONFIG_DMA_ENGINE is
enabled, but calling the function without CONFIG_DMA_ENGINE enabled
results in the following gcc error.
ERROR: "dma_sync_wait" [drivers/ntb/ntb.ko] undefined!

To get around this, declare dma_sync_wait as an inline function if
CONFIG_DMA_ENGINE is undefined.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
---
 include/linux/dmaengine.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 96d3e4a..e3652ac 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -963,8 +963,8 @@ dma_set_tx_state(struct dma_tx_state *st, dma_cookie_t last, dma_cookie_t used,
 	}
 }
 
-enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
+enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
 struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
@@ -972,6 +972,10 @@ struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name);
 void dma_release_channel(struct dma_chan *chan);
 #else
+static inline enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
+{
+	return DMA_SUCCESS;
+}
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
 	return DMA_SUCCESS;
-- 
1.7.9.5

