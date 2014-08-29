Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaH2WFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:05:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:5490 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbaH2WFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:05:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378882476"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v2 2/3] i2c: add support for Diolan DLN-2 USB-I2C adapter
Date: Sat, 30 Aug 2014 01:00:53 +0300
Message-Id: <1409349654-24841-3-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409349654-24841-1-git-send-email-octavian.purdila@intel.com>
References: <1409349654-24841-1-git-send-email-octavian.purdila@intel.com>
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
---
 drivers/i2c/busses/Kconfig    |  10 ++
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 300 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 311 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-dln2.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 2ac87fa..4873161 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1021,4 +1021,14 @@ config SCx200_ACB
 	  This support is also available as a module.  If so, the module
 	  will be called scx200_acb.
 
+config I2C_DLN2
+       tristate "Diolan DLN-2 USB I2C adapter"
+       depends on USB && MFD_DLN2
+       help
+         If you say yes to this option, support will be included for Diolan
+         DLN2, a USB to I2C interface.
+
+         This driver can also be built as a module.  If so, the module
+         will be called i2c-dln2.
+
 endmenu
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 49bf07e..3118fea 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -100,5 +100,6 @@ obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
 obj-$(CONFIG_I2C_PCA_ISA)	+= i2c-pca-isa.o
 obj-$(CONFIG_I2C_SIBYTE)	+= i2c-sibyte.o
 obj-$(CONFIG_SCx200_ACB)	+= scx200_acb.o
+obj-$(CONFIG_I2C_DLN2)		+= i2c-dln2.o
 
 ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG
diff --git a/drivers/i2c/busses/i2c-dln2.c b/drivers/i2c/busses/i2c-dln2.c
new file mode 100644
index 0000000..cc1335a
--- /dev/null
+++ b/drivers/i2c/busses/i2c-dln2.c
@@ -0,0 +1,300 @@
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
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+
+#include <linux/platform_device.h>
+#include <linux/mfd/dln2.h>
+
+#define DRIVER_NAME			"dln2-i2c"
+
+#define DLN2_I2C_MODULE_ID		0x03
+#define DLN2_I2C_CMD(cmd)		DLN2_CMD(cmd, DLN2_I2C_MODULE_ID)
+
+/* I2C commands */
+#define DLN2_I2C_GET_PORT_COUNT		DLN2_I2C_CMD(0x00)
+#define DLN2_I2C_ENABLE			DLN2_I2C_CMD(0x01)
+#define DLN2_I2C_DISABLE			DLN2_I2C_CMD(0x02)
+#define DLN2_I2C_IS_ENABLED		DLN2_I2C_CMD(0x03)
+#define DLN2_I2C_SET_FREQUENCY		DLN2_I2C_CMD(0x04)
+#define DLN2_I2C_GET_FREQUENCY		DLN2_I2C_CMD(0x05)
+#define DLN2_I2C_WRITE			DLN2_I2C_CMD(0x06)
+#define DLN2_I2C_READ			DLN2_I2C_CMD(0x07)
+#define DLN2_I2C_SCAN_DEVICES		DLN2_I2C_CMD(0x08)
+#define DLN2_I2C_PULLUP_ENABLE		DLN2_I2C_CMD(0x09)
+#define DLN2_I2C_PULLUP_DISABLE		DLN2_I2C_CMD(0x0A)
+#define DLN2_I2C_PULLUP_IS_ENABLED	DLN2_I2C_CMD(0x0B)
+#define DLN2_I2C_TRANSFER		DLN2_I2C_CMD(0x0C)
+#define DLN2_I2C_SET_MAX_REPLY_COUNT	DLN2_I2C_CMD(0x0D)
+#define DLN2_I2C_GET_MAX_REPLY_COUNT	DLN2_I2C_CMD(0x0E)
+#define DLN2_I2C_GET_MIN_FREQUENCY	DLN2_I2C_CMD(0x40)
+#define DLN2_I2C_GET_MAX_FREQUENCY	DLN2_I2C_CMD(0x41)
+
+#define DLN2_I2C_FREQ_FAST		400000
+#define DLN2_I2C_FREQ_STD		100000
+
+#define DLN2_I2C_MAX_XFER_SIZE		256
+
+struct dln2_i2c {
+	struct platform_device *pdev;
+	struct i2c_adapter adapter;
+};
+
+static uint frequency = DLN2_I2C_FREQ_STD;	/* I2C clock frequency in Hz */
+
+module_param(frequency, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(frequency, "I2C clock frequency in hertz");
+
+static int dln2_i2c_set_state(struct dln2_i2c *dln2, u8 state)
+{
+	int ret;
+	u8 port = 0;
+
+	ret = dln2_transfer(dln2->pdev,
+			    state ? DLN2_I2C_ENABLE : DLN2_I2C_DISABLE,
+			    &port, sizeof(port), NULL, NULL);
+
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+#define dln2_i2c_enable(dln2)	dln2_i2c_set_state(dln2, 1)
+#define dln2_i2c_disable(dln2)	dln2_i2c_set_state(dln2, 0)
+
+static int dln2_i2c_set_frequency(struct dln2_i2c *dln2, u32 freq)
+{
+	int ret;
+	struct tx_data {
+		u8 port;
+		__le32 freq;
+	} __packed tx;
+
+	tx.port = 0;
+	tx.freq = cpu_to_le32(freq);
+
+	ret = dln2_transfer(dln2->pdev, DLN2_I2C_SET_FREQUENCY, &tx, sizeof(tx),
+			    NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int dln2_i2c_write(struct dln2_i2c *dln2, u8 addr,
+			  u8 *data, u16 data_len)
+{
+	int ret, len;
+	struct tx_data {
+		u8 port;
+		u8 addr;
+		u8 mem_addr_len;
+		__le32 mem_addr;
+		__le16 buf_len;
+		u8 buf[DLN2_I2C_MAX_XFER_SIZE];
+	} __packed tx;
+
+	if (data_len > DLN2_I2C_MAX_XFER_SIZE)
+		return -ENOSPC;
+
+	tx.port = 0;
+	tx.addr = addr;
+	tx.mem_addr_len = 0;
+	tx.mem_addr = 0;
+	tx.buf_len = cpu_to_le16(data_len);
+	memcpy(tx.buf, data, data_len);
+
+	len = sizeof(tx) + data_len - DLN2_I2C_MAX_XFER_SIZE;
+	ret = dln2_transfer(dln2->pdev, DLN2_I2C_WRITE, &tx, len,
+			    NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	return data_len;
+}
+
+static int dln2_i2c_read(struct dln2_i2c *dln2, u16 addr, u8 *data,
+			 u16 data_len)
+{
+	struct tx_data {
+		u8 port;
+		u8 addr;
+		u8 mem_addr_len;
+		__le32 mem_addr;
+		__le16 buf_len;
+	} __packed tx;
+	struct rx_data {
+		__le16 buf_len;
+		u8 buf[DLN2_I2C_MAX_XFER_SIZE];
+	} __packed rx;
+	int ret, buf_len, rx_len = sizeof(rx);
+
+	tx.port = 0;
+	tx.addr = addr;
+	tx.mem_addr_len = 0;
+	tx.mem_addr = 0;
+	tx.buf_len = cpu_to_le16(data_len);
+
+	ret = dln2_transfer(dln2->pdev, DLN2_I2C_READ, &tx, sizeof(tx),
+			    &rx, &rx_len);
+	if (ret < 0)
+		return ret;
+	if (rx_len < 2)
+		return -EPROTO;
+
+	buf_len = le16_to_cpu(rx.buf_len);
+	if (rx_len + sizeof(__le16) <  buf_len)
+		return -EPROTO;
+
+	memcpy(data, rx.buf, buf_len);
+
+	return buf_len;
+}
+
+static int dln2_i2c_setup(struct dln2_i2c *dln2)
+{
+	int ret;
+
+	ret = dln2_i2c_disable(dln2);
+	if (ret < 0)
+		return ret;
+
+	/* Set I2C frequency */
+	ret = dln2_i2c_set_frequency(dln2, frequency);
+	if (ret < 0)
+		return ret;
+
+	ret = dln2_i2c_enable(dln2);
+
+	return ret;
+}
+
+static int dln2_i2c_xfer(struct i2c_adapter *adapter,
+			 struct i2c_msg *msgs, int num)
+{
+	struct dln2_i2c *dln2 = i2c_get_adapdata(adapter);
+	struct i2c_msg *pmsg;
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < num; i++) {
+		pmsg = &msgs[i];
+
+		if (pmsg->len > DLN2_I2C_MAX_XFER_SIZE)
+			return -EINVAL;
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
+/*
+ * Return list of supported functionality.
+ */
+static u32 dln2_i2c_func(struct i2c_adapter *a)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_BYTE | I2C_FUNC_SMBUS_BYTE_DATA |
+		I2C_FUNC_SMBUS_WORD_DATA | I2C_FUNC_SMBUS_BLOCK_PROC_CALL;
+}
+
+static const struct i2c_algorithm dln2_i2c_usb_algorithm = {
+	.master_xfer = dln2_i2c_xfer,
+	.functionality = dln2_i2c_func,
+};
+
+/* device layer */
+
+static int dln2_i2c_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct device *dev = &pdev->dev;
+	struct dln2_i2c *dln2 = kzalloc(sizeof(*dln2), GFP_KERNEL);
+
+	if (!dln2)
+		return -ENOMEM;
+
+	dln2->pdev = pdev;
+
+	/* setup i2c adapter description */
+	dln2->adapter.owner = THIS_MODULE;
+	dln2->adapter.class = I2C_CLASS_HWMON;
+	dln2->adapter.algo = &dln2_i2c_usb_algorithm;
+	dln2->adapter.dev.parent = dev;
+	i2c_set_adapdata(&dln2->adapter, dln2);
+	snprintf(dln2->adapter.name, sizeof(dln2->adapter.name), DRIVER_NAME);
+
+	/* initialize the i2c interface */
+	ret = dln2_i2c_setup(dln2);
+	if (ret < 0) {
+		dev_err(dev, "failed to initialize adapter\n");
+		goto error_free;
+	}
+
+	/* and finally attach to i2c layer */
+	ret = i2c_add_adapter(&dln2->adapter);
+	if (ret < 0) {
+		dev_err(dev, "failed to add I2C adapter\n");
+		goto error_free;
+	}
+
+	platform_set_drvdata(pdev, dln2);
+
+	return 0;
+
+error_free:
+	kfree(dln2);
+
+	return ret;
+}
+
+static int dln2_i2c_remove(struct platform_device *pdev)
+{
+	struct dln2_i2c *dln2 = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&dln2->adapter);
+
+	return 0;
+}
+
+static struct platform_driver dln2_i2c_driver = {
+	.driver.name	= DRIVER_NAME,
+	.driver.owner	= THIS_MODULE,
+	.probe		= dln2_i2c_probe,
+	.remove		= dln2_i2c_remove,
+};
+
+module_platform_driver(dln2_i2c_driver);
+
+MODULE_AUTHOR("Laurentiu Palcu <laurentiu.palcu@intel.com>");
+MODULE_DESCRIPTION(DRIVER_NAME " driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

