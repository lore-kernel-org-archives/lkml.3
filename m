Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaLCQJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:09:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45495 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaLCQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:09:44 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-bd-547f35a92f1c
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH/RFC v9 19/19] leds: aat1290: add support for V4L2 Flash
 sub-device
Date: Wed, 03 Dec 2014 17:06:54 +0100
Message-id: <1417622814-10845-20-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9jQd2VpvUhBjue8VtsnLGe1eLozolM
	Fv1vFrJanHu1ktGi9+pzRouzTW/YLS7vmsNmsfXNOkaLng1bWS2WXr/IZHH31FE2iwnT17JY
	tO49wm6xe9dTVovDb9pZLc7sX8lm8WnLNyYHQY8189Ywelzu62Xy2DnrLrvHyuVf2DwOf13I
	4rFpVSebx7yTgR575v9g9ejbsorRY8Xq7+wenzfJBXBHcdmkpOZklqUW6dslcGXcmfSYqeCK
	fEXb+7dMDYx7pboYOTkkBEwktt07ygJhi0lcuLeeDcQWEpjOKHH3qEcXIxeQ3c4ksau/gREk
	wSZgKPHzxWumLkYODhGBaIlLx+pBapgFPjBJXPz/hR0kLiwQIrH0VSZIOYuAqsSat/9YQWxe
	AU+JT3daWUBKJAQUJOZMsgEJcwKFn/64D9YpJOAhcXCi/wRG3gWMDKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgoP9mfQOxlUNFocYBTgYlXh4LeLqQoRYE8uKK3MPMUpwMCuJ8D77BhTi
	TUmsrEotyo8vKs1JLT7EKM3BoiTOe+NmboiQQHpiSWp2ampBahFMlomDU6qBseZ4xgvT/S0T
	f/NI2Td1bJm2X+14zzNto1dlP/pmdlc8D0y53hVpH3R+3sfY/LuxLqeyV+UdO+D53unAr0VH
	4k/wncw3+Wgesp9R+r+rULtbx94K6ZuXOM+/j2u9XDSr+eIZyVSxCNX0SWfrVC5fsHWecum2
	hMnL75PMrL5H/FjZOP31l+M1k5RYijMSDbWYi4oTAbytsbtyAgAA
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
 drivers/leds/leds-aat1290.c |   61 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
index 15d969b..81a8f48 100644
--- a/drivers/leds/leds-aat1290.c
+++ b/drivers/leds/leds-aat1290.c
@@ -21,6 +21,7 @@
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
 #include <linux/of.h>
+#include <media/v4l2-flash.h>
 #include <linux/workqueue.h>
 
 #define AAT1290_MOVIE_MODE_CURRENT_ADDR	17
@@ -63,6 +64,7 @@ struct aat1290_led {
 	struct mutex lock;
 
 	struct led_classdev_flash ldev;
+	struct v4l2_flash *v4l2_flash;
 
 	int flen_gpio;
 	int en_set_gpio;
@@ -280,11 +282,51 @@ static void aat1290_init_flash_settings(struct aat1290_led *led,
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
+
+static const struct v4l2_flash_ops *get_v4l2_flash_ops(void)
+{
+	return &v4l2_flash_ops;
+}
+#else
+#define get_v4l2_flash_ops() (NULL)
+#endif
+
 static int aat1290_led_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -292,6 +334,9 @@ static int aat1290_led_probe(struct platform_device *pdev)
 	struct aat1290_led *led;
 	struct led_classdev *led_cdev;
 	struct led_classdev_flash *flash;
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	struct v4l2_flash_ctrl_config v4l2_flash_config;
+#endif
 	struct aat1290_led_settings settings;
 	int flen_gpio, enset_gpio, ret;
 
@@ -344,6 +389,9 @@ static int aat1290_led_probe(struct platform_device *pdev)
 
 	flash->timeout = settings.flash_timeout;
 
+	/* Init V4L2 Flash controls basing on initialized settings */
+	aat1290_init_v4l2_ctrl_config(&settings, &v4l2_flash_config);
+
 	/* Init led class */
 	led_cdev = &flash->led_cdev;
 	led_cdev->name = led->label;
@@ -361,8 +409,20 @@ static int aat1290_led_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_gpio_en_set;
 
+	/* Create V4L2 Flash subdev. */
+	led->v4l2_flash = v4l2_flash_init(flash,
+					  get_v4l2_flash_ops(),
+					  dev_node,
+					  &v4l2_flash_config);
+	if (IS_ERR(led->v4l2_flash)) {
+		ret = PTR_ERR(led->v4l2_flash);
+		goto error_v4l2_flash_init;
+	}
+
 	return 0;
 
+error_v4l2_flash_init:
+	led_classdev_flash_unregister(flash);
 error_gpio_en_set:
 	if (gpio_is_valid(enset_gpio))
 		gpio_free(enset_gpio);
@@ -378,6 +438,7 @@ static int aat1290_led_remove(struct platform_device *pdev)
 {
 	struct aat1290_led *led = platform_get_drvdata(pdev);
 
+	v4l2_flash_release(led->v4l2_flash);
 	led_classdev_flash_unregister(&led->ldev);
 	cancel_work_sync(&led->work_brightness_set);
 
-- 
1.7.9.5

