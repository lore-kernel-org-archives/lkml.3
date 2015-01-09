Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbbAIP0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:26:02 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:23490 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbbAIPZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:25:14 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-98-54aff2d82715
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH/RFC v10 19/19] leds: aat1290: add support for V4L2 Flash
 sub-device
Date: Fri, 09 Jan 2015 16:23:09 +0100
Message-id: <1420816989-1808-20-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t9jQd0bn9aHGDR81bLYOGM9q8XRnROZ
	LOYfOcdq0Xv1OaPF2aY37BaXd81hs9j6Zh2jRc+GrawWd08dZbPYvespq8XhN+2sFmf2r2Sz
	+LTlG5MDr8fOWXfZPQ5/XcjiMe9koMee+T9YPfq2rGL0WLH6O7vH501yAexRXDYpqTmZZalF
	+nYJXBkf//9kK1gjX7Fh2wbWBsY1Ul2MnBwSAiYS7b/nMkLYYhIX7q1n62Lk4hASmM4o0fXv
	MzuE084ksaL9KjtIFZuAocTPF6+Zuhg5OEQEoiUuHasHqWEWmM4kse5tMxtIjbBAqMSZnUvB
	bBYBVYl1D++xgNi8Ah4SL7fsBeuVEFCQmDPJBsTkBAq3/HYCMYUE3CXeXDWcwMi7gJFhFaNo
	akFyQXFSeq6RXnFibnFpXrpecn7uJkZweD6T3sG4qsHiEKMAB6MSD+8GufUhQqyJZcWVuYcY
	JTiYlUR4GzYDhXhTEiurUovy44tKc1KLDzFKc7AoifMq2beFCAmkJ5akZqemFqQWwWSZODil
	GhjdGZuDa+dW67FySLdY39BfPt/hAmuT553+HOsE6X/TlqXo9Hpvl31v8m1NwaeIorLtsqzW
	EsdzXLW77iTlCkcbbAh6cv0Yy8fQYytlpNUvTZ7dPVlwE6PH5dVfrtoYunurtz58nxu4cLJW
	W4nY92vuD65bGhUq/NIPqZpw/eoKxQmFjx2nvVdiKc5INNRiLipOBACmH9ocSwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for V4L2 Flash sub-device to the aat1290 LED Flash class
driver. The support allows for V4L2 Flash sub-device to take the control
of the LED Flash class device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/leds-aat1290.c |   62 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
index 0a3c9b4..0974868 100644
--- a/drivers/leds/leds-aat1290.c
+++ b/drivers/leds/leds-aat1290.c
@@ -20,6 +20,7 @@
 #include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <media/v4l2-flash.h>
 #include <linux/workqueue.h>
 
 #define AAT1290_MOVIE_MODE_CURRENT_ADDR	17
@@ -67,6 +68,7 @@ struct aat1290_led {
 	struct mutex lock;
 
 	struct led_classdev_flash fled_cdev;
+	struct v4l2_flash *v4l2_flash;
 
 	int flen_gpio;
 	int en_set_gpio;
@@ -280,11 +282,44 @@ static void aat1290_init_flash_settings(struct aat1290_led *led,
 	setting->val = setting->max;
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+static void aat1290_init_v4l2_ctrl_config(struct aat1290_led_settings *s,
+					struct v4l2_flash_ctrl_config *config)
+{
+	struct led_flash_setting *setting;
+	struct v4l2_ctrl_config *c;
+
+	c = &config->intensity;
+	setting = &s->torch_brightness;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+
+	c = &config->flash_timeout;
+	setting = &s->flash_timeout;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+
+	config->has_external_strobe = false;
+}
+#else
+#define aat1290_init_v4l2_ctrl_config(s, config)
+#endif
+
 static const struct led_flash_ops flash_ops = {
 	.strobe_set = aat1290_led_flash_strobe_set,
 	.timeout_set = aat1290_led_flash_timeout_set,
 };
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+static const struct v4l2_flash_ops v4l2_flash_ops = {
+	.external_strobe_set = NULL,
+};
+#endif
+
 static int aat1290_led_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -292,6 +327,9 @@ static int aat1290_led_probe(struct platform_device *pdev)
 	struct aat1290_led *led;
 	struct led_classdev *led_cdev;
 	struct led_classdev_flash *fled_cdev;
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	struct v4l2_flash_ctrl_config v4l2_flash_config;
+#endif
 	struct aat1290_led_settings settings;
 	int flen_gpio, enset_gpio, ret;
 
@@ -342,6 +380,9 @@ static int aat1290_led_probe(struct platform_device *pdev)
 
 	fled_cdev->timeout = settings.flash_timeout;
 
+	/* Init V4L2 Flash controls basing on initialized settings */
+	aat1290_init_v4l2_ctrl_config(&settings, &v4l2_flash_config);
+
 	/* Init led class */
 	led_cdev = &fled_cdev->led_cdev;
 	led_cdev->name = led->label;
@@ -361,13 +402,34 @@ static int aat1290_led_probe(struct platform_device *pdev)
 
 	mutex_init(&led->lock);
 
+	of_node_get(dev_node);
+	led_cdev->dev->of_node = dev_node;
+
+	/* Create V4L2 Flash subdev. */
+	led->v4l2_flash = v4l2_flash_init(fled_cdev,
+					  &v4l2_flash_ops,
+					  &v4l2_flash_config);
+	if (IS_ERR(led->v4l2_flash)) {
+		ret = PTR_ERR(led->v4l2_flash);
+		goto error_v4l2_flash_init;
+	}
+
 	return 0;
+
+error_v4l2_flash_init:
+	of_node_put(dev_node);
+	led_classdev_flash_unregister(fled_cdev);
+	mutex_destroy(&led->lock);
+
+	return ret;
 }
 
 static int aat1290_led_remove(struct platform_device *pdev)
 {
 	struct aat1290_led *led = platform_get_drvdata(pdev);
 
+	v4l2_flash_release(led->v4l2_flash);
+	of_node_put(led->fled_cdev.led_cdev.dev->of_node);
 	led_classdev_flash_unregister(&led->fled_cdev);
 	cancel_work_sync(&led->work_brightness_set);
 
-- 
1.7.9.5

