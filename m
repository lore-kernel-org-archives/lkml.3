Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab3K1JG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:06:58 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58559 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3K1JGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:06:51 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
CC: <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH] leds: pwm: Fix for deferred probe in DT booted mode
Date: Thu, 28 Nov 2013 11:06:38 +0200
Message-ID: <1385629598-16205-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to make sure that the error code from devm_of_pwm_get() is the one
the module returns in case of failure.
Restructure the code to make this possible for DT booted case.
With this patch the driver can ask for deferred probing when the board is
booted with DT.
Fixes for example omap4-sdp board's keyboard backlight led.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Hi,

it would be good if this can make it to 3.13 since with -rc1 the keypad led does
not work.

Regards,
Peter

 drivers/leds/leds-pwm.c | 53 ++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 2848171..b31d8e9 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -82,22 +82,12 @@ static inline size_t sizeof_pwm_leds_priv(int num_leds)
 		      (sizeof(struct led_pwm_data) * num_leds);
 }
 
-static struct led_pwm_priv *led_pwm_create_of(struct platform_device *pdev)
+static int led_pwm_create_of(struct platform_device *pdev,
+			     struct led_pwm_priv *priv)
 {
 	struct device_node *node = pdev->dev.of_node;
 	struct device_node *child;
-	struct led_pwm_priv *priv;
-	int count, ret;
-
-	/* count LEDs in this device, so we know how much to allocate */
-	count = of_get_child_count(node);
-	if (!count)
-		return NULL;
-
-	priv = devm_kzalloc(&pdev->dev, sizeof_pwm_leds_priv(count),
-			    GFP_KERNEL);
-	if (!priv)
-		return NULL;
+	int ret;
 
 	for_each_child_of_node(node, child) {
 		struct led_pwm_data *led_dat = &priv->leds[priv->num_leds];
@@ -109,6 +99,7 @@ static struct led_pwm_priv *led_pwm_create_of(struct platform_device *pdev)
 		if (IS_ERR(led_dat->pwm)) {
 			dev_err(&pdev->dev, "unable to request PWM for %s\n",
 				led_dat->cdev.name);
+			ret = PTR_ERR(led_dat->pwm);
 			goto err;
 		}
 		/* Get the period from PWM core when n*/
@@ -137,28 +128,36 @@ static struct led_pwm_priv *led_pwm_create_of(struct platform_device *pdev)
 		priv->num_leds++;
 	}
 
-	return priv;
+	return 0;
 err:
 	while (priv->num_leds--)
 		led_classdev_unregister(&priv->leds[priv->num_leds].cdev);
 
-	return NULL;
+	return ret;
 }
 
 static int led_pwm_probe(struct platform_device *pdev)
 {
 	struct led_pwm_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct led_pwm_priv *priv;
-	int i, ret = 0;
+	int count, i;
+	int ret = 0;
+
+	if (pdata)
+		count = pdata->num_leds;
+	else
+		count = of_get_child_count(pdev->dev.of_node);
+
+	if (!count)
+		return -EINVAL;
 
-	if (pdata && pdata->num_leds) {
-		priv = devm_kzalloc(&pdev->dev,
-				    sizeof_pwm_leds_priv(pdata->num_leds),
-				    GFP_KERNEL);
-		if (!priv)
-			return -ENOMEM;
+	priv = devm_kzalloc(&pdev->dev, sizeof_pwm_leds_priv(count),
+			    GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
-		for (i = 0; i < pdata->num_leds; i++) {
+	if (pdata) {
+		for (i = 0; i < count; i++) {
 			struct led_pwm *cur_led = &pdata->leds[i];
 			struct led_pwm_data *led_dat = &priv->leds[i];
 
@@ -188,11 +187,11 @@ static int led_pwm_probe(struct platform_device *pdev)
 			if (ret < 0)
 				goto err;
 		}
-		priv->num_leds = pdata->num_leds;
+		priv->num_leds = count;
 	} else {
-		priv = led_pwm_create_of(pdev);
-		if (!priv)
-			return -ENODEV;
+		ret = led_pwm_create_of(pdev, priv);
+		if (ret)
+			return ret;
 	}
 
 	platform_set_drvdata(pdev, priv);
-- 
1.8.4.2

