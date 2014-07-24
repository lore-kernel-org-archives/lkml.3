Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaGXJGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:06:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:4785 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaGXJGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:06:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,722,1400050800"; 
   d="scan'208";a="548292885"
From: chiau.ee.chew@intel.com
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>, chiauee85@gmail.com
Subject: [PATCH v2] spi/pxa2xx-pci: Add common clock framework support in PCI glue layer
Date: Fri, 25 Jul 2014 01:10:54 +0800
Message-Id: <1406221854-12828-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

SPI PXA2XX core layer has dependency on common clock framework
to obtain information on host supported clock rate. Thus, we
setup the clock device in the PCI glue layer to enable PCI mode
host pass in the clock rate information.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Acked-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
---
 changelog v2:
 i. add CONFIG_COMMON_CLK dependency for SPI_PXA2XX_PCI in Kconfig
 ii. add clk cleanup in remove()

 drivers/spi/Kconfig          |    2 +-
 drivers/spi/spi-pxa2xx-pci.c |   21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 62e2242..aa005cb 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -380,7 +380,7 @@ config SPI_PXA2XX
 	  additional documentation can be found a Documentation/spi/pxa2xx.
 
 config SPI_PXA2XX_PCI
-	def_tristate SPI_PXA2XX && PCI
+	def_tristate SPI_PXA2XX && PCI && COMMON_CLK
 
 config SPI_ROCKCHIP
 	tristate "Rockchip SPI controller driver"
diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index c1865c9..20ebbc7 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -7,6 +7,8 @@
 #include <linux/of_device.h>
 #include <linux/module.h>
 #include <linux/spi/pxa2xx_spi.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
 
 enum {
 	PORT_CE4100,
@@ -21,6 +23,7 @@ struct pxa_spi_info {
 	int tx_chan_id;
 	int rx_slave_id;
 	int rx_chan_id;
+	unsigned long max_clk_rate;
 };
 
 static struct pxa_spi_info spi_info_configs[] = {
@@ -32,6 +35,7 @@ static struct pxa_spi_info spi_info_configs[] = {
 		.tx_chan_id = -1,
 		.rx_slave_id = -1,
 		.rx_chan_id = -1,
+		.max_clk_rate = 3686400,
 	},
 	[PORT_BYT] = {
 		.type = LPSS_SSP,
@@ -41,6 +45,7 @@ static struct pxa_spi_info spi_info_configs[] = {
 		.tx_chan_id = 0,
 		.rx_slave_id = 1,
 		.rx_chan_id = 1,
+		.max_clk_rate = 50000000,
 	},
 };
 
@@ -53,6 +58,7 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
 	struct pxa2xx_spi_master spi_pdata;
 	struct ssp_device *ssp;
 	struct pxa_spi_info *c;
+	char buf[40];
 
 	ret = pcim_enable_device(dev);
 	if (ret)
@@ -84,6 +90,12 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
 	ssp->port_id = (c->port_id >= 0) ? c->port_id : dev->devfn;
 	ssp->type = c->type;
 
+	snprintf(buf, sizeof(buf), "pxa2xx-spi.%d", ssp->port_id);
+	ssp->clk = clk_register_fixed_rate(&dev->dev, buf , NULL,
+					CLK_IS_ROOT, c->max_clk_rate);
+	 if (IS_ERR(ssp->clk))
+		return PTR_ERR(ssp->clk);
+
 	memset(&pi, 0, sizeof(pi));
 	pi.parent = &dev->dev;
 	pi.name = "pxa2xx-spi";
@@ -92,8 +104,10 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
 	pi.size_data = sizeof(spi_pdata);
 
 	pdev = platform_device_register_full(&pi);
-	if (IS_ERR(pdev))
+	if (IS_ERR(pdev)) {
+		clk_unregister(ssp->clk);
 		return PTR_ERR(pdev);
+	}
 
 	pci_set_drvdata(dev, pdev);
 
@@ -103,8 +117,13 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
 static void pxa2xx_spi_pci_remove(struct pci_dev *dev)
 {
 	struct platform_device *pdev = pci_get_drvdata(dev);
+	struct pxa2xx_spi_master *spi_pdata;
+
+	spi_pdata = dev_get_platdata(&pdev->dev);
 
 	platform_device_unregister(pdev);
+	clk_unregister(spi_pdata->ssp.clk);
+	pci_set_drvdata(dev, NULL);
 }
 
 static const struct pci_device_id pxa2xx_spi_pci_devices[] = {
-- 
1.7.4.4

