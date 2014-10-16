Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaJPQwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:52:16 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34971 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaJPQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:49:54 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 2/7] regulator: max77802: Add set suspend mode for BUCKs and simplify code
Date: Thu, 16 Oct 2014 18:48:48 +0200
Message-Id: <1413478133-2577-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max77802 PMIC has a special enable pin (PWRREQ) that can be used
by the Application Processor (AP) to power down and up voltage rails.

The max77802 PMIC regulators have 3 different enable control logics.
Some regulators support to be configured on different operational mode
during normal operation while others only support to be put in a Low
Power Mode while the system has entered in sleep mode. Some regulators
don't even support that configuration. The logics are the following:

Enable Control Logic1 by PWRREQ (BUCK 2-4, LDO2, LDO4-19, LDO22, LDO35)
-------------------------------
0: Output OFF
1: Output ON/OFF (Controlled by PWRREQ)
     PWRREQ = HIGH (1): Output ON in Normal Mode
     PWRREQ = LOW (0): Output OFF
2: Output On with Low Power Mode (Controlled by PWRREQ)
     PWRREQ = HIGH (1) : Output ON in Normal Mode
     PWRREQ = LOW (0): Output ON in Low Power Mode
3: Output ON in Normal Mode

Enable Control Logic2 by PWRREQ (LDO1, LDO20, LDO21)
-------------------------------
0: Output ON/OFF by ENx
1: Output ON in Low Power Mode
2: Output ON in Low Power Mode (Controlled by PWRREQ)
   PWRREQ = HIGH (1): Output ON in Normal Mode
   PWRREQ = LOW (0): Output ON in Low Power Mode
3: Output ON in Normal Mode

Enable Control Logic3 by PWRREQ (LDO3)
-------------------------------
0 or 3: Output ON in Normal Mode
1: Output ON in Low Power Mode
2: Output ON in Low Power Mode (Controlled by PWRREQ)
   PWRREQ = HIGH (1): Output ON in Normal Mode
   PWRREQ = LOW (0): Output ON in Low Power Mode

The driver only implemented .set_suspend_mode for the LDOs regulators
but some BUCKs also support to be put in Low Power Mode on system wide
suspend so they should be supported as well. Two different functions
were used for the logic 1 and 2 but this is not necessary.

Only normal and Low Power Mode are valid operational modes, OFF is not
an mode but is a regulator state that is handled by .set_suspend_enable
ad .set_suspend_disable. So the same .set_suspend_mode function can be
used by all the regulators that support Output On with Low Power Mode
by PWRREQ, making much simpler the code to set the suspend mode.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v1:
 - Don't map both IDLE and STANDBY modes to the hw Low Power Mode.
   Suggested by Mark Brown.

 drivers/regulator/max77802.c | 93 ++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 6eabb95..dae2c1a 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -50,6 +50,7 @@
 #define MAX77802_RAMP_RATE_SHIFT_4BIT	4
 
 #define MAX77802_OFF_PWRREQ		0x1
+#define MAX77802_LP_PWRREQ		0x2
 
 /* MAX77802 has two register formats: 2-bit and 4-bit */
 static const unsigned int ramp_table_77802_2bit[] = {
@@ -148,71 +149,68 @@ static unsigned max77802_get_mode(struct regulator_dev *rdev)
 	return max77802_map_mode(max77802->opmode[id]);
 }
 
-/*
- * Some LDOs supports LPM-ON/OFF/Normal-ON mode during suspend state
- * (Enable Control Logic1 by PWRREQ)
+/**
+ * max77802_set_suspend_mode - set regulator opmode when the system is suspended
+ * @rdev: regulator to change mode
+ * @mode: operating mode to be set
+ *
+ * Will set the operating mode for the regulators during system suspend.
+ * This function is valid for the three different enable control logics:
  *
- * LDOs 2, 4-19, 22-35.
+ * Enable Control Logic1 by PWRREQ (BUCK 2-4 and LDOs 2, 4-19, 22-35)
+ * Enable Control Logic2 by PWRREQ (LDOs 1, 20, 21)
+ * Enable Control Logic3 by PWRREQ (LDO 3)
  *
+ * If setting the regulator mode fails, the function only warns but does
+ * not return an error code to avoid the regulator core to stop setting
+ * the operating mode for the remaining regulators.
  */
-static int max77802_ldo_set_suspend_mode_logic1(struct regulator_dev *rdev,
-						unsigned int mode)
+static int max77802_set_suspend_mode(struct regulator_dev *rdev,
+				     unsigned int mode)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
 	int id = rdev_get_id(rdev);
 	unsigned int val;
 	int shift = max77802_get_opmode_shift(id);
 
-	switch (mode) {
-	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = MAX77802_OPMODE_LP;
-		break;
-	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = MAX77802_OPMODE_NORMAL;
-		break;
-	case REGULATOR_MODE_STANDBY:			/* ON/OFF by PWRREQ */
-		val = MAX77802_OPMODE_STANDBY;
-		break;
-	default:
-		dev_warn(&rdev->dev, "%s: regulator mode: 0x%x not supported\n",
+	/*
+	 * If the regulator has been disabled for suspend
+	 * then is invalid to try setting a suspend mode.
+	 */
+	if (!max77802->opmode[id] == MAX77802_OFF_PWRREQ) {
+		dev_warn(&rdev->dev, "%s: is disabled, mode: 0x%x not set\n",
 			 rdev->desc->name, mode);
-		return -EINVAL;
+		return 0;
 	}
 
-	max77802->opmode[id] = val;
-	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask, val << shift);
-}
-
-/*
- * Mode 1 (Output[ON/OFF] by PWRREQ) is not supported on some LDOs
- * (Enable Control Logic2 by PWRREQ)
- *
- * LDOs 1, 20, 21, and 3,
- *
- */
-static int max77802_ldo_set_suspend_mode_logic2(struct regulator_dev *rdev,
-						unsigned int mode)
-{
-	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
-	unsigned int val;
-	int shift = max77802_get_opmode_shift(id);
-
 	switch (mode) {
-	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = MAX77802_OPMODE_LP;
-		break;
-	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = MAX77802_OPMODE_NORMAL;
+	case REGULATOR_MODE_STANDBY:
+		/*
+		 * If the regulator opmode is normal then enable
+		 * ON in Low Power Mode by PWRREQ. If the mode is
+		 * already Low Power then no action is required.
+		 */
+		if (max77802->opmode[id] == MAX77802_OPMODE_NORMAL)
+			val = MAX77802_LP_PWRREQ;
+		else
+			return 0;
 		break;
+	case REGULATOR_MODE_NORMAL:
+		/*
+		 * If the regulator operating mode is Low Power then
+		 * normal is not a valid opmode in suspend. If the
+		 * mode is already normal then no action is required.
+		 */
+		if (max77802->opmode[id] == MAX77802_OPMODE_LP)
+			dev_warn(&rdev->dev, "%s: in Low Power: 0x%x invalid\n",
+				 rdev->desc->name, mode);
+		return 0;
 	default:
 		dev_warn(&rdev->dev, "%s: regulator mode: 0x%x not supported\n",
 			 rdev->desc->name, mode);
 		return -EINVAL;
 	}
 
-	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
 }
@@ -297,7 +295,7 @@ static struct regulator_ops max77802_ldo_ops_logic1 = {
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_suspend_enable	= max77802_enable,
 	.set_suspend_disable	= max77802_set_suspend_disable,
-	.set_suspend_mode	= max77802_ldo_set_suspend_mode_logic1,
+	.set_suspend_mode	= max77802_set_suspend_mode,
 };
 
 /*
@@ -314,7 +312,7 @@ static struct regulator_ops max77802_ldo_ops_logic2 = {
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_mode		= max77802_set_mode,
 	.get_mode		= max77802_get_mode,
-	.set_suspend_mode	= max77802_ldo_set_suspend_mode_logic2,
+	.set_suspend_mode	= max77802_set_suspend_mode,
 };
 
 /* BUCKS 1, 6 */
@@ -345,6 +343,7 @@ static struct regulator_ops max77802_buck_234_ops = {
 	.set_ramp_delay		= max77802_set_ramp_delay_2bit,
 	.set_suspend_enable	= max77802_enable,
 	.set_suspend_disable	= max77802_set_suspend_disable,
+	.set_suspend_mode	= max77802_set_suspend_mode,
 };
 
 /* BUCKs 5, 7-10 */
-- 
2.1.0

