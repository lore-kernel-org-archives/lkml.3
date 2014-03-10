Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaCJIf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:35:27 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14371 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaCJIdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:33:00 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-aa-531d78bab319
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/8] regulator: max77686: Remove regulator_dev array from state
 container
Date: Mon, 10 Mar 2014 09:32:45 +0100
Message-id: <1394440371-29588-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t/xK7q7KmSDDWZWWUx9+ITN4vULQ4tv
	VzqYLC7vmsPmwOKxc9Zddo9NqzrZPPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvjwsTrLAUL
	uCt+/93L2MC4krOLkZNDQsBEovH4KzYIW0ziwr31QDYXh5DAUkaJP5unMUM4fUwSMz8sYQSp
	YhMwlti8fAlYh4hAhsTmeVNZQWxmAUOJn+/+sHcxcnAIC0RLTLsjDhJmEVCV2HfmOROIzSvg
	LrFsag8jSImEgILEnEk2IGFOAQ+JRXtusYPYQkAluzt3sExg5F3AyLCKUTS1NLmgOCk910iv
	ODG3uDQvXS85P3cTIyRMvu5gXHrM6hCjAAejEg/vgbcywUKsiWXFlbmHGCU4mJVEeDPiZIOF
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MKrydC946uTL+d/teUW1+0/FySJ/TKYp8drmbKl81vum
	t6JxezBXo+ccTsGEZWLbZdx9Qzg7jh6ffFv7+ft7CnrrhFV31U+Si5jw8+3Olw+OfNRadbM2
	P1W6zSNqrr+rXaM+c6fqM5d1NoK+5vXyXt3mbx6HntlsYnVcOCNEc+fBFydCvzpMVGIpzkg0
	1GIuKk4EAEks7pvxAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't store array of regulator_dev returned by devm_regulator_register()
in state container. It isn't used anywhere outside of
max77686_pmic_probe() function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index ae001ccf26f4..a46e9af21f36 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -65,7 +65,6 @@ enum max77686_ramp_rate {
 };
 
 struct max77686_data {
-	struct regulator_dev *rdev[MAX77686_REGULATORS];
 	unsigned int opmode[MAX77686_REGULATORS];
 };
 
@@ -474,16 +473,18 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, max77686);
 
 	for (i = 0; i < MAX77686_REGULATORS; i++) {
+		struct regulator_dev *rdev;
+
 		config.init_data = pdata->regulators[i].initdata;
 		config.of_node = pdata->regulators[i].of_node;
 
 		max77686->opmode[i] = regulators[i].enable_mask;
-		max77686->rdev[i] = devm_regulator_register(&pdev->dev,
+		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
-		if (IS_ERR(max77686->rdev[i])) {
+		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev,
 				"regulator init failed for %d\n", i);
-			return PTR_ERR(max77686->rdev[i]);
+			return PTR_ERR(rdev);
 		}
 	}
 
-- 
1.7.9.5

