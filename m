Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3IZV4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:56:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55742 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab3IZV4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:56:35 -0400
From: Joel Fernandes <joelf@ti.com>
To: Sekhar Nori <nsekhar@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Olof Johansson <olof@lixom.net>,
        Nishanth Menon <nm@ti.com>,
        Pantel Antoniou <panto@antoniou-consulting.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH v3] ARM: EDMA: Fix clearing of unused list for DT DMA resources
Date: Thu, 26 Sep 2013 16:55:46 -0500
Message-ID: <1380232546-821-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HWMOD removal for MMC is breaking edma_start as the events are being manually
triggered due to unused channel list not being clear.

The above issue is fixed by reading the "dmas" property from the DT node if it
exists and clearing the bits in the unused channel list if the dma controller
used by any device is EDMA. For this purpose we use the of_* helpers to parse
the arguments in the dmas phandle list.

Also introduced is a minor clean up of a checkpatch error in old code.

Reviewed-by: Sekhar Nori <nsekhar@ti.com>
Reported-by: Balaji T K <balajitk@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Nishanth Menon <nm@ti.com>
Cc: Pantel Antoniou <panto@antoniou-consulting.com>
Cc: Jason Kridner <jkridner@beagleboard.org>
Cc: Koen Kooi <koen@dominion.thruhere.net>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
Just resending this patch after discussing with Sekhar and Olof.

AM335x is being booted by many users such as the beaglebone community. DT is
the only boot method available for all these users.  EDMA is required for the
operation for many common peripherals in AM335x SoC such as McASP, MMC and
Crypto.

Although EDMA DT nodes are going in only for 3.13, in reality the kernel has
been used for more than a year with EDMA code and out of tree EDMA DTS patches.
Hence though the DT nodes are still not in mainline, this patch can be still be
considered a critical fix as such and it would be great if it could be included
in 3.12-rc release. Thanks.

More details about why this broke an existing feature folks were using:
Previously the DMA resources for platform devices were being populated through
HWMOD, however with the recent clean ups with HWMOD, this data has been moved
to Device tree. The EDMA code though is not aware of this so it fails to fetch
the DMA resources correctly which it needs to prepare the unused channel list
(basically doesn't properly clear the channels that are in use, in the unused
list).

 arch/arm/common/edma.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 117f955..8e1a024 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -269,6 +269,11 @@ static const struct edmacc_param dummy_paramset = {
 	.ccnt = 1,
 };
 
+static const struct of_device_id edma_of_ids[] = {
+	{ .compatible = "ti,edma3", },
+	{}
+};
+
 /*****************************************************************************/
 
 static void map_dmach_queue(unsigned ctlr, unsigned ch_no,
@@ -560,14 +565,38 @@ static int reserve_contiguous_slots(int ctlr, unsigned int id,
 static int prepare_unused_channel_list(struct device *dev, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	int i, ctlr;
+	int i, count, ctlr;
+	struct of_phandle_args  dma_spec;
 
+	if (dev->of_node) {
+		count = of_property_count_strings(dev->of_node, "dma-names");
+		if (count < 0)
+			return 0;
+		for (i = 0; i < count; i++) {
+			if (of_parse_phandle_with_args(dev->of_node, "dmas",
+						       "#dma-cells", i,
+						       &dma_spec))
+				continue;
+
+			if (!of_match_node(edma_of_ids, dma_spec.np)) {
+				of_node_put(dma_spec.np);
+				continue;
+			}
+
+			clear_bit(EDMA_CHAN_SLOT(dma_spec.args[0]),
+				  edma_cc[0]->edma_unused);
+			of_node_put(dma_spec.np);
+		}
+		return 0;
+	}
+
+	/* For non-OF case */
 	for (i = 0; i < pdev->num_resources; i++) {
 		if ((pdev->resource[i].flags & IORESOURCE_DMA) &&
 				(int)pdev->resource[i].start >= 0) {
 			ctlr = EDMA_CTLR(pdev->resource[i].start);
 			clear_bit(EDMA_CHAN_SLOT(pdev->resource[i].start),
-					edma_cc[ctlr]->edma_unused);
+				  edma_cc[ctlr]->edma_unused);
 		}
 	}
 
@@ -1762,11 +1791,6 @@ static int edma_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id edma_of_ids[] = {
-	{ .compatible = "ti,edma3", },
-	{}
-};
-
 static struct platform_driver edma_driver = {
 	.driver = {
 		.name	= "edma",
-- 
1.8.1.2

