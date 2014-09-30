Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaI3Eqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:46:31 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37838 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaI3Eq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:46:27 -0400
Message-ID: <542A35B0.8040807@gmail.com>
Date: Mon, 29 Sep 2014 21:46:40 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org
CC: rajatjain@juniper.net, groeck@juniper.net
Subject: [PATCH 1/4] pci: Add I2C driver for the PLX PEX8xxx PCIe switch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver that allows talking to the I2C interface of the PLX PEX8xxx
family of PCI Express switches. More details about the need and use cases
have been described in the documentation being added as part of this
patchset.

Currently the devices supported and tested with this driver are:
PEX8614
PEX8618
PEX8713

It should be fairly straight forward to support other PLX8xxx devices,
since they use fairly similar command formats. Currently limited to
these 3 devices primarily due to lack of hardware for testing (on other
devices)..

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 drivers/pci/Kconfig             |   11 ++
 drivers/pci/Makefile            |    2 +
 drivers/pci/pex8xxx_i2c.c       |  258 +++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pex8xxx_i2c.h |   36 ++++++
 4 files changed, 307 insertions(+)
 create mode 100644 drivers/pci/pex8xxx_i2c.c
 create mode 100644 include/linux/i2c/pex8xxx_i2c.h

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 893503f..29233aa 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -115,4 +115,15 @@ config PCI_LABEL
 	def_bool y if (DMI || ACPI)
 	select NLS
 
+config PEX8XXX_I2C
+	tristate "PLX PEX8xxx Switch I2C interface driver"
+	depends on I2C
+	help
+	  Select this if you want I2C interface support for the PLX PEX8xxx
+	  family of PCI express switches. Currently this I2C driver supports
+	  PEX8614, PEX8618, PEX8713 switches. It provides read / write API
+	  calls to talk to the switch (over I2C).
+
+	  If built as a module, the driver will be called pex8xxx_i2c.
+
 source "drivers/pci/host/Kconfig"
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index e04fe2d..9759947 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -63,3 +63,5 @@ ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG
 
 # PCI host controller drivers
 obj-y += host/
+
+obj-$(CONFIG_PEX8XXX_I2C) 	+= pex8xxx_i2c.o
diff --git a/drivers/pci/pex8xxx_i2c.c b/drivers/pci/pex8xxx_i2c.c
new file mode 100644
index 0000000..ab59417
--- /dev/null
+++ b/drivers/pci/pex8xxx_i2c.c
@@ -0,0 +1,258 @@
+/*
+ * Driver for the PEX8xxx I2C slave interface
+ *
+ * Rajat Jain <rajatjain@juniper.net>
+ * Copyright 2014 Juniper Networks
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/i2c/pex8xxx_i2c.h>
+
+#define PCI_DEVICE_ID_PLX_8614	    0x8614
+#define PCI_DEVICE_ID_PLX_8618	    0x8618
+#define PCI_DEVICE_ID_PLX_8713	    0x8713
+
+/* Supported devices */
+enum chips { pex8614, pex8618, pex8713 };
+
+#define MAXSTN			    2
+#define MAXMODE			    4
+
+/* Common Register defines */
+#define PEX8XXX_CMD(val)	    (((val) & 7) << 24)
+#define PEX8XXX_CMD_WR		    0x03
+#define PEX8XXX_CMD_RD		    0x04
+
+#define PEX8XXX_BYTE_ENA(val)	    (((val) & 0xF) << 10)
+#define PEX8XXX_REG(val)	    (((val) >> 2) & 0x3FF)
+
+/* PEX8614/8618 Device specific register defines */
+#define PEX861X_PORT(val)	    (((val) & 0x1F) << 15)
+
+#define PEX861X_I2C_CMD(cmd, port, mode, stn, reg, byte_mask)	\
+	(PEX8XXX_CMD(cmd) |					\
+	 PEX861X_PORT(port) |					\
+	 PEX8XXX_BYTE_ENA(byte_mask) |				\
+	 PEX8XXX_REG(reg))
+
+/* PEX8713 Device specific register defines */
+#define PEX8713_MODE(val)	    (((val) & 3) << 20)
+#define PEX8713_STN(val)	    (((val) & 3) << 18)
+#define PEX8713_PORT(val)	    (((val) & 7) << 15)
+
+#define PEX8713_I2C_CMD(cmd, port, mode, stn, reg, byte_mask)	\
+	(PEX8XXX_CMD(cmd) |					\
+	 PEX8713_MODE(mode) |					\
+	 PEX8713_STN(stn) |					\
+	 PEX8713_PORT(port) |					\
+	 PEX8XXX_BYTE_ENA(byte_mask) |				\
+	 PEX8XXX_REG(reg))
+
+struct pex8xxx_dev {
+	enum chips	        devtype;
+};
+
+/**
+ * pex8xxx_read() - Read a (32 bit) register from the PEX8xxx device.
+ * @client:	struct i2c_client*, representing the pex8xxx device.
+ * @stn:	Station number (Used on some PLX switches such as PEX8713 that
+ *		support multi stations. Ignored on switches that don't support
+ *		it)
+ * @mode:	Port mode (Transparent / Non-transparent etc)
+ * @byte_mask:	Byte enable mask.
+ * @port:	Port number
+ * @reg:	Register offset to read.
+ * @val:	Pointer where the result is to be written.
+ *
+ * Return: 0 on Success, Error value otherwise.
+ */
+int pex8xxx_read(struct i2c_client *client, u8 stn, u8 mode, u8 byte_mask,
+		 u8 port, u32 reg, u32 *val)
+{
+	struct pex8xxx_dev *pex8xxx = i2c_get_clientdata(client);
+	__be32 cmd, data;
+	int ret;
+
+	struct i2c_msg msgs[2] = {
+		{
+			.addr = client->addr,
+			.len = 4,
+			.flags = 0,
+			.buf = (u8 *) &cmd,
+		},
+		{
+			.addr = client->addr,
+			.len = 4,
+			.flags = I2C_M_RD,
+			.buf = (u8 *) &data,
+		},
+	};
+
+	switch (pex8xxx->devtype) {
+	case pex8614:
+	case pex8618:
+		cmd = cpu_to_be32(PEX861X_I2C_CMD(PEX8XXX_CMD_RD, port, mode,
+						  stn, reg, byte_mask));
+		break;
+	case pex8713:
+		cmd = cpu_to_be32(PEX8713_I2C_CMD(PEX8XXX_CMD_RD, port, mode,
+						  stn, reg, byte_mask));
+		break;
+	default: /* Unknown device */
+		return -ENODEV;
+	}
+
+	ret = i2c_transfer(client->adapter, msgs, 2);
+	*val = be32_to_cpu(data);
+
+	if (ret < 0)
+		return ret;
+	else if (ret != ARRAY_SIZE(msgs))
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL(pex8xxx_read);
+
+/**
+ * pex8xxx_write() - Write a (32 bit) register to the PEX8xxx device.
+ * @client:	struct i2c_client*, representing the pex8xxx device.
+ * @stn:	Station number (Used on some PLX switches such as PEX8713 that
+ *		support multi stations. Ignored on switches that don't support
+ *		it)
+ * @mode:	Port mode (Transparent / Non-transparent etc)
+ * @byte_mask:	Byte enable mask.
+ * @port:	Port number
+ * @reg:	Register offset to write.
+ * @val:	Value to be written.
+ *
+ * Return: 0 on Success, Error value otherwise.
+ */
+int pex8xxx_write(struct i2c_client *client, u8 stn, u8 mode, u8 byte_mask,
+		  u8 port, u32 reg, u32 val)
+{
+	struct pex8xxx_dev *pex8xxx = i2c_get_clientdata(client);
+	__be32 msgbuf[2];
+	int ret;
+
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.len = 8,
+		.flags = 0,
+		.buf = (u8 *) msgbuf,
+	};
+
+	switch (pex8xxx->devtype) {
+	case pex8614:
+	case pex8618:
+		msgbuf[0] = cpu_to_be32(PEX861X_I2C_CMD(PEX8XXX_CMD_WR, port,
+							mode, stn, reg,
+							byte_mask));
+		break;
+	case pex8713:
+		msgbuf[0] = cpu_to_be32(PEX8713_I2C_CMD(PEX8XXX_CMD_WR, port,
+							mode, stn, reg,
+							byte_mask));
+		break;
+	default: /* Unknown device */
+		return -ENODEV;
+	}
+	msgbuf[1] = cpu_to_be32(val);
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+
+	if (ret < 0)
+		return ret;
+	else if (ret != 1)
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL(pex8xxx_write);
+
+static int pex8xxx_verify_device(struct pex8xxx_dev *pex8xxx,
+				 struct i2c_client *client)
+{
+	u8 stn, mode;
+	bool found = false;
+	u32 data = 0;
+
+	for (stn = 0; stn < MAXSTN; stn++) {
+		for (mode = 0; mode < MAXMODE; mode++) {
+			if (!pex8xxx_read(client, stn, mode, MASK_BYTE_ALL, 0,
+					  PCI_VENDOR_ID, &data)) {
+				found = true;
+				break;
+			}
+		}
+	}
+
+	if (!found || (data & 0xFFFF) != PCI_VENDOR_ID_PLX)
+		return -ENODEV;
+
+	switch (data >> 16) {
+	case PCI_DEVICE_ID_PLX_8614:
+		pex8xxx->devtype = pex8614;
+		break;
+	case PCI_DEVICE_ID_PLX_8618:
+		pex8xxx->devtype = pex8618;
+		break;
+	case PCI_DEVICE_ID_PLX_8713:
+		pex8xxx->devtype = pex8713;
+		break;
+	default:    /* Unsupported PLX device */
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int pex8xxx_probe(struct i2c_client *client,
+			 const struct i2c_device_id *dev_id)
+{
+	struct pex8xxx_dev *pex8xxx;
+
+	pex8xxx = devm_kzalloc(&client->dev, sizeof(*pex8xxx), GFP_KERNEL);
+	if (!pex8xxx)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, pex8xxx);
+
+	if (pex8xxx_verify_device(pex8xxx, client))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int pex8xxx_remove(struct i2c_client *client)
+{
+	return 0;
+}
+
+static const struct i2c_device_id pex8xxx_id[] = {
+	{ "pex8614", pex8614 },
+	{ "pex8618", pex8618 },
+	{ "pex8713", pex8713 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, pex8xxx_id);
+
+static struct i2c_driver pex8xxx_driver = {
+	.driver = {
+		.name	= "pex8xxx",
+	},
+	.probe	= pex8xxx_probe,
+	.remove	= pex8xxx_remove,
+	.id_table = pex8xxx_id,
+};
+
+module_i2c_driver(pex8xxx_driver);
+
+MODULE_DESCRIPTION("PLX PEX8xxx switch I2C interface driver");
+MODULE_AUTHOR("Rajat Jain <rajatjain@juniper.net>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/i2c/pex8xxx_i2c.h b/include/linux/i2c/pex8xxx_i2c.h
new file mode 100644
index 0000000..b60ad16
--- /dev/null
+++ b/include/linux/i2c/pex8xxx_i2c.h
@@ -0,0 +1,36 @@
+/*
+ * Interface for the PEX8xxx I2C slave interface
+ *
+ * Rajat Jain <rajatjain@juniper.net>
+ * Copyright 2014 Juniper Networks
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#ifndef __PEX8XXX_I2C_H__
+#define __PEX8XXX_I2C_H__
+
+#include <linux/i2c.h>
+
+/* Values for "mode" argument */
+#define MODE_TRANSPARENT	0x00
+#define MODE_NT_LINK		0x01
+#define MODE_NT_VIRT		0x02
+#define MODE_DMA		0x03
+
+/* Values for "byte_mask" argument */
+#define MASK_BYTE0		0x01
+#define MASK_BYTE1		0x02
+#define MASK_BYTE2		0x04
+#define MASK_BYTE3		0x08
+#define MASK_BYTE_ALL		(MASK_BYTE0 | MASK_BYTE1 |\
+				 MASK_BYTE2 | MASK_BYTE3)
+
+int pex8xxx_read(struct i2c_client *client, u8 stn, u8 mode, u8 byte_mask,
+		 u8 port, u32 reg, u32 *val);
+int pex8xxx_write(struct i2c_client *client, u8 stn, u8 mode, u8 byte_mask,
+		  u8 port, u32 reg, u32 val);
+
+#endif /* __PEX8XXX_I2C_H__ */
-- 
1.7.9.5

