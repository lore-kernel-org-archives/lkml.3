Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3GUG70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 02:59:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39747 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab3GUG7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 02:59:22 -0400
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
        Balaji TK <balajitk@ti.com>, Gururaja Hebbar <gururaja.hebbar@ti.com>,
        Chris Ball <cjb@laptop.org>, Jason Kridner <jkridner@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [RFC 5/5] DMA: EDMA: Leave linked to Null slot instead of DUMMY slot
Date: Sun, 21 Jul 2013 01:58:45 -0500
Message-ID: <1374389925-32667-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dummy slot has been used as a way for missed-events not to be
reported as missing. This has been particularly troublesome for cases
where we might want to temporarily pause all incoming events.

For EDMA DMAC, there is no way to do any such pausing of events as
the occurence of the "next" event is not software controlled.
Using "edma_pause" in IRQ handlers doesn't help as by then the event
in concern from the slave is already missed.

Linking a dummy slot, is seen to absorb these events which we didn't
want to miss. So we don't link to dummy, but instead leave it linked
to NULL set, allow an error condition and detect the channel that
missed it.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index b0b5bcd..e9f1f27 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -160,9 +160,6 @@ static void edma_execute(struct edma_chan *echan)
 		/* Link to the previous slot if not the last set */
 		if (i != (total_process - 1))
 			edma_link(echan->slot[i], echan->slot[i+1]);
-		/* Final pset links to the dummy pset */
-		else
-			edma_link(echan->slot[i], echan->ecc->dummy_slot);
 	}
 
 	edesc->total_processed += total_process;
-- 
1.7.9.5

