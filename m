Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaKVPYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 10:24:30 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54798 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaKVPY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 10:24:26 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v3 3/4] spi: meson: Add support for Amlogic Meson SPIFC
Date: Sat, 22 Nov 2014 16:21:41 +0100
Message-Id: <1416669702-7841-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416669702-7841-1-git-send-email-b.galvani@gmail.com>
References: <1416669702-7841-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the Amlogic Meson SPIFC (SPI flash controller),
which is one of the two SPI controllers available on the SoC. It
doesn't support DMA and has a 64-byte unified transmit/receive buffer.

The device is optimized for interfacing with SPI NOR memories and
allows the execution of standard operations such as read, page
program, sector erase, etc. in a simplified way, toggling a bit in a
dedicated register. The driver doesn't use those predefined commands
and relies only on custom transfers.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/spi/Kconfig           |   7 +
 drivers/spi/Makefile          |   1 +
 drivers/spi/spi-meson-spifc.c | 462 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 470 insertions(+)
 create mode 100644 drivers/spi/spi-meson-spifc.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 98de207..0373c37 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -308,6 +308,13 @@ config SPI_FSL_ESPI
 	  From MPC8536, 85xx platform uses the controller, and all P10xx,
 	  P20xx, P30xx,P40xx, P50xx uses this controller.
 
+config SPI_MESON_SPIFC
+	tristate "Amlogic Meson SPIFC controller"
+	depends on ARCH_MESON || COMPILE_TEST
+	help
+	  This enables master mode support for the SPIFC (SPI flash
+	  controller) available in Amlogic Meson SoCs.
+
 config SPI_OC_TINY
 	tristate "OpenCores tiny SPI"
 	depends on GPIOLIB
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 37dc2e7..6b9d2ac 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_SPI_GPIO)			+= spi-gpio.o
 obj-$(CONFIG_SPI_IMG_SPFI)		+= spi-img-spfi.o
 obj-$(CONFIG_SPI_IMX)			+= spi-imx.o
 obj-$(CONFIG_SPI_LM70_LLP)		+= spi-lm70llp.o
+obj-$(CONFIG_SPI_MESON_SPIFC)		+= spi-meson-spifc.o
 obj-$(CONFIG_SPI_MPC512x_PSC)		+= spi-mpc512x-psc.o
 obj-$(CONFIG_SPI_MPC52xx_PSC)		+= spi-mpc52xx-psc.o
 obj-$(CONFIG_SPI_MPC52xx)		+= spi-mpc52xx.o
diff --git a/drivers/spi/spi-meson-spifc.c b/drivers/spi/spi-meson-spifc.c
new file mode 100644
index 0000000..f536476
--- /dev/null
+++ b/drivers/spi/spi-meson-spifc.c
@@ -0,0 +1,462 @@
+/*
+ * Driver for Amlogic Meson SPI flash controller (SPIFC)
+ *
+ * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+#include <linux/types.h>
+
+/* register map */
+#define REG_CMD			0x00
+#define REG_ADDR		0x04
+#define REG_CTRL		0x08
+#define REG_CTRL1		0x0c
+#define REG_STATUS		0x10
+#define REG_CTRL2		0x14
+#define REG_CLOCK		0x18
+#define REG_USER		0x1c
+#define REG_USER1		0x20
+#define REG_USER2		0x24
+#define REG_USER3		0x28
+#define REG_USER4		0x2c
+#define REG_SLAVE		0x30
+#define REG_SLAVE1		0x34
+#define REG_SLAVE2		0x38
+#define REG_SLAVE3		0x3c
+#define REG_C0			0x40
+#define REG_B8			0x60
+#define REG_MAX			0x7c
+
+/* register fields */
+#define CMD_USER		BIT(18)
+#define CTRL_ENABLE_AHB		BIT(17)
+#define CLOCK_SOURCE		BIT(31)
+#define CLOCK_DIV_SHIFT		12
+#define CLOCK_DIV_MASK		(0x3f << CLOCK_DIV_SHIFT)
+#define CLOCK_CNT_HIGH_SHIFT	6
+#define CLOCK_CNT_HIGH_MASK	(0x3f << CLOCK_CNT_HIGH_SHIFT)
+#define CLOCK_CNT_LOW_SHIFT	0
+#define CLOCK_CNT_LOW_MASK	(0x3f << CLOCK_CNT_LOW_SHIFT)
+#define USER_DIN_EN_MS		BIT(0)
+#define USER_CMP_MODE		BIT(2)
+#define USER_UC_DOUT_SEL	BIT(27)
+#define USER_UC_DIN_SEL		BIT(28)
+#define USER_UC_MASK		((BIT(5) - 1) << 27)
+#define USER1_BN_UC_DOUT_SHIFT	17
+#define USER1_BN_UC_DOUT_MASK	(0xff << 16)
+#define USER1_BN_UC_DIN_SHIFT	8
+#define USER1_BN_UC_DIN_MASK	(0xff << 8)
+#define USER4_CS_ACT		BIT(30)
+#define SLAVE_TRST_DONE		BIT(4)
+#define SLAVE_OP_MODE		BIT(30)
+#define SLAVE_SW_RST		BIT(31)
+
+#define SPIFC_BUFFER_SIZE	64
+
+/**
+ * struct meson_spifc
+ * @master:	the SPI master
+ * @regmap:	regmap for device registers
+ * @clk:	input clock of the built-in baud rate generator
+ * @device:	the device structure
+ */
+struct meson_spifc {
+	struct spi_master *master;
+	struct regmap *regmap;
+	struct clk *clk;
+	struct device *dev;
+};
+
+static struct regmap_config spifc_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.max_register = REG_MAX,
+};
+
+/**
+ * meson_spifc_wait_ready() - wait for the current operation to terminate
+ * @spifc:	the Meson SPI device
+ * Return:	0 on success, a negative value on error
+ */
+static int meson_spifc_wait_ready(struct meson_spifc *spifc)
+{
+	unsigned long deadline = jiffies + msecs_to_jiffies(5);
+	u32 data;
+
+	do {
+		regmap_read(spifc->regmap, REG_SLAVE, &data);
+		if (data & SLAVE_TRST_DONE)
+			return 0;
+		cond_resched();
+	} while (!time_after(jiffies, deadline));
+
+	return -ETIMEDOUT;
+}
+
+/**
+ * meson_spifc_drain_buffer() - copy data from device buffer to memory
+ * @spifc:	the Meson SPI device
+ * @buf:	the destination buffer
+ * @len:	number of bytes to copy
+ */
+static void meson_spifc_drain_buffer(struct meson_spifc *spifc, u8 *buf,
+				     int len)
+{
+	u32 data;
+	int i = 0;
+
+	while (i < len) {
+		regmap_read(spifc->regmap, REG_C0 + i, &data);
+
+		if (len - i >= 4) {
+			*((u32 *)buf) = data;
+			buf += 4;
+		} else {
+			memcpy(buf, &data, len - i);
+			break;
+		}
+		i += 4;
+	}
+}
+
+/**
+ * meson_spifc_fill_buffer() - copy data from memory to device buffer
+ * @spifc:	the Meson SPI device
+ * @buf:	the source buffer
+ * @len:	number of bytes to copy
+ */
+static void meson_spifc_fill_buffer(struct meson_spifc *spifc, const u8 *buf,
+				    int len)
+{
+	u32 data;
+	int i = 0;
+
+	while (i < len) {
+		if (len - i >= 4)
+			data = *(u32 *)buf;
+		else
+			memcpy(&data, buf, len - i);
+
+		regmap_write(spifc->regmap, REG_C0 + i, data);
+
+		buf += 4;
+		i += 4;
+	}
+}
+
+/**
+ * meson_spifc_setup_speed() - program the clock divider
+ * @spifc:	the Meson SPI device
+ * @speed:	desired speed in Hz
+ */
+void meson_spifc_setup_speed(struct meson_spifc *spifc, u32 speed)
+{
+	unsigned long parent, value;
+	int n;
+
+	parent = clk_get_rate(spifc->clk);
+	n = max_t(int, parent / speed - 1, 1);
+
+	dev_dbg(spifc->dev, "parent %lu, speed %u, n %d\n", parent,
+		speed, n);
+
+	value = (n << CLOCK_DIV_SHIFT) & CLOCK_DIV_MASK;
+	value |= (n << CLOCK_CNT_LOW_SHIFT) & CLOCK_CNT_LOW_MASK;
+	value |= (((n + 1) / 2 - 1) << CLOCK_CNT_HIGH_SHIFT) &
+		CLOCK_CNT_HIGH_MASK;
+
+	regmap_write(spifc->regmap, REG_CLOCK, value);
+}
+
+/**
+ * meson_spifc_txrx() - transfer a chunk of data
+ * @spifc:	the Meson SPI device
+ * @xfer:	the current SPI transfer
+ * @offset:	offset of the data to transfer
+ * @len:	length of the data to transfer
+ * @last_xfer:	whether this is the last transfer of the message
+ * @last_chunk:	whether this is the last chunk of the transfer
+ * Return:	0 on success, a negative value on error
+ */
+static int meson_spifc_txrx(struct meson_spifc *spifc,
+			    struct spi_transfer *xfer,
+			    int offset, int len, bool last_xfer,
+			    bool last_chunk)
+{
+	bool keep_cs = true;
+	int ret;
+
+	if (xfer->tx_buf)
+		meson_spifc_fill_buffer(spifc, xfer->tx_buf + offset, len);
+
+	/* enable DOUT stage */
+	regmap_update_bits(spifc->regmap, REG_USER, USER_UC_MASK,
+			   USER_UC_DOUT_SEL);
+	regmap_write(spifc->regmap, REG_USER1,
+		     (8 * len - 1) << USER1_BN_UC_DOUT_SHIFT);
+
+	/* enable data input during DOUT */
+	regmap_update_bits(spifc->regmap, REG_USER, USER_DIN_EN_MS,
+			   USER_DIN_EN_MS);
+
+	if (last_chunk) {
+		if (last_xfer)
+			keep_cs = xfer->cs_change;
+		else
+			keep_cs = !xfer->cs_change;
+	}
+
+	regmap_update_bits(spifc->regmap, REG_USER4, USER4_CS_ACT,
+			   keep_cs ? USER4_CS_ACT : 0);
+
+	/* clear transition done bit */
+	regmap_update_bits(spifc->regmap, REG_SLAVE, SLAVE_TRST_DONE, 0);
+	/* start transfer */
+	regmap_update_bits(spifc->regmap, REG_CMD, CMD_USER, CMD_USER);
+
+	ret = meson_spifc_wait_ready(spifc);
+
+	if (!ret && xfer->rx_buf)
+		meson_spifc_drain_buffer(spifc, xfer->rx_buf + offset, len);
+
+	return ret;
+}
+
+/**
+ * meson_spifc_transfer_one() - perform a single transfer
+ * @master:	the SPI master
+ * @spi:	the SPI device
+ * @xfer:	the current SPI transfer
+ * Return:	0 on success, a negative value on error
+ */
+static int meson_spifc_transfer_one(struct spi_master *master,
+				    struct spi_device *spi,
+				    struct spi_transfer *xfer)
+{
+	struct meson_spifc *spifc = spi_master_get_devdata(master);
+	int len, done = 0, ret = 0;
+
+	meson_spifc_setup_speed(spifc, xfer->speed_hz);
+
+	regmap_update_bits(spifc->regmap, REG_CTRL, CTRL_ENABLE_AHB, 0);
+
+	while (done < xfer->len && !ret) {
+		len = min_t(int, xfer->len - done, SPIFC_BUFFER_SIZE);
+		ret = meson_spifc_txrx(spifc, xfer, done, len,
+				       spi_transfer_is_last(master, xfer),
+				       done + len >= xfer->len);
+		done += len;
+	}
+
+	regmap_update_bits(spifc->regmap, REG_CTRL, CTRL_ENABLE_AHB,
+			   CTRL_ENABLE_AHB);
+
+	return ret;
+}
+
+/**
+ * meson_spifc_hw_init() - reset and initialize the SPI controller
+ * @spifc:	the Meson SPI device
+ */
+static void meson_spifc_hw_init(struct meson_spifc *spifc)
+{
+	/* reset device */
+	regmap_update_bits(spifc->regmap, REG_SLAVE, SLAVE_SW_RST,
+			   SLAVE_SW_RST);
+	/* disable compatible mode */
+	regmap_update_bits(spifc->regmap, REG_USER, USER_CMP_MODE, 0);
+	/* set master mode */
+	regmap_update_bits(spifc->regmap, REG_SLAVE, SLAVE_OP_MODE, 0);
+}
+
+static int meson_spifc_probe(struct platform_device *pdev)
+{
+	struct spi_master *master;
+	struct meson_spifc *spifc;
+	struct resource *res;
+	void __iomem *base;
+	unsigned int rate;
+	int ret = 0;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct meson_spifc));
+	if (!master)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, master);
+
+	spifc = spi_master_get_devdata(master);
+	spifc->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(spifc->dev, res);
+	if (IS_ERR(base)) {
+		ret = PTR_ERR(base);
+		goto out_err;
+	}
+
+	spifc->regmap = devm_regmap_init_mmio(spifc->dev, base,
+					      &spifc_regmap_config);
+	if (IS_ERR(spifc->regmap)) {
+		ret = PTR_ERR(spifc->regmap);
+		goto out_err;
+	}
+
+	spifc->clk = devm_clk_get(spifc->dev, NULL);
+	if (IS_ERR(spifc->clk)) {
+		dev_err(spifc->dev, "missing clock\n");
+		ret = PTR_ERR(spifc->clk);
+		goto out_err;
+	}
+
+	ret = clk_prepare_enable(spifc->clk);
+	if (ret) {
+		dev_err(spifc->dev, "can't prepare clock\n");
+		goto out_err;
+	}
+
+	rate = clk_get_rate(spifc->clk);
+
+	master->num_chipselect = 1;
+	master->dev.of_node = pdev->dev.of_node;
+	master->bits_per_word_mask = SPI_BPW_MASK(8);
+	master->auto_runtime_pm = true;
+	master->transfer_one = meson_spifc_transfer_one;
+	master->min_speed_hz = rate >> 6;
+	master->max_speed_hz = rate >> 1;
+
+	meson_spifc_hw_init(spifc);
+
+	pm_runtime_set_active(spifc->dev);
+	pm_runtime_enable(spifc->dev);
+
+	ret = devm_spi_register_master(spifc->dev, master);
+	if (ret) {
+		dev_err(spifc->dev, "failed to register spi master\n");
+		goto out_clk;
+	}
+
+	return 0;
+out_clk:
+	clk_disable_unprepare(spifc->clk);
+out_err:
+	spi_master_put(master);
+	return ret;
+}
+
+static int meson_spifc_remove(struct platform_device *pdev)
+{
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct meson_spifc *spifc = spi_master_get_devdata(master);
+
+	pm_runtime_get_sync(&pdev->dev);
+	clk_disable_unprepare(spifc->clk);
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int meson_spifc_suspend(struct device *dev)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct meson_spifc *spifc = spi_master_get_devdata(master);
+	int ret;
+
+	ret = spi_master_suspend(master);
+	if (ret)
+		return ret;
+
+	if (!pm_runtime_suspended(dev))
+		clk_disable_unprepare(spifc->clk);
+
+	return 0;
+}
+
+static int meson_spifc_resume(struct device *dev)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct meson_spifc *spifc = spi_master_get_devdata(master);
+	int ret;
+
+	if (!pm_runtime_suspended(dev)) {
+		ret = clk_prepare_enable(spifc->clk);
+		if (ret)
+			return ret;
+	}
+
+	meson_spifc_hw_init(spifc);
+
+	ret = spi_master_resume(master);
+	if (ret)
+		clk_disable_unprepare(spifc->clk);
+
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_RUNTIME
+static int meson_spifc_runtime_suspend(struct device *dev)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct meson_spifc *spifc = spi_master_get_devdata(master);
+
+	clk_disable_unprepare(spifc->clk);
+
+	return 0;
+}
+
+static int meson_spifc_runtime_resume(struct device *dev)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct meson_spifc *spifc = spi_master_get_devdata(master);
+
+	return clk_prepare_enable(spifc->clk);
+}
+#endif /* CONFIG_PM_RUNTIME */
+
+static const struct dev_pm_ops meson_spifc_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(meson_spifc_suspend, meson_spifc_resume)
+	SET_RUNTIME_PM_OPS(meson_spifc_runtime_suspend,
+			   meson_spifc_runtime_resume,
+			   NULL)
+};
+
+static const struct of_device_id meson_spifc_dt_match[] = {
+	{ .compatible = "amlogic,meson6-spifc", },
+	{ },
+};
+
+static struct platform_driver meson_spifc_driver = {
+	.probe	= meson_spifc_probe,
+	.remove	= meson_spifc_remove,
+	.driver	= {
+		.name		= "meson-spifc",
+		.of_match_table	= of_match_ptr(meson_spifc_dt_match),
+		.pm		= &meson_spifc_pm_ops,
+	},
+};
+
+module_platform_driver(meson_spifc_driver);
+
+MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
+MODULE_DESCRIPTION("Amlogic Meson SPIFC driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

