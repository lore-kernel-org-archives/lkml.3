Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaHSM6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:58:31 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:49259 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbaHSM62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:58:28 -0400
From: Vincent Donnefort <vdonnefort@gmail.com>
To: hughd@google.com, cooloney@gmail.com
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Vincent Donnefort <vdonnefort@gmail.com>
Subject: [PATCH] leds: make led_blink_set IRQ safe
Date: Tue, 19 Aug 2014 14:58:21 +0200
Message-Id: <1408453101-30290-2-git-send-email-vdonnefort@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408453101-30290-1-git-send-email-vdonnefort@gmail.com>
References: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils>
 <1408453101-30290-1-git-send-email-vdonnefort@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a work which take care of reseting the blink workqueue and
avoid calling the cancel_delayed_work_sync function which may sleep, from an IRQ
context.

Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 129729d..0971554 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -148,6 +148,24 @@ static void led_work_function(struct work_struct *ws)
 			   msecs_to_jiffies(delay));
 }
 
+static void reset_blink_work_delayed(struct work_struct *ws)
+{
+	struct led_classdev *led_cdev =
+		container_of(ws, struct led_classdev, reset_blink_work);
+
+	cancel_delayed_work_sync(&led_cdev->blink_work);
+
+	if (!led_cdev->blink_delay_on) {
+		__led_set_brightness(led_cdev, LED_OFF);
+		return;
+	} else if (!led_cdev->blink_delay_off) {
+		__led_set_brightness(led_cdev, led_cdev->blink_brightness);
+		return;
+	}
+
+	queue_delayed_work(system_wq, &led_cdev->blink_work, 1);
+}
+
 static void set_brightness_delayed(struct work_struct *ws)
 {
 	struct led_classdev *led_cdev =
@@ -234,6 +252,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	INIT_WORK(&led_cdev->set_brightness_work, set_brightness_delayed);
 
 	INIT_DELAYED_WORK(&led_cdev->blink_work, led_work_function);
+	INIT_WORK(&led_cdev->reset_blink_work, reset_blink_work_delayed);
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	led_trigger_set_default(led_cdev);
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 4bb1168..959510a 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -40,19 +40,7 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
 	led_cdev->blink_delay_on = delay_on;
 	led_cdev->blink_delay_off = delay_off;
 
-	/* never on - just set to off */
-	if (!delay_on) {
-		__led_set_brightness(led_cdev, LED_OFF);
-		return;
-	}
-
-	/* never off - just set to brightness */
-	if (!delay_off) {
-		__led_set_brightness(led_cdev, led_cdev->blink_brightness);
-		return;
-	}
-
-	queue_delayed_work(system_wq, &led_cdev->blink_work, 1);
+	schedule_work(&led_cdev->reset_blink_work);
 }
 
 
@@ -76,8 +64,6 @@ void led_blink_set(struct led_classdev *led_cdev,
 		   unsigned long *delay_on,
 		   unsigned long *delay_off)
 {
-	cancel_delayed_work_sync(&led_cdev->blink_work);
-
 	led_cdev->flags &= ~LED_BLINK_ONESHOT;
 	led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 6a599dc..6e5523d 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -69,6 +69,7 @@ struct led_classdev {
 
 	unsigned long		 blink_delay_on, blink_delay_off;
 	struct delayed_work	 blink_work;
+	struct work_struct	 reset_blink_work;
 	int			 blink_brightness;
 
 	struct work_struct	set_brightness_work;
-- 
1.9.1

