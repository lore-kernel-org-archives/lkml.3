Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab3AWPiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:38:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:47809 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229Ab3AWPiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:38:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,523,1355126400"; 
   d="scan'208";a="194342978"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/4] dw_dmac: remove unnecessary tx_list field in dw_dma_chan
Date: Wed, 23 Jan 2013 17:37:29 +0200
Message-Id: <1358955452-20960-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The soft LLP mode is working for active descriptor only. So, we do not need to
have a copy of its pointer.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   17 ++++++++++++-----
 drivers/dma/dw_dmac_regs.h |    1 -
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 72e6316..82e7c58 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -284,9 +284,9 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 
 		dwc_initialize(dwc);
 
-		dwc->tx_list = &first->tx_list;
 		dwc->tx_node_active = &first->tx_list;
 
+		/* Submit first block */
 		dwc_do_single_block(dwc, first);
 
 		return;
@@ -404,15 +404,22 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		dma_writel(dw, CLEAR.XFER, dwc->mask);
 
 		if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
-			if (dwc->tx_node_active != dwc->tx_list) {
-				desc = to_dw_desc(dwc->tx_node_active);
+			/*
+			 * We are inside first active descriptor.
+			 * Otherwise something is really wrong.
+			 */
+			desc = dwc_first_active(dwc);
+
+			if (dwc->tx_node_active != &desc->tx_list) {
+				child = to_dw_desc(dwc->tx_node_active);
 
 				/* Submit next block */
-				dwc_do_single_block(dwc, desc);
-				spin_unlock_irqrestore(&dwc->lock, flags);
+				dwc_do_single_block(dwc, child);
 
+				spin_unlock_irqrestore(&dwc->lock, flags);
 				return;
 			}
+
 			/* We are done here */
 			clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
 		}
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index fef296d..13000d2 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -194,7 +194,6 @@ struct dw_dma_chan {
 	bool				initialized;
 
 	/* software emulation of the LLP transfers */
-	struct list_head	*tx_list;
 	struct list_head	*tx_node_active;
 
 	spinlock_t		lock;
-- 
1.7.10.4

