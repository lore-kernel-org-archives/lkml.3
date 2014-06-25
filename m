Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbaFYRKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:10:03 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:60953 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbaFYRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:09:54 -0400
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
Subject: [PATCH 06/13] leds: max8997: fix attribute-creation race
Date: Wed, 25 Jun 2014 19:08:49 +0200
Message-Id: <1403716136-32694-7-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403716136-32694-1-git-send-email-johan@kernel.org>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the attribute groups of the led-class to create the mode attribute
during probe in order to avoid racing with userspace.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-max8997.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/leds-max8997.c b/drivers/leds/leds-max8997.c
index f449a8bdddc7..607bc2755aba 100644
--- a/drivers/leds/leds-max8997.c
+++ b/drivers/leds/leds-max8997.c
@@ -229,6 +229,12 @@ static ssize_t max8997_led_store_mode(struct device *dev,
 
 static DEVICE_ATTR(mode, 0644, max8997_led_show_mode, max8997_led_store_mode);
 
+static struct attribute *max8997_attrs[] = {
+	&dev_attr_mode.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(max8997);
+
 static int max8997_led_probe(struct platform_device *pdev)
 {
 	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
@@ -253,6 +259,7 @@ static int max8997_led_probe(struct platform_device *pdev)
 	led->cdev.brightness_set = max8997_led_brightness_set;
 	led->cdev.flags |= LED_CORE_SUSPENDRESUME;
 	led->cdev.brightness = 0;
+	led->cdev.groups = max8997_groups;
 	led->iodev = iodev;
 
 	/* initialize mode and brightness according to platform_data */
@@ -281,14 +288,6 @@ static int max8997_led_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	ret = device_create_file(led->cdev.dev, &dev_attr_mode);
-	if (ret != 0) {
-		dev_err(&pdev->dev,
-			"failed to create file: %d\n", ret);
-		led_classdev_unregister(&led->cdev);
-		return ret;
-	}
-
 	return 0;
 }
 
@@ -296,7 +295,6 @@ static int max8997_led_remove(struct platform_device *pdev)
 {
 	struct max8997_led *led = platform_get_drvdata(pdev);
 
-	device_remove_file(led->cdev.dev, &dev_attr_mode);
 	led_classdev_unregister(&led->cdev);
 
 	return 0;
-- 
1.8.5.5

