Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3G2NbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:31:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34034 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab3G2Na6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:30:58 -0400
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
Subject: [PATCH 4/9] dma: edma: Find missed events and issue them
Date: Mon, 29 Jul 2013 08:29:50 -0500
Message-ID: <1375104595-16018-5-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375104595-16018-1-git-send-email-joelf@ti.com>
References: <1375104595-16018-1-git-send-email-joelf@ti.com>
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

[1] http://marc.info/?l=linux-omap&m=137416733628831&w=2

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index d9a151b..aa4989f 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -417,7 +417,15 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 
 		break;
 	case DMA_CC_ERROR:
-		dev_dbg(dev, "transfer error on channel %d\n", ch_num);
+		if (echan->edesc) {
+			dev_dbg(dev, "Missed event on %d, retrying\n",
+				ch_num);
+			edma_clean_channel(echan->ch_num);
+			edma_stop(echan->ch_num);
+			edma_start(echan->ch_num);
+			edma_manual_trigger(echan->ch_num);
+		}
+		dev_dbg(dev, "handled error on channel %d\n", ch_num);
 		break;
 	default:
 		break;
-- 
1.7.9.5

