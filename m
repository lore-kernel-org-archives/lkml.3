Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaHSRe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:34:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:36503 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbaHSReT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="578872944"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 10/12] spi/pxa2xx-pci: Add support for Intel Braswell
Date: Tue, 19 Aug 2014 20:29:21 +0300
Message-Id: <1408469363-15901-11-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Instead of one port we have 3 ports and all of them can take advantage of
the shared DMA controller.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx-pci.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index c950ee2..6beee8c 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -16,6 +16,9 @@
 enum {
 	PORT_CE4100,
 	PORT_BYT,
+	PORT_BSW0,
+	PORT_BSW1,
+	PORT_BSW2,
 };
 
 struct pxa_spi_info {
@@ -32,6 +35,13 @@ struct pxa_spi_info {
 static struct dw_dma_slave byt_tx_param = { .dst_id = 0 };
 static struct dw_dma_slave byt_rx_param = { .src_id = 1 };
 
+static struct dw_dma_slave bsw0_tx_param = { .dst_id = 0 };
+static struct dw_dma_slave bsw0_rx_param = { .src_id = 1 };
+static struct dw_dma_slave bsw1_tx_param = { .dst_id = 6 };
+static struct dw_dma_slave bsw1_rx_param = { .src_id = 7 };
+static struct dw_dma_slave bsw2_tx_param = { .dst_id = 8 };
+static struct dw_dma_slave bsw2_rx_param = { .src_id = 9 };
+
 static bool lpss_dma_filter(struct dma_chan *chan, void *param)
 {
 	struct dw_dma_slave *dws = param;
@@ -58,6 +68,30 @@ static struct pxa_spi_info spi_info_configs[] = {
 		.tx_param = &byt_tx_param,
 		.rx_param = &byt_rx_param,
 	},
+	[PORT_BSW0] = {
+		.type = LPSS_SSP,
+		.port_id = 0,
+		.num_chipselect = 1,
+		.max_clk_rate = 50000000,
+		.tx_param = &bsw0_tx_param,
+		.rx_param = &bsw0_rx_param,
+	},
+	[PORT_BSW1] = {
+		.type = LPSS_SSP,
+		.port_id = 1,
+		.num_chipselect = 1,
+		.max_clk_rate = 50000000,
+		.tx_param = &bsw1_tx_param,
+		.rx_param = &bsw1_rx_param,
+	},
+	[PORT_BSW2] = {
+		.type = LPSS_SSP,
+		.port_id = 2,
+		.num_chipselect = 1,
+		.max_clk_rate = 50000000,
+		.tx_param = &bsw2_tx_param,
+		.rx_param = &bsw2_rx_param,
+	},
 };
 
 static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
@@ -158,6 +192,9 @@ static void pxa2xx_spi_pci_remove(struct pci_dev *dev)
 static const struct pci_device_id pxa2xx_spi_pci_devices[] = {
 	{ PCI_VDEVICE(INTEL, 0x2e6a), PORT_CE4100 },
 	{ PCI_VDEVICE(INTEL, 0x0f0e), PORT_BYT },
+	{ PCI_VDEVICE(INTEL, 0x228e), PORT_BSW0 },
+	{ PCI_VDEVICE(INTEL, 0x2290), PORT_BSW1 },
+	{ PCI_VDEVICE(INTEL, 0x22ac), PORT_BSW2 },
 	{ },
 };
 MODULE_DEVICE_TABLE(pci, pxa2xx_spi_pci_devices);
-- 
2.1.0

