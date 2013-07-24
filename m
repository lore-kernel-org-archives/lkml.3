Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3GXWNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:13:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3GXWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 28/36] video: backlight: lcd: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:31 -0700
Message-Id: <1374703539-9705-29-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the video backlight lcd class
code to use the correct field.

Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Richard, feel free to take this through your tree, or ACK it and I can
take it through mine.

 drivers/video/backlight/lcd.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 41964a71..93cf15ef 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -89,7 +89,7 @@ static inline void lcd_unregister_fb(struct lcd_device *ld)
 }
 #endif /* CONFIG_FB */
 
-static ssize_t lcd_show_power(struct device *dev, struct device_attribute *attr,
+static ssize_t lcd_power_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	int rc;
@@ -105,7 +105,7 @@ static ssize_t lcd_show_power(struct device *dev, struct device_attribute *attr,
 	return rc;
 }
 
-static ssize_t lcd_store_power(struct device *dev,
+static ssize_t lcd_power_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	int rc;
@@ -128,8 +128,9 @@ static ssize_t lcd_store_power(struct device *dev,
 
 	return rc;
 }
+static DEVICE_ATTR_RW(lcd_power);
 
-static ssize_t lcd_show_contrast(struct device *dev,
+static ssize_t contrast_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	int rc = -ENXIO;
@@ -143,7 +144,7 @@ static ssize_t lcd_show_contrast(struct device *dev,
 	return rc;
 }
 
-static ssize_t lcd_store_contrast(struct device *dev,
+static ssize_t contrast_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	int rc;
@@ -166,14 +167,16 @@ static ssize_t lcd_store_contrast(struct device *dev,
 
 	return rc;
 }
+static DEVICE_ATTR_RW(contrast);
 
-static ssize_t lcd_show_max_contrast(struct device *dev,
+static ssize_t max_contrast_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct lcd_device *ld = to_lcd_device(dev);
 
 	return sprintf(buf, "%d\n", ld->props.max_contrast);
 }
+static DEVICE_ATTR_RO(max_contrast);
 
 static struct class *lcd_class;
 
@@ -183,12 +186,13 @@ static void lcd_device_release(struct device *dev)
 	kfree(ld);
 }
 
-static struct device_attribute lcd_device_attributes[] = {
-	__ATTR(lcd_power, 0644, lcd_show_power, lcd_store_power),
-	__ATTR(contrast, 0644, lcd_show_contrast, lcd_store_contrast),
-	__ATTR(max_contrast, 0444, lcd_show_max_contrast, NULL),
-	__ATTR_NULL,
+static struct attribute *lcd_device_attrs[] = {
+	&dev_attr_lcd_power.attr,
+	&dev_attr_contrast.attr,
+	&dev_attr_max_contrast.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(lcd_device);
 
 /**
  * lcd_device_register - register a new object of lcd_device class.
@@ -344,7 +348,7 @@ static int __init lcd_class_init(void)
 		return PTR_ERR(lcd_class);
 	}
 
-	lcd_class->dev_attrs = lcd_device_attributes;
+	lcd_class->dev_groups = lcd_device_groups;
 	return 0;
 }
 
-- 
1.8.3.rc0.20.gb99dd2e

