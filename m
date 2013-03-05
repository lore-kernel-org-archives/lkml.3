Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3CEXvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:51:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1801 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3CEXvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:51:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Mar 2013 15:51:32 -0800
From: Andrew Chew <achew@nvidia.com>
To: <thierry.reding@avionic-design.de>, <acourbot@nvidia.com>
CC: <achew@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 v3] pwm_bl: Add support for backlight enable regulator
Date: Tue, 5 Mar 2013 15:51:25 -0800
Message-ID: <1362527485-8611-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backlight enable regulator is specified in the device tree node for
backlight.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
Applied all recommendations from Thierry Reding and Alex Courbot, including
making pwm_bl take an optional regulator instead of a GPIO, which solves
the platform data issue (platform data will default the regulator to NULL,
which is the right thing).

 .../bindings/video/backlight/pwm-backlight.txt     |    1 +
 drivers/video/backlight/pwm_bl.c                   |   53 +++++++++++++++++---
 include/linux/pwm_backlight.h                      |    1 +
 3 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..e0bccd30 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,6 +14,7 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - en-supply: phandle to the regulator device tree node
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 069983c..c4da5e2 100644
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
+	struct regulator	*en_supply;
+	bool			en_supply_enabled;
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
@@ -35,6 +38,34 @@ struct pwm_bl_data {
 	void			(*exit)(struct device *);
 };
 
+static void pwm_backlight_enable(struct backlight_device *bl)
+{
+	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+
+	pwm_enable(pb->pwm);
+
+	if (pb->en_supply && !pb->en_supply_enabled) {
+		if (regulator_enable(pb->en_supply) != 0)
+			dev_warn(&bl->dev, "Failed to enable regulator");
+		else
+			pb->en_supply_enabled = true;
+	}
+}
+
+static void pwm_backlight_disable(struct backlight_device *bl)
+{
+	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+
+	if (pb->en_supply && pb->en_supply_enabled) {
+		if (regulator_disable(pb->en_supply) != 0)
+			dev_warn(&bl->dev, "Failed to disable regulator");
+		else
+			pb->en_supply_enabled = false;
+	}
+
+	pwm_disable(pb->pwm);
+}
+
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
@@ -52,7 +83,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 
 	if (brightness == 0) {
 		pwm_config(pb->pwm, 0, pb->period);
-		pwm_disable(pb->pwm);
+		pwm_backlight_disable(bl);
 	} else {
 		int duty_cycle;
 
@@ -66,7 +97,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		duty_cycle = pb->lth_brightness +
 		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
 		pwm_config(pb->pwm, duty_cycle, pb->period);
-		pwm_enable(pb->pwm);
+		pwm_backlight_enable(bl);
 	}
 
 	if (pb->notify_after)
@@ -146,10 +177,17 @@ static int pwm_backlight_parse_dt(struct device *dev,
 	}
 
 	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
+	 * If "en-supply" is present, use that regulator to enable the
+	 * backlight.  If a GPIO is used to enable the backlight, make
+	 * a fixed regulator with that particular GPIO and use that
+	 * regulator for "en-supply".
 	 */
+	data->en_supply = devm_regulator_get(dev, "en");
+	if (IS_ERR_OR_NULL(data->en_supply)) {
+		ret = PTR_ERR(data->en_supply);
+		data->en_supply = NULL;
+		return ret;
+	}
 
 	return 0;
 }
@@ -207,6 +245,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	} else
 		max = data->max_brightness;
 
+	pb->en_supply = data->en_supply;
 	pb->notify = data->notify;
 	pb->notify_after = data->notify_after;
 	pb->check_fb = data->check_fb;
@@ -268,7 +307,7 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 
 	backlight_device_unregister(bl);
 	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_disable(bl);
 	if (pb->exit)
 		pb->exit(&pdev->dev);
 	return 0;
@@ -283,7 +322,7 @@ static int pwm_backlight_suspend(struct device *dev)
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
 	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_disable(bl);
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, 0);
 	return 0;
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..330512b 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -8,6 +8,7 @@
 
 struct platform_pwm_backlight_data {
 	int pwm_id;
+	struct regulator *en_supply;
 	unsigned int max_brightness;
 	unsigned int dft_brightness;
 	unsigned int lth_brightness;
-- 
1.7.9.5

