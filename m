Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbbAIPaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:30:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24643 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843AbbAIPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:25:08 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-91-54aff2d2cf48
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH/RFC v10 18/19] leds: max77693: add support for V4L2 Flash
 sub-device
Date: Fri, 09 Jan 2015 16:23:08 +0100
Message-id: <1420816989-1808-19-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t9jQd1Ln9aHGLQe1rDYOGM9q8XRnROZ
	LOYfOcdq0Xv1OaPF2aY37BaXd81hs9j6Zh2jRc+GrawWd08dZbPYvespq8XhN+2sFmf2r2Sz
	+LTlG5MDr8fOWXfZPQ5/XcjiMe9koMee+T9YPfq2rGL0WLH6O7vH501yAexRXDYpqTmZZalF
	+nYJXBkz5vQzFfT5VxyZuIC1gfGeYxcjJ4eEgInEx6afLBC2mMSFe+vZuhi5OIQEpjNKbHzf
	xwzhtDNJbHr+hhGkik3AUOLni9dMXYwcHCIC0RKXjtWD1DALTGeSWPe2mQ2kRlggTGJW+26w
	ehYBVYnTl5exg9i8Ah4SC+7uZQbplRBQkJgzyQbE5AQKt/x2AjGFBNwl3lw1nMDIu4CRYRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcHg+k97BuKrB4hCjAAejEg/vBrn1IUKsiWXFlbmH
	GCU4mJVEeBs2A4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzKtm3hQgJpCeWpGanphakFsFkmTg4
	pRoYNf5EsAf9E6j2zmbfEPlP3zh1YeB/AQ3G4ysO7j30/NJ8wfXOrdxPdORTNrRk/TcOf8Kw
	LDSOn7lYWGfdrsQPPMbm9huSphxrz+tguKTsdILfvfNrooLTT/5NlsxsKxcL72Y+fU3Z4H9R
	XrhNfO6ee8o399nYs2to78rz4z9pH8q08ozniw4lluKMREMt5qLiRACo2pMuSwIAAA==
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
 drivers/leds/leds-max77693.c |  151 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 142 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
index 3ba07c4..ef35abb 100644
--- a/drivers/leds/leds-max77693.c
+++ b/drivers/leds/leds-max77693.c
@@ -21,6 +21,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <media/v4l2-flash.h>
 
 #define MODE_OFF		0
 #define MODE_FLASH(a)		(1 << (a))
@@ -52,6 +53,8 @@ struct max77693_sub_led {
 	struct led_classdev_flash fled_cdev;
 	/* assures led-triggers compatibility */
 	struct work_struct work_brightness_set;
+	/* V4L2 Flash device */
+	struct v4l2_flash *v4l2_flash;
 
 	/* brightness cache */
 	unsigned int torch_brightness;
@@ -624,6 +627,32 @@ unlock:
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+static int max77693_led_external_strobe_set(
+				struct v4l2_flash *v4l2_flash,
+				bool enable)
+{
+	struct max77693_sub_led *sub_led =
+				flcdev_to_sub_led(v4l2_flash->fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int fled_id = sub_led->fled_id;
+	int ret;
+
+	mutex_lock(&led->lock);
+
+	if (enable)
+		ret = max77693_add_mode(led, MODE_FLASH_EXTERNAL(fled_id));
+	else
+		ret = max77693_clear_mode(led, MODE_FLASH_EXTERNAL(fled_id));
+
+	mutex_unlock(&led->lock);
+
+	return ret;
+}
+#else
+#define max77693_led_external_strobe_set(v4l2_flash, enable) (NULL)
+#endif
+
 static int max77693_led_flash_fault_get(
 				struct led_classdev_flash *fled_cdev,
 				u32 *fault)
@@ -689,7 +718,8 @@ static int max77693_led_flash_timeout_set(
 }
 
 static int max77693_led_parse_dt(struct max77693_led_device *led,
-				 struct device_node *node)
+				 struct device_node *node,
+				 struct device_node **sub_nodes)
 {
 	struct max77693_led_config_data *cfg = led->cfg_data;
 	struct max77693_sub_led *sub_leds = led->sub_leds;
@@ -727,6 +757,13 @@ static int max77693_led_parse_dt(struct max77693_led_device *led,
 			return -EINVAL;
 		}
 
+		if (sub_nodes[fled_id]) {
+			dev_err(dev,
+				"Conflicting \"led-sources\" DT properties\n");
+			return -EINVAL;
+		}
+
+		sub_nodes[fled_id] = child_node;
 		sub_leds[fled_id].fled_id = fled_id;
 
 		ret = of_property_read_string(child_node, "label",
@@ -812,7 +849,8 @@ static void max77693_led_validate_configuration(struct max77693_led_device *led)
 				MAX_FLASH1_VSYS_MAX, MAX_FLASH1_VSYS_STEP);
 }
 
-static int max77693_led_get_configuration(struct max77693_led_device *led)
+static int max77693_led_get_configuration(struct max77693_led_device *led,
+					  struct device_node **sub_nodes)
 {
 	struct device *dev = &led->pdev->dev;
 	int ret;
@@ -824,7 +862,7 @@ static int max77693_led_get_configuration(struct max77693_led_device *led)
 	if (!led->cfg_data)
 		return -ENOMEM;
 
-	ret = max77693_led_parse_dt(led, dev->of_node);
+	ret = max77693_led_parse_dt(led, dev->of_node, sub_nodes);
 	if (ret < 0)
 		return ret;
 
@@ -841,6 +879,12 @@ static const struct led_flash_ops flash_ops = {
 	.fault_get		= max77693_led_flash_fault_get,
 };
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+static const struct v4l2_flash_ops v4l2_flash_ops = {
+	.external_strobe_set = max77693_led_external_strobe_set,
+};
+#endif
+
 static void max77693_init_flash_settings(struct max77693_led_device *led,
 					 struct max77693_led_settings *s,
 					 int fled_id)
@@ -875,6 +919,47 @@ static void max77693_init_flash_settings(struct max77693_led_device *led,
 	setting->val = setting->max;
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+static void max77693_init_v4l2_ctrl_config(struct max77693_led_settings *s,
+					struct max77693_led_config_data *p,
+					struct v4l2_flash_ctrl_config *config,
+					int fled_id)
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
+	config->has_external_strobe = true;
+}
+#else
+#define max77693_init_v4l2_ctrl_config(s, p, config, fled_id)
+#endif
+
 static int max77693_set_available_sync_led(struct max77693_led_device *led,
 						int fled_id)
 {
@@ -893,7 +978,8 @@ static int max77693_set_available_sync_led(struct max77693_led_device *led,
 }
 
 static void max77693_init_fled_cdev(struct max77693_led_device *led,
-					int fled_id)
+				int fled_id,
+				struct v4l2_flash_ctrl_config *v4l2_flash_cfg)
 {
 	struct led_classdev_flash *fled_cdev;
 	struct led_classdev *led_cdev;
@@ -902,6 +988,9 @@ static void max77693_init_fled_cdev(struct max77693_led_device *led,
 
 	/* Initialize flash settings */
 	max77693_init_flash_settings(led, &settings, fled_id);
+	/* Initialize V4L2 Flash config basing on initialized settings */
+	max77693_init_v4l2_ctrl_config(&settings, led->cfg_data,
+					v4l2_flash_cfg, fled_id);
 
 	/* Initialize LED Flash class device */
 	fled_cdev = &sub_led->fled_cdev;
@@ -924,14 +1013,51 @@ static void max77693_init_fled_cdev(struct max77693_led_device *led,
 	sub_led->flash_timeout = fled_cdev->timeout.val;
 }
 
+static int max77693_register_led(struct max77693_sub_led *sub_led,
+				 struct v4l2_flash_ctrl_config *v4l2_flash_cfg,
+				 struct device_node *sub_node)
+{
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	struct led_classdev_flash *fled_cdev = &sub_led->fled_cdev;
+	struct device *dev = &led->pdev->dev;
+	int ret;
+
+	/* Register in the LED subsystem */
+	ret = led_classdev_flash_register(dev, fled_cdev);
+	if (ret < 0)
+		return ret;
+
+	of_node_get(sub_node);
+	fled_cdev->led_cdev.dev->of_node = sub_node;
+
+	/* Register in the V4L2 subsystem. */
+	sub_led->v4l2_flash = v4l2_flash_init(fled_cdev, &v4l2_flash_ops,
+						v4l2_flash_cfg);
+	if (IS_ERR(sub_led->v4l2_flash)) {
+		ret = PTR_ERR(sub_led->v4l2_flash);
+		goto err_v4l2_flash_init;
+	}
+
+	return 0;
+
+err_v4l2_flash_init:
+	of_node_put(sub_node);
+	led_classdev_flash_unregister(fled_cdev);
+	return ret;
+}
+
 static int max77693_led_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
 	struct max77693_led_device *led;
 	struct max77693_sub_led *sub_leds;
+	struct device_node *sub_nodes[2] = { NULL, NULL };
+	struct v4l2_flash_ctrl_config v4l2_flash_config[2];
 	int init_fled_cdev[2], i, ret;
 
+	memset(v4l2_flash_config, 0, sizeof(v4l2_flash_config));
+
 	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
 	if (!led)
 		return -ENOMEM;
@@ -941,7 +1067,7 @@ static int max77693_led_probe(struct platform_device *pdev)
 	sub_leds = led->sub_leds;
 
 	platform_set_drvdata(pdev, led);
-	ret = max77693_led_get_configuration(led);
+	ret = max77693_led_get_configuration(led, sub_nodes);
 	if (ret < 0)
 		return ret;
 
@@ -957,7 +1083,7 @@ static int max77693_led_probe(struct platform_device *pdev)
 	/* Initialize LED Flash class device(s) */
 	for (i = FLED1; i <= FLED2; ++i)
 		if (init_fled_cdev[i])
-			max77693_init_fled_cdev(led, i);
+			max77693_init_fled_cdev(led, i, &v4l2_flash_config[i]);
 
 	/* Setup sub-leds available for flash strobe synchronization */
 	if (led->cfg_data->num_leds == 2) {
@@ -970,11 +1096,12 @@ static int max77693_led_probe(struct platform_device *pdev)
 
 	mutex_init(&led->lock);
 
-	/* Register LED Flash class device(s) */
+	/* Register LED Flash class and related V4L2 Flash device(s) */
 	for (i = FLED1; i <= FLED2; ++i) {
 		if (init_fled_cdev[i]) {
-			ret = led_classdev_flash_register(dev,
-							&sub_leds[i].fled_cdev);
+			ret = max77693_register_led(&sub_leds[i],
+						    &v4l2_flash_config[i],
+						    sub_nodes[i]);
 			if (ret < 0) {
 				/*
 				 * At this moment FLED1 might have been already
@@ -995,6 +1122,8 @@ err_register_led2:
 	/* It is possible than only FLED2 was to be registered */
 	if (!init_fled_cdev[FLED1])
 		goto err_register_led1;
+	v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
+	of_node_put(sub_leds[FLED1].fled_cdev.led_cdev.dev->of_node);
 	led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
 err_register_led1:
 	mutex_destroy(&led->lock);
@@ -1008,11 +1137,15 @@ static int max77693_led_remove(struct platform_device *pdev)
 	struct max77693_sub_led *sub_leds = led->sub_leds;
 
 	if (led->iout_joint || max77693_fled_used(led, FLED1)) {
+		v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
+		of_node_put(sub_leds[FLED1].fled_cdev.led_cdev.dev->of_node);
 		led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
 		cancel_work_sync(&sub_leds[FLED1].work_brightness_set);
 	}
 
 	if (!led->iout_joint && max77693_fled_used(led, FLED2)) {
+		v4l2_flash_release(sub_leds[FLED2].v4l2_flash);
+		of_node_put(sub_leds[FLED2].fled_cdev.led_cdev.dev->of_node);
 		led_classdev_flash_unregister(&sub_leds[FLED2].fled_cdev);
 		cancel_work_sync(&sub_leds[FLED2].work_brightness_set);
 	}
-- 
1.7.9.5

