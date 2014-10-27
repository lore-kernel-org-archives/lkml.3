Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaJ0MMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:12:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56746 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaJ0MME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:12:04 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-84-544e369139a2
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
Subject: [PATCH v5 2/4] regulator: max77686: Store opmode non-shifted
Date: Mon, 27 Oct 2014 13:11:48 +0100
Message-id: <1414411911-5539-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xy7oTzfxCDI6+1rDYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBbfLvSwWSx6fE1VovLu+awWcw4
	v4/J4vZlXou1R+6yO/B7tDT3sHn8fX6dxePvqhfMHjtn3WX32LSqk81j85J6j74tqxg9Pm+S
	C+CI4rJJSc3JLEst0rdL4Mp4fng3U8EJlYquvnXsDYzdcl2MnBwSAiYSU74uZIWwxSQu3FvP
	1sXIxSEksJRRYu66ViYIp49JYuWywywgVWwCxhKbly9hA7FFBPYzSTyeYAJSxCywmkni55VT
	zF2MHBzCAq4SLTOtQUwWAVWJLauDQExeATeJjdMYIXbJSZw8NhlsL6eAu8SbOW1gcSGgkmWn
	HrJPYORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkcL/uYFx6zOoQowAHoxIP74Ri
	3xAh1sSy4srcQ4wSHMxKIryOP4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGOs5bu05NJm/tEVy
	xjrOBYpfrKfucW45E/5safin75t0nnCK8lyNtjAw1f2dYy1qX8qlry9rPHHr2yCtT2y9JWzf
	6ks/WE6JKr2/uXb9xbyMj1wf9GqSmfPqNH1ut0z4/Kz3xaeVWRsMZed/NmXifjx5lkLxn1nd
	bw9ciVD/E/HM0uh06rkPuUosxRmJhlrMRcWJACqNFA46AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce simple helper for calculating the shift for OPMODE field in
registers. This allows storing the current value of opmode in
non-shifted form and simplifies a little set_suspend_disable and enable
functions. Additionally this will allow adding support LDOs to the
existing set_suspend_disable function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77686.c | 49 ++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index c625a8a7940d..2ebc4257425b 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -85,20 +85,32 @@ struct max77686_data {
 	unsigned int opmode[MAX77686_REGULATORS];
 };
 
+static unsigned int max77686_get_opmode_shift(int id)
+{
+	switch (id) {
+	case MAX77686_BUCK1:
+	case MAX77686_BUCK5 ... MAX77686_BUCK9:
+		return 0;
+	case MAX77686_BUCK2 ... MAX77686_BUCK4:
+		return MAX77686_OPMODE_BUCK234_SHIFT;
+	default:
+		/* all LDOs */
+		return MAX77686_OPMODE_SHIFT;
+	}
+}
+
 /* Some BUCKS supports Normal[ON/OFF] mode during suspend */
 static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
 {
-	unsigned int val;
+	unsigned int val, shift;
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
 	int ret, id = rdev_get_id(rdev);
 
-	if (id == MAX77686_BUCK1)
-		val = MAX77686_OFF_PWRREQ;
-	else
-		val = MAX77686_OFF_PWRREQ << MAX77686_OPMODE_BUCK234_SHIFT;
+	shift = max77686_get_opmode_shift(id);
+	val = MAX77686_OFF_PWRREQ;
 
 	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				 rdev->desc->enable_mask, val);
+				 rdev->desc->enable_mask, val << shift);
 	if (ret)
 		return ret;
 
@@ -120,10 +132,10 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 
 	switch (mode) {
 	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = MAX77686_LDO_LOWPOWER_PWRREQ << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_LDO_LOWPOWER_PWRREQ;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = MAX77686_NORMAL << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_NORMAL;
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
@@ -132,7 +144,8 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 	}
 
 	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask, val);
+				  rdev->desc->enable_mask,
+				  val << MAX77686_OPMODE_SHIFT);
 	if (ret)
 		return ret;
 
@@ -150,13 +163,13 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 
 	switch (mode) {
 	case REGULATOR_MODE_STANDBY:			/* switch off */
-		val = MAX77686_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_OFF_PWRREQ;
 		break;
 	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = MAX77686_LDO_LOWPOWER_PWRREQ << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_LDO_LOWPOWER_PWRREQ;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = MAX77686_NORMAL << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_NORMAL;
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
@@ -165,7 +178,8 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 	}
 
 	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				 rdev->desc->enable_mask, val);
+				 rdev->desc->enable_mask,
+				 val << MAX77686_OPMODE_SHIFT);
 	if (ret)
 		return ret;
 
@@ -176,10 +190,14 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 static int max77686_enable(struct regulator_dev *rdev)
 {
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	unsigned int shift;
+	int id = rdev_get_id(rdev);
+
+	shift = max77686_get_opmode_shift(id);
 
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
-				  max77686->opmode[rdev_get_id(rdev)]);
+				  max77686->opmode[id] << shift);
 }
 
 static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
@@ -495,7 +513,8 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		config.init_data = pdata->regulators[i].initdata;
 		config.of_node = pdata->regulators[i].of_node;
 
-		max77686->opmode[i] = regulators[i].enable_mask;
+		max77686->opmode[i] = regulators[i].enable_mask >>
+						max77686_get_opmode_shift(i);
 		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.9.1

