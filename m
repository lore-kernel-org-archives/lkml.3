Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3GXWGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3GXWFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 10/36] leds: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:13 -0700
Message-Id: <1374703539-9705-11-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the led class code to use the
correct field.

Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Bryan and Richard, feel free to take this through your tree, or ACK it and I
can take it through mine.

 drivers/leds/led-class.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 4336e37a..f37d63cf 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -29,7 +29,7 @@ static void led_update_brightness(struct led_classdev *led_cdev)
 		led_cdev->brightness = led_cdev->brightness_get(led_cdev);
 }
 
-static ssize_t led_brightness_show(struct device *dev,
+static ssize_t brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
@@ -40,7 +40,7 @@ static ssize_t led_brightness_show(struct device *dev,
 	return sprintf(buf, "%u\n", led_cdev->brightness);
 }
 
-static ssize_t led_brightness_store(struct device *dev,
+static ssize_t brightness_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
@@ -57,6 +57,7 @@ static ssize_t led_brightness_store(struct device *dev,
 
 	return size;
 }
+static DEVICE_ATTR_RW(brightness);
 
 static ssize_t led_max_brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -65,14 +66,35 @@ static ssize_t led_max_brightness_show(struct device *dev,
 
 	return sprintf(buf, "%u\n", led_cdev->max_brightness);
 }
+static DEVICE_ATTR(max_brightness, 0444, led_max_brightness_show, NULL);
 
-static struct device_attribute led_class_attrs[] = {
-	__ATTR(brightness, 0644, led_brightness_show, led_brightness_store),
-	__ATTR(max_brightness, 0444, led_max_brightness_show, NULL),
 #ifdef CONFIG_LEDS_TRIGGERS
-	__ATTR(trigger, 0644, led_trigger_show, led_trigger_store),
+static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
+static struct attribute *led_trigger_attrs[] = {
+	&dev_attr_trigger.attr,
+	NULL,
+};
+static const struct attribute_group led_trigger_group = {
+	.attrs = led_trigger_attrs,
+};
+#endif
+
+static struct attribute *led_class_attrs[] = {
+	&dev_attr_brightness.attr,
+	&dev_attr_max_brightness.attr,
+	NULL,
+};
+
+static const struct attribute_group led_group = {
+	.attrs = led_class_attrs,
+};
+
+static const struct attribute_group *led_groups[] = {
+	&led_group,
+#ifdef CONFIG_LEDS_TRIGGERS
+	&led_trigger_group,
 #endif
-	__ATTR_NULL,
+	NULL,
 };
 
 static void led_timer_function(unsigned long data)
@@ -258,7 +280,7 @@ static int __init leds_init(void)
 	if (IS_ERR(leds_class))
 		return PTR_ERR(leds_class);
 	leds_class->pm = &leds_class_dev_pm_ops;
-	leds_class->dev_attrs = led_class_attrs;
+	leds_class->dev_groups = led_groups;
 	return 0;
 }
 
-- 
1.8.3.rc0.20.gb99dd2e

