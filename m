Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaAPRQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:16:03 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51895 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753090AbaAPRPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:15:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/4] spi: sunxi: Add Allwinner A31 SPI controller driver
Date: Thu, 16 Jan 2014 18:11:24 +0100
Message-Id: <1389892285-11745-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A31 has a new SPI controller IP compared to the older Allwinner
SoCs.

It supports DMA, but the driver only does PIO for now, and DMA will be
supported eventually.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../devicetree/bindings/spi/spi-sun6i.txt          |  23 +
 drivers/spi/Makefile                               |   1 +
 drivers/spi/spi-sun6i.c                            | 463 +++++++++++++++++++++
 3 files changed, 487 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-sun6i.txt
 create mode 100644 drivers/spi/spi-sun6i.c

diff --git a/Documentation/devicetree/bindings/spi/spi-sun6i.txt b/Documentation/devicetree/bindings/spi/spi-sun6i.txt
new file mode 100644
index 0000000..019a05f
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-sun6i.txt
@@ -0,0 +1,23 @@
+Allwinner A31 SPI controller
+
+Required properties:
+- compatible: Should be "allwinner,sun6i-a31-spi".
+- reg: Should contain register location and length.
+- interrupts: Should contain interrupt.
+- clocks: phandle to the clocks feeding the SPI controller. Two are
+          needed:
+  - "ahb": the gated AHB parent clock
+  - "mod": the parent module clock
+- resets: phandle to the reset controller asserting this device in
+          reset
+
+Example:
+
+spi1: spi@01c69000 {
+	compatible = "allwinner,sun6i-a31-spi";
+	reg = <0x01c69000 0x1000>;
+	interrupts = <0 66 4>;
+	clocks = <&ahb1_gates 21>, <&spi1_clk>;
+	clock-names = "ahb", "mod";
+	resets = <&ahb1_rst 21>;
+};
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index ab8d864..b94f43d 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_SPI_SH_HSPI)		+= spi-sh-hspi.o
 obj-$(CONFIG_SPI_SH_MSIOF)		+= spi-sh-msiof.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi-sh-sci.o
 obj-$(CONFIG_SPI_SIRF)		+= spi-sirf.o
+obj-$(CONFIG_ARCH_SUNXI)		+= spi-sun6i.o
 obj-$(CONFIG_SPI_TEGRA114)		+= spi-tegra114.o
 obj-$(CONFIG_SPI_TEGRA20_SFLASH)	+= spi-tegra20-sflash.o
 obj-$(CONFIG_SPI_TEGRA20_SLINK)		+= spi-tegra20-slink.o
diff --git a/drivers/spi/spi-sun6i.c b/drivers/spi/spi-sun6i.c
new file mode 100644
index 0000000..92f0343
--- /dev/null
+++ b/drivers/spi/spi-sun6i.c
@@ -0,0 +1,463 @@
+/*
+ * Copyright (C) 2012 - 2014 Allwinner Tech
+ * Pan Nan <pannan@allwinnertech.com>
+ *
+ * Copyright (C) 2014 Maxime Ripard
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+#include <linux/workqueue.h>
+
+#include <linux/spi/spi.h>
+
+#define SUN6I_FIFO_DEPTH		128
+
+#define SUN6I_GBL_CTL_REG		0x04
+#define SUN6I_GBL_CTL_BUS_ENABLE		BIT(0)
+#define SUN6I_GBL_CTL_MASTER			BIT(1)
+#define SUN6I_GBL_CTL_TP			BIT(7)
+#define SUN6I_GBL_CTL_RST			BIT(31)
+
+#define SUN6I_TFR_CTL_REG		0x08
+#define SUN6I_TFR_CTL_CPHA			BIT(0)
+#define SUN6I_TFR_CTL_CPOL			BIT(1)
+#define SUN6I_TFR_CTL_SPOL			BIT(2)
+#define SUN6I_TFR_CTL_CS_MASK			0x3
+#define SUN6I_TFR_CTL_CS(cs)			(((cs) & SUN6I_TFR_CTL_CS_MASK) << 4)
+#define SUN6I_TFR_CTL_FBS			BIT(12)
+#define SUN6I_TFR_CTL_XCH			BIT(31)
+
+#define SUN6I_INT_CTL_REG		0x10
+#define SUN6I_INT_CTL_RF_OVF			BIT(8)
+#define SUN6I_INT_CTL_TC			BIT(12)
+
+#define SUN6I_INT_STA_REG		0x14
+
+#define SUN6I_FIFO_CTL_REG		0x18
+#define SUN6I_FIFO_CTL_RF_RST			BIT(15)
+#define SUN6I_FIFO_CTL_TF_RST			BIT(31)
+
+#define SUN6I_FIFO_STA_REG		0x1c
+#define SUN6I_FIFO_STA_RF_CNT_MASK		0x7f
+#define SUN6I_FIFO_STA_RF_CNT_BITS		0
+#define SUN6I_FIFO_STA_TF_CNT_MASK		0x7f
+#define SUN6I_FIFO_STA_TF_CNT_BITS		16
+
+#define SUN6I_CLK_CTL_REG		0x24
+#define SUN6I_CLK_CTL_CDR2_MASK			0xff
+#define SUN6I_CLK_CTL_CDR2(div)			(((div) & SUN6I_CLK_CTL_CDR2_MASK) << 0)
+#define SUN6I_CLK_CTL_CDR1_MASK			0xf
+#define SUN6I_CLK_CTL_CDR1(div)			(((div) & SUN6I_CLK_CTL_CDR1_MASK) << 8)
+#define SUN6I_CLK_CTL_DRS			BIT(12)
+
+#define SUN6I_BURST_CNT_REG		0x30
+#define SUN6I_BURST_CNT(cnt)			((cnt) & 0xffffff)
+
+#define SUN6I_XMIT_CNT_REG		0x34
+#define SUN6I_XMIT_CNT(cnt)			((cnt) & 0xffffff)
+
+#define SUN6I_BURST_CTL_CNT_REG		0x38
+#define SUN6I_BURST_CTL_CNT_STC(cnt)		((cnt) & 0xffffff)
+
+#define SUN6I_TXDATA_REG		0x200
+#define SUN6I_RXDATA_REG		0x300
+
+struct sun6i_spi {
+	struct spi_master	*master;
+	void __iomem		*base_addr;
+	struct clk		*hclk;
+	struct clk		*mclk;
+	struct reset_control	*rstc;
+
+	struct completion	done;
+
+	const u8		*tx_buf;
+	u8			*rx_buf;
+	int			len;
+};
+
+static inline u32 sun6i_spi_read(struct sun6i_spi *sspi, u32 reg)
+{
+	return readl(sspi->base_addr + reg);
+}
+
+static inline void sun6i_spi_write(struct sun6i_spi *sspi, u32 reg, u32 value)
+{
+	writel(value, sspi->base_addr + reg);
+}
+
+static inline void sun6i_spi_drain_fifo(struct sun6i_spi *sspi, int len)
+{
+	u32 reg, cnt;
+	u8 byte;
+
+	/* See how much data are available */
+	reg = sun6i_spi_read(sspi, SUN6I_FIFO_STA_REG);
+	reg &= SUN6I_FIFO_STA_RF_CNT_MASK;
+	cnt = reg >> SUN6I_FIFO_STA_RF_CNT_BITS;
+
+	if (len > cnt)
+		len = cnt;
+
+	while (len--) {
+		byte = readb(sspi->base_addr + SUN6I_RXDATA_REG);
+		if (sspi->rx_buf)
+			*sspi->rx_buf++ = byte;
+	}
+}
+
+static inline void sun6i_spi_fill_fifo(struct sun6i_spi *sspi, int len)
+{
+	u8 byte;
+
+	if (len > sspi->len)
+		len = sspi->len;
+
+	while (len--) {
+		byte = sspi->tx_buf ? *sspi->tx_buf++ : 0;
+		writeb(byte, sspi->base_addr + SUN6I_TXDATA_REG);
+		sspi->len--;
+	}
+}
+
+static int sun6i_spi_start_transfer(struct spi_device *spi,
+				    struct spi_transfer *tfr)
+{
+	struct sun6i_spi *sspi = spi_master_get_devdata(spi->master);
+	unsigned int bursts = 0, tx_len = 0;
+	unsigned int mclk_rate, div;
+	u32 reg;
+
+	reinit_completion(&sspi->done);
+	sspi->tx_buf = tfr->tx_buf;
+	sspi->rx_buf = tfr->rx_buf;
+	sspi->len = tfr->len;
+
+	/* Clear pending interrupts */
+	sun6i_spi_write(sspi, SUN6I_INT_STA_REG, ~0);
+
+	/* Reset FIFO */
+	sun6i_spi_write(sspi, SUN6I_FIFO_CTL_REG,
+			SUN6I_FIFO_CTL_RF_RST | SUN6I_FIFO_CTL_TF_RST);
+
+	/*
+	 * Setup the transfer control register: Chip Select,
+	 * polarities, etc.
+	 */
+	reg = SUN6I_TFR_CTL_CS(spi->chip_select);
+
+	if (spi->mode & SPI_CPOL)
+		reg |= SUN6I_TFR_CTL_CPOL;
+
+	if (spi->mode & SPI_CPHA)
+		reg |= SUN6I_TFR_CTL_CPHA;
+
+	if (!(spi->mode & SPI_CS_HIGH))
+		reg |= SUN6I_TFR_CTL_SPOL;
+
+	if (spi->mode & SPI_LSB_FIRST)
+		reg |= SUN6I_TFR_CTL_FBS;
+
+	sun6i_spi_write(sspi, SUN6I_TFR_CTL_REG, reg);
+
+	/*
+	 * Setup clock divider.
+	 *
+	 * We have two choices there. Either we can use the clock
+	 * divide rate 1, which is calculated thanks to this formula:
+	 * SPI_CLK = MOD_CLK / (2 ^ cdr)
+	 * Or we can use CDR2, which is calculated with the formula:
+	 * SPI_CLK = MOD_CLK / (2 * (cdr + 1))
+	 * Wether we use the former or the latter is set through the
+	 * DRS bit.
+	 *
+	 * First try CDR2, and if we can't reach the expected
+	 * frequency, fall back to CDR1.
+	 */
+	mclk_rate = clk_get_rate(sspi->mclk);
+	div = mclk_rate / (spi->max_speed_hz << 1);
+
+	if (div <= (SUN6I_CLK_CTL_CDR2_MASK + 1)) {
+		if (div > 0)
+			div--;
+
+		reg = SUN6I_CLK_CTL_CDR2(div) | SUN6I_CLK_CTL_DRS;
+	} else {
+		div = ilog2(mclk_rate) - ilog2(spi->max_speed_hz);
+		reg = SUN6I_CLK_CTL_CDR1(div);
+	}
+
+	sun6i_spi_write(sspi, SUN6I_CLK_CTL_REG, reg);
+
+	/* Setup the transfer now... */
+	if (sspi->rx_buf && sspi->tx_buf) {
+		bursts = tfr->len + 1;
+		tx_len = tfr->len;
+	} else if (sspi->tx_buf) {
+		bursts = tfr->len;
+		tx_len = tfr->len;
+	} else if (sspi->rx_buf) {
+		bursts = tfr->len;
+	}
+
+	/* Setup the counters */
+	sun6i_spi_write(sspi, SUN6I_BURST_CNT_REG, SUN6I_BURST_CNT(bursts));
+	sun6i_spi_write(sspi, SUN6I_XMIT_CNT_REG, SUN6I_XMIT_CNT(tx_len));
+	sun6i_spi_write(sspi, SUN6I_BURST_CTL_CNT_REG,
+			SUN6I_BURST_CTL_CNT_STC(tx_len));
+
+	/* Fill the TX FIFO */
+	sun6i_spi_fill_fifo(sspi, SUN6I_FIFO_DEPTH);
+
+	/* Enable the interrupts */
+	sun6i_spi_write(sspi, SUN6I_INT_CTL_REG,
+			SUN6I_INT_CTL_TC | SUN6I_INT_CTL_RF_OVF);
+
+	/* Start the transfer */
+	reg = sun6i_spi_read(sspi, SUN6I_TFR_CTL_REG);
+	sun6i_spi_write(sspi, SUN6I_TFR_CTL_REG, reg | SUN6I_TFR_CTL_XCH);
+
+	return 0;
+}
+
+static int sun6i_spi_finish_transfer(struct spi_device *spi,
+				     struct spi_transfer *tfr,
+				     bool cs_change)
+{
+	struct sun6i_spi *sspi = spi_master_get_devdata(spi->master);
+
+	sun6i_spi_drain_fifo(sspi, SUN6I_FIFO_DEPTH);
+
+	if (tfr->delay_usecs)
+		udelay(tfr->delay_usecs);
+
+	return 0;
+}
+
+static int sun6i_spi_transfer_one(struct spi_master *master,
+				  struct spi_message *mesg)
+{
+	struct sun6i_spi *sspi = spi_master_get_devdata(master);
+	struct spi_device *spi = mesg->spi;
+	struct spi_transfer *tfr;
+	unsigned int timeout;
+	int cs_change, err;
+	u32 reg;
+
+	list_for_each_entry(tfr, &mesg->transfers, transfer_list) {
+		err = sun6i_spi_start_transfer(spi, tfr);
+		if (err)
+			goto out;
+
+		timeout = wait_for_completion_timeout(&sspi->done,
+						      msecs_to_jiffies(1000));
+		if (!timeout) {
+			err = -ETIMEDOUT;
+			goto out;
+		}
+
+		cs_change = tfr->cs_change ||
+			list_is_last(&tfr->transfer_list, &mesg->transfers);
+
+		err = sun6i_spi_finish_transfer(spi, tfr, cs_change);
+		if (err)
+			goto out;
+
+		mesg->actual_length += tfr->len;
+	}
+
+out:
+	reg = sun6i_spi_read(sspi, SUN6I_INT_CTL_REG);
+	sun6i_spi_write(sspi, SUN6I_INT_CTL_REG, reg & ~SUN6I_INT_CTL_TC);
+
+	mesg->status = err;
+	spi_finalize_current_message(master);
+	return 0;
+}
+
+/* wake up the sleep thread, and give the result code */
+static irqreturn_t sun6i_spi_handler(int irq, void *dev_id)
+{
+	struct sun6i_spi *sspi = dev_id;
+	u32 status = sun6i_spi_read(sspi, SUN6I_INT_STA_REG);
+
+	/* Transfer complete */
+	if (status & SUN6I_INT_CTL_TC) {
+		sun6i_spi_write(sspi, SUN6I_INT_STA_REG, SUN6I_INT_CTL_TC);
+		complete(&sspi->done);
+		return IRQ_HANDLED;
+	}
+
+	if (status & SUN6I_INT_CTL_RF_OVF) {
+		sun6i_spi_drain_fifo(sspi, SUN6I_FIFO_DEPTH);
+		sun6i_spi_write(sspi, SUN6I_INT_STA_REG, SUN6I_INT_CTL_RF_OVF);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static int sun6i_spi_probe(struct platform_device *pdev)
+{
+	struct spi_master *master;
+	struct sun6i_spi *sspi;
+	struct resource	*res;
+	int ret = 0, irq;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct sun6i_spi));
+	if (!master) {
+		dev_err(&pdev->dev, "Unable to allocate SPI Master\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, master);
+	sspi = spi_master_get_devdata(master);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	sspi->base_addr = devm_request_and_ioremap(&pdev->dev, res);
+	if (!sspi->base_addr) {
+		dev_err(&pdev->dev, "Unable to remap IO\n");
+		ret = -ENXIO;
+		goto err;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "No spi IRQ specified\n");
+		ret = -ENXIO;
+		goto err;
+	}
+
+	ret = devm_request_irq(&pdev->dev, irq, sun6i_spi_handler,
+			       0, "sun6i-spi", sspi);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot request IRQ\n");
+		goto err;
+	}
+
+	sspi->master = master;
+	master->bus_num	= -1;
+	master->transfer_one_message = sun6i_spi_transfer_one;
+	master->num_chipselect = 4;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST;
+	master->dev.of_node = pdev->dev.of_node;
+
+	/* Setup clocks */
+	sspi->hclk = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(sspi->hclk)) {
+		dev_err(&pdev->dev, "Unable to acquire AHB clock\n");
+		ret = PTR_ERR(sspi->hclk);
+		goto err;
+	}
+
+	ret = clk_prepare_enable(sspi->hclk);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't enable clock 'ahb spi'\n");
+		goto err;
+	}
+
+	sspi->mclk = devm_clk_get(&pdev->dev, "mod");
+	if (IS_ERR(sspi->mclk)) {
+		dev_err(&pdev->dev, "Unable to acquire module clock\n");
+		ret = PTR_ERR(sspi->mclk);
+		goto err2;
+	}
+
+	ret = clk_set_rate(sspi->mclk, 100000000);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't change module clock rate\n");
+		goto err2;
+	}
+
+	ret = clk_prepare_enable(sspi->mclk);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't enable clock 'ahb spi'\n");
+		goto err2;
+	}
+
+	init_completion(&sspi->done);
+
+	sspi->rstc = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(sspi->rstc)) {
+		dev_err(&pdev->dev, "Couldn't get reset controller\n");
+		ret = PTR_ERR(sspi->rstc);
+		goto err3;
+	}
+
+	ret = reset_control_deassert(sspi->rstc);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't deassert the device from reset\n");
+		goto err3;
+	}
+
+	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG,
+			SUN6I_GBL_CTL_BUS_ENABLE | SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
+
+	ret = spi_register_master(master);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot register SPI master\n");
+		goto err4;
+	}
+
+	return 0;
+
+err4:
+	reset_control_assert(sspi->rstc);
+err3:
+	clk_disable_unprepare(sspi->mclk);
+err2:
+	clk_disable_unprepare(sspi->hclk);
+err:
+	spi_master_put(master);
+
+	return ret;
+}
+
+static int sun6i_spi_remove(struct platform_device *pdev)
+{
+	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
+	struct sun6i_spi *sspi = spi_master_get_devdata(master);
+
+	spi_unregister_master(master);
+	reset_control_assert(sspi->rstc);
+	clk_disable_unprepare(sspi->mclk);
+	clk_disable_unprepare(sspi->hclk);
+	spi_master_put(master);
+
+	return 0;
+}
+
+static const struct of_device_id sun6i_spi_match[] = {
+	{ .compatible = "allwinner,sun6i-a31-spi", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sun6i_spi_match);
+
+static struct platform_driver sun6i_spi_driver = {
+	.probe	= sun6i_spi_probe,
+	.remove	= sun6i_spi_remove,
+	.driver	= {
+		.name		= "sun6i-spi",
+		.owner		= THIS_MODULE,
+		.of_match_table	= sun6i_spi_match,
+	},
+};
+module_platform_driver(sun6i_spi_driver);
+
+MODULE_AUTHOR("Pan Nan <pannan@allwinnertech.com>");
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com>");
+MODULE_DESCRIPTION("Allwinner A31 SPI controller driver");
+MODULE_LICENSE("GPL");
-- 
1.8.4.2

