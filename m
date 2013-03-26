Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab3CZGuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:50:54 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53744 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759405Ab3CZGux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:50:53 -0400
Message-ID: <1364280647.16881.1.camel@phoenix>
Subject: [PATCH RFC/RFT] regulator: ab8500: Remove is_enabled from struct
 ab8500_regulator_info
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 14:50:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_enabled flag looks not necessary at all, it also introduces some issues
because current code updates info->is_enabled flag in error paths of
ab8500_regulator_enable() and ab8500_regulator_disable().
Thus this patch removes is_enabled from struct ab8500_regulator_info.

This patch also removes info->is_enabled checking in ab8500_regulator_set_mode(),
so it allows setting mode even the regulator is disabled.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
This patch also removes info->is_enabled checking in ab8500_regulator_set_mode().
I'm not very clear if we should avoid setting mode when the regulator is disabled.
It looks to me if we don't want to allow setting mode when regulator is disabled,
this checking should be done in regulator-core.
Seems current code in other regulator drivers does not check if regulator is
enabled or not in set_mode callback implementation.
Axel
 drivers/regulator/ab8500.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 12e2740..8a84b6d 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -30,7 +30,6 @@
  * @dev: device pointer
  * @desc: regulator description
  * @regulator_dev: regulator device
- * @is_enabled: status of regulator (on/off)
  * @load_lp_uA: maximum load in idle (low power) mode
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
@@ -48,7 +47,6 @@ struct ab8500_regulator_info {
 	struct device		*dev;
 	struct regulator_desc	desc;
 	struct regulator_dev	*regulator;
-	bool is_enabled;
 	int load_lp_uA;
 	u8 update_bank;
 	u8 update_reg;
@@ -121,8 +119,6 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set enable bits for regulator\n");
 
-	info->is_enabled = true;
-
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-enable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
@@ -148,8 +144,6 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set disable bits for regulator\n");
 
-	info->is_enabled = false;
-
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-disable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
@@ -202,20 +196,15 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	if (info->is_enabled) {
-		ret = abx500_mask_and_set_register_interruptible(info->dev,
-			info->update_bank, info->update_reg,
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
-	}
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+		info->update_bank, info->update_reg,
+		info->update_mask, info->update_val);
+	if (ret < 0)
+		dev_err(rdev_get_dev(rdev), "couldn't set regulator mode\n");
+
+	dev_vdbg(rdev_get_dev(rdev), "%s-set_mode (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, info->update_val);
 
 	return ret;
 }
@@ -265,12 +254,7 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 		info->desc.name, info->update_bank, info->update_reg,
 		info->update_mask, regval);
 
-	if (regval & info->update_mask)
-		info->is_enabled = true;
-	else
-		info->is_enabled = false;
-
-	return info->is_enabled;
+	return regval & info->update_mask;
 }
 
 static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
-- 
1.7.10.4



