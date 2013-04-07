Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab3DGPMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:12:36 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:54564 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab3DGPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:12:35 -0400
Message-ID: <1365347548.9931.1.camel@phoenix>
Subject: [PATCH 1/4] regulator: ab8500: Get rid of is_enabled from struct
 ab8500_regulator_info
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 07 Apr 2013 23:12:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intention of this patch is to simplify the code.

Maintain the is_enabled flag is not trivial, it not only needs to set/clear the
flag in disable()/enable() but also needs to set the flag in is_enable() to get
initial status. The only benefit of keeping is_enabled flag is just save a
register read when set_mode(). Remove is_enabled flag makes the code simpler.

This patch also moves ab8500_regulator_is_enabled() close to
ab8500_regulator_[en|dis]able functions.
This is required to avoid a forward declaration because now we call
ab8500_regulator_is_enabled() in ab8500_regulator_set_mode().
This change also makes the code better in readability by moving similar
functions to one place.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   72 ++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 517305e..9ebd131 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -46,7 +46,6 @@ struct ab8500_shared_mode {
  * @desc: regulator description
  * @regulator_dev: regulator device
  * @shared_mode: used when mode is shared between two regulators
- * @is_enabled: status of regulator (on/off)
  * @load_lp_uA: maximum load in idle (low power) mode
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
@@ -69,7 +68,6 @@ struct ab8500_regulator_info {
 	struct regulator_desc	desc;
 	struct regulator_dev	*regulator;
 	struct ab8500_shared_mode *shared_mode;
-	bool is_enabled;
 	int load_lp_uA;
 	u8 update_bank;
 	u8 update_reg;
@@ -259,8 +257,6 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 		return ret;
 	}
 
-	info->is_enabled = true;
-
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-enable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
@@ -288,8 +284,6 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 		return ret;
 	}
 
-	info->is_enabled = false;
-
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-disable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
@@ -298,6 +292,37 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 	return ret;
 }
 
+static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	int ret;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval;
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	ret = abx500_get_register_interruptible(info->dev,
+		info->update_bank, info->update_reg, &regval);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"couldn't read 0x%x register\n", info->update_reg);
+		return ret;
+	}
+
+	dev_vdbg(rdev_get_dev(rdev),
+		"%s-is_enabled (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
+		" 0x%x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, regval);
+
+	if (regval & info->update_mask)
+		return 1;
+	else
+		return 0;
+}
+
 static unsigned int ab8500_regulator_get_optimum_mode(
 		struct regulator_dev *rdev, int input_uV,
 		int output_uV, int load_uA)
@@ -398,7 +423,7 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		mask = info->update_mask;
 	}
 
-	if (info->is_enabled || dmr) {
+	if (dmr || ab8500_regulator_is_enabled(rdev)) {
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
 			bank, reg, mask, val);
 		if (ret < 0)
@@ -464,39 +489,6 @@ static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
 	return ret;
 }
 
-static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
-{
-	int ret;
-	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-	u8 regval;
-
-	if (info == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
-		return -EINVAL;
-	}
-
-	ret = abx500_get_register_interruptible(info->dev,
-		info->update_bank, info->update_reg, &regval);
-	if (ret < 0) {
-		dev_err(rdev_get_dev(rdev),
-			"couldn't read 0x%x register\n", info->update_reg);
-		return ret;
-	}
-
-	dev_vdbg(rdev_get_dev(rdev),
-		"%s-is_enabled (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
-		" 0x%x\n",
-		info->desc.name, info->update_bank, info->update_reg,
-		info->update_mask, regval);
-
-	if (regval & info->update_mask)
-		info->is_enabled = true;
-	else
-		info->is_enabled = false;
-
-	return info->is_enabled;
-}
-
 static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
 	int ret, val;
-- 
1.7.10.4



