Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaLQWGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:06:10 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54516 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaLQWGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:06:08 -0500
Date: Wed, 17 Dec 2014 14:06:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Subject: Re: [PATCH v7 1/3] Input: add regulator haptic driver
Message-ID: <20141217220602.GC32399@dtor-ws>
References: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com>
 <1418787308-29019-2-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418787308-29019-2-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Jaewon,

On Wed, Dec 17, 2014 at 12:35:06PM +0900, Jaewon Kim wrote:
> This patch adds support for haptic driver controlled by
> voltage of regulator. And this driver support for
> Force Feedback interface from input framework
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Does the driver still work if you apply the patch below on top of yours?

Thanks.

-- 
Dmitry


Input: regulator-haptics - misc changes

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/Kconfig            |    4 -
 drivers/input/misc/regulator-haptic.c |  164 ++++++++++++++++++++-------------
 2 files changed, 100 insertions(+), 68 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index e5e556d..0b652c5 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -395,11 +395,11 @@ config INPUT_CM109
 	  called cm109.
 
 config INPUT_REGULATOR_HAPTIC
-	tristate "regulator haptics support"
+	tristate "Regulator haptics support"
 	select INPUT_FF_MEMLESS
 	help
 	  This option enables device driver support for the haptic controlled
-	  by regulator. This driver supports ff-memless interface
+	  by a regulator. This driver supports ff-memless interface
 	  from input framework.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/input/misc/regulator-haptic.c b/drivers/input/misc/regulator-haptic.c
index 16f5ec8..9426221 100644
--- a/drivers/input/misc/regulator-haptic.c
+++ b/drivers/input/misc/regulator-haptic.c
@@ -28,55 +28,78 @@ struct regulator_haptic {
 	struct work_struct work;
 	struct mutex mutex;
 
-	bool enabled;
-	bool suspend_state;
+	bool active;
+	bool suspended;
+
 	unsigned int max_volt;
 	unsigned int min_volt;
-	unsigned int intensity;
 	unsigned int magnitude;
 };
 
-static void regulator_haptic_enable(struct regulator_haptic *haptic, bool state)
+static int regulator_haptic_toggle(struct regulator_haptic *haptic, bool on)
 {
 	int error;
 
-	if (haptic->enabled == state)
-		return;
+	if (haptic->active != on) {
+
+		error = on ? regulator_enable(haptic->regulator) :
+			     regulator_disable(haptic->regulator);
+		if (error) {
+			dev_err(haptic->dev,
+				"failed to switch regulator %s: %d\n",
+				on ? "on" : "off", error);
+			return error;
+		}
+
+		haptic->active = on;
+	}
 
-	error = state ? regulator_enable(haptic->regulator) :
-		regulator_disable(haptic->regulator);
+	return 0;
+}
+
+static int regulator_haptic_set_voltage(struct regulator_haptic *haptic,
+					 unsigned int magnitude)
+{
+	u64 volt_mag_multi;
+	unsigned int intensity;
+	int error;
+
+	volt_mag_multi = (u64)(haptic->max_volt - haptic->min_volt) * magnitude;
+	intensity = (unsigned int)(volt_mag_multi >> MAX_MAGNITUDE_SHIFT);
+
+	error = regulator_set_voltage(haptic->regulator,
+				      intensity + haptic->min_volt,
+				      haptic->max_volt);
 	if (error) {
-		dev_err(haptic->dev, "cannot enable regulator\n");
-		return;
+		dev_err(haptic->dev, "cannot set regulator voltage to %d: %d\n",
+			intensity + haptic->min_volt, error);
+		return error;
 	}
 
-	haptic->enabled = state;
+	return 0;
 }
 
 static void regulator_haptic_work(struct work_struct *work)
 {
 	struct regulator_haptic *haptic = container_of(work,
 					struct regulator_haptic, work);
+	unsigned int magnitude;
 	int error;
 
 	mutex_lock(&haptic->mutex);
 
-	if (haptic->suspend_state)
-		goto err;
+	if (haptic->suspended)
+		goto out;
 
-	error = regulator_set_voltage(haptic->regulator,
-			haptic->intensity + haptic->min_volt, haptic->max_volt);
-	if (error) {
-		dev_err(haptic->dev, "cannot set regulator voltage\n");
-		goto err;
-	}
+	magnitude = ACCESS_ONCE(haptic->magnitude);
 
-	if (haptic->magnitude)
-		regulator_haptic_enable(haptic, true);
-	else
-		regulator_haptic_enable(haptic, false);
+	error = regulator_haptic_set_voltage(haptic, magnitude);
+	if (error)
+		goto out;
 
-err:
+	regulator_haptic_toggle(haptic, magnitude != 0);
+
+out:
 	mutex_unlock(&haptic->mutex);
 }
 
@@ -84,18 +107,11 @@ static int regulator_haptic_play_effect(struct input_dev *input, void *data,
 					struct ff_effect *effect)
 {
 	struct regulator_haptic *haptic = input_get_drvdata(input);
-	u64 volt_mag_multi;
 
 	haptic->magnitude = effect->u.rumble.strong_magnitude;
 	if (!haptic->magnitude)
 		haptic->magnitude = effect->u.rumble.weak_magnitude;
 
-
-	volt_mag_multi = (u64)(haptic->max_volt - haptic->min_volt) *
-					haptic->magnitude;
-	haptic->intensity = (unsigned int)(volt_mag_multi >>
-					MAX_MAGNITUDE_SHIFT);
-
 	schedule_work(&haptic->work);
 
 	return 0;
@@ -106,35 +122,32 @@ static void regulator_haptic_close(struct input_dev *input)
 	struct regulator_haptic *haptic = input_get_drvdata(input);
 
 	cancel_work_sync(&haptic->work);
-	regulator_haptic_enable(haptic, false);
+	regulator_haptic_set_voltage(haptic, 0);
+	regulator_haptic_toggle(haptic, false);
 }
 
-static int regulator_haptic_get_data(struct platform_device *pdev)
+static int __maybe_unused
+regulator_haptic_parse_dt(struct device *dev, struct regulator_haptic *haptic)
 {
-	struct device_node *node = pdev->dev.of_node;
-	struct regulator_haptic_data *data = dev_get_platdata(&pdev->dev);
-	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+	struct device_node *node;
 	int error;
 
-	if (data) {
-		haptic->max_volt = data->max_volt;
-		haptic->min_volt = data->min_volt;
-	} else if (pdev->dev.of_node) {
-		error = of_property_read_u32(node, "max-microvolt",
-				&haptic->max_volt);
-		if (error) {
-			dev_err(&pdev->dev, "cannot parse max-microvolt\n");
-			return error;
-		}
+	node = dev->of_node;
+	if(!node) {
+		dev_err(dev, "Missing dveice tree data\n");
+		return -EINVAL;
+	}
 
-		error = of_property_read_u32(node, "min-microvolt",
-				&haptic->min_volt);
-		if (error) {
-			dev_err(&pdev->dev, "cannot parse min-microvolt\n");
-			return error;
-		}
-	} else {
-		return -ENODEV;
+	error = of_property_read_u32(node, "max-microvolt", &haptic->max_volt);
+	if (error) {
+		dev_err(dev, "cannot parse max-microvolt\n");
+		return error;
+	}
+
+	error = of_property_read_u32(node, "min-microvolt", &haptic->min_volt);
+	if (error) {
+		dev_err(dev, "cannot parse min-microvolt\n");
+		return error;
 	}
 
 	return 0;
@@ -142,6 +155,7 @@ static int regulator_haptic_get_data(struct platform_device *pdev)
 
 static int regulator_haptic_probe(struct platform_device *pdev)
 {
+	const struct regulator_haptic_data *pdata = dev_get_platdata(&pdev->dev);
 	struct regulator_haptic *haptic;
 	struct input_dev *input_dev;
 	int error;
@@ -152,15 +166,19 @@ static int regulator_haptic_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, haptic);
 	haptic->dev = &pdev->dev;
-	haptic->enabled = false;
-	haptic->suspend_state = false;
 	mutex_init(&haptic->mutex);
 	INIT_WORK(&haptic->work, regulator_haptic_work);
 
-	error = regulator_haptic_get_data(pdev);
-	if (error) {
-		dev_err(&pdev->dev, "failed to get voltage value\n");
-		return error;
+	if (pdata) {
+		haptic->max_volt = pdata->max_volt;
+		haptic->min_volt = pdata->min_volt;
+	} else if (IS_ENABLED(CONFIG_OF)) {
+		error = regulator_haptic_parse_dt(&pdev->dev, haptic);
+		if (error)
+			return error;
+	} else {
+		dev_err(&pdev->dev, "Missing platform data\n");
+		return -EINVAL;
 	}
 
 	haptic->regulator = devm_regulator_get_exclusive(&pdev->dev, "haptic");
@@ -181,7 +199,7 @@ static int regulator_haptic_probe(struct platform_device *pdev)
 	input_set_capability(haptic->input_dev, EV_FF, FF_RUMBLE);
 
 	error = input_ff_create_memless(input_dev, NULL,
-			      regulator_haptic_play_effect);
+					regulator_haptic_play_effect);
 	if (error) {
 		dev_err(&pdev->dev, "failed to create force-feedback\n");
 		return error;
@@ -200,13 +218,16 @@ static int __maybe_unused regulator_haptic_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+	int error;
 
-	mutex_lock(&haptic->mutex);
+	error = mutex_lock_interruptible(&haptic->mutex);
+	if (error)
+		return error;
 
-	haptic->suspend_state = true;
+	regulator_haptic_set_voltage(haptic, 0);
+	regulator_haptic_toggle(haptic, false);
 
-	if (haptic->enabled)
-		regulator_haptic_enable(haptic, false);
+	haptic->suspended = true;
 
 	mutex_unlock(&haptic->mutex);
 
@@ -217,8 +238,19 @@ static int __maybe_unused regulator_haptic_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+	unsigned int magnitude;
+
+	mutex_lock(&haptic->mutex);
+
+	haptic->suspended = false;
 
-	haptic->suspend_state = false;
+	magnitude = ACCESS_ONCE(haptic->magnitude);
+	if (magnitude) {
+		regulator_haptic_set_voltage(haptic, magnitude);
+		regulator_haptic_toggle(haptic, true);
+	}
+
+	mutex_unlock(&haptic->mutex);
 
 	return 0;
 }
