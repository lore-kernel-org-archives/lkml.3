Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3BDMNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:13:25 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:57335 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3BDL4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 16/73] regulator: ab8500-ext: Cosmetic changes
Date: Mon,  4 Feb 2013 11:53:31 +0000
Message-Id: <1359978868-28736-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Variable is renamed in driver. Some comments are added.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias NILSSON <mattias.i.nilsson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    2 +-
 drivers/regulator/ab8500-ext.c                |   22 +++++++++++-----------
 include/linux/regulator/ab8500.h              |    2 ++
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index c58fc86..72fb449 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -280,7 +280,7 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	/*
 	 * VextSupply1Regu          = HW control
 	 * VextSupply2Regu          = HW control
-	 * VextSupply3Regu          = HW control
+	 * VextSupply3Regu          = force HP (-> STBB2=LP and TPS=LP)
 	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
 	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
 	 */
diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index ffcb96e..aa55a05 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -28,7 +28,7 @@
  * struct ab8500_ext_regulator_info - ab8500 regulator information
  * @dev: device pointer
  * @desc: regulator description
- * @regulator_dev: regulator device
+ * @rdev: regulator device
  * @is_enabled: status of regulator (on/off)
  * @fixed_uV: typical voltage (for fixed voltage supplies)
  * @update_bank: bank to control on/off
@@ -44,7 +44,7 @@
 struct ab8500_ext_regulator_info {
 	struct device *dev;
 	struct regulator_desc desc;
-	struct regulator_dev *regulator;
+	struct regulator_dev *rdev;
 	bool is_enabled;
 	int fixed_uV;
 	u8 update_bank;
@@ -69,7 +69,7 @@ static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
 		info->update_bank, info->update_reg,
 		info->update_mask, info->update_val);
 	if (ret < 0)
-		dev_err(rdev_get_dev(rdev),
+		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set enable bits for regulator\n");
 
 	info->is_enabled = true;
@@ -96,7 +96,7 @@ static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
 		info->update_bank, info->update_reg,
 		info->update_mask, 0x0);
 	if (ret < 0)
-		dev_err(rdev_get_dev(rdev),
+		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set disable bits for regulator\n");
 
 	info->is_enabled = false;
@@ -249,21 +249,21 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
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
 
@@ -278,10 +278,10 @@ int ab8500_ext_regulator_exit(struct platform_device *pdev)
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
index 63d2c4e..e9522c9 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -160,6 +160,7 @@ enum ab8500_ext_regulator_id {
 	AB8500_NUM_EXT_REGULATORS,
 };
 
+/* AB8500 regulator platform data */
 struct ab8500_regulator_platform_data {
 	int num_reg_init;
 	struct ab8500_regulator_reg_init *reg_init;
@@ -169,6 +170,7 @@ struct ab8500_regulator_platform_data {
 	struct regulator_init_data *ext_regulator;
 };
 
+/* AB8500 external regulator functions (internal) */
 #ifdef CONFIG_REGULATOR_AB8500_EXT
 int ab8500_ext_regulator_init(struct platform_device *pdev);
 int ab8500_ext_regulator_exit(struct platform_device *pdev);
-- 
1.7.9.5

