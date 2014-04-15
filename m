Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaDOUPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:15:00 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57934 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaDOUOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:14:54 -0400
From: Doug Anderson <dianders@chromium.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Olof Johansson <olof@lixom.net>, Sachin Kamat <sachin.kamat@linaro.org>,
        ajaykumar.rs@samsung.com, linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, Simon Glass <sjg@chromium.org>,
        Michael Spang <spang@chromium.org>, Sean Paul <seanpaul@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] regulator: tps65090: Make FETs more reliable
Date: Tue, 15 Apr 2014 13:14:36 -0700
Message-Id: <1397592876-5741-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397592876-5741-1-git-send-email-dianders@chromium.org>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An issue was discovered with tps65090 where sometimes the FETs
wouldn't actually turn on when requested.  The most problematic FET
was the one use for the LCD backlight on the Samsung ARM Chromebook
(FET1).  Problems were especially prevalent when the device was
plugged in to AC power, making the backlight voltage higher.

Mitigate the problem by:
* Allow setting the overcurrent wait time so devices with this problem
  can set it to the max.
* Add retry logic on enables of FETs.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Michael Spang <spang@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 .../devicetree/bindings/regulator/tps65090.txt     |   4 +
 drivers/regulator/tps65090-regulator.c             | 197 +++++++++++++++++++--
 include/linux/mfd/tps65090.h                       |   5 +
 3 files changed, 194 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps65090.txt b/Documentation/devicetree/bindings/regulator/tps65090.txt
index 313a60b..34098023 100644
--- a/Documentation/devicetree/bindings/regulator/tps65090.txt
+++ b/Documentation/devicetree/bindings/regulator/tps65090.txt
@@ -21,6 +21,10 @@ Optional properties:
   number should be provided. If it is externally controlled and no GPIO
   entry then driver will just configure this rails as external control
   and will not provide any enable/disable APIs.
+- ti,overcurrent-wait: This is applicable to FET registers, which have a
+  poorly defined "overcurrent wait" field.  If this property is present it
+  should be between 0 - 3.  If this property isn't present we won't touch the
+  "overcurrent wait" field and we'll leave it to the BIOS/EC to deal with.
 
 Each regulator is defined using the standard binding for regulators.
 
diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 2e92ef6..e8d1c62 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -17,6 +17,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
@@ -28,21 +29,186 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/mfd/tps65090.h>
 
+#define MAX_CTRL_READ_TRIES	5
+#define MAX_FET_ENABLE_TRIES	1000
+
+#define CTRL_EN_BIT		0 /* Regulator enable bit, active high */
+#define CTRL_WT_BIT		2 /* Regulator wait time 0 bit */
+#define CTRL_PG_BIT		4 /* Regulator power good bit, 1=good */
+#define CTRL_TO_BIT		7 /* Regulator timeout bit, 1=wait */
+
+#define MAX_OVERCURRENT_WAIT	3 /* Overcurrent wait must be less than this */
+
+/**
+ * struct tps65090_regulator - Per-regulator data for a tps65090 regulator
+ *
+ * @dev: Pointer to our device.
+ * @desc: The struct regulator_desc for the regulator.
+ * @rdev: The struct regulator_dev for the regulator.
+ * @overcurrent_wait_valid: True if overcurrent_wait is valid.
+ * @overcurrent_wait: For FETs, the value to put in the WTFET bitfield.
+ */
+
 struct tps65090_regulator {
 	struct device		*dev;
 	struct regulator_desc	*desc;
 	struct regulator_dev	*rdev;
+	bool			overcurrent_wait_valid;
+	int			overcurrent_wait;
 };
 
 static struct regulator_ops tps65090_ext_control_ops = {
 };
 
-static struct regulator_ops tps65090_reg_contol_ops = {
+/**
+ * tps65090_fet_is_enabled - Tell if a fet is enabled
+ *
+ * @rdev:	Regulator device
+ * @return true if the fet is enabled and its power is good; false otherwise.
+ */
+static int tps65090_fet_is_enabled(struct regulator_dev *rdev)
+{
+	unsigned int control;
+	unsigned int expected = rdev->desc->enable_mask | BIT(CTRL_PG_BIT);
+	int ret;
+
+	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &control);
+	if (ret != 0)
+		return ret;
+
+	return (control & expected) == expected;
+}
+
+/**
+ * tps65090_reg_set_overcurrent_wait - Setup overcurrent wait
+ *
+ * This will set the overcurrent wait time based on what's in the regulator
+ * info.
+ *
+ * @rdev:	Regulator device
+ * @return 0 if no error, non-zero if there was an error writing the register.
+ */
+static int tps65090_reg_set_overcurrent_wait(struct regulator_dev *rdev)
+{
+	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (!ri->overcurrent_wait_valid)
+		return 0;
+
+	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				 MAX_OVERCURRENT_WAIT << CTRL_WT_BIT,
+				 ri->overcurrent_wait << CTRL_WT_BIT);
+	if (ret) {
+		dev_err(&rdev->dev, "Error updating overcurrent wait %#x\n",
+			rdev->desc->enable_reg);
+	}
+
+	return ret;
+}
+
+/**
+ * tps6090_try_enable_fet - Try to enable a FET
+ *
+ * @rdev:	Regulator device
+ * @return 0 if ok, -ENOTRECOVERABLE if the FET power good bit did not get set,
+ * or some other -ve value if another error occurred (e.g. i2c error)
+ */
+static int tps6090_try_enable_fet(struct regulator_dev *rdev)
+{
+	unsigned int control;
+	int ret, i;
+
+	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				 rdev->desc->enable_mask,
+				 rdev->desc->enable_mask);
+	if (ret < 0) {
+		dev_err(&rdev->dev, "Error in updating reg %#x\n",
+			rdev->desc->enable_reg);
+		return ret;
+	}
+
+	for (i = 0; i < MAX_CTRL_READ_TRIES; i++) {
+		ret = regmap_read(rdev->regmap, rdev->desc->enable_reg,
+				  &control);
+		if (ret < 0)
+			return ret;
+
+		if (!(control & BIT(CTRL_TO_BIT)))
+			break;
+
+		usleep_range(1000, 1500);
+	}
+	if (!(control & BIT(CTRL_PG_BIT)))
+		return -ENOTRECOVERABLE;
+
+	return 0;
+}
+
+/**
+ * tps65090_fet_enable - Enable a FET, trying a few times if it fails
+ *
+ * Some versions of the tps65090 have issues when turning on the FETs.
+ * This function goes through several steps to ensure the best chance of the
+ * FET going on.  Specifically:
+ * - We'll make sure that we bump the "overcurrent wait" to the maximum, which
+ *   increases the chances that we'll turn on properly.
+ * - We'll retry turning the FET on multiple times (turning off in between).
+ *
+ * @rdev:	Regulator device
+ * @return 0 if ok, non-zero if it fails.
+ */
+static int tps65090_fet_enable(struct regulator_dev *rdev)
+{
+	int ret, tries;
+
+	ret = tps65090_reg_set_overcurrent_wait(rdev);
+	if (ret)
+		goto err;
+
+	/*
+	 * Try enabling multiple times until we succeed since sometimes the
+	 * first try times out.
+	 */
+	for (tries = 0; ; tries++) {
+		ret = tps6090_try_enable_fet(rdev);
+		if (!ret)
+			break;
+		if (ret != -ENOTRECOVERABLE || tries == MAX_FET_ENABLE_TRIES)
+			goto err;
+
+		/* Try turning the FET off (and then on again) */
+		ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+					 rdev->desc->enable_mask, 0);
+		if (ret)
+			goto err;
+	}
+
+	if (tries) {
+		dev_warn(&rdev->dev, "reg %#x enable ok after %d tries\n",
+			 rdev->desc->enable_reg, tries);
+	}
+
+	return 0;
+err:
+	dev_warn(&rdev->dev, "reg %#x enable failed\n", rdev->desc->enable_reg);
+	WARN_ON(1);
+
+	return ret;
+}
+
+static struct regulator_ops tps65090_reg_control_ops = {
 	.enable		= regulator_enable_regmap,
 	.disable	= regulator_disable_regmap,
 	.is_enabled	= regulator_is_enabled_regmap,
 };
 
+static struct regulator_ops tps65090_fet_control_ops = {
+	.enable		= tps65090_fet_enable,
+	.disable	= regulator_disable_regmap,
+	.is_enabled	= tps65090_fet_is_enabled,
+};
+
 static struct regulator_ops tps65090_ldo_ops = {
 };
 
@@ -53,22 +219,22 @@ static struct regulator_ops tps65090_ldo_ops = {
 	.id = TPS65090_REGULATOR_##_id,			\
 	.ops = &_ops,					\
 	.enable_reg = _en_reg,				\
-	.enable_mask = BIT(0),				\
+	.enable_mask = BIT(CTRL_EN_BIT),		\
 	.type = REGULATOR_VOLTAGE,			\
 	.owner = THIS_MODULE,				\
 }
 
 static struct regulator_desc tps65090_regulator_desc[] = {
-	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET1,  "infet1",  0x0F, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET2,  "infet2",  0x10, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET3,  "infet3",  0x11, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET4,  "infet4",  0x12, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, tps65090_reg_control_ops),
+	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, tps65090_reg_control_ops),
+	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, tps65090_reg_control_ops),
+	tps65090_REG_DESC(FET1,  "infet1",  0x0F, tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET2,  "infet2",  0x10, tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET3,  "infet3",  0x11, tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET4,  "infet4",  0x12, tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_fet_control_ops),
 	tps65090_REG_DESC(LDO1,  "vsys-l1", 0,    tps65090_ldo_ops),
 	tps65090_REG_DESC(LDO2,  "vsys-l2", 0,    tps65090_ldo_ops),
 };
@@ -209,6 +375,11 @@ static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
 			rpdata->gpio = of_get_named_gpio(np,
 					"dcdc-ext-control-gpios", 0);
 
+		if (of_property_read_u32(tps65090_matches[idx].of_node,
+					 "ti,overcurrent-wait",
+					 &rpdata->overcurrent_wait) == 0)
+			rpdata->overcurrent_wait_valid = true;
+
 		tps65090_pdata->reg_pdata[idx] = rpdata;
 	}
 	return tps65090_pdata;
@@ -258,6 +429,8 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 		ri = &pmic[num];
 		ri->dev = &pdev->dev;
 		ri->desc = &tps65090_regulator_desc[num];
+		ri->overcurrent_wait_valid = tps_pdata->overcurrent_wait_valid;
+		ri->overcurrent_wait = tps_pdata->overcurrent_wait;
 
 		/*
 		 * TPS5090 DCDC support the control from external digital input.
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 3f43069..f25adfa 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -78,11 +78,16 @@ struct tps65090 {
  *     DCDC1, DCDC2 and DCDC3.
  * @gpio: Gpio number if external control is enabled and controlled through
  *     gpio.
+ * @overcurrent_wait_valid: True if the overcurrent_wait should be applied.
+ * @overcurrent_wait: Value to set as the overcurrent wait time.  This is the
+ *     actual bitfield value, not a time in ms (valid value are 0 - 3).
  */
 struct tps65090_regulator_plat_data {
 	struct regulator_init_data *reg_init_data;
 	bool enable_ext_control;
 	int gpio;
+	bool overcurrent_wait_valid;
+	int overcurrent_wait;
 };
 
 struct tps65090_platform_data {
-- 
1.9.1.423.g4596e3a

