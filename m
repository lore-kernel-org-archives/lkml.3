Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3GHNn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:43:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56185 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3GHNny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:43:54 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>
CC: <balbi@ti.com>, <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCHv3 2/3] drivers: spi: Add qspi flash controller
Date: Mon, 8 Jul 2013 19:12:59 +0530
Message-ID: <1373290980-17883-3-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch add basic support for the quad spi controller.

QSPI is a kind of spi module that allows single,
dual and quad read access to external spi devices. The module
has a memory mapped interface which provide direct interface
for accessing data form external spi devices.

The patch will configure controller clocks, device control
register and for defining low level transfer apis which
will be used by the spi framework to transfer data to
the slave spi device(flash in this case).

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
v2->v3
1. Add threaded irq support
2. made the driver more generic in terms of chip select, bits_per_word etc.
3. Made it more modular by sepoerating tx/rx function.
 Documentation/devicetree/bindings/spi/ti_qspi.txt |   22 +
 drivers/spi/Kconfig                               |    8 +
 drivers/spi/Makefile                              |    1 +
 drivers/spi/spi-ti-qspi.c                         |  485 +++++++++++++++++++++
 4 files changed, 516 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/ti_qspi.txt
 create mode 100644 drivers/spi/spi-ti-qspi.c

diff --git a/Documentation/devicetree/bindings/spi/ti_qspi.txt b/Documentation/devicetree/bindings/spi/ti_qspi.txt
new file mode 100644
index 0000000..398ef59
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/ti_qspi.txt
@@ -0,0 +1,22 @@
+TI QSPI controller.
+
+Required properties:
+- compatible : should be "ti,dra7xxx-qspi".
+- reg: Should contain QSPI registers location and length.
+- #address-cells, #size-cells : Must be present if the device has sub-nodes
+- ti,hwmods: Name of the hwmod associated to the QSPI
+
+Recommended properties:
+- spi-max-frequency: Definition as per
+                     Documentation/devicetree/bindings/spi/spi-bus.txt
+
+Example:
+
+qspi: qspi@4b300000 {
+	compatible = "ti,dra7xxx-qspi";
+	reg = <0x4b300000 0x100>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	spi-max-frequency = <25000000>;
+	ti,hwmods = "qspi";
+};
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 92a9345..e594fdb 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -285,6 +285,14 @@ config SPI_OMAP24XX
 	  SPI master controller for OMAP24XX and later Multichannel SPI
 	  (McSPI) modules.
 
+config QSPI_DRA7xxx
+	tristate "DRA7xxx QSPI controller support"
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
+	help
+	  QSPI master controller for DRA7xxx used for flash devices.
+	  This device supports single, dual and quad read support, while
+	  it only supports single write mode.
+
 config SPI_OMAP_100K
 	tristate "OMAP SPI 100K"
 	depends on ARCH_OMAP850 || ARCH_OMAP730
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 33f9c09..b3b4857 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_SPI_OCTEON)		+= spi-octeon.o
 obj-$(CONFIG_SPI_OMAP_UWIRE)		+= spi-omap-uwire.o
 obj-$(CONFIG_SPI_OMAP_100K)		+= spi-omap-100k.o
 obj-$(CONFIG_SPI_OMAP24XX)		+= spi-omap2-mcspi.o
+obj-$(CONFIG_QSPI_DRA7xxx)              += spi-ti-qspi.o
 obj-$(CONFIG_SPI_ORION)			+= spi-orion.o
 obj-$(CONFIG_SPI_PL022)			+= spi-pl022.o
 obj-$(CONFIG_SPI_PPC4xx)		+= spi-ppc4xx.o
diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
new file mode 100644
index 0000000..430de9c
--- /dev/null
+++ b/drivers/spi/spi-ti-qspi.c
@@ -0,0 +1,485 @@
+/*
+ * TI QSPI driver
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ * Author: Sourav Poddar <sourav.poddar@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GPLv2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR /PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/omap-dma.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
+
+#include <linux/spi/spi.h>
+
+struct dra7xxx_qspi {
+	spinlock_t              lock;           /* IRQ synchronization */
+	struct spi_master	*master;
+	void __iomem            *base;
+	struct device           *dev;
+	struct completion       word_complete;
+	struct clk *fclk;
+	int device_type;
+	u32 spi_max_frequency;
+	u32 cmd;
+	u32 dc;
+};
+
+#define QSPI_PID			(0x0)
+#define QSPI_SYSCONFIG			(0x10)
+#define QSPI_INTR_STATUS_RAW_SET	(0x20)
+#define QSPI_INTR_STATUS_ENABLED_CLEAR	(0x24)
+#define QSPI_INTR_ENABLE_SET_REG	(0x28)
+#define QSPI_INTR_ENABLE_CLEAR_REG	(0x2c)
+#define QSPI_SPI_CLOCK_CNTRL_REG	(0x40)
+#define QSPI_SPI_DC_REG			(0x44)
+#define QSPI_SPI_CMD_REG		(0x48)
+#define QSPI_SPI_STATUS_REG		(0x4c)
+#define QSPI_SPI_DATA_REG		(0x50)
+#define QSPI_SPI_SETUP0_REG		(0x54)
+#define QSPI_SPI_SWITCH_REG		(0x64)
+#define QSPI_SPI_SETUP1_REG		(0x58)
+#define QSPI_SPI_SETUP2_REG		(0x5c)
+#define QSPI_SPI_SETUP3_REG		(0x60)
+#define QSPI_SPI_DATA_REG_1		(0x68)
+#define QSPI_SPI_DATA_REG_2		(0x6c)
+#define QSPI_SPI_DATA_REG_3		(0x70)
+
+#define QSPI_TIMEOUT			2000000
+
+#define QSPI_FCLK			192000000
+
+/* Clock Control */
+#define QSPI_CLK_EN			(1 << 31)
+#define QSPI_CLK_DIV_MAX		0xffff
+
+/* Command */
+#define QSPI_EN_CS(n)			(n << 28)
+#define QSPI_WLEN(n)			((n-1) << 19)
+#define QSPI_3_PIN			(1 << 18)
+#define QSPI_RD_SNGL			(1 << 16)
+#define QSPI_WR_SNGL			(2 << 16)
+#define QSPI_RD_QUAD			(7 << 16)
+#define QSPI_INVAL			(4 << 16)
+#define QSPI_WC_CMD_INT_EN			(1 << 14)
+#define QSPI_FLEN(n)			((n-1) << 0)
+
+/* INTERRUPT REGISTER */
+#define QSPI_WC_INT_EN				(1 << 1)
+#define QSPI_WC_INT_DISABLE			(1 << 1)
+
+/* Device Control */
+#define QSPI_DD(m, n)			(m << (3 + n*8))
+#define QSPI_CKPHA(n)			(1 << (2 + n*8))
+#define QSPI_CSPOL(n)			(1 << (1 + n*8))
+#define QSPI_CKPOL(n)			(1 << (n*8))
+
+/* Status */
+#define QSPI_WC				(1 << 1)
+#define QSPI_BUSY			(1 << 0)
+#define QSPI_WC_BUSY			(QSPI_WC | QSPI_BUSY)
+#define QSPI_XFER_DONE			QSPI_WC
+
+#define	QSPI_FRAME_MAX			0xfff
+
+#define SPI_AUTOSUSPEND_TIMEOUT         2000
+
+static inline unsigned long dra7xxx_readl(struct dra7xxx_qspi *qspi,
+		unsigned long reg)
+{
+	return readl(qspi->base + reg);
+}
+
+static inline void dra7xxx_writel(struct dra7xxx_qspi *qspi,
+		unsigned long val, unsigned long reg)
+{
+	writel(val, qspi->base + reg);
+}
+
+static inline unsigned long dra7xxx_readl_data(struct dra7xxx_qspi *qspi,
+		unsigned long reg, int wlen)
+{
+	switch (wlen) {
+	case 8:
+		return readw(qspi->base + reg);
+		break;
+	case 16:
+		return readb(qspi->base + reg);
+		break;
+	case 32:
+		return readl(qspi->base + reg);
+		break;
+	default:
+		return -1;
+	}
+}
+
+static inline void dra7xxx_writel_data(struct dra7xxx_qspi *qspi,
+		unsigned long val, unsigned long reg, int wlen)
+{
+	switch (wlen) {
+	case 8:
+		writew(val, qspi->base + reg);
+		break;
+	case 16:
+		writeb(val, qspi->base + reg);
+		break;
+	case 32:
+		writeb(val, qspi->base + reg);
+		break;
+	default:
+		dev_dbg(qspi->dev, "word lenght out of range");
+		break;
+	}
+}
+
+static int dra7xxx_qspi_setup(struct spi_device *spi)
+{
+	struct dra7xxx_qspi	*qspi = spi_master_get_devdata(spi->master);
+	int clk_div = 0;
+	u32 clk_ctrl_reg, clk_rate;
+
+	clk_rate = clk_get_rate(qspi->fclk);
+
+	if (!qspi->spi_max_frequency) {
+		dev_err(qspi->dev, "spi max frequency not defined\n");
+		return -1;
+	} else
+		clk_div = (clk_rate / qspi->spi_max_frequency) - 1;
+
+	dev_dbg(qspi->dev, "%s: hz: %d, clock divider %d\n", __func__,
+			qspi->spi_max_frequency, clk_div);
+
+	pm_runtime_get_sync(qspi->dev);
+
+	clk_ctrl_reg = dra7xxx_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG);
+
+	clk_ctrl_reg &= ~QSPI_CLK_EN;
+
+	/* disable SCLK */
+	dra7xxx_writel(qspi, clk_ctrl_reg, QSPI_SPI_CLOCK_CNTRL_REG);
+
+	if (clk_div < 0) {
+		dev_dbg(qspi->dev, "%s: clock divider < 0, using /1 divider\n",
+				__func__);
+		clk_div = 1;
+	}
+
+	if (clk_div > QSPI_CLK_DIV_MAX) {
+		dev_dbg(qspi->dev, "%s: clock divider >%d , using /%d divider\n",
+			__func__, QSPI_CLK_DIV_MAX, QSPI_CLK_DIV_MAX + 1);
+		clk_div = QSPI_CLK_DIV_MAX;
+	}
+
+	/* enable SCLK */
+	dra7xxx_writel(qspi, QSPI_CLK_EN | clk_div, QSPI_SPI_CLOCK_CNTRL_REG);
+
+	pm_runtime_mark_last_busy(qspi->dev);
+	pm_runtime_put_autosuspend(qspi->dev);
+
+	return 0;
+}
+
+static int dra7xxx_qspi_prepare_xfer(struct spi_master *master)
+{
+	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
+
+	pm_runtime_get_sync(qspi->dev);
+
+	return 0;
+}
+
+static int dra7xxx_qspi_unprepare_xfer(struct spi_master *master)
+{
+	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
+
+	pm_runtime_mark_last_busy(qspi->dev);
+	pm_runtime_put_autosuspend(qspi->dev);
+
+	return 0;
+}
+
+static int qspi_write_msg(struct dra7xxx_qspi *qspi, struct spi_transfer *t)
+{
+	const u8 *txbuf;
+	int wlen, count;
+
+	count = t->len;
+	txbuf = t->tx_buf;
+	wlen = t->bits_per_word;
+
+	while (count--) {
+		dev_dbg(qspi->dev, "tx cmd %08x dc %08x data %02x\n",
+			qspi->cmd | QSPI_WR_SNGL, qspi->dc, *txbuf);
+		dra7xxx_writel(qspi, QSPI_WC_INT_EN, QSPI_INTR_ENABLE_SET_REG);
+		dra7xxx_writel_data(qspi, *txbuf++, QSPI_SPI_DATA_REG, wlen);
+		dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
+		dra7xxx_writel(qspi, qspi->cmd | QSPI_WR_SNGL,
+			QSPI_SPI_CMD_REG);
+		wait_for_completion(&qspi->word_complete);
+	}
+
+	return 0;
+}
+
+static int qspi_read_msg(struct dra7xxx_qspi *qspi, struct spi_transfer *t)
+{
+	u8 *rxbuf;
+	int wlen, count;
+
+	count = t->len;
+	rxbuf = t->rx_buf;
+	wlen = t->bits_per_word;
+
+	while (count--) {
+		dev_dbg(qspi->dev, "rx cmd %08x dc %08x\n",
+			qspi->cmd | QSPI_RD_SNGL, qspi->dc);
+		dra7xxx_writel(qspi, QSPI_WC_INT_EN, QSPI_INTR_ENABLE_SET_REG);
+		dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
+		dra7xxx_writel(qspi, qspi->cmd | QSPI_RD_SNGL,
+			QSPI_SPI_CMD_REG);
+		wait_for_completion(&qspi->word_complete);
+		*rxbuf++ = dra7xxx_readl_data(qspi, QSPI_SPI_DATA_REG, wlen);
+		dev_dbg(qspi->dev, "rx done, read %02x\n", *(rxbuf-1));
+	}
+
+	return 0;
+}
+
+static int qspi_transfer_msg(struct dra7xxx_qspi *qspi, struct spi_transfer *t)
+{
+	if (t->tx_buf)
+		qspi_write_msg(qspi, t);
+	if (t->rx_buf)
+		qspi_read_msg(qspi, t);
+
+	return 0;
+}
+
+static int dra7xxx_qspi_start_transfer_one(struct spi_master *master,
+		struct spi_message *m)
+{
+	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
+	struct spi_device *spi = m->spi;
+	struct spi_transfer *t;
+	int status = 0;
+	int frame_length;
+
+	/* setup device control reg */
+	qspi->dc = 0;
+
+	if (spi->mode & SPI_CPHA)
+		qspi->dc |= QSPI_CKPHA(spi->chip_select);
+	if (spi->mode & SPI_CPOL)
+		qspi->dc |= QSPI_CKPOL(spi->chip_select);
+	if (spi->mode & SPI_CS_HIGH)
+		qspi->dc |= QSPI_CSPOL(spi->chip_select);
+
+	frame_length = DIV_ROUND_UP(m->frame_length * spi->bits_per_word,
+				spi->bits_per_word);
+
+	frame_length = clamp(frame_length, 0, QSPI_FRAME_MAX);
+
+	/* setup command reg */
+	qspi->cmd = 0;
+	qspi->cmd |= QSPI_EN_CS(spi->chip_select);
+	qspi->cmd |= QSPI_FLEN(frame_length);
+
+	list_for_each_entry(t, &m->transfers, transfer_list) {
+		qspi->cmd |= QSPI_WLEN(t->bits_per_word);
+		qspi->cmd |= QSPI_WC_CMD_INT_EN;
+
+		qspi_transfer_msg(qspi, t);
+
+		m->actual_length += t->len;
+
+		if (list_is_last(&t->transfer_list, &m->transfers))
+			goto out;
+	}
+
+out:
+	m->status = status;
+	spi_finalize_current_message(master);
+
+	dra7xxx_writel(qspi, qspi->cmd | QSPI_INVAL, QSPI_SPI_CMD_REG);
+
+	return status;
+}
+
+static irqreturn_t dra7xxx_qspi_isr(int irq, void *dev_id)
+{
+	struct dra7xxx_qspi *qspi = dev_id;
+	u16 mask, stat;
+
+	irqreturn_t ret = IRQ_HANDLED;
+
+	spin_lock(&qspi->lock);
+
+	stat = dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
+	mask = dra7xxx_readl(qspi, QSPI_SPI_CMD_REG);
+
+	if ((stat & QSPI_WC) && (mask & QSPI_WC_CMD_INT_EN))
+		ret = IRQ_WAKE_THREAD;
+
+	spin_unlock(&qspi->lock);
+
+	return ret;
+}
+
+static irqreturn_t dra7xxx_qspi_threaded_isr(int this_irq, void *dev_id)
+{
+	struct dra7xxx_qspi *qspi = dev_id;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qspi->lock, flags);
+
+	dra7xxx_writel(qspi, QSPI_WC_INT_DISABLE, QSPI_INTR_ENABLE_CLEAR_REG);
+	dra7xxx_writel(qspi, QSPI_WC_INT_DISABLE,
+			QSPI_INTR_STATUS_ENABLED_CLEAR);
+
+	complete(&qspi->word_complete);
+
+	spin_unlock_irqrestore(&qspi->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static const struct of_device_id dra7xxx_qspi_match[] = {
+	{.compatible = "ti,dra7xxx-qspi" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, dra7xxx_qspi_match);
+
+static int dra7xxx_qspi_probe(struct platform_device *pdev)
+{
+	struct  dra7xxx_qspi *qspi;
+	struct spi_master *master;
+	struct resource         *r;
+	struct device_node *np = pdev->dev.of_node;
+	u32 max_freq;
+	int ret = 0, num_cs, irq;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(*qspi));
+	if (!master)
+		return -ENOMEM;
+
+	master->mode_bits = SPI_CPOL | SPI_CPHA;
+
+	master->num_chipselect = 1;
+	master->bus_num = -1;
+	master->setup = dra7xxx_qspi_setup;
+	master->prepare_transfer_hardware = dra7xxx_qspi_prepare_xfer;
+	master->transfer_one_message = dra7xxx_qspi_start_transfer_one;
+	master->unprepare_transfer_hardware = dra7xxx_qspi_unprepare_xfer;
+	master->dev.of_node = pdev->dev.of_node;
+	master->bits_per_word_mask = BIT(32 - 1) | BIT(16 - 1) | BIT(8 - 1);
+
+	if (!of_property_read_u32(np, "ti,spi-num-cs", &num_cs))
+		master->num_chipselect = num_cs;
+
+	platform_set_drvdata(pdev, master);
+
+	qspi = spi_master_get_devdata(master);
+	qspi->master = master;
+	qspi->dev = &pdev->dev;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		ret = -ENODEV;
+		goto free_master;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no irq resource?\n");
+		return irq;
+	}
+
+	spin_lock_init(&qspi->lock);
+
+	qspi->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(qspi->base)) {
+		ret = -ENOMEM;
+		goto free_master;
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, irq, dra7xxx_qspi_isr,
+		dra7xxx_qspi_threaded_isr, IRQF_NO_SUSPEND | IRQF_ONESHOT,
+			dev_name(&pdev->dev), qspi);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
+				irq);
+		goto free_master;
+	}
+
+	qspi->fclk = devm_clk_get(&pdev->dev, "fck");
+	if (IS_ERR(qspi->fclk)) {
+		ret = PTR_ERR(qspi->fclk);
+		dev_err(&pdev->dev, "could not get clk: %d\n", ret);
+	}
+
+	init_completion(&qspi->word_complete);
+
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
+	pm_runtime_enable(&pdev->dev);
+
+	if (!of_property_read_u32(np, "spi-max-frequency", &max_freq))
+		qspi->spi_max_frequency = max_freq;
+
+	ret = spi_register_master(master);
+	if (ret)
+		goto free_master;
+
+	return ret;
+
+free_master:
+	spi_master_put(master);
+	return ret;
+}
+
+static int dra7xxx_qspi_remove(struct platform_device *pdev)
+{
+	struct  dra7xxx_qspi *qspi = platform_get_drvdata(pdev);
+
+	spi_unregister_master(qspi->master);
+
+	return 0;
+}
+
+static struct platform_driver dra7xxx_qspi_driver = {
+	.probe	= dra7xxx_qspi_probe,
+	.remove	= dra7xxx_qspi_remove,
+	.driver = {
+		.name	= "ti,dra7xxx-qspi",
+		.owner	= THIS_MODULE,
+		.of_match_table = dra7xxx_qspi_match,
+	}
+};
+
+module_platform_driver(dra7xxx_qspi_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("TI QSPI controller driver");
-- 
1.7.1

