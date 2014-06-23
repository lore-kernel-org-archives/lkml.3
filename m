Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaFWI73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:59:29 -0400
Received: from acledge3.advantech.com.tw ([219.90.3.242]:49182 "EHLO
	acledge3.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaFWI7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:59:25 -0400
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa@the-dreams.de>
CC: "Louis.Lu" <Louis.Lu@advantech.com.tw>, "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: [PATCH 5/5] i2c: imanager2: add support for IT8516/18/28
Date: Mon, 23 Jun 2014 01:39:52 -0700
Message-ID: <1403512792-19100-5-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403512792-19100-1-git-send-email-weichun.pan@advantech.com.tw>
References: <1403512792-19100-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
---
 drivers/i2c/busses/Kconfig         |   8 ++
 drivers/i2c/busses/Makefile        |   1 +
 drivers/i2c/busses/imanager2_i2c.c | 261 +++++++++++++++++++++++++++++++++++++
 3 files changed, 270 insertions(+)
 create mode 100644 drivers/i2c/busses/imanager2_i2c.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index c94db1c..8aad058 100644
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
index 18d18ff..8a2a26b 100644
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
new file mode 100644
index 0000000..bb83155
--- /dev/null
+++ b/drivers/i2c/busses/imanager2_i2c.c
@@ -0,0 +1,261 @@
+/*
+ * imanager2_i2c.c - I2C interface for Advantech EC IT8516/18/28 driver
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
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/mfd/advantech/imanager2.h>
+
+#define DRV_NAME	"imanager2_i2c"
+#define DRV_VERSION	"4.0.1"
+
+#define EC_I2C_SMB_DEV_MAX	8
+
+struct imanager2_i2c {
+	struct i2c_adapter adapter;
+	struct imanager2 *ec;
+	enum ec_device_id did;
+};
+
+struct imanager2_i2c_drv {
+	struct imanager2_i2c *devs[EC_I2C_SMB_DEV_MAX];
+	int devcount;
+};
+
+static int imanager2_smb_access(struct i2c_adapter *adap, u16 addr,
+				unsigned short flags, char read_write,
+				u8 command, int size,
+				union i2c_smbus_data *data)
+{
+	struct imanager2_i2c *i2cdev = i2c_get_adapdata(adap);
+	int ret;
+	u8 protocol = 0, *wdata = NULL, wlen = 0, *rdata = NULL, *rlen = NULL;
+	u8 buf[EC_MAILBOX_SMBI2C_DATA_LENGTH];
+
+	addr <<= 1;
+
+	switch (size) {
+	case I2C_SMBUS_QUICK:
+		if (read_write == I2C_SMBUS_WRITE)
+			protocol = EC_CMD_MALLBOX_SMBUS_WRITE_QUICK;
+		else
+			protocol = EC_CMD_MALLBOX_SMBUS_READ_QUICK;
+		break;
+	case I2C_SMBUS_BYTE:
+		if (read_write == I2C_SMBUS_WRITE) {
+			protocol = EC_CMD_MALLBOX_SMBUS_SEND_BYTE;
+			wdata = &data->byte;
+			wlen = 1;
+		} else {
+			protocol = EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE;
+			rdata = &data->byte;
+			*rlen = 1;
+		}
+		break;
+	case I2C_SMBUS_BYTE_DATA:
+		if (read_write == I2C_SMBUS_WRITE) {
+			protocol = EC_CMD_MALLBOX_SMBUS_WRITE_BYTE;
+			wdata = &data->byte;
+			wlen = 1;
+		} else {
+			protocol = EC_CMD_MALLBOX_SMBUS_READ_BYTE;
+			rdata = &data->byte;
+			*rlen = 1;
+		}
+		break;
+	case I2C_SMBUS_WORD_DATA:
+		if (read_write == I2C_SMBUS_WRITE) {
+			protocol = EC_CMD_MALLBOX_SMBUS_WRITE_WORD;
+			wdata = (u8 *)&data->word;
+			wlen = 2;
+		} else {
+			protocol = EC_CMD_MALLBOX_SMBUS_READ_WORD;
+			rdata = (u8 *)&data->word;
+			*rlen = 2;
+		}
+		break;
+	case I2C_SMBUS_BLOCK_DATA:
+		if (read_write == I2C_SMBUS_WRITE) {
+			protocol = EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK;
+			wdata = (u8 *)&data->block[1];
+			wlen = data->block[0];
+		} else {
+			protocol = EC_CMD_MALLBOX_SMBUS_READ_BLOCK;
+			rdata = (u8 *)&data->block[1];
+			*rlen = data->block[0];
+		}
+		break;
+	case I2C_SMBUS_I2C_BLOCK_DATA:
+		if (read_write == I2C_SMBUS_WRITE) {
+			int i;
+
+			buf[0] = command;
+			for (i = 0; i < data->block[0]; i++)
+				buf[i + 1] = data->block[i + 1];
+			protocol = EC_CMD_MALLBOX_I2C_WRITE_READ;
+			wdata = buf;
+			wlen = data->block[0] + 1;
+		} else {
+			int i;
+
+			buf[0] = command;
+			for (i = 0; i < data->block[0]; i++)
+				buf[i + 1] = data->block[i + 1];
+
+			protocol = EC_CMD_MALLBOX_I2C_READ_WRITE;
+			rdata = buf;
+			*rlen = data->block[0] + 1;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	mutex_lock(&i2cdev->ec->lock);
+	ret = imanager2_smbus_transmit_routine(i2cdev->ec, i2cdev->did,
+					       protocol, (u8) addr, command,
+					       wdata, wlen, rdata, rlen);
+	mutex_unlock(&i2cdev->ec->lock);
+
+	return ret;
+}
+
+static u32 imanager2_smb_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
+	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
+	       I2C_FUNC_SMBUS_BLOCK_DATA | I2C_FUNC_SMBUS_I2C_BLOCK;
+}
+
+static const struct i2c_algorithm imanager2_algorithm = {
+	.smbus_xfer = imanager2_smb_access,
+	.functionality = imanager2_smb_i2c_func
+};
+
+static u32 imanager2_smb_io_i2c_func(struct i2c_adapter *adap)
+{
+	/* IO chennel access way has no I2C block protocol */
+	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
+	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
+	       I2C_FUNC_SMBUS_BLOCK_DATA;
+}
+
+static const struct i2c_algorithm imanager2_io_algorithm = {
+	.smbus_xfer = imanager2_smb_access,
+	.functionality = imanager2_smb_io_i2c_func
+};
+
+struct i2c_item {
+	const u8 did;
+	const char *name;
+};
+
+static struct i2c_item imanager2_i2c_table[] = {
+	{smboem0, "iManager2 SMBus0"},
+	{smboem1, "iManager2 SMBus1"},
+	{smboem2, "iManager2 SMBus2"},
+	{smbthermal0, "iManager2 Thermal0"},
+	{smbthermal1, "iManager2 Thermal1"},
+	{i2coem, "iManager2 I2COEM"}
+};
+
+static struct imanager2_i2c *add_i2c_adapter(struct device *dev, int index)
+{
+	struct imanager2_i2c *i2cdev;
+
+	i2cdev = devm_kzalloc(dev, sizeof(struct imanager2_i2c), GFP_KERNEL);
+	if (!i2cdev)
+		return NULL;
+
+	i2cdev->did = imanager2_i2c_table[index].did;
+	i2cdev->ec = dev->parent->platform_data;
+	i2cdev->adapter.owner = THIS_MODULE;
+	i2cdev->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
+	if (i2cdev->ec->flag & EC_FLAG_MAILBOX)
+		i2cdev->adapter.algo = &imanager2_algorithm;
+	else
+		i2cdev->adapter.algo = &imanager2_io_algorithm;
+	i2cdev->adapter.dev.parent = dev;
+	i2cdev->adapter.retries = 3;
+	i2c_set_adapdata(&i2cdev->adapter, i2cdev);
+
+	snprintf(i2cdev->adapter.name, sizeof(i2cdev->adapter.name),
+		 imanager2_i2c_table[index].name);
+
+	if (i2c_add_adapter(&i2cdev->adapter))
+		return NULL;
+
+	return i2cdev;
+}
+
+static int imanager2_i2c_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct imanager2 *ec = dev->parent->platform_data;
+	struct imanager2_i2c_drv *drvdata;
+	int i;
+
+	drvdata =
+	    devm_kzalloc(dev, sizeof(struct imanager2_i2c_drv), GFP_KERNEL);
+
+	if (!drvdata)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, drvdata);
+
+	drvdata->devcount = 0;
+	for (i = 0; i < ARRAY_SIZE(imanager2_i2c_table); i++)
+		if (ec->table.devid2itemnum[imanager2_i2c_table[i].did] !=
+		    EC_TABLE_ITEM_UNUSED) {
+			struct imanager2_i2c *i2cdev = add_i2c_adapter(dev, i);
+			if (i2cdev) {
+				drvdata->devs[drvdata->devcount] = i2cdev;
+				drvdata->devcount++;
+			}
+		}
+
+	return 0;
+}
+
+static int imanager2_i2c_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct imanager2_i2c_drv *drvdata = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < drvdata->devcount; i++)
+		i2c_del_adapter(&drvdata->devs[i]->adapter);
+
+	return 0;
+}
+
+static struct platform_driver imanager2_i2c_driver = {
+	.probe = imanager2_i2c_probe,
+	.remove = imanager2_i2c_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRV_NAME,
+	},
+};
+
+module_platform_driver(imanager2_i2c_driver);
+
+MODULE_AUTHOR("Richard Vidal-Dorsch <richard.dorsch at advantech.com>");
+MODULE_DESCRIPTION("I2C interface for Advantech EC IT8516/18/28 driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
-- 
1.9.1

