Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaFQHjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:39:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44349 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752798AbaFQHi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:38:59 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 1/7] mfd: axp20x: add AXP221 PMIC support
Date: Tue, 17 Jun 2014 09:38:37 +0200
Message-Id: <1402990723-28138-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the AXP221 PMIC device to the existing AXP20x driver.

The AXP221 defines a new set of registers, power supplies and regulators,
but most of the API is similar to the AXP20x ones.
The AXP20x irq chip definition is reused, though some interrupts are not
available in the AXP221.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/mfd/axp20x.c       | 64 ++++++++++++++++++++++++++++++++++++++++++----
 include/linux/mfd/axp20x.h | 56 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index dee6539..ad4c177 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -33,6 +33,11 @@ static const struct regmap_range axp20x_writeable_ranges[] = {
 	regmap_reg_range(AXP20X_DCDC_MODE, AXP20X_FG_RES),
 };
 
+static const struct regmap_range axp22x_writeable_ranges[] = {
+	regmap_reg_range(AXP20X_DATACACHE(0), AXP20X_IRQ5_STATE),
+	regmap_reg_range(AXP20X_DCDC_MODE, AXP22X_BATLOW_THRES1),
+};
+
 static const struct regmap_range axp20x_volatile_ranges[] = {
 	regmap_reg_range(AXP20X_IRQ1_EN, AXP20X_IRQ5_STATE),
 };
@@ -42,6 +47,11 @@ static const struct regmap_access_table axp20x_writeable_table = {
 	.n_yes_ranges	= ARRAY_SIZE(axp20x_writeable_ranges),
 };
 
+static const struct regmap_access_table axp22x_writeable_table = {
+	.yes_ranges	= axp22x_writeable_ranges,
+	.n_yes_ranges	= ARRAY_SIZE(axp22x_writeable_ranges),
+};
+
 static const struct regmap_access_table axp20x_volatile_table = {
 	.yes_ranges	= axp20x_volatile_ranges,
 	.n_yes_ranges	= ARRAY_SIZE(axp20x_volatile_ranges),
@@ -70,6 +80,15 @@ static const struct regmap_config axp20x_regmap_config = {
 	.cache_type	= REGCACHE_RBTREE,
 };
 
+static const struct regmap_config axp22x_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.wr_table	= &axp22x_writeable_table,
+	.volatile_table	= &axp20x_volatile_table,
+	.max_register	= AXP22X_BATLOW_THRES1,
+	.cache_type	= REGCACHE_RBTREE,
+};
+
 #define AXP20X_IRQ(_irq, _off, _mask) \
 	[AXP20X_IRQ_##_irq] = { .reg_offset = (_off), .mask = BIT(_mask) }
 
@@ -116,6 +135,7 @@ static const struct regmap_irq axp20x_regmap_irqs[] = {
 static const struct of_device_id axp20x_of_match[] = {
 	{ .compatible = "x-powers,axp202", .data = (void *) AXP202_ID },
 	{ .compatible = "x-powers,axp209", .data = (void *) AXP209_ID },
+	{ .compatible = "x-powers,axp221", .data = (void *) AXP221_ID },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, axp20x_of_match);
@@ -149,6 +169,21 @@ static const char * const axp20x_supplies[] = {
 	"ldo5in",
 };
 
+static const char *axp22x_supplies[] = {
+	"vbus",
+	"acin",
+	"vin1",
+	"vin2",
+	"vin3",
+	"vin4",
+	"vin5",
+	"aldoin",
+	"dldoin",
+	"eldoin",
+	"ldoioin",
+	"rtcldoin",
+};
+
 static struct mfd_cell axp20x_cells[] = {
 	{
 		.name			= "axp20x-pek",
@@ -161,6 +196,14 @@ static struct mfd_cell axp20x_cells[] = {
 	},
 };
 
+static struct mfd_cell axp22x_cells[] = {
+	{
+		.name			= "axp20x-regulator",
+		.parent_supplies	= axp22x_supplies,
+		.num_parent_supplies	= ARRAY_SIZE(axp22x_supplies),
+	},
+};
+
 static struct axp20x_dev *axp20x_pm_power_off;
 static void axp20x_power_off(void)
 {
@@ -171,8 +214,11 @@ static void axp20x_power_off(void)
 static int axp20x_i2c_probe(struct i2c_client *i2c,
 			 const struct i2c_device_id *id)
 {
-	struct axp20x_dev *axp20x;
+	const struct regmap_config *regmap_cfg;
 	const struct of_device_id *of_id;
+	struct axp20x_dev *axp20x;
+	struct mfd_cell *cells;
+	int ncells;
 	int ret;
 
 	axp20x = devm_kzalloc(&i2c->dev, sizeof(*axp20x), GFP_KERNEL);
@@ -190,7 +236,17 @@ static int axp20x_i2c_probe(struct i2c_client *i2c,
 	axp20x->dev = &i2c->dev;
 	dev_set_drvdata(axp20x->dev, axp20x);
 
-	axp20x->regmap = devm_regmap_init_i2c(i2c, &axp20x_regmap_config);
+	if (axp20x->variant == AXP221_ID) {
+		regmap_cfg = &axp22x_regmap_config;
+		cells = axp22x_cells;
+		ncells = ARRAY_SIZE(axp22x_cells);
+	} else {
+		regmap_cfg = &axp20x_regmap_config;
+		cells = axp20x_cells;
+		ncells = ARRAY_SIZE(axp20x_cells);
+	}
+
+	axp20x->regmap = devm_regmap_init_i2c(i2c, regmap_cfg);
 	if (IS_ERR(axp20x->regmap)) {
 		ret = PTR_ERR(axp20x->regmap);
 		dev_err(&i2c->dev, "regmap init failed: %d\n", ret);
@@ -206,9 +262,7 @@ static int axp20x_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	ret = mfd_add_devices(axp20x->dev, -1, axp20x_cells,
-			      ARRAY_SIZE(axp20x_cells), NULL, 0, NULL);
-
+	ret = mfd_add_devices(axp20x->dev, -1, cells, ncells, NULL, 0, NULL);
 	if (ret) {
 		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
 		regmap_del_irq_chip(i2c->irq, axp20x->regmap_irqc);
diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp20x.h
index d0e31a2..8a8ce02 100644
--- a/include/linux/mfd/axp20x.h
+++ b/include/linux/mfd/axp20x.h
@@ -14,6 +14,7 @@
 enum {
 	AXP202_ID = 0,
 	AXP209_ID,
+	AXP221_ID,
 };
 
 #define AXP20X_DATACACHE(m)		(0x04 + (m))
@@ -43,6 +44,28 @@ enum {
 #define AXP20X_V_LTF_DISCHRG		0x3c
 #define AXP20X_V_HTF_DISCHRG		0x3d
 
+#define AXP22X_PWR_OUT_CTRL1		0x10
+#define AXP22X_PWR_OUT_CTRL2		0x12
+#define AXP22X_PWR_OUT_CTRL3		0x13
+#define AXP22X_DLDO1_V_OUT		0x15
+#define AXP22X_DLDO2_V_OUT		0x16
+#define AXP22X_DLDO3_V_OUT		0x17
+#define AXP22X_DLDO4_V_OUT		0x18
+#define AXP22X_ELDO1_V_OUT		0x19
+#define AXP22X_ELDO2_V_OUT		0x1a
+#define AXP22X_ELDO3_V_OUT		0x1b
+#define AXP22X_DC5LDO_V_OUT		0x1c
+#define AXP22X_DCDC1_V_OUT		0x21
+#define AXP22X_DCDC2_V_OUT		0x22
+#define AXP22X_DCDC3_V_OUT		0x23
+#define AXP22X_DCDC4_V_OUT		0x24
+#define AXP22X_DCDC5_V_OUT		0x25
+#define AXP22X_DCDC23_V_RAMP_CTRL	0x27
+#define AXP22X_ALDO1_V_OUT		0x28
+#define AXP22X_ALDO2_V_OUT		0x29
+#define AXP22X_ALDO3_V_OUT		0x2a
+#define AXP22X_CHRG_CTRL3		0x35
+
 /* Interrupt */
 #define AXP20X_IRQ1_EN			0x40
 #define AXP20X_IRQ2_EN			0x41
@@ -96,6 +119,9 @@ enum {
 #define AXP20X_VBUS_MON			0x8b
 #define AXP20X_OVER_TMP			0x8f
 
+#define AXP22X_PWREN_CTRL1		0x8c
+#define AXP22X_PWREN_CTRL2		0x8d
+
 /* GPIO */
 #define AXP20X_GPIO0_CTRL		0x90
 #define AXP20X_LDO5_V_OUT		0x91
@@ -104,6 +130,11 @@ enum {
 #define AXP20X_GPIO20_SS		0x94
 #define AXP20X_GPIO3_CTRL		0x95
 
+#define AXP22X_LDO_IO0_V_OUT		0x91
+#define AXP22X_LDO_IO1_V_OUT		0x93
+#define AXP22X_GPIO_STATE		0x94
+#define AXP22X_GPIO_PULL_DOWN		0x95
+
 /* Battery */
 #define AXP20X_CHRG_CC_31_24		0xb0
 #define AXP20X_CHRG_CC_23_16		0xb1
@@ -116,6 +147,8 @@ enum {
 #define AXP20X_CC_CTRL			0xb8
 #define AXP20X_FG_RES			0xb9
 
+#define AXP22X_BATLOW_THRES1		0xe6
+
 /* Regulators IDs */
 enum {
 	AXP20X_LDO1 = 0,
@@ -128,6 +161,29 @@ enum {
 	AXP20X_REG_ID_MAX,
 };
 
+enum {
+	AXP22X_DCDC1 = 0,
+	AXP22X_DCDC2,
+	AXP22X_DCDC3,
+	AXP22X_DCDC4,
+	AXP22X_DCDC5,
+	AXP22X_DC5LDO,
+	AXP22X_ALDO1,
+	AXP22X_ALDO2,
+	AXP22X_ALDO3,
+	AXP22X_ELDO1,
+	AXP22X_ELDO2,
+	AXP22X_ELDO3,
+	AXP22X_DLDO1,
+	AXP22X_DLDO2,
+	AXP22X_DLDO3,
+	AXP22X_DLDO4,
+	AXP22X_RTC_LDO,
+	AXP22X_LDO_IO0,
+	AXP22X_LDO_IO1,
+	AXP22X_REG_ID_MAX,
+};
+
 /* IRQs */
 enum {
 	AXP20X_IRQ_ACIN_OVER_V = 1,
-- 
1.8.3.2

