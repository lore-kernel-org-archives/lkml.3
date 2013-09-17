Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3IQN44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:56:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59839 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3IQN4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:56:31 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [[PATCH] 3/3] dma: imx-dma: fix callback path in tasklet
Date: Tue, 17 Sep 2013 15:56:08 +0200
Message-Id: <1379426168-31989-4-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379426168-31989-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1379426168-31989-1-git-send-email-m.grzeschik@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to free the ld_active list head before jumping into the callback
routine. Otherwise the callback could run into issue_pending and change
our ld_active list head we just going to free. This will run the channel
list into an currupted and undefined state.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/dma/imx-dma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 247aa7c..55852c0 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -627,13 +627,11 @@ static void imxdma_tasklet(unsigned long data)
 
 	if (list_empty(&imxdmac->ld_active)) {
 		/* Someone might have called terminate all */
-		goto out;
+		spin_unlock_irqrestore(&imxdma->lock, flags);
+		return;
 	}
 	desc = list_first_entry(&imxdmac->ld_active, struct imxdma_desc, node);
 
-	if (desc->desc.callback)
-		desc->desc.callback(desc->desc.callback_param);
-
 	/* If we are dealing with a cyclic descriptor, keep it on ld_active
 	 * and dont mark the descriptor as complete.
 	 * Only in non-cyclic cases it would be marked as complete
@@ -661,6 +659,10 @@ static void imxdma_tasklet(unsigned long data)
 	}
 out:
 	spin_unlock_irqrestore(&imxdma->lock, flags);
+
+	if (desc->desc.callback)
+		desc->desc.callback(desc->desc.callback_param);
+
 }
 
 static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-- 
1.8.4.rc3

