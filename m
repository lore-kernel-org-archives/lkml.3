Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbaFYRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:09:59 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:37858 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813AbaFYRJy (ORCPT
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
Subject: [PATCH 02/13] leds: lm3550: fix attribute-creation race
Date: Wed, 25 Jun 2014 19:08:45 +0200
Message-Id: <1403716136-32694-3-git-send-email-johan@kernel.org>
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
 drivers/leds/leds-lm3530.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 652368c2ea9a..91325de3cd33 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -400,6 +400,12 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 }
 static DEVICE_ATTR(mode, 0644, lm3530_mode_get, lm3530_mode_set);
 
+static struct attribute *lm3530_attrs[] = {
+	&dev_attr_mode.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(lm3530);
+
 static int lm3530_probe(struct i2c_client *client,
 			   const struct i2c_device_id *id)
 {
@@ -436,6 +442,7 @@ static int lm3530_probe(struct i2c_client *client,
 	drvdata->led_dev.name = LM3530_LED_DEV;
 	drvdata->led_dev.brightness_set = lm3530_brightness_set;
 	drvdata->led_dev.max_brightness = MAX_BRIGHTNESS;
+	drvdata->led_dev.groups = lm3530_groups;
 
 	i2c_set_clientdata(client, drvdata);
 
@@ -461,26 +468,13 @@ static int lm3530_probe(struct i2c_client *client,
 		return err;
 	}
 
-	err = device_create_file(drvdata->led_dev.dev, &dev_attr_mode);
-	if (err < 0) {
-		dev_err(&client->dev, "File device creation failed: %d\n", err);
-		err = -ENODEV;
-		goto err_create_file;
-	}
-
 	return 0;
-
-err_create_file:
-	led_classdev_unregister(&drvdata->led_dev);
-	return err;
 }
 
 static int lm3530_remove(struct i2c_client *client)
 {
 	struct lm3530_data *drvdata = i2c_get_clientdata(client);
 
-	device_remove_file(drvdata->led_dev.dev, &dev_attr_mode);
-
 	lm3530_led_disable(drvdata);
 	led_classdev_unregister(&drvdata->led_dev);
 	return 0;
-- 
1.8.5.5

