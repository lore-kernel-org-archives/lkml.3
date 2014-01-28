Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaA1MUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:20:31 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20320 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaA1MTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:12 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-6b-52e7a03c84e5
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 13/18] mfd: max77836: Add max77836 support to max14577 driver
Date: Tue, 28 Jan 2014 13:18:37 +0100
Message-id: <1390911522-28209-14-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xa7o2C54HGfz+J28x9eETNovrX56z
	Wrx+YWhxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CzWHrnLbnG7cQWbxeluVgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6M1hlv2Qv+djJW
	3N+2hLGBcV9RFyMnh4SAicSig78YIWwxiQv31rN1MXJxCAksZZS4dGI3K4TTxyTxdcFtsCo2
	AWOJzcuXgFWJCKxmklizYCoLSIJZoJdR4uZuDxBbWMBX4m3LbSYQm0VAVWLveYgaXgEPietP
	rgHZHEDrFCTmTLIBCXMChV9dbQQrFxJwlzh1/B3LBEbeBYwMqxhFU0uTC4qT0nMN9YoTc4tL
	89L1kvNzNzFCgvHLDsbFx6wOMQpwMCrx8HZ0PgsSYk0sK67MPcQowcGsJMKbOPt5kBBvSmJl
	VWpRfnxRaU5q8SFGJg5OqQbG7u2x01b7Fak3JP17+fry3b6q2awJMzZxy2Wc154xmaNkvplv
	0fK4063cOY8OnpkeJyGSFXdg5v0rfGsv7ptonbbTX2fa7CkFokFizUl3DSd0OxvXTrjwpkzT
	Xin2VNCppwkpm5You0SbSgZuqXbXe5e3nkNANsK3dR1b03ZLSwY1i8B0jvVKLMUZiYZazEXF
	iQDxCAKyJAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Maxim 77836 support to max14577 driver. The chipsets have same MUIC
component so the extcon, charger and regulators are almost the same. The
max77836 however has also PMIC and Fuel Gauge.

The MAX77836 uses three I2C slave addresses and has additional interrupts
(related to PMIC and Fuel Gauge). It has also Interrupt Source register,
just like MAX77686 and MAX77693.

The MAX77836 PMIC's TOPSYS and INTSRC interrupts are reported in the
PMIC block. The PMIC block has different I2C slave address and uses own
regmap so another regmap_irq_chip is needed.

Since we have two regmap_irq_chip, use shared interrupts on MAX77836.

This patch adds additional defines and functions to the max14577 MFD core
driver so the driver will handle both chipsets.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mfd/max14577.c               |  215 ++++++++++++++++++++++++++++++++--
 include/linux/mfd/max14577-private.h |   85 +++++++++++++-
 include/linux/mfd/max14577.h         |    7 +-
 3 files changed, 296 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 224aba8c5b3f..5b10f6f89834 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -1,7 +1,7 @@
 /*
- * max14577.c - mfd core driver for the Maxim 14577
+ * max14577.c - mfd core driver for the Maxim 14577/77836
  *
- * Copyright (C) 2013 Samsung Electrnoics
+ * Copyright (C) 2013,2014 Samsung Electrnoics
  * Chanwoo Choi <cw00.choi@samsung.com>
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
@@ -37,11 +37,31 @@ static struct mfd_cell max14577_devs[] = {
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
+	{ .name = "max77836-charger", },
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
 
@@ -56,6 +76,29 @@ static bool max14577_muic_volatile_reg(struct device *dev, unsigned int reg)
 	return false;
 }
 
+static bool max77836_muic_volatile_reg(struct device *dev, unsigned int reg)
+{
+	/* Any max14577 volatile registers are also max77836 volatile. */
+	if (max14577_muic_volatile_reg(dev, reg))
+		return true;
+	switch (reg) {
+	case MAX77836_FG_REG_VCELL_MSB ... MAX77836_FG_REG_SOC_LSB:
+	case MAX77836_FG_REG_CRATE_MSB ... MAX77836_FG_REG_CRATE_LSB:
+	case MAX77836_FG_REG_STATUS_H ... MAX77836_FG_REG_STATUS_L:
+		/* fall through */
+	case MAX77836_PMIC_REG_INTSRC:
+		/* fall through */
+	case MAX77836_PMIC_REG_TOPSYS_INT:
+		/* fall through */
+	case MAX77836_PMIC_REG_TOPSYS_STAT:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+
 static const struct regmap_config max14577_muic_regmap_config = {
 	.reg_bits	= 8,
 	.val_bits	= 8,
@@ -63,6 +106,13 @@ static const struct regmap_config max14577_muic_regmap_config = {
 	.max_register	= MAXIM_MUIC_REG_END,
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
 	{ .reg_offset = 0, .mask = MAXIM_INT1_ADC_MASK, },
@@ -91,6 +141,50 @@ static const struct regmap_irq_chip max14577_irq_chip = {
 	.num_irqs		= ARRAY_SIZE(max14577_irqs),
 };
 
+static const struct regmap_irq max77836_muic_irqs[] = {
+	/* INT1 interrupts */
+	{ .reg_offset = 0, .mask = MAXIM_INT1_ADC_MASK, },
+	{ .reg_offset = 0, .mask = MAXIM_INT1_ADCLOW_MASK, },
+	{ .reg_offset = 0, .mask = MAXIM_INT1_ADCERR_MASK, },
+	/* INT2 interrupts */
+	{ .reg_offset = 1, .mask = MAXIM_INT2_CHGTYP_MASK, },
+	{ .reg_offset = 1, .mask = MAXIM_INT2_CHGDETRUN_MASK, },
+	{ .reg_offset = 1, .mask = MAXIM_INT2_DCDTMR_MASK, },
+	{ .reg_offset = 1, .mask = MAXIM_INT2_DBCHG_MASK, },
+	{ .reg_offset = 1, .mask = MAXIM_INT2_VBVOLT_MASK, },
+	{ .reg_offset = 1, .mask = MAX77836_INT2_VIDRM_MASK, },
+	/* INT3 interrupts */
+	{ .reg_offset = 2, .mask = MAXIM_INT3_EOC_MASK, },
+	{ .reg_offset = 2, .mask = MAXIM_INT3_CGMBC_MASK, },
+	{ .reg_offset = 2, .mask = MAXIM_INT3_OVP_MASK, },
+	{ .reg_offset = 2, .mask = MAXIM_INT3_MBCCHGERR_MASK, },
+};
+
+static const struct regmap_irq_chip max77836_muic_irq_chip = {
+	.name			= "max77836-muic",
+	.status_base		= MAXIM_MUIC_REG_INT1,
+	.mask_base		= MAXIM_MUIC_REG_INTMASK1,
+	.mask_invert		= 1,
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
+	.mask_invert		= 0,
+	.num_regs		= 1,
+	.irqs			= max77836_pmic_irqs,
+	.num_irqs		= ARRAY_SIZE(max77836_pmic_irqs),
+};
+
 static void max14577_print_dev_type(struct maxim_core *maxim_core)
 {
 	u8 reg_data, vendor_id, device_id;
@@ -111,6 +205,81 @@ static void max14577_print_dev_type(struct maxim_core *maxim_core)
 			maxim_core->dev_type, device_id, vendor_id);
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
+static int max77836_init(struct maxim_core *maxim_core)
+{
+	int ret;
+	u8 intsrc_mask;
+
+	maxim_core->i2c_pmic = i2c_new_dummy(maxim_core->i2c->adapter,
+			I2C_ADDR_PMIC);
+	if (!maxim_core->i2c_pmic) {
+		dev_err(maxim_core->dev, "Failed to register PMIC I2C device\n");
+		return -EPERM;
+	}
+	i2c_set_clientdata(maxim_core->i2c_pmic, maxim_core);
+
+	maxim_core->regmap_pmic = devm_regmap_init_i2c(maxim_core->i2c_pmic,
+			&max77836_pmic_regmap_config);
+	if (IS_ERR(maxim_core->regmap_pmic)) {
+		ret = PTR_ERR(maxim_core->regmap_pmic);
+		dev_err(maxim_core->dev, "Failed to allocate PMIC register map: %d\n",
+				ret);
+		goto err;
+	}
+
+	/* Un-mask MAX77836 Interrupt Source register */
+	ret = max14577_read_reg(maxim_core->regmap_pmic,
+			MAX77836_PMIC_REG_INTSRC_MASK, &intsrc_mask);
+	if (ret < 0) {
+		dev_err(maxim_core->dev, "Failed to read PMIC register\n");
+		goto err;
+	}
+
+	intsrc_mask &= ~(MAX77836_INTSRC_MASK_TOP_INT_MASK);
+	intsrc_mask &= ~(MAX77836_INTSRC_MASK_MUIC_CHG_INT_MASK);
+	ret = max14577_write_reg(maxim_core->regmap_pmic,
+			MAX77836_PMIC_REG_INTSRC_MASK, intsrc_mask);
+	if (ret < 0) {
+		dev_err(maxim_core->dev, "Failed to write PMIC register\n");
+		goto err;
+	}
+
+	ret = regmap_add_irq_chip(maxim_core->regmap_pmic, maxim_core->irq,
+			IRQF_TRIGGER_FALLING | IRQF_ONESHOT | IRQF_SHARED,
+			0, &max77836_pmic_irq_chip,
+			&maxim_core->irq_data_pmic);
+	if (ret != 0) {
+		dev_err(maxim_core->dev, "Failed to request PMIC IRQ %d: %d\n",
+				maxim_core->irq, ret);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	i2c_unregister_device(maxim_core->i2c_pmic);
+
+	return ret;
+}
+
+/*
+ * Max77836 specific de-initialization code for driver remove.
+ */
+static void max77836_remove(struct maxim_core *maxim_core)
+{
+	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data_pmic);
+	i2c_unregister_device(maxim_core->i2c_pmic);
+}
+
 static int max14577_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
@@ -118,6 +287,10 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	struct max14577_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct device_node *np = i2c->dev.of_node;
 	int ret = 0;
+	const struct regmap_irq_chip *irq_chip;
+	struct mfd_cell *mfd_devs;
+	unsigned int mfd_devs_size;
+	int irq_flags;
 
 	if (np) {
 		pdata = devm_kzalloc(&i2c->dev, sizeof(*pdata), GFP_KERNEL);
@@ -160,9 +333,24 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 
 	max14577_print_dev_type(maxim_core);
 
+	switch (maxim_core->dev_type) {
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
 	ret = regmap_add_irq_chip(maxim_core->regmap_muic, maxim_core->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT, 0,
-				  &max14577_irq_chip,
+				  irq_flags, 0, irq_chip,
 				  &maxim_core->irq_data_muic);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
@@ -170,8 +358,15 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	ret = mfd_add_devices(maxim_core->dev, -1, max14577_devs,
-			ARRAY_SIZE(max14577_devs), NULL, 0,
+	/* Max77836 specific initialization code (additional regmap) */
+	if (maxim_core->dev_type == MAXIM_DEVICE_TYPE_MAX77836) {
+		ret = max77836_init(maxim_core);
+		if (ret < 0)
+			goto err_max77836;
+	}
+
+	ret = mfd_add_devices(maxim_core->dev, -1, mfd_devs,
+			mfd_devs_size, NULL, 0,
 			regmap_irq_get_domain(maxim_core->irq_data_muic));
 	if (ret < 0)
 		goto err_mfd;
@@ -181,6 +376,9 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	return 0;
 
 err_mfd:
+	if (maxim_core->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
+		max77836_remove(maxim_core);
+err_max77836:
 	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data_muic);
 
 	return ret;
@@ -192,12 +390,15 @@ static int max14577_i2c_remove(struct i2c_client *i2c)
 
 	mfd_remove_devices(maxim_core->dev);
 	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data_muic);
+	if (maxim_core->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
+		max77836_remove(maxim_core);
 
 	return 0;
 }
 
 static const struct i2c_device_id max14577_i2c_id[] = {
 	{ "max14577", MAXIM_DEVICE_TYPE_MAX14577, },
+	{ "max77836", MAXIM_DEVICE_TYPE_MAX77836, },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
@@ -268,5 +469,5 @@ static void __exit max14577_i2c_exit(void)
 module_exit(max14577_i2c_exit);
 
 MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>");
-MODULE_DESCRIPTION("MAXIM 14577 multi-function core driver");
+MODULE_DESCRIPTION("Maxim 14577/77836 multi-function core driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 814bf013d3e8..e0dd27d937d6 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -1,7 +1,7 @@
 /*
- * max14577-private.h - Common API for the Maxim 14577 internal sub chip
+ * max14577-private.h - Common API for the Maxim 14577/77836 internal sub chip
  *
- * Copyright (C) 2013 Samsung Electrnoics
+ * Copyright (C) 2013,2014 Samsung Electrnoics
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
@@ -78,6 +83,7 @@ enum maxim_muic_charger_type {
 #define MAXIM_INT2_DCDTMR_MASK			(0x1 << 2)
 #define MAXIM_INT2_DBCHG_MASK			(0x1 << 3)
 #define MAXIM_INT2_VBVOLT_MASK			(0x1 << 4)
+#define MAX77836_INT2_VIDRM_MASK		(0x1 << 5)
 
 #define MAXIM_INT3_EOC_MASK			(0x1 << 0)
 #define MAXIM_INT3_CGMBC_MASK			(0x1 << 1)
@@ -94,9 +100,11 @@ enum maxim_muic_charger_type {
 #define MAXIM_STATUS1_ADC_SHIFT		0
 #define MAXIM_STATUS1_ADCLOW_SHIFT	5
 #define MAXIM_STATUS1_ADCERR_SHIFT	6
+#define MAX77836_STATUS1_ADC1K_SHIFT	7
 #define MAXIM_STATUS1_ADC_MASK		(0x1f << MAXIM_STATUS1_ADC_SHIFT)
 #define MAXIM_STATUS1_ADCLOW_MASK	(0x1 << MAXIM_STATUS1_ADCLOW_SHIFT)
 #define MAXIM_STATUS1_ADCERR_MASK	(0x1 << MAXIM_STATUS1_ADCERR_SHIFT)
+#define MAX77836_STATUS1_ADC1K_MASK	(0x1 << MAX77836_STATUS1_ADC1K_SHIFT)
 
 /* MAX14577 STATUS2 register */
 #define MAXIM_STATUS2_CHGTYP_SHIFT	0
@@ -104,11 +112,13 @@ enum maxim_muic_charger_type {
 #define MAXIM_STATUS2_DCDTMR_SHIFT	4
 #define MAXIM_STATUS2_DBCHG_SHIFT	5
 #define MAXIM_STATUS2_VBVOLT_SHIFT	6
+#define MAX77836_STATUS2_VIDRM_SHIFT	7
 #define MAXIM_STATUS2_CHGTYP_MASK	(0x7 << MAXIM_STATUS2_CHGTYP_SHIFT)
 #define MAXIM_STATUS2_CHGDETRUN_MASK	(0x1 << MAXIM_STATUS2_CHGDETRUN_SHIFT)
 #define MAXIM_STATUS2_DCDTMR_MASK	(0x1 << MAXIM_STATUS2_DCDTMR_SHIFT)
 #define MAXIM_STATUS2_DBCHG_MASK	(0x1 << MAXIM_STATUS2_DBCHG_SHIFT)
 #define MAXIM_STATUS2_VBVOLT_MASK	(0x1 << MAXIM_STATUS2_VBVOLT_SHIFT)
+#define MAX77836_STATUS2_VIDRM_MASK	(0x1 << MAX77836_STATUS2_VIDRM_SHIFT)
 
 /* MAX14577 STATUS3 register */
 #define MAXIM_STATUS3_EOC_SHIFT		0
@@ -232,6 +242,70 @@ enum maxim_muic_charger_type {
 
 
 
+/* Slave addr = 0x46: PMIC */
+enum max77836_pmic_reg {
+	MAX77836_COMP_REG_COMP1			= 0x60,
+
+	MAX77836_LDO_REG_CNFG1_LDO1		= 0x51,
+	MAX77836_LDO_REG_CNFG2_LDO1		= 0x52,
+	MAX77836_LDO_REG_CNFG1_LDO2		= 0x53,
+	MAX77836_LDO_REG_CNFG2_LDO2		= 0x54,
+	MAX77836_LDO_REG_CNFG_LDO_BIAS		= 0x55,
+
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
+	MAX77836_PMIC_REG_END,
+};
+
+#define MAX77836_INTSRC_MASK_TOP_INT_SHIFT	1
+#define MAX77836_INTSRC_MASK_MUIC_CHG_INT_SHIFT	3
+#define MAX77836_INTSRC_MASK_TOP_INT_MASK	(0x1 << MAX77836_INTSRC_MASK_TOP_INT_SHIFT)
+#define MAX77836_INTSRC_MASK_MUIC_CHG_INT_MASK	(0x1 << MAX77836_INTSRC_MASK_MUIC_CHG_INT_SHIFT)
+
+/* MAX77836 PMIC interrupts */
+#define MAX77836_TOPSYS_INT_T120C_SHIFT		0
+#define MAX77836_TOPSYS_INT_T140C_SHIFT		1
+#define MAX77836_TOPSYS_INT_T120C_MASK		(0x1 << MAX77836_TOPSYS_INT_T120C_SHIFT)
+#define MAX77836_TOPSYS_INT_T140C_MASK		(0x1 << MAX77836_TOPSYS_INT_T140C_SHIFT)
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
 enum maxim_irq {
 	/* INT1 */
 	MAXIM_IRQ_INT1_ADC,
@@ -251,6 +325,10 @@ enum maxim_irq {
 	MAXIM_IRQ_INT3_OVP,
 	MAXIM_IRQ_INT3_MBCCHGERR,
 
+	/* TOPSYS_INT */
+	MAXIM_IRQ_TOPSYS_T140C,
+	MAXIM_IRQ_TOPSYS_T120C,
+
 	MAXIM_IRQ_NUM,
 };
 
@@ -260,11 +338,14 @@ enum maxim_irq {
 struct maxim_core {
 	struct device *dev;
 	struct i2c_client *i2c; /* Slave addr = 0x4A */
+	struct i2c_client *i2c_pmic; /* Slave addr = 0x46 */
 	enum maxim_device_type dev_type;
 
 	struct regmap *regmap_muic;
+	struct regmap *regmap_pmic;
 
 	struct regmap_irq_chip_data *irq_data_muic;
+	struct regmap_irq_chip_data *irq_data_pmic;
 	int irq;
 };
 
diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
index 75301be5c548..5e5fc77db977 100644
--- a/include/linux/mfd/max14577.h
+++ b/include/linux/mfd/max14577.h
@@ -1,7 +1,7 @@
 /*
- * max14577.h - Driver for the Maxim 14577
+ * max14577.h - Driver for the Maxim 14577/77836
  *
- * Copyright (C) 2013 Samsung Electrnoics
+ * Copyright (C) 2013,2014 Samsung Electrnoics
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
1.7.9.5

