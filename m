Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaLCQJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:09:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65468 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaLCQJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:09:09 -0500
X-AuditID: cbfee61a-f79c06d000004e71-d2-547f35a2bf5c
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH/RFC v9 18/19] leds: max77693: add support for V4L2 Flash
 sub-device
Date: Wed, 03 Dec 2014 17:06:53 +0100
Message-id: <1417622814-10845-19-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t9jQd1FpvUhBv0vLCw2zljPanF050Qm
	i/43C1ktzr1ayWjRe/U5o8XZpjfsFpd3zWGz2PpmHaNFz4atrBZLr19ksrh76iibxYTpa1ks
	WvceYbfYvespq8XhN+2sFmf2r2Sz+LTlG5ODoMeaeWsYPS739TJ57Jx1l91j5fIvbB6Hvy5k
	8di0qpPNY97JQI8983+wevRtWcXosWL1d3aPz5vkArijuGxSUnMyy1KL9O0SuDJmPbvHVPDT
	oeJgj0UD4xvTLkZODgkBE4lLnT/ZIWwxiQv31rN1MXJxCAlMZ5R4f/0JC4TTziTxcOZyJpAq
	NgFDiZ8vXgPZHBwiAtESl47Vg9QwC3xgkrj4/wvYJGGBUIm++a+ZQWwWAVWJvZvfgtm8Ap4S
	/x58YgPplRBQkJgzyQYkzAkUfvrjPjtIWEjAQ+LgRP8JjLwLGBlWMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYgSH+zOpHYwrGywOMQpwMCrx8FrE1YUIsSaWFVfmHmKU4GBWEuF99g0oxJuS
	WFmVWpQfX1Sak1p8iFGag0VJnPfGzdwQIYH0xJLU7NTUgtQimCwTB6dUA6Obh0rVbOXd7y+Y
	bBWwkjp3ks2peGOqw4K8pWp/F+Rueti6++hCp16NL4En/4sa/CmQW9r6LUDIsrMh94SQgpXz
	HeVkj5YFcycH3HuwzPNWZAH/ZP+/12bUBR/z3iaUxOwo9oEjIMUv/KDYveSpSfu32Zd8t1P9
	p9Z9uOqA6ZvVy+yt1+2RW6nEUpyRaKjFXFScCAAv0jCDcwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for V4L2 Flash sub-device to the max77693 LED Flash class
driver. The support allows for V4L2 Flash sub-device to take the control
of the LED Flash class device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/leds-max77693.c |  133 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 132 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
index 67a2f8f..e93edbd 100644
--- a/drivers/leds/leds-max77693.c
+++ b/drivers/leds/leds-max77693.c
@@ -21,6 +21,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <media/v4l2-flash.h>
 
 #define MODE_OFF		0
 #define MODE_FLASH1		(1 << 0)
@@ -49,6 +50,7 @@ enum {
 struct max77693_sub_led {
 	struct led_classdev_flash ldev;
 	struct work_struct work_brightness_set;
+	struct v4l2_flash *v4l2_flash;
 
 	unsigned int torch_brightness;
 	unsigned int flash_timeout;
@@ -602,6 +604,32 @@ unlock:									\
 	return ret;							\
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+#define MAX77693_LED_FLASH_EXTERNAL_STROBE_SET(ID)			\
+static int max77693_led##ID##_external_strobe_set(			\
+				struct v4l2_flash *v4l2_flash,		\
+				bool enable)				\
+{									\
+	struct max77693_led *led =					\
+			ldev##ID##_to_led(v4l2_flash->flash);		\
+	int ret;							\
+									\
+	mutex_lock(&led->lock);						\
+									\
+	if (enable)							\
+		ret = max77693_add_mode(led, MODE_FLASH_EXTERNAL##ID);	\
+	else								\
+		ret = max77693_clear_mode(led,				\
+					MODE_FLASH_EXTERNAL##ID);	\
+									\
+	mutex_unlock(&led->lock);					\
+									\
+	return ret;							\
+}
+#else
+#define MAX77693_LED_FLASH_EXTERNAL_STROBE_SET(ID)
+#endif
+
 #define MAX77693_LED_FLASH_FAULT_GET(ID)				\
 static int max77693_led##ID##_flash_fault_get(				\
 				struct led_classdev_flash *flash,	\
@@ -670,6 +698,7 @@ MAX77693_LED_TORCH_BRIGHTNESS_SET(1)
 MAX77693_LED_FLASH_BRIGHTNESS_SET(1)
 MAX77693_LED_FLASH_STROBE_SET(1)
 MAX77693_LED_FLASH_STROBE_GET(1)
+MAX77693_LED_FLASH_EXTERNAL_STROBE_SET(1)
 MAX77693_LED_FLASH_TIMEOUT_SET(1)
 MAX77693_LED_FLASH_FAULT_GET(1)
 
@@ -679,6 +708,7 @@ MAX77693_LED_TORCH_BRIGHTNESS_SET(2)
 MAX77693_LED_FLASH_BRIGHTNESS_SET(2)
 MAX77693_LED_FLASH_STROBE_SET(2)
 MAX77693_LED_FLASH_STROBE_GET(2)
+MAX77693_LED_FLASH_EXTERNAL_STROBE_SET(2)
 MAX77693_LED_FLASH_TIMEOUT_SET(2)
 MAX77693_LED_FLASH_FAULT_GET(2)
 
@@ -838,9 +868,35 @@ static const struct led_flash_ops flash_ops##ID = {				\
 	.fault_get		= max77693_led##ID##_flash_fault_get,		\
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+#define MAX77693_LED_V4L2_FLASH_OPS(ID)						\
+static const struct v4l2_flash_ops v4l2_flash##ID##_ops = {			\
+	.external_strobe_set = max77693_led##ID##_external_strobe_set,		\
+}
+
+#define MAX77693_LED_GET_V4L2_FLASH_OPS(ID)					\
+static inline const struct v4l2_flash_ops *get_v4l2_flash##ID##_ops(void)	\
+{										\
+	return &v4l2_flash##ID##_ops;						\
+}
+#else
+#define MAX77693_LED_V4L2_FLASH_OPS(ID)
+
+#define MAX77693_LED_GET_V4L2_FLASH_OPS(ID)					\
+static inline const struct v4l2_flash_ops *get_v4l2_flash##ID##_ops(void)	\
+{										\
+	return NULL;								\
+}
+#endif
+
 MAX77693_LED_INIT_FLASH_OPS(1);
 MAX77693_LED_INIT_FLASH_OPS(2);
 
+MAX77693_LED_V4L2_FLASH_OPS(1);
+MAX77693_LED_V4L2_FLASH_OPS(2);
+MAX77693_LED_GET_V4L2_FLASH_OPS(1);
+MAX77693_LED_GET_V4L2_FLASH_OPS(2);
+
 static void max77693_init_flash_settings(struct max77693_led *led,
 					 struct max77693_led_settings *s,
 					 int led_id)
@@ -876,18 +932,68 @@ static void max77693_init_flash_settings(struct max77693_led *led,
 	setting->val = setting->max;
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+static void max77693_init_v4l2_ctrl_config(struct max77693_led_settings *s,
+					struct max77693_led_platform_data *p,
+					struct v4l2_flash_ctrl_config *config,
+					int led_id)
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
+	c = &config->flash_intensity;
+	setting = &s->flash_brightness;
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
+	/* Init flash faults config */
+	config->flash_faults =	V4L2_FLASH_FAULT_OVER_VOLTAGE |
+				V4L2_FLASH_FAULT_SHORT_CIRCUIT |
+				V4L2_FLASH_FAULT_OVER_CURRENT;
+
+	config->has_external_strobe =
+			!!(p->trigger[led_id] & MAX77693_LED_TRIG_FLASH);
+}
+#else
+#define max77693_init_v4l2_ctrl_config(s, p, config, led_id)
+#endif
+
 static int max77693_register_led(struct max77693_led *led, int id)
 {
 	struct platform_device *pdev = led->pdev;
 	struct led_classdev_flash *flash;
 	struct led_classdev *led_cdev;
 	struct max77693_sub_led *sub_leds = led->sub_leds;
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	struct v4l2_flash_ctrl_config v4l2_flash_config;
+#endif
+	const struct v4l2_flash_ops *v4l2_flash_ops = NULL;
 	struct max77693_led_settings settings;
+	int ret;
 
 	flash = &sub_leds[id].ldev;
 
 	/* Initialize flash settings */
 	max77693_init_flash_settings(led, &settings, id);
+	/* Initialize V4L2 Flash config basing on initialized settings */
+	max77693_init_v4l2_ctrl_config(&settings, led->pdata,
+					&v4l2_flash_config, id);
 
 	/* Initialize LED Flash class device */
 	led_cdev = &flash->led_cdev;
@@ -901,6 +1007,7 @@ static int max77693_register_led(struct max77693_led *led, int id)
 		INIT_WORK(&sub_leds[id].work_brightness_set,
 				max77693_led1_brightness_set_work);
 		flash->ops = &flash_ops1;
+		v4l2_flash_ops = get_v4l2_flash1_ops();
 	} else {
 		led_cdev->brightness_set = max77693_led2_brightness_set;
 		led_cdev->brightness_set_sync =
@@ -908,6 +1015,7 @@ static int max77693_register_led(struct max77693_led *led, int id)
 		INIT_WORK(&sub_leds[id].work_brightness_set,
 				max77693_led2_brightness_set_work);
 		flash->ops = &flash_ops2;
+		v4l2_flash_ops = get_v4l2_flash2_ops();
 	}
 
 	led_cdev->max_brightness = settings.torch_brightness.val /
@@ -921,7 +1029,27 @@ static int max77693_register_led(struct max77693_led *led, int id)
 	sub_leds[id].flash_timeout = flash->timeout.val;
 
 	/* Register in the LED subsystem. */
-	return led_classdev_flash_register(&pdev->dev, flash);
+	ret = led_classdev_flash_register(&pdev->dev, flash);
+	if (ret < 0)
+		return ret;
+
+	sub_leds[id].v4l2_flash =
+		v4l2_flash_init(flash,
+				v4l2_flash_ops,
+				led->pdata->sub_nodes[id],
+				&v4l2_flash_config);
+
+	if (IS_ERR(sub_leds[id].v4l2_flash)) {
+		ret = PTR_ERR(sub_leds[id].v4l2_flash);
+		goto err_v4l2_flash_init;
+	}
+
+	return 0;
+
+err_v4l2_flash_init:
+	led_classdev_flash_unregister(flash);
+
+	return ret;
 }
 
 static int max77693_led_probe(struct platform_device *pdev)
@@ -972,6 +1100,7 @@ static int max77693_led_probe(struct platform_device *pdev)
 err_register_led2:
 	if (!p->fleds[FLED1])
 		goto err_setup;
+	v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
 	led_classdev_flash_unregister(&sub_leds[FLED1].ldev);
 err_setup:
 	mutex_destroy(&led->lock);
@@ -986,11 +1115,13 @@ static int max77693_led_remove(struct platform_device *pdev)
 	struct max77693_sub_led *sub_leds = led->sub_leds;
 
 	if (led->iout_joint || p->fleds[FLED1]) {
+		v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
 		led_classdev_flash_unregister(&sub_leds[FLED1].ldev);
 		cancel_work_sync(&sub_leds[FLED1].work_brightness_set);
 	}
 
 	if (!led->iout_joint && p->fleds[FLED2]) {
+		v4l2_flash_release(sub_leds[FLED2].v4l2_flash);
 		led_classdev_flash_unregister(&sub_leds[FLED2].ldev);
 		cancel_work_sync(&sub_leds[FLED2].work_brightness_set);
 	}
-- 
1.7.9.5

