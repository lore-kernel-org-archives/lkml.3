Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3H2XGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:06:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54478 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab3H2XGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:06:33 -0400
From: Joel Fernandes <joelf@ti.com>
To: Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sricharan R <r.sricharan@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Franklin Cooper <fcooper@ti.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH v4 4/6] dma: edma: Find missed events and issue them
Date: Thu, 29 Aug 2013 18:05:43 -0500
Message-ID: <1377817545-18015-5-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377817545-18015-1-git-send-email-joelf@ti.com>
References: <1377817545-18015-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an effort to move to using Scatter gather lists of any size with
EDMA as discussed at [1] instead of placing limitations on the driver,
we work through the limitations of the EDMAC hardware to find missed
events and issue them.

The sequence of events that require this are:

For the scenario where MAX slots for an EDMA channel is 3:

SG1 -> SG2 -> SG3 -> SG4 -> SG5 -> SG6 -> Null

The above SG list will have to be DMA'd in 2 sets:

(1) SG1 -> SG2 -> SG3 -> Null
(2) SG4 -> SG5 -> SG6 -> Null

After (1) is succesfully transferred, the events from the MMC controller
donot stop coming and are missed by the time we have setup the transfer
for (2). So here, we catch the events missed as an error condition and
issue them manually.

In the second part of the patch, we make handle the NULL slot cases:
For crypto IP, we continue to receive events even continuously in
NULL slot, the setup of the next set of SG elements happens after
the error handler executes. This is results in some recursion problems.
Due to this, we continously receive error interrupts when we manually
trigger an event from the error handler.

We fix this, by first detecting if the Channel is currently transferring
from a NULL slot or not, that's where the edma_read_slot in the error
callback from interrupt handler comes in. With this we can determine if
the set up of the next SG list has completed, and we manually trigger
only in this case. If the setup has _not_ completed, we are still in NULL
so we just set a missed flag and allow the manual triggerring to happen
in edma_execute which will be eventually called. This fixes the above
mentioned race conditions seen with the crypto drivers.

[1] http://marc.info/?l=linux-omap&m=137416733628831&w=2

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 732829b..0e77b57 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -70,6 +70,7 @@ struct edma_chan {
 	int				ch_num;
 	bool				alloced;
 	int				slot[EDMA_MAX_SLOTS];
+	int				missed;
 	struct dma_slave_config		cfg;
 };
 
@@ -170,6 +171,20 @@ static void edma_execute(struct edma_chan *echan)
 		dev_dbg(dev, "first transfer starting %d\n", echan->ch_num);
 		edma_start(echan->ch_num);
 	}
+
+	/*
+	 * This happens due to setup times between intermediate transfers
+	 * in long SG lists which have to be broken up into transfers of
+	 * MAX_NR_SG
+	 */
+	if (echan->missed) {
+		dev_dbg(dev, "missed event in execute detected\n");
+		edma_clean_channel(echan->ch_num);
+		edma_stop(echan->ch_num);
+		edma_start(echan->ch_num);
+		edma_trigger_channel(echan->ch_num);
+		echan->missed = 0;
+	}
 }
 
 static int edma_terminate_all(struct edma_chan *echan)
@@ -387,6 +402,7 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 	struct device *dev = echan->vchan.chan.device->dev;
 	struct edma_desc *edesc;
 	unsigned long flags;
+	struct edmacc_param p;
 
 	/* Pause the channel */
 	edma_pause(echan->ch_num);
@@ -414,7 +430,39 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 
 		break;
 	case DMA_CC_ERROR:
-		dev_dbg(dev, "transfer error on channel %d\n", ch_num);
+		spin_lock_irqsave(&echan->vchan.lock, flags);
+
+		edma_read_slot(EDMA_CHAN_SLOT(echan->slot[0]), &p);
+
+		/*
+		 * Issue later based on missed flag which will be sure
+		 * to happen as:
+		 * (1) we finished transmitting an intermediate slot and
+		 *     edma_execute is coming up.
+		 * (2) or we finished current transfer and issue will
+		 *     call edma_execute.
+		 *
+		 * Important note: issuing can be dangerous here and
+		 * lead to some nasty recursion when we are in a NULL
+		 * slot. So we avoid doing so and set the missed flag.
+		 */
+		if (p.a_b_cnt == 0 && p.ccnt == 0) {
+			dev_dbg(dev, "Error occurred, looks like slot is null, just setting miss\n");
+			echan->missed = 1;
+		} else {
+			/*
+			 * The slot is already programmed but the event got
+			 * missed, so its safe to issue it here.
+			 */
+			dev_dbg(dev, "Error occurred but slot is non-null, TRIGGERING\n");
+			edma_clean_channel(echan->ch_num);
+			edma_stop(echan->ch_num);
+			edma_start(echan->ch_num);
+			edma_trigger_channel(echan->ch_num);
+		}
+
+		spin_unlock_irqrestore(&echan->vchan.lock, flags);
+
 		break;
 	default:
 		break;
-- 
1.8.1.2

