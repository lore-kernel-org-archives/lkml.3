Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbaCKMqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:46:50 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33966 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbaCKMpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:45:46 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 1/3] spi: add xtfpga SPI controller driver
Date: Tue, 11 Mar 2014 16:44:49 +0400
Message-Id: <1394541891-26469-2-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
References: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple SPI master controller is built into xtfpga bitstreams. It
always transfers 16 bit words in SPI mode 0, automatically asserting CS
on transfer start and deasserting on end.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/spi/Kconfig             |  13 ++++
 drivers/spi/Makefile            |   1 +
 drivers/spi/spi-xtensa-xtfpga.c | 165 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+)
 create mode 100644 drivers/spi/spi-xtensa-xtfpga.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 581ee2a..e3f5335 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -520,6 +520,19 @@ config SPI_XILINX
 
 	  Or for the DS570, see "XPS Serial Peripheral Interface (SPI) (v2.00b)"
 
+config SPI_XTENSA_XTFPGA
+	tristate "Xtensa SPI controller for xtfpga"
+	depends on XTENSA && XTENSA_PLATFORM_XTFPGA
+	select SPI_BITBANG
+	help
+	  SPI driver for xtfpga SPI master controller.
+
+	  This simple SPI master controller is built into xtfpga bitstreams
+	  and is used to control daughterboard audio codec. It always transfers
+	  16 bit words in SPI mode 0, automatically asserting CS on transfer
+	  start and deasserting on end.
+
+
 config SPI_NUC900
 	tristate "Nuvoton NUC900 series SPI"
 	depends on ARCH_W90X900
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 95af48d..5379ade 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -79,3 +79,4 @@ obj-$(CONFIG_SPI_TOPCLIFF_PCH)		+= spi-topcliff-pch.o
 obj-$(CONFIG_SPI_TXX9)			+= spi-txx9.o
 obj-$(CONFIG_SPI_XCOMM)		+= spi-xcomm.o
 obj-$(CONFIG_SPI_XILINX)		+= spi-xilinx.o
+obj-$(CONFIG_SPI_XTENSA_XTFPGA)		+= spi-xtensa-xtfpga.o
diff --git a/drivers/spi/spi-xtensa-xtfpga.c b/drivers/spi/spi-xtensa-xtfpga.c
new file mode 100644
index 0000000..3131916
--- /dev/null
+++ b/drivers/spi/spi-xtensa-xtfpga.c
@@ -0,0 +1,165 @@
+/*
+ * Xtensa xtfpga SPI controller driver
+ *
+ * Copyright (c) 2014 Cadence Design Systems Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+
+#define XTFPGA_SPI_NAME "xtfpga_spi"
+
+#define XTFPGA_SPI_START	0x0
+#define XTFPGA_SPI_BUSY		0x4
+#define XTFPGA_SPI_DATA		0x8
+
+struct xtfpga_spi {
+	struct spi_bitbang bitbang;
+	void __iomem *regs;
+};
+
+static inline void xtfpga_spi_write32(const struct xtfpga_spi *spi,
+				      unsigned addr, u32 val)
+{
+	iowrite32(val, spi->regs + addr);
+}
+
+static inline unsigned int xtfpga_spi_read32(const struct xtfpga_spi *spi,
+					     unsigned addr)
+{
+	return ioread32(spi->regs + addr);
+}
+
+static inline int xtfpga_spi_wait_busy(struct xtfpga_spi *xspi)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(100);
+	while (xtfpga_spi_read32(xspi, XTFPGA_SPI_BUSY)) {
+		if (!time_before(jiffies, timeout))
+			return -EBUSY;
+		else
+			cpu_relax();
+	}
+	return 0;
+}
+
+static u32 xtfpga_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
+				u32 v, u8 bits)
+{
+	struct xtfpga_spi *xspi = spi_master_get_devdata(spi->master);
+
+	/* Bytes that should go out earlier have lower addresses,
+	 * but the hardware operates with 16 bit words and transmits
+	 * higher bits first. Thus data in memory is in BE order.
+	 */
+	xtfpga_spi_write32(xspi, XTFPGA_SPI_DATA, be16_to_cpu(v));
+	xtfpga_spi_write32(xspi, XTFPGA_SPI_START, 1);
+	xtfpga_spi_wait_busy(xspi);
+	xtfpga_spi_write32(xspi, XTFPGA_SPI_START, 0);
+
+	return 0;
+}
+
+/* Unused: this device controls its only CS automatically,
+ * deactivating it after every 16 bit transfer completion.
+ */
+static void xtfpga_spi_chipselect(struct spi_device *spi, int is_on)
+{
+}
+
+static int xtfpga_spi_probe(struct platform_device *pdev)
+{
+	struct xtfpga_spi *xspi;
+	struct resource *mem;
+	int ret;
+	struct spi_master *master;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct xtfpga_spi));
+	if (!master)
+		return -ENOMEM;
+
+	master->flags = SPI_MASTER_NO_RX;
+	master->bits_per_word_mask = SPI_BPW_MASK(16);
+	master->bus_num = pdev->dev.id;
+	master->dev.of_node = pdev->dev.of_node;
+
+	xspi = spi_master_get_devdata(master);
+	xspi->bitbang.master = master;
+	xspi->bitbang.chipselect = xtfpga_spi_chipselect;
+	xspi->bitbang.txrx_word[SPI_MODE_0] = xtfpga_spi_txrx_word;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "No memory resource\n");
+		ret = -ENODEV;
+		goto err;
+	}
+	xspi->regs = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(xspi->regs)) {
+		ret = PTR_ERR(xspi->regs);
+		goto err;
+	}
+
+	xtfpga_spi_write32(xspi, XTFPGA_SPI_START, 0);
+	ret = xtfpga_spi_wait_busy(xspi);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Device stuck in busy state\n");
+		goto err;
+	}
+
+	ret = spi_bitbang_start(&xspi->bitbang);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "spi_bitbang_start failed\n");
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, master);
+	return 0;
+err:
+	spi_master_put(master);
+	return ret;
+}
+
+static int xtfpga_spi_remove(struct platform_device *pdev)
+{
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct xtfpga_spi *xspi = spi_master_get_devdata(master);
+
+	spi_bitbang_stop(&xspi->bitbang);
+	spi_master_put(master);
+
+	return 0;
+}
+
+MODULE_ALIAS("platform:" XTFPGA_SPI_NAME);
+
+#ifdef CONFIG_OF
+static const struct of_device_id xtfpga_spi_of_match[] = {
+	{ .compatible = "cdns,xtfpga-spi", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, xtfpga_spi_of_match);
+#endif
+
+static struct platform_driver xtfpga_spi_driver = {
+	.probe = xtfpga_spi_probe,
+	.remove = xtfpga_spi_remove,
+	.driver = {
+		.name = XTFPGA_SPI_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(xtfpga_spi_of_match),
+	},
+};
+module_platform_driver(xtfpga_spi_driver);
+
+MODULE_AUTHOR("Max Filippov <jcmvbkbc@gmail.com>");
+MODULE_DESCRIPTION("xtensa xtfpga SPI driver");
+MODULE_LICENSE("GPL");
-- 
1.8.1.4

