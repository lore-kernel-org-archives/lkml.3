Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab3CEUyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:54:16 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:37415 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898Ab3CEUxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:53:05 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>
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
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v8 7/9] spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
Date: Tue,  5 Mar 2013 15:53:13 -0500
Message-Id: <1362516795-6346-8-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362516795-6346-1-git-send-email-mporter@ti.com>
References: <1362516795-6346-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert dmaengine channel requests to use
dma_request_slave_channel_compat(). This supports the DT case of
platforms requiring channel selection from either the OMAP DMA or
the EDMA engine. AM33xx only boots from DT and is the only user
implementing EDMA so in the !DT case we can default to the OMAP DMA
filter.

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi-omap2-mcspi.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 893c3d7..38d0915 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -102,6 +102,9 @@ struct omap2_mcspi_dma {
 
 	struct completion dma_tx_completion;
 	struct completion dma_rx_completion;
+
+	char dma_rx_ch_name[14];
+	char dma_tx_ch_name[14];
 };
 
 /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
@@ -822,14 +825,23 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 	sig = mcspi_dma->dma_rx_sync_dev;
-	mcspi_dma->dma_rx = dma_request_channel(mask, omap_dma_filter_fn, &sig);
+
+	mcspi_dma->dma_rx =
+		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
+						 &sig, &master->dev,
+						 mcspi_dma->dma_rx_ch_name);
+
 	if (!mcspi_dma->dma_rx) {
 		dev_err(&spi->dev, "no RX DMA engine channel for McSPI\n");
 		return -EAGAIN;
 	}
 
 	sig = mcspi_dma->dma_tx_sync_dev;
-	mcspi_dma->dma_tx = dma_request_channel(mask, omap_dma_filter_fn, &sig);
+	mcspi_dma->dma_tx =
+		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
+						 &sig, &master->dev,
+						 mcspi_dma->dma_tx_ch_name);
+
 	if (!mcspi_dma->dma_tx) {
 		dev_err(&spi->dev, "no TX DMA engine channel for McSPI\n");
 		dma_release_channel(mcspi_dma->dma_rx);
@@ -1240,12 +1252,13 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 		goto free_master;
 
 	for (i = 0; i < master->num_chipselect; i++) {
-		char dma_ch_name[14];
+		char *dma_rx_ch_name = mcspi->dma_channels[i].dma_rx_ch_name;
+		char *dma_tx_ch_name = mcspi->dma_channels[i].dma_tx_ch_name;
 		struct resource *dma_res;
 
-		sprintf(dma_ch_name, "rx%d", i);
+		sprintf(dma_rx_ch_name, "rx%d", i);
 		dma_res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
-				dma_ch_name);
+				dma_rx_ch_name);
 		if (!dma_res) {
 			dev_dbg(&pdev->dev, "cannot get DMA RX channel\n");
 			status = -ENODEV;
@@ -1253,9 +1266,9 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 		}
 
 		mcspi->dma_channels[i].dma_rx_sync_dev = dma_res->start;
-		sprintf(dma_ch_name, "tx%d", i);
+		sprintf(dma_tx_ch_name, "tx%d", i);
 		dma_res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
-				dma_ch_name);
+				dma_tx_ch_name);
 		if (!dma_res) {
 			dev_dbg(&pdev->dev, "cannot get DMA TX channel\n");
 			status = -ENODEV;
-- 
1.7.9.5

