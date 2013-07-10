Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3GJQiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:38:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49368 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3GJQiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:38:24 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] spi: revert master->setup function removal for altera and nuc900
Date: Wed, 10 Jul 2013 10:38:18 -0600
Message-Id: <1373474298-13470-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit 24778be "spi: convert drivers to use bits_per_word_mask" removed
what appeared to be redundant code from many drivers. However, it
appears that in the spi-bitbang case, these functions are required by
the spi-bitbang core, even if they don't do anything. Restore them.

For 3.12, the spi-bitbang core should be adjusted not to require these
callbacks to exist if they don't need to do anything.

This is the equivalent of Michal Simek's patch "spi/xilinx: Revert
master->setup function removal", applied to other affected drivers.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Sorry, I suck:-(

 drivers/spi/spi-altera.c | 12 ++++++++++++
 drivers/spi/spi-nuc900.c | 13 +++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/spi/spi-altera.c b/drivers/spi/spi-altera.c
index 8a6bb37..81b9adb 100644
--- a/drivers/spi/spi-altera.c
+++ b/drivers/spi/spi-altera.c
@@ -103,6 +103,16 @@ static void altera_spi_chipsel(struct spi_device *spi, int value)
 	}
 }
 
+static int altera_spi_setupxfer(struct spi_device *spi, struct spi_transfer *t)
+{
+	return 0;
+}
+
+static int altera_spi_setup(struct spi_device *spi)
+{
+	return 0;
+}
+
 static inline unsigned int hw_txbyte(struct altera_spi *hw, int count)
 {
 	if (hw->tx) {
@@ -221,6 +231,7 @@ static int altera_spi_probe(struct platform_device *pdev)
 	master->bus_num = pdev->id;
 	master->num_chipselect = 16;
 	master->mode_bits = SPI_CS_HIGH;
+	master->setup = altera_spi_setup;
 
 	hw = spi_master_get_devdata(master);
 	platform_set_drvdata(pdev, hw);
@@ -229,6 +240,7 @@ static int altera_spi_probe(struct platform_device *pdev)
 	hw->bitbang.master = spi_master_get(master);
 	if (!hw->bitbang.master)
 		return err;
+	hw->bitbang.setup_transfer = altera_spi_setupxfer;
 	hw->bitbang.chipselect = altera_spi_chipsel;
 	hw->bitbang.txrx_bufs = altera_spi_txrx;
 
diff --git a/drivers/spi/spi-nuc900.c b/drivers/spi/spi-nuc900.c
index 2ad3d74..150d854 100644
--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -174,6 +174,17 @@ static void nuc900_spi_gobusy(struct nuc900_spi *hw)
 	spin_unlock_irqrestore(&hw->lock, flags);
 }
 
+static int nuc900_spi_setupxfer(struct spi_device *spi,
+				 struct spi_transfer *t)
+{
+	return 0;
+}
+
+static int nuc900_spi_setup(struct spi_device *spi)
+{
+	return 0;
+}
+
 static inline unsigned int hw_txbyte(struct nuc900_spi *hw, int count)
 {
 	return hw->tx ? hw->tx[count] : 0;
@@ -366,8 +377,10 @@ static int nuc900_spi_probe(struct platform_device *pdev)
 	master->num_chipselect     = hw->pdata->num_cs;
 	master->bus_num            = hw->pdata->bus_num;
 	hw->bitbang.master         = hw->master;
+	hw->bitbang.setup_transfer = nuc900_spi_setupxfer;
 	hw->bitbang.chipselect     = nuc900_spi_chipsel;
 	hw->bitbang.txrx_bufs      = nuc900_spi_txrx;
+	hw->bitbang.master->setup  = nuc900_spi_setup;
 
 	hw->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (hw->res == NULL) {
-- 
1.8.1.5

