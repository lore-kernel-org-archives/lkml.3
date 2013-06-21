Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3FUKQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:16:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56186 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3FUKQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:16:10 -0400
From: Sekhar Nori <nsekhar@ti.com>
To: Joel A Fernandes <joelagnel@ti.com>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Koen Kooi <koen@beagleboard.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Rob Landley <rob@landley.net>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Matt Porter <matt@ohporter.com>
Subject: [PATCH] ARM: edma: Add EDMA crossbar event mux support
Date: Fri, 21 Jun 2013 15:44:31 +0530
Message-ID: <1371809671-24037-1-git-send-email-nsekhar@ti.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <51C42705.1060803@ti.com>
References: <51C42705.1060803@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

EDMA supports a cross bar which provides ability
to mux additional events into physical channels
present in the channel controller.

This is required when the number of events present
in the system are more than number of available
physical channels.

Changes by Joel:
* Split EDMA xbar support out of original EDMA DT parsing patch
to keep it easier for review.
* Rewrite shift and offset calculation.

Suggested-by: Sekhar Nori <nsekhar@ti.com>
Suggested by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
[nsekhar@ti.com: fix checkpatch errors and a minor coding improvement]
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/common/edma.c             |   78 ++++++++++++++++++++++++++++++++++++
 include/linux/platform_data/edma.h |    1 +
 2 files changed, 79 insertions(+)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index b3770ab..2b591b1 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1378,12 +1378,76 @@ EXPORT_SYMBOL(edma_clear_event);
 
 #if IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_DMADEVICES)
 
+static int edma_of_read_u32_to_s16_array(const struct device_node *np,
+					 const char *propname, s16 *out_values,
+					 size_t sz)
+{
+	int ret;
+
+	ret = of_property_read_u16_array(np, propname, out_values, sz);
+	if (ret)
+		return ret;
+
+	/* Terminate it */
+	*out_values++ = -1;
+	*out_values++ = -1;
+
+	return 0;
+}
+
+static int edma_xbar_event_map(struct device *dev,
+			       struct device_node *node,
+			       struct edma_soc_info *pdata, int len)
+{
+	int ret, i;
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
 {
 	int ret = 0, i;
 	u32 value;
+	struct property *prop;
+	size_t sz;
 	struct edma_rsv_info *rsv_info;
 	s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
 
@@ -1439,6 +1503,10 @@ static int edma_of_parse_dt(struct device *dev,
 
 	pdata->default_queue = 0;
 
+	prop = of_find_property(node, "ti,edma-xbar-event-map", &sz);
+	if (prop)
+		ret = edma_xbar_event_map(dev, node, pdata, sz);
+
 	return ret;
 }
 
@@ -1492,6 +1560,7 @@ static int edma_probe(struct platform_device *pdev)
 	int			status = -1;
 	const s16		(*rsv_chans)[2];
 	const s16		(*rsv_slots)[2];
+	const s16		(*xbar_chans)[2];
 	int			irq[EDMA_MAX_CC] = {0, 0};
 	int			err_irq[EDMA_MAX_CC] = {0, 0};
 	struct resource		*r[EDMA_MAX_CC] = {NULL};
@@ -1599,6 +1668,15 @@ static int edma_probe(struct platform_device *pdev)
 			}
 		}
 
+		/* Clear the xbar mapped channels in unused list */
+		xbar_chans = info[j]->xbar_chans;
+		if (xbar_chans) {
+			for (i = 0; xbar_chans[i][1] != -1; i++) {
+				off = xbar_chans[i][1];
+				clear_bits(off, 1,
+					   edma_cc[j]->edma_unused);
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
1.7.10.1

