Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3AUJbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:31:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:37125 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3AUJbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:31:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="279685579"
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
Subject: [PATCH v2 09/10] spi/pxa2xx: add support for Intel Low Power Subsystem SPI
Date: Mon, 21 Jan 2013 11:32:02 +0200
Message-Id: <1358760723-32752-10-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel LPSS SPI is pretty much the same as the PXA27xx SPI except that it
has few additional features over the original:

	o FIFO depth is 256 entries
	o RX FIFO has one watermark
	o TX FIFO has two watermarks, low and high
	o chip select can be controlled by writing to a register

The new FIFO registers follow immediately the PXA27xx registers but then there
are some additional LPSS private registers at offset 1k or 2k from the base
address. For these private registers we add new accessors that take advantage
of drv_data->lpss_base once it is resolved.

We add a new type LPSS_SSP that can be used to distinguish the LPSS devices
from others.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c       |  133 ++++++++++++++++++++++++++++++++++++++--
 drivers/spi/spi-pxa2xx.h       |    6 ++
 include/linux/pxa2xx_ssp.h     |    9 +++
 include/linux/spi/pxa2xx_spi.h |    1 +
 4 files changed, 145 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 1a56faa..fa01b6d 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2005 Stephen Street / StreetFire Sound Labs
+ * Copyright (C) 2013, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -61,6 +62,98 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 				| SSCR1_RFT | SSCR1_TFT | SSCR1_MWDS \
 				| SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
 
+#define LPSS_RX_THRESH_DFLT	64
+#define LPSS_TX_LOTHRESH_DFLT	160
+#define LPSS_TX_HITHRESH_DFLT	224
+
+/* Offset from drv_data->lpss_base */
+#define SPI_CS_CONTROL		0x18
+#define SPI_CS_CONTROL_SW_MODE	BIT(0)
+#define SPI_CS_CONTROL_CS_HIGH	BIT(1)
+
+static bool is_lpss_ssp(const struct driver_data *drv_data)
+{
+	return drv_data->ssp_type == LPSS_SSP;
+}
+
+/*
+ * Read and write LPSS SSP private registers. Caller must first check that
+ * is_lpss_ssp() returns true before these can be called.
+ */
+static u32 __lpss_ssp_read_priv(struct driver_data *drv_data, unsigned offset)
+{
+	WARN_ON(!drv_data->lpss_base);
+	return readl(drv_data->lpss_base + offset);
+}
+
+static void __lpss_ssp_write_priv(struct driver_data *drv_data,
+				  unsigned offset, u32 value)
+{
+	WARN_ON(!drv_data->lpss_base);
+	writel(value, drv_data->lpss_base + offset);
+}
+
+/*
+ * lpss_ssp_setup - perform LPSS SSP specific setup
+ * @drv_data: pointer to the driver private data
+ *
+ * Perform LPSS SSP specific setup. This function must be called first if
+ * one is going to use LPSS SSP private registers.
+ */
+static void lpss_ssp_setup(struct driver_data *drv_data)
+{
+	unsigned offset = 0x400;
+	u32 value, orig;
+
+	if (!is_lpss_ssp(drv_data))
+		return;
+
+	/*
+	 * Perform auto-detection of the LPSS SSP private registers. They
+	 * can be either at 1k or 2k offset from the base address.
+	 */
+	orig = readl(drv_data->ioaddr + offset + SPI_CS_CONTROL);
+
+	value = orig | SPI_CS_CONTROL_SW_MODE;
+	writel(value, drv_data->ioaddr + offset + SPI_CS_CONTROL);
+	value = readl(drv_data->ioaddr + offset + SPI_CS_CONTROL);
+	if (value != (orig | SPI_CS_CONTROL_SW_MODE)) {
+		offset = 0x800;
+		goto detection_done;
+	}
+
+	value &= ~SPI_CS_CONTROL_SW_MODE;
+	writel(value, drv_data->ioaddr + offset + SPI_CS_CONTROL);
+	value = readl(drv_data->ioaddr + offset + SPI_CS_CONTROL);
+	if (value != orig) {
+		offset = 0x800;
+		goto detection_done;
+	}
+
+detection_done:
+	/* Now set the LPSS base */
+	drv_data->lpss_base = drv_data->ioaddr + offset;
+
+	/* Enable software chip select control */
+	value = SPI_CS_CONTROL_SW_MODE | SPI_CS_CONTROL_CS_HIGH;
+	__lpss_ssp_write_priv(drv_data, SPI_CS_CONTROL, value);
+}
+
+static void lpss_ssp_cs_control(struct driver_data *drv_data, bool enable)
+{
+	u32 value;
+
+	if (!is_lpss_ssp(drv_data))
+		return;
+
+	value = __lpss_ssp_read_priv(drv_data, SPI_CS_CONTROL);
+	if (enable)
+		value &= ~SPI_CS_CONTROL_CS_HIGH;
+	else
+		value |= SPI_CS_CONTROL_CS_HIGH;
+	__lpss_ssp_write_priv(drv_data, SPI_CS_CONTROL, value);
+}
+
 static void cs_assert(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
@@ -75,8 +168,12 @@ static void cs_assert(struct driver_data *drv_data)
 		return;
 	}
 
-	if (gpio_is_valid(chip->gpio_cs))
+	if (gpio_is_valid(chip->gpio_cs)) {
 		gpio_set_value(chip->gpio_cs, chip->gpio_cs_inverted);
+		return;
+	}
+
+	lpss_ssp_cs_control(drv_data, true);
 }
 
 static void cs_deassert(struct driver_data *drv_data)
@@ -91,8 +188,12 @@ static void cs_deassert(struct driver_data *drv_data)
 		return;
 	}
 
-	if (gpio_is_valid(chip->gpio_cs))
+	if (gpio_is_valid(chip->gpio_cs)) {
 		gpio_set_value(chip->gpio_cs, !chip->gpio_cs_inverted);
+		return;
+	}
+
+	lpss_ssp_cs_control(drv_data, false);
 }
 
 void write_SSSR_CS(struct driver_data *drv_data, u32 val)
@@ -651,6 +752,13 @@ static void pump_transfers(unsigned long data)
 		write_SSSR_CS(drv_data, drv_data->clear_sr);
 	}
 
+	if (is_lpss_ssp(drv_data)) {
+		if ((read_SSIRF(reg) & 0xff) != chip->lpss_rx_threshold)
+			write_SSIRF(chip->lpss_rx_threshold, reg);
+		if ((read_SSITF(reg) & 0xffff) != chip->lpss_tx_threshold)
+			write_SSITF(chip->lpss_tx_threshold, reg);
+	}
+
 	/* see if we need to reload the config registers */
 	if ((read_SSCR0(reg) != cr0)
 		|| (read_SSCR1(reg) & SSCR1_CHANGE_MASK) !=
@@ -763,8 +871,17 @@ static int setup(struct spi_device *spi)
 	struct chip_data *chip;
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
 	unsigned int clk_div;
-	uint tx_thres = TX_THRESH_DFLT;
-	uint rx_thres = RX_THRESH_DFLT;
+	uint tx_thres, tx_hi_thres, rx_thres;
+
+	if (is_lpss_ssp(drv_data)) {
+		tx_thres = LPSS_TX_LOTHRESH_DFLT;
+		tx_hi_thres = LPSS_TX_HITHRESH_DFLT;
+		rx_thres = LPSS_RX_THRESH_DFLT;
+	} else {
+		tx_thres = TX_THRESH_DFLT;
+		tx_hi_thres = 0;
+		rx_thres = RX_THRESH_DFLT;
+	}
 
 	if (!pxa25x_ssp_comp(drv_data)
 		&& (spi->bits_per_word < 4 || spi->bits_per_word > 32)) {
@@ -817,6 +934,8 @@ static int setup(struct spi_device *spi)
 			chip->timeout = chip_info->timeout;
 		if (chip_info->tx_threshold)
 			tx_thres = chip_info->tx_threshold;
+		if (chip_info->tx_hi_threshold)
+			tx_hi_thres = chip_info->tx_hi_threshold;
 		if (chip_info->rx_threshold)
 			rx_thres = chip_info->rx_threshold;
 		chip->enable_dma = drv_data->master_info->enable_dma;
@@ -828,6 +947,10 @@ static int setup(struct spi_device *spi)
 	chip->threshold = (SSCR1_RxTresh(rx_thres) & SSCR1_RFT) |
 			(SSCR1_TxTresh(tx_thres) & SSCR1_TFT);
 
+	chip->lpss_rx_threshold = SSIRF_RxThresh(rx_thres);
+	chip->lpss_tx_threshold = SSITF_TxLoThresh(tx_thres)
+				| SSITF_TxHiThresh(tx_hi_thres);
+
 	/* set dma burst and threshold outside of chip_info path so that if
 	 * chip_info goes away after setting chip->enable_dma, the
 	 * burst and threshold can still respond to changes in bits_per_word */
@@ -1014,6 +1137,8 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 		write_SSTO(0, drv_data->ioaddr);
 	write_SSPSP(0, drv_data->ioaddr);
 
+	lpss_ssp_setup(drv_data);
+
 	tasklet_init(&drv_data->pump_transfers, pump_transfers,
 		     (unsigned long)drv_data);
 
diff --git a/drivers/spi/spi-pxa2xx.h b/drivers/spi/spi-pxa2xx.h
index 771af62..b445a77 100644
--- a/drivers/spi/spi-pxa2xx.h
+++ b/drivers/spi/spi-pxa2xx.h
@@ -86,6 +86,8 @@ struct driver_data {
 	int (*read)(struct driver_data *drv_data);
 	irqreturn_t (*transfer_handler)(struct driver_data *drv_data);
 	void (*cs_control)(u32 command);
+
+	void __iomem *lpss_base;
 };
 
 struct chip_data {
@@ -97,6 +99,8 @@ struct chip_data {
 	u32 dma_burst_size;
 	u32 threshold;
 	u32 dma_threshold;
+	u16 lpss_rx_threshold;
+	u16 lpss_tx_threshold;
 	u8 enable_dma;
 	u8 bits_per_word;
 	u32 speed_hz;
@@ -124,6 +128,8 @@ DEFINE_SSP_REG(SSITR, 0x0c)
 DEFINE_SSP_REG(SSDR, 0x10)
 DEFINE_SSP_REG(SSTO, 0x28)
 DEFINE_SSP_REG(SSPSP, 0x2c)
+DEFINE_SSP_REG(SSITF, SSITF)
+DEFINE_SSP_REG(SSIRF, SSIRF)
 
 #define START_STATE ((void *)0)
 #define RUNNING_STATE ((void *)1)
diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
index 065e7f6..467cc63 100644
--- a/include/linux/pxa2xx_ssp.h
+++ b/include/linux/pxa2xx_ssp.h
@@ -155,6 +155,14 @@
 #define SSACD_ACDS(x)		((x) << 0)	/* Audio clock divider select */
 #define SSACD_SCDX8		(1 << 7)	/* SYSCLK division ratio select */
 
+/* LPSS SSP */
+#define SSITF			0x44		/* TX FIFO trigger level */
+#define SSITF_TxLoThresh(x)	(((x) - 1) << 8)
+#define SSITF_TxHiThresh(x)	((x) - 1)
+
+#define SSIRF			0x48		/* RX FIFO trigger level */
+#define SSIRF_RxThresh(x)	((x) - 1)
+
 enum pxa_ssp_type {
 	SSP_UNDEFINED = 0,
 	PXA25x_SSP,  /* pxa 210, 250, 255, 26x */
@@ -164,6 +172,7 @@ enum pxa_ssp_type {
 	PXA168_SSP,
 	PXA910_SSP,
 	CE4100_SSP,
+	LPSS_SSP,
 };
 
 struct ssp_device {
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index e5cbbc4..82d5111 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -44,6 +44,7 @@ struct pxa2xx_spi_master {
  */
 struct pxa2xx_spi_chip {
 	u8 tx_threshold;
+	u8 tx_hi_threshold;
 	u8 rx_threshold;
 	u8 dma_burst_size;
 	u32 timeout;
-- 
1.7.10.4

