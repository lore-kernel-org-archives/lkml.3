Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3GXWJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:09:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3GXWGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 27/36] video: backlight: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:30 -0700
Message-Id: <1374703539-9705-28-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the video backlight class code to
use the correct field.

Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Richard, feel free to take this through your tree, or ACK it and I can
take it through mine.

 drivers/video/backlight/backlight.c | 44 ++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 3fccb6d3..94a403a9 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -103,16 +103,16 @@ static void backlight_generate_event(struct backlight_device *bd,
 	sysfs_notify(&bd->dev.kobj, NULL, "actual_brightness");
 }
 
-static ssize_t backlight_show_power(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t bl_power_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
 	return sprintf(buf, "%d\n", bd->props.power);
 }
 
-static ssize_t backlight_store_power(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+static ssize_t bl_power_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
 {
 	int rc;
 	struct backlight_device *bd = to_backlight_device(dev);
@@ -136,8 +136,9 @@ static ssize_t backlight_store_power(struct device *dev,
 
 	return rc;
 }
+static DEVICE_ATTR_RW(bl_power);
 
-static ssize_t backlight_show_brightness(struct device *dev,
+static ssize_t brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
@@ -145,7 +146,7 @@ static ssize_t backlight_show_brightness(struct device *dev,
 	return sprintf(buf, "%d\n", bd->props.brightness);
 }
 
-static ssize_t backlight_store_brightness(struct device *dev,
+static ssize_t brightness_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	int rc;
@@ -175,24 +176,27 @@ static ssize_t backlight_store_brightness(struct device *dev,
 
 	return rc;
 }
+static DEVICE_ATTR_RW(brightness);
 
-static ssize_t backlight_show_type(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t type_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
 	return sprintf(buf, "%s\n", backlight_types[bd->props.type]);
 }
+static DEVICE_ATTR_RO(type);
 
-static ssize_t backlight_show_max_brightness(struct device *dev,
+static ssize_t max_brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
 	return sprintf(buf, "%d\n", bd->props.max_brightness);
 }
+static DEVICE_ATTR_RO(max_brightness);
 
-static ssize_t backlight_show_actual_brightness(struct device *dev,
+static ssize_t actual_brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	int rc = -ENXIO;
@@ -205,6 +209,7 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
 
 	return rc;
 }
+static DEVICE_ATTR_RO(actual_brightness);
 
 static struct class *backlight_class;
 
@@ -247,16 +252,15 @@ static void bl_device_release(struct device *dev)
 	kfree(bd);
 }
 
-static struct device_attribute bl_device_attributes[] = {
-	__ATTR(bl_power, 0644, backlight_show_power, backlight_store_power),
-	__ATTR(brightness, 0644, backlight_show_brightness,
-		     backlight_store_brightness),
-	__ATTR(actual_brightness, 0444, backlight_show_actual_brightness,
-		     NULL),
-	__ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
-	__ATTR(type, 0444, backlight_show_type, NULL),
-	__ATTR_NULL,
+static struct attribute *bl_device_attrs[] = {
+	&dev_attr_bl_power.attr,
+	&dev_attr_brightness.attr,
+	&dev_attr_actual_brightness.attr,
+	&dev_attr_max_brightness.attr,
+	&dev_attr_type.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(bl_device);
 
 /**
  * backlight_force_update - tell the backlight subsystem that hardware state
@@ -493,7 +497,7 @@ static int __init backlight_class_init(void)
 		return PTR_ERR(backlight_class);
 	}
 
-	backlight_class->dev_attrs = bl_device_attributes;
+	backlight_class->dev_groups = bl_device_groups;
 	backlight_class->pm = &backlight_class_dev_pm_ops;
 	return 0;
 }
-- 
1.8.3.rc0.20.gb99dd2e

