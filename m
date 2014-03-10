Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaCJIdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:33:07 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17382 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCJIdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:33:01 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b8-531d78bbc8ea
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 5/8] regulator: max8907: Remove regulator_dev array from state
 container
Date: Mon, 10 Mar 2014 09:32:48 +0100
Message-id: <1394440371-29588-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t/xK7q7K2SDDVZcMLOY+vAJm8XrF4YW
	3650MFlc3jWHzYHFY+esu+wem1Z1snn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxqnn/9gL
	JvFU7F16mrWB8T9nFyMnh4SAicSE7ocsELaYxIV769m6GLk4hASWMkpcP/GSFcLpY5JY/aqb
	EaSKTcBYYvPyJWwgtohAhsTmeVNZQWxmAUOJn+/+sIPYwgJREvvPP2YGsVkEVCXOPr8GFucV
	cJdoOdzF1MXIAbRNQWLOJBuQMKeAh8SiPbfASoSASnZ37mCZwMi7gJFhFaNoamlyQXFSeq6R
	XnFibnFpXrpecn7uJkZIqHzdwbj0mNUhRgEORiUe3gNvZYKFWBPLiitzDzFKcDArifBmxMkG
	C/GmJFZWpRblxxeV5qQWH2Jk4uCUamCUFug46bky6uK0FElbk/usClJTwhddtPOW7UlivJ2v
	ofb9+wHrfQabatO4r/0oOBzAo2o2T2GVhIzC65AXkxm3rghh3+trYC8oI3P+Z3jq1rcJUn82
	aTNf2es+VSaqKHVZ8ZeWLvbzHhPvvHKbn6V9OnH7hEe/NPafYM23fjs5WWeyN5OtX7wSS3FG
	oqEWc1FxIgDIGRZs8wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't store array of regulator_dev returned by devm_regulator_register()
in state container. It isn't used anywhere outside of
max8907_regulator_probe() function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max8907-regulator.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index 0c5fe6c6ac26..58959ee0249b 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -34,7 +34,6 @@
 
 struct max8907_regulator {
 	struct regulator_desc desc[MAX8907_NUM_REGULATORS];
-	struct regulator_dev *rdev[MAX8907_NUM_REGULATORS];
 };
 
 #define REG_MBATT() \
@@ -311,6 +310,8 @@ static int max8907_regulator_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < MAX8907_NUM_REGULATORS; i++) {
+		struct regulator_dev *rdev;
+
 		config.dev = pdev->dev.parent;
 		if (pdata)
 			idata = pdata->init_data[i];
@@ -350,13 +351,13 @@ static int max8907_regulator_probe(struct platform_device *pdev)
 				pmic->desc[i].ops = &max8907_out5v_hwctl_ops;
 		}
 
-		pmic->rdev[i] = devm_regulator_register(&pdev->dev,
+		rdev = devm_regulator_register(&pdev->dev,
 						&pmic->desc[i], &config);
-		if (IS_ERR(pmic->rdev[i])) {
+		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev,
 				"failed to register %s regulator\n",
 				pmic->desc[i].name);
-			return PTR_ERR(pmic->rdev[i]);
+			return PTR_ERR(rdev);
 		}
 	}
 
-- 
1.7.9.5

