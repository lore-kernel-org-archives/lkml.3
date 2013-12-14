Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3LNCGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 21:06:21 -0500
Received: from smtp106.biz.mail.ne1.yahoo.com ([98.138.207.13]:21983 "HELO
	smtp106.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753187Ab3LNCGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 21:06:18 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wlpLcxsVM1mWdZoAOHXHOI8H7BEL3eqNSiUy.b2qDcm_A5l
 YQSqN6Eu1Y_iz.1XZHLiJVKHz1aABvXo.xuWPJ3XQ8ZY0qs1olLOO71ba_WJ
 SMLYtB8rAc_9qLaVu6hpii.NzWkBCRq.j8Cr5wgiuGCJn1LapP7.F68TAsYi
 09y6ZW7UuWPumYPdC9zmenh9O0adI49q0FPxnIlBLfbfgl8WJIZf.pHbdf4w
 __55FdW38pok_TR8d5tWZw41wFkFnbTzHstOJ3K1.mm2MAEgjWEdLoV1VIjG
 2aPeKUbjUuT2HbY.Zlue9XD47i_7xS3TDI3cE2YkSLnx5yDUjDiAhqvb1Rtx
 qKeFLz3a6T04O_ksvjNy1uvT8xExuIZV_GYEKep05pH06tvc2dDp2tp9nK5W
 wkyuxYrUJYt0xaSE9WSNxjlJ6cT81zugUKW0dgTrbVg1vRU3n6_u5xkae469
 gBV6SsWokYZDtmBTxHa03ZJd75Iu5DpCyijToK8ZlXnfKvxT3qU2hrxMC0sM
 9bHCSkEnPNQv_.hRrQYmSN2ge87aIWK3QngnaH4ZJYvCfgg--
X-Yahoo-SMTP: oqiDtsaswBDv2aVUlxVTYPpATqA-
X-Rocket-Received: from xpc2.US.CapellaMicro.com (ktsai@69.225.173.17 with plain [98.138.105.25])
        by smtp106.biz.mail.ne1.yahoo.com with SMTP; 13 Dec 2013 17:59:36 -0800 PST
From: Kevin Tsai <ktsai@capellamicro.com>
To: Kevin Tsai <ktsai@capellamicro.com>, Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 1/1] Added Capella CM32181 Ambient Light Sensor IIO Driver.
Date: Fri, 13 Dec 2013 17:59:19 -0800
Message-Id: <1386986359-1830-1-git-send-email-ktsai@capellamicro.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Tsai <ktsai@capellamicro.com>
---
 drivers/iio/light/Kconfig   |  11 ++
 drivers/iio/light/Makefile  |   1 +
 drivers/iio/light/cm32181.c | 437 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 449 insertions(+)
 create mode 100644 drivers/iio/light/cm32181.c

diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index a022f27..d12b2a0 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -27,6 +27,17 @@ config APDS9300
 	 To compile this driver as a module, choose M here: the
 	 module will be called apds9300.
 
+config CM32181
+	depends on I2C
+	tristate "CM32181 driver"
+	help
+	 Say Y here if you use cm32181.
+	 This option enables ambient light sensor using
+	 Capella cm32181 device driver.
+
+	 To compile this driver as a module, choose M here:
+	 the module will be called cm32181.
+
 config CM36651
 	depends on I2C
 	tristate "CM36651 driver"
diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
index daa327f..60e35ac 100644
--- a/drivers/iio/light/Makefile
+++ b/drivers/iio/light/Makefile
@@ -5,6 +5,7 @@
 # When adding new entries keep the list in alphabetical order
 obj-$(CONFIG_ADJD_S311)		+= adjd_s311.o
 obj-$(CONFIG_APDS9300)		+= apds9300.o
+obj-$(CONFIG_CM32181)		+= cm32181.o
 obj-$(CONFIG_CM36651)		+= cm36651.o
 obj-$(CONFIG_GP2AP020A00F)	+= gp2ap020a00f.o
 obj-$(CONFIG_HID_SENSOR_ALS)	+= hid-sensor-als.o
diff --git a/drivers/iio/light/cm32181.c b/drivers/iio/light/cm32181.c
new file mode 100644
index 0000000..58ab1b2
--- /dev/null
+++ b/drivers/iio/light/cm32181.c
@@ -0,0 +1,437 @@
+/*
+ * Copyright (C) 2013 Capella Microsystems Inc.
+ * Author: Kevin Tsai <ktsai@capellamicro.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General Public License version 2, as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/regulator/consumer.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+#include <linux/iio/events.h>
+#include <linux/init.h>
+
+/* Registers Address */
+#define	CM32181_REG_ADDR_CMD		0x00
+#define	CM32181_REG_ADDR_ALS		0x04
+#define	CM32181_REG_ADDR_STATUS		0x06
+#define	CM32181_REG_ADDR_ID		0x07
+
+/* Number of Configurable Registers */
+#define CM32181_CONF_REG_NUM		0x01
+
+/* CMD register */
+#define CM32181_CMD_ALS_ENABLE		0x00
+#define CM32181_CMD_ALS_DISABLE		0x01
+#define CM32181_CMD_ALS_INT_EN		0x02
+
+#define	CM32181_CMD_ALS_IT_SHIFT	6
+#define	CM32181_CMD_ALS_IT_MASK		(0x0F << CM32181_CMD_ALS_IT_SHIFT)
+#define	CM32181_CMD_ALS_IT_DEFAULT	(0x00 << CM32181_CMD_ALS_IT_SHIFT)
+
+#define CM32181_CMD_ALS_SM_SHIFT	11
+#define	CM32181_CMD_ALS_SM_MASK		(0x03 << CM32181_CMD_ALS_SM_SHIFT)
+#define	CM32181_CMD_ALS_SM_DEFAULT	(0x01 << CM32181_CMD_ALS_SM_SHIFT)
+
+#define	CM32181_MLUX_PER_BIT		5	/* ALS_SM=01 IT=800ms */
+#define	CM32181_MLUX_PER_BIT_BASE_IT	800000	/* Based on IT=800ms */
+#define	CM32181_CALIBSCALE_RESOLUTION	1000
+#define	MLUX_PER_LUX			1000
+
+enum cm32181_command {
+	CM32181_CMD_READ_RAW_LIGHT,
+};
+
+static const u16 normal_i2c[] = {
+	0x10, 0x48, I2C_CLIENT_END };
+
+static const u8 cm32181_reg[CM32181_CONF_REG_NUM] = {
+	CM32181_REG_ADDR_CMD,
+};
+
+static const int als_it_bits[] = {12, 8, 0, 1, 2, 3};
+static int als_it_value[] = {25000, 50000, 100000, 200000, 400000, 800000};
+
+struct cm32181_chip {
+	struct i2c_client *client;
+	struct mutex lock;
+	u16 conf_regs[CM32181_CONF_REG_NUM];
+	int calibscale;
+};
+
+static int cm32181_read_reg(struct i2c_client *client, u8 reg, u16 *reg_data)
+{
+	s32 ret;
+	int wd;
+
+	wd = 5;
+	while ((ret = i2c_smbus_read_word_data(client, reg)) < 0 &&
+		wd-- > 0)
+		;
+
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"Error in reading Reg.0x%02X\n", reg);
+	} else {
+		if (ret > 0xFFFF)
+			ret = 0xFFFF;
+		*reg_data = (u16)ret;
+	}
+
+	return ret;
+}
+
+static int cm32181_write_reg(struct i2c_client *client, u8 reg, u16 reg_data)
+{
+	int ret;
+	int wd;
+
+	wd = 5;
+	while ((ret = i2c_smbus_write_word_data(client, reg, reg_data)) < 0 &&
+		wd-- > 0)
+		;
+
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"Error in writing 0x%04X to Reg.0x%02X\n",
+			reg_data, reg);
+	}
+
+	return ret;
+}
+
+static int cm32181_reg_init(struct cm32181_chip *cm32181)
+{
+	struct i2c_client *client = cm32181->client;
+	int i, ret;
+
+	cm32181->conf_regs[CM32181_REG_ADDR_CMD] = CM32181_CMD_ALS_ENABLE |
+			CM32181_CMD_ALS_IT_DEFAULT | CM32181_CMD_ALS_SM_DEFAULT;
+
+	for (i = 0; i < CM32181_CONF_REG_NUM; i++) {
+		ret = cm32181_write_reg(client, cm32181_reg[i],
+			cm32181->conf_regs[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	cm32181->calibscale = 1000;
+
+	return 0;
+}
+
+static int cm32181_read_als_it(struct cm32181_chip *cm32181, int *val)
+{
+	u16 als_it;
+	int i;
+
+	als_it = cm32181->conf_regs[CM32181_REG_ADDR_CMD];
+	als_it &= CM32181_CMD_ALS_IT_MASK;
+	als_it >>= CM32181_CMD_ALS_IT_SHIFT;
+	for (i = 0; i < sizeof(als_it_bits)/sizeof(als_it_bits[0]); i++) {
+		if (als_it == als_it_bits[i]) {
+			*val = als_it_value[i];
+			return IIO_VAL_INT;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int cm32181_write_als_it(struct cm32181_chip *cm32181, int val)
+{
+	struct i2c_client *client = cm32181->client;
+	u16 als_it;
+	int ret, i, n;
+
+	n = sizeof(als_it_value)/sizeof(als_it_value[0]);
+	for (i = 0; i < n; i++)
+		if (val <= als_it_value[i])
+			break;
+	if (i >= n && n > 0)
+		i = n-1;
+
+	als_it = als_it_bits[i];
+	als_it <<= CM32181_CMD_ALS_IT_SHIFT;
+
+	mutex_lock(&cm32181->lock);
+	cm32181->conf_regs[CM32181_REG_ADDR_CMD] &=
+		~CM32181_CMD_ALS_IT_MASK;
+	cm32181->conf_regs[CM32181_REG_ADDR_CMD] |= als_it;
+	ret = cm32181_write_reg(client, CM32181_REG_ADDR_CMD,
+			cm32181->conf_regs[CM32181_REG_ADDR_CMD]);
+	mutex_unlock(&cm32181->lock);
+
+	return ret;
+}
+
+static int cm32181_read_raw(struct iio_dev *indio_dev,
+			    struct iio_chan_spec const *chan,
+			    int *val, int *val2, long mask)
+{
+	struct cm32181_chip *cm32181 = iio_priv(indio_dev);
+	struct i2c_client *client = cm32181->client;
+	int ret = -EINVAL;
+	u16 val16 = 0;
+
+	if (chan->type != IIO_LIGHT)
+		return -EINVAL;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		ret = cm32181_read_reg(client, CM32181_REG_ADDR_ALS, &val16);
+		if (ret >= 0) {
+			ret = IIO_VAL_INT;
+			*val = (int)val16;
+		}
+		break;
+	case IIO_CHAN_INFO_INT_TIME:
+		ret = cm32181_read_als_it(cm32181, val);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int cm32181_write_raw(struct iio_dev *indio_dev,
+			     struct iio_chan_spec const *chan,
+			     int val, int val2, long mask)
+{
+	struct cm32181_chip *cm32181 = iio_priv(indio_dev);
+	struct i2c_client *client = cm32181->client;
+	int ret = -EINVAL;
+
+	if (chan->type != IIO_LIGHT)
+		return -EINVAL;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_INT_TIME:
+		ret = cm32181_write_als_it(cm32181, val);
+		if (ret < 0)
+			dev_err(&client->dev, "INT_TIME write failed\n");
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static ssize_t get_lux(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
+	struct i2c_client *client = cm32181->client;
+	unsigned long lux;
+	int ret;
+	int als_it;
+	u16 val;
+
+	ret = cm32181_read_als_it(cm32181, &als_it);
+	if (ret < 0 || als_it == 0)
+		return sprintf(buf, "invalid\n");
+
+	lux = CM32181_MLUX_PER_BIT;
+	lux *= CM32181_MLUX_PER_BIT_BASE_IT;
+	lux /= als_it;
+
+	ret = cm32181_read_reg(client, CM32181_REG_ADDR_ALS, &val);
+	if (ret < 0)
+		return sprintf(buf, "error\n");
+
+	lux *= val;
+	lux *= cm32181->calibscale;
+	lux /= CM32181_CALIBSCALE_RESOLUTION;
+	lux /= MLUX_PER_LUX;
+	return sprintf(buf, "%d\n", (int)lux);
+}
+
+static ssize_t get_it_available(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	int i, n, len;
+
+	n = sizeof(als_it_value)/sizeof(als_it_value[0]);
+	for (i = 0, len = 0; i < n; i++)
+		len += sprintf(buf+len, "%d ", (int)als_it_value[i]);
+	return len + sprintf(buf+len, "\n");
+}
+
+static ssize_t get_calibscale(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
+	return sprintf(buf, "%d\n", cm32181->calibscale);
+}
+
+static ssize_t set_calibscale(struct device *dev,
+			struct device_attribute *attr, const char *buf,
+			size_t count)
+{
+	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
+	unsigned long lval;
+
+	if (kstrtoul(buf, 10, &lval))
+		return -EINVAL;
+
+	cm32181->calibscale = lval;
+	return count;
+}
+
+static const struct iio_chan_spec cm32181_channels[] = {
+	{
+		.type = IIO_LIGHT,
+		.indexed = 0,
+		.channel = 0,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
+				BIT(IIO_CHAN_INFO_INT_TIME),
+	}
+};
+
+
+static IIO_DEVICE_ATTR(in_illuminance_input, S_IRUGO,
+			get_lux, NULL, 0);
+static IIO_DEVICE_ATTR(in_illuminance_integration_time_available,
+			S_IRUGO, get_it_available, NULL, 0);
+static IIO_DEVICE_ATTR(in_illuminance_calibscale, S_IRUGO | S_IWUSR,
+			get_calibscale, set_calibscale, 0);
+
+static struct attribute *cm32181_attributes[] = {
+	&iio_dev_attr_in_illuminance_input.dev_attr.attr,
+	&iio_dev_attr_in_illuminance_integration_time_available.dev_attr.attr,
+	&iio_dev_attr_in_illuminance_calibscale.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group cm32181_attribute_group = {
+	.attrs = cm32181_attributes
+};
+
+static const struct iio_info cm32181_info = {
+	.driver_module		= THIS_MODULE,
+	.read_raw		= &cm32181_read_raw,
+	.write_raw		= &cm32181_write_raw,
+	.attrs			= &cm32181_attribute_group,
+};
+
+static int cm32181_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
+{
+	struct cm32181_chip *cm32181;
+	struct iio_dev *indio_dev;
+	int ret;
+
+	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*cm32181));
+	if (!indio_dev) {
+		dev_err(&client->dev, "devm_iio_device_alloc failed\n");
+		return -ENOMEM;
+	}
+
+	cm32181 = iio_priv(indio_dev);
+
+	i2c_set_clientdata(client, indio_dev);
+
+	cm32181->client = client;
+	mutex_init(&cm32181->lock);
+	indio_dev->dev.parent = &client->dev;
+	indio_dev->channels = cm32181_channels;
+	indio_dev->num_channels = ARRAY_SIZE(cm32181_channels);
+	indio_dev->info = &cm32181_info;
+	indio_dev->name = id->name;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+
+	ret = cm32181_reg_init(cm32181);
+	if (ret) {
+		dev_err(&client->dev, "%s: register init failed\n", __func__);
+		goto error_disable_reg;
+	}
+
+	ret = iio_device_register(indio_dev);
+	if (ret) {
+		dev_err(&client->dev, "%s: regist device failed\n", __func__);
+		goto error_disable_reg;
+	}
+
+	return 0;
+
+error_disable_reg:
+	return ret;
+}
+
+static int cm32181_detect(struct i2c_client *client,
+				struct i2c_board_info *info)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	const char *name = NULL;
+	u16 id;
+	int ret;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	ret = cm32181_read_reg(client, CM32181_REG_ADDR_ID, &id);
+	if (ret < 0)
+		return -ENODEV;
+
+	switch (id&0xFF) {
+	case 0x81:
+		name = "cm32181";
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	strlcpy(info->type, name, I2C_NAME_SIZE);
+	return 0;
+}
+
+static int cm32181_remove(struct i2c_client *client)
+{
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+
+	iio_device_unregister(indio_dev);
+	return 0;
+}
+
+static const struct i2c_device_id cm32181_id[] = {
+	{ "cm32181", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, cm32181_id);
+
+static const struct of_device_id cm32181_of_match[] = {
+	{ .compatible = "capella,cm32181" },
+	{ }
+};
+
+static struct i2c_driver cm32181_driver = {
+	.driver = {
+		.name	= "cm32181",
+		.of_match_table = of_match_ptr(cm32181_of_match),
+		.owner	= THIS_MODULE,
+	},
+	.id_table       = cm32181_id,
+	.probe		= cm32181_probe,
+	.remove		= cm32181_remove,
+	/* for autodetection */
+	.class = I2C_CLASS_HWMON,
+	.detect		= cm32181_detect,
+	.address_list	= normal_i2c,
+};
+
+module_i2c_driver(cm32181_driver);
+
+MODULE_AUTHOR("Kevin Tsai <ktsai@capellamicro.com>");
+MODULE_DESCRIPTION("CM32181 ambient light sensor driver");
+MODULE_LICENSE("GPL");
-- 
1.8.3.1

