Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965789Ab3FTVKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:10:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43874 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965190Ab3FTVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:07:56 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel A Fernandes <joelagnel@ti.com>
Subject: [PATCH v12 03/11] ARM: edma: Add EDMA crossbar event mux support
Date: Thu, 20 Jun 2013 16:06:39 -0500
Message-ID: <1371762407-24544-4-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

Changes by Joel:
* Split EDMA xbar support out of original EDMA DT parsing patch
to keep it easier for review.
* Rewrite shift and offset calculation.

Suggested-by: Sekhar Nori <nsekhar@ti.com>
Suggested by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>

Reference:
[1] https://patchwork.kernel.org/patch/2226991/
---
 arch/arm/common/edma.c             |   62 +++++++++++++++++++++++++++++++++++-
 include/linux/platform_data/edma.h |    1 +
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 407e01e..a03d4f0 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -568,7 +568,7 @@ static int prepare_unused_channel_list(struct device *dev, void *data)
 				(int)pdev->resource[i].start >= 0) {
 			ctlr = EDMA_CTLR(pdev->resource[i].start);
 			clear_bit(EDMA_CHAN_SLOT(pdev->resource[i].start),
-					edma_cc[ctlr]->edma_unused);
+						edma_cc[ctlr]->edma_unused);
 		}
 	}
 
@@ -1393,6 +1393,52 @@ static int edma_of_read_u32_to_s16_array(const struct device_node *np,
 	return 0;
 }
 
+static int edma_xbar_event_map(struct device *dev,
+			       struct device_node *node,
+			       struct edma_soc_info *pdata, int len)
+{
+	int ret = 0;
+	int i;
+	struct resource res;
+	void __iomem *xbar;
+	const s16 (*xbar_chans)[2];
+	u32 shift, offset, mux;
+
+	xbar_chans = devm_kzalloc(dev,
+				  len/sizeof(s16) + 2*sizeof(s16),
+				  GFP_KERNEL);
+	if (!xbar_chans)
+		return -ENOMEM;
+
+	ret = of_address_to_resource(node, 1, &res);
+	if (ret)
+		return -EIO;
+
+	xbar = devm_ioremap(dev, res.start, resource_size(&res));
+	if (!xbar)
+		return -ENOMEM;
+
+	ret = edma_of_read_u32_to_s16_array(node,
+					    "ti,edma-xbar-event-map",
+					    (s16 *)xbar_chans,
+					    len/sizeof(u32));
+	if (ret)
+		return -EIO;
+
+	for (i = 0; xbar_chans[i][0] != -1; i++) {
+		shift = (xbar_chans[i][1] & 0x03) << 3;
+		offset = xbar_chans[i][1] & 0xfffffffc;
+		mux = readl(xbar + offset);
+		mux &= ~(0xff << shift);
+		mux |= xbar_chans[i][0] << shift;
+		writel(mux, (xbar + offset));
+	}
+
+	pdata->xbar_chans = xbar_chans;
+
+	return 0;
+}
+
 static int edma_of_parse_dt(struct device *dev,
 			    struct device_node *node,
 			    struct edma_soc_info *pdata)
@@ -1458,6 +1504,10 @@ static int edma_of_parse_dt(struct device *dev,
 
 	pdata->default_queue = 0;
 
+	prop = of_find_property(node, "ti,edma-xbar-event-map", &sz);
+	if (prop)
+		ret = edma_xbar_event_map(dev, node, pdata, sz);
+
 	return ret;
 }
 
@@ -1476,6 +1526,7 @@ static int edma_probe(struct platform_device *pdev)
 	int			status = -1;
 	const s16		(*rsv_chans)[2];
 	const s16		(*rsv_slots)[2];
+	const s16		(*xbar_chans)[2];
 	int			irq[EDMA_MAX_CC] = {0, 0};
 	int			err_irq[EDMA_MAX_CC] = {0, 0};
 	struct resource		*r[EDMA_MAX_CC] = {NULL};
@@ -1591,6 +1642,15 @@ static int edma_probe(struct platform_device *pdev)
 			}
 		}
 
+		/* Clear the xbar mapped channels in unused list */
+		xbar_chans = info[j]->xbar_chans;
+		if (xbar_chans) {
+			for (i = 0; xbar_chans[i][1] != -1; i++) {
+				off = xbar_chans[i][1];
+				clear_bits(off, 1,
+					  edma_cc[j]->edma_unused);
+			}
+		}
 
 		if (node) {
 			irq[j] = irq_of_parse_and_map(node, 0);
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index 317f2be..57300fd 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -177,6 +177,7 @@ struct edma_soc_info {
 
 	s8	(*queue_tc_mapping)[2];
 	s8	(*queue_priority_mapping)[2];
+	const s16	(*xbar_chans)[2];
 };
 
 #endif
-- 
1.7.9.5

