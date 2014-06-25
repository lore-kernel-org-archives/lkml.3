Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbaFYRNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:13:07 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:47263 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820AbaFYRJz (ORCPT
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
Subject: [PATCH 05/13] leds: lm3642: fix attribute-creation race
Date: Wed, 25 Jun 2014 19:08:48 +0200
Message-Id: <1403716136-32694-6-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403716136-32694-1-git-send-email-johan@kernel.org>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the attribute groups of the led-class to create the flash and
torch-LED attributes during probe in order to avoid racing with
userspace.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-lm3642.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/leds/leds-lm3642.c b/drivers/leds/leds-lm3642.c
index ceb6b3cde6fe..d3dec0132769 100644
--- a/drivers/leds/leds-lm3642.c
+++ b/drivers/leds/leds-lm3642.c
@@ -313,6 +313,18 @@ static const struct regmap_config lm3642_regmap = {
 	.max_register = REG_MAX,
 };
 
+static struct attribute *lm3642_flash_attrs[] = {
+	&dev_attr_strobe_pin.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(lm3642_flash);
+
+static struct attribute *lm3642_torch_attrs[] = {
+	&dev_attr_torch_pin.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(lm3642_torch);
+
 static int lm3642_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
@@ -364,17 +376,13 @@ static int lm3642_probe(struct i2c_client *client,
 	chip->cdev_flash.max_brightness = 16;
 	chip->cdev_flash.brightness_set = lm3642_strobe_brightness_set;
 	chip->cdev_flash.default_trigger = "flash";
+	chip->cdev_flash.groups = lm3642_flash_groups,
 	err = led_classdev_register((struct device *)
 				    &client->dev, &chip->cdev_flash);
 	if (err < 0) {
 		dev_err(chip->dev, "failed to register flash\n");
 		goto err_out;
 	}
-	err = device_create_file(chip->cdev_flash.dev, &dev_attr_strobe_pin);
-	if (err < 0) {
-		dev_err(chip->dev, "failed to create strobe-pin file\n");
-		goto err_create_flash_pin_file;
-	}
 
 	/* torch */
 	INIT_WORK(&chip->work_torch, lm3642_deferred_torch_brightness_set);
@@ -382,17 +390,13 @@ static int lm3642_probe(struct i2c_client *client,
 	chip->cdev_torch.max_brightness = 8;
 	chip->cdev_torch.brightness_set = lm3642_torch_brightness_set;
 	chip->cdev_torch.default_trigger = "torch";
+	chip->cdev_torch.groups = lm3642_torch_groups,
 	err = led_classdev_register((struct device *)
 				    &client->dev, &chip->cdev_torch);
 	if (err < 0) {
 		dev_err(chip->dev, "failed to register torch\n");
 		goto err_create_torch_file;
 	}
-	err = device_create_file(chip->cdev_torch.dev, &dev_attr_torch_pin);
-	if (err < 0) {
-		dev_err(chip->dev, "failed to create torch-pin file\n");
-		goto err_create_torch_pin_file;
-	}
 
 	/* indicator */
 	INIT_WORK(&chip->work_indicator,
@@ -411,12 +415,8 @@ static int lm3642_probe(struct i2c_client *client,
 	return 0;
 
 err_create_indicator_file:
-	device_remove_file(chip->cdev_torch.dev, &dev_attr_torch_pin);
-err_create_torch_pin_file:
 	led_classdev_unregister(&chip->cdev_torch);
 err_create_torch_file:
-	device_remove_file(chip->cdev_flash.dev, &dev_attr_strobe_pin);
-err_create_flash_pin_file:
 	led_classdev_unregister(&chip->cdev_flash);
 err_out:
 	return err;
@@ -428,10 +428,8 @@ static int lm3642_remove(struct i2c_client *client)
 
 	led_classdev_unregister(&chip->cdev_indicator);
 	flush_work(&chip->work_indicator);
-	device_remove_file(chip->cdev_torch.dev, &dev_attr_torch_pin);
 	led_classdev_unregister(&chip->cdev_torch);
 	flush_work(&chip->work_torch);
-	device_remove_file(chip->cdev_flash.dev, &dev_attr_strobe_pin);
 	led_classdev_unregister(&chip->cdev_flash);
 	flush_work(&chip->work_flash);
 	regmap_write(chip->regmap, REG_ENABLE, 0);
-- 
1.8.5.5

