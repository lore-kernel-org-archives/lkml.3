Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3FDJgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:36:13 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:47544 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3FDJfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:35:52 -0400
From: Ferruh Yigit <fery@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: ttdrivers@cypress.com, Javier Martinez Canillas <javier@dowhile0.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Simon Budig <simon.budig@kernelconcepts.de>,
        Alexander Shiyan <shc_work@mail.ru>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Ferruh Yigit <fery@cypress.com>
Subject: [PATCH v3 4/4] Input: cyttsp4 - SPI driver for Cypress TMA4XX touchscreen devices
Date: Tue,  4 Jun 2013 12:34:44 +0300
Message-Id: <1370338484-26573-5-git-send-email-fery@cypress.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370338484-26573-1-git-send-email-fery@cypress.com>
References: <1370338484-26573-1-git-send-email-fery@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cypress TrueTouch(tm) Standard Product controllers,
Generation4 devices, SPI adapter module.

This driver adds communication support with TTSP controller
using SPI bus.

Signed-off-by: Ferruh Yigit <fery@cypress.com>
---
 drivers/input/touchscreen/Kconfig       |    9 ++
 drivers/input/touchscreen/Makefile      |    1 +
 drivers/input/touchscreen/cyttsp4_spi.c |  205 +++++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+)
 create mode 100644 drivers/input/touchscreen/cyttsp4_spi.c

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 1645e8e..2d70089 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -188,6 +188,15 @@ config TOUCHSCREEN_CYTTSP4_I2C
 	  To compile this driver as a module, choose M here: the
 	  module will be called cyttsp4_i2c.
 
+config TOUCHSCREEN_CYTTSP4_SPI
+	tristate "support SPI bus connection"
+	depends on TOUCHSCREEN_CYTTSP4_CORE && SPI_MASTER
+	help
+	  Say Y here if the touchscreen is connected via SPI bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cyttsp4_spi.
+
 config TOUCHSCREEN_DA9034
 	tristate "Touchscreen support for Dialog Semiconductor DA9034"
 	depends on PMIC_DA903X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 1ef807c..f5216c1 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_TOUCHSCREEN_CYTTSP_I2C)	+= cyttsp_i2c.o cyttsp_i2c_common.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP_SPI)	+= cyttsp_spi.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP4_CORE)	+= cyttsp4_core.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP4_I2C)	+= cyttsp4_i2c.o cyttsp_i2c_common.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP4_SPI)	+= cyttsp4_spi.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
 obj-$(CONFIG_TOUCHSCREEN_DA9052)	+= da9052_tsi.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
diff --git a/drivers/input/touchscreen/cyttsp4_spi.c b/drivers/input/touchscreen/cyttsp4_spi.c
new file mode 100644
index 0000000..f8f891b
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp4_spi.c
@@ -0,0 +1,205 @@
+/*
+ * Source for:
+ * Cypress TrueTouch(TM) Standard Product (TTSP) SPI touchscreen driver.
+ * For use with Cypress Txx4xx parts.
+ * Supported parts include:
+ * TMA4XX
+ * TMA1036
+ *
+ * Copyright (C) 2009, 2010, 2011 Cypress Semiconductor, Inc.
+ * Copyright (C) 2012 Javier Martinez Canillas <javier@dowhile0.org>
+ * Copyright (C) 2013 Cypress Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com <ttdrivers@cypress.com>
+ *
+ */
+
+#include "cyttsp4_core.h"
+
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/spi/spi.h>
+
+#define CY_SPI_WR_OP		0x00 /* r/~w */
+#define CY_SPI_RD_OP		0x01
+#define CY_SPI_BITS_PER_WORD	8
+#define CY_SPI_A8_BIT		0x02
+#define CY_SPI_WR_HEADER_BYTES	2
+#define CY_SPI_RD_HEADER_BYTES	1
+#define CY_SPI_CMD_BYTES	2
+#define CY_SPI_SYNC_BYTE	0
+#define CY_SPI_SYNC_ACK		0x62 /* from TRM *A protocol */
+#define CY_SPI_DATA_SIZE	(2 * 256)
+
+#define CY_SPI_DATA_BUF_SIZE	(CY_SPI_CMD_BYTES + CY_SPI_DATA_SIZE)
+
+static int cyttsp_spi_xfer(struct device *dev, u8 *xfer_buf,
+			   u8 op, u8 reg, u8 *buf, int length)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct spi_message msg;
+	struct spi_transfer xfer[2];
+	u8 *wr_buf = &xfer_buf[0];
+	u8 rd_buf[CY_SPI_CMD_BYTES];
+	int retval;
+	int i;
+
+	if (length > CY_SPI_DATA_SIZE) {
+		dev_err(dev, "%s: length %d is too big.\n",
+			__func__, length);
+		return -EINVAL;
+	}
+
+	memset(wr_buf, 0, CY_SPI_DATA_BUF_SIZE);
+	memset(rd_buf, 0, CY_SPI_CMD_BYTES);
+
+	if (reg > 255)
+		wr_buf[0] = op + CY_SPI_A8_BIT;
+	else
+		wr_buf[0] = op;
+	if (op == CY_SPI_WR_OP)
+		wr_buf[1] = reg % 256;
+	if (op == CY_SPI_WR_OP && length > 0)
+		memcpy(wr_buf + CY_SPI_CMD_BYTES, buf, length);
+
+	memset(xfer, 0, sizeof(xfer));
+	spi_message_init(&msg);
+
+	/*
+	  We set both TX and RX buffers because Cypress TTSP
+	  requires full duplex operation.
+	*/
+	xfer[0].tx_buf = wr_buf;
+	xfer[0].rx_buf = rd_buf;
+	switch (op) {
+	case CY_SPI_WR_OP:
+		xfer[0].len = length + CY_SPI_CMD_BYTES;
+		spi_message_add_tail(&xfer[0], &msg);
+		break;
+
+	case CY_SPI_RD_OP:
+		xfer[0].len = CY_SPI_RD_HEADER_BYTES;
+		spi_message_add_tail(&xfer[0], &msg);
+
+		xfer[1].rx_buf = buf;
+		xfer[1].len = length;
+		spi_message_add_tail(&xfer[1], &msg);
+		break;
+
+	default:
+		dev_err(dev, "%s: bad operation code=%d\n", __func__, op);
+		return -EINVAL;
+	}
+
+	retval = spi_sync(spi, &msg);
+	if (retval < 0) {
+		dev_dbg(dev, "%s: spi_sync() error %d, len=%d, op=%d\n",
+			__func__, retval, xfer[1].len, op);
+
+		/*
+		 * do not return here since was a bad ACK sequence
+		 * let the following ACK check handle any errors and
+		 * allow silent retries
+		 */
+	}
+
+	if (rd_buf[CY_SPI_SYNC_BYTE] != CY_SPI_SYNC_ACK) {
+		dev_dbg(dev, "%s: operation %d failed\n", __func__, op);
+
+		for (i = 0; i < CY_SPI_CMD_BYTES; i++)
+			dev_dbg(dev, "%s: test rd_buf[%d]:0x%02x\n",
+				__func__, i, rd_buf[i]);
+		for (i = 0; i < length; i++)
+			dev_dbg(dev, "%s: test buf[%d]:0x%02x\n",
+				__func__, i, buf[i]);
+
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int cyttsp_spi_read_block_data(struct device *dev, u8 *xfer_buf,
+				      u8 addr, u8 length, void *data)
+{
+	int rc;
+
+	rc = cyttsp_spi_xfer(dev, xfer_buf, CY_SPI_WR_OP, addr, NULL, 0);
+	if (rc)
+		return rc;
+	else
+		return cyttsp_spi_xfer(dev, xfer_buf, CY_SPI_RD_OP, addr, data,
+				length);
+}
+
+static int cyttsp_spi_write_block_data(struct device *dev, u8 *xfer_buf,
+				       u8 addr, u8 length, const void *data)
+{
+	return cyttsp_spi_xfer(dev, xfer_buf, CY_SPI_WR_OP, addr, (void *)data,
+			length);
+}
+
+static const struct cyttsp4_bus_ops cyttsp_spi_bus_ops = {
+	.bustype	= BUS_SPI,
+	.write		= cyttsp_spi_write_block_data,
+	.read		= cyttsp_spi_read_block_data,
+};
+
+static int cyttsp4_spi_probe(struct spi_device *spi)
+{
+	struct cyttsp4 *ts;
+	int error;
+
+	/* Set up SPI*/
+	spi->bits_per_word = CY_SPI_BITS_PER_WORD;
+	spi->mode = SPI_MODE_0;
+	error = spi_setup(spi);
+	if (error < 0) {
+		dev_err(&spi->dev, "%s: SPI setup error %d\n",
+			__func__, error);
+		return error;
+	}
+
+	ts = cyttsp4_probe(&cyttsp_spi_bus_ops, &spi->dev, spi->irq,
+			  CY_SPI_DATA_BUF_SIZE);
+
+	if (IS_ERR(ts))
+		return PTR_ERR(ts);
+
+	return 0;
+}
+
+static int cyttsp4_spi_remove(struct spi_device *spi)
+{
+	struct cyttsp4 *ts = spi_get_drvdata(spi);
+	cyttsp4_remove(ts);
+
+	return 0;
+}
+
+static struct spi_driver cyttsp4_spi_driver = {
+	.driver = {
+		.name	= CYTTSP4_SPI_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &cyttsp4_pm_ops,
+	},
+	.probe  = cyttsp4_spi_probe,
+	.remove = cyttsp4_spi_remove,
+};
+
+module_spi_driver(cyttsp4_spi_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) SPI driver");
+MODULE_AUTHOR("Cypress");
+MODULE_ALIAS("spi:cyttsp4");
-- 
1.7.9.5

