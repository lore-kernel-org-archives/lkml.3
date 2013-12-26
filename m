Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3LZVsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 16:48:55 -0500
Received: from mail-ie0-f202.google.com ([209.85.223.202]:59207 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3LZVsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 16:48:54 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>,
        Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH 1/2] regulator: as3722: detect SD0 low-voltage mode
Date: Thu, 26 Dec 2013 13:48:46 -0800
Message-Id: <1388094527-7585-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SD0 may operate in low-voltage mode, with a minimum of 0.41V
and a maximum of 1.5V.  This is indicated by bit 4 of FUSE7.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drivers/regulator/as3722-regulator.c | 30 ++++++++++++++++++++++++++----
 include/linux/mfd/as3722.h           |  4 ++++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index 27fe63c..1e91761 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -99,7 +99,6 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD0_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD0_CONTROL_REG,
 		.mode_mask = AS3722_SD0_MODE_FAST,
-		.n_voltages = AS3722_SD0_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_SD1,
@@ -112,7 +111,6 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD1_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD1_CONTROL_REG,
 		.mode_mask = AS3722_SD1_MODE_FAST,
-		.n_voltages = AS3722_SD0_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_SD2,
@@ -181,7 +179,6 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD6_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD6_CONTROL_REG,
 		.mode_mask = AS3722_SD6_MODE_FAST,
-		.n_voltages = AS3722_SD0_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_LDO0,
@@ -595,6 +592,22 @@ static int as3722_sd016_set_current_limit(struct regulator_dev *rdev,
 	return as3722_update_bits(as3722, reg, mask, val);
 }
 
+static bool as3722_sd0_is_low_voltage(struct as3722_regulators *as3722_regs)
+{
+	int err;
+	unsigned val;
+
+	err = as3722_read(as3722_regs->as3722, AS3722_FUSE7_REG, &val);
+	if (err < 0) {
+		dev_err(as3722_regs->dev, "Reg 0x%02x read failed: %d\n",
+			AS3722_FUSE7_REG, err);
+		return false;
+	}
+	if (val & AS3722_FUSE7_SD0_LOW_VOLTAGE)
+		return true;
+	return false;
+}
+
 static const struct regulator_linear_range as3722_sd2345_ranges[] = {
 	REGULATOR_LINEAR_RANGE(612500, 0x01, 0x40, 12500),
 	REGULATOR_LINEAR_RANGE(1425000, 0x41, 0x70, 25000),
@@ -820,7 +833,16 @@ static int as3722_regulator_probe(struct platform_device *pdev)
 				ops = &as3722_sd016_extcntrl_ops;
 			else
 				ops = &as3722_sd016_ops;
-			as3722_regs->desc[id].min_uV = 610000;
+			if (id == AS3722_REGULATOR_ID_SD0 &&
+			    as3722_sd0_is_low_voltage(as3722_regs)) {
+				as3722_regs->desc[id].n_voltages =
+					AS3722_SD0_VSEL_LOW_VOL_MAX + 1;
+				as3722_regs->desc[id].min_uV = 410000;
+			} else {
+				as3722_regs->desc[id].n_voltages =
+					AS3722_SD0_VSEL_MAX + 1,
+				as3722_regs->desc[id].min_uV = 610000;
+			}
 			as3722_regs->desc[id].uV_step = 10000;
 			as3722_regs->desc[id].linear_min_sel = 1;
 			break;
diff --git a/include/linux/mfd/as3722.h b/include/linux/mfd/as3722.h
index 16bf8a0..bb9616d 100644
--- a/include/linux/mfd/as3722.h
+++ b/include/linux/mfd/as3722.h
@@ -151,6 +151,7 @@
 #define AS3722_ASIC_ID1_REG				0x90
 #define AS3722_ASIC_ID2_REG				0x91
 #define AS3722_LOCK_REG					0x9E
+#define AS3722_FUSE7_REG				0xA7
 #define AS3722_MAX_REGISTER				0xF4
 
 #define AS3722_SD0_EXT_ENABLE_MASK			0x03
@@ -224,6 +225,7 @@
 #define AS3722_SD_VSEL_MASK				0x7F
 #define AS3722_SD0_VSEL_MIN				0x01
 #define AS3722_SD0_VSEL_MAX				0x5A
+#define AS3722_SD0_VSEL_LOW_VOL_MAX			0x6E
 #define AS3722_SD2_VSEL_MIN				0x01
 #define AS3722_SD2_VSEL_MAX				0x7F
 
@@ -341,6 +343,8 @@
 #define AS3722_EXT_CONTROL_ENABLE2			0x2
 #define AS3722_EXT_CONTROL_ENABLE3			0x3
 
+#define AS3722_FUSE7_SD0_LOW_VOLTAGE			BIT(4)
+
 /* Interrupt IDs */
 enum as3722_irq {
 	AS3722_IRQ_LID,
-- 
1.8.5.1

