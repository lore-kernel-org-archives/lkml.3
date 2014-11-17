Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaKQOBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:01:46 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48964 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752995AbaKQNpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:13 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 20/61] dmaengine: ep93xx: Split device_control
Date: Mon, 17 Nov 2014 14:42:14 +0100
Message-Id: <1416231775-31252-21-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Cirrus Logic EP93xx driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/ep93xx_dma.c | 41 +++++++----------------------------------
 1 file changed, 7 insertions(+), 34 deletions(-)

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 7650470196c4..a8bcbb5bc0ed 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -1164,13 +1164,14 @@ fail:
 
 /**
  * ep93xx_dma_terminate_all - terminate all transactions
- * @edmac: channel
+ * @chan: channel
  *
  * Stops all DMA transactions. All descriptors are put back to the
  * @edmac->free_list and callbacks are _not_ called.
  */
-static int ep93xx_dma_terminate_all(struct ep93xx_dma_chan *edmac)
+static int ep93xx_dma_terminate_all(struct dma_chan *chan)
 {
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
 	struct ep93xx_dma_desc *desc, *_d;
 	unsigned long flags;
 	LIST_HEAD(list);
@@ -1194,9 +1195,10 @@ static int ep93xx_dma_terminate_all(struct ep93xx_dma_chan *edmac)
 	return 0;
 }
 
-static int ep93xx_dma_slave_config(struct ep93xx_dma_chan *edmac,
+static int ep93xx_dma_slave_config(struct dma_chan *chan,
 				   struct dma_slave_config *config)
 {
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
 	enum dma_slave_buswidth width;
 	unsigned long flags;
 	u32 addr, ctrl;
@@ -1242,36 +1244,6 @@ static int ep93xx_dma_slave_config(struct ep93xx_dma_chan *edmac,
 }
 
 /**
- * ep93xx_dma_control - manipulate all pending operations on a channel
- * @chan: channel
- * @cmd: control command to perform
- * @arg: optional argument
- *
- * Controls the channel. Function returns %0 in case of success or negative
- * error in case of failure.
- */
-static int ep93xx_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			      unsigned long arg)
-{
-	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
-	struct dma_slave_config *config;
-
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		return ep93xx_dma_terminate_all(edmac);
-
-	case DMA_SLAVE_CONFIG:
-		config = (struct dma_slave_config *)arg;
-		return ep93xx_dma_slave_config(edmac, config);
-
-	default:
-		break;
-	}
-
-	return -ENOSYS;
-}
-
-/**
  * ep93xx_dma_tx_status - check if a transaction is completed
  * @chan: channel
  * @cookie: transaction specific cookie
@@ -1352,7 +1324,8 @@ static int __init ep93xx_dma_probe(struct platform_device *pdev)
 	dma_dev->device_free_chan_resources = ep93xx_dma_free_chan_resources;
 	dma_dev->device_prep_slave_sg = ep93xx_dma_prep_slave_sg;
 	dma_dev->device_prep_dma_cyclic = ep93xx_dma_prep_dma_cyclic;
-	dma_dev->device_control = ep93xx_dma_control;
+	dma_dev->device_config = ep93xx_dma_slave_config;
+	dma_dev->device_terminate_all = ep93xx_dma_terminate_all;
 	dma_dev->device_issue_pending = ep93xx_dma_issue_pending;
 	dma_dev->device_tx_status = ep93xx_dma_tx_status;
 
-- 
2.1.1

