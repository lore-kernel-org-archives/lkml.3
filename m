Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaDNJRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:17:52 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54678 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaDNJRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:17:42 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-c0-534ba7b11dd9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 7/9] mfd: max77836: Add MAX77836 support to max14577 driver
Date: Mon, 14 Apr 2014 11:17:18 +0200
Message-id: <1397467040-30502-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Fd2Ny72DDbbtV7DYOGM9q8XUh0/Y
	LK5/ec5q8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbHwkE1B2zbGitXTvzA1
	MHbNYOxi5OSQEDCRWPvjDJQtJnHh3nq2LkYuDiGBpYwS+6+9ZIVw+pgk/n17DlbFJmAssXn5
	ErAqEYFmJomWvrOMIA6zwFFGiem9b5lAqoQF/CT2vJvLCmKzCKhK7Dh+Hsjm4OAVcJd48j4Z
	Yp2CxLIva5lBbE4BD4lb3cfAbCGgkhefbrNPYORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10v
	OT93EyMkDL/uYFx6zOoQowAHoxIPb8cc72Ah1sSy4srcQ4wSHMxKIrzbMryChXhTEiurUovy
	44tKc1KLDzEycXBKNTBumfnk5Z8LQVNqvDzM//SGiG49wJkcc/bSu5b64h6PKU/YdK6LZAd5
	XypKSZfdXXgixtVPqipvMTNrQNGjc+6xFamTIjkNcmMPZJ3xXLNGWyc1Z51BzwxvkfjPu3V6
	9jwJum2iIuhcvpez/wZ7U79eWeP/v/piHwuk+KNXTUwouH/4XvXWdCWW4oxEQy3mouJEABxB
	CrwhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Maxim 77836 support to max14577 driver. The chipsets have same MUIC
component so the extcon, charger and regulators are almost the same. The
MAX77836 however has also PMIC and Fuel Gauge.

The MAX77836 uses three I2C slave addresses and has additional interrupts
(related to PMIC and Fuel Gauge). It has also Interrupt Source register,
just like MAX77686 and MAX77693.

The MAX77836 PMIC's TOPSYS and INTSRC interrupts are reported in the
PMIC block. The PMIC block has different I2C slave address and uses own
regmap so another regmap_irq_chip is needed.

Since we have two regmap_irq_chip, use shared interrupts on MAX77836.

This patch adds additional defines and functions to the max14577 MFD core
driver so the driver will handle both chipsets. Also this patch replaces
"0x1 << N" with BIT(N) in defines for register masks.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig                  |   6 +-
 drivers/mfd/max14577.c               | 217 +++++++++++++++++++++++++++++++++--
 include/linux/mfd/max14577-private.h | 145 +++++++++++++++++------
 include/linux/mfd/max14577.h         |   7 +-
 4 files changed, 330 insertions(+), 45 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 33834120d057..5bdefe72625e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -331,15 +331,15 @@ config MFD_88PM860X
 	  battery-charger under the corresponding menus.
 
 config MFD_MAX14577
-	bool "Maxim Semiconductor MAX14577 MUIC + Charger Support"
+	bool "Maxim Semiconductor MAX14577/77836 MUIC + Charger Support"
 	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select IRQ_DOMAIN
 	help
-	  Say yes here to add support for Maxim Semiconductor MAX14577.
-	  This is a Micro-USB IC with Charger controls on chip.
+	  Say yes here to add support for Maxim Semiconductor MAX14577 and
+	  MAX77836 Micro-USB ICs with battery charger.
 	  This driver provides common support for accessing the device;
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 6f39dec9dfdf..20e3b2d81bf0 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -1,7 +1,7 @@
 /*
- * max14577.c - mfd core driver for the Maxim 14577
+ * max14577.c - mfd core driver for the Maxim 14577/77836
  *
- * Copyright (C) 2013 Samsung Electrnoics
+ * Copyright (C) 2014 Samsung Electrnoics
  * Chanwoo Choi <cw00.choi@samsung.com>
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
@@ -38,11 +38,34 @@ static struct mfd_cell max14577_devs[] = {
 	{ .name = "max14577-charger", },
 };
 
+static struct mfd_cell max77836_devs[] = {
+	{
+		.name = "max77836-muic",
+		.of_compatible = "maxim,max77836-muic",
+	},
+	{
+		.name = "max77836-regulator",
+		.of_compatible = "maxim,max77836-regulator",
+	},
+	{
+		.name = "max77836-charger",
+		.of_compatible = "maxim,max77836-charger",
+	},
+	{
+		.name = "max77836-battery",
+		.of_compatible = "maxim,max77836-battery",
+	},
+};
+
 static struct of_device_id max14577_dt_match[] = {
 	{
 		.compatible = "maxim,max14577",
 		.data = (void *)MAXIM_DEVICE_TYPE_MAX14577,
 	},
+	{
+		.compatible = "maxim,max77836",
+		.data = (void *)MAXIM_DEVICE_TYPE_MAX77836,
+	},
 	{},
 };
 
@@ -57,6 +80,26 @@ static bool max14577_muic_volatile_reg(struct device *dev, unsigned int reg)
 	return false;
 }
 
+static bool max77836_muic_volatile_reg(struct device *dev, unsigned int reg)
+{
+	/* Any max14577 volatile registers are also max77836 volatile. */
+	if (max14577_muic_volatile_reg(dev, reg))
+		return true;
+
+	switch (reg) {
+	case MAX77836_FG_REG_VCELL_MSB ... MAX77836_FG_REG_SOC_LSB:
+	case MAX77836_FG_REG_CRATE_MSB ... MAX77836_FG_REG_CRATE_LSB:
+	case MAX77836_FG_REG_STATUS_H ... MAX77836_FG_REG_STATUS_L:
+	case MAX77836_PMIC_REG_INTSRC:
+	case MAX77836_PMIC_REG_TOPSYS_INT:
+	case MAX77836_PMIC_REG_TOPSYS_STAT:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
 static const struct regmap_config max14577_muic_regmap_config = {
 	.reg_bits	= 8,
 	.val_bits	= 8,
@@ -64,6 +107,13 @@ static const struct regmap_config max14577_muic_regmap_config = {
 	.max_register	= MAX14577_REG_END,
 };
 
+static const struct regmap_config max77836_pmic_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.volatile_reg	= max77836_muic_volatile_reg,
+	.max_register	= MAX77836_PMIC_REG_END,
+};
+
 static const struct regmap_irq max14577_irqs[] = {
 	/* INT1 interrupts */
 	{ .reg_offset = 0, .mask = MAX14577_INT1_ADC_MASK, },
@@ -86,12 +136,56 @@ static const struct regmap_irq_chip max14577_irq_chip = {
 	.name			= "max14577",
 	.status_base		= MAX14577_REG_INT1,
 	.mask_base		= MAX14577_REG_INTMASK1,
-	.mask_invert		= 1,
+	.mask_invert		= true,
 	.num_regs		= 3,
 	.irqs			= max14577_irqs,
 	.num_irqs		= ARRAY_SIZE(max14577_irqs),
 };
 
+static const struct regmap_irq max77836_muic_irqs[] = {
+	/* INT1 interrupts */
+	{ .reg_offset = 0, .mask = MAX14577_INT1_ADC_MASK, },
+	{ .reg_offset = 0, .mask = MAX14577_INT1_ADCLOW_MASK, },
+	{ .reg_offset = 0, .mask = MAX14577_INT1_ADCERR_MASK, },
+	/* INT2 interrupts */
+	{ .reg_offset = 1, .mask = MAX14577_INT2_CHGTYP_MASK, },
+	{ .reg_offset = 1, .mask = MAX14577_INT2_CHGDETRUN_MASK, },
+	{ .reg_offset = 1, .mask = MAX14577_INT2_DCDTMR_MASK, },
+	{ .reg_offset = 1, .mask = MAX14577_INT2_DBCHG_MASK, },
+	{ .reg_offset = 1, .mask = MAX14577_INT2_VBVOLT_MASK, },
+	{ .reg_offset = 1, .mask = MAX77836_INT2_VIDRM_MASK, },
+	/* INT3 interrupts */
+	{ .reg_offset = 2, .mask = MAX14577_INT3_EOC_MASK, },
+	{ .reg_offset = 2, .mask = MAX14577_INT3_CGMBC_MASK, },
+	{ .reg_offset = 2, .mask = MAX14577_INT3_OVP_MASK, },
+	{ .reg_offset = 2, .mask = MAX14577_INT3_MBCCHGERR_MASK, },
+};
+
+static const struct regmap_irq_chip max77836_muic_irq_chip = {
+	.name			= "max77836-muic",
+	.status_base		= MAX14577_REG_INT1,
+	.mask_base		= MAX14577_REG_INTMASK1,
+	.mask_invert		= true,
+	.num_regs		= 3,
+	.irqs			= max77836_muic_irqs,
+	.num_irqs		= ARRAY_SIZE(max77836_muic_irqs),
+};
+
+static const struct regmap_irq max77836_pmic_irqs[] = {
+	{ .reg_offset = 0, .mask = MAX77836_TOPSYS_INT_T120C_MASK, },
+	{ .reg_offset = 0, .mask = MAX77836_TOPSYS_INT_T140C_MASK, },
+};
+
+static const struct regmap_irq_chip max77836_pmic_irq_chip = {
+	.name			= "max77836-pmic",
+	.status_base		= MAX77836_PMIC_REG_TOPSYS_INT,
+	.mask_base		= MAX77836_PMIC_REG_TOPSYS_INT_MASK,
+	.mask_invert		= false,
+	.num_regs		= 1,
+	.irqs			= max77836_pmic_irqs,
+	.num_irqs		= ARRAY_SIZE(max77836_pmic_irqs),
+};
+
 static void max14577_print_dev_type(struct max14577 *max14577)
 {
 	u8 reg_data, vendor_id, device_id;
@@ -114,6 +208,81 @@ static void max14577_print_dev_type(struct max14577 *max14577)
 			max14577->dev_type, device_id, vendor_id);
 }
 
+/*
+ * Max77836 specific initialization code for driver probe.
+ * Adds new I2C dummy device, regmap and regmap IRQ chip.
+ * Unmasks Interrupt Source register.
+ *
+ * On success returns 0.
+ * On failure returns errno and reverts any changes done so far (e.g. remove
+ * I2C dummy device), except masking the INT SRC register.
+ */
+static int max77836_init(struct max14577 *max14577)
+{
+	int ret;
+	u8 intsrc_mask;
+
+	max14577->i2c_pmic = i2c_new_dummy(max14577->i2c->adapter,
+			I2C_ADDR_PMIC);
+	if (!max14577->i2c_pmic) {
+		dev_err(max14577->dev, "Failed to register PMIC I2C device\n");
+		return -ENODEV;
+	}
+	i2c_set_clientdata(max14577->i2c_pmic, max14577);
+
+	max14577->regmap_pmic = devm_regmap_init_i2c(max14577->i2c_pmic,
+			&max77836_pmic_regmap_config);
+	if (IS_ERR(max14577->regmap_pmic)) {
+		ret = PTR_ERR(max14577->regmap_pmic);
+		dev_err(max14577->dev, "Failed to allocate PMIC register map: %d\n",
+				ret);
+		goto err;
+	}
+
+	/* Un-mask MAX77836 Interrupt Source register */
+	ret = max14577_read_reg(max14577->regmap_pmic,
+			MAX77836_PMIC_REG_INTSRC_MASK, &intsrc_mask);
+	if (ret < 0) {
+		dev_err(max14577->dev, "Failed to read PMIC register\n");
+		goto err;
+	}
+
+	intsrc_mask &= ~(MAX77836_INTSRC_MASK_TOP_INT_MASK);
+	intsrc_mask &= ~(MAX77836_INTSRC_MASK_MUIC_CHG_INT_MASK);
+	ret = max14577_write_reg(max14577->regmap_pmic,
+			MAX77836_PMIC_REG_INTSRC_MASK, intsrc_mask);
+	if (ret < 0) {
+		dev_err(max14577->dev, "Failed to write PMIC register\n");
+		goto err;
+	}
+
+	ret = regmap_add_irq_chip(max14577->regmap_pmic, max14577->irq,
+			IRQF_TRIGGER_FALLING | IRQF_ONESHOT | IRQF_SHARED,
+			0, &max77836_pmic_irq_chip,
+			&max14577->irq_data_pmic);
+	if (ret != 0) {
+		dev_err(max14577->dev, "Failed to request PMIC IRQ %d: %d\n",
+				max14577->irq, ret);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	i2c_unregister_device(max14577->i2c_pmic);
+
+	return ret;
+}
+
+/*
+ * Max77836 specific de-initialization code for driver remove.
+ */
+static void max77836_remove(struct max14577 *max14577)
+{
+	regmap_del_irq_chip(max14577->irq, max14577->irq_data_pmic);
+	i2c_unregister_device(max14577->i2c_pmic);
+}
+
 static int max14577_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
@@ -121,6 +290,10 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	struct max14577_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct device_node *np = i2c->dev.of_node;
 	int ret = 0;
+	const struct regmap_irq_chip *irq_chip;
+	struct mfd_cell *mfd_devs;
+	unsigned int mfd_devs_size;
+	int irq_flags;
 
 	if (np) {
 		pdata = devm_kzalloc(&i2c->dev, sizeof(*pdata), GFP_KERNEL);
@@ -164,9 +337,24 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 
 	max14577_print_dev_type(max14577);
 
+	switch (max14577->dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		irq_chip = &max77836_muic_irq_chip;
+		mfd_devs = max77836_devs;
+		mfd_devs_size = ARRAY_SIZE(max77836_devs);
+		irq_flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT | IRQF_SHARED;
+		break;
+	case MAXIM_DEVICE_TYPE_MAX14577:
+	default:
+		irq_chip = &max14577_irq_chip;
+		mfd_devs = max14577_devs;
+		mfd_devs_size = ARRAY_SIZE(max14577_devs);
+		irq_flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+		break;
+	}
+
 	ret = regmap_add_irq_chip(max14577->regmap, max14577->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT, 0,
-				  &max14577_irq_chip,
+				  irq_flags, 0, irq_chip,
 				  &max14577->irq_data);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
@@ -174,8 +362,15 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	ret = mfd_add_devices(max14577->dev, -1, max14577_devs,
-			ARRAY_SIZE(max14577_devs), NULL, 0,
+	/* Max77836 specific initialization code (additional regmap) */
+	if (max14577->dev_type == MAXIM_DEVICE_TYPE_MAX77836) {
+		ret = max77836_init(max14577);
+		if (ret < 0)
+			goto err_max77836;
+	}
+
+	ret = mfd_add_devices(max14577->dev, -1, mfd_devs,
+			mfd_devs_size, NULL, 0,
 			regmap_irq_get_domain(max14577->irq_data));
 	if (ret < 0)
 		goto err_mfd;
@@ -185,6 +380,9 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	return 0;
 
 err_mfd:
+	if (max14577->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
+		max77836_remove(max14577);
+err_max77836:
 	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
 
 	return ret;
@@ -196,12 +394,15 @@ static int max14577_i2c_remove(struct i2c_client *i2c)
 
 	mfd_remove_devices(max14577->dev);
 	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
+	if (max14577->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
+		max77836_remove(max14577);
 
 	return 0;
 }
 
 static const struct i2c_device_id max14577_i2c_id[] = {
 	{ "max14577", MAXIM_DEVICE_TYPE_MAX14577, },
+	{ "max77836", MAXIM_DEVICE_TYPE_MAX77836, },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
@@ -274,5 +475,5 @@ static void __exit max14577_i2c_exit(void)
 module_exit(max14577_i2c_exit);
 
 MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>");
-MODULE_DESCRIPTION("MAXIM 14577 multi-function core driver");
+MODULE_DESCRIPTION("Maxim 14577/77836 multi-function core driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 989183d232cd..e301bd19b067 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -1,7 +1,7 @@
 /*
- * max14577-private.h - Common API for the Maxim 14577 internal sub chip
+ * max14577-private.h - Common API for the Maxim 14577/77836 internal sub chip
  *
- * Copyright (C) 2013 Samsung Electrnoics
+ * Copyright (C) 2014 Samsung Electrnoics
  * Chanwoo Choi <cw00.choi@samsung.com>
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
@@ -22,9 +22,14 @@
 #include <linux/i2c.h>
 #include <linux/regmap.h>
 
+#define I2C_ADDR_PMIC	(0x46 >> 1)
+#define I2C_ADDR_MUIC	(0x4A >> 1)
+#define I2C_ADDR_FG	(0x6C >> 1)
+
 enum maxim_device_type {
 	MAXIM_DEVICE_TYPE_UNKNOWN	= 0,
 	MAXIM_DEVICE_TYPE_MAX14577,
+	MAXIM_DEVICE_TYPE_MAX77836,
 
 	MAXIM_DEVICE_TYPE_NUM,
 };
@@ -88,6 +93,7 @@ enum max14577_muic_charger_type {
 #define MAX14577_INT2_DCDTMR_MASK	BIT(2)
 #define MAX14577_INT2_DBCHG_MASK	BIT(3)
 #define MAX14577_INT2_VBVOLT_MASK	BIT(4)
+#define MAX77836_INT2_VIDRM_MASK	BIT(5)
 
 #define MAX14577_INT3_EOC_MASK		BIT(0)
 #define MAX14577_INT3_CGMBC_MASK	BIT(1)
@@ -104,9 +110,11 @@ enum max14577_muic_charger_type {
 #define STATUS1_ADC_SHIFT		0
 #define STATUS1_ADCLOW_SHIFT		5
 #define STATUS1_ADCERR_SHIFT		6
+#define MAX77836_STATUS1_ADC1K_SHIFT	7
 #define STATUS1_ADC_MASK		(0x1f << STATUS1_ADC_SHIFT)
-#define STATUS1_ADCLOW_MASK		(0x1 << STATUS1_ADCLOW_SHIFT)
-#define STATUS1_ADCERR_MASK		(0x1 << STATUS1_ADCERR_SHIFT)
+#define STATUS1_ADCLOW_MASK		BIT(STATUS1_ADCLOW_SHIFT)
+#define STATUS1_ADCERR_MASK		BIT(STATUS1_ADCERR_SHIFT)
+#define MAX77836_STATUS1_ADC1K_MASK	BIT(MAX77836_STATUS1_ADC1K_SHIFT)
 
 /* MAX14577 STATUS2 register */
 #define STATUS2_CHGTYP_SHIFT		0
@@ -114,11 +122,13 @@ enum max14577_muic_charger_type {
 #define STATUS2_DCDTMR_SHIFT		4
 #define STATUS2_DBCHG_SHIFT		5
 #define STATUS2_VBVOLT_SHIFT		6
+#define MAX77836_STATUS2_VIDRM_SHIFT	7
 #define STATUS2_CHGTYP_MASK		(0x7 << STATUS2_CHGTYP_SHIFT)
-#define STATUS2_CHGDETRUN_MASK		(0x1 << STATUS2_CHGDETRUN_SHIFT)
-#define STATUS2_DCDTMR_MASK		(0x1 << STATUS2_DCDTMR_SHIFT)
-#define STATUS2_DBCHG_MASK		(0x1 << STATUS2_DBCHG_SHIFT)
-#define STATUS2_VBVOLT_MASK		(0x1 << STATUS2_VBVOLT_SHIFT)
+#define STATUS2_CHGDETRUN_MASK		BIT(STATUS2_CHGDETRUN_SHIFT)
+#define STATUS2_DCDTMR_MASK		BIT(STATUS2_DCDTMR_SHIFT)
+#define STATUS2_DBCHG_MASK		BIT(STATUS2_DBCHG_SHIFT)
+#define STATUS2_VBVOLT_MASK		BIT(STATUS2_VBVOLT_SHIFT)
+#define MAX77836_STATUS2_VIDRM_MASK	BIT(MAX77836_STATUS2_VIDRM_SHIFT)
 
 /* MAX14577 CONTROL1 register */
 #define COMN1SW_SHIFT			0
@@ -127,8 +137,8 @@ enum max14577_muic_charger_type {
 #define IDBEN_SHIFT			7
 #define COMN1SW_MASK			(0x7 << COMN1SW_SHIFT)
 #define COMP2SW_MASK			(0x7 << COMP2SW_SHIFT)
-#define MICEN_MASK			(0x1 << MICEN_SHIFT)
-#define IDBEN_MASK			(0x1 << IDBEN_SHIFT)
+#define MICEN_MASK			BIT(MICEN_SHIFT)
+#define IDBEN_MASK			BIT(IDBEN_SHIFT)
 #define CLEAR_IDBEN_MICEN_MASK		(COMN1SW_MASK | COMP2SW_MASK)
 #define CTRL1_SW_USB			((1 << COMP2SW_SHIFT) \
 						| (1 << COMN1SW_SHIFT))
@@ -148,14 +158,14 @@ enum max14577_muic_charger_type {
 #define CTRL2_ACCDET_SHIFT		(5)
 #define CTRL2_USBCPINT_SHIFT		(6)
 #define CTRL2_RCPS_SHIFT		(7)
-#define CTRL2_LOWPWR_MASK		(0x1 << CTRL2_LOWPWR_SHIFT)
-#define CTRL2_ADCEN_MASK		(0x1 << CTRL2_ADCEN_SHIFT)
-#define CTRL2_CPEN_MASK			(0x1 << CTRL2_CPEN_SHIFT)
-#define CTRL2_SFOUTASRT_MASK		(0x1 << CTRL2_SFOUTASRT_SHIFT)
-#define CTRL2_SFOUTORD_MASK		(0x1 << CTRL2_SFOUTORD_SHIFT)
-#define CTRL2_ACCDET_MASK		(0x1 << CTRL2_ACCDET_SHIFT)
-#define CTRL2_USBCPINT_MASK		(0x1 << CTRL2_USBCPINT_SHIFT)
-#define CTRL2_RCPS_MASK			(0x1 << CTR2_RCPS_SHIFT)
+#define CTRL2_LOWPWR_MASK		BIT(CTRL2_LOWPWR_SHIFT)
+#define CTRL2_ADCEN_MASK		BIT(CTRL2_ADCEN_SHIFT)
+#define CTRL2_CPEN_MASK			BIT(CTRL2_CPEN_SHIFT)
+#define CTRL2_SFOUTASRT_MASK		BIT(CTRL2_SFOUTASRT_SHIFT)
+#define CTRL2_SFOUTORD_MASK		BIT(CTRL2_SFOUTORD_SHIFT)
+#define CTRL2_ACCDET_MASK		BIT(CTRL2_ACCDET_SHIFT)
+#define CTRL2_USBCPINT_MASK		BIT(CTRL2_USBCPINT_SHIFT)
+#define CTRL2_RCPS_MASK			BIT(CTRL2_RCPS_SHIFT)
 
 #define CTRL2_CPEN1_LOWPWR0 ((1 << CTRL2_CPEN_SHIFT) | \
 				(0 << CTRL2_LOWPWR_SHIFT))
@@ -203,14 +213,14 @@ enum max14577_charger_reg {
 #define CDETCTRL1_DBEXIT_SHIFT		5
 #define CDETCTRL1_DBIDLE_SHIFT		6
 #define CDETCTRL1_CDPDET_SHIFT		7
-#define CDETCTRL1_CHGDETEN_MASK		(0x1 << CDETCTRL1_CHGDETEN_SHIFT)
-#define CDETCTRL1_CHGTYPMAN_MASK	(0x1 << CDETCTRL1_CHGTYPMAN_SHIFT)
-#define CDETCTRL1_DCDEN_MASK		(0x1 << CDETCTRL1_DCDEN_SHIFT)
-#define CDETCTRL1_DCD2SCT_MASK		(0x1 << CDETCTRL1_DCD2SCT_SHIFT)
-#define CDETCTRL1_DCHKTM_MASK		(0x1 << CDETCTRL1_DCHKTM_SHIFT)
-#define CDETCTRL1_DBEXIT_MASK		(0x1 << CDETCTRL1_DBEXIT_SHIFT)
-#define CDETCTRL1_DBIDLE_MASK		(0x1 << CDETCTRL1_DBIDLE_SHIFT)
-#define CDETCTRL1_CDPDET_MASK		(0x1 << CDETCTRL1_CDPDET_SHIFT)
+#define CDETCTRL1_CHGDETEN_MASK		BIT(CDETCTRL1_CHGDETEN_SHIFT)
+#define CDETCTRL1_CHGTYPMAN_MASK	BIT(CDETCTRL1_CHGTYPMAN_SHIFT)
+#define CDETCTRL1_DCDEN_MASK		BIT(CDETCTRL1_DCDEN_SHIFT)
+#define CDETCTRL1_DCD2SCT_MASK		BIT(CDETCTRL1_DCD2SCT_SHIFT)
+#define CDETCTRL1_DCHKTM_MASK		BIT(CDETCTRL1_DCHKTM_SHIFT)
+#define CDETCTRL1_DBEXIT_MASK		BIT(CDETCTRL1_DBEXIT_SHIFT)
+#define CDETCTRL1_DBIDLE_MASK		BIT(CDETCTRL1_DBIDLE_SHIFT)
+#define CDETCTRL1_CDPDET_MASK		BIT(CDETCTRL1_CDPDET_SHIFT)
 
 /* MAX14577 CHGCTRL1 register */
 #define CHGCTRL1_TCHW_SHIFT		4
@@ -218,9 +228,9 @@ enum max14577_charger_reg {
 
 /* MAX14577 CHGCTRL2 register */
 #define CHGCTRL2_MBCHOSTEN_SHIFT	6
-#define CHGCTRL2_MBCHOSTEN_MASK		(0x1 << CHGCTRL2_MBCHOSTEN_SHIFT)
+#define CHGCTRL2_MBCHOSTEN_MASK		BIT(CHGCTRL2_MBCHOSTEN_SHIFT)
 #define CHGCTRL2_VCHGR_RC_SHIFT		7
-#define CHGCTRL2_VCHGR_RC_MASK		(0x1 << CHGCTRL2_VCHGR_RC_SHIFT)
+#define CHGCTRL2_VCHGR_RC_MASK		BIT(CHGCTRL2_VCHGR_RC_SHIFT)
 
 /* MAX14577 CHGCTRL3 register */
 #define CHGCTRL3_MBCCVWRC_SHIFT		0
@@ -230,7 +240,7 @@ enum max14577_charger_reg {
 #define CHGCTRL4_MBCICHWRCH_SHIFT	0
 #define CHGCTRL4_MBCICHWRCH_MASK	(0xf << CHGCTRL4_MBCICHWRCH_SHIFT)
 #define CHGCTRL4_MBCICHWRCL_SHIFT	4
-#define CHGCTRL4_MBCICHWRCL_MASK	(0x1 << CHGCTRL4_MBCICHWRCL_SHIFT)
+#define CHGCTRL4_MBCICHWRCL_MASK	BIT(CHGCTRL4_MBCICHWRCL_SHIFT)
 
 /* MAX14577 CHGCTRL5 register */
 #define CHGCTRL5_EOCS_SHIFT		0
@@ -238,7 +248,7 @@ enum max14577_charger_reg {
 
 /* MAX14577 CHGCTRL6 register */
 #define CHGCTRL6_AUTOSTOP_SHIFT		5
-#define CHGCTRL6_AUTOSTOP_MASK		(0x1 << CHGCTRL6_AUTOSTOP_SHIFT)
+#define CHGCTRL6_AUTOSTOP_MASK		BIT(CHGCTRL6_AUTOSTOP_SHIFT)
 
 /* MAX14577 CHGCTRL7 register */
 #define CHGCTRL7_OTPCGHCVS_SHIFT	0
@@ -253,6 +263,70 @@ enum max14577_charger_reg {
 /* MAX14577 regulator SFOUT LDO voltage, fixed, uV */
 #define MAX14577_REGULATOR_SAFEOUT_VOLTAGE		4900000
 
+/* Slave addr = 0x46: PMIC */
+enum max77836_pmic_reg {
+	MAX77836_PMIC_REG_PMIC_ID		= 0x20,
+	MAX77836_PMIC_REG_PMIC_REV		= 0x21,
+	MAX77836_PMIC_REG_INTSRC		= 0x22,
+	MAX77836_PMIC_REG_INTSRC_MASK		= 0x23,
+	MAX77836_PMIC_REG_TOPSYS_INT		= 0x24,
+	MAX77836_PMIC_REG_TOPSYS_INT_MASK	= 0x26,
+	MAX77836_PMIC_REG_TOPSYS_STAT		= 0x28,
+	MAX77836_PMIC_REG_MRSTB_CNTL		= 0x2A,
+	MAX77836_PMIC_REG_LSCNFG		= 0x2B,
+
+	MAX77836_LDO_REG_CNFG1_LDO1		= 0x51,
+	MAX77836_LDO_REG_CNFG2_LDO1		= 0x52,
+	MAX77836_LDO_REG_CNFG1_LDO2		= 0x53,
+	MAX77836_LDO_REG_CNFG2_LDO2		= 0x54,
+	MAX77836_LDO_REG_CNFG_LDO_BIAS		= 0x55,
+
+	MAX77836_COMP_REG_COMP1			= 0x60,
+
+	MAX77836_PMIC_REG_END,
+};
+
+#define MAX77836_INTSRC_MASK_TOP_INT_SHIFT	1
+#define MAX77836_INTSRC_MASK_MUIC_CHG_INT_SHIFT	3
+#define MAX77836_INTSRC_MASK_TOP_INT_MASK	BIT(MAX77836_INTSRC_MASK_TOP_INT_SHIFT)
+#define MAX77836_INTSRC_MASK_MUIC_CHG_INT_MASK	BIT(MAX77836_INTSRC_MASK_MUIC_CHG_INT_SHIFT)
+
+/* MAX77836 PMIC interrupts */
+#define MAX77836_TOPSYS_INT_T120C_SHIFT		0
+#define MAX77836_TOPSYS_INT_T140C_SHIFT		1
+#define MAX77836_TOPSYS_INT_T120C_MASK		BIT(MAX77836_TOPSYS_INT_T120C_SHIFT)
+#define MAX77836_TOPSYS_INT_T140C_MASK		BIT(MAX77836_TOPSYS_INT_T140C_SHIFT)
+
+/* Slave addr = 0x6C: Fuel-Gauge/Battery */
+enum max77836_fg_reg {
+	MAX77836_FG_REG_VCELL_MSB	= 0x02,
+	MAX77836_FG_REG_VCELL_LSB	= 0x03,
+	MAX77836_FG_REG_SOC_MSB		= 0x04,
+	MAX77836_FG_REG_SOC_LSB		= 0x05,
+	MAX77836_FG_REG_MODE_H		= 0x06,
+	MAX77836_FG_REG_MODE_L		= 0x07,
+	MAX77836_FG_REG_VERSION_MSB	= 0x08,
+	MAX77836_FG_REG_VERSION_LSB	= 0x09,
+	MAX77836_FG_REG_HIBRT_H		= 0x0A,
+	MAX77836_FG_REG_HIBRT_L		= 0x0B,
+	MAX77836_FG_REG_CONFIG_H	= 0x0C,
+	MAX77836_FG_REG_CONFIG_L	= 0x0D,
+	MAX77836_FG_REG_VALRT_MIN	= 0x14,
+	MAX77836_FG_REG_VALRT_MAX	= 0x15,
+	MAX77836_FG_REG_CRATE_MSB	= 0x16,
+	MAX77836_FG_REG_CRATE_LSB	= 0x17,
+	MAX77836_FG_REG_VRESET		= 0x18,
+	MAX77836_FG_REG_FGID		= 0x19,
+	MAX77836_FG_REG_STATUS_H	= 0x1A,
+	MAX77836_FG_REG_STATUS_L	= 0x1B,
+	/*
+	 * TODO: TABLE registers
+	 * TODO: CMD register
+	 */
+
+	MAX77836_FG_REG_END,
+};
+
 enum max14577_irq {
 	/* INT1 */
 	MAX14577_IRQ_INT1_ADC,
@@ -272,17 +346,24 @@ enum max14577_irq {
 	MAX14577_IRQ_INT3_OVP,
 	MAX14577_IRQ_INT3_MBCCHGERR,
 
+	/* TOPSYS_INT, only MAX77836 */
+	MAX77836_IRQ_TOPSYS_T140C,
+	MAX77836_IRQ_TOPSYS_T120C,
+
 	MAX14577_IRQ_NUM,
 };
 
 struct max14577 {
 	struct device *dev;
 	struct i2c_client *i2c; /* Slave addr = 0x4A */
+	struct i2c_client *i2c_pmic; /* Slave addr = 0x46 */
 	enum maxim_device_type dev_type;
 
-	struct regmap *regmap;
+	struct regmap *regmap; /* For MUIC and Charger */
+	struct regmap *regmap_pmic;
 
-	struct regmap_irq_chip_data *irq_data;
+	struct regmap_irq_chip_data *irq_data; /* For MUIC and Charger */
+	struct regmap_irq_chip_data *irq_data_pmic;
 	int irq;
 };
 
diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
index 736d39c3ec0d..08b449159fd1 100644
--- a/include/linux/mfd/max14577.h
+++ b/include/linux/mfd/max14577.h
@@ -1,7 +1,7 @@
 /*
- * max14577.h - Driver for the Maxim 14577
+ * max14577.h - Driver for the Maxim 14577/77836
  *
- * Copyright (C) 2013 Samsung Electrnoics
+ * Copyright (C) 2014 Samsung Electrnoics
  * Chanwoo Choi <cw00.choi@samsung.com>
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
@@ -20,6 +20,9 @@
  * MAX14577 has MUIC, Charger devices.
  * The devices share the same I2C bus and interrupt line
  * included in this mfd driver.
+ *
+ * MAX77836 has additional PMIC and Fuel-Gauge on different I2C slave
+ * addresses.
  */
 
 #ifndef __MAX14577_H__
-- 
1.8.3.2

