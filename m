Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3HZWqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:46:12 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61758 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3HZWp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:45:59 -0400
From: Rob Herring <robherring2@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andreas Herrmann <andreas.herrmann@calxeda.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 07/11] net: calxedaxgmac: enable interrupts after napi_enable
Date: Mon, 26 Aug 2013 17:45:22 -0500
Message-Id: <1377557126-10716-7-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377557126-10716-1-git-send-email-robherring2@gmail.com>
References: <1377557126-10716-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Fix a race condition where the interrupt handler may have called
napi_schedule before napi_enable is called. This would disable interrupts
and never actually schedule napi to run.

Reported-by: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/xgmac.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index cd5872c..385eca0 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -962,9 +962,7 @@ static int xgmac_hw_init(struct net_device *dev)
 		DMA_BUS_MODE_FB | DMA_BUS_MODE_ATDS | DMA_BUS_MODE_AAL;
 	writel(value, ioaddr + XGMAC_DMA_BUS_MODE);
 
-	/* Enable interrupts */
-	writel(DMA_INTR_DEFAULT_MASK, ioaddr + XGMAC_DMA_STATUS);
-	writel(DMA_INTR_DEFAULT_MASK, ioaddr + XGMAC_DMA_INTR_ENA);
+	writel(0, ioaddr + XGMAC_DMA_INTR_ENA);
 
 	/* Mask power mgt interrupt */
 	writel(XGMAC_INT_STAT_PMTIM, ioaddr + XGMAC_INT_STAT);
@@ -1032,6 +1030,10 @@ static int xgmac_open(struct net_device *dev)
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
 
+	/* Enable interrupts */
+	writel(DMA_INTR_DEFAULT_MASK, ioaddr + XGMAC_DMA_STATUS);
+	writel(DMA_INTR_DEFAULT_MASK, ioaddr + XGMAC_DMA_INTR_ENA);
+
 	return 0;
 }
 
-- 
1.8.1.2

