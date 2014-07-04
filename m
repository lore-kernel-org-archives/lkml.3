Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbaGDJ4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:56:35 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38149 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030364AbaGDJ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:56:28 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v6 17/23] mfd: max77686: Add Maxim 77802 PMIC support
Date: Fri,  4 Jul 2014 11:55:16 +0200
Message-Id: <1404467722-26687-18-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim MAX77802 is a power management chip that contains 10 high
efficiency Buck regulators, 32 Low-dropout (LDO) regulators used
to power up application processors and peripherals, a 2-channel
32kHz clock outputs, a Real-Time-Clock (RTC) and a I2C interface
to program the individual regulators, clocks outputs and the RTC.

This patch adds support for MAX77802 to the MAX77686 driver and is
based on a driver added to the Chrome OS kernel 3.8 by Simon Glass.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

    NOTE: I didn't carry previous {Review,Acked,Tested}-by tags since
    this patch extending MAX77686 is quite different than the old one
    adding a new mfd driver. So review and test is highly appreciated.

    Changes since v5:
     - Extend the 77686 driver to support 77802 instead of adding a new driver.
       Suggested by Lee Jones.

    Changes since v4:
     - Use consistent expressions when checking for NULL values.
       Suggested by Krzysztof Kozlowski.
     - Remove unused defines. Suggested by Krzysztof Kozlowski.
     - Explain why IRQ is disabled on suspend. Suggested by Krzysztof Kozlowski.

    Changes since v3:
     - Remove unnecessary OOM error message since the mm subsystem already logs it.

    Changes since v2:
     - Split the DT binding docs in a separate patch and improve the documentation.
       Suggested by Mark Brown.
     - Add all the devices in the MFD driver instead of doing in separate patches.
       Suggested by Mark Brown.

    Changes since v1:
     - Convert max77{686,802} to regmap irq API and get rid of max77{686,802}-irq.c
       Suggested by Krzysztof Kozlowski.
     - Don't protect max77802 mfd_cells using Kconfig options since mfd core omits
       devices that don't match. Suggested by Lee Jones.
     - Change mfd driver to be tristate instead of boolean. Suggested by Mark Brown.
     - Change binding "voltage-regulators" property to "regulators" to be consistent
       with other PMIC drivers. Suggested by Mark Brown.
     - Use regulators node names instead of the deprecated "regulator-compatible"
       property. Suggested by Mark Brown.
     - Use the new descriptor-based GPIO interface instead of the deprecated
---
 drivers/mfd/Kconfig                  |   6 +-
 drivers/mfd/max77686.c               | 187 ++++++++++++++++++++++++++-----
 include/linux/mfd/max77686-private.h | 208 ++++++++++++++++++++++++++++++++++-
 include/linux/mfd/max77686.h         |  60 +++++++++-
 4 files changed, 428 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3010204..de5abf2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -380,15 +380,15 @@ config MFD_MAX14577
 	  of the device.
 
 config MFD_MAX77686
-	bool "Maxim Semiconductor MAX77686 PMIC Support"
+	bool "Maxim Semiconductor MAX77686/802 PMIC Support"
 	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select IRQ_DOMAIN
 	help
-	  Say yes here to add support for Maxim Semiconductor MAX77686.
-	  This is a Power Management IC with RTC on chip.
+	  Say yes here to add support for Maxim Semiconductor MAX77686 and
+	  MAX77802 which are Power Management IC with an RTC on chip.
 	  This driver provides common support for accessing the device;
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 648d564..c0db750 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -1,5 +1,5 @@
 /*
- * max77686.c - mfd core driver for the Maxim 77686
+ * max77686.c - mfd core driver for the Maxim 77686/802
  *
  * Copyright (C) 2012 Samsung Electronics
  * Chiwoong Byun <woong.byun@smasung.com>
@@ -45,6 +45,74 @@ static const struct mfd_cell max77686_devs[] = {
 	{ .name = "max77686-clk", },
 };
 
+static const struct mfd_cell max77802_devs[] = {
+	{ .name = "max77802-pmic", },
+	{ .name = "max77802-clk", },
+	{ .name = "max77802-rtc", },
+};
+
+static bool max77802_pmic_is_accessible_reg(struct device *dev,
+					    unsigned int reg)
+{
+	return (reg >= MAX77802_REG_DEVICE_ID && reg < MAX77802_REG_PMIC_END);
+}
+
+static bool max77802_rtc_is_accessible_reg(struct device *dev,
+					   unsigned int reg)
+{
+	return (reg >= MAX77802_RTC_INT && reg < MAX77802_RTC_END);
+}
+
+static bool max77802_is_accessible_reg(struct device *dev, unsigned int reg)
+{
+	return (max77802_pmic_is_accessible_reg(dev, reg) ||
+		max77802_rtc_is_accessible_reg(dev, reg));
+}
+
+static bool max77802_pmic_is_precious_reg(struct device *dev, unsigned int reg)
+{
+	return (reg == MAX77802_REG_INTSRC || reg == MAX77802_REG_INT1 ||
+		reg == MAX77802_REG_INT2);
+}
+
+static bool max77802_rtc_is_precious_reg(struct device *dev, unsigned int reg)
+{
+	return (reg == MAX77802_RTC_INT ||
+		reg == MAX77802_RTC_UPDATE0 ||
+		reg == MAX77802_RTC_UPDATE1);
+}
+
+static bool max77802_is_precious_reg(struct device *dev, unsigned int reg)
+{
+	return (max77802_pmic_is_precious_reg(dev, reg) ||
+		max77802_rtc_is_precious_reg(dev, reg));
+}
+
+static bool max77802_pmic_is_volatile_reg(struct device *dev, unsigned int reg)
+{
+	return (max77802_is_precious_reg(dev, reg) ||
+		reg == MAX77802_REG_STATUS1 || reg == MAX77802_REG_STATUS2 ||
+		reg == MAX77802_REG_PWRON);
+}
+
+static bool max77802_rtc_is_volatile_reg(struct device *dev, unsigned int reg)
+{
+	return (max77802_rtc_is_precious_reg(dev, reg) ||
+		reg == MAX77802_RTC_SEC ||
+		reg == MAX77802_RTC_MIN ||
+		reg == MAX77802_RTC_HOUR ||
+		reg == MAX77802_RTC_WEEKDAY ||
+		reg == MAX77802_RTC_MONTH ||
+		reg == MAX77802_RTC_YEAR ||
+		reg == MAX77802_RTC_DATE);
+}
+
+static bool max77802_is_volatile_reg(struct device *dev, unsigned int reg)
+{
+	return (max77802_pmic_is_volatile_reg(dev, reg) ||
+		max77802_rtc_is_volatile_reg(dev, reg));
+}
+
 static struct regmap_config max77686_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -55,6 +123,17 @@ static struct regmap_config max77686_rtc_regmap_config = {
 	.val_bits = 8,
 };
 
+static struct regmap_config max77802_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.writeable_reg = max77802_is_accessible_reg,
+	.readable_reg = max77802_is_accessible_reg,
+	.precious_reg = max77802_is_precious_reg,
+	.volatile_reg = max77802_is_volatile_reg,
+	.name = "max77802-pmic",
+	.cache_type = REGCACHE_RBTREE,
+};
+
 static const struct regmap_irq max77686_irqs[] = {
 	/* INT1 interrupts */
 	{ .reg_offset = 0, .mask = MAX77686_INT1_PWRONF_MSK, },
@@ -98,9 +177,34 @@ static const struct regmap_irq_chip max77686_rtc_irq_chip = {
 	.num_irqs		= ARRAY_SIZE(max77686_rtc_irqs),
 };
 
+static const struct regmap_irq_chip max77802_irq_chip = {
+	.name			= "max77802-pmic",
+	.status_base		= MAX77802_REG_INT1,
+	.mask_base		= MAX77802_REG_INT1MSK,
+	.num_regs		= 2,
+	.irqs			= max77686_irqs, /* same masks than 77686 */
+	.num_irqs		= ARRAY_SIZE(max77686_irqs),
+};
+
+static const struct regmap_irq_chip max77802_rtc_irq_chip = {
+	.name			= "max77802-rtc",
+	.status_base		= MAX77802_RTC_INT,
+	.mask_base		= MAX77802_RTC_INTM,
+	.num_regs		= 1,
+	.irqs			= max77686_rtc_irqs, /* same masks than 77686 */
+	.num_irqs		= ARRAY_SIZE(max77686_rtc_irqs),
+};
+
 static const struct of_device_id max77686_pmic_dt_match[] = {
-	{.compatible = "maxim,max77686", .data = NULL},
-	{},
+	{
+		.compatible = "maxim,max77686",
+		.data = (void *)TYPE_MAX77686,
+	},
+	{
+		.compatible = "maxim,max77802",
+		.data = (void *)TYPE_MAX77802,
+	},
+	{ },
 };
 
 static void max77686_dt_parse_dvs_gpio(struct device *dev)
@@ -236,6 +340,12 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	struct max77686_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	unsigned int data;
 	int ret = 0;
+	const struct regmap_config *config;
+	const struct regmap_irq_chip *irq_chip;
+	const struct regmap_irq_chip *rtc_irq_chip;
+	struct regmap **rtc_regmap;
+	const struct mfd_cell *cells;
+	int n_devs;
 
 	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node && !pdata)
 		pdata = max77686_i2c_parse_dt_pdata(&i2c->dev);
@@ -258,56 +368,77 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	max77686->wakeup = pdata->wakeup;
 	max77686->irq = i2c->irq;
 
-	max77686->regmap = devm_regmap_init_i2c(i2c, &max77686_regmap_config);
+	if (max77686->type == TYPE_MAX77686) {
+		config = &max77686_regmap_config;
+		irq_chip = &max77686_irq_chip;
+		rtc_irq_chip = &max77686_rtc_irq_chip;
+		rtc_regmap = &max77686->rtc_regmap;
+		cells =  max77686_devs;
+		n_devs = ARRAY_SIZE(max77686_devs);
+	} else {
+		config = &max77802_regmap_config;
+		irq_chip = &max77802_irq_chip;
+		rtc_irq_chip = &max77802_rtc_irq_chip;
+		rtc_regmap = &max77686->regmap;
+		cells =  max77802_devs;
+		n_devs = ARRAY_SIZE(max77802_devs);
+	}
+
+	max77686->regmap = devm_regmap_init_i2c(i2c, config);
 	if (IS_ERR(max77686->regmap)) {
 		ret = PTR_ERR(max77686->regmap);
 		dev_err(max77686->dev, "Failed to allocate register map: %d\n",
-				ret);
+			ret);
 		return ret;
 	}
 
 	ret = regmap_read(max77686->regmap, MAX77686_REG_DEVICE_ID, &data);
 	if (ret < 0) {
 		dev_err(max77686->dev,
-			"device not found on this channel (this is not an error)\n");
-		return -ENODEV;
-	}
-
-	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
-	if (!max77686->rtc) {
-		dev_err(max77686->dev, "Failed to allocate I2C device for RTC\n");
+			"device not found on this channel\n");
 		return -ENODEV;
 	}
-	i2c_set_clientdata(max77686->rtc, max77686);
 
-	max77686->rtc_regmap = devm_regmap_init_i2c(max77686->rtc,
-						    &max77686_rtc_regmap_config);
-	if (IS_ERR(max77686->rtc_regmap)) {
-		ret = PTR_ERR(max77686->rtc_regmap);
-		dev_err(max77686->dev, "failed to allocate RTC regmap: %d\n",
-			ret);
-		goto err_unregister_i2c;
+	if (max77686->type == TYPE_MAX77686) {
+		max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
+		if (!max77686->rtc) {
+			dev_err(max77686->dev,
+				"Failed to allocate I2C device for RTC\n");
+			return -ENODEV;
+		}
+		i2c_set_clientdata(max77686->rtc, max77686);
+
+		max77686->rtc_regmap =
+			devm_regmap_init_i2c(max77686->rtc,
+					     &max77686_rtc_regmap_config);
+		if (IS_ERR(max77686->rtc_regmap)) {
+			ret = PTR_ERR(max77686->rtc_regmap);
+			dev_err(max77686->dev,
+				"failed to allocate RTC regmap: %d\n",
+				ret);
+			goto err_unregister_i2c;
+		}
 	}
 
 	ret = regmap_add_irq_chip(max77686->regmap, max77686->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
-				  IRQF_SHARED, 0, &max77686_irq_chip,
+				  IRQF_SHARED, 0, irq_chip,
 				  &max77686->irq_data);
 	if (ret) {
 		dev_err(&i2c->dev, "failed to add PMIC irq chip: %d\n", ret);
 		goto err_unregister_i2c;
 	}
-	ret = regmap_add_irq_chip(max77686->rtc_regmap, max77686->irq,
+
+	ret = regmap_add_irq_chip(*rtc_regmap, max77686->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
-				  IRQF_SHARED, 0, &max77686_rtc_irq_chip,
+				  IRQF_SHARED, 0, rtc_irq_chip,
 				  &max77686->rtc_irq_data);
 	if (ret) {
 		dev_err(&i2c->dev, "failed to add RTC irq chip: %d\n", ret);
 		goto err_del_irqc;
 	}
 
-	ret = mfd_add_devices(max77686->dev, -1, max77686_devs,
-			      ARRAY_SIZE(max77686_devs), NULL, 0, NULL);
+	ret = mfd_add_devices(max77686->dev, -1, cells, n_devs, NULL, 0, NULL);
 	if (ret < 0) {
 		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
 		goto err_del_rtc_irqc;
@@ -320,7 +451,8 @@ err_del_rtc_irqc:
 err_del_irqc:
 	regmap_del_irq_chip(max77686->irq, max77686->irq_data);
 err_unregister_i2c:
-	i2c_unregister_device(max77686->rtc);
+	if (max77686->type == TYPE_MAX77686)
+		i2c_unregister_device(max77686->rtc);
 
 	return ret;
 }
@@ -341,6 +473,7 @@ static int max77686_i2c_remove(struct i2c_client *i2c)
 
 static const struct i2c_device_id max77686_i2c_id[] = {
 	{ "max77686", TYPE_MAX77686 },
+	{ "max77802", TYPE_MAX77802 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max77686_i2c_id);
@@ -409,6 +542,6 @@ static void __exit max77686_i2c_exit(void)
 }
 module_exit(max77686_i2c_exit);
 
-MODULE_DESCRIPTION("MAXIM 77686 multi-function core driver");
+MODULE_DESCRIPTION("MAXIM 77686/802 multi-function core driver");
 MODULE_AUTHOR("Chiwoong Byun <woong.byun@samsung.com>");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
index 8e17780..0d60b38 100644
--- a/include/linux/mfd/max77686-private.h
+++ b/include/linux/mfd/max77686-private.h
@@ -1,5 +1,5 @@
 /*
- * max77686-private.h - Voltage regulator driver for the Maxim 77686
+ * max77686-private.h - Voltage regulator driver for the Maxim 77686/802
  *
  *  Copyright (C) 2012 Samsung Electrnoics
  *  Chiwoong Byun <woong.byun@samsung.com>
@@ -28,6 +28,7 @@
 
 #define MAX77686_REG_INVALID		(0xff)
 
+/* MAX77686 PMIC registers */
 enum max77686_pmic_reg {
 	MAX77686_REG_DEVICE_ID		= 0x00,
 	MAX77686_REG_INTSRC		= 0x01,
@@ -181,6 +182,210 @@ enum max77686_rtc_reg {
 	MAX77686_ALARM2_DATE		= 0x1B,
 };
 
+/* MAX77802 PMIC registers */
+enum max77802_pmic_reg {
+	MAX77802_REG_DEVICE_ID		= 0x00,
+	MAX77802_REG_INTSRC		= 0x01,
+	MAX77802_REG_INT1		= 0x02,
+	MAX77802_REG_INT2		= 0x03,
+
+	MAX77802_REG_INT1MSK		= 0x04,
+	MAX77802_REG_INT2MSK		= 0x05,
+
+	MAX77802_REG_STATUS1		= 0x06,
+	MAX77802_REG_STATUS2		= 0x07,
+
+	MAX77802_REG_PWRON		= 0x08,
+	/* Reserved: 0x09 */
+	MAX77802_REG_MRSTB		= 0x0A,
+	MAX77802_REG_EPWRHOLD		= 0x0B,
+	/* Reserved: 0x0C-0x0D */
+	MAX77802_REG_BOOSTCTRL		= 0x0E,
+	MAX77802_REG_BOOSTOUT		= 0x0F,
+
+	MAX77802_REG_BUCK1CTRL		= 0x10,
+	MAX77802_REG_BUCK1DVS1		= 0x11,
+	MAX77802_REG_BUCK1DVS2		= 0x12,
+	MAX77802_REG_BUCK1DVS3		= 0x13,
+	MAX77802_REG_BUCK1DVS4		= 0x14,
+	MAX77802_REG_BUCK1DVS5		= 0x15,
+	MAX77802_REG_BUCK1DVS6		= 0x16,
+	MAX77802_REG_BUCK1DVS7		= 0x17,
+	MAX77802_REG_BUCK1DVS8		= 0x18,
+	/* Reserved: 0x19 */
+	MAX77802_REG_BUCK2CTRL1		= 0x1A,
+	MAX77802_REG_BUCK2CTRL2		= 0x1B,
+	MAX77802_REG_BUCK2PHTRAN	= 0x1C,
+	MAX77802_REG_BUCK2DVS1		= 0x1D,
+	MAX77802_REG_BUCK2DVS2		= 0x1E,
+	MAX77802_REG_BUCK2DVS3		= 0x1F,
+	MAX77802_REG_BUCK2DVS4		= 0x20,
+	MAX77802_REG_BUCK2DVS5		= 0x21,
+	MAX77802_REG_BUCK2DVS6		= 0x22,
+	MAX77802_REG_BUCK2DVS7		= 0x23,
+	MAX77802_REG_BUCK2DVS8		= 0x24,
+	/* Reserved: 0x25-0x26 */
+	MAX77802_REG_BUCK3CTRL1		= 0x27,
+	MAX77802_REG_BUCK3DVS1		= 0x28,
+	MAX77802_REG_BUCK3DVS2		= 0x29,
+	MAX77802_REG_BUCK3DVS3		= 0x2A,
+	MAX77802_REG_BUCK3DVS4		= 0x2B,
+	MAX77802_REG_BUCK3DVS5		= 0x2C,
+	MAX77802_REG_BUCK3DVS6		= 0x2D,
+	MAX77802_REG_BUCK3DVS7		= 0x2E,
+	MAX77802_REG_BUCK3DVS8		= 0x2F,
+	/* Reserved: 0x30-0x36 */
+	MAX77802_REG_BUCK4CTRL1		= 0x37,
+	MAX77802_REG_BUCK4DVS1		= 0x38,
+	MAX77802_REG_BUCK4DVS2		= 0x39,
+	MAX77802_REG_BUCK4DVS3		= 0x3A,
+	MAX77802_REG_BUCK4DVS4		= 0x3B,
+	MAX77802_REG_BUCK4DVS5		= 0x3C,
+	MAX77802_REG_BUCK4DVS6		= 0x3D,
+	MAX77802_REG_BUCK4DVS7		= 0x3E,
+	MAX77802_REG_BUCK4DVS8		= 0x3F,
+	/* Reserved: 0x40 */
+	MAX77802_REG_BUCK5CTRL		= 0x41,
+	MAX77802_REG_BUCK5OUT		= 0x42,
+	/* Reserved: 0x43 */
+	MAX77802_REG_BUCK6CTRL		= 0x44,
+	MAX77802_REG_BUCK6DVS1		= 0x45,
+	MAX77802_REG_BUCK6DVS2		= 0x46,
+	MAX77802_REG_BUCK6DVS3		= 0x47,
+	MAX77802_REG_BUCK6DVS4		= 0x48,
+	MAX77802_REG_BUCK6DVS5		= 0x49,
+	MAX77802_REG_BUCK6DVS6		= 0x4A,
+	MAX77802_REG_BUCK6DVS7		= 0x4B,
+	MAX77802_REG_BUCK6DVS8		= 0x4C,
+	/* Reserved: 0x4D */
+	MAX77802_REG_BUCK7CTRL		= 0x4E,
+	MAX77802_REG_BUCK7OUT		= 0x4F,
+	/* Reserved: 0x50 */
+	MAX77802_REG_BUCK8CTRL		= 0x51,
+	MAX77802_REG_BUCK8OUT		= 0x52,
+	/* Reserved: 0x53 */
+	MAX77802_REG_BUCK9CTRL		= 0x54,
+	MAX77802_REG_BUCK9OUT		= 0x55,
+	/* Reserved: 0x56 */
+	MAX77802_REG_BUCK10CTRL		= 0x57,
+	MAX77802_REG_BUCK10OUT		= 0x58,
+
+	/* Reserved: 0x59-0x5F */
+
+	MAX77802_REG_LDO1CTRL1		= 0x60,
+	MAX77802_REG_LDO2CTRL1		= 0x61,
+	MAX77802_REG_LDO3CTRL1		= 0x62,
+	MAX77802_REG_LDO4CTRL1		= 0x63,
+	MAX77802_REG_LDO5CTRL1		= 0x64,
+	MAX77802_REG_LDO6CTRL1		= 0x65,
+	MAX77802_REG_LDO7CTRL1		= 0x66,
+	MAX77802_REG_LDO8CTRL1		= 0x67,
+	MAX77802_REG_LDO9CTRL1		= 0x68,
+	MAX77802_REG_LDO10CTRL1		= 0x69,
+	MAX77802_REG_LDO11CTRL1		= 0x6A,
+	MAX77802_REG_LDO12CTRL1		= 0x6B,
+	MAX77802_REG_LDO13CTRL1		= 0x6C,
+	MAX77802_REG_LDO14CTRL1		= 0x6D,
+	MAX77802_REG_LDO15CTRL1		= 0x6E,
+	/* Reserved: 0x6F */
+	MAX77802_REG_LDO17CTRL1		= 0x70,
+	MAX77802_REG_LDO18CTRL1		= 0x71,
+	MAX77802_REG_LDO19CTRL1		= 0x72,
+	MAX77802_REG_LDO20CTRL1		= 0x73,
+	MAX77802_REG_LDO21CTRL1		= 0x74,
+	MAX77802_REG_LDO22CTRL1		= 0x75,
+	MAX77802_REG_LDO23CTRL1		= 0x76,
+	MAX77802_REG_LDO24CTRL1		= 0x77,
+	MAX77802_REG_LDO25CTRL1		= 0x78,
+	MAX77802_REG_LDO26CTRL1		= 0x79,
+	MAX77802_REG_LDO27CTRL1		= 0x7A,
+	MAX77802_REG_LDO28CTRL1		= 0x7B,
+	MAX77802_REG_LDO29CTRL1		= 0x7C,
+	MAX77802_REG_LDO30CTRL1		= 0x7D,
+	/* Reserved: 0x7E */
+	MAX77802_REG_LDO32CTRL1		= 0x7F,
+	MAX77802_REG_LDO33CTRL1		= 0x80,
+	MAX77802_REG_LDO34CTRL1		= 0x81,
+	MAX77802_REG_LDO35CTRL1		= 0x82,
+	/* Reserved: 0x83-0x8F */
+	MAX77802_REG_LDO1CTRL2		= 0x90,
+	MAX77802_REG_LDO2CTRL2		= 0x91,
+	MAX77802_REG_LDO3CTRL2		= 0x92,
+	MAX77802_REG_LDO4CTRL2		= 0x93,
+	MAX77802_REG_LDO5CTRL2		= 0x94,
+	MAX77802_REG_LDO6CTRL2		= 0x95,
+	MAX77802_REG_LDO7CTRL2		= 0x96,
+	MAX77802_REG_LDO8CTRL2		= 0x97,
+	MAX77802_REG_LDO9CTRL2		= 0x98,
+	MAX77802_REG_LDO10CTRL2		= 0x99,
+	MAX77802_REG_LDO11CTRL2		= 0x9A,
+	MAX77802_REG_LDO12CTRL2		= 0x9B,
+	MAX77802_REG_LDO13CTRL2		= 0x9C,
+	MAX77802_REG_LDO14CTRL2		= 0x9D,
+	MAX77802_REG_LDO15CTRL2		= 0x9E,
+	/* Reserved: 0x9F */
+	MAX77802_REG_LDO17CTRL2		= 0xA0,
+	MAX77802_REG_LDO18CTRL2		= 0xA1,
+	MAX77802_REG_LDO19CTRL2		= 0xA2,
+	MAX77802_REG_LDO20CTRL2		= 0xA3,
+	MAX77802_REG_LDO21CTRL2		= 0xA4,
+	MAX77802_REG_LDO22CTRL2		= 0xA5,
+	MAX77802_REG_LDO23CTRL2		= 0xA6,
+	MAX77802_REG_LDO24CTRL2		= 0xA7,
+	MAX77802_REG_LDO25CTRL2		= 0xA8,
+	MAX77802_REG_LDO26CTRL2		= 0xA9,
+	MAX77802_REG_LDO27CTRL2		= 0xAA,
+	MAX77802_REG_LDO28CTRL2		= 0xAB,
+	MAX77802_REG_LDO29CTRL2		= 0xAC,
+	MAX77802_REG_LDO30CTRL2		= 0xAD,
+	/* Reserved: 0xAE */
+	MAX77802_REG_LDO32CTRL2		= 0xAF,
+	MAX77802_REG_LDO33CTRL2		= 0xB0,
+	MAX77802_REG_LDO34CTRL2		= 0xB1,
+	MAX77802_REG_LDO35CTRL2		= 0xB2,
+	/* Reserved: 0xB3 */
+
+	MAX77802_REG_BBAT_CHG		= 0xB4,
+	MAX77802_REG_32KHZ		= 0xB5,
+
+	MAX77802_REG_PMIC_END		= 0xB6,
+};
+
+enum max77802_rtc_reg {
+	MAX77802_RTC_INT		= 0xC0,
+	MAX77802_RTC_INTM		= 0xC1,
+	MAX77802_RTC_CONTROLM		= 0xC2,
+	MAX77802_RTC_CONTROL		= 0xC3,
+	MAX77802_RTC_UPDATE0		= 0xC4,
+	MAX77802_RTC_UPDATE1		= 0xC5,
+	MAX77802_WTSR_SMPL_CNTL		= 0xC6,
+	MAX77802_RTC_SEC		= 0xC7,
+	MAX77802_RTC_MIN		= 0xC8,
+	MAX77802_RTC_HOUR		= 0xC9,
+	MAX77802_RTC_WEEKDAY		= 0xCA,
+	MAX77802_RTC_MONTH		= 0xCB,
+	MAX77802_RTC_YEAR		= 0xCC,
+	MAX77802_RTC_DATE		= 0xCD,
+	MAX77802_RTC_AE1		= 0xCE,
+	MAX77802_ALARM1_SEC		= 0xCF,
+	MAX77802_ALARM1_MIN		= 0xD0,
+	MAX77802_ALARM1_HOUR		= 0xD1,
+	MAX77802_ALARM1_WEEKDAY		= 0xD2,
+	MAX77802_ALARM1_MONTH		= 0xD3,
+	MAX77802_ALARM1_YEAR		= 0xD4,
+	MAX77802_ALARM1_DATE		= 0xD5,
+	MAX77802_RTC_AE2		= 0xD6,
+	MAX77802_ALARM2_SEC		= 0xD7,
+	MAX77802_ALARM2_MIN		= 0xD8,
+	MAX77802_ALARM2_HOUR		= 0xD9,
+	MAX77802_ALARM2_WEEKDAY		= 0xDA,
+	MAX77802_ALARM2_MONTH		= 0xDB,
+	MAX77802_ALARM2_YEAR		= 0xDC,
+	MAX77802_ALARM2_DATE		= 0xDD,
+
+	MAX77802_RTC_END		= 0xDF,
+};
+
 enum max77686_irq_source {
 	PMIC_INT1 = 0,
 	PMIC_INT2,
@@ -250,6 +455,7 @@ struct max77686_dev {
 
 enum max77686_types {
 	TYPE_MAX77686,
+	TYPE_MAX77802,
 };
 
 extern int max77686_irq_init(struct max77686_dev *max77686);
diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
index 46a736b..ff021b8 100644
--- a/include/linux/mfd/max77686.h
+++ b/include/linux/mfd/max77686.h
@@ -1,5 +1,5 @@
 /*
- * max77686.h - Driver for the Maxim 77686
+ * max77686.h - Driver for the Maxim 77686/802
  *
  *  Copyright (C) 2012 Samsung Electrnoics
  *  Chiwoong Byun <woong.byun@samsung.com>
@@ -71,6 +71,54 @@ enum max77686_regulators {
 	MAX77686_REG_MAX,
 };
 
+/* MAX77802 regulator IDs */
+enum max77802_regulators {
+	MAX77802_BUCK1 = 0,
+	MAX77802_BUCK2,
+	MAX77802_BUCK3,
+	MAX77802_BUCK4,
+	MAX77802_BUCK5,
+	MAX77802_BUCK6,
+	MAX77802_BUCK7,
+	MAX77802_BUCK8,
+	MAX77802_BUCK9,
+	MAX77802_BUCK10,
+	MAX77802_LDO1,
+	MAX77802_LDO2,
+	MAX77802_LDO3,
+	MAX77802_LDO4,
+	MAX77802_LDO5,
+	MAX77802_LDO6,
+	MAX77802_LDO7,
+	MAX77802_LDO8,
+	MAX77802_LDO9,
+	MAX77802_LDO10,
+	MAX77802_LDO11,
+	MAX77802_LDO12,
+	MAX77802_LDO13,
+	MAX77802_LDO14,
+	MAX77802_LDO15,
+	MAX77802_LDO17,
+	MAX77802_LDO18,
+	MAX77802_LDO19,
+	MAX77802_LDO20,
+	MAX77802_LDO21,
+	MAX77802_LDO23,
+	MAX77802_LDO24,
+	MAX77802_LDO25,
+	MAX77802_LDO26,
+	MAX77802_LDO27,
+	MAX77802_LDO28,
+	MAX77802_LDO29,
+	MAX77802_LDO30,
+	MAX77802_LDO32,
+	MAX77802_LDO33,
+	MAX77802_LDO34,
+	MAX77802_LDO35,
+
+	MAX77802_REG_MAX,
+};
+
 struct max77686_regulator_data {
 	int id;
 	struct regulator_init_data *initdata;
@@ -83,6 +131,13 @@ enum max77686_opmode {
 	MAX77686_OPMODE_STANDBY,
 };
 
+enum max77802_opmode {
+	MAX77802_OPMODE_OFF,
+	MAX77802_OPMODE_STANDBY,
+	MAX77802_OPMODE_LP,
+	MAX77802_OPMODE_NORMAL,
+};
+
 struct max77686_opmode_data {
 	int id;
 	int mode;
@@ -106,7 +161,8 @@ struct max77686_platform_data {
 	struct gpio_desc *buck_gpio_dvs[3]; /* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
 	int buck_default_idx; /* Default value of DVS1, 2, 3 */
 
-	struct gpio_desc *buck_gpio_selb[3]; /* Buck regulators 2, 3, 4 */
+	/* GPIO-SELBx - MAX77686: 2, 3, 4; MAX77802: 1, 2, 3, 4, 6 */
+	struct gpio_desc *buck_gpio_selb[5];
 };
 
 extern int max77686_setup_gpios(struct device *dev);
-- 
2.0.0.rc2

