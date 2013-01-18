Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3ARMOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:14:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:34376 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab3ARMOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:14:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,491,1355126400"; 
   d="scan'208";a="192609696"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: move soft LLP code from tasklet to dwc_scan_descriptors
Date: Fri, 18 Jan 2013 14:14:15 +0200
Message-Id: <1358511255-6324-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proper place for the main logic of the soft LLP mode is
dwc_scan_descriptors. It prevents to get the transfer unexpectedly aborted in
case the user calls dwc_tx_status.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 28593b7..3935ed7 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -400,6 +400,20 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	if (status_xfer & dwc->mask) {
 		/* Everything we've submitted is done */
 		dma_writel(dw, CLEAR.XFER, dwc->mask);
+
+		if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
+			if (dwc->tx_node_active != dwc->tx_list) {
+				desc = to_dw_desc(dwc->tx_node_active);
+
+				/* Submit next block */
+				dwc_do_single_block(dwc, desc);
+				spin_unlock_irqrestore(&dwc->lock, flags);
+
+				return;
+			}
+			/* We are done here */
+			clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
+		}
 		spin_unlock_irqrestore(&dwc->lock, flags);
 
 		dwc_complete_all(dw, dwc);
@@ -411,6 +425,12 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		return;
 	}
 
+	if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
+		dev_vdbg(chan2dev(&dwc->chan), "%s: soft LLP mode\n", __func__);
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		return;
+	}
+
 	dev_vdbg(chan2dev(&dwc->chan), "%s: llp=0x%llx\n", __func__,
 			(unsigned long long)llp);
 
@@ -596,29 +616,8 @@ static void dw_dma_tasklet(unsigned long data)
 			dwc_handle_cyclic(dw, dwc, status_err, status_xfer);
 		else if (status_err & (1 << i))
 			dwc_handle_error(dw, dwc);
-		else if (status_xfer & (1 << i)) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&dwc->lock, flags);
-			if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
-				if (dwc->tx_node_active != dwc->tx_list) {
-					struct dw_desc *desc =
-						to_dw_desc(dwc->tx_node_active);
-
-					dma_writel(dw, CLEAR.XFER, dwc->mask);
-
-					dwc_do_single_block(dwc, desc);
-
-					spin_unlock_irqrestore(&dwc->lock, flags);
-					continue;
-				}
-				/* we are done here */
-				clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
-			}
-			spin_unlock_irqrestore(&dwc->lock, flags);
-
+		else if (status_xfer & (1 << i))
 			dwc_scan_descriptors(dw, dwc);
-		}
 	}
 
 	/*
-- 
1.7.10.4

