Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3GVRtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:49:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51173 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab3GVRty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:49:54 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Balaji TK <balajitk@ti.com>, Arnd Bergmann <arnd@arndb.de>
CC: Jason Kridner <jkridner@beagleboard.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH] ARM: EDMA: Fix clearing of unused list for DT DMA resources
Date: Mon, 22 Jul 2013 12:49:17 -0500
Message-ID: <1374515357-14574-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HWMOD removal for MMC is breaking edma_start as the events are being manually
triggered due to unused channel list not being clear, Thanks to Balaji TK for
finding this issue.

This patch fixes the issue, by reading the "dmas" property from the DT node if
it exists and clearing the bits in the unused channel list.

Cc: Balaji T K <balajitk@ti.com>
Cc: Pantel Antoniou <panto@antoniou-consulting.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
Fixed pushed to git@github.com:joelagnel/linux-kernel.git
   99b65c9..a411a81  master-rebase -> master-rebase

 arch/arm/common/edma.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index a432e6c..720f958 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -561,14 +561,29 @@ static int reserve_contiguous_slots(int ctlr, unsigned int id,
 static int prepare_unused_channel_list(struct device *dev, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	int i, ctlr;
-
-	for (i = 0; i < pdev->num_resources; i++) {
-		if ((pdev->resource[i].flags & IORESOURCE_DMA) &&
-				(int)pdev->resource[i].start >= 0) {
-			ctlr = EDMA_CTLR(pdev->resource[i].start);
-			clear_bit(EDMA_CHAN_SLOT(pdev->resource[i].start),
-					edma_cc[ctlr]->edma_unused);
+	int i = 0, ctlr;
+	u32 dma_chan;
+	__be32 *dma_chan_p;
+	struct property *prop;
+
+	if (dev->of_node) {
+		of_property_for_each_u32(dev->of_node, "dmas", prop, \
+					 dma_chan_p, dma_chan) {
+			if (i++ & 1) {
+				ctlr = EDMA_CTLR(dma_chan);
+				clear_bit(EDMA_CHAN_SLOT(dma_chan),
+						edma_cc[ctlr]->edma_unused);
+			}
+		}
+	} else {
+		for (; i < pdev->num_resources; i++) {
+			if ((pdev->resource[i].flags & IORESOURCE_DMA) &&
+			    (int)pdev->resource[i].start >= 0) {
+				ctlr = EDMA_CTLR(pdev->resource[i].start);
+				clear_bit(EDMA_CHAN_SLOT(
+					  pdev->resource[i].start),
+					  edma_cc[ctlr]->edma_unused);
+			}
 		}
 	}
 
-- 
1.7.9.5

