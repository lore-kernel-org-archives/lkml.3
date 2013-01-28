Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3A1OBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:01:12 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:54664 "HELO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756931Ab3A1OBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:01:08 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH v3 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can sleep
Date: Mon, 28 Jan 2013 15:00:59 +0100
Message-Id: <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch>
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call to led_pwm_set() can happen inside atomic context, like triggers.
If the PWM call can sleep, defer using a worker.

Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/leds/leds-pwm.c |   50 +++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index a1ea5f6..faf52c0 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -23,12 +23,16 @@
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
+	bool			can_sleep;
 };
 
 struct led_pwm_priv {
@@ -36,6 +40,26 @@ struct led_pwm_priv {
 	struct led_pwm_data leds[0];
 };
 
+static void __led_pwm_set(struct led_pwm_data *led_dat)
+{
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
+static void led_pwm_work(struct work_struct *work)
+{
+	struct led_pwm_data *led_dat =
+		container_of(work, struct led_pwm_data, work);
+
+	__led_pwm_set(led_dat);
+}
+
 static void led_pwm_set(struct led_classdev *led_cdev,
 	enum led_brightness brightness)
 {
@@ -44,13 +68,12 @@ static void led_pwm_set(struct led_classdev *led_cdev,
 	unsigned int max = led_dat->cdev.max_brightness;
 	unsigned int period =  led_dat->period;
 
-	if (brightness == 0) {
-		pwm_config(led_dat->pwm, 0, period);
-		pwm_disable(led_dat->pwm);
-	} else {
-		pwm_config(led_dat->pwm, brightness * period / max, period);
-		pwm_enable(led_dat->pwm);
-	}
+	led_dat->duty = brightness * period / max;
+
+	if (led_dat->can_sleep)
+		schedule_work(&led_dat->work);
+	else
+		__led_pwm_set(led_dat);
 }
 
 static inline size_t sizeof_pwm_leds_priv(int num_leds)
@@ -100,6 +123,10 @@ static struct led_pwm_priv *led_pwm_create_of(struct platform_device *pdev)
 		led_dat->cdev.brightness = LED_OFF;
 		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
+		led_dat->can_sleep = pwm_can_sleep(led_dat->pwm);
+		if (led_dat->can_sleep)
+			INIT_WORK(&led_dat->work, led_pwm_work);
+
 		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to register for %s\n",
@@ -153,6 +180,10 @@ static int led_pwm_probe(struct platform_device *pdev)
 			led_dat->cdev.max_brightness = cur_led->max_brightness;
 			led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
+			led_dat->can_sleep = pwm_can_sleep(led_dat->pwm);
+			if (led_dat->can_sleep)
+				INIT_WORK(&led_dat->work, led_pwm_work);
+
 			ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
 			if (ret < 0)
 				goto err;
@@ -180,8 +211,11 @@ static int led_pwm_remove(struct platform_device *pdev)
 	struct led_pwm_priv *priv = platform_get_drvdata(pdev);
 	int i;
 
-	for (i = 0; i < priv->num_leds; i++)
+	for (i = 0; i < priv->num_leds; i++) {
 		led_classdev_unregister(&priv->leds[i].cdev);
+		if (priv->leds[i].can_sleep)
+			cancel_work_sync(&priv->leds[i].work);
+	}
 
 	return 0;
 }
-- 
1.7.5.4

