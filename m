Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab3IJSyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:54:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57571 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab3IJSxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:53:42 -0400
From: Joel Fernandes <joelf@ti.com>
To: Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>, Jyri Sarah <jsarha@ti.com>,
        "Jason Kridner" <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v3] ARM: EDMA: Fix clearing of unused list for DT DMA resources
Date: Tue, 10 Sep 2013 13:52:51 -0500
Message-ID: <1378839171-14455-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HWMOD removal for MMC is breaking edma_start as the events are being manually
triggered due to unused channel list not being clear.

This patch fixes the issue, by reading the "dmas" property from the DT node if
it exists and clearing the bits in the unused channel list. For this purpose
we use the of_* helpers to parse the arguments in the dmas phandle list.

Reviewed-by: Sekhar Nori <nsekhar@ti.com>
Reported-by: Balaji T K <balajitk@ti.com>
Cc: Pantel Antoniou <panto@antoniou-consulting.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
This patch is a repost of v2 with minor change of return value.

As such this patch fixes DMA breakages on all dependent peripherals (DMA, AES,
MMC, McASP..) so should go in for -rc cycle.

 arch/arm/common/edma.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 117f955..88ea067 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -560,14 +560,30 @@ static int reserve_contiguous_slots(int ctlr, unsigned int id,
 static int prepare_unused_channel_list(struct device *dev, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	int i, ctlr;
+	int i = 0, ctlr;
+	u32 dma_chan;
+	const __be32 *dma_chan_p;
+	struct property *prop;
+
+	if (dev->of_node) {
+		of_property_for_each_u32(dev->of_node, "dmas", prop,
+					 dma_chan_p, dma_chan) {
+			if (i++ & 1) {
+				ctlr = EDMA_CTLR(dma_chan);
+				clear_bit(EDMA_CHAN_SLOT(dma_chan),
+					  edma_cc[ctlr]->edma_unused);
+			}
+		}
+		return 0;
+	}
 
-	for (i = 0; i < pdev->num_resources; i++) {
+	/* For non-OF case */
+	for (; i < pdev->num_resources; i++) {
 		if ((pdev->resource[i].flags & IORESOURCE_DMA) &&
 				(int)pdev->resource[i].start >= 0) {
 			ctlr = EDMA_CTLR(pdev->resource[i].start);
 			clear_bit(EDMA_CHAN_SLOT(pdev->resource[i].start),
-					edma_cc[ctlr]->edma_unused);
+				  edma_cc[ctlr]->edma_unused);
 		}
 	}
 
-- 
1.8.1.2

