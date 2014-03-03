Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaCCPyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 10:54:51 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36667 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaCCPyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 10:54:50 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-48-5314a5c5b930
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: s2mps11: Fix section mismatch
Date: Mon, 03 Mar 2014 16:53:51 +0100
Message-id: <1393862031-4896-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xa7pHl4oEG6w6I2exccZ6VoupD5+w
	Wbx/vp7Z4vULQ4uzTW/YLb5d6WCyuLxrDpvF2iN32S0urvjCZLF+xmsWi7m/G1kduD12zrrL
	7rF4z0smj02rOtk8+rasYvT4vEkugDWKyyYlNSezLLVI3y6BK+PZzemsBdcUKlZ1v2FuYPwr
	1cXIySEhYCIx5fl5JghbTOLCvfVsXYxcHEICSxkl1j7/DeX0MUn87/rJCFLFJmAssXn5ErCE
	iEAPo8TLrZ+ZQRxmgQNMEndbVrN3MXJwCAtYShw5rAnSwCKgKjGpaQs7iM0r4CaxaOJuNpAS
	CQEFiTmTbCYwci9gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERJMX3cwLj1mdYhRgINR
	iYfXYYpIsBBrYllxZe4hRgkOZiUR3ogaoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGG1e2bp7J
	vlogZ/UEnua4rFlmoUtaOqTsHvsLHY2fyr5dnctUfpJCsryzdP7O9XwzbHs3vr/k6FDv4Sub
	o+tdP73mQZ0732bjlIxrf7UfrSi7yqH+Vbxg1V73NTOdv76WWTVHV8Wp+lZv14lrSnl8xbEt
	mnuKujybtPdJ/Q3Y8yl+S04Bl5oSS3FGoqEWc1FxIgBNEOcpBAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __initconst from regulator_desc array because this array is used
during probe and s2mps11_pmic_probe() is not in __init section. However
still select the number of supported regulators according to device ID
so the driver will be ready for adding support for S2MPS14 device.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mps11.c |   63 ++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 46 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index ca66fc56fa58..ca876de72eae 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -342,7 +342,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-static const struct regulator_desc s2mps11_regulators[] __initconst = {
+static const struct regulator_desc s2mps11_regulators[] = {
 	regulator_desc_ldo2(1),
 	regulator_desc_ldo1(2),
 	regulator_desc_ldo1(3),
@@ -393,41 +393,6 @@ static const struct regulator_desc s2mps11_regulators[] __initconst = {
 	regulator_desc_buck10,
 };
 
-/*
- * Allocates memory under 'regulators' pointer and copies there array
- * of regulator_desc for given device.
- *
- * Returns number of regulators or negative ERRNO on error.
- */
-static int __init
-s2mps11_pmic_init_regulators_desc(struct platform_device *pdev,
-		struct regulator_desc **regulators)
-{
-	const struct regulator_desc *regulators_init;
-	enum sec_device_type dev_type;
-	int rdev_num;
-
-	dev_type = platform_get_device_id(pdev)->driver_data;
-	switch (dev_type) {
-	case S2MPS11X:
-		rdev_num = ARRAY_SIZE(s2mps11_regulators);
-		regulators_init = s2mps11_regulators;
-		break;
-	default:
-		dev_err(&pdev->dev, "Invalid device type: %u\n", dev_type);
-		return -EINVAL;
-	};
-
-	*regulators = devm_kzalloc(&pdev->dev,
-			sizeof(**regulators) * rdev_num, GFP_KERNEL);
-	if (!*regulators)
-		return -ENOMEM;
-
-	memcpy(*regulators, regulators_init, sizeof(**regulators) * rdev_num);
-
-	return rdev_num;
-}
-
 static int s2mps11_pmic_probe(struct platform_device *pdev)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
@@ -437,17 +402,24 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	struct s2mps11_info *s2mps11;
 	int i, ret = 0;
-	struct regulator_desc *regulators = NULL;
-	int rdev_num;
+	const struct regulator_desc *regulators;
+	enum sec_device_type dev_type;
 
 	s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
 				GFP_KERNEL);
 	if (!s2mps11)
 		return -ENOMEM;
 
-	rdev_num = s2mps11_pmic_init_regulators_desc(pdev, &regulators);
-	if (rdev_num < 0)
-		return rdev_num;
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
 
 	if (!iodev->dev->of_node) {
 		if (pdata) {
@@ -459,11 +431,11 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
-	rdata = kzalloc(sizeof(*rdata) * rdev_num, GFP_KERNEL);
+	rdata = kzalloc(sizeof(*rdata) * s2mps11->rdev_num, GFP_KERNEL);
 	if (!rdata)
 		return -ENOMEM;
 
-	for (i = 0; i < rdev_num; i++)
+	for (i = 0; i < s2mps11->rdev_num; i++)
 		rdata[i].name = regulators[i].name;
 
 	reg_np = of_find_node_by_name(iodev->dev->of_node, "regulators");
@@ -473,16 +445,15 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	of_regulator_match(&pdev->dev, reg_np, rdata, rdev_num);
+	of_regulator_match(&pdev->dev, reg_np, rdata, s2mps11->rdev_num);
 
 common_reg:
 	platform_set_drvdata(pdev, s2mps11);
-	s2mps11->rdev_num = rdev_num;
 
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap_pmic;
 	config.driver_data = s2mps11;
-	for (i = 0; i < rdev_num; i++) {
+	for (i = 0; i < s2mps11->rdev_num; i++) {
 		struct regulator_dev *regulator;
 
 		if (!reg_np) {
-- 
1.7.9.5

