Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaBFOf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:35:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51236 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaBFOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:35:25 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] regulator: da9052: Add ramp speed information for the DVC regulators
Date: Thu,  6 Feb 2014 15:35:21 +0100
Message-Id: <1391697321-14231-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LDOs and DCDCs have a fixed ramp speed of 6.25 mV/µs. This patch adds
the set_voltage_time_sel function to let consumers know about this.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/regulator/da9052-regulator.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 3adeaef..e0dbfec 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -240,6 +240,31 @@ static int da9052_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	return ret;
 }
 
+static int da9052_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
+						 unsigned int old_sel,
+						 unsigned int new_sel)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int id = rdev_get_id(rdev);
+	int ret = 0;
+
+	/* The DVC controlled LDOs and DCDCs ramp with 6.25mV/µs after enabling
+	 * the activate bit.
+	 */
+	switch (id) {
+	case DA9052_ID_BUCK1:
+	case DA9052_ID_BUCK2:
+	case DA9052_ID_BUCK3:
+	case DA9052_ID_LDO2:
+	case DA9052_ID_LDO3:
+		ret = (new_sel - old_sel) * info->step_uV / 6250;
+		break;
+	}
+
+	return ret;
+}
+
 static struct regulator_ops da9052_dcdc_ops = {
 	.get_current_limit = da9052_dcdc_get_current_limit,
 	.set_current_limit = da9052_dcdc_set_current_limit,
@@ -248,6 +273,7 @@ static struct regulator_ops da9052_dcdc_ops = {
 	.map_voltage = da9052_map_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = da9052_regulator_set_voltage_sel,
+	.set_voltage_time_sel = da9052_regulator_set_voltage_time_sel,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -258,6 +284,7 @@ static struct regulator_ops da9052_ldo_ops = {
 	.map_voltage = da9052_map_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = da9052_regulator_set_voltage_sel,
+	.set_voltage_time_sel = da9052_regulator_set_voltage_time_sel,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-- 
1.8.5.3

