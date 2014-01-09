Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbaAIQtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:49:43 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35920 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbaAIQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:49:11 -0500
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
To: <anton@enomsg.org>, <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Cc: <mk7.kang@samsung.com>
Subject: [PATCH 1/3] power_supply: modelgauge_battery: Maxim ModelGauge ICs gauge
Date: Thu,  9 Jan 2014 20:49:03 +0400
Message-Id: <1389286145-15375-2-git-send-email-vladimir.barinov@cogentembedded.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
References: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Maxim ModelGauge ICs gauge driver for MAX17040/41/43/44/48/49/58/59 chips

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

---
 drivers/power/Kconfig                            |    8 
 drivers/power/Makefile                           |    1 
 drivers/power/modelgauge_battery.c               |  875 +++++++++++++++++++++++
 include/linux/platform_data/battery-modelgauge.h |   44 +
 4 files changed, 928 insertions(+)

Index: battery-2.6/drivers/power/Kconfig
===================================================================
--- battery-2.6.orig/drivers/power/Kconfig	2014-01-09 15:09:31.455138730 +0400
+++ battery-2.6/drivers/power/Kconfig	2014-01-09 15:09:36.331138847 +0400
@@ -204,6 +204,14 @@
 	  with MAX17042. This driver also supports max17047/50 chips which are
 	  improved version of max17042.
 
+config BATTERY_MODELGAUGE
+	tristate "Maxim ModelGauge ICs fuel gauge"
+	depends on I2C
+	help
+	  ModelGauge(TM) is a Maxim algorithm incorporated in
+	  MAX17040/41/43/44/48/49/58/59 fuel-gauges for lithium-ion (Li+)
+	  batteries.
+
 config BATTERY_Z2
 	tristate "Z2 battery driver"
 	depends on I2C && MACH_ZIPIT2
Index: battery-2.6/drivers/power/Makefile
===================================================================
--- battery-2.6.orig/drivers/power/Makefile	2014-01-09 15:09:31.483138731 +0400
+++ battery-2.6/drivers/power/Makefile	2014-01-09 15:09:36.331138847 +0400
@@ -32,6 +32,7 @@
 obj-$(CONFIG_BATTERY_DA9052)	+= da9052-battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_BATTERY_MAX17042)	+= max17042_battery.o
+obj-$(CONFIG_BATTERY_MODELGAUGE)	+= modelgauge_battery.o
 obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
 obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
 obj-$(CONFIG_CHARGER_88PM860X)	+= 88pm860x_charger.o
Index: battery-2.6/drivers/power/modelgauge_battery.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ battery-2.6/drivers/power/modelgauge_battery.c	2014-01-09 15:09:36.335138846 +0400
@@ -0,0 +1,875 @@
+/*
+ * Maxim ModelGauge ICs fuel gauge driver
+ *
+ * Author: Vladimir Barinov <source@cogentembedded.com>
+ * Copyright (C) 2013 Cogent Embedded, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/power_supply.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/battery-modelgauge.h>
+#include <linux/slab.h>
+
+#define DRV_NAME "modelgauge"
+
+/* Register offsets for ModelGauge ICs */
+#define MODELGAUGE_VCELL_REG		0x02
+#define MODELGAUGE_SOC_REG		0x04
+#define MODELGAUGE_MODE_REG		0x06
+#define MODELGAUGE_VERSION_REG		0x08
+#define MODELGAUGE_HIBRT_REG		0x0A
+#define MODELGAUGE_CONFIG_REG		0x0C
+#define MODELGAUGE_OCV_REG		0x0E
+#define MODELGAUGE_VALRT_REG		0x14
+#define MODELGAUGE_CRATE_REG		0x16
+#define MODELGAUGE_VRESETID_REG		0x18
+#define MODELGAUGE_STATUS_REG		0x1A
+#define MODELGAUGE_UNLOCK_REG		0x3E
+#define MODELGAUGE_TABLE_REG		0x40
+#define MODELGAUGE_RCOMPSEG_REG		0x80
+#define MODELGAUGE_CMD_REG		0xFE
+
+/* MODE register bits */
+#define MODELGAUGE_MODE_QUICKSTART	(1 << 14)
+#define MODELGAUGE_MODE_ENSLEEP		(1 << 13)
+#define MODELGAUGE_MODE_HIBSTAT		(1 << 12)
+
+/* CONFIG register bits */
+#define MODELGAUGE_CONFIG_SLEEP		(1 << 7)
+#define MODELGAUGE_CONFIG_ALSC		(1 << 6)
+#define MODELGAUGE_CONFIG_ALRT		(1 << 5)
+#define MODELGAUGE_CONFIG_ATHD_MASK	0x1f
+
+/* STATUS register bits */
+#define MODELGAUGE_STATUS_ENVR		(1 << 14)
+#define MODELGAUGE_STATUS_SC		(1 << 13)
+#define MODELGAUGE_STATUS_HD		(1 << 12)
+#define MODELGAUGE_STATUS_VR		(1 << 11)
+#define MODELGAUGE_STATUS_VL		(1 << 10)
+#define MODELGAUGE_STATUS_VH		(1 << 9)
+#define MODELGAUGE_STATUS_RI		(1 << 8)
+
+/* VRESETID register bits */
+#define MODELGAUGE_VRESETID_DIS		(1 << 8)
+
+#define MODELGAUGE_UNLOCK_VALUE		0x4a57
+#define MODELGAUGE_RESET_VALUE		0x5400
+
+#define MODELGAUGE_RCOMP_UPDATE_DELAY	60000
+
+enum chip_id {
+	ID_MAX17040,
+	ID_MAX17041,
+	ID_MAX17043,
+	ID_MAX17044,
+	ID_MAX17048,
+	ID_MAX17049,
+	ID_MAX17058,
+	ID_MAX17059,
+};
+
+struct modelgauge_priv {
+	struct i2c_client		*client;
+	struct power_supply		battery;
+	struct modelgauge_platform_data	*pdata;
+	enum chip_id			chip;
+	struct work_struct		load_work;
+	struct delayed_work		rcomp_work;
+	int				soc_shift;
+};
+
+static int modelgauge_read_reg(struct i2c_client *client, u8 reg, u16 *value)
+{
+	int ret = i2c_smbus_read_word_data(client, reg);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+		return ret;
+	}
+
+	*value = be16_to_cpu(ret);
+	return 0;
+}
+
+static int modelgauge_write_reg(struct i2c_client *client, u8 reg, u16 value)
+{
+	int ret = i2c_smbus_write_word_data(client, reg, cpu_to_be16(value));
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static void modelgauge_write_block(struct i2c_client *client, u8 adr, u8 size,
+				   u16 *data)
+{
+	int k;
+
+	for (k = 0; k < size; k += 2, adr += 2, data++)
+		i2c_smbus_write_word_data(client, adr, *data);
+}
+
+static void modelgauge_reset(struct i2c_client *client)
+{
+	/* Reset chip transaction does not provide ACK */
+	i2c_smbus_write_word_data(client, MODELGAUGE_CMD_REG,
+				  cpu_to_be16(MODELGAUGE_RESET_VALUE));
+}
+
+static int modelgauge_lsb_to_uvolts(struct modelgauge_priv *priv, int lsb)
+{
+	switch (priv->chip) {
+	case ID_MAX17040:
+	case ID_MAX17043:
+		return (lsb >> 4) * 1250; /* 1.25mV per bit */
+	case ID_MAX17041:
+	case ID_MAX17044:
+		return (lsb >> 4) * 2500; /* 2.5mV per bit */
+	case ID_MAX17048:
+	case ID_MAX17058:
+		return lsb * 625 / 8; /* 78.125uV per bit */
+	case ID_MAX17049:
+	case ID_MAX17059:
+		return lsb * 625 / 4; /* 156.25uV per bit */
+	default:
+		return -EINVAL;
+	}
+}
+
+static enum power_supply_property modelgauge_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+	POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_OCV,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_TEMP,
+};
+
+static int modelgauge_get_property(struct power_supply *psy,
+				   enum power_supply_property psp,
+				   union power_supply_propval *val)
+{
+	struct modelgauge_priv *priv = container_of(psy,
+						    struct modelgauge_priv,
+						    battery);
+	struct i2c_client *client = priv->client;
+	struct modelgauge_platform_data *pdata = priv->pdata;
+	u16 reg;
+	int ret;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		if (pdata && pdata->get_charging_status)
+			val->intval = pdata->get_charging_status();
+		else
+			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		if (pdata && pdata->model)
+			val->intval = pdata->model->full_adjustment;
+		else
+			val->intval = 100;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN:
+		if (pdata && pdata->model)
+			val->intval = pdata->model->empty_adjustment;
+		else
+			val->intval = 0;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = modelgauge_read_reg(client, MODELGAUGE_VCELL_REG, &reg);
+		if (ret < 0)
+			return ret;
+
+		val->intval = modelgauge_lsb_to_uvolts(priv, reg);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
+		/* Unlock model access */
+		modelgauge_write_reg(client, MODELGAUGE_UNLOCK_REG,
+				     MODELGAUGE_UNLOCK_VALUE);
+		ret = modelgauge_read_reg(client, MODELGAUGE_OCV_REG, &reg);
+		/* Lock model access */
+		modelgauge_write_reg(client, MODELGAUGE_UNLOCK_REG, 0);
+		if (ret < 0)
+			return ret;
+
+		val->intval = modelgauge_lsb_to_uvolts(priv, reg);
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		ret = modelgauge_read_reg(client, MODELGAUGE_SOC_REG, &reg);
+		if (ret < 0)
+			return ret;
+
+		val->intval = reg / (1 << priv->soc_shift);
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		if (pdata && pdata->get_temperature)
+			val->intval = pdata->get_temperature();
+		else
+			val->intval = 25;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void modelgauge_update_rcomp(struct modelgauge_priv *priv)
+{
+	struct i2c_client *client = priv->client;
+	struct modelgauge_custom_model *model = priv->pdata->model;
+	u16 rcomp, reg;
+	int temp;
+
+	if (priv->pdata->get_temperature)
+		temp = priv->pdata->get_temperature();
+	else
+		temp = 25;
+
+	if (!model->temp_co_up)
+		model->temp_co_up = -500;
+	if (!model->temp_co_down)
+		model->temp_co_down = -5000;
+
+	rcomp = model->rcomp0;
+	if (temp > 20)
+		rcomp += (temp - 20) * model->temp_co_up / 1000;
+	else
+		rcomp += (temp - 20) * model->temp_co_down / 1000;
+
+	/* Update RCOMP */
+	modelgauge_read_reg(client, MODELGAUGE_CONFIG_REG, &reg);
+	reg &= 0xff;
+	reg |= rcomp << 8;
+	modelgauge_write_reg(client, MODELGAUGE_CONFIG_REG, reg);
+}
+
+static void modelgauge_update_rcomp_work(struct work_struct *work)
+{
+	struct modelgauge_priv *priv = container_of(work,
+						    struct modelgauge_priv,
+						    rcomp_work.work);
+
+	modelgauge_update_rcomp(priv);
+	schedule_delayed_work(&priv->rcomp_work,
+			      msecs_to_jiffies(MODELGAUGE_RCOMP_UPDATE_DELAY));
+}
+
+static int modelgauge_load_model(struct modelgauge_priv *priv)
+{
+	struct i2c_client *client = priv->client;
+	struct modelgauge_custom_model *model = priv->pdata->model;
+	int ret = -EINVAL;
+	int timeout, k;
+	u16 ocv, config, soc;
+
+	/* Save CONFIG */
+	modelgauge_read_reg(client, MODELGAUGE_CONFIG_REG, &config);
+
+	for (timeout = 0; timeout < 100; timeout++) {
+		/* Unlock model access */
+		modelgauge_write_reg(client, MODELGAUGE_UNLOCK_REG,
+				     MODELGAUGE_UNLOCK_VALUE);
+
+		/* Read OCV */
+		modelgauge_read_reg(client, MODELGAUGE_OCV_REG, &ocv);
+		if (ocv != 0xffff)
+			break;
+	}
+
+	if (timeout >= 100) {
+		dev_err(&client->dev, "timeout to unlock model access\n");
+		ret = -EIO;
+		goto exit;
+	}
+
+	switch (priv->chip) {
+	case ID_MAX17058:
+	case ID_MAX17059:
+		/* Reset chip */
+		modelgauge_reset(client);
+		msleep(150);
+
+		for (timeout = 0; timeout < 100; timeout++) {
+			u16 reg;
+
+			/* Unlock Model Access */
+			modelgauge_write_reg(client, MODELGAUGE_UNLOCK_REG,
+						     MODELGAUGE_UNLOCK_VALUE);
+
+			/* Read OCV */
+			modelgauge_read_reg(client, MODELGAUGE_OCV_REG, &reg);
+			if (reg != 0xffff)
+				break;
+		}
+
+		if (timeout >= 100) {
+			dev_err(&client->dev, "timeout to unlock model access\n");
+			ret = -EIO;
+			goto exit;
+		}
+		break;
+	default:
+		break;
+	}
+
+	switch (priv->chip) {
+	case ID_MAX17040:
+	case ID_MAX17041:
+	case ID_MAX17043:
+	case ID_MAX17044:
+		/* Write OCV */
+		modelgauge_write_reg(client, MODELGAUGE_OCV_REG,
+				     model->ocvtest);
+		/* Write RCOMP to its maximum value */
+		modelgauge_write_reg(client, MODELGAUGE_CONFIG_REG, 0xff00);
+		break;
+	default:
+		break;
+	}
+
+	/* Write the model */
+	modelgauge_write_block(client, MODELGAUGE_TABLE_REG,
+			       MODELGAUGE_TABLE_SIZE,
+			       (u16 *)model->model_data);
+
+	switch (priv->chip) {
+	case ID_MAX17048:
+	case ID_MAX17049: {
+			u16 buf[16];
+
+			if (!model->rcomp_seg)
+				model->rcomp_seg = 0x80;
+
+			for (k = 0; k < 16; k++)
+				*buf = model->rcomp_seg;
+
+			/* Write RCOMPSeg */
+			modelgauge_write_block(client, MODELGAUGE_RCOMPSEG_REG,
+					       32, buf);
+		}
+		break;
+	default:
+		break;
+	}
+
+	switch (priv->chip) {
+	case ID_MAX17040:
+	case ID_MAX17041:
+	case ID_MAX17043:
+	case ID_MAX17044:
+		/* Delay at least 150ms */
+		msleep(150);
+		break;
+	default:
+		break;
+	}
+
+	/* Write OCV */
+	modelgauge_write_reg(client, MODELGAUGE_OCV_REG, model->ocvtest);
+
+	switch (priv->chip) {
+	case ID_MAX17048:
+	case ID_MAX17049:
+		/* Disable Hibernate */
+		modelgauge_write_reg(client, MODELGAUGE_HIBRT_REG, 0);
+		/* fall-through */
+	case ID_MAX17058:
+	case ID_MAX17059:
+		/* Lock Model Access */
+		modelgauge_write_reg(client, MODELGAUGE_UNLOCK_REG, 0);
+		break;
+	default:
+		break;
+	}
+
+	/* Delay between 150ms and 600ms */
+	msleep(200);
+
+	/* Read SOC Register and compare to expected result */
+	modelgauge_read_reg(client, MODELGAUGE_SOC_REG, &soc);
+	soc >>= 8;
+	if (soc >= model->soc_check_a && soc <= model->soc_check_b)
+		ret = 0;
+
+	switch (priv->chip) {
+	case ID_MAX17048:
+	case ID_MAX17049:
+	case ID_MAX17058:
+	case ID_MAX17059:
+		/* Unlock model access */
+		modelgauge_write_reg(client, MODELGAUGE_UNLOCK_REG,
+				     MODELGAUGE_UNLOCK_VALUE);
+		break;
+	default:
+		break;
+	}
+
+	/* Restore CONFIG and OCV */
+	modelgauge_write_reg(client, MODELGAUGE_CONFIG_REG, config);
+	modelgauge_write_reg(client, MODELGAUGE_OCV_REG, ocv);
+
+	switch (priv->chip) {
+	case ID_MAX17048:
+	case ID_MAX17049:
+		/* Restore Hibernate */
+		modelgauge_write_reg(client, MODELGAUGE_HIBRT_REG,
+				     (priv->pdata->hibernate_threshold << 8) |
+				     priv->pdata->active_threshold);
+		break;
+	default:
+		break;
+	}
+
+exit:
+	/* Lock model access */
+	modelgauge_write_reg(client, MODELGAUGE_UNLOCK_REG, 0);
+
+	/* Wait 150ms minimum */
+	msleep(150);
+
+	return ret;
+}
+
+static void modelgauge_load_model_work(struct work_struct *work)
+{
+	struct modelgauge_priv *priv = container_of(work,
+						    struct modelgauge_priv,
+						    load_work);
+	struct i2c_client *client = priv->client;
+	int ret;
+	u16 reg;
+	int timeout;
+
+	for (timeout = 0; timeout < 10; timeout++) {
+		/* Load custom model data */
+		ret = modelgauge_load_model(priv);
+		if (!ret)
+			break;
+	}
+
+	if (timeout >= 10) {
+		dev_info(&client->dev, "failed to load custom model\n");
+		return;
+	}
+
+	switch (priv->chip) {
+	case ID_MAX17048:
+	case ID_MAX17049:
+	case ID_MAX17058:
+	case ID_MAX17059:
+		/* Clear reset indicator bit */
+		modelgauge_read_reg(client, MODELGAUGE_STATUS_REG, &reg);
+		reg &= ~MODELGAUGE_STATUS_RI;
+		modelgauge_write_reg(client, MODELGAUGE_STATUS_REG, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static irqreturn_t modelgauge_irq_handler(int id, void *dev)
+{
+	struct modelgauge_priv *priv = dev;
+	u16 config;
+
+	/* clear alert status bit */
+	modelgauge_read_reg(priv->client, MODELGAUGE_CONFIG_REG, &config);
+	config &= ~MODELGAUGE_CONFIG_ALRT;
+	modelgauge_write_reg(priv->client, MODELGAUGE_CONFIG_REG, config);
+
+	power_supply_changed(&priv->battery);
+	return IRQ_HANDLED;
+}
+
+static int modelgauge_init(struct modelgauge_priv *priv)
+{
+	struct i2c_client *client = priv->client;
+	struct modelgauge_platform_data *pdata = priv->pdata;
+	int ret;
+	u16 reg;
+
+	ret = modelgauge_read_reg(client, MODELGAUGE_VERSION_REG, &reg);
+	if (ret < 0)
+		return -ENODEV;
+
+	dev_info(&client->dev, "IC production version 0x%04x\n", reg);
+
+	/* SOC=0 means unrecoverable IC fault, reset is a workaround */
+	modelgauge_read_reg(client, MODELGAUGE_SOC_REG, &reg);
+	if (!reg) {
+		dev_info(&client->dev, "Reset chip, SOC measurement stall\n");
+		modelgauge_reset(client);
+		msleep(150);
+	}
+
+	/* Default model uses 8 bits per percent */
+	priv->soc_shift = 8;
+
+	if (!priv->pdata) {
+		dev_info(&client->dev, "no platform data provided\n");
+		return 0;
+	}
+
+	if (pdata->model) {
+		switch (pdata->model->bits) {
+		case 19:
+			priv->soc_shift = 9;
+			break;
+		case 18:
+		default:
+			priv->soc_shift = 8;
+			break;
+		}
+	}
+
+	/* Set RCOMP */
+	if (pdata->model)
+		modelgauge_update_rcomp(priv);
+	if (pdata->model && pdata->get_temperature) {
+		/* Schedule update RCOMP */
+		schedule_delayed_work(&priv->rcomp_work,
+			    msecs_to_jiffies(MODELGAUGE_RCOMP_UPDATE_DELAY));
+	}
+
+	/* Clear alert status bit, wake-up, set alert threshold */
+	modelgauge_read_reg(client, MODELGAUGE_CONFIG_REG, &reg);
+	reg &= ~(MODELGAUGE_CONFIG_ALRT | MODELGAUGE_CONFIG_SLEEP |
+		 MODELGAUGE_CONFIG_ALSC);
+	switch (priv->chip) {
+	case ID_MAX17048:
+	case ID_MAX17049:
+		reg |= pdata->soc_change_alert ? MODELGAUGE_CONFIG_ALSC : 0;
+		/* fall-through */
+	case ID_MAX17043:
+	case ID_MAX17044:
+	case ID_MAX17058:
+	case ID_MAX17059:
+		reg &= ~MODELGAUGE_CONFIG_ATHD_MASK;
+		reg |= 32 -
+		       (pdata->empty_alert_threshold << (priv->soc_shift - 8));
+		break;
+	default:
+		break;
+	}
+	modelgauge_write_reg(client, MODELGAUGE_CONFIG_REG, reg);
+	switch (priv->chip) {
+	case ID_MAX17048:
+	case ID_MAX17049:
+		/* Set Hibernate thresholds */
+		reg = (pdata->hibernate_threshold * 125 / 26) & 0xff;
+		reg <<= 8;
+		reg |= (pdata->active_threshold * 4 / 5) & 0xff;
+		modelgauge_write_reg(client, MODELGAUGE_HIBRT_REG, reg);
+
+		/* Set undervoltage/overvoltage alerts */
+		reg = (pdata->undervoltage / 20) & 0xff;
+		reg <<= 8;
+		reg |= (pdata->overvoltage / 20) & 0xff;
+		modelgauge_write_reg(client, MODELGAUGE_VALRT_REG, reg);
+		/* fall-through */
+	case ID_MAX17058:
+	case ID_MAX17059:
+		/* Disable sleep mode and quick start */
+		modelgauge_write_reg(client, MODELGAUGE_MODE_REG, 0);
+
+		/* Setup reset voltage threshold */
+		if (pdata->resetvoltage)
+			reg = ((pdata->resetvoltage / 40) & 0x7f) << 9;
+		else
+			reg = MODELGAUGE_VRESETID_DIS;
+		modelgauge_write_reg(client, MODELGAUGE_VRESETID_REG, reg);
+
+		/* Skip load model if reset indicator cleared */
+		modelgauge_read_reg(client, MODELGAUGE_STATUS_REG, &reg);
+
+		/* Skip load custom model */
+		if (!(reg & MODELGAUGE_STATUS_RI))
+			return 0;
+		break;
+	default:
+		break;
+	}
+
+	/* Schedule load custom model work */
+	if (pdata->model && pdata->model->model_data)
+		schedule_work(&priv->load_work);
+
+	return 0;
+}
+
+static struct modelgauge_platform_data *modelgauge_parse_dt(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct modelgauge_platform_data *pdata;
+	struct property *prop;
+
+	if (!of_get_property(np, "maxim,empty_alert_threshold", NULL) &&
+	    !of_get_property(np, "maxim,soc_change_alert", NULL) &&
+	    !of_get_property(np, "maxim,hibernate_threshold", NULL) &&
+	    !of_get_property(np, "maxim,active_threshold", NULL) &&
+	    !of_get_property(np, "maxim,undervoltage", NULL) &&
+	    !of_get_property(np, "maxim,overvoltage", NULL) &&
+	    !of_get_property(np, "maxim,resetvoltage", NULL))
+		return NULL;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	of_property_read_u8(np, "maxim,empty_alert_threshold",
+			    &pdata->empty_alert_threshold);
+	pdata->soc_change_alert =
+			of_property_read_bool(np, "maxim,soc_change_alert");
+	of_property_read_u8(np, "maxim,hibernate_threshold",
+			    &pdata->hibernate_threshold);
+	of_property_read_u8(np, "maxim,active_threshold",
+			    &pdata->active_threshold);
+	of_property_read_u16(np, "maxim,undervoltage", &pdata->undervoltage);
+	of_property_read_u16(np, "maxim,overvoltage", &pdata->overvoltage);
+	of_property_read_u16(np, "maxim,resetvoltage", &pdata->resetvoltage);
+
+	prop = of_find_property(np, "maxim,ocvtest", NULL);
+	if (prop) {
+		pdata->model = devm_kzalloc(dev, sizeof(*pdata->model),
+					    GFP_KERNEL);
+		if (!pdata->model)
+			return NULL;
+
+		of_property_read_u8(np, "maxim,empty_adjustment",
+				    &pdata->model->empty_adjustment);
+		of_property_read_u8(np, "maxim,full_adjustment",
+				    &pdata->model->full_adjustment);
+		of_property_read_u8(np, "maxim,rcomp0",
+				    &pdata->model->rcomp0);
+		prop = of_find_property(np, "maxim,temp_co_up", NULL);
+		if (prop)
+			pdata->model->temp_co_up = be32_to_cpup(prop->value);
+		prop = of_find_property(np, "maxim,temp_co_down", NULL);
+		if (prop)
+			pdata->model->temp_co_down = be32_to_cpup(prop->value);
+		of_property_read_u16(np, "maxim,ocvtest",
+				     &pdata->model->ocvtest);
+		of_property_read_u8(np, "maxim,soc_check_a",
+				    &pdata->model->soc_check_a);
+		of_property_read_u8(np, "maxim,soc_check_b",
+				    &pdata->model->soc_check_b);
+		of_property_read_u8(np, "maxim,bits",
+				    &pdata->model->bits);
+		of_property_read_u16(np, "maxim,rcomp_seg",
+				     &pdata->model->rcomp_seg);
+	}
+
+	prop = of_find_property(np, "maxim,model_data", NULL);
+	if (prop && prop->length == MODELGAUGE_TABLE_SIZE) {
+		pdata->model->model_data = devm_kzalloc(dev,
+							MODELGAUGE_TABLE_SIZE,
+							GFP_KERNEL);
+		if (!pdata->model->model_data)
+			return NULL;
+
+		of_property_read_u8_array(np, "maxim,model_data",
+					  pdata->model->model_data,
+					  MODELGAUGE_TABLE_SIZE);
+	}
+
+	return pdata;
+}
+
+static int modelgauge_probe(struct i2c_client *client,
+			    const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct modelgauge_priv *priv;
+	int ret;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
+		return -EIO;
+
+	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	if (client->dev.of_node)
+		priv->pdata = modelgauge_parse_dt(&client->dev);
+	else
+		priv->pdata = client->dev.platform_data;
+
+	priv->client	= client;
+	priv->chip	= id->driver_data;
+
+	i2c_set_clientdata(client, priv);
+
+	priv->battery.name		= "modelgauge_battery";
+	priv->battery.type		= POWER_SUPPLY_TYPE_BATTERY;
+	priv->battery.get_property	= modelgauge_get_property;
+	priv->battery.properties	= modelgauge_battery_props;
+	priv->battery.num_properties	= ARRAY_SIZE(modelgauge_battery_props);
+
+	INIT_WORK(&priv->load_work, modelgauge_load_model_work);
+	INIT_DELAYED_WORK(&priv->rcomp_work, modelgauge_update_rcomp_work);
+
+	ret = modelgauge_init(priv);
+	if (ret)
+		return ret;
+
+	ret = power_supply_register(&client->dev, &priv->battery);
+	if (ret) {
+		dev_err(&client->dev, "failed: power supply register\n");
+		goto err_supply;
+	}
+
+	if (client->irq) {
+		switch (priv->chip) {
+		case ID_MAX17040:
+		case ID_MAX17041:
+			dev_err(&client->dev, "alert line is not supported\n");
+			ret = -EINVAL;
+			goto err_irq;
+		default:
+			ret = request_threaded_irq(client->irq, NULL,
+						   modelgauge_irq_handler,
+						   IRQF_TRIGGER_FALLING,
+						   priv->battery.name, priv);
+			if (ret) {
+				dev_err(&client->dev, "failed to request irq %d\n",
+					client->irq);
+				goto err_irq;
+			}
+		}
+	}
+
+	return 0;
+
+err_irq:
+	power_supply_unregister(&priv->battery);
+err_supply:
+	cancel_work_sync(&priv->load_work);
+	cancel_delayed_work(&priv->rcomp_work);
+	return ret;
+}
+
+static int modelgauge_remove(struct i2c_client *client)
+{
+	struct modelgauge_priv *priv = i2c_get_clientdata(client);
+
+	if (client->irq)
+		free_irq(client->irq, priv);
+
+	cancel_work_sync(&priv->load_work);
+	cancel_delayed_work(&priv->rcomp_work);
+
+	power_supply_unregister(&priv->battery);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int modelgauge_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct modelgauge_priv *priv = i2c_get_clientdata(client);
+	struct modelgauge_platform_data *pdata = priv->pdata;
+
+	if (pdata && pdata->model && pdata->get_temperature)
+		cancel_delayed_work(&priv->rcomp_work);
+
+	switch (priv->chip) {
+	case ID_MAX17040:
+	case ID_MAX17041:
+		return 0;
+	default:
+		if (client->irq) {
+			disable_irq(client->irq);
+			enable_irq_wake(client->irq);
+		}
+	}
+
+	return 0;
+}
+
+static int modelgauge_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct modelgauge_priv *priv = i2c_get_clientdata(client);
+	struct modelgauge_platform_data *pdata = priv->pdata;
+
+	if (pdata && pdata->model && pdata->get_temperature)
+		schedule_delayed_work(&priv->rcomp_work,
+			    msecs_to_jiffies(MODELGAUGE_RCOMP_UPDATE_DELAY));
+
+	switch (priv->chip) {
+	case ID_MAX17040:
+	case ID_MAX17041:
+		return 0;
+	default:
+		if (client->irq) {
+			disable_irq_wake(client->irq);
+			enable_irq(client->irq);
+		}
+	}
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(modelgauge_pm_ops,
+			 modelgauge_suspend, modelgauge_resume);
+#define MODELGAUGE_PM_OPS (&modelgauge_pm_ops)
+#else
+#define MODELGAUGE_PM_OPS NULL
+#endif /* CONFIG_PM_SLEEP */
+
+static const struct of_device_id modelgauge_match[] = {
+	{ .compatible = "maxim,max17040" },
+	{ .compatible = "maxim,max17041" },
+	{ .compatible = "maxim,max17043" },
+	{ .compatible = "maxim,max17044" },
+	{ .compatible = "maxim,max17048" },
+	{ .compatible = "maxim,max17049" },
+	{ .compatible = "maxim,max17058" },
+	{ .compatible = "maxim,max17059" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, modelgauge_match);
+
+static const struct i2c_device_id modelgauge_id[] = {
+	{ "max17040", ID_MAX17040 },
+	{ "max17041", ID_MAX17041 },
+	{ "max17043", ID_MAX17043 },
+	{ "max17044", ID_MAX17044 },
+	{ "max17048", ID_MAX17048 },
+	{ "max17049", ID_MAX17049 },
+	{ "max17058", ID_MAX17058 },
+	{ "max17059", ID_MAX17059 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, modelgauge_id);
+
+static struct i2c_driver modelgauge_i2c_driver = {
+	.driver	= {
+		.name		= DRV_NAME,
+		.of_match_table	= of_match_ptr(modelgauge_match),
+		.pm		= MODELGAUGE_PM_OPS,
+	},
+	.probe		= modelgauge_probe,
+	.remove		= modelgauge_remove,
+	.id_table	= modelgauge_id,
+};
+module_i2c_driver(modelgauge_i2c_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vladimir Barinov");
+MODULE_DESCRIPTION("Maxim ModelGauge fuel gauge");
Index: battery-2.6/include/linux/platform_data/battery-modelgauge.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ battery-2.6/include/linux/platform_data/battery-modelgauge.h	2014-01-09 15:09:36.335138846 +0400
@@ -0,0 +1,44 @@
+/*
+ * Maxim ModelGauge ICs fuel gauge driver header file
+ *
+ * Author: Vladimir Barinov <source@cogentembedded.com>
+ * Copyright (C) 2013 Cogent Embedded, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __BATTERY_MODELGAUGE_H_
+#define __BATTERY_MODELGAUGE_H_
+
+#define MODELGAUGE_TABLE_SIZE	64
+
+struct modelgauge_custom_model {
+	u8	empty_adjustment;
+	u8	full_adjustment;
+	u8	rcomp0;
+	int	temp_co_up;
+	int	temp_co_down;
+	u16	ocvtest;
+	u8	soc_check_a;
+	u8	soc_check_b;
+	u8	bits;
+	u16	rcomp_seg;
+	u8	*model_data;
+};
+
+struct modelgauge_platform_data {
+	u8	empty_alert_threshold;	/* soc alert range 1..32 */
+	bool	soc_change_alert;	/* alert for 1% soc change */
+	u8	hibernate_threshold;	/* soc per hour */
+	u8	active_threshold;	/* mV */
+	u16	undervoltage;		/* mV */
+	u16	overvoltage;		/* mV */
+	u16	resetvoltage;		/* mV */
+	struct modelgauge_custom_model *model; /* custom battery data */
+	int	(*get_temperature)(void); /* C */
+	int	(*get_charging_status)(void);
+};
+#endif
