Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935939Ab3DJM4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:56:39 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:35241 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab3DJM4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:56:38 -0400
Message-ID: <1365598592.24689.3.camel@phoenix>
Subject: [RFT][PATCH 3/3] regulator: ab8500-ext: Remove enable() and
 disable() functions
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 20:56:32 +0800
In-Reply-To: <1365598464.24689.1.camel@phoenix>
References: <1365598464.24689.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both enable() and disable() functions have only one caller, thus remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500-ext.c |   62 ++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 1efe702..dd582be 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -54,32 +54,44 @@ struct ab8500_ext_regulator_info {
 	u8 update_val_hw;
 };
 
-static int enable(struct ab8500_ext_regulator_info *info, u8 *regval)
+static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
 {
 	int ret;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval;
 
-	*regval = info->update_val;
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
 
 	/*
 	 * To satisfy both HW high power request and SW request, the regulator
 	 * must be on in high power.
 	 */
 	if (info->cfg && info->cfg->hwreq)
-		*regval = info->update_val_hp;
+		regval = info->update_val_hp;
+	else
+		regval = info->update_val;
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
-		info->update_mask, *regval);
+		info->update_mask, regval);
 	if (ret < 0) {
 		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set enable bits for regulator\n");
 		return ret;
 	}
 
-	return ret;
+	dev_dbg(rdev_get_dev(rdev), "%s-enable (bank, reg, mask, value):"
+		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, regval);
+
+	return 0;
 }
 
-static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
+static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
 {
 	int ret;
 	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
@@ -90,53 +102,23 @@ static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
 		return -EINVAL;
 	}
 
-	ret = enable(info, &regval);
-
-	dev_dbg(rdev_get_dev(rdev), "%s-enable (bank, reg, mask, value):"
-		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
-		info->desc.name, info->update_bank, info->update_reg,
-		info->update_mask, regval);
-
-	return ret;
-}
-
-static int disable(struct ab8500_ext_regulator_info *info, u8 *regval)
-{
-	int ret;
-
-	*regval = 0x0;
-
 	/*
 	 * Set the regulator in HW request mode if configured
 	 */
 	if (info->cfg && info->cfg->hwreq)
-		*regval = info->update_val_hw;
+		regval = info->update_val_hw;
+	else
+		regval = 0;
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
-		info->update_mask, *regval);
+		info->update_mask, regval);
 	if (ret < 0) {
 		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set disable bits for regulator\n");
 		return ret;
 	}
 
-	return ret;
-}
-
-static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
-{
-	int ret;
-	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
-	u8 regval;
-
-	if (info == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
-		return -EINVAL;
-	}
-
-	ret = disable(info, &regval);
-
 	dev_dbg(rdev_get_dev(rdev), "%s-disable (bank, reg, mask, value):"
 		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
 		info->desc.name, info->update_bank, info->update_reg,
-- 
1.7.10.4



