Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab3CHWps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:45:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7579 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab3CHWpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:45:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 08 Mar 2013 14:45:45 -0800
From: Andrew Chew <achew@nvidia.com>
To: <thierry.reding@avionic-design.de>, <acourbot@nvidia.com>
CC: <achew@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 v6] pwm_bl: Add mandatory backlight enable regulator
Date: Fri, 8 Mar 2013 14:45:36 -0800
Message-ID: <1362782736-551-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many backlights need to be explicitly enabled.  Typically, this is done
with a GPIO.  For flexibility, we generalize the enable mechanism to a
regulator.

If an enable regulator is not needed, then a dummy regulator can be given
to the backlight driver.  If a GPIO is used to enable the backlight,
then a fixed regulator can be instantiated to control the GPIO.

The backlight enable regulator can be specified in the device tree node
for the backlight, or can be done with legacy board setup code in the
usual way.

Signed-off-by: Andrew Chew <achew@nvidia.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
---
Removed "pb->enable_supply = NULL;" per Alex's suggestion, since probe fails
in this case anyway, and on next probe (if probe is deferred) will assign
to pb->enable_supply before accessing it.

Updated the commit message to provide a description of the purpose of the
new mandatory regulator, and tweaked verbiage to not be device tree
specific.

I intend to follow up with patches to fix all existing machines that use the
pwm_bl driver.

 .../bindings/video/backlight/pwm-backlight.txt     |   14 +++++
 drivers/video/backlight/pwm_bl.c                   |   55 ++++++++++++++++----
 2 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..7e2e089 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -10,6 +10,11 @@ Required properties:
       last value in the array represents a 100% duty cycle (brightest).
   - default-brightness-level: the default brightness level (index into the
       array defined by the "brightness-levels" property)
+  - enable-supply: A phandle to the regulator device tree node. This
+      regulator will be turned on and off as the pwm is enabled and disabled.
+      Many backlights are enabled via a GPIO. In this case, we instantiate
+      a fixed regulator and give that to enable-supply. If a regulator
+      is not needed, then provide a dummy fixed regulator.
 
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
@@ -19,10 +24,19 @@ Optional properties:
 
 Example:
 
+	bl_en: fixed-regulator {
+                compatible = "regulator-fixed";
+                regulator-name = "bl-en-supply";
+                regulator-boot-on;
+                gpio = <&some_gpio>;
+                enable-active-high;
+	};
+
 	backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pwm 0 5000000>;
 
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+		enable-supply = <&bl_en>;
 	};
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 069983c..f403b9d 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -20,10 +20,13 @@
 #include <linux/pwm.h>
 #include <linux/pwm_backlight.h>
 #include <linux/slab.h>
+#include <linux/regulator/consumer.h>
 
 struct pwm_bl_data {
 	struct pwm_device	*pwm;
 	struct device		*dev;
+	bool			enabled;
+	struct regulator	*enable_supply;
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
@@ -35,6 +38,38 @@ struct pwm_bl_data {
 	void			(*exit)(struct device *);
 };
 
+static void pwm_backlight_enable(struct backlight_device *bl)
+{
+	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+
+	/* Bail if we are already enabled. */
+	if (pb->enabled)
+		return;
+
+	pwm_enable(pb->pwm);
+
+	if (regulator_enable(pb->enable_supply) != 0)
+		dev_warn(&bl->dev, "Failed to enable regulator");
+
+	pb->enabled = true;
+}
+
+static void pwm_backlight_disable(struct backlight_device *bl)
+{
+	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+
+	/* Bail if we are already disabled. */
+	if (!pb->enabled)
+		return;
+
+	if (regulator_disable(pb->enable_supply) != 0)
+		dev_warn(&bl->dev, "Failed to disable regulator");
+
+	pwm_disable(pb->pwm);
+
+	pb->enabled = false;
+}
+
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
@@ -52,7 +87,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 
 	if (brightness == 0) {
 		pwm_config(pb->pwm, 0, pb->period);
-		pwm_disable(pb->pwm);
+		pwm_backlight_disable(bl);
 	} else {
 		int duty_cycle;
 
@@ -66,7 +101,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		duty_cycle = pb->lth_brightness +
 		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
 		pwm_config(pb->pwm, duty_cycle, pb->period);
-		pwm_enable(pb->pwm);
+		pwm_backlight_enable(bl);
 	}
 
 	if (pb->notify_after)
@@ -145,12 +180,6 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->max_brightness--;
 	}
 
-	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
-	 */
-
 	return 0;
 }
 
@@ -213,6 +242,12 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	pb->exit = data->exit;
 	pb->dev = &pdev->dev;
 
+	pb->enable_supply = devm_regulator_get(&pdev->dev, "enable");
+	if (IS_ERR(pb->enable_supply)) {
+		ret = PTR_ERR(pb->enable_supply);
+		goto err_alloc;
+	}
+
 	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
 	if (IS_ERR(pb->pwm)) {
 		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
@@ -268,7 +303,7 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 
 	backlight_device_unregister(bl);
 	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_disable(bl);
 	if (pb->exit)
 		pb->exit(&pdev->dev);
 	return 0;
@@ -283,7 +318,7 @@ static int pwm_backlight_suspend(struct device *dev)
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
 	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_disable(bl);
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, 0);
 	return 0;
-- 
1.7.9.5

