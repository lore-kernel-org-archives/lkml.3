Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaBKNG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:06:58 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34136 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaBKNER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:17 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-97-52fa1fcf970b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 07/14] regulator: s2mps11: Choose number of supported
 regulators during probe
Date: Tue, 11 Feb 2014 14:03:50 +0100
Message-id: <1392123837-5517-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xK7rn5X8FGSxtF7HYOGM9q8XUh0/Y
	LK5/ec5q8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBYzzu9jslh75C67xeluVouLK74wOfB4
	7Jx1l91j06pONo871/awecw7GejRt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGZsevWMpOKhY
	sW3xI9YGxqfSXYycHBICJhINi3awQ9hiEhfurWfrYuTiEBJYyigxu/86C4TTxyTR/fEhE0gV
	m4CxxOblS8CqRAQ2M0os/n6VFcRhFtjKJPF5/UZmkCphgXiJnhufgeZycLAIqEqc3pUHEuYV
	cJM4tKiNDSQsIaAgMWeSDUiYU8Bdou/Tf7CwEFDJ8v7YCYy8CxgZVjGKppYmFxQnpeca6hUn
	5haX5qXrJefnbmKEhOKXHYyLj1kdYhTgYFTi4d2g+DNIiDWxrLgy9xCjBAezkgjvF+FfQUK8
	KYmVValF+fFFpTmpxYcYmTg4pRoYkxNWZry7wTVZ2/M2W0aKzO/E/1O9fwu0mDkeVjmbeaPh
	qRcfg9sOhSwZlXCmrxIhKRu7qgRztB0aS65qK8a+MzJdsIdz5kw2Lw2zpERDuW/mjc4+Cf7X
	+jaorNq0xOHOM8YXHW/73bOEVF+Hbtq0w5Rvi/DRJVV6SkISLjeOVP7xrVpw8L0SS3FGoqEW
	c1FxIgBOnhhEIwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe choose how many regulators will be supported according to
device ID. Allocate array of of_regulator_match() dynamically (based
number of regulators) instead of allocation on the stack.

This is needed for supporting different devices in s2mps11
driver and actually prepares the regulator driver for supporting the
S2MPS14 device.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 drivers/regulator/s2mps11.c |   46 +++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index d44bd5b3fe8e..43a2eefb9aa4 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -25,10 +25,9 @@
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/s2mps11.h>
 
-#define S2MPS11_REGULATOR_CNT ARRAY_SIZE(regulators)
-
 struct s2mps11_info {
-	struct regulator_dev *rdev[S2MPS11_REGULATOR_MAX];
+	struct regulator_dev **rdev;
+	unsigned int rdev_num;
 
 	int ramp_delay2;
 	int ramp_delay34;
@@ -345,7 +344,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-static const struct regulator_desc regulators[] = {
+static const struct regulator_desc s2mps11_regulators[] = {
 	regulator_desc_ldo2(1),
 	regulator_desc_ldo1(2),
 	regulator_desc_ldo1(3),
@@ -399,18 +398,31 @@ static const struct regulator_desc regulators[] = {
 static int s2mps11_pmic_probe(struct platform_device *pdev)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
-	struct of_regulator_match rdata[S2MPS11_REGULATOR_MAX];
+	struct sec_platform_data *pdata = iodev->pdata;
+	struct of_regulator_match *rdata = NULL;
 	struct device_node *reg_np = NULL;
 	struct regulator_config config = { };
 	struct s2mps11_info *s2mps11;
 	int i, ret;
+	const struct regulator_desc *regulators;
+	enum sec_device_type dev_type;
 
 	s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
 				GFP_KERNEL);
 	if (!s2mps11)
 		return -ENOMEM;
 
+	dev_type = platform_get_device_id(pdev)->driver_data;
+	switch (dev_type) {
+	case S2MPS11X:
+		s2mps11->rdev_num = ARRAY_SIZE(s2mps11_regulators);
+		regulators = s2mps11_regulators;
+		break;
+	default:
+		dev_err(&pdev->dev, "Invalid device type: %u\n", dev_type);
+		return -EINVAL;
+	};
+
 	if (!iodev->dev->of_node) {
 		if (pdata) {
 			goto common_reg;
@@ -421,7 +433,17 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (i = 0; i < S2MPS11_REGULATOR_CNT; i++)
+	s2mps11->rdev = devm_kzalloc(&pdev->dev,
+			sizeof(*s2mps11->rdev)*s2mps11->rdev_num, GFP_KERNEL);
+	if (!s2mps11->rdev)
+		return -ENOMEM;
+
+	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata)*s2mps11->rdev_num,
+			GFP_KERNEL);
+	if (!rdata)
+		return -ENOMEM;
+
+	for (i = 0; i < s2mps11->rdev_num; i++)
 		rdata[i].name = regulators[i].name;
 
 	reg_np = of_find_node_by_name(iodev->dev->of_node, "regulators");
@@ -430,7 +452,7 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	of_regulator_match(&pdev->dev, reg_np, rdata, S2MPS11_REGULATOR_MAX);
+	of_regulator_match(&pdev->dev, reg_np, rdata, s2mps11->rdev_num);
 
 common_reg:
 	platform_set_drvdata(pdev, s2mps11);
@@ -438,7 +460,7 @@ common_reg:
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap_pmic;
 	config.driver_data = s2mps11;
-	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
+	for (i = 0; i < s2mps11->rdev_num; i++) {
 		if (!reg_np) {
 			config.init_data = pdata->regulators[i].initdata;
 			config.of_node = pdata->regulators[i].reg_node;
@@ -457,11 +479,15 @@ common_reg:
 		}
 	}
 
+	/* rdata was needed only for of_regulator_match() during probe */
+	if (rdata)
+		devm_kfree(&pdev->dev, rdata);
+
 	return 0;
 }
 
 static const struct platform_device_id s2mps11_pmic_id[] = {
-	{ "s2mps11-pmic", 0},
+	{ "s2mps11-pmic", S2MPS11X},
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, s2mps11_pmic_id);
-- 
1.7.9.5

