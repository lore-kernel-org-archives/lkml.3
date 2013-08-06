Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3HFSb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:31:26 -0400
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:41172 "HELO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756707Ab3HFSbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:31:24 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2013 14:31:23 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qyVExUMVM1l_Q39bDqAV_TAzQdKA3P6UL19BFndZRgbzdui
 R10zPkfTr2MVL6ipYdH351C2aCxKzntBe_AIJtcB6nS4gHhhKyxtC3DUr1tk
 veQMR.s6veTDS9435PQgdyhKxFrAh4pHuKdR_RBfgK2pSSbOb1yABrjpTqUO
 oYqJq.gcLVFzb6C9wbS2or_MxhIuwEe4l5lPvqqU9Y7s8sfqUa.wFcEyZu0A
 GidRMcL0m1fLRktze_7u5gEy4..1bQtSReWHqg.xgTDC1U5mbfwv4xYrZo87
 pw3aLU32gmz181smOa26YdlxMOfe2B6KmKzO7L3fuWmJPggvyvBeozbZIdsc
 H8prPc4B..Larj7sMjHLWS5Vng3qMaB8w2K50fLIXMXbB2PjsO0Iuhi_A07g
 yWYKafCI5CNJcKzCc.yYttxSvoAOSVmTgiTbmoVK2VN02lPIPFH1K8munp7R
 _yD3bFX0AU22MdiLM0TqEExtHoLQF_RkR0m.OjOtCRHnhVDfRJ0DcX46Yxqq
 h6ptxbQpCecf5D_QmqRlQIg9wWZs.zi5uORz.wQOn
X-Yahoo-SMTP: oqiDtsaswBDv2aVUlxVTYPpATqA-
X-Rocket-Received: from ubuntu.US.CapellaMicro.com (ktsai@69.225.173.17 with )
        by smtp105.biz.mail.bf1.yahoo.com with SMTP; 06 Aug 2013 11:24:43 -0700 PDT
From: Kevin Tsai <ktsai@capellamicro.com>
To: Kevin Tsai <ktsai@capellamicro.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Alexander Holler <holler@ahsoftware.de>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 1/1] Added Capella CM3218 Ambient Light Sensor IIO driver.
Date: Tue,  6 Aug 2013 11:24:13 -0700
Message-Id: <1375813453-2290-1-git-send-email-ktsai@capellamicro.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Tsai <ktsai@capellamicro.com>
---
 drivers/iio/light/Kconfig  |  10 +
 drivers/iio/light/Makefile |   1 +
 drivers/iio/light/cm3218.c | 589 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 600 insertions(+)
 create mode 100644 drivers/iio/light/cm3218.c

diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index 5ef1a39..dd1ea80 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -15,6 +15,16 @@ config ADJD_S311
 	 This driver can also be built as a module.  If so, the module
 	 will be called adjd_s311.
 
+config SENSORS_CM3218
+        tristate "CM3218 Ambient Light Sensor"
+        depends on I2C
+        help
+         Say Y here if you have a Capella Micro CM3218 Ambient Light Sensor.
+
+         To compile this driver as a module, choose M here.  This module
+         will be called to 'cm3218'.  It will access ALS data via iio sysfs.
+         This is recommended.
+
 config SENSORS_LM3533
 	tristate "LM3533 ambient light sensor"
 	depends on MFD_LM3533
diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
index 040d9c7..c4ebe37 100644
--- a/drivers/iio/light/Makefile
+++ b/drivers/iio/light/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_ADJD_S311)		+= adjd_s311.o
+obj-$(CONFIG_SENSORS_CM3218)    += cm3218.o
 obj-$(CONFIG_SENSORS_LM3533)	+= lm3533-als.o
 obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
 obj-$(CONFIG_VCNL4000)		+= vcnl4000.o
diff --git a/drivers/iio/light/cm3218.c b/drivers/iio/light/cm3218.c
new file mode 100644
index 0000000..1989fbb
--- /dev/null
+++ b/drivers/iio/light/cm3218.c
@@ -0,0 +1,589 @@
+/*
+ * A iio driver for CM3218 Ambient Light Sensor.
+ *
+ * IIO driver for monitoring ambient light intensity in lux.
+ *
+ * Copyright (c) 2013, Capella Microsystems Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#if 0	/* ChromeOS still uses old API */
+#include "../iio.h"
+#include "../sysfs.h"
+#define	IIO_DEVICE_ALLOC	iio_allocate_device
+#define	IIO_DEVICE_FREE		iio_free_device
+#else
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+#define	IIO_DEVICE_ALLOC	iio_device_alloc
+#define	IIO_DEVICE_FREE		iio_device_free
+#endif	/* 0 */
+
+/*
+ * SMBus ARA address
+ */
+#define	CM3218_ADDR_ARA			0x0C
+
+/*
+ * CM3218 CMD Registers
+ */
+#define	CM3218_REG_ADDR_CMD		0x00
+#define	CM3218_CMD_ALS_SD		0x0001
+#define	CM3218_CMD_ALS_INT_EN		0x0002
+#define	CM3218_CMD_ALS_IT_SHIFT		6
+#define	CM3218_CMD_ALS_IT_MASK		(3 << CM3218_CMD_ALS_IT_SHIFT)
+#define	CM3218_CMD_ALS_IT_05T		(0 << CM3218_CMD_ALS_IT_SHIFT)
+#define	CM3218_CMD_ALS_IT_1T		(1 << CM3218_CMD_ALS_IT_SHIFT)
+#define	CM3218_CMD_ALS_IT_2T		(2 << CM3218_CMD_ALS_IT_SHIFT)
+#define	CM3218_CMD_ALS_IT_4T		(3 << CM3218_CMD_ALS_IT_SHIFT)
+#define	CM3218_DEFAULT_CMD		(CM3218_CMD_ALS_IT_1T)
+
+#define	CM3218_REG_ADDR_ALS_WH		0x01
+#define	CM3218_DEFAULT_ALS_WH		0xFFFF
+
+#define	CM3218_REG_ADDR_ALS_WL		0x02
+#define	CM3218_DEFAULT_ALS_WL		0x0000
+
+#define	CM3218_REG_ADDR_ALS		0x04
+
+#define	CM3218_REG_ADDR_STATUS		0x06
+
+#define	CM3218_REG_ADDR_ID		0x07
+
+/*
+ * Software Parameters
+ */
+#define	CM3218_MAX_CACHE_REGS		(0x03+1)	/* Reg.0x00 to 0x03 */
+
+/*
+ * Features
+ */
+#define	CM3218_DEBUG
+
+static const unsigned short normal_i2c[] = {
+	0x10, 0x48, I2C_CLIENT_END };
+
+struct cm3218_chip {
+	struct i2c_client	*client;
+	struct mutex		lock;
+	unsigned int		lensfactor;
+	bool			suspended;
+	u16			reg_cache[CM3218_MAX_CACHE_REGS];
+};
+
+static int cm3218_read_ara(struct i2c_client *client)
+{
+	int status;
+	unsigned short addr;
+
+	addr = client->addr;
+	client->addr = CM3218_ADDR_ARA;
+	status = i2c_smbus_read_byte(client);
+	client->addr = addr;
+
+	if (status < 0)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int cm3218_write(struct i2c_client *client, u8 reg, u16 value)
+{
+	int ret;
+	struct cm3218_chip *chip = iio_priv(i2c_get_clientdata(client));
+
+#ifdef	CM3218_DEBUG
+	dev_err(&client->dev,
+		"Write to device register 0x%02X with 0x%04X\n", reg, value);
+#endif	/* CM3218_DEBUG */
+	ret = i2c_smbus_write_word_data(client, reg, value);
+	if (ret) {
+		dev_err(&client->dev, "Write to device fails: 0x%x\n", ret);
+	} else {
+		/* Update cache */
+		if (reg < CM3218_MAX_CACHE_REGS)
+			chip->reg_cache[reg] = value;
+	}
+
+	return ret;
+}
+
+static int cm3218_read(struct i2c_client *client, u8 reg)
+{
+	int status;
+	struct cm3218_chip *chip = iio_priv(i2c_get_clientdata(client));
+
+	if (reg < CM3218_MAX_CACHE_REGS) {
+		status = chip->reg_cache[reg];
+	} else {
+		status = i2c_smbus_read_word_data(client, reg);
+		if (status < 0) {
+			dev_err(&client->dev,
+				"Error in reading Reg.0x%02X\n", reg);
+			return status;
+		}
+#ifdef	CM3218_DEBUG
+		dev_err(&client->dev,
+			"Read from device register 0x%02X = 0x%04X\n",
+			reg, status);
+#endif	/* CM3218_DEBUG */
+	}
+
+	return status;
+}
+
+static int cm3218_read_sensor_input(struct i2c_client *client)
+{
+	int status;
+
+	status = cm3218_read(client, CM3218_REG_ADDR_ALS);
+	if (status < 0)
+		return status;
+
+	dev_vdbg(&client->dev, "lux = %u\n", status);
+
+	return status;
+}
+
+static int cm3218_read_lux(struct i2c_client *client, int *lux)
+{
+	struct cm3218_chip *chip = iio_priv(i2c_get_clientdata(client));
+	int lux_data;
+
+	lux_data = cm3218_read_sensor_input(client);
+
+	if (lux_data < 0)
+		return lux_data;
+
+	*lux  = lux_data * chip->lensfactor;
+	*lux /= 1000;
+	return 0;
+}
+
+/* Sysfs interface */
+/* lensfactor */
+static ssize_t show_lensfactor(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct cm3218_chip *chip = iio_priv(indio_dev);
+
+	return sprintf(buf, "%d\n", chip->lensfactor);
+}
+
+static ssize_t store_lensfactor(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct cm3218_chip *chip = iio_priv(indio_dev);
+	unsigned long lval;
+
+	if (kstrtoul(buf, 10, &lval))
+		return -EINVAL;
+
+	mutex_lock(&chip->lock);
+	chip->lensfactor = lval;
+	mutex_unlock(&chip->lock);
+
+	return count;
+}
+
+static ssize_t get_sensor_data(struct device *dev, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct cm3218_chip *chip = iio_priv(indio_dev);
+	struct i2c_client *client = chip->client;
+	int value = 0;
+	int status;
+
+	mutex_lock(&chip->lock);
+	if (chip->suspended) {
+		mutex_unlock(&chip->lock);
+		return -EBUSY;
+	}
+
+	 status = cm3218_read_lux(client, &value);
+
+	if (status < 0) {
+		dev_err(&client->dev, "Error in Reading data");
+		mutex_unlock(&chip->lock);
+		return status;
+	}
+
+	mutex_unlock(&chip->lock);
+
+	return sprintf(buf, "%d\n", value);
+}
+
+
+/* Read lux */
+static ssize_t show_lux(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	return get_sensor_data(dev, buf);
+}
+
+#ifdef	CM3218_DEBUG
+/* windows_high */
+static ssize_t show_cmd(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct cm3218_chip *chip = iio_priv(indio_dev);
+	struct i2c_client *client = chip->client;
+	int status;
+
+	status = cm3218_read(client, CM3218_REG_ADDR_CMD);
+	if (status < 0) {
+		dev_err(dev, "Error in getting CM3218_REG_ADDR_CMD\n");
+		return status;
+	}
+
+	return sprintf(buf, "%u\n", status);
+}
+
+static ssize_t store_cmd(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct cm3218_chip *chip = iio_priv(indio_dev);
+	struct i2c_client *client = chip->client;
+	int status;
+	unsigned long lval;
+
+	if (kstrtoul(buf, 10, &lval))
+		return -EINVAL;
+
+	mutex_lock(&chip->lock);
+	if (lval > 0x10000)
+		lval = 0xFFFF;
+	status = cm3218_write(client, CM3218_REG_ADDR_CMD, (u16)lval);
+	if (status < 0) {
+		mutex_unlock(&chip->lock);
+		dev_err(dev, "Error in setting CM3218_REG_ADDR_CMD\n");
+		return status;
+	}
+	mutex_unlock(&chip->lock);
+
+	return count;
+}
+
+/* status */
+static ssize_t show_status(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct cm3218_chip *chip = iio_priv(indio_dev);
+	struct i2c_client *client = chip->client;
+	int status;
+
+	status = cm3218_read(client, CM3218_REG_ADDR_STATUS);
+	if (status < 0) {
+		dev_err(dev, "Error in getting CM3218_REG_ADDR_STATUS\n");
+		return status;
+	}
+
+	return sprintf(buf, "%u\n", status);
+}
+
+#endif	/* CM3218_DEBUG */
+
+/* Channel IO */
+static int cm3218_write_raw(struct iio_dev *indio_dev,
+			      struct iio_chan_spec const *chan,
+			      int val,
+			      int val2,
+			      long mask)
+{
+	struct cm3218_chip *chip = iio_priv(indio_dev);
+	int ret = -EINVAL;
+
+	mutex_lock(&chip->lock);
+	if (mask == IIO_CHAN_INFO_CALIBSCALE && chan->type == IIO_LIGHT) {
+		chip->lensfactor = val;
+		ret = 0;
+	}
+	mutex_unlock(&chip->lock);
+
+	return 0;
+}
+
+static int cm3218_read_raw(struct iio_dev *indio_dev,
+			     struct iio_chan_spec const *chan,
+			     int *val,
+			     int *val2,
+			     long mask)
+{
+	int ret = -EINVAL;
+	struct cm3218_chip *chip = iio_priv(indio_dev);
+	struct i2c_client *client = chip->client;
+
+	mutex_lock(&chip->lock);
+	if (chip->suspended) {
+		mutex_unlock(&chip->lock);
+		return -EBUSY;
+	}
+	switch (mask) {
+	case 0:
+		ret = cm3218_read_lux(client, val);
+		if (!ret)
+			ret = IIO_VAL_INT;
+		break;
+	case IIO_CHAN_INFO_CALIBSCALE:
+		*val = chip->lensfactor;
+		ret = IIO_VAL_INT_PLUS_MICRO;
+		break;
+	default:
+		break;
+	}
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+
+#define IIO_CHAN_INFO_SEPARATE_BIT(type) BIT(type*2 + 1)
+#define IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT                   \
+	IIO_CHAN_INFO_SEPARATE_BIT(IIO_CHAN_INFO_CALIBSCALE)
+
+static const struct iio_chan_spec cm3218_channels[] = {
+	{
+		.type = IIO_LIGHT,
+		.indexed = 1,
+		.channel = 0,
+		.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT,
+	}
+};
+
+static IIO_DEVICE_ATTR(illuminance0_input, S_IRUGO, show_lux, NULL, 0);
+static IIO_DEVICE_ATTR(illuminance0_calibscale, S_IRUGO | S_IWUSR,
+					show_lensfactor, store_lensfactor, 0);
+#ifdef	CM3218_DEBUG
+static IIO_DEVICE_ATTR(cmd, S_IRUGO | S_IWUSR, show_cmd, store_cmd, 0);
+static IIO_DEVICE_ATTR(status, S_IRUGO, show_status, NULL, 0);
+#endif	/* CM3218_DEBUG */
+
+#define CM3218_DEV_ATTR(name) (&iio_dev_attr_##name.dev_attr.attr)
+#define CM3218_CONST_ATTR(name) (&iio_const_attr_##name.dev_attr.attr)
+static struct attribute *cm3218_attributes[] = {
+	CM3218_DEV_ATTR(illuminance0_input),
+	CM3218_DEV_ATTR(illuminance0_calibscale),
+#ifdef	CM3218_DEBUG
+	CM3218_DEV_ATTR(cmd),
+	CM3218_DEV_ATTR(status),
+#endif	/* CM3218_DEBUG */
+	NULL
+};
+
+static const struct attribute_group cm3218_group = {
+	.attrs = cm3218_attributes,
+};
+
+static int cm3218_chip_init(struct i2c_client *client)
+{
+	struct cm3218_chip *chip = iio_priv(i2c_get_clientdata(client));
+	int status, i;
+
+	memset(chip->reg_cache, 0, sizeof(chip->reg_cache));
+
+	for (i = 0; i < 5; i++) {
+		status = cm3218_write(client, CM3218_REG_ADDR_CMD,
+				CM3218_CMD_ALS_SD);
+		if (status >= 0)
+			break;
+		cm3218_read_ara(client);
+	}
+
+	status = cm3218_write(client, CM3218_REG_ADDR_CMD, CM3218_DEFAULT_CMD);
+	if (status < 0) {
+		dev_err(&client->dev, "Init CM3218 CMD fails\n");
+		return status;
+	}
+
+
+	/* Clean interrupt status */
+	cm3218_read(client, CM3218_REG_ADDR_STATUS);
+
+	return 0;
+}
+
+static const struct iio_info cm3218_info = {
+	.attrs = &cm3218_group,
+	.driver_module = THIS_MODULE,
+	.read_raw = &cm3218_read_raw,
+	.write_raw = &cm3218_write_raw,
+};
+
+static int cm3218_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct cm3218_chip *chip;
+	struct iio_dev *indio_dev;
+	int err;
+
+	indio_dev = IIO_DEVICE_ALLOC(sizeof(*chip));
+	if (indio_dev == NULL) {
+		dev_err(&client->dev, "iio allocation fails\n");
+		err = -ENOMEM;
+		goto exit;
+	}
+	chip = iio_priv(indio_dev);
+	chip->client = client;
+	i2c_set_clientdata(client, indio_dev);
+
+	mutex_init(&chip->lock);
+
+	chip->lensfactor = 1000;
+	chip->suspended = false;
+
+	err = cm3218_chip_init(client);
+	if (err)
+		goto exit_iio_free;
+
+	indio_dev->info = &cm3218_info;
+	indio_dev->channels = cm3218_channels;
+	indio_dev->num_channels = ARRAY_SIZE(cm3218_channels);
+	indio_dev->name = id->name;
+	indio_dev->dev.parent = &client->dev;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	err = iio_device_register(indio_dev);
+	if (err) {
+		dev_err(&client->dev, "iio registration fails\n");
+		goto exit_iio_free;
+	}
+
+	return 0;
+exit_iio_free:
+	IIO_DEVICE_FREE(indio_dev);
+exit:
+	return err;
+}
+
+static int cm3218_detect(struct i2c_client *client,
+				   struct i2c_board_info *info)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	const char *name = NULL;
+	int id;
+
+	cm3218_read_ara(client);
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	id = cm3218_read(client, CM3218_REG_ADDR_ID);
+	if (id < 0)
+		return -ENODEV;
+
+	switch (id&0xFF) {
+	case 0x18:
+		name = "cm3218";
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	strlcpy(info->type, name, I2C_NAME_SIZE);
+
+	return 0;
+}
+
+static int cm3218_remove(struct i2c_client *client)
+{
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "%s()\n", __func__);
+	iio_device_unregister(indio_dev);
+	IIO_DEVICE_FREE(indio_dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int cm3218_suspend(struct device *dev)
+{
+	struct cm3218_chip *chip = iio_priv(dev_get_drvdata(dev));
+
+	mutex_lock(&chip->lock);
+
+	/* Since this driver uses only polling commands, we are by default in
+	 * auto shutdown (ie, power-down) mode.
+	 * So we do not have much to do here.
+	 */
+	chip->suspended = true;
+
+	mutex_unlock(&chip->lock);
+	return 0;
+}
+
+static int cm3218_resume(struct device *dev)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct cm3218_chip *chip = iio_priv(indio_dev);
+	struct i2c_client *client = chip->client;
+	int err;
+
+	mutex_lock(&chip->lock);
+
+	err = cm3218_chip_init(client);
+	if (!err)
+		chip->suspended = false;
+
+	mutex_unlock(&chip->lock);
+	return err;
+}
+
+static SIMPLE_DEV_PM_OPS(cm3218_pm_ops, cm3218_suspend, cm3218_resume);
+#define CM3218_PM_OPS (&cm3218_pm_ops)
+#else
+#define CM3218_PM_OPS NULL
+#endif
+
+static const struct i2c_device_id cm3218_id[] = {
+	{"cm3218", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, cm3218_id);
+
+static const struct of_device_id cm3218_of_match[] = {
+	{ .compatible = "invn,cm3218", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, cm3218_of_match);
+
+static struct i2c_driver cm3218_driver = {
+	.class = I2C_CLASS_HWMON,
+	.driver = {
+		.name = "cm3218",
+		.pm = CM3218_PM_OPS,
+		.owner = THIS_MODULE,
+		.of_match_table = cm3218_of_match,
+	},
+	.probe = cm3218_probe,
+	.remove = cm3218_remove,
+	.id_table = cm3218_id,
+	.detect = cm3218_detect,
+	.address_list = normal_i2c,
+};
+module_i2c_driver(cm3218_driver);
+
+MODULE_DESCRIPTION("CM3218 Ambient Light Sensor driver");
+MODULE_LICENSE("GPL");
-- 
1.8.3.1

