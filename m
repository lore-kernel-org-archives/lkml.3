Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3AWPhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:37:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:11848 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab3AWPhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:37:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,523,1355126400"; 
   d="scan'208";a="281246687"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 4/4] dw_dmac: return proper residue value
Date: Wed, 23 Jan 2013 17:37:32 +0200
Message-Id: <1358955452-20960-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
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
 drivers/dma/dw_dmac.c      |   53 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 026a3c7..639d4cc 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -387,6 +387,35 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
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
+static void dwc_update_residue(struct dw_dma_chan *dwc, struct dw_desc *desc)
+{
+	struct list_head *head = &desc->tx_list, *active;
+
+	/* First node is active */
+	if (dwc->tx_node_active == head->next) {
+		dwc->residue = desc->total_len - dwc_get_sent(dwc);
+		return;
+	}
+
+	/* Somewhere in the middle */
+	dwc->residue = desc->total_len - desc->len;
+	list_for_each(active, head) {
+		if (active == dwc->tx_node_active->prev)
+			break;
+		dwc->residue -= to_dw_desc(active)->len;
+	}
+	dwc->residue -= dwc_get_sent(dwc);
+}
+
 static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 {
 	dma_addr_t llp;
@@ -399,6 +428,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	llp = channel_readl(dwc, LLP);
 	status_xfer = dma_readl(dw, RAW.XFER);
 
+	dwc->residue = 0;
+
 	if (status_xfer & dwc->mask) {
 		/* Everything we've submitted is done */
 		dma_writel(dw, CLEAR.XFER, dwc->mask);
@@ -410,6 +441,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 			 */
 			desc = dwc_first_active(dwc);
 
+			dwc_update_residue(dwc, desc);
+
 			if (dwc->tx_node_active != &desc->tx_list) {
 				child = to_dw_desc(dwc->tx_node_active);
 
@@ -436,6 +469,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 
 	if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
 		dev_vdbg(chan2dev(&dwc->chan), "%s: soft LLP mode\n", __func__);
+
+		dwc_update_residue(dwc, dwc_first_active(dwc));
+
 		spin_unlock_irqrestore(&dwc->lock, flags);
 		return;
 	}
@@ -444,6 +480,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 			(unsigned long long)llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
+		/* initial residue value */
+		dwc->residue = desc->total_len;
+
 		/* check first descriptors addr */
 		if (desc->txd.phys == llp) {
 			spin_unlock_irqrestore(&dwc->lock, flags);
@@ -453,16 +492,21 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
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
@@ -1058,6 +1102,7 @@ dwc_tx_status(struct dma_chan *chan,
 	      struct dma_tx_state *txstate)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	unsigned long		flags;
 	enum dma_status		ret;
 
 	ret = dma_cookie_status(chan, cookie, txstate);
@@ -1067,8 +1112,12 @@ dwc_tx_status(struct dma_chan *chan,
 		ret = dma_cookie_status(chan, cookie, txstate);
 	}
 
+	spin_lock_irqsave(&dwc->lock, flags);
+
 	if (ret != DMA_SUCCESS)
-		dma_set_residue(txstate, dwc_first_active(dwc)->len);
+		dma_set_residue(txstate, dwc->residue);
+
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
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

