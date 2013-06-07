Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3FGQNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:13:04 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51613 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab3FGQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:12:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/10] regulator: ab8500-ext: Enable for Device Tree
Date: Fri,  7 Jun 2013 17:11:27 +0100
Message-Id: <1370621488-18130-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we use the OF regulator match facility to collect and populate
initialisation data from Device Tree if we're booting with it enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500-ext.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 95f495f..4137a2f 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -16,9 +16,11 @@
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
@@ -333,18 +335,37 @@ static struct ab8500_ext_regulator_info
 	},
 };
 
+static struct of_regulator_match ab8500_ext_regulator_match[] = {
+	{ .name = "ab8500_ext1", .driver_data = (void *) AB8500_EXT_SUPPLY1, },
+	{ .name = "ab8500_ext2", .driver_data = (void *) AB8500_EXT_SUPPLY2, },
+	{ .name = "ab8500_ext3", .driver_data = (void *) AB8500_EXT_SUPPLY3, },
+};
+
 int ab8500_ext_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *ppdata;
 	struct ab8500_regulator_platform_data *pdata;
+	struct device_node *np = pdev->dev.of_node;
 	struct regulator_config config = { };
 	int i, err;
 
+	if (np) {
+		err = of_regulator_match(&pdev->dev, np,
+					 ab8500_ext_regulator_match,
+					 ARRAY_SIZE(ab8500_ext_regulator_match));
+		if (err < 0) {
+			dev_err(&pdev->dev,
+				"Error parsing regulator init data: %d\n", err);
+			return err;
+		}
+	}
+
 	if (!ab8500) {
 		dev_err(&pdev->dev, "null mfd parent\n");
 		return -EINVAL;
 	}
+
 	ppdata = dev_get_platdata(ab8500->dev);
 	if (!ppdata) {
 		dev_err(&pdev->dev, "null parent pdata\n");
@@ -385,8 +406,11 @@ int ab8500_ext_regulator_probe(struct platform_device *pdev)
 			pdata->ext_regulator[i].driver_data;
 
 		config.dev = &pdev->dev;
-		config.init_data = &pdata->ext_regulator[i];
 		config.driver_data = info;
+		config.of_node = ab8500_ext_regulator_match[i].of_node;
+		config.init_data = (np) ?
+			ab8500_ext_regulator_match[i].init_data :
+			&pdata->ext_regulator[i];
 
 		/* register regulator with framework */
 		info->rdev = regulator_register(&info->desc, &config);
-- 
1.7.10.4

