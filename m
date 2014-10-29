Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbaJ2LPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:15:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33979 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaJ2LPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:15:11 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-13-5450cc3c2a43
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
Subject: [PATCH v6 1/3] regulator: max77686: Add suspend disable for some LDOs
Date: Wed, 29 Oct 2014 12:14:52 +0100
Message-id: <1414581294-1315-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414581294-1315-1-git-send-email-k.kozlowski@samsung.com>
References: <1414581294-1315-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xa7o2ZwJCDCZslrbYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBbfLvSwWSx6fE1VovLu+awWcw4
	v4/J4vZlXou1R+6yO/B7tDT3sHn8fX6dxePvqhfMHjtn3WX32LSqk81j85J6j74tqxg9Pm+S
	C+CI4rJJSc3JLEst0rdL4Mro2X2BraBXvOLmohVMDYwPhLsYOTkkBEwkbkyZxwxhi0lcuLee
	rYuRi0NIYCmjxPvj15ghnD4miRfX/4JVsQkYS2xevoQNxBYR2M8k8XiCCUgRs8BqJomfV06B
	FQkL+Emc3XuMEcRmEVCV+Lv2PROIzSvgJvHr+BUWiHVyEiePTWYFsTkF3CU+7m5jB7GFgGo2
	/+hkmcDIu4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSPh+3cG49JjVIUYBDkYlHt6I
	YwEhQqyJZcWVuYcYJTiYlUR43+0FCvGmJFZWpRblxxeV5qQWH2Jk4uCUamBcfemk8389M/7p
	l/g2djtx127f9sWtl/m5WXjqh9mcs6K4upa3nDcyCM3nfX1oCcsPt9y2uqkZt9evr5tvpKO3
	ZdGiiQfNF9uesLsxyZv3VSVjZE7NUn6uA7bf2y5uz322yGJN3cL7Xhv9MhZbfH4VZinxPUhp
	WXnTpDhpyx4DAVHNnr59cz4psRRnJBpqMRcVJwIAhhipxD0CAAA=
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

Add suspend disable for LDO regulators supporting this. Re-use existing
max77686_buck_set_suspend_disable() function. This helps reducing
energy consumption during system sleep.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77686.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 2ebc4257425b..f960cfc7fdc6 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -99,8 +99,8 @@ static unsigned int max77686_get_opmode_shift(int id)
 	}
 }
 
-/* Some BUCKS supports Normal[ON/OFF] mode during suspend */
-static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
+/* Some BUCKs and LDOs supports Normal[ON/OFF] mode during suspend */
+static int max77686_set_suspend_disable(struct regulator_dev *rdev)
 {
 	unsigned int val, shift;
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
@@ -195,6 +195,9 @@ static int max77686_enable(struct regulator_dev *rdev)
 
 	shift = max77686_get_opmode_shift(id);
 
+	if (max77686->opmode[id] == MAX77686_OFF_PWRREQ)
+		max77686->opmode[id] = MAX77686_NORMAL;
+
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
 				  max77686->opmode[id] << shift);
@@ -247,6 +250,7 @@ static struct regulator_ops max77686_ldo_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_suspend_mode	= max77686_ldo_set_suspend_mode,
+	.set_suspend_disable	= max77686_set_suspend_disable,
 };
 
 static struct regulator_ops max77686_buck1_ops = {
@@ -258,7 +262,7 @@ static struct regulator_ops max77686_buck1_ops = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
-	.set_suspend_disable	= max77686_buck_set_suspend_disable,
+	.set_suspend_disable	= max77686_set_suspend_disable,
 };
 
 static struct regulator_ops max77686_buck_dvs_ops = {
@@ -271,7 +275,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= max77686_set_ramp_delay,
-	.set_suspend_disable	= max77686_buck_set_suspend_disable,
+	.set_suspend_disable	= max77686_set_suspend_disable,
 };
 
 #define regulator_desc_ldo(num)		{				\
-- 
1.9.1

