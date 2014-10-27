Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaJ0JqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:46:11 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8323 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaJ0Jot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:44:49 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-f5-544e140e282d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 2/3] regulator: max77686: Implement suspend disable for some
 LDOs
Date: Mon, 27 Oct 2014 10:44:25 +0100
Message-id: <1414403066-7872-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414403066-7872-1-git-send-email-k.kozlowski@samsung.com>
References: <1414403066-7872-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xK7p8In4hBld36VlsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gtvl3pYLLY9Pgaq8XlXXPYLGac
	38dkcfsyr8XaI3fZHfg9Wpp72Dz+Pr/O4vF31Qtmj52z7rJ7bFrVyeaxeUm9R9+WVYwenzfJ
	BXBEcdmkpOZklqUW6dslcGVsvXWOqeCuRsXU80vZGxiXKXUxcnJICJhI3Px5mg3CFpO4cG89
	kM3FISSwlFHi4ZTfrCAJIYE+Jokp31NAbDYBY4nNy5eANYgI7GeSeDzBBKSBWWA1k8TPK6eY
	QRLCAmESHYtmgDWzCKhKrJ/fzQ5i8wq4SXR2zGGG2CYncfLYZLAaTgF3iXnde9kglrlJ3J4+
	h3UCI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHB+2UH4+JjVocYBTgYlXh4d0zz
	DRFiTSwrrsw9xCjBwawkwuv4EyjEm5JYWZValB9fVJqTWnyIkYmDU6qB0fC+hnOnIftym+KO
	+km9y0/6bowwCyvnXHH/X8/5zMqOC1+cP9xnrW/QfKCvs+JseSn/rXm1KvVH9faabs21ahXd
	9iJK+u6X6xetzp0+I7Y2dfJfxi+FWdqLaxn2r2W5oZ7m2zIz5HSNNv+STZPUz+QvXpAy6845
	LSP+TW7LzvzI/7Zf5lC+thJLcUaioRZzUXEiAEP8ajs8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LDOs of Maxim 77686 PMIC support disabling during system suspend
(LDO{2,6,7,8,10,11,12,14,15,16}). This was already implemented as part
of set_suspend_mode function. In that case the mode was one of:
 - disable,
 - normal mode,
 - low power mode.
However there are no bindings for setting the mode during suspend.

Add suspend disable for LDO regulators supporting this to the existing
max77686_buck_set_suspend_disable() function. This helps reducing
energy consumption during system sleep.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 75 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 66 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 3d0922051488..4b35c19c9286 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -87,18 +87,31 @@ struct max77686_data {
 	unsigned int opmode[MAX77686_REGULATORS];
 };
 
-/* Some BUCKS supports Normal[ON/OFF] mode during suspend */
-static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
+/* Some BUCKs and LDOs supports Normal[ON/OFF] mode during suspend */
+static int max77686_set_suspend_disable(struct regulator_dev *rdev)
 {
 	unsigned int val;
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
 	int ret, id = rdev_get_id(rdev);
 
-	if (id == MAX77686_BUCK1)
+	switch (id) {
+	case MAX77686_BUCK1:
 		val = MAX77686_BUCK_OFF_PWRREQ;
-	else
-		val = MAX77686_BUCK_OFF_PWRREQ
-			<< MAX77686_OPMODE_BUCK234_SHIFT;
+		break;
+	case MAX77686_BUCK2 ...	MAX77686_BUCK4:
+		val = MAX77686_BUCK_OFF_PWRREQ << MAX77686_OPMODE_BUCK234_SHIFT;
+		break;
+	case MAX77686_LDO2:
+	case MAX77686_LDO6 ... MAX77686_LDO8:
+	case MAX77686_LDO10 ... MAX77686_LDO12:
+	case MAX77686_LDO14 ... MAX77686_LDO16:
+		val = MAX77686_LDO_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
+		break;
+	default:
+		pr_warn("%s: regulator_suspend_disable not supported\n",
+			rdev->desc->name);
+		return -EINVAL;
+	}
 
 	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				 rdev->desc->enable_mask, val);
@@ -176,13 +189,53 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 	return 0;
 }
 
+/*
+ * For regulators supporting disabled in suspend it checks if opmode
+ * is 'off_pwrreq' mode (disabled in suspend) and changes it to 'enable'.
+ * For other regulators does nothing.
+ */
+static void max77686_set_opmode_enable(struct max77686_data *max77686, int id)
+{
+	unsigned int opmode_shift;
+
+	/*
+	 * Same enable function is used for LDO and bucks. Assuming
+	 * the same values are used for enable registers.
+	 */
+	BUILD_BUG_ON(MAX77686_LDO_OFF_PWRREQ != MAX77686_BUCK_OFF_PWRREQ);
+	BUILD_BUG_ON(MAX77686_LDO_NORMAL != MAX77686_BUCK_NORMAL);
+
+	switch (id) {
+	case MAX77686_BUCK1:
+		opmode_shift = 0;
+		break;
+	case MAX77686_BUCK2 ...	MAX77686_BUCK4:
+		opmode_shift = MAX77686_OPMODE_BUCK234_SHIFT;
+		break;
+	case MAX77686_LDO2:
+	case MAX77686_LDO6 ... MAX77686_LDO8:
+	case MAX77686_LDO10 ... MAX77686_LDO12:
+	case MAX77686_LDO14 ... MAX77686_LDO16:
+		opmode_shift = MAX77686_OPMODE_SHIFT;
+		break;
+	default:
+		return;
+	}
+
+	if (max77686->opmode[id] == (MAX77686_LDO_OFF_PWRREQ << opmode_shift))
+		max77686->opmode[id] = MAX77686_LDO_NORMAL << opmode_shift;
+}
+
 static int max77686_enable(struct regulator_dev *rdev)
 {
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+
+	max77686_set_opmode_enable(max77686, id);
 
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
-				  max77686->opmode[rdev_get_id(rdev)]);
+				  max77686->opmode[id]);
 }
 
 static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
@@ -232,6 +285,8 @@ static struct regulator_ops max77686_ldo_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_suspend_mode	= max77686_ldo_set_suspend_mode,
+	.set_suspend_disable	= max77686_set_suspend_disable,
+	.set_suspend_enable	= max77686_enable,
 };
 
 static struct regulator_ops max77686_buck1_ops = {
@@ -243,7 +298,8 @@ static struct regulator_ops max77686_buck1_ops = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
-	.set_suspend_disable	= max77686_buck_set_suspend_disable,
+	.set_suspend_disable	= max77686_set_suspend_disable,
+	.set_suspend_enable	= max77686_enable,
 };
 
 static struct regulator_ops max77686_buck_dvs_ops = {
@@ -256,7 +312,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= max77686_set_ramp_delay,
-	.set_suspend_disable	= max77686_buck_set_suspend_disable,
+	.set_suspend_disable	= max77686_set_suspend_disable,
+	.set_suspend_enable	= max77686_enable,
 };
 
 #define regulator_desc_ldo(num)		{				\
-- 
1.9.1

