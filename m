Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaKERFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:05:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:28009 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbaKERFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:05:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="602871957"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v10 2/3] i2c: add support for Diolan DLN-2 USB-I2C adapter
Date: Wed,  5 Nov 2014 19:05:00 +0200
Message-Id: <1415207101-16461-3-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415207101-16461-1-git-send-email-octavian.purdila@intel.com>
References: <1415207101-16461-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurentiu Palcu <laurentiu.palcu@intel.com>

This patch adds support for the Diolan DLN-2 I2C master module. Due
to hardware limitations it does not support SMBUS quick commands.

Information about the USB protocol interface can be found in the
Programmer's Reference Manual [1], see section 6.2.2 for the I2C
master module commands and responses.

[1] https://www.diolan.com/downloads/dln-api-manual.pdf

Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Acked-by: Wolfram Sang <wsa@the-dreams.de>
Reviewed-by: Johan Hovold <johan@kernel.org>
---
 drivers/i2c/busses/Kconfig    |  10 ++
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 267 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 278 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-dln2.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 917c358..059e846 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -881,6 +881,16 @@ config I2C_DIOLAN_U2C
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-diolan-u2c.
 
+config I2C_DLN2
+       tristate "Diolan DLN-2 USB I2C adapter"
+       depends on MFD_DLN2
+       help
+         If you say yes to this option, support will be included for Diolan
+         DLN2, a USB to I2C interface.
+
+         This driver can also be built as a module.  If so, the module
+         will be called i2c-dln2.
+
 config I2C_PARPORT
 	tristate "Parallel port adapter"
 	depends on PARPORT
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 78d56c5..cdac7f1 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_I2C_RCAR)		+= i2c-rcar.o
 
 # External I2C/SMBus adapter drivers
 obj-$(CONFIG_I2C_DIOLAN_U2C)	+= i2c-diolan-u2c.o
+obj-$(CONFIG_I2C_DLN2)		+= i2c-dln2.o
 obj-$(CONFIG_I2C_PARPORT)	+= i2c-parport.o
 obj-$(CONFIG_I2C_PARPORT_LIGHT)	+= i2c-parport-light.o
 obj-$(CONFIG_I2C_ROBOTFUZZ_OSIF)	+= i2c-robotfuzz-osif.o
diff --git a/drivers/i2c/busses/i2c-dln2.c b/drivers/i2c/busses/i2c-dln2.c
new file mode 100644
index 0000000..010a5fa
--- /dev/null
+++ b/drivers/i2c/busses/i2c-dln2.c
@@ -0,0 +1,267 @@
+/*
+ * Driver for the Diolan DLN-2 USB-I2C adapter
+ *
+ * Copyright (c) 2014 Intel Corporation
+ *
+ * Derived from:
+ *  i2c-diolan-u2c.c
+ *  Copyright (c) 2010-2011 Ericsson AB
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/dln2.h>
+
+#define DLN2_I2C_MODULE_ID		0x03
+#define DLN2_I2C_CMD(cmd)		DLN2_CMD(cmd, DLN2_I2C_MODULE_ID)
+
+/* I2C commands */
+#define DLN2_I2C_GET_PORT_COUNT		DLN2_I2C_CMD(0x00)
+#define DLN2_I2C_ENABLE			DLN2_I2C_CMD(0x01)
+#define DLN2_I2C_DISABLE		DLN2_I2C_CMD(0x02)
+#define DLN2_I2C_IS_ENABLED		DLN2_I2C_CMD(0x03)
+#define DLN2_I2C_WRITE			DLN2_I2C_CMD(0x06)
+#define DLN2_I2C_READ			DLN2_I2C_CMD(0x07)
+#define DLN2_I2C_SCAN_DEVICES		DLN2_I2C_CMD(0x08)
+#define DLN2_I2C_PULLUP_ENABLE		DLN2_I2C_CMD(0x09)
+#define DLN2_I2C_PULLUP_DISABLE		DLN2_I2C_CMD(0x0A)
+#define DLN2_I2C_PULLUP_IS_ENABLED	DLN2_I2C_CMD(0x0B)
+#define DLN2_I2C_TRANSFER		DLN2_I2C_CMD(0x0C)
+#define DLN2_I2C_SET_MAX_REPLY_COUNT	DLN2_I2C_CMD(0x0D)
+#define DLN2_I2C_GET_MAX_REPLY_COUNT	DLN2_I2C_CMD(0x0E)
+
+#define DLN2_I2C_MAX_XFER_SIZE		256
+#define DLN2_I2C_BUF_SIZE		(DLN2_I2C_MAX_XFER_SIZE + 16)
+
+struct dln2_i2c {
+	struct platform_device *pdev;
+	struct i2c_adapter adapter;
+	u8 port;
+	/*
+	 * Buffer to hold the packet for read or write transfers. One is enough
+	 * since we can't have multiple transfers in parallel on the i2c bus.
+	 */
+	void *buf;
+};
+
+static int dln2_i2c_enable(struct dln2_i2c *dln2, bool enable)
+{
+	int ret;
+	u16 cmd;
+	struct {
+		u8 port;
+	} tx;
+
+	tx.port = dln2->port;
+
+	if (enable)
+		cmd = DLN2_I2C_ENABLE;
+	else
+		cmd = DLN2_I2C_DISABLE;
+
+	ret = dln2_transfer_tx(dln2->pdev, cmd, &tx, sizeof(tx));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int dln2_i2c_write(struct dln2_i2c *dln2, u8 addr,
+			  u8 *data, u16 data_len)
+{
+	int ret;
+	struct {
+		u8 port;
+		u8 addr;
+		u8 mem_addr_len;
+		__le32 mem_addr;
+		__le16 buf_len;
+		u8 buf[DLN2_I2C_MAX_XFER_SIZE];
+	} __packed *tx = dln2->buf;
+	unsigned len;
+
+	BUILD_BUG_ON(sizeof(*tx) > DLN2_I2C_BUF_SIZE);
+
+	tx->port = dln2->port;
+	tx->addr = addr;
+	tx->mem_addr_len = 0;
+	tx->mem_addr = 0;
+	tx->buf_len = cpu_to_le16(data_len);
+	memcpy(tx->buf, data, data_len);
+
+	len = sizeof(*tx) + data_len - DLN2_I2C_MAX_XFER_SIZE;
+	ret = dln2_transfer_tx(dln2->pdev, DLN2_I2C_WRITE, tx, len);
+	if (ret < 0)
+		return ret;
+
+	return data_len;
+}
+
+static int dln2_i2c_read(struct dln2_i2c *dln2, u16 addr, u8 *data,
+			 u16 data_len)
+{
+	int ret;
+	struct {
+		u8 port;
+		u8 addr;
+		u8 mem_addr_len;
+		__le32 mem_addr;
+		__le16 buf_len;
+	} __packed tx;
+	struct {
+		__le16 buf_len;
+		u8 buf[DLN2_I2C_MAX_XFER_SIZE];
+	} __packed *rx = dln2->buf;
+	unsigned rx_len = sizeof(*rx);
+
+	BUILD_BUG_ON(sizeof(*rx) > DLN2_I2C_BUF_SIZE);
+
+	tx.port = dln2->port;
+	tx.addr = addr;
+	tx.mem_addr_len = 0;
+	tx.mem_addr = 0;
+	tx.buf_len = cpu_to_le16(data_len);
+
+	ret = dln2_transfer(dln2->pdev, DLN2_I2C_READ, &tx, sizeof(tx),
+			    rx, &rx_len);
+	if (ret < 0)
+		return ret;
+	if (rx_len < sizeof(rx->buf_len) + data_len)
+		return -EPROTO;
+	if (le16_to_cpu(rx->buf_len) != data_len)
+		return -EPROTO;
+
+	memcpy(data, rx->buf, data_len);
+
+	return data_len;
+}
+
+static int dln2_i2c_xfer(struct i2c_adapter *adapter,
+			 struct i2c_msg *msgs, int num)
+{
+	struct dln2_i2c *dln2 = i2c_get_adapdata(adapter);
+	struct i2c_msg *pmsg;
+	struct device *dev = &dln2->adapter.dev;
+	int i;
+
+	for (i = 0; i < num; i++) {
+		int ret;
+
+		pmsg = &msgs[i];
+
+		if (pmsg->len > DLN2_I2C_MAX_XFER_SIZE) {
+			dev_warn(dev, "maximum transfer size exceeded\n");
+			return -EOPNOTSUPP;
+		}
+
+		if (pmsg->flags & I2C_M_RD) {
+			ret = dln2_i2c_read(dln2, pmsg->addr, pmsg->buf,
+					    pmsg->len);
+			if (ret < 0)
+				return ret;
+
+			pmsg->len = ret;
+		} else {
+			ret = dln2_i2c_write(dln2, pmsg->addr, pmsg->buf,
+					     pmsg->len);
+			if (ret != pmsg->len)
+				return -EPROTO;
+		}
+	}
+
+	return num;
+}
+
+static u32 dln2_i2c_func(struct i2c_adapter *a)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_BYTE | I2C_FUNC_SMBUS_BYTE_DATA |
+		I2C_FUNC_SMBUS_WORD_DATA | I2C_FUNC_SMBUS_BLOCK_PROC_CALL |
+		I2C_FUNC_SMBUS_I2C_BLOCK;
+}
+
+static const struct i2c_algorithm dln2_i2c_usb_algorithm = {
+	.master_xfer = dln2_i2c_xfer,
+	.functionality = dln2_i2c_func,
+};
+
+static int dln2_i2c_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct dln2_i2c *dln2;
+	struct device *dev = &pdev->dev;
+	struct dln2_platform_data *pdata = dev_get_platdata(&pdev->dev);
+
+	dln2 = devm_kzalloc(dev, sizeof(*dln2), GFP_KERNEL);
+	if (!dln2)
+		return -ENOMEM;
+
+	dln2->buf = devm_kmalloc(dev, DLN2_I2C_BUF_SIZE, GFP_KERNEL);
+	if (!dln2->buf)
+		return -ENOMEM;
+
+	dln2->pdev = pdev;
+	dln2->port = pdata->port;
+
+	/* setup i2c adapter description */
+	dln2->adapter.owner = THIS_MODULE;
+	dln2->adapter.class = I2C_CLASS_HWMON;
+	dln2->adapter.algo = &dln2_i2c_usb_algorithm;
+	dln2->adapter.dev.parent = dev;
+	i2c_set_adapdata(&dln2->adapter, dln2);
+	snprintf(dln2->adapter.name, sizeof(dln2->adapter.name), "%s-%s-%d",
+		 "dln2-i2c", dev_name(pdev->dev.parent), dln2->port);
+
+	platform_set_drvdata(pdev, dln2);
+
+	/* initialize the i2c interface */
+	ret = dln2_i2c_enable(dln2, true);
+	if (ret < 0) {
+		dev_err(dev, "failed to initialize adapter: %d\n", ret);
+		return ret;
+	}
+
+	/* and finally attach to i2c layer */
+	ret = i2c_add_adapter(&dln2->adapter);
+	if (ret < 0) {
+		dev_err(dev, "failed to add I2C adapter: %d\n", ret);
+		goto out_disable;
+	}
+
+	return 0;
+
+out_disable:
+	dln2_i2c_enable(dln2, false);
+
+	return ret;
+}
+
+static int dln2_i2c_remove(struct platform_device *pdev)
+{
+	struct dln2_i2c *dln2 = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&dln2->adapter);
+	dln2_i2c_enable(dln2, false);
+
+	return 0;
+}
+
+static struct platform_driver dln2_i2c_driver = {
+	.driver.name	= "dln2-i2c",
+	.probe		= dln2_i2c_probe,
+	.remove		= dln2_i2c_remove,
+};
+
+module_platform_driver(dln2_i2c_driver);
+
+MODULE_AUTHOR("Laurentiu Palcu <laurentiu.palcu@intel.com>");
+MODULE_DESCRIPTION("Driver for the Diolan DLN2 I2C master interface");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:dln2-i2c");
-- 
1.9.1

