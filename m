Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaE2GPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:15:55 -0400
Received: from acledge3.advantech.com.tw ([219.90.3.242]:58843 "EHLO
	acledge3.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaE2GPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:15:53 -0400
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa@the-dreams.de>
CC: "Louis.Lu" <Louis.Lu@advantech.com.tw>, "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: [PATCH 3/3] i2c: iManager2: add support for IT8516/18/28
Date: Wed, 28 May 2014 22:57:16 -0700
Message-ID: <1401343036-26159-3-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401343036-26159-1-git-send-email-weichun.pan@advantech.com.tw>
References: <1401343036-26159-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Advantech's new module comes equipped with "iManager" - an embedded controller (EC), providing embedded features for system integrators to increase reliability and simplify integration.
    This patch add the MFD driver for enabling Advantech iManager V2.0 chipset. Available functions support I2C base on ITE-IT85XX chip. These functions are tested on Advantech SOM-5892 board. All the embedded functions are configured by a utility. Advantech has done all the hard work for user with the release of a suite of Software APIs.
    These provide not only the underlying drivers required but also a rich set of user-friendly, intelligent and integrated interfaces, which speeds development, enhances security and offers add-on value for Advantech platforms.

Signed-off-by: Wei-Chun Pan Developer <weichun.pan@advantech.com.tw>
---
 drivers/i2c/busses/Kconfig         |   8 ++
 drivers/i2c/busses/Makefile        |   1 +
 drivers/i2c/busses/imanager2_i2c.c | 257 +++++++++++++++++++++++++++++++++++++
 drivers/i2c/busses/imanager2_i2c.h |  38 ++++++
 4 files changed, 304 insertions(+)
 mode change 100644 => 100755 drivers/i2c/busses/Kconfig
 mode change 100644 => 100755 drivers/i2c/busses/Makefile
 create mode 100755 drivers/i2c/busses/imanager2_i2c.c
 create mode 100755 drivers/i2c/busses/imanager2_i2c.h

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
old mode 100644
new mode 100755
index c94db1c..8aad058
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -8,6 +8,14 @@ menu "I2C Hardware Bus support"
 comment "PC SMBus host controller drivers"
 	depends on PCI
 
+config I2C_IMANAGER2
+	tristate "Support for Advantech iManager2 EC I2C"
+	select MFD_CORE
+	select MFD_IMANAGER2
+	depends on I2C=y
+	help
+	  Support for the Advantech iManager2 EC I2C.
+
 config I2C_ALI1535
 	tristate "ALI 1535"
 	depends on PCI
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
old mode 100644
new mode 100755
index 18d18ff..8a2a26b
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
 obj-$(CONFIG_I2C_XILINX)	+= i2c-xiic.o
 obj-$(CONFIG_I2C_XLR)		+= i2c-xlr.o
 obj-$(CONFIG_I2C_RCAR)		+= i2c-rcar.o
+obj-$(CONFIG_I2C_IMANAGER2)	+= imanager2_i2c.o
 
 # External I2C/SMBus adapter drivers
 obj-$(CONFIG_I2C_DIOLAN_U2C)	+= i2c-diolan-u2c.o
diff --git a/drivers/i2c/busses/imanager2_i2c.c b/drivers/i2c/busses/imanager2_i2c.c
new file mode 100755
index 0000000..6510dca
--- /dev/null
+++ b/drivers/i2c/busses/imanager2_i2c.c
@@ -0,0 +1,257 @@
+/* imanager2_i2c.c - I2C interface for Advantech EC IT8516/18/28 driver
+ * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/mfd/advantech/imanager2.h>
+#include "imanager2_i2c.h"
+
+#define DRV_NAME	CHIP_NAME "_i2c"
+#define DRV_VERSION	"0.2.4"
+
+struct it85xx_i2c {
+	struct i2c_adapter adapter;
+	struct it85xx *ec;
+	enum ec_device_id did;
+};
+
+struct it85xx_i2c_drv {
+	struct it85xx_i2c *devs[EC_I2C_SMB_DEV_MAX];
+	int devcount;
+};
+
+static int it85xx_smb_access(struct i2c_adapter *adap, u16 addr,
+			     unsigned short flags, char read_write, u8 command,
+			     int size, union i2c_smbus_data *data)
+{
+	struct it85xx_i2c *i2cdev = i2c_get_adapdata(adap);
+	int ret = 0;
+	u8 rlen = 0;
+
+	addr <<= 1;
+
+	spin_lock(&i2cdev->ec->lock);
+
+	switch (size) {
+	case I2C_SMBUS_QUICK:
+		pr_info("I2C_SMBUS_QUICK\n");
+		if (read_write == I2C_SMBUS_WRITE)
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_WRITE_QUICK,
+					(u8)addr, 0, NULL, 0, NULL, NULL, 0);
+		else
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_READ_QUICK,
+					(u8)addr, 0, NULL, 0, NULL, NULL, 0);
+		pr_info("ret = %X, addr = %X\n", ret , addr >> 1);
+		break;
+	case I2C_SMBUS_BYTE:
+		pr_info("I2C_SMBUS_BYTE\n");
+		if (read_write == I2C_SMBUS_WRITE) {
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_SEND_BYTE,
+					(u8)addr, 0, &data->byte, 1, NULL, NULL,
+					0);
+		} else {
+			rlen = 1;
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE,
+					(u8)addr, 0, NULL, 0, &data->byte,
+					&rlen, 0);
+		}
+		pr_info("ret = %X, addr = %X\n", ret , addr >> 1);
+		break;
+	case I2C_SMBUS_BYTE_DATA:
+		pr_info("I2C_SMBUS_BYTE_DATA\n");
+		if (read_write == I2C_SMBUS_WRITE) {
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_WRITE_BYTE,
+					(u8)addr, command, &data->byte, 1, NULL,
+					NULL, 0);
+		} else {
+			rlen = 1;
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_READ_BYTE,
+					(u8)addr, command, NULL, 0, &data->byte,
+					&rlen, 0);
+		}
+		pr_info("ret = %X, addr = %X\n", ret , addr >> 1);
+		break;
+	case I2C_SMBUS_WORD_DATA:
+		pr_info("I2C_SMBUS_WORD_DATA\n");
+		if (read_write == I2C_SMBUS_WRITE) {
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_WRITE_WORD,
+					(u8)addr, command, (u8 *)&data->word, 2,
+					NULL, NULL, 0);
+		} else {
+			rlen = 2;
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_READ_WORD,
+					(u8)addr, command, NULL, 0,
+					(u8 *)&data->word, &rlen, 0);
+		}
+		pr_info("ret = %X, addr = %X\n", ret , addr >> 1);
+		break;
+	case I2C_SMBUS_BLOCK_DATA:
+		if (read_write == I2C_SMBUS_WRITE)
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK,
+					(u8)addr, command, &data->block[1],
+					data->block[0], NULL, NULL, 0);
+		else
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_READ_BLOCK,
+					(u8)addr, command, NULL, 0,
+					&data->block[1], &data->block[0], 0);
+		break;
+	case I2C_SMBUS_I2C_BLOCK_DATA:
+		if (read_write == I2C_SMBUS_READ)
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK,
+					(u8)addr, command, &data->block[0],
+					data->block[0], NULL, NULL, 1);
+		else
+			ret = ec_smbus_transmit_routine(
+					i2cdev->ec, i2cdev->did,
+					EC_CMD_MALLBOX_SMBUS_READ_BLOCK,
+					(u8)addr, command, NULL, 0,
+					&data->block[0], &data->block[0], 1);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	spin_unlock(&i2cdev->ec->lock);
+
+	return ret;
+}
+
+static u32 it85xx_smb_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
+	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
+	       I2C_FUNC_SMBUS_BLOCK_DATA | I2C_FUNC_SMBUS_I2C_BLOCK;
+}
+
+static const struct i2c_algorithm it85xx_algorithm = {
+	.smbus_xfer	= it85xx_smb_access,
+	.functionality	= it85xx_smb_i2c_func
+};
+
+static struct it85xx_i2c *add_i2c_adapter(struct device *dev, int index)
+{
+	int ret;
+	struct it85xx_i2c *i2cdev;
+
+	i2cdev = devm_kzalloc(dev, sizeof(struct it85xx_i2c), GFP_KERNEL);
+	if (i2cdev == NULL)
+		return NULL;
+
+	i2cdev->did = ec_i2c_table[index].did;
+	i2cdev->ec = dev->parent->platform_data;
+	i2cdev->adapter.owner = THIS_MODULE;
+	i2cdev->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
+	i2cdev->adapter.algo = &it85xx_algorithm;
+	i2cdev->adapter.dev.parent = dev;
+	i2cdev->adapter.retries = 3;
+	i2c_set_adapdata(&i2cdev->adapter, i2cdev);
+	snprintf(i2cdev->adapter.name, sizeof(i2cdev->adapter.name),
+		 ec_i2c_table[index].name);
+
+	ret = i2c_add_adapter(&i2cdev->adapter);
+	if (ret != 0) {
+		dev_err(dev, "Failed to add I2C adapter\n");
+		return NULL;
+	}
+
+	return i2cdev;
+}
+
+static int it85xx_i2c_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct it85xx *ec = dev->parent->platform_data;
+	struct it85xx_i2c_drv *drvdata;
+	int i;
+
+	drvdata = devm_kzalloc(dev, sizeof(struct it85xx_i2c_drv), GFP_KERNEL);
+
+	if (drvdata == NULL)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, drvdata);
+
+	drvdata->devcount = 0;
+	for (i = 0; i < ARRAY_SIZE(ec_i2c_table); i++)
+		if (ec->table.devid2itemnum[ec_i2c_table[i].did] !=
+							EC_TABLE_ITEM_UNUSED) {
+			struct it85xx_i2c *i2cdev = add_i2c_adapter(dev, i);
+			if (i2cdev != NULL) {
+				drvdata->devs[drvdata->devcount] = i2cdev;
+				drvdata->devcount++;
+			}
+		}
+
+	pr_info("I2C driver v%s loaded\n", DRV_VERSION);
+
+	return 0;
+}
+
+static int it85xx_i2c_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct it85xx_i2c_drv *drvdata = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < drvdata->devcount; i++)
+		i2c_del_adapter(&drvdata->devs[i]->adapter);
+
+	pr_info("I2C driver removed\n");
+
+	return 0;
+}
+
+static struct platform_driver it85xx_i2c_driver = {
+	.probe = it85xx_i2c_probe,
+	.remove = it85xx_i2c_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = DRV_NAME,
+	},
+};
+
+module_platform_driver(it85xx_i2c_driver);
+
+MODULE_AUTHOR("Richard Vidal-Dorsch <richard.dorsch at advantech.com>");
+MODULE_DESCRIPTION("I2C interface for Advantech EC IT8516/18/28 driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/i2c/busses/imanager2_i2c.h b/drivers/i2c/busses/imanager2_i2c.h
new file mode 100755
index 0000000..b9b836b
--- /dev/null
+++ b/drivers/i2c/busses/imanager2_i2c.h
@@ -0,0 +1,38 @@
+/* imanager2_i2c.h - I2C interface for Advantech EC IT8516/18/28 driver
+ * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __IMANAGER2_I2C_H__
+#define __IMANAGER2_I2C_H__
+
+#define EC_I2C_SMB_DEV_MAX	8
+#define EC_I2C_BLOCK_MAX	32
+
+struct i2c_item {
+	const u8 did;
+	const char *name;
+};
+
+static struct i2c_item ec_i2c_table[] = {
+	{smboem0, "IT85xx SMBus0"},
+	{smboem1, "IT85xx SMBus1"},
+	{smboem2, "IT85xx SMBus2"},
+	{smbthermal0, "IT85xx Thermal0"},
+	{smbthermal1, "IT85xx Thermal1"},
+	{i2coem, "IT85xx I2COEM"}
+};
+
+#endif /* __IMANAGER2_I2C_H__ */
-- 
1.9.1

