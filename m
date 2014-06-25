Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829AbaFYRNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:13:09 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:53546 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819AbaFYRJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:09:55 -0400
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
Subject: [PATCH 03/13] leds: lm3533: fix attribute-creation race
Date: Wed, 25 Jun 2014 19:08:46 +0200
Message-Id: <1403716136-32694-4-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403716136-32694-1-git-send-email-johan@kernel.org>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the attribute groups of the led-class to create the attributes
during probe in order to avoid racing with userspace.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-lm3533.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/leds/leds-lm3533.c b/drivers/leds/leds-lm3533.c
index e2c642c1169b..cbf61a40137d 100644
--- a/drivers/leds/leds-lm3533.c
+++ b/drivers/leds/leds-lm3533.c
@@ -645,6 +645,11 @@ static struct attribute_group lm3533_led_attribute_group = {
 	.attrs		= lm3533_led_attributes
 };
 
+static const struct attribute_group *lm3533_led_attribute_groups[] = {
+	&lm3533_led_attribute_group,
+	NULL
+};
+
 static int lm3533_led_setup(struct lm3533_led *led,
 					struct lm3533_led_platform_data *pdata)
 {
@@ -692,6 +697,7 @@ static int lm3533_led_probe(struct platform_device *pdev)
 	led->cdev.brightness_get = lm3533_led_get;
 	led->cdev.blink_set = lm3533_led_blink_set;
 	led->cdev.brightness = LED_OFF;
+	led->cdev.groups = lm3533_led_attribute_groups,
 	led->id = pdev->id;
 
 	mutex_init(&led->mutex);
@@ -715,25 +721,16 @@ static int lm3533_led_probe(struct platform_device *pdev)
 
 	led->cb.dev = led->cdev.dev;
 
-	ret = sysfs_create_group(&led->cdev.dev->kobj,
-						&lm3533_led_attribute_group);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to create sysfs attributes\n");
-		goto err_unregister;
-	}
-
 	ret = lm3533_led_setup(led, pdata);
 	if (ret)
-		goto err_sysfs_remove;
+		goto err_unregister;
 
 	ret = lm3533_ctrlbank_enable(&led->cb);
 	if (ret)
-		goto err_sysfs_remove;
+		goto err_unregister;
 
 	return 0;
 
-err_sysfs_remove:
-	sysfs_remove_group(&led->cdev.dev->kobj, &lm3533_led_attribute_group);
 err_unregister:
 	led_classdev_unregister(&led->cdev);
 	flush_work(&led->work);
@@ -748,7 +745,6 @@ static int lm3533_led_remove(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
 	lm3533_ctrlbank_disable(&led->cb);
-	sysfs_remove_group(&led->cdev.dev->kobj, &lm3533_led_attribute_group);
 	led_classdev_unregister(&led->cdev);
 	flush_work(&led->work);
 
-- 
1.8.5.5

