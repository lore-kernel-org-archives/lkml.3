Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3BPGio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 01:38:44 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53703 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3BPGin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 01:38:43 -0500
Message-ID: <1360996717.6116.3.camel@phoenix>
Subject: [RFT][PATCH 3/3] regulator: max8649: Use enable_is_inverted flag
 with regulator_enable_regmap and friends APIs
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2013 14:38:37 +0800
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
 drivers/regulator/max8649.c |   39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 3ca1438..fdb67ff 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -60,36 +60,6 @@ struct max8649_regulator_info {
 	unsigned	ramp_down:1;
 };
 
-/* EN_PD means pulldown on EN input */
-static int max8649_enable(struct regulator_dev *rdev)
-{
-	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
-	return regmap_update_bits(info->regmap, MAX8649_CONTROL, MAX8649_EN_PD, 0);
-}
-
-/*
- * Applied internal pulldown resistor on EN input pin.
- * If pulldown EN pin outside, it would be better.
- */
-static int max8649_disable(struct regulator_dev *rdev)
-{
-	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
-	return regmap_update_bits(info->regmap, MAX8649_CONTROL, MAX8649_EN_PD,
-				MAX8649_EN_PD);
-}
-
-static int max8649_is_enabled(struct regulator_dev *rdev)
-{
-	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
-	unsigned int val;
-	int ret;
-
-	ret = regmap_read(info->regmap, MAX8649_CONTROL, &val);
-	if (ret != 0)
-		return ret;
-	return !((unsigned char)val & MAX8649_EN_PD);
-}
-
 static int max8649_enable_time(struct regulator_dev *rdev)
 {
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
@@ -151,9 +121,9 @@ static struct regulator_ops max8649_dcdc_ops = {
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage	= regulator_list_voltage_linear,
 	.map_voltage	= regulator_map_voltage_linear,
-	.enable		= max8649_enable,
-	.disable	= max8649_disable,
-	.is_enabled	= max8649_is_enabled,
+	.enable		= regulator_enable_regmap,
+	.disable	= regulator_disable_regmap,
+	.is_enabled	= regulator_is_enabled_regmap,
 	.enable_time	= max8649_enable_time,
 	.set_mode	= max8649_set_mode,
 	.get_mode	= max8649_get_mode,
@@ -169,6 +139,9 @@ static struct regulator_desc dcdc_desc = {
 	.vsel_mask	= MAX8649_VOL_MASK,
 	.min_uV		= MAX8649_DCDC_VMIN,
 	.uV_step	= MAX8649_DCDC_STEP,
+	.enable_reg	= MAX8649_CONTROL,
+	.enable_mask	= MAX8649_EN_PD,
+	.enable_is_inverted = true,
 };
 
 static struct regmap_config max8649_regmap_config = {
-- 
1.7.9.5



