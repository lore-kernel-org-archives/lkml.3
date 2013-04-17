Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966345Ab3DQNm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:42:29 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48955 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965940Ab3DQNm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:42:28 -0400
Message-ID: <1366206143.3305.4.camel@phoenix>
Subject: [RFT][PATCH 1/2] regulator: tps80031: Fix LDO2 track mode for
 TPS80031 or TPS80032-ES1.0
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 21:42:23 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have a special code in tps80031_ldo_set_voltage_sel() to handle
LDO2 track mode for TPS80031 or TPS80032-ES1.0. The purpose is to address below
issues:

Issue description:
- LDO2 traking mode is enabled
- LDO2 tracks SMPS2 voltage.
- LDO2 automatically switch-off when LDO2_CFG_VOLTAGE is changed to some discrete values (non exhaustive list):
            00011001, 00011010, 00011011, 00011100, .
- LDO2 switch-on again when LDO2_CFG_VOLTAGE is changed to other values (non exhaustive list):
        00011000, 00010111, .

LDOs have reserved codes. For these codes, LDO is switch-off.

In tracking, LDO2 ref comes from SMPS2.
However LDO2 enable is still gated by LDO2 VSEL decoding.
As a result, in tracking mode LDO2 will be disabled for following code (SMPS VSEL format):
000000 & 100000 (MSB not decoded)
011001 & 111001 (MSB not decoded)
011010 & 111010 (MSB not decoded)
011100 & 111100 (MSB not decoded)
011101 & 111101 (MSB not decoded)
011110 & 111110 (MSB not decoded)

However, current code has below bugs:
1. It uses regulator_list_voltage_linear, so list_voltage() still shows above
   invalid selectors have supported voltage.
2. Current code may return -EINVAL in tps80031_ldo_set_voltage_sel() for
   supported voltage. This is because when we use regulator_list_voltage_linear
   as list_voltage callback, regulator core will default use
   regulator_map_voltage_linear(). regulator_map_voltage_linear() has an
   assumption that the voltages are linear which is not true for this case.

   For example,
   when request voltage range is: min_uV=950000 uV && max_uV=1200000 uV
   regulator_map_voltage_linear() returns the selector is 29 (0x1D),
   set_voltage_sel() returns -EINVAL.
   (The selector is in invalid range, 0x19 ~ 0x1f).

   In above case, map_voltage() should find the lowest valid voltage within
   specific range (selector = 0x20) and set_voltage_sel() should successfully
   set the voltage to 987500 uV.

This patch fixes these issues by:
1. Add checking valid setting for LDO2 track mode of TPS80031 or TPS80032-ES1.0
   in list_voltage.  So it returns -EINVAL for invalid selectors.
2. Implement tps80031_ldo_map_voltage, use regulator_map_voltage_iterate()
   to find the lowest voltage within specific range for TPS80031 or
   TPS80032-ES1.0. This is required when the voltage map is no longer linear.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Laxman,
I don't have this hardware, can you test this patch serial?

Thank you,
Axel
 drivers/regulator/tps80031-regulator.c |   38 ++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index 9019d0e..6430789 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -238,12 +238,11 @@ static int tps80031_dcdc_get_voltage_sel(struct regulator_dev *rdev)
 	return vsel & SMPS_VSEL_MASK;
 }
 
-static int tps80031_ldo_set_voltage_sel(struct regulator_dev *rdev,
-		unsigned sel)
+static int tps80031_ldo_list_voltage(struct regulator_dev *rdev,
+				     unsigned int sel)
 {
 	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
 	struct device *parent = to_tps80031_dev(rdev);
-	int ret;
 
 	/* Check for valid setting for TPS80031 or TPS80032-ES1.0 */
 	if ((ri->rinfo->desc.id == TPS80031_REGULATOR_LDO2) &&
@@ -260,6 +259,36 @@ static int tps80031_ldo_set_voltage_sel(struct regulator_dev *rdev,
 		}
 	}
 
+	return regulator_list_voltage_linear(rdev, sel);
+}
+
+static int tps80031_ldo_map_voltage(struct regulator_dev *rdev,
+				    int min_uV, int max_uV)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+
+	/* Check for valid setting for TPS80031 or TPS80032-ES1.0 */
+	if ((ri->rinfo->desc.id == TPS80031_REGULATOR_LDO2) &&
+			(ri->device_flags & TRACK_MODE_ENABLE)) {
+		if (((tps80031_get_chip_info(parent) == TPS80031) ||
+			((tps80031_get_chip_info(parent) == TPS80032) &&
+			(tps80031_get_pmu_version(parent) == 0x0)))) {
+			return regulator_map_voltage_iterate(rdev, min_uV,
+							     max_uV);
+		}
+	}
+
+	return regulator_map_voltage_linear(rdev, min_uV, max_uV);
+}
+
+static int tps80031_ldo_set_voltage_sel(struct regulator_dev *rdev,
+		unsigned sel)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	int ret;
+
 	ret = tps80031_write(parent, ri->rinfo->volt_id,
 			ri->rinfo->volt_reg, sel);
 	if (ret < 0)
@@ -390,7 +419,8 @@ static struct regulator_ops tps80031_dcdc_ops = {
 };
 
 static struct regulator_ops tps80031_ldo_ops = {
-	.list_voltage		= regulator_list_voltage_linear,
+	.list_voltage		= tps80031_ldo_list_voltage,
+	.map_voltage		= tps80031_ldo_map_voltage,
 	.set_voltage_sel	= tps80031_ldo_set_voltage_sel,
 	.get_voltage_sel	= tps80031_ldo_get_voltage_sel,
 	.enable			= tps80031_reg_enable,
-- 
1.7.10.4



