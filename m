Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaFYRLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:11:06 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40027 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827AbaFYRJ4 (ORCPT
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
Subject: [PATCH 10/13] leds: wm831x-status: fix attribute-creation race
Date: Wed, 25 Jun 2014 19:08:53 +0200
Message-Id: <1403716136-32694-11-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403716136-32694-1-git-send-email-johan@kernel.org>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the attribute groups of the led-class to create the src attribute
during probe in order to avoid racing with userspace.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-wm831x-status.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/leds/leds-wm831x-status.c b/drivers/leds/leds-wm831x-status.c
index e72c974142d0..1b71e0701002 100644
--- a/drivers/leds/leds-wm831x-status.c
+++ b/drivers/leds/leds-wm831x-status.c
@@ -219,6 +219,12 @@ static ssize_t wm831x_status_src_store(struct device *dev,
 
 static DEVICE_ATTR(src, 0644, wm831x_status_src_show, wm831x_status_src_store);
 
+static struct attribute *wm831x_status_attrs[] = {
+	&dev_attr_src.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(wm831x_status);
+
 static int wm831x_status_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
@@ -232,8 +238,7 @@ static int wm831x_status_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "No register resource\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_status),
@@ -284,31 +289,21 @@ static int wm831x_status_probe(struct platform_device *pdev)
 	drvdata->cdev.default_trigger = pdata.default_trigger;
 	drvdata->cdev.brightness_set = wm831x_status_set;
 	drvdata->cdev.blink_set = wm831x_status_blink_set;
+	drvdata->cdev.groups = wm831x_status_groups;
 
 	ret = led_classdev_register(wm831x->dev, &drvdata->cdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
-		goto err_led;
+		return ret;
 	}
 
-	ret = device_create_file(drvdata->cdev.dev, &dev_attr_src);
-	if (ret != 0)
-		dev_err(&pdev->dev,
-			"No source control for LED: %d\n", ret);
-
 	return 0;
-
-err_led:
-	led_classdev_unregister(&drvdata->cdev);
-err:
-	return ret;
 }
 
 static int wm831x_status_remove(struct platform_device *pdev)
 {
 	struct wm831x_status *drvdata = platform_get_drvdata(pdev);
 
-	device_remove_file(drvdata->cdev.dev, &dev_attr_src);
 	led_classdev_unregister(&drvdata->cdev);
 
 	return 0;
-- 
1.8.5.5

