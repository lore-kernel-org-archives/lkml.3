Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3FDJfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:35:38 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39767 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3FDJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:35:30 -0400
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
Subject: [PATCH v3 1/4] Input: cyttsp - I2C driver split into two modules
Date: Tue,  4 Jun 2013 12:34:41 +0300
Message-Id: <1370338484-26573-2-git-send-email-fery@cypress.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370338484-26573-1-git-send-email-fery@cypress.com>
References: <1370338484-26573-1-git-send-email-fery@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing I2C code is for TrueTouch Gen3 devices

TrueTouch Gen4 device is using same protocol, will split driver into
two pieces to use common code with both drivers.

Read/Write functions parameter list modified, since shared code will
be used by two separate drivers and these drivers are not sharing same
structs, parameters updated to use common structures.

Signed-off-by: Ferruh Yigit <fery@cypress.com>
---
 drivers/input/touchscreen/Makefile            |    2 +-
 drivers/input/touchscreen/cyttsp_core.c       |    6 +-
 drivers/input/touchscreen/cyttsp_core.h       |   11 +++-
 drivers/input/touchscreen/cyttsp_i2c.c        |   50 +---------------
 drivers/input/touchscreen/cyttsp_i2c_common.c |   79 +++++++++++++++++++++++++
 drivers/input/touchscreen/cyttsp_spi.c        |   38 ++++++------
 6 files changed, 112 insertions(+), 74 deletions(-)
 create mode 100644 drivers/input/touchscreen/cyttsp_i2c_common.c

diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 6bfbeab..2b378b1 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_TOUCHSCREEN_AUO_PIXCIR)	+= auo-pixcir-ts.o
 obj-$(CONFIG_TOUCHSCREEN_BU21013)	+= bu21013_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)	+= cy8ctmg110_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)	+= cyttsp_core.o
-obj-$(CONFIG_TOUCHSCREEN_CYTTSP_I2C)	+= cyttsp_i2c.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP_I2C)	+= cyttsp_i2c.o cyttsp_i2c_common.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP_SPI)	+= cyttsp_spi.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
 obj-$(CONFIG_TOUCHSCREEN_DA9052)	+= da9052_tsi.o
diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
index 8e60437..4824fa3 100644
--- a/drivers/input/touchscreen/cyttsp_core.c
+++ b/drivers/input/touchscreen/cyttsp_core.c
@@ -84,7 +84,8 @@ static int ttsp_read_block_data(struct cyttsp *ts, u8 command,
 	int tries;
 
 	for (tries = 0; tries < CY_NUM_RETRY; tries++) {
-		error = ts->bus_ops->read(ts, command, length, buf);
+		error = ts->bus_ops->read(ts->dev, ts->xfer_buf, command,
+				length, buf);
 		if (!error)
 			return 0;
 
@@ -101,7 +102,8 @@ static int ttsp_write_block_data(struct cyttsp *ts, u8 command,
 	int tries;
 
 	for (tries = 0; tries < CY_NUM_RETRY; tries++) {
-		error = ts->bus_ops->write(ts, command, length, buf);
+		error = ts->bus_ops->write(ts->dev, ts->xfer_buf, command,
+				length, buf);
 		if (!error)
 			return 0;
 
diff --git a/drivers/input/touchscreen/cyttsp_core.h b/drivers/input/touchscreen/cyttsp_core.h
index 1aa3c69..d0c9e48 100644
--- a/drivers/input/touchscreen/cyttsp_core.h
+++ b/drivers/input/touchscreen/cyttsp_core.h
@@ -112,9 +112,10 @@ struct cyttsp;
 
 struct cyttsp_bus_ops {
 	u16 bustype;
-	int (*write)(struct cyttsp *ts,
-		     u8 addr, u8 length, const void *values);
-	int (*read)(struct cyttsp *ts, u8 addr, u8 length, void *values);
+	int (*write)(struct device *dev, u8 *xfer_buf, u8 addr, u8 length,
+			const void *values);
+	int (*read)(struct device *dev, u8 *xfer_buf, u8 addr, u8 length,
+			void *values);
 };
 
 enum cyttsp_state {
@@ -144,6 +145,10 @@ struct cyttsp *cyttsp_probe(const struct cyttsp_bus_ops *bus_ops,
 			    struct device *dev, int irq, size_t xfer_buf_size);
 void cyttsp_remove(struct cyttsp *ts);
 
+int cyttsp_i2c_write_block_data(struct device *dev, u8 *xfer_buf, u8 addr,
+		u8 length, const void *values);
+int cyttsp_i2c_read_block_data(struct device *dev, u8 *xfer_buf, u8 addr,
+		u8 length, void *values);
 extern const struct dev_pm_ops cyttsp_pm_ops;
 
 #endif /* __CYTTSP_CORE_H__ */
diff --git a/drivers/input/touchscreen/cyttsp_i2c.c b/drivers/input/touchscreen/cyttsp_i2c.c
index 4dbdf44..63104a8 100644
--- a/drivers/input/touchscreen/cyttsp_i2c.c
+++ b/drivers/input/touchscreen/cyttsp_i2c.c
@@ -1,5 +1,5 @@
 /*
- * Source for:
+ * cyttsp_i2c.c
  * Cypress TrueTouch(TM) Standard Product (TTSP) I2C touchscreen driver.
  * For use with Cypress Txx3xx parts.
  * Supported parts include:
@@ -19,11 +19,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
- *
- * Contact Cypress Semiconductor at www.cypress.com <kev@cypress.com>
+ * Contact Cypress Semiconductor at www.cypress.com <ttdrivers@cypress.com>
  *
  */
 
@@ -34,47 +30,6 @@
 
 #define CY_I2C_DATA_SIZE	128
 
-static int cyttsp_i2c_read_block_data(struct cyttsp *ts,
-				      u8 addr, u8 length, void *values)
-{
-	struct i2c_client *client = to_i2c_client(ts->dev);
-	struct i2c_msg msgs[] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &addr,
-		},
-		{
-			.addr = client->addr,
-			.flags = I2C_M_RD,
-			.len = length,
-			.buf = values,
-		},
-	};
-	int retval;
-
-	retval = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
-	if (retval < 0)
-		return retval;
-
-	return retval != ARRAY_SIZE(msgs) ? -EIO : 0;
-}
-
-static int cyttsp_i2c_write_block_data(struct cyttsp *ts,
-				       u8 addr, u8 length, const void *values)
-{
-	struct i2c_client *client = to_i2c_client(ts->dev);
-	int retval;
-
-	ts->xfer_buf[0] = addr;
-	memcpy(&ts->xfer_buf[1], values, length);
-
-	retval = i2c_master_send(client, ts->xfer_buf, length + 1);
-
-	return retval < 0 ? retval : 0;
-}
-
 static const struct cyttsp_bus_ops cyttsp_i2c_bus_ops = {
 	.bustype	= BUS_I2C,
 	.write		= cyttsp_i2c_write_block_data,
@@ -98,7 +53,6 @@ static int cyttsp_i2c_probe(struct i2c_client *client,
 		return PTR_ERR(ts);
 
 	i2c_set_clientdata(client, ts);
-
 	return 0;
 }
 
diff --git a/drivers/input/touchscreen/cyttsp_i2c_common.c b/drivers/input/touchscreen/cyttsp_i2c_common.c
new file mode 100644
index 0000000..07c553f
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp_i2c_common.c
@@ -0,0 +1,79 @@
+/*
+ * cyttsp_i2c_common.c
+ * Cypress TrueTouch(TM) Standard Product (TTSP) I2C touchscreen driver.
+ * For use with Cypress Txx3xx and Txx4xx parts.
+ * Supported parts include:
+ * CY8CTST341
+ * CY8CTMA340
+ * TMA4XX
+ * TMA1036
+ *
+ * Copyright (C) 2009, 2010, 2011 Cypress Semiconductor, Inc.
+ * Copyright (C) 2012 Javier Martinez Canillas <javier@dowhile0.org>
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
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+int cyttsp_i2c_read_block_data(struct device *dev, u8 *xfer_buf,
+				      u8 addr, u8 length, void *values)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_msg msgs[] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = 1,
+			.buf = &addr,
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = length,
+			.buf = values,
+		},
+	};
+	int retval;
+
+	retval = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+	if (retval < 0)
+		return retval;
+
+	return retval != ARRAY_SIZE(msgs) ? -EIO : 0;
+}
+EXPORT_SYMBOL_GPL(cyttsp_i2c_read_block_data);
+
+int cyttsp_i2c_write_block_data(struct device *dev, u8 *xfer_buf,
+				       u8 addr, u8 length, const void *values)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int retval;
+
+	xfer_buf[0] = addr;
+	memcpy(&xfer_buf[1], values, length);
+
+	retval = i2c_master_send(client, xfer_buf, length + 1);
+
+	return retval < 0 ? retval : 0;
+}
+EXPORT_SYMBOL_GPL(cyttsp_i2c_write_block_data);
+
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Cypress");
diff --git a/drivers/input/touchscreen/cyttsp_spi.c b/drivers/input/touchscreen/cyttsp_spi.c
index 861b7f7..1df6253 100644
--- a/drivers/input/touchscreen/cyttsp_spi.c
+++ b/drivers/input/touchscreen/cyttsp_spi.c
@@ -8,6 +8,7 @@
  *
  * Copyright (C) 2009, 2010, 2011 Cypress Semiconductor, Inc.
  * Copyright (C) 2012 Javier Martinez Canillas <javier@dowhile0.org>
+ * Copyright (C) 2013 Cypress Semiconductor
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -19,11 +20,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
- *
- * Contact Cypress Semiconductor at www.cypress.com <kev@cypress.com>
+ * Contact Cypress Semiconductor at www.cypress.com <ttdrivers@cypress.com>
  *
  */
 
@@ -43,19 +40,19 @@
 #define CY_SPI_DATA_BUF_SIZE	(CY_SPI_CMD_BYTES + CY_SPI_DATA_SIZE)
 #define CY_SPI_BITS_PER_WORD	8
 
-static int cyttsp_spi_xfer(struct cyttsp *ts,
+static int cyttsp_spi_xfer(struct device *dev, u8 *xfer_buf,
 			   u8 op, u8 reg, u8 *buf, int length)
 {
-	struct spi_device *spi = to_spi_device(ts->dev);
+	struct spi_device *spi = to_spi_device(dev);
 	struct spi_message msg;
 	struct spi_transfer xfer[2];
-	u8 *wr_buf = &ts->xfer_buf[0];
-	u8 *rd_buf = &ts->xfer_buf[CY_SPI_DATA_BUF_SIZE];
+	u8 *wr_buf = &xfer_buf[0];
+	u8 *rd_buf = &xfer_buf[CY_SPI_DATA_BUF_SIZE];
 	int retval;
 	int i;
 
 	if (length > CY_SPI_DATA_SIZE) {
-		dev_err(ts->dev, "%s: length %d is too big.\n",
+		dev_err(dev, "%s: length %d is too big.\n",
 			__func__, length);
 		return -EINVAL;
 	}
@@ -95,13 +92,13 @@ static int cyttsp_spi_xfer(struct cyttsp *ts,
 		break;
 
 	default:
-		dev_err(ts->dev, "%s: bad operation code=%d\n", __func__, op);
+		dev_err(dev, "%s: bad operation code=%d\n", __func__, op);
 		return -EINVAL;
 	}
 
 	retval = spi_sync(spi, &msg);
 	if (retval < 0) {
-		dev_dbg(ts->dev, "%s: spi_sync() error %d, len=%d, op=%d\n",
+		dev_dbg(dev, "%s: spi_sync() error %d, len=%d, op=%d\n",
 			__func__, retval, xfer[1].len, op);
 
 		/*
@@ -113,14 +110,13 @@ static int cyttsp_spi_xfer(struct cyttsp *ts,
 
 	if (rd_buf[CY_SPI_SYNC_BYTE] != CY_SPI_SYNC_ACK1 ||
 	    rd_buf[CY_SPI_SYNC_BYTE + 1] != CY_SPI_SYNC_ACK2) {
-
-		dev_dbg(ts->dev, "%s: operation %d failed\n", __func__, op);
+		dev_dbg(dev, "%s: operation %d failed\n", __func__, op);
 
 		for (i = 0; i < CY_SPI_CMD_BYTES; i++)
-			dev_dbg(ts->dev, "%s: test rd_buf[%d]:0x%02x\n",
+			dev_dbg(dev, "%s: test rd_buf[%d]:0x%02x\n",
 				__func__, i, rd_buf[i]);
 		for (i = 0; i < length; i++)
-			dev_dbg(ts->dev, "%s: test buf[%d]:0x%02x\n",
+			dev_dbg(dev, "%s: test buf[%d]:0x%02x\n",
 				__func__, i, buf[i]);
 
 		return -EIO;
@@ -129,16 +125,18 @@ static int cyttsp_spi_xfer(struct cyttsp *ts,
 	return 0;
 }
 
-static int cyttsp_spi_read_block_data(struct cyttsp *ts,
+static int cyttsp_spi_read_block_data(struct device *dev, u8 *xfer_buf,
 				      u8 addr, u8 length, void *data)
 {
-	return cyttsp_spi_xfer(ts, CY_SPI_RD_OP, addr, data, length);
+	return cyttsp_spi_xfer(dev, xfer_buf, CY_SPI_RD_OP, addr, data,
+			length);
 }
 
-static int cyttsp_spi_write_block_data(struct cyttsp *ts,
+static int cyttsp_spi_write_block_data(struct device *dev, u8 *xfer_buf,
 				       u8 addr, u8 length, const void *data)
 {
-	return cyttsp_spi_xfer(ts, CY_SPI_WR_OP, addr, (void *)data, length);
+	return cyttsp_spi_xfer(dev, xfer_buf, CY_SPI_WR_OP, addr, (void *)data,
+			length);
 }
 
 static const struct cyttsp_bus_ops cyttsp_spi_bus_ops = {
-- 
1.7.9.5

