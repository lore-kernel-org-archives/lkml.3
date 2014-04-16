Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaDPSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:25:56 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:45083 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaDPSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:25:35 -0400
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
Subject: [PATCH v2 4/5] regulator: tps65090: Allow setting the overcurrent wait time
Date: Wed, 16 Apr 2014 11:25:23 -0700
Message-Id: <1397672724-9063-5-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397672724-9063-1-git-send-email-dianders@chromium.org>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
 <1397672724-9063-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65090 regulator allows you to specify how long you want it to
wait before detecting an overcurrent condition.  Allow specifying that
through the device tree (or through platform data).

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Michael Spang <spang@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
Changes in v2:
- Separated the overcurrent and retries changes into two patches.
- Now set overcurrent at probe time since it doesn't change.

 .../devicetree/bindings/regulator/tps65090.txt     |  4 ++
 drivers/regulator/tps65090-regulator.c             | 55 ++++++++++++++++++++++
 include/linux/mfd/tps65090.h                       |  5 ++
 3 files changed, 64 insertions(+)

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
index 2e92ef6..ca13a1a 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -28,15 +28,57 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/mfd/tps65090.h>
 
+#define CTRL_WT_BIT		2 /* Regulator wait time 0 bit */
+
+#define MAX_OVERCURRENT_WAIT	3 /* Overcurrent wait must be <= this */
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
 
+/**
+ * tps65090_reg_set_overcurrent_wait - Setup overcurrent wait
+ *
+ * This will set the overcurrent wait time based on what's in the regulator
+ * info.
+ *
+ * @ri:		Overall regulator data
+ * @rdev:	Regulator device
+ * @return 0 if no error, non-zero if there was an error writing the register.
+ */
+static int tps65090_reg_set_overcurrent_wait(struct tps65090_regulator *ri,
+					     struct regulator_dev *rdev)
+{
+	int ret;
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
 static struct regulator_ops tps65090_reg_contol_ops = {
 	.enable		= regulator_enable_regmap,
 	.disable	= regulator_disable_regmap,
@@ -209,6 +251,11 @@ static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
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
@@ -258,6 +305,8 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 		ri = &pmic[num];
 		ri->dev = &pdev->dev;
 		ri->desc = &tps65090_regulator_desc[num];
+		ri->overcurrent_wait_valid = tps_pdata->overcurrent_wait_valid;
+		ri->overcurrent_wait = tps_pdata->overcurrent_wait;
 
 		/*
 		 * TPS5090 DCDC support the control from external digital input.
@@ -299,6 +348,12 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 		}
 		ri->rdev = rdev;
 
+		if (ri->overcurrent_wait_valid) {
+			ret = tps65090_reg_set_overcurrent_wait(ri, rdev);
+			if (ret < 0)
+				return ret;
+		}
+
 		/* Enable external control if it is require */
 		if (tps_pdata && is_dcdc(num) && tps_pdata->reg_init_data &&
 				tps_pdata->enable_ext_control) {
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 45f0f9d..0bf2708 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -92,11 +92,16 @@ struct tps65090 {
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

