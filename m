Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3AYKJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:09:13 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:56188 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756149Ab3AYKIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:08:44 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can sleep
Date: Fri, 25 Jan 2013 11:01:54 +0100
Message-Id: <1359108114-16998-4-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1359108114-16998-1-git-send-email-florian.vaussard@epfl.ch>
References: <1359108114-16998-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call to led_pwm_set() can happen inside atomic context, like triggers.
If the PWM call can sleep, defer using a worker.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/leds/leds-pwm.c |   45 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index a1ea5f6..1ffb6ba 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -23,12 +23,15 @@
 #include <linux/pwm.h>
 #include <linux/leds_pwm.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 struct led_pwm_data {
 	struct led_classdev	cdev;
 	struct pwm_device	*pwm;
+	struct work_struct	work;
 	unsigned int		active_low;
 	unsigned int		period;
+	int			duty;
 };
 
 struct led_pwm_priv {
@@ -36,6 +39,20 @@ struct led_pwm_priv {
 	struct led_pwm_data leds[0];
 };
 
+static void led_pwm_work(struct work_struct *work)
+{
+	struct led_pwm_data *led_dat =
+		container_of(work, struct led_pwm_data, work);
+	int new_duty = led_dat->duty;
+
+	pwm_config(led_dat->pwm, new_duty, led_dat->period);
+
+	if (new_duty == 0)
+		pwm_disable(led_dat->pwm);
+	else
+		pwm_enable(led_dat->pwm);
+}
+
 static void led_pwm_set(struct led_classdev *led_cdev,
 	enum led_brightness brightness)
 {
@@ -43,13 +60,23 @@ static void led_pwm_set(struct led_classdev *led_cdev,
 		container_of(led_cdev, struct led_pwm_data, cdev);
 	unsigned int max = led_dat->cdev.max_brightness;
 	unsigned int period =  led_dat->period;
+	int duty;
 
-	if (brightness == 0) {
-		pwm_config(led_dat->pwm, 0, period);
-		pwm_disable(led_dat->pwm);
+	if (brightness == 0)
+		duty = 0;
+	else
+		duty = brightness * period / max;
+
+	if (pwm_can_sleep(led_dat->pwm)) {
+		led_dat->duty = duty;
+		schedule_work(&led_dat->work);
 	} else {
-		pwm_config(led_dat->pwm, brightness * period / max, period);
-		pwm_enable(led_dat->pwm);
+		pwm_config(led_dat->pwm, duty, period);
+
+		if (duty == 0)
+			pwm_disable(led_dat->pwm);
+		else
+			pwm_enable(led_dat->pwm);
 	}
 }
 
@@ -100,6 +127,8 @@ static struct led_pwm_priv *led_pwm_create_of(struct platform_device *pdev)
 		led_dat->cdev.brightness = LED_OFF;
 		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
+		INIT_WORK(&led_dat->work, led_pwm_work);
+
 		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to register for %s\n",
@@ -153,6 +182,8 @@ static int led_pwm_probe(struct platform_device *pdev)
 			led_dat->cdev.max_brightness = cur_led->max_brightness;
 			led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
+			INIT_WORK(&led_dat->work, led_pwm_work);
+
 			ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
 			if (ret < 0)
 				goto err;
@@ -180,8 +211,10 @@ static int led_pwm_remove(struct platform_device *pdev)
 	struct led_pwm_priv *priv = platform_get_drvdata(pdev);
 	int i;
 
-	for (i = 0; i < priv->num_leds; i++)
+	for (i = 0; i < priv->num_leds; i++) {
 		led_classdev_unregister(&priv->leds[i].cdev);
+		cancel_work_sync(&priv->leds[i].work);
+	}
 
 	return 0;
 }
-- 
1.7.5.4

