Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3AXNHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:07:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:27637 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3AXNHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:07:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,529,1355126400"; 
   d="scan'208";a="281651096"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3.5] dw_dmac: return proper residue value
Date: Thu, 24 Jan 2013 15:07:29 +0200
Message-Id: <1359032849-25551-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAOh2x=kqEzw9cvg=WLpjEbF50aTKCUUVd9GzNg8PqtBx_BpYLg@mail.gmail.com>
References: <CAOh2x=kqEzw9cvg=WLpjEbF50aTKCUUVd9GzNg8PqtBx_BpYLg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver returns full length of the active descriptor which is
wrong. We have to go throught the active descriptor and substract the length of
each sent children in the chain from the total length along with the actual
data in the DMA channel registers.

The cyclic case is not handled by this patch due to len field in the descriptor
structure is left untouched by the original code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   47 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 3b788c8..b5c3f3a 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -284,6 +284,7 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 
 		dwc_initialize(dwc);
 
+		dwc->residue = first->total_len;
 		dwc->tx_node_active = &first->tx_list;
 
 		/* Submit first block */
@@ -387,6 +388,15 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		dwc_descriptor_complete(dwc, desc, true);
 }
 
+/* Returns how many bytes were already received from source */
+static inline u32 dwc_get_sent(struct dw_dma_chan *dwc)
+{
+	u32 ctlhi = channel_readl(dwc, CTL_HI);
+	u32 ctllo = channel_readl(dwc, CTL_LO);
+
+	return (ctlhi & DWC_CTLH_BLOCK_TS_MASK) * (1 << (ctllo >> 4 & 7));
+}
+
 static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 {
 	dma_addr_t llp;
@@ -414,6 +424,12 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 
 			head = &desc->tx_list;
 			if (active != head) {
+				/* Update desc to reflect last sent one */
+				if (active != head->next)
+					desc = to_dw_desc(active->prev);
+
+				dwc->residue -= desc->len;
+
 				child = to_dw_desc(active);
 
 				/* Submit next block */
@@ -426,6 +442,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 			/* We are done here */
 			clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
 		}
+
+		dwc->residue = 0;
+
 		spin_unlock_irqrestore(&dwc->lock, flags);
 
 		dwc_complete_all(dw, dwc);
@@ -433,6 +452,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	}
 
 	if (list_empty(&dwc->active_list)) {
+		dwc->residue = 0;
 		spin_unlock_irqrestore(&dwc->lock, flags);
 		return;
 	}
@@ -447,6 +467,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 			(unsigned long long)llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
+		/* initial residue value */
+		dwc->residue = desc->total_len;
+
 		/* check first descriptors addr */
 		if (desc->txd.phys == llp) {
 			spin_unlock_irqrestore(&dwc->lock, flags);
@@ -456,16 +479,21 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		/* check first descriptors llp */
 		if (desc->lli.llp == llp) {
 			/* This one is currently in progress */
+			dwc->residue -= dwc_get_sent(dwc);
 			spin_unlock_irqrestore(&dwc->lock, flags);
 			return;
 		}
 
-		list_for_each_entry(child, &desc->tx_list, desc_node)
+		dwc->residue -= desc->len;
+		list_for_each_entry(child, &desc->tx_list, desc_node) {
 			if (child->lli.llp == llp) {
 				/* Currently in progress */
+				dwc->residue -= dwc_get_sent(dwc);
 				spin_unlock_irqrestore(&dwc->lock, flags);
 				return;
 			}
+			dwc->residue -= child->len;
+		}
 
 		/*
 		 * No descriptors so far seem to be in progress, i.e.
@@ -1056,6 +1084,21 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	return 0;
 }
 
+static inline u32 dwc_get_residue(struct dw_dma_chan *dwc)
+{
+	unsigned long flags;
+	u32 residue;
+
+	spin_lock_irqsave(&dwc->lock, flags);
+
+	residue = dwc->residue;
+	if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags) && residue)
+		residue -= dwc_get_sent(dwc);
+
+	spin_unlock_irqrestore(&dwc->lock, flags);
+	return residue;
+}
+
 static enum dma_status
 dwc_tx_status(struct dma_chan *chan,
 	      dma_cookie_t cookie,
@@ -1072,7 +1115,7 @@ dwc_tx_status(struct dma_chan *chan,
 	}
 
 	if (ret != DMA_SUCCESS)
-		dma_set_residue(txstate, dwc_first_active(dwc)->len);
+		dma_set_residue(txstate, dwc_get_residue(dwc));
 
 	if (dwc->paused)
 		return DMA_PAUSED;
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 833b4cf..88dd8eb 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -203,6 +203,7 @@ struct dw_dma_chan {
 	struct list_head	active_list;
 	struct list_head	queue;
 	struct list_head	free_list;
+	u32			residue;
 	struct dw_cyclic_desc	*cdesc;
 
 	unsigned int		descs_allocated;
-- 
1.7.10.4

