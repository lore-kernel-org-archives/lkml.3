Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3C1JXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:23:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48504 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3C1JXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:23:07 -0400
Message-ID: <1364462580.17483.1.camel@phoenix>
Subject: [PATCH RFT v2] regulator: ab8500: Update info->update_val only when
 successfully update register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 17:23:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't update info->update_val if write to the register fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2:
On the second thought, I think it's ok to update info->update_val when
regulator is disabled, the mode will change when the regulator is enabled.

Hi Bengt,
I just got your Ack for v1.
Can you review this v2 again, and let Mark know which version do you prefer.

Thanks.
Axel
 drivers/regulator/ab8500.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 12e2740..7814ac3 100644
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
@@ -193,31 +193,42 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 
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
 
+	/* ab8500 regulators share mode and enable in the same register bits.
+	   off = 0b00
+	   low power mode= 0b11
+	   full powermode = 0b01
+	   (HW control mode = 0b10)
+	   Thus we don't write to the register when regulator is disabled.
+	*/
 	if (info->is_enabled) {
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
 			info->update_bank, info->update_reg,
-			info->update_mask, info->update_val);
-		if (ret < 0)
+			info->update_mask, update_val);
+		if (ret < 0) {
 			dev_err(rdev_get_dev(rdev),
 				"couldn't set regulator mode\n");
+			return ret;
+		}
 
 		dev_vdbg(rdev_get_dev(rdev),
 			"%s-set_mode (bank, reg, mask, value): "
 			"0x%x, 0x%x, 0x%x, 0x%x\n",
 			info->desc.name, info->update_bank, info->update_reg,
-			info->update_mask, info->update_val);
+			info->update_mask, update_val);
 	}
 
-	return ret;
+	info->update_val = update_val;
+
+	return 0;
 }
 
 static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
-- 
1.7.10.4



