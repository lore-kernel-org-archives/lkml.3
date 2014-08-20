Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaHTLUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:20:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:9085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaHTLUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:20:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="374704810"
From: Daniel Baluta <daniel.baluta@intel.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, wsa@the-dreams.de,
        linux-i2c@vger.kernel.org, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org
Cc: pratyush.anand@st.com, pebolle@tiscali.nl, stern@rowland.harvard.edu,
        octavian.purdila@intel.com, matthew@mjdsystems.ca,
        linux-kernel@vger.kernel.org, laurentiu.palcu@intel.com,
        daniel.baluta@intel.com, jdelvare@suse.de, arnd@arndb.de,
        sjg@chromium.org
Subject: [PATCH 2/3] i2c: add support for Diolan DLN-2 USB-I2C adapter
Date: Wed, 20 Aug 2014 14:24:46 +0300
Message-Id: <1408533887-22727-3-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408533887-22727-1-git-send-email-daniel.baluta@intel.com>
References: <1408533887-22727-1-git-send-email-daniel.baluta@intel.com>
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
---
 drivers/i2c/busses/Kconfig    |  11 ++
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 328 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 340 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-dln2.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 2ac87fa..06b1e89 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1021,4 +1021,15 @@ config SCx200_ACB
 	  This support is also available as a module.  If so, the module
 	  will be called scx200_acb.
 
+config I2C_DLN2
+       tristate "Diolan DLN-2 USB I2C adapter"
+       depends on USB
+       select USB_DLN2
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
index 0000000..7befbb0
--- /dev/null
+++ b/drivers/i2c/busses/i2c-dln2.c
@@ -0,0 +1,328 @@
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
+#include <linux/usb/dln2.h>
+#include <linux/i2c.h>
+
+#define DRIVER_NAME			"i2c-dln2"
+
+#define DLN2_I2C_MODULE_ID		0x03
+#define DLN2_I2C_CMD(cmd)		DLN2_CMD(cmd, DLN2_I2C_MODULE_ID)
+
+/* I2C commands */
+#define CMD_I2C_GET_PORT_COUNT		DLN2_I2C_CMD(0x00)
+#define CMD_I2C_ENABLE			DLN2_I2C_CMD(0x01)
+#define CMD_I2C_DISABLE			DLN2_I2C_CMD(0x02)
+#define CMD_I2C_IS_ENABLED		DLN2_I2C_CMD(0x03)
+#define CMD_I2C_SET_FREQUENCY		DLN2_I2C_CMD(0x04)
+#define CMD_I2C_GET_FREQUENCY		DLN2_I2C_CMD(0x05)
+#define CMD_I2C_WRITE			DLN2_I2C_CMD(0x06)
+#define CMD_I2C_READ			DLN2_I2C_CMD(0x07)
+#define CMD_I2C_SCAN_DEVICES		DLN2_I2C_CMD(0x08)
+#define CMD_I2C_PULLUP_ENABLE		DLN2_I2C_CMD(0x09)
+#define CMD_I2C_PULLUP_DISABLE		DLN2_I2C_CMD(0x0A)
+#define CMD_I2C_PULLUP_IS_ENABLED	DLN2_I2C_CMD(0x0B)
+#define CMD_I2C_TRANSFER		DLN2_I2C_CMD(0x0C)
+#define CMD_I2C_SET_MAX_REPLY_COUNT	DLN2_I2C_CMD(0x0D)
+#define CMD_I2C_GET_MAX_REPLY_COUNT	DLN2_I2C_CMD(0x0E)
+#define CMD_I2C_GET_MIN_FREQUENCY	DLN2_I2C_CMD(0x40)
+#define CMD_I2C_GET_MAX_FREQUENCY	DLN2_I2C_CMD(0x41)
+
+#define DLN2_I2C_FREQ_FAST		400000
+#define DLN2_I2C_FREQ_STD		100000
+
+#define DLN2_I2C_MAX_XFER_SIZE		256
+
+static struct dln2_mod *dln2_i2c_mod;
+
+/* Structure to hold all of our device specific stuff */
+struct dln2_i2c {
+	struct i2c_adapter adapter;	/* i2c related things */
+	struct dln2_dev *dln2;
+};
+
+static uint frequency = DLN2_I2C_FREQ_STD;	/* I2C clock frequency in Hz */
+
+module_param(frequency, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(frequency, "I2C clock frequency in hertz");
+
+static int dln2_i2c_set_state(struct dln2_i2c *dev, u8 state)
+{
+	int ret;
+	u8 port = 0;
+
+	ret = dln2_transfer(dev->dln2, dln2_i2c_mod,
+			    state ? CMD_I2C_ENABLE : CMD_I2C_DISABLE,
+			    &port, sizeof(port), NULL, NULL);
+
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+#define dln2_i2c_enable(dev)	dln2_i2c_set_state(dev, 1)
+#define dln2_i2c_disable(dev)	dln2_i2c_set_state(dev, 0)
+
+static int dln2_i2c_set_frequency(struct dln2_i2c *dev, u32 freq)
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
+	ret = dln2_transfer(dev->dln2, dln2_i2c_mod, CMD_I2C_SET_FREQUENCY,
+			    &tx, sizeof(tx), NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int dln2_i2c_write(struct dln2_i2c *dev, u8 addr,
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
+	ret = dln2_transfer(dev->dln2, dln2_i2c_mod, CMD_I2C_WRITE,
+			    &tx, len, NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	return data_len;
+}
+
+static int dln2_i2c_read(struct dln2_i2c *dev, u16 addr, u8 *data,
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
+	int ret, rx_len = sizeof(rx), buf_len;
+
+
+	tx.port = 0;
+	tx.addr = addr;
+	tx.mem_addr_len = 0;
+	tx.mem_addr = 0;
+	tx.buf_len = cpu_to_le16(data_len);
+
+	ret = dln2_transfer(dev->dln2, dln2_i2c_mod, CMD_I2C_READ, &tx,
+			    sizeof(tx), &rx, &rx_len);
+	if (ret < 0)
+		return ret;
+
+	buf_len = le16_to_cpu(rx.buf_len);
+
+	if (rx_len < buf_len) {
+		dev_warn(&dev->adapter.dev, "RX len mismatch: %d %d\n",
+			 rx_len, buf_len);
+		buf_len = rx_len;
+	}
+
+	dev_dbg(&dev->adapter.dev, "Rcvd: %d bytes", buf_len);
+
+	memcpy(data, rx.buf, min(rx_len, buf_len));
+
+	return rx_len;
+}
+
+static int dln2_i2c_setup(struct dln2_i2c *dev)
+{
+	int ret;
+
+	ret = dln2_i2c_disable(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Set I2C frequency */
+	ret = dln2_i2c_set_frequency(dev, frequency);
+	if (ret < 0)
+		return ret;
+
+	ret = dln2_i2c_enable(dev);
+
+	return ret;
+}
+
+static int dln2_i2c_xfer(struct i2c_adapter *adapter,
+			 struct i2c_msg *msgs, int num)
+{
+	struct dln2_i2c *dev = i2c_get_adapdata(adapter);
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
+			ret = dln2_i2c_read(dev, pmsg->addr, pmsg->buf,
+					    pmsg->len);
+			if (ret < 0)
+				return ret;
+
+			pmsg->len = ret;
+		} else {
+			ret = dln2_i2c_write(dev, pmsg->addr, pmsg->buf,
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
+static int dln2_i2c_connect(struct dln2_dev *dln2)
+{
+	int ret;
+	struct dln2_i2c *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+
+	if (!dev)
+		return -ENOMEM;
+
+	/* setup i2c adapter description */
+	dev->adapter.owner = THIS_MODULE;
+	dev->adapter.class = I2C_CLASS_HWMON;
+	dev->adapter.algo = &dln2_i2c_usb_algorithm;
+	i2c_set_adapdata(&dev->adapter, dev);
+	snprintf(dev->adapter.name, sizeof(dev->adapter.name), DRIVER_NAME);
+
+	dev->adapter.dev.parent = dln2_get_device(dln2);
+
+	dev->dln2 = dln2;
+	dln2_set_dev_context(dln2, dln2_i2c_mod, dev);
+
+	/* initialize the i2c interface */
+	ret = dln2_i2c_setup(dev);
+	if (ret < 0) {
+		dev_err(&dev->adapter.dev, "failed to initialize adapter\n");
+		goto error_free;
+	}
+
+	/* and finally attach to i2c layer */
+	ret = i2c_add_adapter(&dev->adapter);
+	if (ret < 0) {
+		dev_err(&dev->adapter.dev, "failed to add I2C adapter\n");
+		goto error_free;
+	}
+
+	dev_dbg(&dev->adapter.dev, "connected " DRIVER_NAME "\n");
+
+	return 0;
+
+error_free:
+	kfree(dev);
+
+	return ret;
+}
+
+static void dln2_i2c_disconnect(struct dln2_dev *dln2)
+{
+	struct dln2_i2c *dev = dln2_get_dev_context(dln2, dln2_i2c_mod);
+
+	i2c_del_adapter(&dev->adapter);
+
+	dev_dbg(&dev->adapter.dev, "disconnected" DRIVER_NAME "\n");
+}
+
+static struct dln2_mod_ops dln2_i2c_ops = {
+	.name = DRIVER_NAME,
+	.connect = dln2_i2c_connect,
+	.disconnect = dln2_i2c_disconnect,
+};
+
+static int __init dln2_i2c_init(void)
+{
+	int err;
+
+	dln2_i2c_mod = dln2_register_module(-1, &dln2_i2c_ops);
+
+	if (IS_ERR(dln2_i2c_mod)) {
+		err = PTR_ERR(dln2_i2c_mod);
+		dln2_i2c_mod = NULL;
+		pr_err(DRIVER_NAME "dln2_register_module failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+module_init(dln2_i2c_init);
+
+static void __exit dln2_i2c_exit(void)
+{
+	if (dln2_i2c_mod)
+		dln2_unregister_module(dln2_i2c_mod);
+}
+module_exit(dln2_i2c_exit);
+
+MODULE_AUTHOR("Laurentiu Palcu <laurentiu.palcu@intel.com>");
+MODULE_DESCRIPTION(DRIVER_NAME " driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

