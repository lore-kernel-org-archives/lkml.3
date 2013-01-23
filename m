Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3AWPiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:38:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:47809 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab3AWPiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:38:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,523,1355126400"; 
   d="scan'208";a="194342980"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/4] dw_dmac: introduce total_len field in struct dw_desc
Date: Wed, 23 Jan 2013 17:37:30 +0200
Message-Id: <1358955452-20960-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By this new field we distinguish a total length of the chain and the individual
length of each descriptor in the chain.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   12 ++++++------
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 82e7c58..c3062a5 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -335,18 +335,18 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
 				dma_unmap_single(parent, desc->lli.dar,
-						desc->len, DMA_FROM_DEVICE);
+					desc->total_len, DMA_FROM_DEVICE);
 			else
 				dma_unmap_page(parent, desc->lli.dar,
-						desc->len, DMA_FROM_DEVICE);
+					desc->total_len, DMA_FROM_DEVICE);
 		}
 		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
 			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
 				dma_unmap_single(parent, desc->lli.sar,
-						desc->len, DMA_TO_DEVICE);
+					desc->total_len, DMA_TO_DEVICE);
 			else
 				dma_unmap_page(parent, desc->lli.sar,
-						desc->len, DMA_TO_DEVICE);
+					desc->total_len, DMA_TO_DEVICE);
 		}
 	}
 
@@ -773,7 +773,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 
 	prev->lli.llp = 0;
 	first->txd.flags = flags;
-	first->len = len;
+	first->total_len = len;
 
 	return &first->txd;
 
@@ -936,7 +936,7 @@ slave_sg_fromdev_fill_desc:
 		prev->lli.ctllo |= DWC_CTLL_INT_EN;
 
 	prev->lli.llp = 0;
-	first->len = total_len;
+	first->total_len = total_len;
 
 	return &first->txd;
 
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 13000d2..833b4cf 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -296,6 +296,7 @@ struct dw_desc {
 	struct list_head		tx_list;
 	struct dma_async_tx_descriptor	txd;
 	size_t				len;
+	size_t				total_len;
 };
 
 #define to_dw_desc(h)	list_entry(h, struct dw_desc, desc_node)
-- 
1.7.10.4

