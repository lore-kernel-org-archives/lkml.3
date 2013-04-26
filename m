Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3DZN5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:57:16 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45923 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3DZN5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:57:15 -0400
Message-ID: <1366984629.31523.1.camel@phoenix>
Subject: [PATCH] regulator: ab3100: Fix regulator register error handling
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 26 Apr 2013 21:57:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure to unregister all regulators before return error in probe().

The regulator register order depends on the regulator ID pass to
ab3100_regulator_register() function. Thus we need to scan ab3100_regulator_desc
and find the index of successfully registered regulators, or alternatively just
call ab3100_regulators_remove() to unregister all registered regulators.

Since current code uses a static ab3100_regulators table, explicitly set
reg->rdev = NULL after regulator_unregister() call to ensure calling
ab3100_regulators_remove() in the unwind path always work.

Also move ab3100_regulators_remove() to avoid forward declaration.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab3100.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index be1e6ad..3be9e46 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -609,6 +609,19 @@ static const u8 ab3100_reg_initvals[] = {
 	LDO_D_SETTING,
 };
 
+static int ab3100_regulators_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < AB3100_NUM_REGULATORS; i++) {
+		struct ab3100_regulator *reg = &ab3100_regulators[i];
+
+		regulator_unregister(reg->rdev);
+		reg->rdev = NULL;
+	}
+	return 0;
+}
+
 static int
 ab3100_regulator_of_probe(struct platform_device *pdev, struct device_node *np)
 {
@@ -635,8 +648,10 @@ ab3100_regulator_of_probe(struct platform_device *pdev, struct device_node *np)
 			pdev, NULL, ab3100_regulator_matches[i].init_data,
 			ab3100_regulator_matches[i].of_node,
 			(int) ab3100_regulator_matches[i].driver_data);
-		if (err)
+		if (err) {
+			ab3100_regulators_remove(pdev);
 			return err;
+		}
 	}
 
 	return 0;
@@ -695,25 +710,15 @@ static int ab3100_regulators_probe(struct platform_device *pdev)
 
 		err = ab3100_regulator_register(pdev, plfdata, NULL, NULL,
 						desc->id);
-		if (err)
+		if (err) {
+			ab3100_regulators_remove(pdev);
 			return err;
+		}
 	}
 
 	return 0;
 }
 
-static int ab3100_regulators_remove(struct platform_device *pdev)
-{
-	int i;
-
-	for (i = 0; i < AB3100_NUM_REGULATORS; i++) {
-		struct ab3100_regulator *reg = &ab3100_regulators[i];
-
-		regulator_unregister(reg->rdev);
-	}
-	return 0;
-}
-
 static struct platform_driver ab3100_regulators_driver = {
 	.driver = {
 		.name  = "ab3100-regulators",
-- 
1.7.10.4



