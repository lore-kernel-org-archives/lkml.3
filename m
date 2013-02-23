Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3BWQgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 11:36:23 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:38963 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758970Ab3BWQgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 11:36:03 -0500
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com
Cc: ldewangan@nvidia.com, lgirdwood@gmail.com,
        Graeme Gregory <gg@slimlogic.co.uk>, Ian Lartey <ian@slimlogic.co.uk>
Subject: [PATCH v2 2/2] mfd: palmas add variant and OTP detection
Date: Sat, 23 Feb 2013 16:35:41 +0000
Message-Id: <1361637341-22214-2-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1361637341-22214-1-git-send-email-ian@slimlogic.co.uk>
References: <1361637341-22214-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

Read the chip varient and the OTP information from the chip and display
this on probe to aid in debugging of issues.

Older palmas chips do not have the USB_ID programmed and will therefore
return 0x0000 for this field.

palmas register read/write/update API is now used

palmas_read_product_id_and_revs used by palmas_i2c_probe to get
the device id, design and software revisions

id field of pamas struct renamed to device_id

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 drivers/mfd/palmas.c       |   88 ++++++++++++++++++++++++++++++++++---------
 include/linux/mfd/palmas.h |   40 +++++++++++++++++++-
 2 files changed, 108 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index bbdbc50..1a435f3 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -4,6 +4,7 @@
  * Copyright 2011-2012 Texas Instruments Inc.
  *
  * Author: Graeme Gregory <gg@slimlogic.co.uk>
+ * Author: Ian Lartey <ian@slimlogic.co.uk>
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under  the terms of the GNU General  Public License as published by the
@@ -257,6 +258,56 @@ static struct regmap_irq_chip palmas_irq_chip = {
 			PALMAS_INT1_MASK),
 };
 
+static int palmas_read_product_id_and_revs(struct palmas *palmas)
+{
+	int ret;
+	unsigned int reg;
+
+	/* Read variant info from the device */
+	ret = palmas_read(palmas, PALMAS_ID_BASE, PALMAS_PRODUCT_ID_LSB, &reg);
+	if (ret < 0) {
+		dev_err(palmas->dev, "Unable to read ID err: %d\n", ret);
+		return ret;
+	}
+
+	palmas->product_id = reg;
+
+	ret = palmas_read(palmas, PALMAS_ID_BASE, PALMAS_PRODUCT_ID_MSB, &reg);
+	if (ret < 0) {
+		dev_err(palmas->dev, "Unable to read ID err: %d\n", ret);
+		return ret;
+	}
+
+	palmas->product_id |= reg << 8;
+
+	dev_info(palmas->dev, "Product ID %x\n", palmas->product_id);
+
+	ret = palmas_read(palmas, PALMAS_DESIGNREV_BASE,
+				PALMAS_DESIGNREV, &reg);
+	if (ret < 0) {
+		dev_err(palmas->dev, "Unable to read DESIGNREV err: %d\n", ret);
+		return ret;
+	}
+
+	palmas->designrev = reg & PALMAS_DESIGNREV_DESIGNREV_MASK;
+
+	dev_info(palmas->dev, "Product Design Rev %x\n", palmas->designrev);
+
+	ret = palmas_read(palmas, PALMAS_PMU_CONTROL_BASE, PALMAS_SW_REVISION,
+			&reg);
+	if (ret < 0) {
+		dev_err(palmas->dev, "Unable to read SW_REVISION err: %d\n",
+				ret);
+		return ret;
+	}
+
+	palmas->sw_revision = reg;
+
+	dev_info(palmas->dev, "Product SW Rev %x\n", palmas->sw_revision);
+
+	return 0;
+}
+
 static void palmas_dt_to_pdata(struct device_node *node,
 		struct palmas_platform_data *pdata)
 {
@@ -292,7 +343,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	struct palmas_platform_data *pdata;
 	struct device_node *node = i2c->dev.of_node;
 	int ret = 0, i;
-	unsigned int reg, addr;
+	unsigned int reg;
 	int slave;
 	struct mfd_cell *children;
 
@@ -316,7 +367,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, palmas);
 	palmas->dev = &i2c->dev;
-	palmas->id = id->driver_data;
+	palmas->product_id = id->driver_data;
 	palmas->irq = i2c->irq;
 
 	for (i = 0; i < PALMAS_NUM_CLIENTS; i++) {
@@ -344,12 +395,16 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
+	/* Read variant info from the device */
+	ret = palmas_read_product_id_and_revs(palmas);
+	if (ret < 0)
+		goto err;
+
 	/* Change IRQ into clear on read mode for efficiency */
 	slave = PALMAS_BASE_TO_SLAVE(PALMAS_INTERRUPT_BASE);
-	addr = PALMAS_BASE_TO_REG(PALMAS_INTERRUPT_BASE, PALMAS_INT_CTRL);
 	reg = PALMAS_INT_CTRL_INT_CLEAR;
 
-	regmap_write(palmas->regmap[slave], addr, reg);
+	ret = palmas_write(palmas, PALMAS_INTERRUPT_BASE, PALMAS_INT_CTRL, reg);
 
 	ret = regmap_add_irq_chip(palmas->regmap[slave], palmas->irq,
 			IRQF_ONESHOT | IRQF_TRIGGER_LOW, 0, &palmas_irq_chip,
@@ -357,17 +412,15 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
-	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
-	addr = PALMAS_BASE_TO_REG(PALMAS_PU_PD_OD_BASE,
-			PALMAS_PRIMARY_SECONDARY_PAD1);
-
 	if (pdata->mux_from_pdata) {
 		reg = pdata->pad1;
-		ret = regmap_write(palmas->regmap[slave], addr, reg);
+		ret = palmas_write(palmas, PALMAS_PU_PD_OD_BASE,
+				PALMAS_PRIMARY_SECONDARY_PAD1, reg);
 		if (ret)
 			goto err_irq;
 	} else {
-		ret = regmap_read(palmas->regmap[slave], addr, &reg);
+		ret = palmas_read(palmas, PALMAS_PU_PD_OD_BASE,
+				PALMAS_PRIMARY_SECONDARY_PAD1, &reg);
 		if (ret)
 			goto err_irq;
 	}
@@ -393,16 +446,15 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	if (!(reg & PALMAS_PRIMARY_SECONDARY_PAD1_GPIO_3))
 		palmas->gpio_muxed |= PALMAS_GPIO_3_MUXED;
 
-	addr = PALMAS_BASE_TO_REG(PALMAS_PU_PD_OD_BASE,
-			PALMAS_PRIMARY_SECONDARY_PAD2);
-
 	if (pdata->mux_from_pdata) {
 		reg = pdata->pad2;
-		ret = regmap_write(palmas->regmap[slave], addr, reg);
+		ret = palmas_write(palmas, PALMAS_PU_PD_OD_BASE,
+				PALMAS_PRIMARY_SECONDARY_PAD2, reg);
 		if (ret)
 			goto err_irq;
 	} else {
-		ret = regmap_read(palmas->regmap[slave], addr, &reg);
+		ret = palmas_read(palmas, PALMAS_PU_PD_OD_BASE,
+				PALMAS_PRIMARY_SECONDARY_PAD2, &reg);
 		if (ret)
 			goto err_irq;
 	}
@@ -422,10 +474,8 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 
 	reg = pdata->power_ctrl;
 
-	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PMU_CONTROL_BASE);
-	addr = PALMAS_BASE_TO_REG(PALMAS_PMU_CONTROL_BASE, PALMAS_POWER_CTRL);
-
-	ret = regmap_write(palmas->regmap[slave], addr, reg);
+	ret = palmas_write(palmas, PALMAS_PU_PD_OD_BASE,
+			PALMAS_PRIMARY_SECONDARY_PAD2, reg);
 	if (ret)
 		goto err_irq;
 
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index a4d13d7..3129f9a 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -4,6 +4,7 @@
  * Copyright 2011 Texas Instruments Inc.
  *
  * Author: Graeme Gregory <gg@slimlogic.co.uk>
+ * Author: Ian Lartey <ian@slimlogic.co.uk>
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under  the terms of the GNU General  Public License as published by the
@@ -22,6 +23,10 @@
 
 #define PALMAS_NUM_CLIENTS		3
 
+/* The ID_REVISION NUMBERS */
+#define PALMAS_CHIP_OLD_ID		0x0000
+#define PALMAS_CHIP_ID			0xC035
+
 struct palmas_pmic;
 struct palmas_gpadc;
 struct palmas_resource;
@@ -34,7 +39,9 @@ struct palmas {
 	struct regmap *regmap[PALMAS_NUM_CLIENTS];
 
 	/* Stored chip id */
-	int id;
+	int product_id;
+	int designrev;
+	int sw_revision;
 
 	/* IRQ Data */
 	int irq;
@@ -427,11 +434,13 @@ enum usb_irq_events {
 #define PALMAS_PU_PD_OD_BASE					0x1F4
 #define PALMAS_LED_BASE						0x200
 #define PALMAS_INTERRUPT_BASE					0x210
+#define PALMAS_ID_BASE						0x24F
 #define PALMAS_USB_OTG_BASE					0x250
 #define PALMAS_VIBRATOR_BASE					0x270
 #define PALMAS_GPIO_BASE					0x280
 #define PALMAS_USB_BASE						0x290
 #define PALMAS_GPADC_BASE					0x2C0
+#define PALMAS_DESIGNREV_BASE					0x357
 #define PALMAS_TRIM_GPADC_BASE					0x3CD
 
 /* Registers for function RTC */
@@ -2149,6 +2158,28 @@ enum usb_irq_events {
 #define PALMAS_INT_CTRL_INT_CLEAR				0x01
 #define PALMAS_INT_CTRL_INT_CLEAR_SHIFT				0
 
+/* Registers for function ID */
+#define PALMAS_VENDOR_ID_LSB					0x0
+#define PALMAS_VENDOR_ID_MSB					0x1
+#define PALMAS_PRODUCT_ID_LSB					0x2
+#define PALMAS_PRODUCT_ID_MSB					0x3
+
+/* Bit definitions for VENDOR_ID_LSB */
+#define PALMAS_VENDOR_ID_LSB_VENDOR_ID_MASK			0xff
+#define PALMAS_VENDOR_ID_LSB_VENDOR_ID_SHIFT			0
+
+/* Bit definitions for VENDOR_ID_MSB */
+#define PALMAS_VENDOR_ID_MSB_VENDOR_ID_MASK			0xff
+#define PALMAS_VENDOR_ID_MSB_VENDOR_ID_SHIFT			0
+
+/* Bit definitions for PRODUCT_ID_LSB */
+#define PALMAS_PRODUCT_ID_LSB_PRODUCT_ID_MASK			0xff
+#define PALMAS_PRODUCT_ID_LSB_PRODUCT_ID_SHIFT			0
+
+/* Bit definitions for PRODUCT_ID_MSB */
+#define PALMAS_PRODUCT_ID_MSB_PRODUCT_ID_MASK			0xff
+#define PALMAS_PRODUCT_ID_MSB_PRODUCT_ID_SHIFT			0
+
 /* Registers for function USB_OTG */
 #define PALMAS_USB_WAKEUP					0x3
 #define PALMAS_USB_VBUS_CTRL_SET				0x4
@@ -2771,6 +2802,13 @@ enum usb_irq_events {
 #define PALMAS_GPADC_SMPS_VSEL_MONITORING_SMPS_VSEL_MONITORING_MASK	0x7f
 #define PALMAS_GPADC_SMPS_VSEL_MONITORING_SMPS_VSEL_MONITORING_SHIFT	0
 
+/* Registers for function DESIGNREV */
+#define PALMAS_DESIGNREV					0x0
+
+/* Bit definitions for DESIGNREV */
+#define PALMAS_DESIGNREV_DESIGNREV_MASK				0x0f
+#define PALMAS_DESIGNREV_DESIGNREV_SHIFT			0
+
 /* Registers for function GPADC */
 #define PALMAS_GPADC_TRIM1					0x0
 #define PALMAS_GPADC_TRIM2					0x1
-- 
1.7.0.4

