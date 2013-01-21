Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3AUJBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:01:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:2128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab3AUJBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:01:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="279673793"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] dw_dmac: return proper residue value
Date: Mon, 21 Jan 2013 11:00:44 +0200
Message-Id: <1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver returns full length of the active descriptor which is
wrong. We have to go throught the active descriptor and sum up the length of
unsent children in the chain along with the actual data in the DMA channel
registers.

The cyclic case is not handled by this patch due to len field in the descriptor
structure is left untouched by the original code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d1b9ba2..4325c68 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -941,6 +941,97 @@ err_desc_get:
 	return NULL;
 }
 
+/* --------------------- Calculate residue ---------------------------- */
+
+static inline size_t dwc_get_rest(struct dw_dma_chan *dwc, struct dw_desc *desc)
+{
+	enum dma_transfer_direction direction = dwc->direction;
+
+	if (direction == DMA_MEM_TO_DEV || direction == DMA_MEM_TO_MEM)
+		return desc->len - (channel_readl(dwc, SAR) - desc->lli.sar);
+	else if (direction == DMA_DEV_TO_MEM)
+		return desc->len - (channel_readl(dwc, DAR) - desc->lli.dar);
+
+	return 0;
+}
+
+static inline size_t dwc_get_residue_in_llp(struct dw_dma_chan *dwc,
+					    struct list_head *active,
+					    struct list_head *head)
+{
+	size_t residue = dwc_get_rest(dwc, to_dw_desc(active));
+
+	do {
+		active = active->next;
+		if (active == head)
+			break;
+		residue += to_dw_desc(active)->len;
+	} while (true);
+
+	return residue;
+}
+
+static size_t dwc_calc_residue_llp_hw(struct dw_dma_chan *dwc)
+{
+	struct dw_desc *desc = dwc_first_active(dwc);
+	struct list_head *head = &desc->tx_list, *active;
+	dma_addr_t llp = channel_readl(dwc, LLP);
+
+	/* The transfer didn't start yet */
+	if (unlikely(desc->txd.phys == llp))
+		return desc->len;
+
+	/* First descriptor is active */
+	if (desc->lli.llp == llp)
+		return dwc_get_rest(dwc, desc);
+
+	/* Somewhere in the middle */
+	list_for_each(active, head)
+		if (to_dw_desc(active)->lli.llp == llp)
+			return dwc_get_residue_in_llp(dwc, active, head);
+
+	return 0;
+}
+
+static size_t dwc_calc_residue_llp_sw(struct dw_dma_chan *dwc)
+{
+	struct dw_desc *desc = dwc_first_active(dwc);
+	struct list_head *head = dwc->tx_list, *active;
+
+	active = dwc->tx_node_active;
+
+	/* First node is active */
+	if (active == head->next)
+		return dwc_get_rest(dwc, desc);
+
+	/* Last node is active */
+	if (active == head)
+		return dwc_get_rest(dwc, to_dw_desc(active->prev));
+
+	/* Somewhere in the middle */
+	return dwc_get_residue_in_llp(dwc, active, head);
+}
+
+static size_t dwc_get_residue(struct dw_dma_chan *dwc)
+{
+	unsigned long flags;
+	size_t residue = 0;
+
+	spin_lock_irqsave(&dwc->lock, flags);
+	if (list_empty(&dwc->active_list)) {
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		return 0;
+	}
+
+	if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags))
+		residue = dwc_calc_residue_llp_sw(dwc);
+	else if (!test_bit(DW_DMA_IS_CYCLIC, &dwc->flags))
+		residue = dwc_calc_residue_llp_hw(dwc);
+
+	spin_unlock_irqrestore(&dwc->lock, flags);
+	return residue;
+}
+
 /*
  * Fix sconfig's burst size according to dw_dmac. We need to convert them as:
  * 1 -> 0, 4 -> 1, 8 -> 2, 16 -> 3.
@@ -1062,7 +1153,7 @@ dwc_tx_status(struct dma_chan *chan,
 	}
 
 	if (ret != DMA_SUCCESS)
-		dma_set_residue(txstate, dwc_first_active(dwc)->len);
+		dma_set_residue(txstate, dwc_get_residue(dwc));
 
 	if (dwc->paused)
 		return DMA_PAUSED;
-- 
1.7.10.4

