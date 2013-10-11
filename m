Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3JKKp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:45:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab3JKKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 100/100] dmaengine: imx-dma: fix callback path in tasklet
Date: Fri, 11 Oct 2013 11:42:10 +0100
Message-Id: <1381488130-30235-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit fcaaba6c7136fe47e5a13352f99a64b019b6d2c5 upstream.

We need to free the ld_active list head before jumping into the callback
routine. Otherwise the callback could run into issue_pending and change
our ld_active list head we just going to free. This will run the channel
list into an currupted and undefined state.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/imx-dma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 2eb396e..39e07e5 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -564,13 +564,11 @@ static void imxdma_tasklet(unsigned long data)
 
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
@@ -598,6 +596,10 @@ static void imxdma_tasklet(unsigned long data)
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
1.8.3.2

