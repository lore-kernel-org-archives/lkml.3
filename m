Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3D0ISy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 04:18:54 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63260 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab3D0ISv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 04:18:51 -0400
Message-ID: <1367050696.20145.1.camel@phoenix>
Subject: [PATCH] regulator: max77686: Don't update max77686->opmode if
 update register fails
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 27 Apr 2013 16:18:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure max77686->opmode always has correct status.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max77686.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index e4586ee..20935b1 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -75,17 +75,20 @@ static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
 {
 	unsigned int val;
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
-        int id = rdev_get_id(rdev);
+	int ret, id = rdev_get_id(rdev);
 
 	if (id == MAX77686_BUCK1)
 		val = 0x1;
 	else
 		val = 0x1 << MAX77686_OPMODE_BUCK234_SHIFT;
 
+	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				 rdev->desc->enable_mask, val);
+	if (ret)
+		return ret;
+
 	max77686->opmode[id] = val;
-	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask,
-				  val);
+	return 0;
 }
 
 /* Some LDOs supports [LPM/Normal]ON mode during suspend state */
@@ -94,7 +97,7 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 {
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
 	unsigned int val;
-        int id = rdev_get_id(rdev);
+	int ret, id = rdev_get_id(rdev);
 
 	/* BUCK[5-9] doesn't support this feature */
 	if (id >= MAX77686_BUCK5)
@@ -113,10 +116,13 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
+	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask, val);
+	if (ret)
+		return ret;
+
 	max77686->opmode[id] = val;
-	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask,
-				  val);
+	return 0;
 }
 
 /* Some LDOs supports LPM-ON/OFF/Normal-ON mode during suspend state */
@@ -125,6 +131,7 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 {
 	unsigned int val;
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	int ret;
 
 	switch (mode) {
 	case REGULATOR_MODE_STANDBY:			/* switch off */
@@ -142,10 +149,13 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
+	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				 rdev->desc->enable_mask, val);
+	if (ret)
+		return ret;
+
 	max77686->opmode[rdev_get_id(rdev)] = val;
-	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask,
-				  val);
+	return 0;
 }
 
 static int max77686_enable(struct regulator_dev *rdev)
-- 
1.7.10.4



