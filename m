Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaCJIdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:33:05 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17532 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaCJIdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:33:00 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b0-531d78ba18aa
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/8] regulator: max77693: Remove state container as it is not
 needed
Date: Mon, 10 Mar 2014 09:32:46 +0100
Message-id: <1394440371-29588-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJMWRmVeSWpSXmKPExsVy+t/xK7q7KmSDDU7+VLGY+vAJm8XrF4YW
	3650MFlc3jWHzYHFY+esu+wem1Z1snn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxosDH5gK
	XopW3Jq0irmBsV2oi5GTQ0LAROJH1yM2CFtM4sK99UA2F4eQwFJGiXcTHzBBOH1MEvuuL2QG
	qWITMJbYvHwJWIeIQIbE5nlTWUFsZgFDiZ/v/rB3MXJwCAuESbQerAQJswioSly6u5kFxOYV
	cJf49PMkG0iJhICCxJxJNiBhTgEPiUV7brGD2EJAJbs7d7BMYORdwMiwilE0tTS5oDgpPddI
	rzgxt7g0L10vOT93EyMkUL7uYFx6zOoQowAHoxIP74G3MsFCrIllxZW5hxglOJiVRHgz4mSD
	hXhTEiurUovy44tKc1KLDzEycXBKNTBms534mfHyybpsvvBQydCZy1KPf5O87XXv4geO1HvP
	Q7df4Njek3Gw8g9/aqjk9Pa21NCpbxWdFRQunjiWy+FR+qhwUmC1CePpnyc4Pq1gs30jN/Fj
	97XIx4/YPbpFhEWXhLDd+SoyJeWWs3yts6pOo/ippQzTE+UXxiZ+tcta8N5mTWSh/zIlluKM
	REMt5qLiRAC5dkJp8gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't store pointers to regulator_dev returned by
devm_regulator_register() in allocated memory in state container. They
aren't used anywhere outside of max77693_pmic_probe() function.

This change allows removing completely the 'struct max77693_pmic_dev'
state container as none of its fields are used outside of probe.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77693.c |   37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index 5fb899f461d0..4352924bfb98 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -34,13 +34,6 @@
 
 #define CHGIN_ILIM_STEP_20mA			20000
 
-struct max77693_pmic_dev {
-	struct device *dev;
-	struct max77693_dev *iodev;
-	int num_regulators;
-	struct regulator_dev **rdev;
-};
-
 /* CHARGER regulator ops */
 /* CHARGER regulator uses two bits for enabling */
 static int max77693_chg_is_enabled(struct regulator_dev *rdev)
@@ -229,7 +222,6 @@ static int max77693_pmic_init_rdata(struct device *dev,
 static int max77693_pmic_probe(struct platform_device *pdev)
 {
 	struct max77693_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max77693_pmic_dev *max77693_pmic;
 	struct max77693_regulator_data *rdata = NULL;
 	int num_rdata, i;
 	struct regulator_config config;
@@ -240,39 +232,22 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	max77693_pmic = devm_kzalloc(&pdev->dev,
-				sizeof(struct max77693_pmic_dev),
-				GFP_KERNEL);
-	if (!max77693_pmic)
-		return -ENOMEM;
-
-	max77693_pmic->rdev = devm_kzalloc(&pdev->dev,
-				sizeof(struct regulator_dev *) * num_rdata,
-				GFP_KERNEL);
-	if (!max77693_pmic->rdev)
-		return -ENOMEM;
-
-	max77693_pmic->dev = &pdev->dev;
-	max77693_pmic->iodev = iodev;
-	max77693_pmic->num_regulators = num_rdata;
-
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap;
-	config.driver_data = max77693_pmic;
-	platform_set_drvdata(pdev, max77693_pmic);
 
-	for (i = 0; i < max77693_pmic->num_regulators; i++) {
+	for (i = 0; i < num_rdata; i++) {
 		int id = rdata[i].id;
+		struct regulator_dev *rdev;
 
 		config.init_data = rdata[i].initdata;
 		config.of_node = rdata[i].of_node;
 
-		max77693_pmic->rdev[i] = devm_regulator_register(&pdev->dev,
+		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[id], &config);
-		if (IS_ERR(max77693_pmic->rdev[i])) {
-			dev_err(max77693_pmic->dev,
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev,
 				"Failed to initialize regulator-%d\n", id);
-			return PTR_ERR(max77693_pmic->rdev[i]);
+			return PTR_ERR(rdev);
 		}
 	}
 
-- 
1.7.9.5

