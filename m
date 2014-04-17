Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbaDQIYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:24:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:64313 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbaDQIXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:23:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,877,1389772800"; 
   d="scan'208";a="522117193"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] spi/pxa2xx-pci: Add PCI mode support for BayTrail LPSS SPI
Date: Fri, 18 Apr 2014 00:26:06 +0800
Message-Id: <1397751967-20250-2-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
References: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Similar to CE4100, BayTrail LPSS SPI can be PCI enumerated
as well. Thus, the functions are renamed from ce4100_xxx
to pxa2xx_spi_pci_xxx to clarify that this is a generic
PCI glue layer. Also, added required infrastructure to
support SPI hosts with different configurations.

This patch is based on Mika Westerberg's previous work.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
---
 drivers/spi/spi-pxa2xx-pci.c |   76 +++++++++++++++++++++++++++++++++--------
 1 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index 3f006d3..c1865c9 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -8,7 +8,43 @@
 #include <linux/module.h>
 #include <linux/spi/pxa2xx_spi.h>
 
-static int ce4100_spi_probe(struct pci_dev *dev,
+enum {
+	PORT_CE4100,
+	PORT_BYT,
+};
+
+struct pxa_spi_info {
+	enum pxa_ssp_type type;
+	int port_id;
+	int num_chipselect;
+	int tx_slave_id;
+	int tx_chan_id;
+	int rx_slave_id;
+	int rx_chan_id;
+};
+
+static struct pxa_spi_info spi_info_configs[] = {
+	[PORT_CE4100] = {
+		.type = PXA25x_SSP,
+		.port_id =  -1,
+		.num_chipselect = -1,
+		.tx_slave_id = -1,
+		.tx_chan_id = -1,
+		.rx_slave_id = -1,
+		.rx_chan_id = -1,
+	},
+	[PORT_BYT] = {
+		.type = LPSS_SSP,
+		.port_id = 0,
+		.num_chipselect = 1,
+		.tx_slave_id = 0,
+		.tx_chan_id = 0,
+		.rx_slave_id = 1,
+		.rx_chan_id = 1,
+	},
+};
+
+static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
 		const struct pci_device_id *ent)
 {
 	struct platform_device_info pi;
@@ -16,6 +52,7 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 	struct platform_device *pdev;
 	struct pxa2xx_spi_master spi_pdata;
 	struct ssp_device *ssp;
+	struct pxa_spi_info *c;
 
 	ret = pcim_enable_device(dev);
 	if (ret)
@@ -25,8 +62,16 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 	if (ret)
 		return ret;
 
+	c = &spi_info_configs[ent->driver_data];
+
 	memset(&spi_pdata, 0, sizeof(spi_pdata));
-	spi_pdata.num_chipselect = dev->devfn;
+	spi_pdata.num_chipselect = (c->num_chipselect > 0) ?
+					c->num_chipselect : dev->devfn;
+	spi_pdata.tx_slave_id = c->tx_slave_id;
+	spi_pdata.tx_chan_id = c->tx_chan_id;
+	spi_pdata.rx_slave_id = c->rx_slave_id;
+	spi_pdata.rx_chan_id = c->rx_chan_id;
+	spi_pdata.enable_dma = c->rx_slave_id >= 0 && c->tx_slave_id >= 0;
 
 	ssp = &spi_pdata.ssp;
 	ssp->phys_base = pci_resource_start(dev, 0);
@@ -36,8 +81,8 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 		return -EIO;
 	}
 	ssp->irq = dev->irq;
-	ssp->port_id = dev->devfn;
-	ssp->type = PXA25x_SSP;
+	ssp->port_id = (c->port_id >= 0) ? c->port_id : dev->devfn;
+	ssp->type = c->type;
 
 	memset(&pi, 0, sizeof(pi));
 	pi.parent = &dev->dev;
@@ -55,28 +100,29 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 	return 0;
 }
 
-static void ce4100_spi_remove(struct pci_dev *dev)
+static void pxa2xx_spi_pci_remove(struct pci_dev *dev)
 {
 	struct platform_device *pdev = pci_get_drvdata(dev);
 
 	platform_device_unregister(pdev);
 }
 
-static const struct pci_device_id ce4100_spi_devices[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2e6a) },
+static const struct pci_device_id pxa2xx_spi_pci_devices[] = {
+	{ PCI_VDEVICE(INTEL, 0x2e6a), PORT_CE4100 },
+	{ PCI_VDEVICE(INTEL, 0x0f0e), PORT_BYT },
 	{ },
 };
-MODULE_DEVICE_TABLE(pci, ce4100_spi_devices);
+MODULE_DEVICE_TABLE(pci, pxa2xx_spi_pci_devices);
 
-static struct pci_driver ce4100_spi_driver = {
-	.name           = "ce4100_spi",
-	.id_table       = ce4100_spi_devices,
-	.probe          = ce4100_spi_probe,
-	.remove         = ce4100_spi_remove,
+static struct pci_driver pxa2xx_spi_pci_driver = {
+	.name           = "pxa2xx_spi_pci",
+	.id_table       = pxa2xx_spi_pci_devices,
+	.probe          = pxa2xx_spi_pci_probe,
+	.remove         = pxa2xx_spi_pci_remove,
 };
 
-module_pci_driver(ce4100_spi_driver);
+module_pci_driver(pxa2xx_spi_pci_driver);
 
-MODULE_DESCRIPTION("CE4100 PCI-SPI glue code for PXA's driver");
+MODULE_DESCRIPTION("CE4100/LPSS PCI-SPI glue code for PXA's driver");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Sebastian Andrzej Siewior <bigeasy@linutronix.de>");
-- 
1.7.4.4

