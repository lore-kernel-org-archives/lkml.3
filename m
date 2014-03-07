Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaCGPus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:50:48 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54149 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaCGPup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:50:45 -0500
Message-ID: <1394207439.17867.6.camel@phoenix>
Subject: [PATCH 3/3] regulator: pbias: Convert to use
 regulator_[enable|is_enabled]_regmap
From: Axel Lin <axel.lin@ingics.com>
To: Chris Ball <chris@printf.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Balaji T K <balajitk@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Date: Fri, 07 Mar 2014 23:50:39 +0800
In-Reply-To: <1394206897.17867.1.camel@phoenix>
References: <1394206897.17867.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ca5d1b3524b4d
"regulator: helpers: Modify helpers enabling multi-bit control",
we can set enable_val setting for device that use multiple bits for control
when using regmap enable/disable/bypass ops.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Note:
This patch depends on below commit which is only in regulator tree now:
http://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/commit/?h=topic/enable

I sent this for reveiw and test now.
if it works, I'll resend it once 3.5-rc1 is released.

 drivers/regulator/pbias-regulator.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/pbias-regulator.c b/drivers/regulator/pbias-regulator.c
index 6d38be3..708ddbb 100644
--- a/drivers/regulator/pbias-regulator.c
+++ b/drivers/regulator/pbias-regulator.c
@@ -49,33 +49,13 @@ static const unsigned int pbias_volt_table[] = {
 	3000000
 };
 
-static int pbias_regulator_enable(struct regulator_dev *rdev)
-{
-	struct pbias_regulator_data *data = rdev_get_drvdata(rdev);
-	const struct pbias_reg_info *info = data->info;
-
-	return regmap_update_bits(data->syscon, rdev->desc->enable_reg,
-				  info->enable_mask, info->enable);
-}
-
-static int pbias_regulator_is_enable(struct regulator_dev *rdev)
-{
-	struct pbias_regulator_data *data = rdev_get_drvdata(rdev);
-	const struct pbias_reg_info *info = data->info;
-	int value;
-
-	regmap_read(data->syscon, rdev->desc->enable_reg, &value);
-
-	return (value & info->enable_mask) == info->enable;
-}
-
 static struct regulator_ops pbias_regulator_voltage_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
-	.enable = pbias_regulator_enable,
+	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-	.is_enabled = pbias_regulator_is_enable,
+	.is_enabled = regulator_is_enabled_regmap,
 };
 
 static const struct pbias_reg_info pbias_mmc_omap2430 = {
@@ -180,6 +160,7 @@ static int pbias_regulator_probe(struct platform_device *pdev)
 		drvdata[data_idx].desc.vsel_mask = info->vmode;
 		drvdata[data_idx].desc.enable_reg = res->start;
 		drvdata[data_idx].desc.enable_mask = info->enable_mask;
+		drvdata[data_idx].desc.enable_val = info->enable;
 
 		cfg.init_data = pbias_matches[idx].init_data;
 		cfg.driver_data = &drvdata[data_idx];
-- 
1.8.1.2



