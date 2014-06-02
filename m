Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaFBLoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:44:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:30334 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbaFBLoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,956,1392192000"; 
   d="scan'208";a="439803194"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org, Chew Chiau Ee <chiau.ee.chew@intel.com>
Subject: [PATCH 1/2] spi/pxa2xx-pci: Add common clock framework support in PCI glue layer
Date: Tue,  3 Jun 2014 03:46:18 +0800
Message-Id: <1401738379-4107-2-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1401738379-4107-1-git-send-email-chiau.ee.chew@intel.com>
References: <1401738379-4107-1-git-send-email-chiau.ee.chew@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

SPI PXA2XX core layer has dependency on common clock framework
to obtain information on host supported clock rate. Thus, we
setup the clock device in the PCI glue layer to enable PCI mode
host pass in the clock rate information.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
---
 drivers/spi/spi-pxa2xx-pci.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index c1865c9..11adc9b 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -7,6 +7,9 @@
 #include <linux/of_device.h>
 #include <linux/module.h>
 #include <linux/spi/pxa2xx_spi.h>
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
 
 enum {
 	PORT_CE4100,
@@ -21,6 +24,7 @@ struct pxa_spi_info {
 	int tx_chan_id;
 	int rx_slave_id;
 	int rx_chan_id;
+	unsigned long max_clk_rate;
 };
 
 static struct pxa_spi_info spi_info_configs[] = {
@@ -32,6 +36,7 @@ static struct pxa_spi_info spi_info_configs[] = {
 		.tx_chan_id = -1,
 		.rx_slave_id = -1,
 		.rx_chan_id = -1,
+		.max_clk_rate = 3686400,
 	},
 	[PORT_BYT] = {
 		.type = LPSS_SSP,
@@ -41,6 +46,7 @@ static struct pxa_spi_info spi_info_configs[] = {
 		.tx_chan_id = 0,
 		.rx_slave_id = 1,
 		.rx_chan_id = 1,
+		.max_clk_rate = 50000000,
 	},
 };
 
@@ -53,6 +59,7 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
 	struct pxa2xx_spi_master spi_pdata;
 	struct ssp_device *ssp;
 	struct pxa_spi_info *c;
+	struct clk *clk;
 
 	ret = pcim_enable_device(dev);
 	if (ret)
@@ -84,6 +91,19 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
 	ssp->port_id = (c->port_id >= 0) ? c->port_id : dev->devfn;
 	ssp->type = c->type;
 
+	clk = clk_register_fixed_rate(&dev->dev, "spi_pxa2xx_clk", NULL,
+					CLK_IS_ROOT, c->max_clk_rate);
+	 if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	clk_register_clkdev(clk, NULL, dev_name(&dev->dev));
+
+	ssp->clk = devm_clk_get(&dev->dev, NULL);
+	if (IS_ERR(ssp->clk)) {
+		dev_err(&dev->dev, "failed to get clock\n");
+		return PTR_ERR(ssp->clk);
+	}
+
 	memset(&pi, 0, sizeof(pi));
 	pi.parent = &dev->dev;
 	pi.name = "pxa2xx-spi";
-- 
1.7.4.4

