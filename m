Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3FRG5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:57:04 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:40120 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab3FRG5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:57:02 -0400
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>
CC: <wangxfdu@gmail.com>, <cxie4@marvell.com>, Xiang Wang <wangx@marvell.com>
Subject: [PATCH V3 1/2] dma: mmp_pdma: add protect when alloc/free phy channels
Date: Tue, 18 Jun 2013 14:55:58 +0800
Message-ID: <1371538559-13185-2-git-send-email-wangxfdu@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
References: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiang Wang <wangx@marvell.com>

In mmp pdma, phy channels are allocated/freed dynamically
and frequently. But no proper protection is added.
Conflict will happen when multi-users are requesting phy
channels at the same time. Use spinlock to protect.

Signed-off-by: Xiang Wang <wangx@marvell.com>
---
 drivers/dma/mmp_pdma.c |   42 ++++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index c26699f..226158d 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -121,6 +121,7 @@ struct mmp_pdma_device {
 	struct device			*dev;
 	struct dma_device		device;
 	struct mmp_pdma_phy		*phy;
+	spinlock_t phy_lock; /* protect alloc/free phy channels */
 };
 
 #define tx_to_mmp_pdma_desc(tx) container_of(tx, struct mmp_pdma_desc_sw, async_tx)
@@ -219,6 +220,7 @@ static struct mmp_pdma_phy *lookup_phy(struct mmp_pdma_chan *pchan)
 	int prio, i;
 	struct mmp_pdma_device *pdev = to_mmp_pdma_dev(pchan->chan.device);
 	struct mmp_pdma_phy *phy;
+	unsigned long flags;
 
 	/*
 	 * dma channel priorities
@@ -227,6 +229,8 @@ static struct mmp_pdma_phy *lookup_phy(struct mmp_pdma_chan *pchan)
 	 * ch 8 - 11, 24 - 27  <--> (2)
 	 * ch 12 - 15, 28 - 31  <--> (3)
 	 */
+
+	spin_lock_irqsave(&pdev->phy_lock, flags);
 	for (prio = 0; prio <= (((pdev->dma_channels - 1) & 0xf) >> 2); prio++) {
 		for (i = 0; i < pdev->dma_channels; i++) {
 			if (prio != ((i & 0xf) >> 2))
@@ -234,14 +238,30 @@ static struct mmp_pdma_phy *lookup_phy(struct mmp_pdma_chan *pchan)
 			phy = &pdev->phy[i];
 			if (!phy->vchan) {
 				phy->vchan = pchan;
+				spin_unlock_irqrestore(&pdev->phy_lock, flags);
 				return phy;
 			}
 		}
 	}
 
+	spin_unlock_irqrestore(&pdev->phy_lock, flags);
 	return NULL;
 }
 
+static void mmp_pdma_free_phy(struct mmp_pdma_chan *pchan)
+{
+	struct mmp_pdma_device *pdev = to_mmp_pdma_dev(pchan->chan.device);
+	unsigned long flags;
+
+	if (!pchan->phy)
+		return;
+
+	spin_lock_irqsave(&pdev->phy_lock, flags);
+	pchan->phy->vchan = NULL;
+	pchan->phy = NULL;
+	spin_unlock_irqrestore(&pdev->phy_lock, flags);
+}
+
 /* desc->tx_list ==> pending list */
 static void append_pending_queue(struct mmp_pdma_chan *chan,
 					struct mmp_pdma_desc_sw *desc)
@@ -277,10 +297,7 @@ static void start_pending_queue(struct mmp_pdma_chan *chan)
 
 	if (list_empty(&chan->chain_pending)) {
 		/* chance to re-fetch phy channel with higher prio */
-		if (chan->phy) {
-			chan->phy->vchan = NULL;
-			chan->phy = NULL;
-		}
+		mmp_pdma_free_phy(chan);
 		dev_dbg(chan->dev, "no pending list\n");
 		return;
 	}
@@ -377,10 +394,7 @@ static int mmp_pdma_alloc_chan_resources(struct dma_chan *dchan)
 		dev_err(chan->dev, "unable to allocate descriptor pool\n");
 		return -ENOMEM;
 	}
-	if (chan->phy) {
-		chan->phy->vchan = NULL;
-		chan->phy = NULL;
-	}
+	mmp_pdma_free_phy(chan);
 	chan->idle = true;
 	chan->dev_addr = 0;
 	return 1;
@@ -411,10 +425,7 @@ static void mmp_pdma_free_chan_resources(struct dma_chan *dchan)
 	chan->desc_pool = NULL;
 	chan->idle = true;
 	chan->dev_addr = 0;
-	if (chan->phy) {
-		chan->phy->vchan = NULL;
-		chan->phy = NULL;
-	}
+	mmp_pdma_free_phy(chan);
 	return;
 }
 
@@ -581,10 +592,7 @@ static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
 		disable_chan(chan->phy);
-		if (chan->phy) {
-			chan->phy->vchan = NULL;
-			chan->phy = NULL;
-		}
+		mmp_pdma_free_phy(chan);
 		spin_lock_irqsave(&chan->desc_lock, flags);
 		mmp_pdma_free_desc_list(chan, &chan->chain_pending);
 		mmp_pdma_free_desc_list(chan, &chan->chain_running);
@@ -777,6 +785,8 @@ static int mmp_pdma_probe(struct platform_device *op)
 		return -ENOMEM;
 	pdev->dev = &op->dev;
 
+	spin_lock_init(&pdev->phy_lock);
+
 	iores = platform_get_resource(op, IORESOURCE_MEM, 0);
 	if (!iores)
 		return -EINVAL;
-- 
1.7.5.4

