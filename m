Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaBXKPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:15:49 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64032 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaBXKLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:11:22 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-4f-530b1ac513bf
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 08/16] mfd: max77836: Add max77836 support to max14577 driver
Date: Mon, 24 Feb 2014 11:10:33 +0100
Message-id: <1393236641-14977-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t/xy7pHpbiDDRbu47LYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJbnO5mtVg/
	4zWLA6/Hzll32T02r9Dy2LSqk83jzrU9bB7zTgZ6bF5S79G3ZRWjx+dNcgEcUVw2Kak5mWWp
	Rfp2CVwZHc8zC+YfYaz4vuMJawPj12WMXYycHBICJhLXPl2EssUkLtxbzwZiCwksZZRYfrUS
	wu5jklhw3APEZhMwlti8fAlQDReHiMAWJoneD18YQRxmgeeMEh8XzWQHqRIWCJBYdfINM4jN
	IqAq8W3NQlYQm1fAXeL0q7lANgfQNgWJOZNsQMKcAh4Sd1sesEIsc5f4Nu86ywRG3gWMDKsY
	RVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQsL0yw7GxcesDjEKcDAq8fBKVHMFC7EmlhVX5h5i
	lOBgVhLhNePlDhbiTUmsrEotyo8vKs1JLT7EyMTBKdXAyGp0fL7qCbd/0/9w6Fca/vYq3/i+
	1Uq1dN3yUmuxwOmHHCJj30iVe2hV/eZzPhSlP2l+vb/qe8MN2zf/u7uYt9agxatg3t/Z3duF
	wt44a20NVRR/LnOg8dA9uaj4yq+G6ccf/TnMOWvNQvHtx40uLi/Ksjtt2N4tmX3xbvbO8jV7
	1Rrjj7zkVmIpzkg01GIuKk4EAJZP22oxAgAA
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
driver so the driver will handle both chipsets. Also this patch replaces
"0x1 << N" with BIT(N) in defines for register masks.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max14577.c               |  217 ++++++++++++++++++++++++++++++++--
 include/linux/mfd/max14577-private.h |  175 +++++++++++++++++++--------
 include/linux/mfd/max14577.h         |    7 +-
 3 files changed, 341 insertions(+), 58 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 3a3530814d9c..e5cbefed5f5f 100644
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
@@ -37,11 +37,34 @@ static struct mfd_cell max14577_devs[] = {
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
 
@@ -56,6 +79,26 @@ static bool max14577_muic_volatile_reg(struct device *dev, unsigned int reg)
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
@@ -85,12 +135,56 @@ static const struct regmap_irq_chip max14577_irq_chip = {
 	.name			= "max14577",
 	.status_base		= MAXIM_MUIC_REG_INT1,
 	.mask_base		= MAXIM_MUIC_REG_INTMASK1,
-	.mask_invert		= 1,
+	.mask_invert		= true,
 	.num_regs		= 3,
 	.irqs			= max14577_irqs,
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
 static void max14577_print_dev_type(struct maxim_core *maxim_core)
 {
 	u8 reg_data, vendor_id, device_id;
@@ -113,6 +207,81 @@ static void max14577_print_dev_type(struct maxim_core *maxim_core)
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
+		return -ENODEV;
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
@@ -120,6 +289,10 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	struct max14577_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct device_node *np = i2c->dev.of_node;
 	int ret = 0;
+	const struct regmap_irq_chip *irq_chip;
+	struct mfd_cell *mfd_devs;
+	unsigned int mfd_devs_size;
+	int irq_flags;
 
 	if (np) {
 		pdata = devm_kzalloc(&i2c->dev, sizeof(*pdata), GFP_KERNEL);
@@ -163,9 +336,24 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 
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
@@ -173,8 +361,15 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
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
@@ -184,6 +379,9 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	return 0;
 
 err_mfd:
+	if (maxim_core->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
+		max77836_remove(maxim_core);
+err_max77836:
 	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data_muic);
 
 	return ret;
@@ -195,12 +393,15 @@ static int max14577_i2c_remove(struct i2c_client *i2c)
 
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
@@ -273,5 +474,5 @@ static void __exit max14577_i2c_exit(void)
 module_exit(max14577_i2c_exit);
 
 MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>");
-MODULE_DESCRIPTION("MAXIM 14577 multi-function core driver");
+MODULE_DESCRIPTION("Maxim 14577/77836 multi-function core driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index afa4e525f9b7..472d5780ca50 100644
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
@@ -69,20 +74,21 @@ enum maxim_muic_charger_type {
 };
 
 /* MAX14577 interrupts */
-#define MAXIM_INT1_ADC_MASK			(0x1 << 0)
-#define MAXIM_INT1_ADCLOW_MASK			(0x1 << 1)
-#define MAXIM_INT1_ADCERR_MASK			(0x1 << 2)
-
-#define MAXIM_INT2_CHGTYP_MASK			(0x1 << 0)
-#define MAXIM_INT2_CHGDETRUN_MASK		(0x1 << 1)
-#define MAXIM_INT2_DCDTMR_MASK			(0x1 << 2)
-#define MAXIM_INT2_DBCHG_MASK			(0x1 << 3)
-#define MAXIM_INT2_VBVOLT_MASK			(0x1 << 4)
-
-#define MAXIM_INT3_EOC_MASK			(0x1 << 0)
-#define MAXIM_INT3_CGMBC_MASK			(0x1 << 1)
-#define MAXIM_INT3_OVP_MASK			(0x1 << 2)
-#define MAXIM_INT3_MBCCHGERR_MASK		(0x1 << 3)
+#define MAXIM_INT1_ADC_MASK		BIT(0)
+#define MAXIM_INT1_ADCLOW_MASK		BIT(1)
+#define MAXIM_INT1_ADCERR_MASK		BIT(2)
+
+#define MAXIM_INT2_CHGTYP_MASK		BIT(0)
+#define MAXIM_INT2_CHGDETRUN_MASK	BIT(1)
+#define MAXIM_INT2_DCDTMR_MASK		BIT(2)
+#define MAXIM_INT2_DBCHG_MASK		BIT(3)
+#define MAXIM_INT2_VBVOLT_MASK		BIT(4)
+#define MAX77836_INT2_VIDRM_MASK	BIT(5)
+
+#define MAXIM_INT3_EOC_MASK		BIT(0)
+#define MAXIM_INT3_CGMBC_MASK		BIT(1)
+#define MAXIM_INT3_OVP_MASK		BIT(2)
+#define MAXIM_INT3_MBCCHGERR_MASK	BIT(3)
 
 /* MAX14577 DEVICE ID register */
 #define MAXIM_DEVID_VENDORID_SHIFT	0
@@ -94,9 +100,11 @@ enum maxim_muic_charger_type {
 #define MAXIM_STATUS1_ADC_SHIFT		0
 #define MAXIM_STATUS1_ADCLOW_SHIFT	5
 #define MAXIM_STATUS1_ADCERR_SHIFT	6
+#define MAX77836_STATUS1_ADC1K_SHIFT	7
 #define MAXIM_STATUS1_ADC_MASK		(0x1f << MAXIM_STATUS1_ADC_SHIFT)
-#define MAXIM_STATUS1_ADCLOW_MASK	(0x1 << MAXIM_STATUS1_ADCLOW_SHIFT)
-#define MAXIM_STATUS1_ADCERR_MASK	(0x1 << MAXIM_STATUS1_ADCERR_SHIFT)
+#define MAXIM_STATUS1_ADCLOW_MASK	BIT(MAXIM_STATUS1_ADCLOW_SHIFT)
+#define MAXIM_STATUS1_ADCERR_MASK	BIT(MAXIM_STATUS1_ADCERR_SHIFT)
+#define MAX77836_STATUS1_ADC1K_MASK	BIT(MAX77836_STATUS1_ADC1K_SHIFT)
 
 /* MAX14577 STATUS2 register */
 #define MAXIM_STATUS2_CHGTYP_SHIFT	0
@@ -104,21 +112,23 @@ enum maxim_muic_charger_type {
 #define MAXIM_STATUS2_DCDTMR_SHIFT	4
 #define MAXIM_STATUS2_DBCHG_SHIFT	5
 #define MAXIM_STATUS2_VBVOLT_SHIFT	6
+#define MAX77836_STATUS2_VIDRM_SHIFT	7
 #define MAXIM_STATUS2_CHGTYP_MASK	(0x7 << MAXIM_STATUS2_CHGTYP_SHIFT)
-#define MAXIM_STATUS2_CHGDETRUN_MASK	(0x1 << MAXIM_STATUS2_CHGDETRUN_SHIFT)
-#define MAXIM_STATUS2_DCDTMR_MASK	(0x1 << MAXIM_STATUS2_DCDTMR_SHIFT)
-#define MAXIM_STATUS2_DBCHG_MASK	(0x1 << MAXIM_STATUS2_DBCHG_SHIFT)
-#define MAXIM_STATUS2_VBVOLT_MASK	(0x1 << MAXIM_STATUS2_VBVOLT_SHIFT)
+#define MAXIM_STATUS2_CHGDETRUN_MASK	BIT(MAXIM_STATUS2_CHGDETRUN_SHIFT)
+#define MAXIM_STATUS2_DCDTMR_MASK	BIT(MAXIM_STATUS2_DCDTMR_SHIFT)
+#define MAXIM_STATUS2_DBCHG_MASK	BIT(MAXIM_STATUS2_DBCHG_SHIFT)
+#define MAXIM_STATUS2_VBVOLT_MASK	BIT(MAXIM_STATUS2_VBVOLT_SHIFT)
+#define MAX77836_STATUS2_VIDRM_MASK	BIT(MAX77836_STATUS2_VIDRM_SHIFT)
 
 /* MAX14577 STATUS3 register */
 #define MAXIM_STATUS3_EOC_SHIFT		0
 #define MAXIM_STATUS3_CGMBC_SHIFT	1
 #define MAXIM_STATUS3_OVP_SHIFT		2
 #define MAXIM_STATUS3_MBCCHGERR_SHIFT	3
-#define MAXIM_STATUS3_EOC_MASK		(0x1 << MAXIM_STATUS3_EOC_SHIFT)
-#define MAXIM_STATUS3_CGMBC_MASK	(0x1 << MAXIM_STATUS3_CGMBC_SHIFT)
-#define MAXIM_STATUS3_OVP_MASK		(0x1 << MAXIM_STATUS3_OVP_SHIFT)
-#define MAXIM_STATUS3_MBCCHGERR_MASK	(0x1 << MAXIM_STATUS3_MBCCHGERR_SHIFT)
+#define MAXIM_STATUS3_EOC_MASK		BIT(MAXIM_STATUS3_EOC_SHIFT)
+#define MAXIM_STATUS3_CGMBC_MASK	BIT(MAXIM_STATUS3_CGMBC_SHIFT)
+#define MAXIM_STATUS3_OVP_MASK		BIT(MAXIM_STATUS3_OVP_SHIFT)
+#define MAXIM_STATUS3_MBCCHGERR_MASK	BIT(MAXIM_STATUS3_MBCCHGERR_SHIFT)
 
 /* MAX14577 CONTROL1 register */
 #define MAXIM_CONTROL1_COMN1SW_SHIFT	0
@@ -127,8 +137,8 @@ enum maxim_muic_charger_type {
 #define MAXIM_CONTROL1_IDBEN_SHIFT	7
 #define MAXIM_CONTROL1_COMN1SW_MASK	(0x7 << MAXIM_CONTROL1_COMN1SW_SHIFT)
 #define MAXIM_CONTROL1_COMP2SW_MASK	(0x7 << MAXIM_CONTROL1_COMP2SW_SHIFT)
-#define MAXIM_CONTROL1_MICEN_MASK	(0x1 << MAXIM_CONTROL1_MICEN_SHIFT)
-#define MAXIM_CONTROL1_IDBEN_MASK	(0x1 << MAXIM_CONTROL1_IDBEN_SHIFT)
+#define MAXIM_CONTROL1_MICEN_MASK	BIT(MAXIM_CONTROL1_MICEN_SHIFT)
+#define MAXIM_CONTROL1_IDBEN_MASK	BIT(MAXIM_CONTROL1_IDBEN_SHIFT)
 
 #define MAXIM_CONTROL1_CLEAR_IDBEN_MICEN_MASK	(MAXIM_CONTROL1_COMN1SW_MASK | MAXIM_CONTROL1_COMP2SW_MASK)
 #define MAXIM_CONTROL1_SW_USB		((1 << MAXIM_CONTROL1_COMP2SW_SHIFT) \
@@ -149,14 +159,14 @@ enum maxim_muic_charger_type {
 #define MAXIM_CONTROL2_ACCDET_SHIFT	5
 #define MAXIM_CONTROL2_USBCPINT_SHIFT	6
 #define MAXIM_CONTROL2_RCPS_SHIFT	7
-#define MAXIM_CONTROL2_LOWPWR_MASK	(0x1 << MAXIM_CONTROL2_LOWPWR_SHIFT)
-#define MAXIM_CONTROL2_ADCEN_MASK	(0x1 << MAXIM_CONTROL2_ADCEN_SHIFT)
-#define MAXIM_CONTROL2_CPEN_MASK	(0x1 << MAXIM_CONTROL2_CPEN_SHIFT)
-#define MAXIM_CONTROL2_SFOUTASRT_MASK	(0x1 << MAXIM_CONTROL2_SFOUTASRT_SHIFT)
-#define MAXIM_CONTROL2_SFOUTORD_MASK	(0x1 << MAXIM_CONTROL2_SFOUTORD_SHIFT)
-#define MAXIM_CONTROL2_ACCDET_MASK	(0x1 << MAXIM_CONTROL2_ACCDET_SHIFT)
-#define MAXIM_CONTROL2_USBCPINT_MASK	(0x1 << MAXIM_CONTROL2_USBCPINT_SHIFT)
-#define MAXIM_CONTROL2_RCPS_MASK	(0x1 << MAXIM_CONTROL2_RCPS_SHIFT)
+#define MAXIM_CONTROL2_LOWPWR_MASK	BIT(MAXIM_CONTROL2_LOWPWR_SHIFT)
+#define MAXIM_CONTROL2_ADCEN_MASK	BIT(MAXIM_CONTROL2_ADCEN_SHIFT)
+#define MAXIM_CONTROL2_CPEN_MASK	BIT(MAXIM_CONTROL2_CPEN_SHIFT)
+#define MAXIM_CONTROL2_SFOUTASRT_MASK	BIT(MAXIM_CONTROL2_SFOUTASRT_SHIFT)
+#define MAXIM_CONTROL2_SFOUTORD_MASK	BIT(MAXIM_CONTROL2_SFOUTORD_SHIFT)
+#define MAXIM_CONTROL2_ACCDET_MASK	BIT(MAXIM_CONTROL2_ACCDET_SHIFT)
+#define MAXIM_CONTROL2_USBCPINT_MASK	BIT(MAXIM_CONTROL2_USBCPINT_SHIFT)
+#define MAXIM_CONTROL2_RCPS_MASK	BIT(MAXIM_CONTROL2_RCPS_SHIFT)
 
 #define MAXIM_CONTROL2_CPEN1_LOWPWR0	((1 << MAXIM_CONTROL2_CPEN_SHIFT) | \
 					(0 << MAXIM_CONTROL2_LOWPWR_SHIFT))
@@ -180,14 +190,14 @@ enum maxim_muic_charger_type {
 #define MAXIM_CDETCTRL1_DBEXIT_SHIFT	5
 #define MAXIM_CDETCTRL1_DBIDLE_SHIFT	6
 #define MAXIM_CDETCTRL1_CDPDET_SHIFT	7
-#define MAXIM_CDETCTRL1_CHGDETEN_MASK	(0x1 << MAXIM_CDETCTRL1_CHGDETEN_SHIFT)
-#define MAXIM_CDETCTRL1_CHGTYPMAN_MASK	(0x1 << MAXIM_CDETCTRL1_CHGTYPMAN_SHIFT)
-#define MAXIM_CDETCTRL1_DCDEN_MASK	(0x1 << MAXIM_CDETCTRL1_DCDEN_SHIFT)
-#define MAXIM_CDETCTRL1_DCD2SCT_MASK	(0x1 << MAXIM_CDETCTRL1_DCD2SCT_SHIFT)
-#define MAXIM_CDETCTRL1_DCHKTM_MASK	(0x1 << MAXIM_CDETCTRL1_DCHKTM_SHIFT)
-#define MAXIM_CDETCTRL1_DBEXIT_MASK	(0x1 << MAXIM_CDETCTRL1_DBEXIT_SHIFT)
-#define MAXIM_CDETCTRL1_DBIDLE_MASK	(0x1 << MAXIM_CDETCTRL1_DBIDLE_SHIFT)
-#define MAXIM_CDETCTRL1_CDPDET_MASK	(0x1 << MAXIM_CDETCTRL1_CDPDET_SHIFT)
+#define MAXIM_CDETCTRL1_CHGDETEN_MASK	BIT(MAXIM_CDETCTRL1_CHGDETEN_SHIFT)
+#define MAXIM_CDETCTRL1_CHGTYPMAN_MASK	BIT(MAXIM_CDETCTRL1_CHGTYPMAN_SHIFT)
+#define MAXIM_CDETCTRL1_DCDEN_MASK	BIT(MAXIM_CDETCTRL1_DCDEN_SHIFT)
+#define MAXIM_CDETCTRL1_DCD2SCT_MASK	BIT(MAXIM_CDETCTRL1_DCD2SCT_SHIFT)
+#define MAXIM_CDETCTRL1_DCHKTM_MASK	BIT(MAXIM_CDETCTRL1_DCHKTM_SHIFT)
+#define MAXIM_CDETCTRL1_DBEXIT_MASK	BIT(MAXIM_CDETCTRL1_DBEXIT_SHIFT)
+#define MAXIM_CDETCTRL1_DBIDLE_MASK	BIT(MAXIM_CDETCTRL1_DBIDLE_SHIFT)
+#define MAXIM_CDETCTRL1_CDPDET_MASK	BIT(MAXIM_CDETCTRL1_CDPDET_SHIFT)
 
 /* MAX14577 MAXIM_CHGCTRL1 register */
 #define MAXIM_CHGCTRL1_TCHW_SHIFT	4
@@ -195,9 +205,9 @@ enum maxim_muic_charger_type {
 
 /* MAX14577 MAXIM_CHGCTRL2 register */
 #define MAXIM_CHGCTRL2_MBCHOSTEN_SHIFT	6
-#define MAXIM_CHGCTRL2_MBCHOSTEN_MASK	(0x1 << MAXIM_CHGCTRL2_MBCHOSTEN_SHIFT)
+#define MAXIM_CHGCTRL2_MBCHOSTEN_MASK	BIT(MAXIM_CHGCTRL2_MBCHOSTEN_SHIFT)
 #define MAXIM_CHGCTRL2_VCHGR_RC_SHIFT	7
-#define MAXIM_CHGCTRL2_VCHGR_RC_MASK	(0x1 << MAXIM_CHGCTRL2_VCHGR_RC_SHIFT)
+#define MAXIM_CHGCTRL2_VCHGR_RC_MASK	BIT(MAXIM_CHGCTRL2_VCHGR_RC_SHIFT)
 
 /* MAX14577 MAXIM_CHGCTRL3 register */
 #define MAXIM_CHGCTRL3_MBCCVWRC_SHIFT	0
@@ -207,7 +217,7 @@ enum maxim_muic_charger_type {
 #define MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT	0
 #define MAXIM_CHGCTRL4_MBCICHWRCH_MASK	(0xf << MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT)
 #define MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT	4
-#define MAXIM_CHGCTRL4_MBCICHWRCL_MASK	(0x1 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT)
+#define MAXIM_CHGCTRL4_MBCICHWRCL_MASK	BIT(MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT)
 
 /* MAX14577 MAXIM_CHGCTRL5 register */
 #define MAXIM_CHGCTRL5_EOCS_SHIFT	0
@@ -215,7 +225,7 @@ enum maxim_muic_charger_type {
 
 /* MAX14577 MAXIM_CHGCTRL6 register */
 #define MAXIM_CHGCTRL6_AUTOSTOP_SHIFT	5
-#define MAXIM_CHGCTRL6_AUTOSTOP_MASK	(0x1 << MAXIM_CHGCTRL6_AUTOSTOP_SHIFT)
+#define MAXIM_CHGCTRL6_AUTOSTOP_MASK	BIT(MAXIM_CHGCTRL6_AUTOSTOP_SHIFT)
 
 /* MAX14577 MAXIM_CHGCTRL7 register */
 #define MAXIM_CHGCTRL7_OTPCGHCVS_SHIFT	0
@@ -230,7 +240,69 @@ enum maxim_muic_charger_type {
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
 
 enum maxim_irq {
 	/* INT1 */
@@ -251,17 +323,24 @@ enum maxim_irq {
 	MAXIM_IRQ_INT3_OVP,
 	MAXIM_IRQ_INT3_MBCCHGERR,
 
+	/* TOPSYS_INT */
+	MAXIM_IRQ_TOPSYS_T140C,
+	MAXIM_IRQ_TOPSYS_T120C,
+
 	MAXIM_IRQ_NUM,
 };
 
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
index 75301be5c548..6aad3f249fdd 100644
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
1.7.9.5

