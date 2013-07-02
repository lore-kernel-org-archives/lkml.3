Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab3GBI5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:57:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54383 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321Ab3GBI47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:56:59 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>
CC: <balbi@ti.com>, <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCHv2] drivers: spi: Add qspi flash controller
Date: Tue, 2 Jul 2013 14:26:39 +0530
Message-ID: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
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
This patch was sent as a part of a series[1];
but this can go in as a standalone patch.
[1]: https://lkml.org/lkml/2013/6/26/83

v1->v2:
1. Placed pm specific calls in prepare/unprepare apis.
2. Put a mask to support upto 32 bits word length.
3. Used "devm_ioremap_resource" variants.
4. Add dt binding doumentation.
 Documentation/devicetree/bindings/spi/ti_qspi.txt |   22 ++
 drivers/spi/Kconfig                               |    8 +
 drivers/spi/Makefile                              |    1 +
 drivers/spi/ti-qspi.c                             |  357 +++++++++++++++++++++
 4 files changed, 388 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/ti_qspi.txt
 create mode 100644 drivers/spi/ti-qspi.c

diff --git a/Documentation/devicetree/bindings/spi/ti_qspi.txt b/Documentation/devicetree/bindings/spi/ti_qspi.txt
new file mode 100644
index 0000000..65075c8
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
+        spi-max-frequency = <25000000>;
+	ti,hwmods = "qspi";
+};
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 92a9345..9937d66 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -285,6 +285,14 @@ config SPI_OMAP24XX
 	  SPI master controller for OMAP24XX and later Multichannel SPI
 	  (McSPI) modules.
 
+config QSPI_DRA7xxx
+	tristate "DRA7xxx QSPI controller support"
+	depends on ARCH_OMAP2PLUS
+	help
+	  QSPI master controller for DRA7xxx used for flash devices.
+	  This device supports single, dual and quad read support, while
+	  it only supports single write mode.
+
 config SPI_OMAP_100K
 	tristate "OMAP SPI 100K"
 	depends on ARCH_OMAP850 || ARCH_OMAP730
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 33f9c09..ea14eff 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_SPI_OCTEON)		+= spi-octeon.o
 obj-$(CONFIG_SPI_OMAP_UWIRE)		+= spi-omap-uwire.o
 obj-$(CONFIG_SPI_OMAP_100K)		+= spi-omap-100k.o
 obj-$(CONFIG_SPI_OMAP24XX)		+= spi-omap2-mcspi.o
+obj-$(CONFIG_QSPI_DRA7xxx)              += ti-qspi.o
 obj-$(CONFIG_SPI_ORION)			+= spi-orion.o
 obj-$(CONFIG_SPI_PL022)			+= spi-pl022.o
 obj-$(CONFIG_SPI_PPC4xx)		+= spi-ppc4xx.o
diff --git a/drivers/spi/ti-qspi.c b/drivers/spi/ti-qspi.c
new file mode 100644
index 0000000..e646a93
--- /dev/null
+++ b/drivers/spi/ti-qspi.c
@@ -0,0 +1,357 @@
+/*
+ * TI QSPI driver
+ *
+ * Copyright (C) 2013, Texas Instruments, Incorporated
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
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
+	struct spi_master	*master;
+	void __iomem            *base;
+	int device_type;
+	struct device           *dev;
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
+#define XFER_END			0x01
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
+static int dra7xxx_qspi_setup(struct spi_device *spi)
+{
+	struct dra7xxx_qspi	*qspi =
+			spi_master_get_devdata(spi->master);
+
+	int clk_div;
+
+	if (!qspi->spi_max_frequency)
+		clk_div = 0;
+	else
+		clk_div = (QSPI_FCLK / qspi->spi_max_frequency) - 1;
+
+	pr_debug("%s: hz: %d, clock divider %d\n", __func__,
+			qspi->spi_max_frequency, clk_div);
+
+	pm_runtime_get_sync(qspi->dev);
+
+	/* disable SCLK */
+	dra7xxx_writel(qspi, dra7xxx_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG)
+			& ~QSPI_CLK_EN, QSPI_SPI_CLOCK_CNTRL_REG);
+
+	if (clk_div < 0) {
+		pr_debug("%s: clock divider < 0, using /1 divider\n", __func__);
+		clk_div = 0;
+	}
+
+	if (clk_div > QSPI_CLK_DIV_MAX) {
+		pr_debug("%s: clock divider >%d , using /%d divider\n",
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
+	pr_debug("%s: spi_clock_cntrl %ld\n", __func__,
+		dra7xxx_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG));
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
+static int qspi_transfer_msg(struct dra7xxx_qspi *qspi, unsigned count,
+			const u8 *txbuf, u8 *rxbuf, bool flags)
+{
+	uint status;
+	int timeout;
+
+	while (count--) {
+		if (txbuf) {
+			pr_debug("tx cmd %08x dc %08x data %02x\n",
+				qspi->cmd | QSPI_WR_SNGL, qspi->dc, *txbuf);
+			dra7xxx_writel(qspi, *txbuf++, QSPI_SPI_DATA_REG);
+			dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
+			dra7xxx_writel(qspi, qspi->cmd | QSPI_WR_SNGL,
+					QSPI_SPI_CMD_REG);
+			status = dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
+			timeout = QSPI_TIMEOUT;
+			while ((status & QSPI_WC_BUSY) != QSPI_XFER_DONE) {
+				if (--timeout < 0) {
+					pr_debug("QSPI tx timed out\n");
+					return -1;
+				}
+				status = dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
+			}
+			pr_debug("tx done, status %08x\n", status);
+		}
+		if (rxbuf) {
+			pr_debug("rx cmd %08x dc %08x\n",
+				qspi->cmd | QSPI_RD_SNGL, qspi->dc);
+			dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
+			dra7xxx_writel(qspi, qspi->cmd | QSPI_RD_SNGL,
+					QSPI_SPI_CMD_REG);
+			status = dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
+			timeout = QSPI_TIMEOUT;
+			while ((status & QSPI_WC_BUSY) != QSPI_XFER_DONE) {
+				if (--timeout < 0) {
+					pr_debug("QSPI rx timed out\n");
+					return -1;
+				}
+				status = dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
+			}
+			*rxbuf++ = dra7xxx_readl(qspi, QSPI_SPI_DATA_REG);
+			pr_debug("rx done, status %08x, read %02x\n",
+				status, *(rxbuf-1));
+		}
+	}
+
+	if (flags & XFER_END)
+		dra7xxx_writel(qspi, qspi->cmd | QSPI_INVAL, QSPI_SPI_CMD_REG);
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
+	int flags = 0;
+
+	/* setup command reg */
+	qspi->cmd = 0;
+	qspi->cmd |= QSPI_WLEN(8);
+	qspi->cmd |= QSPI_EN_CS(0);
+	qspi->cmd |= 0xfff;
+
+	/* setup device control reg */
+	qspi->dc = 0;
+
+	if (spi->mode & SPI_CPHA)
+		qspi->dc |= QSPI_CKPHA(0);
+	if (spi->mode & SPI_CPOL)
+		qspi->dc |= QSPI_CKPOL(0);
+	if (spi->mode & SPI_CS_HIGH)
+		qspi->dc |= QSPI_CSPOL(0);
+
+	list_for_each_entry(t, &m->transfers, transfer_list) {
+		if (list_is_last(&t->transfer_list, &m->transfers))
+			flags = XFER_END;
+
+		qspi_transfer_msg(qspi, t->len, t->tx_buf,
+			t->rx_buf, flags);
+
+		m->actual_length += t->len;
+	}
+	m->status = status;
+	spi_finalize_current_message(master);
+
+	return status;
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
+	int ret;
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
+	dev_set_drvdata(&pdev->dev, master);
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
+	qspi->base = devm_ioremap_resource(&pdev->dev, r);
+	if (!qspi->base) {
+		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
+		ret = -ENOMEM;
+		goto free_master;
+	}
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

