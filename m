Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab3BASWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:22:36 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:60613 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3BASW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:22:28 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v7 03/10] ARM: edma: add AM33XX support to the private EDMA API
Date: Fri,  1 Feb 2013 13:22:48 -0500
Message-Id: <1359742975-10421-4-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359742975-10421-1-git-send-email-mporter@ti.com>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for parsing the TI EDMA DT data into the
required EDMA private API platform data. Enables runtime
PM support to initialize the EDMA hwmod. Adds AM33XX EDMA
crossbar event mux support. Enables build on OMAP.

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/common/edma.c             |   96 ++++++++++++++++++++++++++++++++----
 arch/arm/plat-omap/Kconfig         |    1 +
 include/linux/platform_data/edma.h |    1 +
 3 files changed, 89 insertions(+), 9 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 3440d16..bd2416a 100644
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
 
@@ -723,6 +730,9 @@ EXPORT_SYMBOL(edma_free_channel);
  */
 int edma_alloc_slot(unsigned ctlr, int slot)
 {
+	if (!edma_cc[ctlr])
+		return -EINVAL;
+
 	if (slot >= 0)
 		slot = EDMA_CHAN_SLOT(slot);
 
@@ -1575,27 +1585,69 @@ static struct of_dma_filter_info edma_filter_info = {
 static int edma_probe(struct platform_device *pdev)
 {
 	struct edma_soc_info	**info = pdev->dev.platform_data;
+	struct edma_soc_info	*ninfo[EDMA_MAX_CC] = {NULL, NULL};
+	struct edma_soc_info	tmpinfo;
 	const s8		(*queue_priority_mapping)[2];
 	const s8		(*queue_tc_mapping)[2];
 	int			i, j, off, ln, found = 0;
 	int			status = -1;
 	const s16		(*rsv_chans)[2];
 	const s16		(*rsv_slots)[2];
+	const s16		(*xbar_chans)[2];
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
+	if (IS_ERR_VALUE(ret)) {
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
+			if (!IS_ERR_VALUE(ret))
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
@@ -1670,8 +1722,22 @@ static int edma_probe(struct platform_device *pdev)
 			}
 		}
 
-		sprintf(irq_name, "edma%d", j);
-		irq[j] = platform_get_irq_byname(pdev, irq_name);
+		/* Clear the xbar mapped channels in unused list */
+		xbar_chans = info[j]->xbar_chans;
+		if (xbar_chans) {
+			for (i = 0; xbar_chans[i][1] != -1; i++) {
+				off = xbar_chans[i][1];
+				clear_bits(off, 1,
+					edma_cc[j]->edma_unused);
+			}
+		}
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
@@ -1681,8 +1747,12 @@ static int edma_probe(struct platform_device *pdev)
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
@@ -1743,9 +1813,17 @@ fail1:
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
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 665870d..0b81d6c 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -29,6 +29,7 @@ config ARCH_OMAP2PLUS
 	select PINCTRL
 	select PROC_DEVICETREE if PROC_FS
 	select SPARSE_IRQ
+	select TI_PRIV_EDMA
 	select USE_OF
 	help
 	  "Systems based on OMAP2, OMAP3, OMAP4 or OMAP5"
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index 2344ea2..ffc1fb2 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -177,6 +177,7 @@ struct edma_soc_info {
 
 	const s8	(*queue_tc_mapping)[2];
 	const s8	(*queue_priority_mapping)[2];
+	const s16	(*xbar_chans)[2];
 };
 
 #endif
-- 
1.7.9.5

