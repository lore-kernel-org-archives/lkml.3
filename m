Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaBVEx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 23:53:26 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34591 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaBVExZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 23:53:25 -0500
Message-ID: <1393044798.15653.1.camel@phoenix>
Subject: [PATCH RFC] regulator: anatop: Remove checking control_reg in
 [set|get]_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 22 Feb 2014 12:53:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checking control_reg in [set|get]_voltage_sel and then convert to use
regulator_[set|get]_voltage_sel_regmap for [set|get]_voltage_sel callbacks.

The anatop-reg-offset property is a required property rather than optional
property. So the question is what is the meaning of setting anatop-reg-offset
to 0? If 0 is a valid setting for anatop-reg-offset and it has special meaning,
we had better document it in the binding document. Otherwise, remove the testing
for control_reg in the driver.

No anatop voltage regulator node in the dts files set anatop-reg-offset to 0.
So I think it's safe to remove testing if control_reg is 0.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/anatop-regulator.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 38e8122..7c397bb 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -55,17 +55,6 @@ struct anatop_regulator {
 	int sel;
 };
 
-static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
-					unsigned selector)
-{
-	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
-
-	if (!anatop_reg->control_reg)
-		return -ENOTSUPP;
-
-	return regulator_set_voltage_sel_regmap(reg, selector);
-}
-
 static int anatop_regmap_set_voltage_time_sel(struct regulator_dev *reg,
 	unsigned int old_sel,
 	unsigned int new_sel)
@@ -92,16 +81,6 @@ static int anatop_regmap_set_voltage_time_sel(struct regulator_dev *reg,
 	return ret;
 }
 
-static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
-{
-	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
-
-	if (!anatop_reg->control_reg)
-		return -ENOTSUPP;
-
-	return regulator_get_voltage_sel_regmap(reg);
-}
-
 static int anatop_regmap_enable(struct regulator_dev *reg)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
@@ -178,8 +157,8 @@ static int anatop_regmap_set_bypass(struct regulator_dev *reg, bool enable)
 }
 
 static struct regulator_ops anatop_rops = {
-	.set_voltage_sel = anatop_regmap_set_voltage_sel,
-	.get_voltage_sel = anatop_regmap_get_voltage_sel,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 };
-- 
1.8.1.2



