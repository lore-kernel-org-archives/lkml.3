Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3CUQBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:01:06 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50267 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933742Ab3CUQBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:01:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Mustapha Ben Zoubeir 
	<mustapha.ben.zoubeir-nonst@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/46] regulator: ab8500: Delete useless fixed_uV field
Date: Thu, 21 Mar 2013 15:59:25 +0000
Message-Id: <1363881583-15234-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mustapha Ben Zoubeir <mustapha.ben.zoubeir-nonst@stericsson.com>

The fixed_uV property residing in ab8500_ext_regulator_info is
currently unused. We remove it here.

Signed-off-by: Mustapha Ben Zoubeir <mustapha.ben.zoubeir-nonst@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Daniel WILLERUD <daniel.willerud@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Tested-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/regulator/ab8500-ext.c |   45 ++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index e5e6453..f75d4f7 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -30,7 +30,6 @@
  * @rdev: regulator device
  * @cfg: regulator configuration (extension of regulator FW configuration)
  * @is_enabled: status of regulator (on/off)
- * @fixed_uV: typical voltage (for fixed voltage supplies)
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
  * @update_mask: mask to enable/disable and set mode of regulator
@@ -48,7 +47,6 @@ struct ab8500_ext_regulator_info {
 	struct regulator_dev *rdev;
 	struct ab8500_ext_regulator_cfg *cfg;
 	bool is_enabled;
-	int fixed_uV;
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
@@ -259,30 +257,33 @@ static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)
 
 static int ab8500_ext_fixed_get_voltage(struct regulator_dev *rdev)
 {
-	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+	struct regulation_constraints *regu_constraints = rdev->constraints;
 
-	if (info == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+	if (regu_constraints == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator constraints null pointer\n");
 		return -EINVAL;
 	}
-
-	return info->fixed_uV;
+	if (regu_constraints->min_uV && regu_constraints->max_uV) {
+		if (regu_constraints->min_uV == regu_constraints->max_uV)
+			return regu_constraints->min_uV;
+	}
+	return -EINVAL;
 }
 
 static int ab8500_ext_list_voltage(struct regulator_dev *rdev,
 				   unsigned selector)
 {
-	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+	struct regulation_constraints *regu_constraints = rdev->constraints;
 
-	if (info == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+	if (regu_constraints == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator constraints null pointer\n");
 		return -EINVAL;
 	}
-
 	/* return the uV for the fixed regulators */
-	if (info->fixed_uV)
-		return info->fixed_uV;
-
+	if (regu_constraints->min_uV && regu_constraints->max_uV) {
+		if (regu_constraints->min_uV == regu_constraints->max_uV)
+			return regu_constraints->min_uV;
+	}
 	return -EINVAL;
 }
 
@@ -319,7 +320,6 @@ static struct ab8500_ext_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
-		.fixed_uV		= 1800000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x08,
 		.update_mask		= 0x03,
@@ -337,7 +337,6 @@ static struct ab8500_ext_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
-		.fixed_uV		= 1360000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x08,
 		.update_mask		= 0x0c,
@@ -355,7 +354,6 @@ static struct ab8500_ext_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
-		.fixed_uV		= 3400000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x08,
 		.update_mask		= 0x30,
@@ -417,17 +415,14 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 			pdata->ext_regulator[i].driver_data;
 
 		if (is_ab9540(ab8500)) {
-			if (info->desc.id == AB8500_EXT_SUPPLY1) {
+			if (info->desc.id == AB8500_EXT_SUPPLY1)
 				info->desc.ops = &ab9540_ext_regulator_ops;
-				info->fixed_uV = 4500000;
-			}
-			if (info->desc.id == AB8500_EXT_SUPPLY2)
-				info->desc.ops = &ab9540_ext_regulator_ops;
-
-			if (info->desc.id == AB8500_EXT_SUPPLY3) {
+			if (info->desc.id == AB8500_EXT_SUPPLY2) {
 				info->desc.ops = &ab9540_ext_regulator_ops;
-				info->fixed_uV = 3300000;
+				info->desc.n_voltages = 0;
 			}
+			if (info->desc.id == AB8500_EXT_SUPPLY3)
+				info->desc.ops = &ab9540_ext_regulator_ops;
 		}
 
 		/* register regulator with framework */
-- 
1.7.10.4

