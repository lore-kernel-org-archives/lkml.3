Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3AVK2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:28:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:30225 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab3AVKZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:25:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,513,1355126400"; 
   d="scan'208";a="280457720"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com, Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3 04/10] spi/pxa2xx: convert to the common clk framework
Date: Tue, 22 Jan 2013 12:26:27 +0200
Message-Id: <1358850393-23111-5-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert clk_enable() to clk_prepare_enable() and clk_disable() to
clk_disable_unprepare() respectively in order to support the common clk
framework. Otherwise we get warnings on the console as the clock is not
prepared before it is enabled.

In addition we must cache the maximum clock rate to drv_data->max_clk_rate
at probe time because clk_get_rate() cannot be called in tasklet context.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c       |   33 ++++++++++++++++++++-------------
 include/linux/spi/pxa2xx_spi.h |   18 ------------------
 2 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index a241891..304cf6e 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -30,6 +30,7 @@
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/clk.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -114,6 +115,9 @@ struct driver_data {
 	u32 clear_sr;
 	u32 mask_sr;
 
+	/* Maximun clock rate */
+	unsigned long max_clk_rate;
+
 	/* Message Transfer pump */
 	struct tasklet_struct pump_transfers;
 
@@ -891,9 +895,12 @@ static int set_dma_burst_and_threshold(struct chip_data *chip,
 	return retval;
 }
 
-static unsigned int ssp_get_clk_div(struct ssp_device *ssp, int rate)
+static unsigned int ssp_get_clk_div(struct driver_data *drv_data, int rate)
 {
-	unsigned long ssp_clk = clk_get_rate(ssp->clk);
+	unsigned long ssp_clk = drv_data->max_clk_rate;
+	const struct ssp_device *ssp = drv_data->ssp;
+
+	rate = min_t(int, ssp_clk, rate);
 
 	if (ssp->type == PXA25x_SSP || ssp->type == CE4100_SSP)
 		return ((ssp_clk / (2 * rate) - 1) & 0xff) << 8;
@@ -908,7 +915,6 @@ static void pump_transfers(unsigned long data)
 	struct spi_transfer *transfer = NULL;
 	struct spi_transfer *previous = NULL;
 	struct chip_data *chip = NULL;
-	struct ssp_device *ssp = drv_data->ssp;
 	void __iomem *reg = drv_data->ioaddr;
 	u32 clk_div = 0;
 	u8 bits = 0;
@@ -1005,7 +1011,7 @@ static void pump_transfers(unsigned long data)
 		if (transfer->bits_per_word)
 			bits = transfer->bits_per_word;
 
-		clk_div = ssp_get_clk_div(ssp, speed);
+		clk_div = ssp_get_clk_div(drv_data, speed);
 
 		if (bits <= 8) {
 			drv_data->n_bytes = 1;
@@ -1214,7 +1220,6 @@ static int setup(struct spi_device *spi)
 	struct pxa2xx_spi_chip *chip_info = NULL;
 	struct chip_data *chip;
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
-	struct ssp_device *ssp = drv_data->ssp;
 	unsigned int clk_div;
 	uint tx_thres = TX_THRESH_DFLT;
 	uint rx_thres = RX_THRESH_DFLT;
@@ -1296,7 +1301,7 @@ static int setup(struct spi_device *spi)
 		}
 	}
 
-	clk_div = ssp_get_clk_div(ssp, spi->max_speed_hz);
+	clk_div = ssp_get_clk_div(drv_data, spi->max_speed_hz);
 	chip->speed_hz = spi->max_speed_hz;
 
 	chip->cr0 = clk_div
@@ -1312,12 +1317,12 @@ static int setup(struct spi_device *spi)
 	/* NOTE:  PXA25x_SSP _could_ use external clocking ... */
 	if (!pxa25x_ssp_comp(drv_data))
 		dev_dbg(&spi->dev, "%ld Hz actual, %s\n",
-			clk_get_rate(ssp->clk)
+			drv_data->max_clk_rate
 				/ (1 + ((chip->cr0 & SSCR0_SCR(0xfff)) >> 8)),
 			chip->enable_dma ? "DMA" : "PIO");
 	else
 		dev_dbg(&spi->dev, "%ld Hz actual, %s\n",
-			clk_get_rate(ssp->clk) / 2
+			drv_data->max_clk_rate / 2
 				/ (1 + ((chip->cr0 & SSCR0_SCR(0x0ff)) >> 8)),
 			chip->enable_dma ? "DMA" : "PIO");
 
@@ -1470,7 +1475,9 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	}
 
 	/* Enable SOC clock */
-	clk_enable(ssp->clk);
+	clk_prepare_enable(ssp->clk);
+
+	drv_data->max_clk_rate = clk_get_rate(ssp->clk);
 
 	/* Load default SSP configuration */
 	write_SSCR0(0, drv_data->ioaddr);
@@ -1499,7 +1506,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	return status;
 
 out_error_clock_enabled:
-	clk_disable(ssp->clk);
+	clk_disable_unprepare(ssp->clk);
 
 out_error_dma_alloc:
 	if (drv_data->tx_channel != -1)
@@ -1527,7 +1534,7 @@ static int pxa2xx_spi_remove(struct platform_device *pdev)
 
 	/* Disable the SSP at the peripheral and SOC level */
 	write_SSCR0(0, drv_data->ioaddr);
-	clk_disable(ssp->clk);
+	clk_disable_unprepare(ssp->clk);
 
 	/* Release DMA */
 	if (drv_data->master_info->enable_dma) {
@@ -1571,7 +1578,7 @@ static int pxa2xx_spi_suspend(struct device *dev)
 	if (status != 0)
 		return status;
 	write_SSCR0(0, drv_data->ioaddr);
-	clk_disable(ssp->clk);
+	clk_disable_unprepare(ssp->clk);
 
 	return 0;
 }
@@ -1590,7 +1597,7 @@ static int pxa2xx_spi_resume(struct device *dev)
 			DRCMR_MAPVLD | drv_data->tx_channel;
 
 	/* Enable the SSP clock */
-	clk_enable(ssp->clk);
+	clk_prepare_enable(ssp->clk);
 
 	/* Start the queue running */
 	status = spi_master_resume(drv_data->master);
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index 6b99f09..053b5ba 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -133,23 +133,5 @@ static inline void pxa_free_dma(int dma_ch)
 {
 }
 
-/*
- * The CE4100 does not have the clk framework implemented and SPI clock can
- * not be switched on/off or the divider changed.
- */
-static inline void clk_disable(struct clk *clk)
-{
-}
-
-static inline int clk_enable(struct clk *clk)
-{
-	return 0;
-}
-
-static inline unsigned long clk_get_rate(struct clk *clk)
-{
-	return 3686400;
-}
-
 #endif
 #endif
-- 
1.7.10.4

