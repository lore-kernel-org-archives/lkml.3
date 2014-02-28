Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaB1KDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:03:25 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11856 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaB1KCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:02:04 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-6b-53105e9aef8e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
Subject: [PATCH 3/3] regulator: s2mps11: Copy supported regulators from
 initconst
Date: Fri, 28 Feb 2014 11:01:50 +0100
Message-id: <1393581710-17754-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393581710-17754-1-git-send-email-k.kozlowski@samsung.com>
References: <1393581710-17754-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Zd1ZcQLBBgdXslhsnLGe1WLqwyds
	Fte/PGe1eP3C0OJs0xt2i29XOpgsLu+aw2Yx4/w+Jou1R+6yW1xc8YXJYv2M1ywWc383slrM
	mf6OyYHXY+esu+wem1Z1snn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxpsFHewF3zUrrvTc
	Z29gXKvUxcjJISFgIrHmzXVmCFtM4sK99WxdjFwcQgJLGSU67kxggnD6mCRWTOtiBaliEzCW
	2Lx8CViViMBGRomD+w+zgjjMAh+ZJBb2fwebJSwQLLH0yzGgdg4OFgFVif0TuUHCvALuEpMa
	3rCChCUEFCTmTLIBMTkFPCQurjEEqRACqriy9y7zBEbeBYwMqxhFU0uTC4qT0nMN9YoTc4tL
	89L1kvNzNzFCgvDLDsbFx6wOMQpwMCrx8E7w5A8WYk0sK67MPcQowcGsJMKb5y4QLMSbklhZ
	lVqUH19UmpNafIiRiYNTqoGRLTPaRZ5n7ZztMtfs7bakt28tU//6d43Fo4kfV8+yXdpW5vhT
	+MLvjJXHn131D6kUmFHIWRJ5pzy06LOt4W9+zmNLp7ts9vocnL73wN0rodoTuj+y5TlySz61
	/C9V0+He92JWTlJatfzpRUUHy5bLr7Sf2m/5+bBJkNZ07xmvMuMWSfbl7d2txFKckWioxVxU
	nAgA4Tgp8yACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __initconst to 'regulator_desc' array with supported regulators.
During probe choose how many and which regulators will be supported
according to device ID. Then copy the 'regulator_desc' array to
allocated memory so the regulator core can use it.

Additionally allocate array of of_regulator_match() dynamically (based
on number of regulators) instead of allocation on the stack.

This is needed for supporting different devices in s2mps11
driver and actually prepares the regulator driver for supporting the
S2MPS14 device.

Code for supporting the S2MPS14 device will add its own array of
'regulator_desc' (also marked as __initconst). This way memory footprint
of the driver will be reduced (approximately 'regulators_desc' array for
S2MPS11 occupies 5 kB on 32-bit ARM, for S2MPS14 will occupy 3 kB).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/s2mps11.c |   75 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 62 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 189038aecbf5..ca66fc56fa58 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -25,9 +25,8 @@
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/s2mps11.h>
 
-#define S2MPS11_REGULATOR_CNT ARRAY_SIZE(regulators)
-
 struct s2mps11_info {
+	unsigned int rdev_num;
 	int ramp_delay2;
 	int ramp_delay34;
 	int ramp_delay5;
@@ -343,7 +342,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-static const struct regulator_desc regulators[] = {
+static const struct regulator_desc s2mps11_regulators[] __initconst = {
 	regulator_desc_ldo2(1),
 	regulator_desc_ldo1(2),
 	regulator_desc_ldo1(3),
@@ -394,21 +393,62 @@ static const struct regulator_desc regulators[] = {
 	regulator_desc_buck10,
 };
 
+/*
+ * Allocates memory under 'regulators' pointer and copies there array
+ * of regulator_desc for given device.
+ *
+ * Returns number of regulators or negative ERRNO on error.
+ */
+static int __init
+s2mps11_pmic_init_regulators_desc(struct platform_device *pdev,
+		struct regulator_desc **regulators)
+{
+	const struct regulator_desc *regulators_init;
+	enum sec_device_type dev_type;
+	int rdev_num;
+
+	dev_type = platform_get_device_id(pdev)->driver_data;
+	switch (dev_type) {
+	case S2MPS11X:
+		rdev_num = ARRAY_SIZE(s2mps11_regulators);
+		regulators_init = s2mps11_regulators;
+		break;
+	default:
+		dev_err(&pdev->dev, "Invalid device type: %u\n", dev_type);
+		return -EINVAL;
+	};
+
+	*regulators = devm_kzalloc(&pdev->dev,
+			sizeof(**regulators) * rdev_num, GFP_KERNEL);
+	if (!*regulators)
+		return -ENOMEM;
+
+	memcpy(*regulators, regulators_init, sizeof(**regulators) * rdev_num);
+
+	return rdev_num;
+}
+
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
-	int i, ret;
+	int i, ret = 0;
+	struct regulator_desc *regulators = NULL;
+	int rdev_num;
 
 	s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
 				GFP_KERNEL);
 	if (!s2mps11)
 		return -ENOMEM;
 
+	rdev_num = s2mps11_pmic_init_regulators_desc(pdev, &regulators);
+	if (rdev_num < 0)
+		return rdev_num;
+
 	if (!iodev->dev->of_node) {
 		if (pdata) {
 			goto common_reg;
@@ -419,24 +459,30 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (i = 0; i < S2MPS11_REGULATOR_CNT; i++)
+	rdata = kzalloc(sizeof(*rdata) * rdev_num, GFP_KERNEL);
+	if (!rdata)
+		return -ENOMEM;
+
+	for (i = 0; i < rdev_num; i++)
 		rdata[i].name = regulators[i].name;
 
 	reg_np = of_find_node_by_name(iodev->dev->of_node, "regulators");
 	if (!reg_np) {
 		dev_err(&pdev->dev, "could not find regulators sub-node\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
-	of_regulator_match(&pdev->dev, reg_np, rdata, S2MPS11_REGULATOR_MAX);
+	of_regulator_match(&pdev->dev, reg_np, rdata, rdev_num);
 
 common_reg:
 	platform_set_drvdata(pdev, s2mps11);
+	s2mps11->rdev_num = rdev_num;
 
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap_pmic;
 	config.driver_data = s2mps11;
-	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
+	for (i = 0; i < rdev_num; i++) {
 		struct regulator_dev *regulator;
 
 		if (!reg_np) {
@@ -453,15 +499,18 @@ common_reg:
 			ret = PTR_ERR(regulator);
 			dev_err(&pdev->dev, "regulator init failed for %d\n",
 				i);
-			return ret;
+			goto out;
 		}
 	}
 
-	return 0;
+out:
+	kfree(rdata);
+
+	return ret;
 }
 
 static const struct platform_device_id s2mps11_pmic_id[] = {
-	{ "s2mps11-pmic", 0},
+	{ "s2mps11-pmic", S2MPS11X},
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, s2mps11_pmic_id);
-- 
1.7.9.5

