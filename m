Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3AUJbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:31:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:56387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab3AUJbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:31:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="279685577"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 10/10] spi/pxa2xx: add support for Lynxpoint SPI controllers
Date: Mon, 21 Jan 2013 11:32:03 +0200
Message-Id: <1358760723-32752-11-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Lynxpoint PCH Low Power Subsystem has two general purpose SPI
controllers that are LPSS_SSP compatible. These controllers are enumerated
from ACPI namespace with ACPI IDs INT33C0 and INT33C1.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/Kconfig      |    2 +-
 drivers/spi/spi-pxa2xx.c |  110 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 109 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index c3d4555..fe8c645 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -304,7 +304,7 @@ config SPI_PXA2XX_DMA
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on ARCH_PXA || PCI
+	depends on ARCH_PXA || PCI || ACPI
 	select PXA_SSP if ARCH_PXA
 	select SPI_PXA2XX_PXADMA if ARCH_PXA
 	select SPI_PXA2XX_DMA if DMA_ENGINE && !ARCH_PXA
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index fa01b6d..bb350a7 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
+#include <linux/acpi.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -942,6 +943,13 @@ static int setup(struct spi_device *spi)
 		chip->dma_threshold = 0;
 		if (chip_info->enable_loopback)
 			chip->cr1 = SSCR1_LBM;
+	} else if (ACPI_HANDLE(&spi->dev)) {
+		/*
+		 * Slave devices enumerated from ACPI namespace don't
+		 * usually have chip_info but we still might want to use
+		 * DMA with them.
+		 */
+		chip->enable_dma = drv_data->master_info->enable_dma;
 	}
 
 	chip->threshold = (SSCR1_RxTresh(rx_thres) & SSCR1_RFT) |
@@ -1033,6 +1041,99 @@ static void cleanup(struct spi_device *spi)
 	kfree(chip);
 }
 
+#ifdef CONFIG_ACPI
+static int pxa2xx_spi_acpi_add_dma(struct acpi_resource *res, void *data)
+{
+	struct pxa2xx_spi_master *pdata = data;
+
+	if (res->type == ACPI_RESOURCE_TYPE_FIXED_DMA) {
+		const struct acpi_resource_fixed_dma *dma;
+
+		dma = &res->data.fixed_dma;
+		if (pdata->tx_slave_id < 0) {
+			pdata->tx_slave_id = dma->request_lines;
+			pdata->tx_chan_id = dma->channels;
+		} else if (pdata->rx_slave_id < 0) {
+			pdata->rx_slave_id = dma->request_lines;
+			pdata->rx_chan_id = dma->channels;
+		}
+	}
+
+	/* Tell the ACPI core to skip this resource */
+	return 1;
+}
+
+static struct pxa2xx_spi_master *
+pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
+{
+	struct pxa2xx_spi_master *pdata;
+	struct list_head resource_list;
+	struct acpi_device *adev;
+	struct ssp_device *ssp;
+	struct resource *res;
+	int devid;
+
+	if (!ACPI_HANDLE(&pdev->dev) ||
+	    acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev))
+		return NULL;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*ssp), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&pdev->dev,
+			"failed to allocate memory for platform data\n");
+		return NULL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return NULL;
+
+	ssp = &pdata->ssp;
+
+	ssp->phys_base = res->start;
+	ssp->mmio_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!ssp->mmio_base) {
+		dev_err(&pdev->dev, "failed to ioremap mmio_base\n");
+		return NULL;
+	}
+
+	ssp->clk = devm_clk_get(&pdev->dev, NULL);
+	ssp->irq = platform_get_irq(pdev, 0);
+	ssp->type = LPSS_SSP;
+	ssp->pdev = pdev;
+
+	ssp->port_id = -1;
+	if (adev->pnp.unique_id && !kstrtoint(adev->pnp.unique_id, 0, &devid))
+		ssp->port_id = devid;
+
+	pdata->num_chipselect = 1;
+	pdata->rx_slave_id = -1;
+	pdata->tx_slave_id = -1;
+
+	INIT_LIST_HEAD(&resource_list);
+	acpi_dev_get_resources(adev, &resource_list, pxa2xx_spi_acpi_add_dma,
+			       pdata);
+	acpi_dev_free_resource_list(&resource_list);
+
+	pdata->enable_dma = pdata->rx_slave_id >= 0 && pdata->tx_slave_id >= 0;
+
+	return pdata;
+}
+
+static struct acpi_device_id pxa2xx_spi_acpi_match[] = {
+	{ "INT33C0", 0 },
+	{ "INT33C1", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, pxa2xx_spi_acpi_match);
+#else
+static inline struct pxa2xx_spi_master *
+pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
+{
+	return NULL;
+}
+#endif
+
 static int pxa2xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1044,8 +1145,11 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 
 	platform_info = dev_get_platdata(dev);
 	if (!platform_info) {
-		dev_err(&pdev->dev, "missing platform data\n");
-		return -ENODEV;
+		platform_info = pxa2xx_spi_acpi_get_pdata(pdev);
+		if (!platform_info) {
+			dev_err(&pdev->dev, "missing platform data\n");
+			return -ENODEV;
+		}
 	}
 
 	ssp = pxa_ssp_request(pdev->id, pdev->name);
@@ -1072,6 +1176,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 
 	master->dev.parent = &pdev->dev;
 	master->dev.of_node = pdev->dev.of_node;
+	ACPI_HANDLE_SET(&master->dev, ACPI_HANDLE(&pdev->dev));
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
 
@@ -1280,6 +1385,7 @@ static struct platform_driver driver = {
 		.name	= "pxa2xx-spi",
 		.owner	= THIS_MODULE,
 		.pm	= &pxa2xx_spi_pm_ops,
+		.acpi_match_table = ACPI_PTR(pxa2xx_spi_acpi_match),
 	},
 	.probe = pxa2xx_spi_probe,
 	.remove = pxa2xx_spi_remove,
-- 
1.7.10.4

