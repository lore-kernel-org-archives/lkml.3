Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3C1IkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:40:25 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52454 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3C1IkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:40:22 -0400
Message-ID: <1364460015.10816.2.camel@phoenix>
Subject: [PATCH] regulator: ab8500: Update info->update_val only when
 successfully update register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 16:40:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes 2 issues:

1. Don't update info->update_val if write to the register fails.
2. Don't update info->update_val if regulator is disabled, this avoid
   inconsistent status between the register value and info->update_val.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 12e2740..8b86604 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -182,8 +182,8 @@ static unsigned int ab8500_regulator_get_optimum_mode(
 static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
-	int ret = 0;
-
+	int ret;
+	u8 update_val;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
 	if (info == NULL) {
@@ -191,32 +191,41 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
+	/* ab8500 regulators share mode and enable in the same register bits.
+	   off = 0b00
+	   low power mode= 0b11
+	   full powermode = 0b01
+	   (HW control mode = 0b10)
+	   Thus we don't change the mode settings when regulator is disabled.
+	 */
+	if (!info->is_enabled)
+		return 0;
+
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
-		info->update_val = info->update_val_normal;
+		update_val = info->update_val_normal;
 		break;
 	case REGULATOR_MODE_IDLE:
-		info->update_val = info->update_val_idle;
+		update_val = info->update_val_idle;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (info->is_enabled) {
-		ret = abx500_mask_and_set_register_interruptible(info->dev,
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
 			info->update_bank, info->update_reg,
-			info->update_mask, info->update_val);
-		if (ret < 0)
-			dev_err(rdev_get_dev(rdev),
-				"couldn't set regulator mode\n");
-
-		dev_vdbg(rdev_get_dev(rdev),
-			"%s-set_mode (bank, reg, mask, value): "
-			"0x%x, 0x%x, 0x%x, 0x%x\n",
-			info->desc.name, info->update_bank, info->update_reg,
-			info->update_mask, info->update_val);
+			info->update_mask, update_val);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev), "couldn't set regulator mode\n");
+		return ret;
 	}
 
+	info->update_val = update_val;
+
+	dev_vdbg(rdev_get_dev(rdev), "%s-set_mode (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		 info->desc.name, info->update_bank, info->update_reg,
+		 info->update_mask, info->update_val);
+
 	return ret;
 }
 
-- 
1.7.10.4



