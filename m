Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3DTMNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 08:13:00 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44149 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3DTMM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 08:12:59 -0400
Message-ID: <1366459972.3833.2.camel@phoenix>
Subject: [RFC/RFT][PATCH] regulator: palmas: Convert to use
 regulator_set_voltage_time_sel()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 20 Apr 2013 20:12:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use regulator_set_voltage_time_sel() instead of open coded.

If rdev->constraints->ramp_delay is specified, the setting will be used in
regulator_set_voltage_time_sel(). And then pmic->ramp_delay[] is not used and
can be removed.

There is a different behavior change here:
regulator_set_voltage_time_sel() always returns 
	DIV_ROUND_UP(abs(new_volt - old_volt), ramp_delay);

palma_smps_set_voltage_smps_time_sel() actually returns
	DIV_ROUND_UP(abs(new_volt - old_volt), modified_ramp_delay);
where the modified_ramp_delay is not exactly specified by 
rdev->constraints->ramp_delay but a value from pmic->ramp_delay[id].

So palma_smps_set_voltage_smps_time_sel() may return a smaller delay than
regulator_set_voltage_time_sel() depend on rdev->constraints->ramp_delay value.

I think the delay in both version are *safe* for the operation.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c |   26 +-------------------------
 include/linux/mfd/palmas.h           |    1 -
 2 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 9254f94..3d9437e 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -408,28 +408,6 @@ static int palmas_map_voltage_smps(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int palma_smps_set_voltage_smps_time_sel(struct regulator_dev *rdev,
-	unsigned int old_selector, unsigned int new_selector)
-{
-	struct palmas_pmic *pmic = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
-	int old_uv, new_uv;
-	unsigned int ramp_delay = pmic->ramp_delay[id];
-
-	if (!ramp_delay)
-		return 0;
-
-	old_uv = palmas_list_voltage_smps(rdev, old_selector);
-	if (old_uv < 0)
-		return old_uv;
-
-	new_uv = palmas_list_voltage_smps(rdev, new_selector);
-	if (new_uv < 0)
-		return new_uv;
-
-	return DIV_ROUND_UP(abs(old_uv - new_uv), ramp_delay);
-}
-
 static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 		 int ramp_delay)
 {
@@ -454,7 +432,6 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 		return ret;
 	}
 
-	pmic->ramp_delay[id] = palmas_smps_ramp_delay[reg];
 	return ret;
 }
 
@@ -468,7 +445,7 @@ static struct regulator_ops palmas_ops_smps = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.list_voltage		= palmas_list_voltage_smps,
 	.map_voltage		= palmas_map_voltage_smps,
-	.set_voltage_time_sel	= palma_smps_set_voltage_smps_time_sel,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= palmas_smps_set_ramp_delay,
 };
 
@@ -846,7 +823,6 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			}
 			pmic->desc[id].ramp_delay =
 					palmas_smps_ramp_delay[reg & 0x3];
-			pmic->ramp_delay[id] = pmic->desc[id].ramp_delay;
 		}
 
 		/* Initialise sleep/init values from platform data */
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 8f21daf..c288118 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -337,7 +337,6 @@ struct palmas_pmic {
 	int smps457;
 
 	int range[PALMAS_REG_SMPS10];
-	unsigned int ramp_delay[PALMAS_REG_SMPS10];
 	unsigned int current_reg_mode[PALMAS_REG_SMPS10];
 };
 
-- 
1.7.10.4



