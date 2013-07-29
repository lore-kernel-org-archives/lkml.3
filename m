Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3G2Nbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:31:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41187 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab3G2NbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:31:00 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 6/9] dma: edma: Detect null slot errors and handle them correctly
Date: Mon, 29 Jul 2013 08:29:52 -0500
Message-ID: <1375104595-16018-7-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375104595-16018-1-git-send-email-joelf@ti.com>
References: <1375104595-16018-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For crypto IP, we continue to receive events even continuously in
NULL slot, and request lines don't get de-asserted unlike omap_hsmmc.
Due to this, we continously receive error interrupts when we
manually trigger an event.

We fix this, by first detecting if the Channel is currently transferring
from a NULL slot or not, that's where the edma_read_slot in the error
callback from interrupt handler comes in.

Second thing we do is, if we detect if we are on a NULL slot, we don't
forcefully trigger as this will only result in more error conditions.
Instead we set a missed flag and allow the manual triggerring to happen
in edma_execute which will eventually be called. This fixes the issue
where we are on a NULL slot and continue to receive events from
modules like crypto that don't stop their request events after a
transfer is completed.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 1eda5cc..c72e8c9 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -70,6 +70,7 @@ struct edma_chan {
 	int				ch_num;
 	bool				alloced;
 	int				slot[EDMA_MAX_SLOTS];
+	int				missed;
 	struct dma_slave_config		cfg;
 };
 
@@ -169,6 +170,18 @@ static void edma_execute(struct edma_chan *echan)
 		dev_dbg(dev, "first transfer starting %d\n", echan->ch_num);
 		edma_start(echan->ch_num);
 	}
+
+	/* This happens due to setup times between intermediate transfers
+	   in long SG lists which have to be broken up into transfers of
+	   MAX_NR_SG */
+	if (echan->missed) {
+		dev_dbg(dev, "missed event in execute detected\n");
+		edma_clean_channel(echan->ch_num);
+		edma_stop(echan->ch_num);
+		edma_start(echan->ch_num);
+		edma_manual_trigger(echan->ch_num);
+		echan->missed = 0;
+	}
 }
 
 static int edma_terminate_all(struct edma_chan *echan)
@@ -387,6 +400,7 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 	struct device *dev = echan->vchan.chan.device->dev;
 	struct edma_desc *edesc;
 	unsigned long flags;
+	struct edmacc_param p;
 
 	/* Pause the channel */
 	edma_pause(echan->ch_num);
@@ -414,15 +428,35 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 
 		break;
 	case DMA_CC_ERROR:
-		if (echan->edesc) {
-			dev_dbg(dev, "Missed event on %d, retrying\n",
-				ch_num);
+		spin_lock_irqsave(&echan->vchan.lock, flags);
+
+		edma_read_slot(EDMA_CHAN_SLOT(echan->slot[0]), &p);
+
+		if (p.a_b_cnt == 0 && p.ccnt == 0) {
+			dev_dbg(dev, "Error occurred, looks like slot is null, just setting miss\n");
+			/*
+			   Issue later based on missed flag which will be sure
+			   to happen as:
+			   (1) we finished transmitting an intermediate slot and
+			       edma_execute is coming up.
+			   (2) or we finished current transfer and issue will
+			       call edma_execute.
+
+			   Important note: issuing can be dangerous here and
+			   lead to some nasty recursion as this is a NULL slot
+			   at this point.
+			*/
+			echan->missed = 1;
+		} else {
+			dev_dbg(dev, "Error occurred but slot is non-null, TRIGGERING\n");
 			edma_clean_channel(echan->ch_num);
 			edma_stop(echan->ch_num);
 			edma_start(echan->ch_num);
 			edma_manual_trigger(echan->ch_num);
 		}
-		dev_dbg(dev, "handled error on channel %d\n", ch_num);
+
+		spin_unlock_irqrestore(&echan->vchan.lock, flags);
+
 		break;
 	default:
 		break;
-- 
1.7.9.5

