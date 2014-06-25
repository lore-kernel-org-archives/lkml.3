Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaFYRLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:11:03 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43586 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbaFYRJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:09:56 -0400
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
Subject: [PATCH 11/13] input: lm8323: fix attribute-creation race
Date: Wed, 25 Jun 2014 19:08:54 +0200
Message-Id: <1403716136-32694-12-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403716136-32694-1-git-send-email-johan@kernel.org>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the attribute groups of the led-class to create the time attribute
during probe in order to avoid racing with userspace.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/input/keyboard/lm8323.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
index 0b42118cbf8f..cb32e2b506b7 100644
--- a/drivers/input/keyboard/lm8323.c
+++ b/drivers/input/keyboard/lm8323.c
@@ -558,6 +558,12 @@ static ssize_t lm8323_pwm_store_time(struct device *dev,
 }
 static DEVICE_ATTR(time, 0644, lm8323_pwm_show_time, lm8323_pwm_store_time);
 
+static struct attribute *lm8323_pwm_attrs[] = {
+	&dev_attr_time.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(lm8323_pwm);
+
 static int init_pwm(struct lm8323_chip *lm, int id, struct device *dev,
 		    const char *name)
 {
@@ -580,16 +586,11 @@ static int init_pwm(struct lm8323_chip *lm, int id, struct device *dev,
 	if (name) {
 		pwm->cdev.name = name;
 		pwm->cdev.brightness_set = lm8323_pwm_set_brightness;
+		pwm->cdev.groups = lm8323_pwm_groups;
 		if (led_classdev_register(dev, &pwm->cdev) < 0) {
 			dev_err(dev, "couldn't register PWM %d\n", id);
 			return -1;
 		}
-		if (device_create_file(pwm->cdev.dev,
-					&dev_attr_time) < 0) {
-			dev_err(dev, "couldn't register time attribute\n");
-			led_classdev_unregister(&pwm->cdev);
-			return -1;
-		}
 		pwm->enabled = true;
 	}
 
@@ -753,11 +754,8 @@ fail3:
 	device_remove_file(&client->dev, &dev_attr_disable_kp);
 fail2:
 	while (--pwm >= 0)
-		if (lm->pwm[pwm].enabled) {
-			device_remove_file(lm->pwm[pwm].cdev.dev,
-					   &dev_attr_time);
+		if (lm->pwm[pwm].enabled)
 			led_classdev_unregister(&lm->pwm[pwm].cdev);
-		}
 fail1:
 	input_free_device(idev);
 	kfree(lm);
@@ -777,10 +775,8 @@ static int lm8323_remove(struct i2c_client *client)
 	device_remove_file(&lm->client->dev, &dev_attr_disable_kp);
 
 	for (i = 0; i < 3; i++)
-		if (lm->pwm[i].enabled) {
-			device_remove_file(lm->pwm[i].cdev.dev, &dev_attr_time);
+		if (lm->pwm[i].enabled)
 			led_classdev_unregister(&lm->pwm[i].cdev);
-		}
 
 	kfree(lm);
 
-- 
1.8.5.5

