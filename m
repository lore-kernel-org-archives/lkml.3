Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3FRGk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:40:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54812 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab3FRGjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:39:22 -0400
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
Subject: [PATCH v11 2/8] ARM: edma: Add DT and runtime PM support to the private EDMA API
Date: Tue, 18 Jun 2013 01:38:13 -0500
Message-ID: <1371537499-12970-3-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371537499-12970-1-git-send-email-joelagnel@ti.com>
References: <1371537499-12970-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

Adds support for parsing the TI EDMA DT data into the required EDMA
private API platform data. Enables runtime PM support to initialize
the EDMA hwmod. Enables build on OMAP.

Changes by Joel:
* Setup default one-to-one mapping for queue_priority and queue_tc
mapping as discussed in [1].
* Split out xbar stuff to separate patch. [1]

[1] https://patchwork.kernel.org/patch/2226761/

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 arch/arm/common/edma.c             |  190 +++++++++++++++++++++++++++++++++---
 arch/arm/mach-omap2/Kconfig        |    1 +
 include/linux/platform_data/edma.h |    4 +-
 3 files changed, 181 insertions(+), 14 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index a1db6cd..9823b79 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -24,6 +24,13 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/edma.h>
+#include <linux/err.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_dma.h>
+#include <linux/of_irq.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/platform_data/edma.h>
 
@@ -1369,31 +1376,173 @@ void edma_clear_event(unsigned channel)
 EXPORT_SYMBOL(edma_clear_event);
 
 /*-----------------------------------------------------------------------*/
+static int edma_of_read_u32_to_s8_array(const struct device_node *np,
+					 const char *propname, s8 *out_values,
+					 size_t sz)
+{
+	int ret;
+
+	ret = of_property_read_u8_array(np, propname, out_values, sz);
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
 
-static int __init edma_probe(struct platform_device *pdev)
+static int edma_of_parse_dt(struct device *dev,
+			    struct device_node *node,
+			    struct edma_soc_info *pdata)
+{
+	int ret = 0, i;
+	u32 value;
+	struct property *prop;
+	size_t sz;
+	struct edma_rsv_info *rsv_info;
+	const s16 (*rsv_chans)[2], (*rsv_slots)[2];
+	s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
+
+	memset(pdata, 0, sizeof(struct edma_soc_info));
+
+	ret = of_property_read_u32(node, "dma-channels", &value);
+	if (ret < 0)
+		return ret;
+	pdata->n_channel = value;
+
+	ret = of_property_read_u32(node, "ti,edma-regions", &value);
+	if (ret < 0)
+		return ret;
+	pdata->n_region = value;
+
+	ret = of_property_read_u32(node, "ti,edma-slots", &value);
+	if (ret < 0)
+		return ret;
+	pdata->n_slot = value;
+
+	pdata->n_cc = 1;
+	pdata->n_tc = 3;
+
+	rsv_info =
+		devm_kzalloc(dev, sizeof(struct edma_rsv_info), GFP_KERNEL);
+	if (!rsv_info)
+		return -ENOMEM;
+	pdata->rsv = rsv_info;
+
+	queue_tc_map = devm_kzalloc(dev, 8*sizeof(s8), GFP_KERNEL);
+	if (!queue_tc_map)
+		return -ENOMEM;
+
+	for (i = 0; i < 3; i++)
+		queue_tc_map[i][0] = queue_tc_map[i][1] = i;
+	queue_tc_map[i][0] = queue_tc_map[i][1] = -1;
+
+	pdata->queue_tc_mapping = queue_tc_map;
+
+	queue_priority_map = devm_kzalloc(dev, 8*sizeof(s8), GFP_KERNEL);
+	if (!queue_priority_map)
+		return -ENOMEM;
+
+	for (i = 0; i < 3; i++)
+		queue_priority_map[i][0] = queue_priority_map[i][1] = i;
+	queue_priority_map[i][0] = queue_priority_map[i][1] = -1;
+
+	pdata->queue_priority_mapping = queue_priority_map;
+
+	pdata->default_queue = 0;
+
+
+	return ret;
+}
+
+static struct of_dma_filter_info edma_filter_info = {
+	.filter_fn = edma_filter_fn,
+};
+
+static int edma_probe(struct platform_device *pdev)
 {
 	struct edma_soc_info	**info = pdev->dev.platform_data;
-	const s8		(*queue_priority_mapping)[2];
-	const s8		(*queue_tc_mapping)[2];
+	struct edma_soc_info	*ninfo[EDMA_MAX_CC] = {NULL, NULL};
+	struct edma_soc_info	tmpinfo;
+	s8		(*queue_priority_mapping)[2];
+	s8		(*queue_tc_mapping)[2];
 	int			i, j, off, ln, found = 0;
 	int			status = -1;
 	const s16		(*rsv_chans)[2];
 	const s16		(*rsv_slots)[2];
 	int			irq[EDMA_MAX_CC] = {0, 0};
 	int			err_irq[EDMA_MAX_CC] = {0, 0};
-	struct resource		*r[EDMA_MAX_CC] = {NULL};
+	struct resource		*r[EDMA_MAX_CC] = {NULL, NULL};
+	struct resource		res[EDMA_MAX_CC];
 	resource_size_t		len[EDMA_MAX_CC];
 	char			res_name[10];
 	char			irq_name[10];
+	struct device_node	*node = pdev->dev.of_node;
+	struct device		*dev = &pdev->dev;
+	int			ret;
+
+	if (node) {
+		/* Check if this is a second instance registered */
+		if (arch_num_cc) {
+			dev_err(dev, "only one EDMA instance is supported via DT\n");
+			return -ENODEV;
+		}
+		info = ninfo;
+		edma_of_parse_dt(dev, node, &tmpinfo);
+		info[0] = &tmpinfo;
+
+		dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
+		of_dma_controller_register(dev->of_node,
+					   of_dma_simple_xlate,
+					   &edma_filter_info);
+	}
 
 	if (!info)
 		return -ENODEV;
 
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "pm_runtime_get_sync() failed\n");
+		return ret;
+	}
+
 	for (j = 0; j < EDMA_MAX_CC; j++) {
-		sprintf(res_name, "edma_cc%d", j);
-		r[j] = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+		if (!info[j]) {
+			if (!found)
+				return -ENODEV;
+			break;
+		}
+		if (node) {
+			ret = of_address_to_resource(node, j, &res[j]);
+			if (!ret)
+				r[j] = &res[j];
+		} else {
+			sprintf(res_name, "edma_cc%d", j);
+			r[j] = platform_get_resource_byname(pdev,
+						IORESOURCE_MEM,
 						res_name);
-		if (!r[j] || !info[j]) {
+		}
+		if (!r[j]) {
 			if (found)
 				break;
 			else
@@ -1468,8 +1617,13 @@ static int __init edma_probe(struct platform_device *pdev)
 			}
 		}
 
-		sprintf(irq_name, "edma%d", j);
-		irq[j] = platform_get_irq_byname(pdev, irq_name);
+
+		if (node)
+			irq[j] = irq_of_parse_and_map(node, 0);
+		else {
+			sprintf(irq_name, "edma%d", j);
+			irq[j] = platform_get_irq_byname(pdev, irq_name);
+		}
 		edma_cc[j]->irq_res_start = irq[j];
 		status = request_irq(irq[j], dma_irq_handler, 0, "edma",
 					&pdev->dev);
@@ -1479,8 +1633,12 @@ static int __init edma_probe(struct platform_device *pdev)
 			goto fail;
 		}
 
-		sprintf(irq_name, "edma%d_err", j);
-		err_irq[j] = platform_get_irq_byname(pdev, irq_name);
+		if (node)
+			err_irq[j] = irq_of_parse_and_map(node, 2);
+		else {
+			sprintf(irq_name, "edma%d_err", j);
+			err_irq[j] = platform_get_irq_byname(pdev, irq_name);
+		}
 		edma_cc[j]->irq_res_end = err_irq[j];
 		status = request_irq(err_irq[j], dma_ccerr_handler, 0,
 					"edma_error", &pdev->dev);
@@ -1541,9 +1699,17 @@ fail1:
 	return status;
 }
 
+static const struct of_device_id edma_of_ids[] = {
+	{ .compatible = "ti,edma3", },
+	{}
+};
 
 static struct platform_driver edma_driver = {
-	.driver.name	= "edma",
+	.driver = {
+		.name	= "edma",
+		.of_match_table = edma_of_ids,
+	},
+	.probe = edma_probe,
 };
 
 static int __init edma_init(void)
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index f49cd51..f91b07f 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -17,6 +17,7 @@ config ARCH_OMAP2PLUS
 	select PROC_DEVICETREE if PROC_FS
 	select SOC_BUS
 	select SPARSE_IRQ
+	select TI_PRIV_EDMA
 	select USE_OF
 	help
 	  Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index 2344ea2..317f2be 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -175,8 +175,8 @@ struct edma_soc_info {
 	/* Resource reservation for other cores */
 	struct edma_rsv_info	*rsv;
 
-	const s8	(*queue_tc_mapping)[2];
-	const s8	(*queue_priority_mapping)[2];
+	s8	(*queue_tc_mapping)[2];
+	s8	(*queue_priority_mapping)[2];
 };
 
 #endif
-- 
1.7.9.5

