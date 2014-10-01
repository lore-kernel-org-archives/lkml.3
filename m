Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaJAMIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:08:22 -0400
Received: from atl4mhfb03.myregisteredsite.com ([209.17.115.61]:44377 "EHLO
	atl4mhfb03.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbaJAMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:08:21 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Auryn Verwegen <auryn.verwegen@topic.nl>
Subject: [PATCH] Added LTC2941/LTC2943 Battery Gauge Driver
Date: Wed,  1 Oct 2014 14:07:57 +0200
Message-Id: <1412165277-8861-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Auryn Verwegen <auryn.verwegen@topic.nl>

Both the LTC2941 and LTC2943 measure battery capacity.
The LTC2943 is compatible with the LTC2941, it adds voltage and
temperature monitoring, and uses a slightly different conversion
formula for the charge counter.

To avoid confusion with e.g. the LTC2945, the driver is called
LTC2941 instead of LTC294X.
---
 drivers/power/Kconfig                 |    7 +
 drivers/power/Makefile                |    1 +
 drivers/power/ltc2941-battery-gauge.c |  497 +++++++++++++++++++++++++++++++++
 3 files changed, 505 insertions(+)
 create mode 100644 drivers/power/ltc2941-battery-gauge.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 73cfcdf..3333bf3 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -382,6 +382,13 @@ config CHARGER_TPS65090
 	 Say Y here to enable support for battery charging with TPS65090
 	 PMIC chips.
 
+config BATTERY_GAUGE_LTC2941
+	tristate "LTC2941/LTC2943 Battery Gauge Driver"
+	depends on I2C
+	help
+	 Say Y here to include support for LTC2941 and LTC2943 Battery Gauge
+	 IC.
+
 config AB8500_BM
 	bool "AB8500 Battery Management Driver"
 	depends on AB8500_CORE && AB8500_GPADC
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index dfa8942..4f8e6c0 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_BATTERY_MAX17042)	+= max17042_battery.o
 obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
 obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
 obj-$(CONFIG_BATTERY_TWL4030_MADC)	+= twl4030_madc_battery.o
+obj-$(CONFIG_BATTERY_GAUGE_LTC2941)	+= ltc2941-battery-gauge.o
 obj-$(CONFIG_CHARGER_88PM860X)	+= 88pm860x_charger.o
 obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
 obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
diff --git a/drivers/power/ltc2941-battery-gauge.c b/drivers/power/ltc2941-battery-gauge.c
new file mode 100644
index 0000000..af2c0ab
--- /dev/null
+++ b/drivers/power/ltc2941-battery-gauge.c
@@ -0,0 +1,497 @@
+/*
+ * I2C client/driver for the Linear Technology LTC2941 and LTC2943
+ * Battery Gas Gauge IC
+ *
+ * Copyright (C) 2014 Topic Embedded Systems
+ *
+ * Author: Auryn Verwegen
+ * Author: Mike Looijmans
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/swab.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/idr.h>
+#include <linux/power_supply.h>
+#include <linux/slab.h>
+
+#define I16_MSB(x)			((x >> 8) & 0xFF)
+#define I16_LSB(x)			(x & 0xFF)
+
+#define LTC294X_WORK_DELAY		10	/* Update delay in seconds */
+
+#define LTC294X_MAX_VALUE		0xFFFF
+#define LTC294X_MID_SUPPLY		0x7FFF
+
+#define LTC2941_MAX_PRESCALER_EXP	7
+#define LTC2943_MAX_PRESCALER_EXP	6
+
+enum ltc294x_reg {
+	LTC294X_REG_STATUS		= 0x00,
+	LTC294X_REG_CONTROL		= 0x01,
+	LTC294X_REG_ACC_CHARGE_MSB	= 0x02,
+	LTC294X_REG_ACC_CHARGE_LSB	= 0x03,
+	LTC294X_REG_THRESH_HIGH_MSB	= 0x04,
+	LTC294X_REG_THRESH_HIGH_LSB	= 0x05,
+	LTC294X_REG_THRESH_LOW_MSB	= 0x06,
+	LTC294X_REG_THRESH_LOW_LSB	= 0x07,
+	LTC294X_REG_VOLTAGE_MSB	= 0x08,
+	LTC294X_REG_VOLTAGE_LSB	= 0x09,
+	LTC294X_REG_CURRENT_MSB	= 0x0E,
+	LTC294X_REG_CURRENT_LSB	= 0x0F,
+	LTC294X_REG_TEMPERATURE_MSB	= 0x14,
+	LTC294X_REG_TEMPERATURE_LSB	= 0x15,
+} ;
+
+#define LTC2943_REG_CONTROL_MODE_MASK (BIT(7) | BIT(6))
+#define LTC2943_REG_CONTROL_MODE_SCAN BIT(7)
+#define LTC294X_REG_CONTROL_PRESCALER_MASK	(BIT(5) | BIT(4) | BIT(3))
+#define LTC294X_REG_CONTROL_SHUTDOWN_MASK	(BIT(0))
+#define LTC294X_REG_CONTROL_PRESCALER_SET(x)		((x << 3) & LTC294X_REG_CONTROL_PRESCALER_MASK)
+#define LTC294X_REG_CONTROL_ALCC_CONFIG_DISABLED	0
+
+#define LTC2941_NUM_REGS	0x08
+#define LTC2943_NUM_REGS	0x18
+
+struct ltc294x_info {
+	struct i2c_client *client;	/* I2C Client pointer */
+	struct power_supply supply;	/* Supply pointer */
+	struct delayed_work work;	/* Work scheduler */
+	int num_regs; /* Number of registers (chip type) */
+	int	id;	/* Identifier of ltc294x chip */
+	int	charge;	/* Last measured charge value (uAh) */
+	int	r_sense;	/* mOhm */
+	int Qlsb;	/* nAh */
+};
+
+static DEFINE_IDR(ltc294x_id);
+static DEFINE_MUTEX(ltc294x_lock);
+
+static inline int convert_bin_to_uAh(
+	const struct ltc294x_info *info, int Q)
+{
+	int uAh;
+	uAh = ((Q * (info->Qlsb / 10))) / 100;
+	return uAh;
+}
+
+static inline int convert_uAh_to_bin(
+	const struct ltc294x_info *info, int uAh)
+{
+	int Q;
+	Q = (uAh * 100) / (info->Qlsb/10);
+	return (Q < LTC294X_MAX_VALUE) ? Q : LTC294X_MAX_VALUE;
+}
+
+static int ltc294x_read_regs(struct i2c_client *client,
+    enum ltc294x_reg reg, u8 *buf, int num_regs)
+{
+	int ret;
+	struct i2c_msg msgs[2] = { };
+	u8 reg_start = reg;
+
+	msgs[0].addr 	= client->addr;
+	msgs[0].len 	= 1;
+	msgs[0].buf 	= &reg_start;
+
+	msgs[1].addr 	= client->addr;
+	msgs[1].len 	= num_regs;
+	msgs[1].buf 	= buf;
+	msgs[1].flags	= I2C_M_RD;
+
+	ret = i2c_transfer(client->adapter, &msgs[0], 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "ltc2941 read_reg failed!\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ltc294x_write_regs(struct i2c_client *client, 
+	enum ltc294x_reg reg, const u8* const buf, int num_regs)
+{
+	int ret;
+	u8 reg_start = reg;
+
+	ret = i2c_smbus_write_i2c_block_data(client, reg_start, num_regs, buf);
+	if (ret < 0) {
+		dev_err(&client->dev, "ltc2941 write_reg failed!\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ltc294x_reset(const struct ltc294x_info *info, int prescaler_exp)
+{
+	int ret;
+	u8 value;
+	u8 control;
+
+	/* Read status and control registers */
+	ret = ltc294x_read_regs(info->client, LTC294X_REG_CONTROL, &value, 1);
+	if(ret < 0) {
+		dev_err(&info->client->dev, "LTC2941: Could not read registers from device!\n");
+		goto error_exit;
+	}
+	
+	control = LTC294X_REG_CONTROL_PRESCALER_SET(prescaler_exp) | 
+				LTC294X_REG_CONTROL_ALCC_CONFIG_DISABLED;
+	/* Put the 2943 into "monitor" mode, so it measures every 10 sec */
+	if (info->num_regs == LTC2943_NUM_REGS)
+		control |= LTC2943_REG_CONTROL_MODE_SCAN;
+
+	if (value != control) {
+		ret = ltc294x_write_regs(info->client, LTC294X_REG_CONTROL, &value, 1);
+		if(ret < 0){
+			dev_err(&info->client->dev, "Could not write registers!\n");
+			goto error_exit;
+		}
+	}
+
+	return 0;
+
+error_exit:
+	return ret;
+}
+
+static int ltc294x_get_charge_now(const struct ltc294x_info *info, int *val)
+{
+	int ret;
+	u8 datar[2];
+	u32 value;
+
+	ret = ltc294x_read_regs(info->client, LTC294X_REG_ACC_CHARGE_MSB, &datar[0], 2);
+	value = (datar[0] << 8) + datar[1];
+	*val = convert_bin_to_uAh(info, value);
+	return ret;
+}
+
+static int ltc294x_set_charge_now(const struct ltc294x_info *info, int val)
+{
+	int ret;
+	u8 dataw[2], ctrl_reg;
+	u32 value = convert_uAh_to_bin(info, val);
+
+	/* Read control register */
+	ret = ltc294x_read_regs(info->client, LTC294X_REG_CONTROL, &ctrl_reg, 1);
+	if(ret < 0)
+		goto error_exit;
+	/* Disable analog section */
+	ctrl_reg |= LTC294X_REG_CONTROL_SHUTDOWN_MASK;
+	ret = ltc294x_write_regs(info->client, LTC294X_REG_CONTROL, &ctrl_reg, 1);
+	if(ret < 0)
+		goto error_exit;
+	/* Set new charge value */
+	dataw[0] = I16_MSB(value);
+	dataw[1] = I16_LSB(value);
+	ret = ltc294x_write_regs(info->client, LTC294X_REG_ACC_CHARGE_MSB, &dataw[0], 2);
+	if(ret < 0)
+		goto error_exit;
+	/* Enable analog section */
+	ctrl_reg &= ~LTC294X_REG_CONTROL_SHUTDOWN_MASK;
+	ret = ltc294x_write_regs(info->client, LTC294X_REG_CONTROL, &ctrl_reg, 1);
+	if(ret < 0)
+		goto error_exit;
+
+	return 0;
+
+error_exit:
+	return ret;
+}
+
+static int ltc294x_get_charge_counter(const struct ltc294x_info *info, int *val)
+{
+	int ret;
+	ret = ltc294x_get_charge_now(info, val);
+	*val -= convert_bin_to_uAh(info, LTC294X_MID_SUPPLY);
+	return ret;
+}
+
+static int ltc294x_get_voltage(const struct ltc294x_info *info, int *val)
+{
+	int ret;
+	u8 datar[2];
+	u32 value;
+
+	ret = ltc294x_read_regs(info->client, LTC294X_REG_VOLTAGE_MSB, &datar[0], 2);
+	value = (datar[0] << 8) | datar[1];
+	*val = (value * 23600) / 0xFFFF;
+	return ret;
+}
+
+static int ltc294x_get_current(const struct ltc294x_info *info, int *val)
+{
+	int ret;
+	u8 datar[2];
+	s32 value;
+
+	ret = ltc294x_read_regs(info->client, LTC294X_REG_CURRENT_MSB, &datar[0], 2);
+	value = (datar[0] << 8) | datar[1];
+	value -= 0x7FFF;
+	*val = (60 * value) / (info->r_sense * 0x7FFF);
+	return ret;
+}
+
+static int ltc294x_get_temperature(const struct ltc294x_info *info, int *val)
+{
+	int ret;
+	u8 datar[2];
+	u32 value;
+
+	ret = ltc294x_read_regs(info->client, LTC294X_REG_TEMPERATURE_MSB, &datar[0], 2);
+	value = (datar[0] << 8) | datar[1];
+	 /* Full-scale is 510 Kelvin, convert to millidegrees  */
+	*val = (((51000 * value) / 0xFFFF) - 27215) * 10;
+	return ret;
+}
+
+static int ltc294x_get_property(struct power_supply *psy,
+				enum power_supply_property prop,
+				union power_supply_propval *val)
+{
+	struct ltc294x_info *info = container_of(psy, struct ltc294x_info, supply);
+
+	switch (prop) {
+		case POWER_SUPPLY_PROP_CHARGE_NOW:
+			return ltc294x_get_charge_now(info, &val->intval);
+		case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+			return ltc294x_get_charge_counter(info, &val->intval);
+		case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+			return ltc294x_get_voltage(info, &val->intval);
+		case POWER_SUPPLY_PROP_CURRENT_NOW:
+			return ltc294x_get_current(info, &val->intval);
+		case POWER_SUPPLY_PROP_TEMP:
+			return ltc294x_get_temperature(info, &val->intval);
+		default:
+			return -EINVAL;
+	}
+}
+
+static int ltc294x_set_property(struct power_supply *psy,
+	enum power_supply_property psp,
+	const union power_supply_propval *val)
+{
+	struct ltc294x_info *info =
+		container_of(psy, struct ltc294x_info, supply);
+
+	switch (psp) {
+		case POWER_SUPPLY_PROP_CHARGE_NOW:
+			return ltc294x_set_charge_now(info, val->intval);
+		default:
+			return -EPERM;
+	}
+}
+
+static int ltc294x_property_is_writeable(
+	struct power_supply *psy, enum power_supply_property psp)
+{
+	switch (psp) 
+	{
+		case POWER_SUPPLY_PROP_CHARGE_NOW:
+			return 1;
+		default:
+			return 0;
+	}
+}
+
+static void ltc294x_update(struct ltc294x_info *info)
+{
+	int charge;
+	charge = info->charge;
+	ltc294x_get_charge_now(info, &info->charge);
+	if(charge != info->charge){
+		power_supply_changed(&info->supply);
+	}
+}
+
+static void ltc294x_work(struct work_struct *work)
+{
+	struct ltc294x_info *info;
+
+	info = container_of(work, struct ltc294x_info, work.work);
+	ltc294x_update(info);
+	schedule_delayed_work(&info->work, LTC294X_WORK_DELAY * HZ);
+}
+
+static enum power_supply_property ltc294x_properties[] = {
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_TEMP,
+};
+
+static int ltc294x_i2c_remove(struct i2c_client *client)
+{
+	struct ltc294x_info *info = i2c_get_clientdata(client);
+	
+	cancel_delayed_work(&info->work);
+	power_supply_unregister(&info->supply);
+	kfree(info->supply.name);
+	mutex_lock(&ltc294x_lock);
+	idr_remove(&ltc294x_id, info->id);
+	mutex_unlock(&ltc294x_lock);
+	return 0;
+}
+
+static int ltc294x_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct ltc294x_info *info;
+	int ret;
+	int num;
+	unsigned int prescaler_exp, r_sense;
+	struct device_node *np;
+
+	mutex_lock(&ltc294x_lock);
+	ret = idr_alloc(&ltc294x_id, client, 0, 0, GFP_KERNEL);
+	mutex_unlock(&ltc294x_lock);
+	if(ret < 0)
+		goto fail_id;
+
+	num = ret;
+
+	info = devm_kzalloc(&client->dev, sizeof(*info), GFP_KERNEL);
+	if(info == NULL) {
+		dev_err(&client->dev, "Could not allocate memory for device structure!\n");
+		ret = -ENOMEM;
+		goto fail_info;
+	}
+
+	i2c_set_clientdata(client, info);
+
+	info->num_regs = id->driver_data;
+	info->supply.name = kasprintf(GFP_KERNEL, "%s-%d", client->name, num);
+	if(!info->supply.name) {
+		dev_err(&client->dev, "Could not allocate memory for device name!\n");
+		ret = -ENOMEM;
+		goto fail_name;
+	}
+
+	np = of_node_get(client->dev.of_node);
+
+	ret = of_property_read_u32(np, "resistor-sense", &r_sense);
+	if(ret < 0) {
+		dev_err(&client->dev, "Could not find resistor-sense in devicetree!\n");
+		goto fail_name;
+	}
+	info->r_sense = r_sense;
+	
+	ret = of_property_read_u32(np, "prescaler-exponent", &prescaler_exp);
+	if(ret < 0) {
+		dev_err(&client->dev, "PrescalerExponent not in devicetree, assume max.\n");
+		prescaler_exp = LTC2941_MAX_PRESCALER_EXP;
+	}
+
+	if (info->num_regs == LTC2943_NUM_REGS) {
+		if (prescaler_exp > LTC2943_MAX_PRESCALER_EXP)
+			prescaler_exp = LTC2943_MAX_PRESCALER_EXP;
+		info->Qlsb = ((340 * 50000) / r_sense) / (4096 / (1 << (2*prescaler_exp)));
+	} else {
+		if (prescaler_exp > LTC2941_MAX_PRESCALER_EXP)
+			prescaler_exp = LTC2941_MAX_PRESCALER_EXP;
+		info->Qlsb = ((58 * 50000) / r_sense) / (128 / (1 << prescaler_exp));
+	}
+
+	info->client = client;
+	info->id = num;
+	info->supply.type			= POWER_SUPPLY_TYPE_BATTERY;
+	info->supply.properties			= ltc294x_properties;
+	if (info->num_regs >= LTC294X_REG_TEMPERATURE_LSB)
+		info->supply.num_properties	= ARRAY_SIZE(ltc294x_properties);
+	else if (info->num_regs >= LTC294X_REG_CURRENT_LSB)
+		info->supply.num_properties	= ARRAY_SIZE(ltc294x_properties) - 1;
+	else if (info->num_regs >= LTC294X_REG_VOLTAGE_LSB)
+		info->supply.num_properties	= ARRAY_SIZE(ltc294x_properties) - 2;
+	else
+		info->supply.num_properties	= ARRAY_SIZE(ltc294x_properties) - 3;
+	info->supply.get_property		= ltc294x_get_property;
+	info->supply.set_property		= ltc294x_set_property;
+	info->supply.property_is_writeable	= ltc294x_property_is_writeable;
+	info->supply.external_power_changed	= NULL;
+
+	INIT_DELAYED_WORK(&info->work, ltc294x_work);
+
+	ret = ltc294x_reset(info, prescaler_exp);
+	if (ret < 0) {
+		dev_err(&client->dev, "Communication with chip failed!\n");
+		goto fail_comm;
+	}
+
+	ret = power_supply_register(&client->dev, &info->supply);
+	if (ret) {
+		dev_err(&client->dev, "failed to register ltc2941\n");
+		goto fail_register;
+	} else {
+		schedule_delayed_work(&info->work, LTC294X_WORK_DELAY * HZ);
+	}
+
+	return 0;
+
+fail_register:
+	kfree(info->supply.name);
+fail_comm:
+fail_name:
+fail_info:
+	mutex_lock(&ltc294x_lock);
+	idr_remove(&ltc294x_id, num);
+	mutex_unlock(&ltc294x_lock);
+fail_id:
+	return ret;
+}
+
+#ifdef CONFIG_PM_SLEEP
+
+static int ltc294x_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ltc294x_info *info = i2c_get_clientdata(client);
+
+	cancel_delayed_work(&info->work);
+	return 0;
+}
+
+static int ltc294x_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ltc294x_info *info = i2c_get_clientdata(client);
+
+	schedule_delayed_work(&info->work, LTC294X_WORK_DELAY * HZ);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(ltc294x_pm_ops, ltc294x_suspend, ltc294x_resume);
+#define LTC294X_PM_OPS (&ltc294x_pm_ops)
+
+#else
+#define LTC294X_PM_OPS NULL
+#endif /* CONFIG_PM_SLEEP */
+
+
+static const struct i2c_device_id ltc294x_i2c_id[] = {
+	{"ltc2941", LTC2941_NUM_REGS},
+	{"ltc2943", LTC2943_NUM_REGS}, 
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, ltc294x_i2c_id);
+
+static struct i2c_driver ltc294x_driver = {
+	.driver 	= {
+		.name	= "LTC2941",
+		.owner	= THIS_MODULE,
+		.pm 	= LTC294X_PM_OPS,
+	},
+	.probe		= ltc294x_i2c_probe,
+	.remove		= ltc294x_i2c_remove,
+	.id_table	= ltc294x_i2c_id,
+};
+module_i2c_driver(ltc294x_driver);
+
+MODULE_AUTHOR("Auryn Verwegen, Topic Embedded Systems");
+MODULE_AUTHOR("Mike Looijmans, Topic Embedded Products");
+MODULE_DESCRIPTION("LTC2941/LTC2943 Battery Gas Gauge IC driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

