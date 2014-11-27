Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaK0LoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:44:18 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:50101 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaK0LoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:44:14 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, broonie@kernel.org,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 1/4] spi: Add new driver for STMicroelectronics' SPI Controller
Date: Thu, 27 Nov 2014 11:43:53 +0000
Message-Id: <1417088636-11994-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the SPI portion of ST's SSC device.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/spi/Kconfig  |   8 +
 drivers/spi/Makefile |   1 +
 drivers/spi/spi-st.c | 535 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 544 insertions(+)
 create mode 100644 drivers/spi/spi-st.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 84e7c9e..78793a9 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -488,6 +488,14 @@ config SPI_SIRF
 	help
 	  SPI driver for CSR SiRFprimaII SoCs
 
+config SPI_ST
+	tristate "STMicroelectronics SPI SSC-based driver"
+	depends on ARCH_STI
+	select SPI_BITBANG
+	help
+	  STMicroelectronics SoCs support for SPI. If you say yes to
+	  this option, support will be included for the SSC driven SPI.
+
 config SPI_SUN4I
 	tristate "Allwinner A10 SoCs SPI controller"
 	depends on ARCH_SUNXI || COMPILE_TEST
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 78f24ca..3a2535c 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_SPI_SH_HSPI)		+= spi-sh-hspi.o
 obj-$(CONFIG_SPI_SH_MSIOF)		+= spi-sh-msiof.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi-sh-sci.o
 obj-$(CONFIG_SPI_SIRF)		+= spi-sirf.o
+obj-$(CONFIG_SPI_ST)			+= spi-st.o
 obj-$(CONFIG_SPI_SUN4I)			+= spi-sun4i.o
 obj-$(CONFIG_SPI_SUN6I)			+= spi-sun6i.o
 obj-$(CONFIG_SPI_TEGRA114)		+= spi-tegra114.o
diff --git a/drivers/spi/spi-st.c b/drivers/spi/spi-st.c
new file mode 100644
index 0000000..3355e35
--- /dev/null
+++ b/drivers/spi/spi-st.c
@@ -0,0 +1,535 @@
+/*
+ *  Copyright (c) 2008-2014 STMicroelectronics Limited
+ *
+ *  Author: Angus Clark <Angus.Clark@st.com>
+ *  Author: Patrice Chotard <patrice.chotard@st.com>
+ *
+ *  SPI master mode controller driver, used in STMicroelectronics devices.
+ *
+ *  May be copied or modified under the terms of the GNU General Public
+ *  License Version 2.0 only.  See linux/COPYING for more information.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+
+/* SSC registers */
+#define SSC_BRG				0x000
+#define SSC_TBUF			0x004
+#define SSC_RBUF			0x008
+#define SSC_CTL				0x00C
+#define SSC_IEN				0x010
+#define SSC_I2C				0x018
+
+/* SSC Control */
+#define SSC_CTL_DATA_WIDTH_9		0x8
+#define SSC_CTL_DATA_WIDTH_MSK		0xf
+#define SSC_CTL_BM			0xf
+#define SSC_CTL_HB			BIT(4)
+#define SSC_CTL_PH			BIT(5)
+#define SSC_CTL_PO			BIT(6)
+#define SSC_CTL_SR			BIT(7)
+#define SSC_CTL_MS			BIT(8)
+#define SSC_CTL_EN			BIT(9)
+#define SSC_CTL_LPB			BIT(10)
+#define SSC_CTL_EN_TX_FIFO		BIT(11)
+#define SSC_CTL_EN_RX_FIFO		BIT(12)
+#define SSC_CTL_EN_CLST_RX		BIT(13)
+
+/* SSC Interrupt Enable */
+#define SSC_IEN_TEEN			BIT(2)
+
+#define FIFO_SIZE			8
+
+struct spi_st {
+	/* SSC SPI Controller */
+	struct spi_bitbang	bitbang;
+	void __iomem		*base;
+	struct clk		*clk;
+	struct device		*dev;
+	int			irq;
+
+	/* SSC SPI current transaction */
+	const u8		*tx_ptr;
+	u8			*rx_ptr;
+	u16			bits_per_word;
+	u16			bytes_per_word;
+	unsigned int		baud;
+	unsigned int		words_remaining;
+	struct completion	done;
+	struct pinctrl_state	*pins_sleep;
+};
+
+static void spi_st_gpio_chipselect(struct spi_device *spi, int is_active)
+{
+	int cs = spi->cs_gpio;
+	int out;
+
+	if (cs == -ENOENT)
+		return;
+
+	out = (spi->mode & SPI_CS_HIGH) ? is_active : !is_active;
+	gpio_set_value(cs, out);
+
+	dev_dbg(&spi->dev, "%s GPIO %u -> %d\n",
+		is_active ? "select" : "deselect", cs, out);
+
+	return;
+}
+
+static int spi_st_setup_transfer(struct spi_device *spi,
+				 struct spi_transfer *t)
+{
+	struct spi_st *spi_st = spi_master_get_devdata(spi->master);
+	u32 spi_st_clk, sscbrg, var, hz;
+	u8 bits_per_word;
+
+	bits_per_word 	= t ? t->bits_per_word	: spi->bits_per_word;
+	hz		= t ? t->speed_hz	: spi->max_speed_hz;
+
+	/* Actually, can probably support 2-16 without any other changees */
+	if (bits_per_word != 8 && bits_per_word != 16) {
+		dev_err(&spi->dev, "unsupported bits_per_word %d\n",
+			bits_per_word);
+		return -EINVAL;
+	}
+	spi_st->bits_per_word = bits_per_word;
+
+	spi_st_clk = clk_get_rate(spi_st->clk);
+
+	/* Set SSC_BRF */
+	sscbrg = spi_st_clk / (2 * hz);
+	if (sscbrg < 0x07 || sscbrg > (0x1 << 16)) {
+		dev_err(&spi->dev,
+			"baudrate %d outside valid range %d\n", sscbrg, hz);
+		return -EINVAL;
+	}
+
+	spi_st->baud = spi_st_clk / (2 * sscbrg);
+	if (sscbrg == (0x1 << 16)) /* 16-bit counter wraps */
+		sscbrg = 0x0;
+
+	writel_relaxed(sscbrg, spi_st->base + SSC_BRG);
+
+	dev_dbg(&spi->dev,
+		"setting baudrate:target= %u hz, actual= %u hz, sscbrg= %u\n",
+		hz, spi_st->baud, sscbrg);
+
+	 /* Set SSC_CTL and enable SSC */
+	 var = readl_relaxed(spi_st->base + SSC_CTL);
+	 var |= SSC_CTL_MS;
+
+	 if (spi->mode & SPI_CPOL)
+		var |= SSC_CTL_PO;
+	 else
+		var &= ~SSC_CTL_PO;
+
+	 if (spi->mode & SPI_CPHA)
+		var |= SSC_CTL_PH;
+	 else
+		var &= ~SSC_CTL_PH;
+
+	 if ((spi->mode & SPI_LSB_FIRST) == 0)
+		var |= SSC_CTL_HB;
+	 else
+		var &= ~SSC_CTL_HB;
+
+	 if (spi->mode & SPI_LOOP)
+		var |= SSC_CTL_LPB;
+	 else
+		var &= ~SSC_CTL_LPB;
+
+	 var &= ~SSC_CTL_DATA_WIDTH_MSK;
+	 var |= (bits_per_word - 1);
+
+	 var |= SSC_CTL_EN_TX_FIFO | SSC_CTL_EN_RX_FIFO;
+	 var |= SSC_CTL_EN;
+
+	 writel_relaxed(var, spi_st->base + SSC_CTL);
+
+	 /* Clear the status register */
+	 readl_relaxed(spi_st->base + SSC_RBUF);
+
+	 return 0;
+}
+
+static void spi_st_cleanup(struct spi_device *spi)
+{
+	int cs = spi->cs_gpio;
+	
+	if (cs != -ENOENT)
+		gpio_free(cs);
+}
+
+/* the spi->mode bits understood by this driver: */
+#define MODEBITS  (SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST | SPI_LOOP | SPI_CS_HIGH)
+static int spi_st_setup(struct spi_device *spi)
+{
+	int cs = spi->cs_gpio;
+	int ret;
+
+	if (spi->mode & ~MODEBITS) {
+		dev_err(&spi->dev, "unsupported mode bits 0x%x\n",
+			spi->mode & ~MODEBITS);
+		return -EINVAL;
+	}
+
+	if (!spi->max_speed_hz)  {
+		dev_err(&spi->dev, "max_speed_hz unspecified\n");
+		return -EINVAL;
+	}
+
+	if (!spi->bits_per_word)
+		spi->bits_per_word = 8;
+
+	if (cs != -ENOENT) {
+		ret = gpio_direction_output(cs, spi->mode & SPI_CS_HIGH);
+		if (ret)
+			return ret;
+	}
+
+	return spi_st_setup_transfer(spi, NULL);
+}
+
+/* Load the TX FIFO */
+static void ssc_write_tx_fifo(struct spi_st *spi_st)
+{
+	unsigned int count, i;
+	uint32_t word = 0;
+	
+	if (spi_st->words_remaining > FIFO_SIZE)
+		count = FIFO_SIZE;
+	else
+		count = spi_st->words_remaining;
+
+	for (i = 0; i < count; i++) {
+		if (spi_st->tx_ptr) {
+			if (spi_st->bytes_per_word == 1) {
+				word = *spi_st->tx_ptr++;
+			} else {
+				word = *spi_st->tx_ptr++;
+				word = *spi_st->tx_ptr++ | (word << 8);
+			}
+		}
+		writel_relaxed(word, spi_st->base + SSC_TBUF);
+	}
+}
+
+/* Read the RX FIFO */
+static void ssc_read_rx_fifo(struct spi_st *spi_st)
+{
+	unsigned int count, i;
+	uint32_t word = 0;
+
+	if (spi_st->words_remaining > FIFO_SIZE)
+		count = FIFO_SIZE;
+	else
+		count = spi_st->words_remaining;
+
+	for (i = 0; i < count; i++) {
+		word = readl_relaxed(spi_st->base + SSC_RBUF);
+		if (spi_st->rx_ptr) {
+			if (spi_st->bytes_per_word == 1) {
+				*spi_st->rx_ptr++ = (uint8_t)word;
+			} else {
+				*spi_st->rx_ptr++ = (word >> 8);
+				*spi_st->rx_ptr++ = word & 0xff;
+			}
+		}
+	}
+	spi_st->words_remaining -= count;
+}
+
+/* Interrupt fired when TX shift register becomes empty */
+static irqreturn_t spi_st_irq(int irq, void *dev_id)
+{
+	struct spi_st *spi_st = (struct spi_st *)dev_id;
+
+	/* Read RX FIFO */
+	ssc_read_rx_fifo(spi_st);
+
+	/* Fill TX FIFO */
+	if (spi_st->words_remaining) {
+		ssc_write_tx_fifo(spi_st);
+	} else {
+		/* TX/RX complete */
+		writel_relaxed(0x0, spi_st->base + SSC_IEN);
+		/*
+		 * read SSC_IEN to ensure that this bit is set
+		 * before re-enabling interrupt
+		 */
+		readl(spi_st->base + SSC_IEN);
+		complete(&spi_st->done);
+	}
+
+	return IRQ_HANDLED;
+}
+
+
+static int spi_st_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct spi_st *spi_st = spi_master_get_devdata(spi->master);
+	uint32_t ctl = 0;
+
+	pm_runtime_get_sync(spi_st->dev);
+
+	/* Setup transfer */
+	spi_st->tx_ptr = t->tx_buf;
+	spi_st->rx_ptr = t->rx_buf;
+
+	if (spi_st->bits_per_word > 8) {
+		/*
+		 * Anything greater than 8 bits-per-word requires 2
+		 * bytes-per-word in the RX/TX buffers
+		 */
+		spi_st->bytes_per_word = 2;
+		spi_st->words_remaining = t->len / 2;
+
+	} else if (spi_st->bits_per_word == 8 && !(t->len & 0x1)) {
+		/*
+		 * If transfer is even-length, and 8 bits-per-word, then
+		 * implement as half-length 16 bits-per-word transfer
+		 */
+		spi_st->bytes_per_word = 2;
+		spi_st->words_remaining = t->len/2;
+
+		/* Set SSC_CTL to 16 bits-per-word */
+		ctl = readl_relaxed(spi_st->base + SSC_CTL);
+		writel_relaxed((ctl | 0xf), spi_st->base + SSC_CTL);
+
+		readl_relaxed(spi_st->base + SSC_RBUF);
+
+	} else {
+		spi_st->bytes_per_word = 1;
+		spi_st->words_remaining = t->len;
+	}
+
+	init_completion(&spi_st->done);
+
+	/* Start transfer by writing to the TX FIFO */
+	ssc_write_tx_fifo(spi_st);
+	writel_relaxed(SSC_IEN_TEEN, spi_st->base + SSC_IEN);
+
+	/* Wait for transfer to complete */
+	wait_for_completion(&spi_st->done);
+
+	/* Restore SSC_CTL if necessary */
+	if (ctl)
+		writel_relaxed(ctl, spi_st->base + SSC_CTL);
+
+	pm_runtime_put(spi_st->dev);
+
+	return t->len;
+}
+
+static int spi_st_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct spi_master *master;
+	struct resource *res;
+	struct spi_st *spi_st;
+	int num_cs, cs_gpio, i, ret = 0;
+	u32 var;
+	
+	printk("LEE: %s: %s()[%d]: Probing\n", __FILE__, __func__, __LINE__);
+
+	master = spi_alloc_master(&pdev->dev, sizeof(*spi_st));
+	if (!master) {
+		dev_err(&pdev->dev, "failed to allocate spi master\n");
+		return -ENOMEM;
+	}
+	spi_st = spi_master_get_devdata(master);
+
+	if (!IS_ERR(dev->pins->p)) {
+		spi_st->pins_sleep =
+			pinctrl_lookup_state(dev->pins->p, PINCTRL_STATE_SLEEP);
+		if (IS_ERR(spi_st->pins_sleep))
+			dev_warn(&pdev->dev, "could not get sleep pinstate\n");
+	}
+
+	num_cs = of_gpio_named_count(np, "cs-gpios");
+
+	for (i = 0; i < num_cs; i++) {
+		cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
+
+		if (!gpio_is_valid(cs_gpio)) {
+			dev_err(&pdev->dev,
+				"%d is not a valid gpio\n", cs_gpio);
+			return -EINVAL;
+		}
+			
+		if (devm_gpio_request(&pdev->dev, cs_gpio, pdev->name)) {
+			dev_err(&pdev->dev,
+				"could not request %d gpio\n", cs_gpio);
+			return -EINVAL;
+		}
+	}
+
+	spi_st->clk = of_clk_get_by_name(np, "ssc");
+	if (IS_ERR(spi_st->clk)) {
+		dev_err(&pdev->dev, "Unable to request clock\n");
+		ret = PTR_ERR(spi_st->clk);
+		goto free_master;
+	}
+
+	ret = clk_prepare_enable(spi_st->clk);
+	if (ret)
+		goto free_master;
+
+	master->dev.of_node		= np;
+	master->bus_num			= pdev->id;
+	master->mode_bits		= MODEBITS;
+	spi_st->bitbang.master		= spi_master_get(master);
+	spi_st->bitbang.setup_transfer	= spi_st_setup_transfer;
+	spi_st->bitbang.txrx_bufs	= spi_st_txrx_bufs;
+	spi_st->bitbang.master->setup	= spi_st_setup;
+	spi_st->bitbang.master->cleanup	= spi_st_cleanup;
+	spi_st->bitbang.chipselect	= spi_st_gpio_chipselect;
+	spi_st->dev			= dev;
+
+	init_completion(&spi_st->done);
+
+	/* Get resources */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	spi_st->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(spi_st->base)) {
+		ret = PTR_ERR(spi_st->base);
+		goto clk_disable;
+	}
+
+	spi_st->irq = irq_of_parse_and_map(np, 0);
+	if (!spi_st->irq) {
+		dev_err(&pdev->dev, "IRQ missing or invalid\n");
+		ret = -EINVAL;
+		goto clk_disable;
+	}
+
+	ret = devm_request_irq(&pdev->dev, spi_st->irq, spi_st_irq, 0,
+			       pdev->name, spi_st);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request irq %d\n", spi_st->irq);
+		goto clk_disable;
+	}
+
+	/* Disable I2C and Reset SSC */
+	writel_relaxed(0x0, spi_st->base + SSC_I2C);
+	var = readw(spi_st->base + SSC_CTL);
+	var |= SSC_CTL_SR;
+	writel_relaxed(var, spi_st->base + SSC_CTL);
+
+	udelay(1);
+	var = readl_relaxed(spi_st->base + SSC_CTL);
+	var &= ~SSC_CTL_SR;
+	writel_relaxed(var, spi_st->base + SSC_CTL);
+
+	/* Set SSC into slave mode before reconfiguring PIO pins */
+	var = readl_relaxed(spi_st->base + SSC_CTL);
+	var &= ~SSC_CTL_MS;
+	writel_relaxed(var, spi_st->base + SSC_CTL);
+
+	/* Start "bitbang" worker */
+	ret = spi_bitbang_start(&spi_st->bitbang);
+	if (ret) {
+		dev_err(&pdev->dev, "bitbang start failed [%d]\n", ret);
+		goto clk_disable;
+	}
+
+	dev_info(&pdev->dev, "registered SPI Bus %d\n", master->bus_num);
+
+	platform_set_drvdata(pdev, master);
+
+	/* by default the device is on */
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	return 0;
+
+clk_disable:
+	clk_disable_unprepare(spi_st->clk);
+free_master:
+	spi_master_put(master);
+
+	return ret;
+}
+
+static int spi_st_remove(struct platform_device *pdev)
+{
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct spi_st *spi_st = spi_master_get_devdata(master);
+
+	spi_bitbang_stop(&spi_st->bitbang);
+	clk_disable_unprepare(spi_st->clk);
+
+	if (spi_st->pins_sleep)
+		pinctrl_select_state(pdev->dev.pins->p, spi_st->pins_sleep);
+
+	spi_master_put(spi_st->bitbang.master);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int spi_st_suspend(struct device *dev)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct spi_st *spi_st = spi_master_get_devdata(master);
+
+	writel_relaxed(0, spi_st->base + SSC_IEN);
+
+	if (!IS_ERR(spi_st->pins_sleep))
+		pinctrl_select_state(dev->pins->p, spi_st->pins_sleep);
+
+	clk_disable_unprepare(spi_st->clk);
+
+	return 0;
+}
+
+static int spi_st_resume(struct device *dev)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct spi_st *spi_st = spi_master_get_devdata(master);
+	int ret;
+
+	ret = clk_prepare_enable(spi_st->clk);
+
+	if (!IS_ERR(dev->pins->default_state))
+		pinctrl_select_state(dev->pins->p, dev->pins->default_state);
+
+	return ret;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(spi_st_pm, spi_st_suspend, spi_st_resume);
+
+static struct of_device_id stm_spi_match[] = {
+	{ .compatible = "st,comms-ssc-spi", },
+	{ .compatible = "st,comms-ssc4-spi", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, stm_spi_match);
+
+static struct platform_driver spi_st_driver = {
+	.driver = {
+		.name = "spi-st",
+		.pm = &spi_st_pm,
+		.of_match_table = of_match_ptr(stm_spi_match),
+	},
+	.probe = spi_st_probe,
+	.remove = spi_st_remove,
+};
+module_platform_driver(spi_st_driver);
+
+MODULE_AUTHOR("Patrice Chotard <patrice.chotard@st.com>");
+MODULE_DESCRIPTION("STM SSC SPI driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

