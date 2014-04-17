Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161257AbaDQIXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:23:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:64313 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbaDQIXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:23:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,877,1389772800"; 
   d="scan'208";a="522117212"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] spi/pxa2xx-pci: Pass host clock rate info from PCI glue layer
Date: Fri, 18 Apr 2014 00:26:07 +0800
Message-Id: <1397751967-20250-3-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
References: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Intel BayTrail PCI mode LPSS devices inclusive of SPI do not rely
on common clock framework. Thus, this patch allows the PCI mode
SPI host to pass the supported clock rate info to the core layer
which eventually used for speed calculation.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
---
 Documentation/spi/pxa2xx       |    3 +++
 drivers/spi/spi-pxa2xx-pci.c   |    3 +++
 drivers/spi/spi-pxa2xx.c       |    2 ++
 include/linux/spi/pxa2xx_spi.h |    1 +
 4 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/spi/pxa2xx b/Documentation/spi/pxa2xx
index 3352f97..3cde429 100644
--- a/Documentation/spi/pxa2xx
+++ b/Documentation/spi/pxa2xx
@@ -31,6 +31,9 @@ The "pxa2xx_spi_master.clock_enable" field is used to enable/disable the
 corresponding SSP peripheral block in the "Clock Enable Register (CKEN"). See
 the "PXA2xx Developer Manual" section "Clocks and Power Management".
 
+The "pxa2xx_spi_master.max_clk_rate" field is used to determine the maximum
+clock rate supported by the SPI master.
+
 The "pxa2xx_spi_master.num_chipselect" field is used to determine the number of
 slave device (chips) attached to this SPI master.
 
diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index c1865c9..24cd938 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -17,6 +17,7 @@ struct pxa_spi_info {
 	enum pxa_ssp_type type;
 	int port_id;
 	int num_chipselect;
+	unsigned long max_clk_rate;
 	int tx_slave_id;
 	int tx_chan_id;
 	int rx_slave_id;
@@ -37,6 +38,7 @@ static struct pxa_spi_info spi_info_configs[] = {
 		.type = LPSS_SSP,
 		.port_id = 0,
 		.num_chipselect = 1,
+		.max_clk_rate = 50000000,
 		.tx_slave_id = 0,
 		.tx_chan_id = 0,
 		.rx_slave_id = 1,
@@ -72,6 +74,7 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
 	spi_pdata.rx_slave_id = c->rx_slave_id;
 	spi_pdata.rx_chan_id = c->rx_chan_id;
 	spi_pdata.enable_dma = c->rx_slave_id >= 0 && c->tx_slave_id >= 0;
+	spi_pdata.max_clk_rate = c->max_clk_rate;
 
 	ssp = &spi_pdata.ssp;
 	ssp->phys_base = pci_resource_start(dev, 0);
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index d0fc8e0..b670371 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1182,6 +1182,8 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	clk_prepare_enable(ssp->clk);
 
 	drv_data->max_clk_rate = clk_get_rate(ssp->clk);
+	if (!drv_data->max_clk_rate)
+		drv_data->max_clk_rate = platform_info->max_clk_rate;
 
 	/* Load default SSP configuration */
 	write_SSCR0(0, drv_data->ioaddr);
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index 82d5111..967903f 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -28,6 +28,7 @@ struct pxa2xx_spi_master {
 	u32 clock_enable;
 	u16 num_chipselect;
 	u8 enable_dma;
+	unsigned long max_clk_rate;
 
 	/* DMA engine specific config */
 	int rx_chan_id;
-- 
1.7.4.4

