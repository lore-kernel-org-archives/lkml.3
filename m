Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaJULZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:25:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48872 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbaJULYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:24:01 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-96-5446424ee86e
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
Subject: [PATCH v2 2/4] regulator: max77686: Implement suspend disable for some
 LDOs
Date: Tue, 21 Oct 2014 13:23:15 +0200
Message-id: <1413890597-31037-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
References: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xK7p+Tm4hBs+2WVlsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gtvl3pYLLY9Pgaq8XlXXPYLGac
	38dkcfsyr8XaI3fZHfg9Wpp72Dz+Pr/O4vF31Qtmj52z7rJ7bFrVyeaxeUm9R9+WVYwenzfJ
	BXBEcdmkpOZklqUW6dslcGVsebuKuWCbbMXa73/ZGxj/S3QxcnJICJhI/Pr1jRXCFpO4cG89
	G4gtJLCUUeLuNOYuRi4gu49J4sXy42AJNgFjic3Ll4DZIgL7mSQeTzABKWIWWM0k8fPKKWaQ
	hLBAmETTlJtgNouAqkTX1atMIDavgLvEz/XrWSC2yUmcPDYZbDOngIfEnesd7BCb3SVWH5zD
	OoGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkOD9uoNx6TGrQ4wCHIxKPLwRS1xD
	hFgTy4orcw8xSnAwK4nw5gq7hQjxpiRWVqUW5ccXleakFh9iZOLglGpgVP+dGbPSftGCiF3T
	TjDo6dc2hpot2/BmxtTQrq22HJZRE37OOaymH/TdXvP4i069CKuG36WsoZr1VqXHFJui9v5Z
	cuKZWlCZfLvDnQfr3TaGFBdJ7z7QNG+fXY3Wu9S3Z11rVpy2eXrCZYuk1Oq9ggfcfG5ofWM5
	KvPhubTP+5XLvq3rfK39R4mlOCPRUIu5qDgRAIGLB988AgAA
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
 drivers/regulator/max77686.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index cffe0c69d57d..05df72d584bf 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -79,17 +79,33 @@ struct max77686_data {
 };
 
 /* Some BUCKS supports Normal[ON/OFF] mode during suspend */
-static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
+static int max77686_set_suspend_disable(struct regulator_dev *rdev)
 {
 	unsigned int val;
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
 	int ret, id = rdev_get_id(rdev);
 
-	if (id == MAX77686_BUCK1)
+	switch (id) {
+	case MAX77686_BUCK1:
 		val = MAX77686_OPMODE_OFF_PWRREQ;
-	else
+		break;
+	case MAX77686_BUCK2:
+	case MAX77686_BUCK3:
+	case MAX77686_BUCK4:
 		val = MAX77686_OPMODE_OFF_PWRREQ
 			<< MAX77686_OPMODE_BUCK234_SHIFT;
+		break;
+	case MAX77686_LDO2:
+	case MAX77686_LDO6 ... MAX77686_LDO8:
+	case MAX77686_LDO10 ... MAX77686_LDO12:
+	case MAX77686_LDO14 ... MAX77686_LDO16:
+		val = MAX77686_OPMODE_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
+		break;
+	default:
+		pr_warn("%s: regulator_suspend_disable not supported\n",
+			rdev->desc->name);
+		return -EINVAL;
+	}
 
 	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				 rdev->desc->enable_mask, val);
@@ -171,6 +187,9 @@ static int max77686_enable(struct regulator_dev *rdev)
 {
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
 
+	if (max77686->opmode[rdev_get_id(rdev)] == MAX77686_OPMODE_OFF_PWRREQ)
+		max77686->opmode[rdev_get_id(rdev)] = MAX77686_OPMODE_NORMAL;
+
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
 				  max77686->opmode[rdev_get_id(rdev)]);
@@ -223,6 +242,8 @@ static struct regulator_ops max77686_ldo_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_suspend_mode	= max77686_ldo_set_suspend_mode,
+	.set_suspend_disable	= max77686_set_suspend_disable,
+	.set_suspend_enable	= max77686_enable,
 };
 
 static struct regulator_ops max77686_buck1_ops = {
@@ -234,7 +255,8 @@ static struct regulator_ops max77686_buck1_ops = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
-	.set_suspend_disable	= max77686_buck_set_suspend_disable,
+	.set_suspend_disable	= max77686_set_suspend_disable,
+	.set_suspend_enable	= max77686_enable,
 };
 
 static struct regulator_ops max77686_buck_dvs_ops = {
@@ -247,7 +269,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
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

