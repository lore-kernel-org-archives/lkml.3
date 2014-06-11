Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaFKLT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:19:27 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.165]:61424 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbaFKLRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:17:45 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-16.tower-38.messagelabs.com!1402485096!3045582!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <d4ef0d7ce2d6a2919d528ed75e82d2b99ec8d962.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 11 Jun 2014 12:11:34 +0100
Subject: [PATCH 6/8] power: Add support for DA9150 Charger
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DA9150 Charger & Fuel-Guage IC Charger.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 drivers/power/Kconfig              |  23 ++
 drivers/power/Makefile             |   1 +
 drivers/power/da9150-charger.c     | 790 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/da9150/charger.h |  58 +++
 4 files changed, 872 insertions(+)
 create mode 100644 drivers/power/da9150-charger.c
 create mode 100644 include/linux/mfd/da9150/charger.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index ba69751..9835a78 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -185,6 +185,29 @@ config BATTERY_DA9052
 	  Say Y here to enable support for batteries charger integrated into
 	  DA9052 PMIC.

+config CHARGER_DA9150
+	tristate "Dialog Semiconductor DA9150 Charger support"
+	depends on MFD_DA9150
+	depends on DA9150_GPADC
+	depends on IIO
+	help
+	  Say Y here to enable support for charger unit of the DA9150
+	  Integrated Charger & Fuel-Gauge IC.
+
+	  This driver can also be built as a module. If so, the module will be
+	  called da9150-charger.
+
+config CHARGER_DA9150_OTG_VBUS_EVENT
+	bool "Dialog Semiconductor DA9150 OTG VBUS event support"
+	depends on CHARGER_DA9150
+	help
+	  Say Y here if you have an OTG device driver which can supply events,
+	  using the otg transceiver, for when a USB host or charger is connected
+	  which provides power over VBUS. This setting overrides the default
+	  DA9150 support to indicate this type of event. Note that the default
+	  support cannot determine the type of device that is providing VBUS
+	  power and therefore assumes AC charger type.
+
 config BATTERY_MAX17040
 	tristate "Maxim MAX17040 Fuel Gauge"
 	depends on I2C
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index ee54a3e..2cdefaa 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_BATTERY_SBS)	+= sbs-battery.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
 obj-$(CONFIG_BATTERY_DA9052)	+= da9052-battery.o
+obj-$(CONFIG_CHARGER_DA9150)	+= da9150-charger.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_BATTERY_MAX17042)	+= max17042_battery.o
 obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
diff --git a/drivers/power/da9150-charger.c b/drivers/power/da9150-charger.c
new file mode 100644
index 0000000..dd93fb4
--- /dev/null
+++ b/drivers/power/da9150-charger.c
@@ -0,0 +1,790 @@
+/*
+ * DA9150 Charger Driver
+ *
+ * Copyright (c) 2014 Dialog Semiconductor
+ *
+ * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/interrupt.h>
+#include <linux/timer.h>
+#include <linux/power_supply.h>
+#include <linux/notifier.h>
+#include <linux/usb/phy.h>
+#include <linux/iio/consumer.h>
+#include <linux/sysfs.h>
+
+#include <linux/mfd/da9150/core.h>
+#include <linux/mfd/da9150/pdata.h>
+#include <linux/mfd/da9150/registers.h>
+#include <linux/mfd/da9150/charger.h>
+
+
+/*
+ * Common property functions
+ */
+
+static inline int da9150_charger_supply_online(struct da9150_charger *charger,
+					       struct power_supply *psy,
+					       union power_supply_propval *val)
+{
+	val->intval = (psy == charger->supply_online) ? 1 : 0;
+
+	return 0;
+}
+
+static int da9150_charger_vbus_voltage_now(struct da9150_charger *charger,
+					   union power_supply_propval *val)
+{
+	struct iio_channel *chan = charger->vbus_chan;
+
+	if (!chan)
+		return -EINVAL;
+
+	/* Read processed value - uV units */
+	return iio_read_channel_processed(chan, &val->intval);
+}
+
+static int da9150_charger_ibus_current_avg(struct da9150_charger *charger,
+					   union power_supply_propval *val)
+{
+	struct iio_channel *chan = charger->ibus_chan;
+
+	if (!chan)
+		return -EINVAL;
+
+	/* Read processed value - uA degrees C units */
+	return iio_read_channel_processed(chan, &val->intval);
+}
+
+static int da9150_charger_tjunc_temp(struct da9150_charger *charger,
+				     union power_supply_propval *val)
+{
+	struct iio_channel *chan = charger->tjunc_chan;
+
+	if (!chan)
+		return -EINVAL;
+
+	/* Read processed value - 0.1 degrees C units */
+	return iio_read_channel_processed(chan, &val->intval);
+}
+
+
+/*
+ * USB Properties
+ */
+
+static enum power_supply_property da9150_charger_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_TEMP,
+};
+
+static int da9150_charger_get_prop(struct power_supply *psy,
+				   enum power_supply_property psp,
+				   union power_supply_propval *val)
+{
+	struct da9150_charger *charger = dev_get_drvdata(psy->dev->parent);
+	int ret;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		ret = da9150_charger_supply_online(charger, psy, val);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = da9150_charger_vbus_voltage_now(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		ret = da9150_charger_ibus_current_avg(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		ret = da9150_charger_tjunc_temp(charger, val);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+
+/*
+ * Battery Properties
+ */
+
+static int da9150_charger_battery_status(struct da9150_charger *charger,
+					 union power_supply_propval *val)
+{
+	u8 reg;
+
+	/* Check to see if battery is discharging */
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_H);
+
+	if (((reg & DA9150_VBUS_STAT_MASK) == DA9150_VBUS_STAT_OFF) ||
+	    ((reg & DA9150_VBUS_STAT_MASK) == DA9150_VBUS_STAT_WAIT)) {
+		val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+
+		return 0;
+	}
+
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_J);
+
+	/* Now check for other states */
+	switch (reg & DA9150_CHG_STAT_MASK) {
+	case DA9150_CHG_STAT_ACT:
+	case DA9150_CHG_STAT_PRE:
+	case DA9150_CHG_STAT_CC:
+	case DA9150_CHG_STAT_CV:
+		val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		break;
+	case DA9150_CHG_STAT_OFF:
+	case DA9150_CHG_STAT_SUSP:
+	case DA9150_CHG_STAT_TEMP:
+	case DA9150_CHG_STAT_TIME:
+	case DA9150_CHG_STAT_BAT:
+		val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		break;
+	case DA9150_CHG_STAT_FULL:
+		val->intval = POWER_SUPPLY_STATUS_FULL;
+		break;
+	default:
+		val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+		break;
+	}
+
+	return 0;
+}
+
+static int da9150_charger_battery_health(struct da9150_charger *charger,
+					 union power_supply_propval *val)
+{
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_J);
+
+	/* Check if temperature limit reached */
+	switch (reg & DA9150_CHG_TEMP_MASK) {
+	case DA9150_CHG_TEMP_UNDER:
+		val->intval = POWER_SUPPLY_HEALTH_COLD;
+		return 0;
+	case DA9150_CHG_TEMP_OVER:
+		val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		return 0;
+	default:
+		break;
+	}
+
+	/* Check for other health states */
+	switch (reg & DA9150_CHG_STAT_MASK) {
+	case DA9150_CHG_STAT_ACT:
+	case DA9150_CHG_STAT_PRE:
+		val->intval = POWER_SUPPLY_HEALTH_DEAD;
+		break;
+	case DA9150_CHG_STAT_TIME:
+		val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+		break;
+	default:
+		val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+	}
+
+	return 0;
+}
+
+static int da9150_charger_battery_present(struct da9150_charger *charger,
+					  union power_supply_propval *val)
+{
+	u8 reg;
+
+	/* No valid TBAT reading so assume battery present */
+	if (charger->invalid_tbat) {
+		val->intval = 1;
+		return 0;
+	}
+
+	/* Check if battery present or removed */
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_J);
+	if ((reg & DA9150_CHG_STAT_MASK) == DA9150_CHG_STAT_BAT)
+		val->intval = 0;
+	else
+		val->intval = 1;
+
+	return 0;
+}
+
+static int da9150_charger_battery_charge_type(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_J);
+
+	switch (reg & DA9150_CHG_STAT_MASK) {
+	case DA9150_CHG_STAT_CC:
+		val->intval = POWER_SUPPLY_CHARGE_TYPE_FAST;
+		break;
+	case DA9150_CHG_STAT_ACT:
+	case DA9150_CHG_STAT_PRE:
+	case DA9150_CHG_STAT_CV:
+		val->intval = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
+		break;
+	default:
+		val->intval = POWER_SUPPLY_CHARGE_TYPE_NONE;
+		break;
+	}
+
+	return 0;
+}
+
+static int da9150_charger_battery_voltage_min(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_PPR_CHGCTRL_C);
+
+	/* Value starts at 2500 mV, 50 mV increments, presented in uV */
+	val->intval = ((reg & DA9150_CHG_VFAULT_MASK) * 50000) + 2500000;
+
+	return 0;
+}
+
+static int da9150_charger_battery_voltage_now(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	struct iio_channel *chan = charger->vbat_chan;
+
+	if (!chan)
+		return -EINVAL;
+
+	/* Read processed value - uV units */
+	return iio_read_channel_processed(chan, &val->intval);
+}
+
+static int da9150_charger_battery_current_max(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	int reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_PPR_CHGCTRL_D);
+
+	val->intval = DA9150_CHG_IBAT_REG_TO_UA(reg);
+
+	return 0;
+}
+
+static int da9150_charger_battery_voltage_max(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_PPR_CHGCTRL_B);
+
+	/* Value starts at 3650 mV, 25 mV increments, presented in uV */
+	val->intval = ((reg & DA9150_CHG_VBAT_MASK) * 25000) + 3650000;
+	return 0;
+}
+
+static enum power_supply_property da9150_charger_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
+};
+
+static int da9150_charger_battery_get_prop(struct power_supply *psy,
+					   enum power_supply_property psp,
+					   union power_supply_propval *val)
+{
+	struct da9150_charger *charger = dev_get_drvdata(psy->dev->parent);
+	int ret;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		ret = da9150_charger_battery_status(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		ret = da9150_charger_supply_online(charger, psy, val);
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		ret = da9150_charger_battery_health(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		ret = da9150_charger_battery_present(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		ret = da9150_charger_battery_charge_type(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		ret = da9150_charger_battery_voltage_min(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = da9150_charger_battery_voltage_now(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX:
+		ret = da9150_charger_battery_current_max(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX:
+		ret = da9150_charger_battery_voltage_max(charger, val);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+
+/*
+ * Other properties
+ */
+
+static ssize_t da9150_charger_attr_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf);
+
+#define DA9150_CHARGER_ATTR(_name, _reg, _shift, _mask)		\
+	{							\
+		.attr = __ATTR(_name, S_IRUGO,			\
+			       da9150_charger_attr_show,	\
+			       NULL),				\
+		.reg = _reg,					\
+		.shift = _shift,				\
+		.mask = _mask,					\
+	}
+
+static struct da9150_charger_attr_map da9150_charger_attrs[] = {
+	DA9150_CHARGER_ATTR(chg_en, DA9150_PPR_CHGCTRL_A,
+			    DA9150_CHG_EN_SHIFT, DA9150_CHG_EN_MASK),
+	DA9150_CHARGER_ATTR(chg_ipre, DA9150_PPR_CHGCTRL_C,
+			    DA9150_CHG_IPRE_SHIFT, DA9150_CHG_IPRE_MASK),
+	DA9150_CHARGER_ATTR(chg_iend, DA9150_PPR_CHGCTRL_E,
+			    DA9150_CHG_IEND_SHIFT, DA9150_CHG_IEND_MASK),
+	DA9150_CHARGER_ATTR(chg_temp, DA9150_STATUS_J,
+			    DA9150_CHG_TEMP_SHIFT, DA9150_CHG_TEMP_MASK),
+	DA9150_CHARGER_ATTR(chg_vdrop, DA9150_PPR_CHGCTRL_B,
+			    DA9150_CHG_VDROP_SHIFT, DA9150_CHG_VDROP_MASK),
+	DA9150_CHARGER_ATTR(tbat_upper, DA9150_PPR_THYST_E,
+			    DA9150_TBAT_T5_SHIFT, DA9150_TBAT_T5_MASK),
+	DA9150_CHARGER_ATTR(tbat_lower, DA9150_PPR_THYST_A,
+			    DA9150_TBAT_T1_SHIFT, DA9150_TBAT_T1_MASK),
+	DA9150_CHARGER_ATTR(vbus_mode, DA9150_PPR_BKCTRL_A,
+			    DA9150_VBUS_MODE_SHIFT, DA9150_VBUS_MODE_MASK),
+	DA9150_CHARGER_ATTR(vbus_tred, DA9150_STATUS_H,
+			    DA9150_VBUS_TRED_SHIFT, DA9150_VBUS_TRED_MASK),
+	DA9150_CHARGER_ATTR(vbus_drop_stat, DA9150_STATUS_H,
+			    DA9150_VBUS_DROP_STAT_SHIFT,
+			    DA9150_VBUS_DROP_STAT_MASK),
+};
+
+static ssize_t da9150_charger_attr_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct da9150_charger *charger = dev_get_drvdata(dev);
+	struct da9150_charger_attr_map *charger_attrs;
+	int i;
+
+	/* Find attribute, and print out register field contents. */
+	for (i = 0, charger_attrs = da9150_charger_attrs;
+	     i < ARRAY_SIZE(da9150_charger_attrs);
+	     ++i, ++charger_attrs) {
+		if (attr == &charger_attrs->attr) {
+			u8 val;
+
+			val = da9150_reg_read(charger->da9150,
+					      charger_attrs->reg);
+			val &= charger_attrs->mask;
+			val = val >> charger_attrs->shift;
+
+			return sprintf(buf, "0x%x\n", val);
+		}
+	}
+
+	return 0;
+}
+
+
+/*
+ * IRQs
+ */
+
+static irqreturn_t da9150_charger_chg_irq(int irq, void *data)
+{
+	struct da9150_charger *charger = data;
+
+	power_supply_changed(&charger->battery);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t da9150_charger_tjunc_irq(int irq, void *data)
+{
+	struct da9150_charger *charger = data;
+
+	/* Nothing we can really do except report this. */
+	dev_crit(charger->dev, "TJunc over temperature!!!\n");
+	power_supply_changed(&charger->ac);
+	power_supply_changed(&charger->usb);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t da9150_charger_vfault_irq(int irq, void *data)
+{
+	struct da9150_charger *charger = data;
+
+	/* Nothing we can really do except report this. */
+	dev_crit(charger->dev, "VSYS under voltage!!!\n");
+	power_supply_changed(&charger->ac);
+	power_supply_changed(&charger->usb);
+	power_supply_changed(&charger->battery);
+
+	return IRQ_HANDLED;
+}
+
+#ifndef CONFIG_CHARGER_DA9150_OTG_VBUS_EVENT
+static irqreturn_t da9150_charger_vbus_irq(int irq, void *data)
+{
+	struct da9150_charger *charger = data;
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_H);
+
+	/* Charger plugged in or battery only */
+	switch (reg & DA9150_VBUS_STAT_MASK) {
+	case DA9150_VBUS_STAT_OFF:
+	case DA9150_VBUS_STAT_WAIT:
+		charger->supply_online = &charger->battery;
+		break;
+	case DA9150_VBUS_STAT_CHG:
+		/* Cannot determine charger type so assume AC */
+		charger->supply_online = &charger->ac;
+		break;
+	default:
+		dev_warn(charger->dev, "Unknown VBUS state - reg = 0x%x\n",
+			 reg);
+		charger->supply_online = NULL;
+		break;
+	}
+
+	power_supply_changed(&charger->ac);
+	power_supply_changed(&charger->battery);
+
+	return IRQ_HANDLED;
+}
+#endif /* CONFIG_CHARGER_DA9150_OTG_VBUS_EVENT */
+
+
+/*
+ * Power Management
+ */
+
+static void da9150_charger_shutdown(struct platform_device *pdev)
+{
+	struct da9150_charger *charger = platform_get_drvdata(pdev);
+
+	/* Only allow device into shutdown state if we're not charging. */
+	if ((charger->supply_online != &charger->ac) &&
+	    (charger->supply_online != &charger->usb))
+		charger->da9150->can_shutdown = true;
+}
+
+
+/*
+ * OTG Notification & handling
+ */
+static void da9150_charger_otg_work(struct work_struct *data)
+{
+	struct da9150_charger *charger =
+		container_of(data, struct da9150_charger, otg_work);
+
+	switch (charger->usb_event) {
+#ifdef CONFIG_CHARGER_DA9150_OTG_VBUS_EVENT
+	case USB_EVENT_CHARGER:
+		/* AC Supply online */
+		charger->supply_online = &charger->ac;
+		power_supply_changed(&charger->ac);
+		power_supply_changed(&charger->battery);
+		break;
+	case USB_EVENT_VBUS:
+	case USB_EVENT_ENUMERATED:
+		/* USB Supply online */
+		charger->supply_online = &charger->usb;
+		power_supply_changed(&charger->usb);
+		power_supply_changed(&charger->battery);
+		break;
+#endif /* CONFIG_CHARGER_DA9150_OTG_VBUS_EVENT */
+	case USB_EVENT_ID:
+		/* Enable OTG Boost */
+		da9150_set_bits(charger->da9150, DA9150_PPR_BKCTRL_A,
+				DA9150_VBUS_MODE_MASK, DA9150_VBUS_MODE_OTG);
+		break;
+	case USB_EVENT_NONE:
+		/* Revert to charge mode */
+		power_supply_changed(&charger->ac);
+		power_supply_changed(&charger->usb);
+		power_supply_changed(&charger->battery);
+		da9150_set_bits(charger->da9150, DA9150_PPR_BKCTRL_A,
+				DA9150_VBUS_MODE_MASK, DA9150_VBUS_MODE_CHG);
+		break;
+	}
+}
+
+static int da9150_charger_otg_ncb(struct notifier_block *nb, unsigned long val,
+				  void *priv)
+{
+	struct da9150_charger *charger =
+		container_of(nb, struct da9150_charger, otg_nb);
+
+	dev_dbg(charger->dev, "DA9150 OTG notify %lu\n", val);
+
+	charger->usb_event = val;
+	schedule_work(&charger->otg_work);
+
+	return NOTIFY_OK;
+}
+
+
+/*
+ * DT Platform Data
+ */
+
+static struct da9150_charger_pdata *da9150_charger_dt_pdata(struct device *dev)
+{
+	struct device_node *charger_node = dev->of_node;
+	struct da9150_charger_pdata *pdata;
+
+	pdata = devm_kzalloc(dev, sizeof(struct da9150_charger_pdata),
+			     GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	pdata->invalid_tbat =
+		of_property_read_bool(charger_node, "dlg,invalid-tbat");
+
+	return pdata;
+}
+
+
+/*
+ * Driver top level functions
+ */
+
+static int da9150_charger_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct da9150_charger_pdata *charger_pdata = dev_get_platdata(dev);
+	struct da9150 *da9150 = dev_get_drvdata(dev->parent);
+	struct da9150_charger *charger;
+	struct power_supply *ac, *usb, *battery;
+	struct iio_channel *chan;
+	u8 reg;
+	int i, ret;
+
+	/* Check GPADC is available, if not defer until it is */
+	if (!da9150->gpadc_ready)
+		return -EPROBE_DEFER;
+
+	charger = devm_kzalloc(dev, sizeof(struct da9150_charger), GFP_KERNEL);
+	if (charger == NULL)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, charger);
+	charger->da9150 = da9150;
+	charger->dev = dev;
+
+	/* Handle DT data if provided */
+	if (dev->of_node) {
+		charger_pdata = da9150_charger_dt_pdata(dev);
+		dev->platform_data = charger_pdata;
+	}
+
+	/* Handle any platform data */
+	if (charger_pdata) {
+		/* Does platform expect battery to have valid tbat? */
+		reg = da9150_reg_read(da9150, DA9150_PPR_CHGCTRL_F);
+		if (charger_pdata->invalid_tbat &&
+		    (reg & DA9150_TBAT_TQA_EN_MASK))
+			dev_warn(dev, "TBAT based charging expected, "
+				 "but not enabled\n");
+
+		charger->invalid_tbat = charger_pdata->invalid_tbat;
+	}
+
+	/* Acquire ADC channels */
+	chan = iio_channel_get(dev, "CHAN_IBUS");
+	charger->ibus_chan = IS_ERR(chan) ? NULL : chan;
+
+	chan = iio_channel_get(dev, "CHAN_VBUS");
+	charger->vbus_chan = IS_ERR(chan) ? NULL : chan;
+
+	chan = iio_channel_get(dev, "CHAN_TJUNC");
+	charger->tjunc_chan = IS_ERR(chan) ? NULL : chan;
+
+	chan = iio_channel_get(dev, "CHAN_VBAT");
+	charger->vbat_chan = IS_ERR(chan) ? NULL : chan;
+
+	/* Register power supplies */
+	ac = &charger->ac;
+	usb = &charger->usb;
+	battery = &charger->battery;
+
+	ac->name = "da9150-ac",
+	ac->type = POWER_SUPPLY_TYPE_MAINS;
+	ac->properties = da9150_charger_props;
+	ac->num_properties = ARRAY_SIZE(da9150_charger_props);
+	ac->get_property = da9150_charger_get_prop;
+	ret = power_supply_register(dev, ac);
+	if (ret)
+		return ret;
+
+	usb->name = "da9150-usb",
+	usb->type = POWER_SUPPLY_TYPE_USB;
+	usb->properties = da9150_charger_props;
+	usb->num_properties = ARRAY_SIZE(da9150_charger_props);
+	usb->get_property = da9150_charger_get_prop;
+	ret = power_supply_register(dev, usb);
+	if (ret)
+		goto usb_fail;
+
+	battery->name = "da9150-battery";
+	battery->type = POWER_SUPPLY_TYPE_BATTERY;
+	battery->properties = da9150_charger_bat_props;
+	battery->num_properties = ARRAY_SIZE(da9150_charger_bat_props);
+	battery->get_property = da9150_charger_battery_get_prop;
+	ret = power_supply_register(dev, battery);
+	if (ret)
+		goto battery_fail;
+
+	/* Create additional sysfs attributes */
+	for (i = 0; i < ARRAY_SIZE(da9150_charger_attrs); ++i) {
+		ret = device_create_file(dev, &da9150_charger_attrs[i].attr);
+		if (ret < 0)
+			goto sysfs_fail;
+	}
+
+	/* Get initial online supply */
+	reg = da9150_reg_read(da9150, DA9150_STATUS_H);
+
+	/* Charger plugged in or battery only */
+	switch (reg & DA9150_VBUS_STAT_MASK) {
+	case DA9150_VBUS_STAT_OFF:
+	case DA9150_VBUS_STAT_WAIT:
+		charger->supply_online = &charger->battery;
+		break;
+	case DA9150_VBUS_STAT_CHG:
+		/* Default to AC charger as we don't know yet */
+		charger->supply_online = &charger->ac;
+		break;
+	default:
+		dev_warn(dev, "Unknown VBUS state - reg = 0x%x\n", reg);
+		charger->supply_online = NULL;
+		break;
+	}
+
+	/* Setup OTG reporting & configuration */
+	charger->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+	if (charger->usb_phy != NULL) {
+		INIT_WORK(&charger->otg_work, da9150_charger_otg_work);
+		charger->otg_nb.notifier_call = da9150_charger_otg_ncb;
+		usb_register_notifier(charger->usb_phy, &charger->otg_nb);
+	}
+
+	/* Register IRQs */
+	ret = da9150_register_irq(pdev, charger, da9150_charger_chg_irq,
+				  "CHG_STATUS");
+	if (ret < 0)
+		goto irq_fail;
+
+	ret = da9150_register_irq(pdev, charger, da9150_charger_tjunc_irq,
+				  "CHG_TJUNC");
+	if (ret < 0)
+		goto irq_fail;
+
+	ret = da9150_register_irq(pdev, charger, da9150_charger_vfault_irq,
+				  "CHG_VFAULT");
+	if (ret < 0)
+		goto irq_fail;
+
+#ifndef CONFIG_CHARGER_DA9150_OTG_VBUS_EVENT
+	da9150_register_irq(pdev, charger, da9150_charger_vbus_irq, "CHG_VBUS");
+	if (ret < 0)
+		goto irq_fail;
+#endif /* CONFIG_CHARGER_DA9150_OTG_VBUS_EVENT */
+
+	return ret;
+
+irq_fail:
+sysfs_fail:
+	while (--i >= 0)
+		device_remove_file(&pdev->dev, &da9150_charger_attrs[i].attr);
+
+battery_fail:
+	power_supply_unregister(usb);
+
+usb_fail:
+	power_supply_unregister(ac);
+
+	return ret;
+}
+
+static int da9150_charger_remove(struct platform_device *pdev)
+{
+	struct da9150_charger *charger = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(da9150_charger_attrs); ++i)
+		device_remove_file(&pdev->dev, &da9150_charger_attrs[i].attr);
+
+	/* Release ADC channels */
+	if (charger->ibus_chan)
+		iio_channel_release(charger->ibus_chan);
+	if (charger->vbus_chan)
+		iio_channel_release(charger->vbus_chan);
+	if (charger->tjunc_chan)
+		iio_channel_release(charger->tjunc_chan);
+	if (charger->vbat_chan)
+		iio_channel_release(charger->vbat_chan);
+
+	power_supply_unregister(&charger->battery);
+	power_supply_unregister(&charger->usb);
+	power_supply_unregister(&charger->ac);
+
+	return 0;
+}
+
+static struct platform_driver da9150_charger_driver = {
+	.driver = {
+		.name = "da9150-charger",
+		.owner = THIS_MODULE,
+	},
+	.probe = da9150_charger_probe,
+	.remove = da9150_charger_remove,
+	.shutdown = da9150_charger_shutdown,
+};
+
+module_platform_driver(da9150_charger_driver);
+
+MODULE_DESCRIPTION("Charger Driver for DA9150");
+MODULE_AUTHOR("Adam Thomson <Adam.Thomson.Opensource@diasemi.com");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/da9150/charger.h b/include/linux/mfd/da9150/charger.h
new file mode 100644
index 0000000..73c41b3
--- /dev/null
+++ b/include/linux/mfd/da9150/charger.h
@@ -0,0 +1,58 @@
+/*
+ * DA9150 MFD Driver - Charger Data
+ *
+ * Copyright (c) 2014 Dialog Semiconductor
+ *
+ * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef _DA9150_CHARGER_H
+#define _DA9150_CHARGER_H
+
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/power_supply.h>
+#include <linux/notifier.h>
+#include <linux/usb/otg.h>
+#include <linux/timer.h>
+#include <linux/iio/consumer.h>
+
+#include <linux/mfd/da9150/core.h>
+
+
+struct da9150_charger_attr_map {
+	struct device_attribute attr;
+	u16 reg;
+	u8 shift;
+	u8 mask;
+};
+
+/* Private data */
+struct da9150_charger {
+	struct da9150 *da9150;
+	struct device *dev;
+
+	struct power_supply ac;
+	struct power_supply usb;
+	struct power_supply battery;
+	struct power_supply *supply_online;
+
+	struct usb_phy *usb_phy;
+	struct notifier_block otg_nb;
+	struct work_struct otg_work;
+	unsigned long usb_event;
+
+	struct iio_channel *ibus_chan;
+	struct iio_channel *vbus_chan;
+	struct iio_channel *tjunc_chan;
+	struct iio_channel *vbat_chan;
+
+	bool invalid_tbat;
+};
+
+#endif /* _DA9150_CHARGER_H */
--
1.9.3

