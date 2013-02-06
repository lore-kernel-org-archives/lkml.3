Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3BFLGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:06:37 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:48220 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab3BFKyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:50 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/49] regulator: ab8500-ext: Cosmetic changes
Date: Wed,  6 Feb 2013 10:53:32 +0000
Message-Id: <1360148051-7560-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable is renamed in driver. Some comments are added.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500-ext.c   |   22 +++++++++++-----------
 include/linux/regulator/ab8500.h |    2 ++
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 5f6ac8a..2157c11 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -27,7 +27,7 @@
  * struct ab8500_ext_regulator_info - ab8500 regulator information
  * @dev: device pointer
  * @desc: regulator description
- * @regulator_dev: regulator device
+ * @rdev: regulator device
  * @is_enabled: status of regulator (on/off)
  * @fixed_uV: typical voltage (for fixed voltage supplies)
  * @update_bank: bank to control on/off
@@ -43,7 +43,7 @@
 struct ab8500_ext_regulator_info {
 	struct device *dev;
 	struct regulator_desc desc;
-	struct regulator_dev *regulator;
+	struct regulator_dev *rdev;
 	bool is_enabled;
 	int fixed_uV;
 	u8 update_bank;
@@ -68,7 +68,7 @@ static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
 		info->update_bank, info->update_reg,
 		info->update_mask, info->update_val);
 	if (ret < 0)
-		dev_err(rdev_get_dev(rdev),
+		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set enable bits for regulator\n");
 
 	info->is_enabled = true;
@@ -95,7 +95,7 @@ static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
 		info->update_bank, info->update_reg,
 		info->update_mask, 0x0);
 	if (ret < 0)
-		dev_err(rdev_get_dev(rdev),
+		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set disable bits for regulator\n");
 
 	info->is_enabled = false;
@@ -347,21 +347,21 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		info->dev = &pdev->dev;
 
 		/* register regulator with framework */
-		info->regulator = regulator_register(&info->desc, &pdev->dev,
+		info->rdev = regulator_register(&info->desc, &pdev->dev,
 				&pdata->ext_regulator[i], info, NULL);
-		if (IS_ERR(info->regulator)) {
-			err = PTR_ERR(info->regulator);
+		if (IS_ERR(info->rdev)) {
+			err = PTR_ERR(info->rdev);
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 					info->desc.name);
 			/* when we fail, un-register all earlier regulators */
 			while (--i >= 0) {
 				info = &ab8500_ext_regulator_info[i];
-				regulator_unregister(info->regulator);
+				regulator_unregister(info->rdev);
 			}
 			return err;
 		}
 
-		dev_dbg(rdev_get_dev(info->regulator),
+		dev_dbg(rdev_get_dev(info->rdev),
 			"%s-probed\n", info->desc.name);
 	}
 
@@ -376,10 +376,10 @@ int ab8500_ext_regulator_exit(struct platform_device *pdev)
 		struct ab8500_ext_regulator_info *info = NULL;
 		info = &ab8500_ext_regulator_info[i];
 
-		dev_vdbg(rdev_get_dev(info->regulator),
+		dev_vdbg(rdev_get_dev(info->rdev),
 			"%s-remove\n", info->desc.name);
 
-		regulator_unregister(info->regulator);
+		regulator_unregister(info->rdev);
 	}
 
 	return 0;
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 6de36b5..cefd9de 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -162,6 +162,7 @@ enum ab8500_ext_regulator_id {
 	AB8500_NUM_EXT_REGULATORS,
 };
 
+/* AB8500 regulator platform data */
 struct ab8500_regulator_platform_data {
 	int num_reg_init;
 	struct ab8500_regulator_reg_init *reg_init;
@@ -171,6 +172,7 @@ struct ab8500_regulator_platform_data {
 	struct regulator_init_data *ext_regulator;
 };
 
+/* AB8500 external regulator functions (internal) */
 #ifdef CONFIG_REGULATOR_AB8500_EXT
 int ab8500_ext_regulator_init(struct platform_device *pdev);
 int ab8500_ext_regulator_exit(struct platform_device *pdev);
-- 
1.7.9.5

