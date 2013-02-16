Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3BPGhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 01:37:35 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:50327 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3BPGhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 01:37:34 -0500
Message-ID: <1360996646.6116.2.camel@phoenix>
Subject: [RFT][PATCH 2/3] regulator: 88pm8607: Use enable_is_inverted flag
 with regulator_enable_regmap and friends APIs
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2013 14:37:26 +0800
In-Reply-To: <1360996576.6116.1.camel@phoenix>
References: <1360996576.6116.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/88pm8607.c |   36 ++++--------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index c79ab84..493948a 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -220,35 +220,6 @@ static int pm8607_list_voltage(struct regulator_dev *rdev, unsigned index)
 	return ret;
 }
 
-static int pm8606_preg_enable(struct regulator_dev *rdev)
-{
-	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
-
-	return pm860x_set_bits(info->i2c, rdev->desc->enable_reg,
-			       1 << rdev->desc->enable_mask, 0);
-}
-
-static int pm8606_preg_disable(struct regulator_dev *rdev)
-{
-	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
-
-	return pm860x_set_bits(info->i2c, rdev->desc->enable_reg,
-			       1 << rdev->desc->enable_mask,
-			       1 << rdev->desc->enable_mask);
-}
-
-static int pm8606_preg_is_enabled(struct regulator_dev *rdev)
-{
-	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
-	int ret;
-
-	ret = pm860x_reg_read(info->i2c, rdev->desc->enable_reg);
-	if (ret < 0)
-		return ret;
-
-	return !((unsigned char)ret & (1 << rdev->desc->enable_mask));
-}
-
 static struct regulator_ops pm8607_regulator_ops = {
 	.list_voltage	= pm8607_list_voltage,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
@@ -259,9 +230,9 @@ static struct regulator_ops pm8607_regulator_ops = {
 };
 
 static struct regulator_ops pm8606_preg_ops = {
-	.enable		= pm8606_preg_enable,
-	.disable	= pm8606_preg_disable,
-	.is_enabled	= pm8606_preg_is_enabled,
+	.enable		= regulator_enable_regmap,
+	.disable	= regulator_disable_regmap,
+	.is_enabled	= regulator_is_enabled_regmap,
 };
 
 #define PM8606_PREG(ereg, ebit)						\
@@ -274,6 +245,7 @@ static struct regulator_ops pm8606_preg_ops = {
 		.owner	= THIS_MODULE,					\
 		.enable_reg = PM8606_##ereg,				\
 		.enable_mask = (ebit),					\
+		.enable_is_inverted = true,				\
 	},								\
 }
 
-- 
1.7.9.5



