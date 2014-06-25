Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaFYRK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:10:59 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51541 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847AbaFYRJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:09:57 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 13/13] leds: lp55xx-common: fix attribute-creation race
Date: Wed, 25 Jun 2014 19:08:56 +0200
Message-Id: <1403716136-32694-14-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403716136-32694-1-git-send-email-johan@kernel.org>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the attribute groups of the led-class to create the LED attributes
during probe in order to avoid racing with userspace.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-lp55xx-common.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 3fbfb31602c7..77c26bc32eed 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -127,15 +127,12 @@ static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, lp55xx_show_current,
 		lp55xx_store_current);
 static DEVICE_ATTR(max_current, S_IRUGO , lp55xx_show_max_current, NULL);
 
-static struct attribute *lp55xx_led_attributes[] = {
+static struct attribute *lp55xx_led_attrs[] = {
 	&dev_attr_led_current.attr,
 	&dev_attr_max_current.attr,
 	NULL,
 };
-
-static struct attribute_group lp55xx_led_attr_group = {
-	.attrs = lp55xx_led_attributes
-};
+ATTRIBUTE_GROUPS(lp55xx_led);
 
 static void lp55xx_set_brightness(struct led_classdev *cdev,
 			     enum led_brightness brightness)
@@ -176,6 +173,7 @@ static int lp55xx_init_led(struct lp55xx_led *led,
 	}
 
 	led->cdev.brightness_set = lp55xx_set_brightness;
+	led->cdev.groups = lp55xx_led_groups;
 
 	if (pdata->led_config[chan].name) {
 		led->cdev.name = pdata->led_config[chan].name;
@@ -185,24 +183,12 @@ static int lp55xx_init_led(struct lp55xx_led *led,
 		led->cdev.name = name;
 	}
 
-	/*
-	 * register led class device for each channel and
-	 * add device attributes
-	 */
-
 	ret = led_classdev_register(dev, &led->cdev);
 	if (ret) {
 		dev_err(dev, "led register err: %d\n", ret);
 		return ret;
 	}
 
-	ret = sysfs_create_group(&led->cdev.dev->kobj, &lp55xx_led_attr_group);
-	if (ret) {
-		dev_err(dev, "led sysfs err: %d\n", ret);
-		led_classdev_unregister(&led->cdev);
-		return ret;
-	}
-
 	return 0;
 }
 
@@ -520,8 +506,6 @@ void lp55xx_unregister_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
 
 	for (i = 0; i < chip->num_leds; i++) {
 		each = led + i;
-		sysfs_remove_group(&each->cdev.dev->kobj,
-						&lp55xx_led_attr_group);
 		led_classdev_unregister(&each->cdev);
 		flush_work(&each->brightness_work);
 	}
-- 
1.8.5.5

