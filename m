Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3GXWQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:16:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GXWF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 19/36] rtc: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:22 -0700
Message-Id: <1374703539-9705-20-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the rtc class code to use the
correct field.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Alessandro, feel free to take this through your tree, or ACK it and I
can take it through mine.

 drivers/rtc/rtc-sysfs.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index 4b26f867..babd43bf 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -25,15 +25,14 @@
  */
 
 static ssize_t
-rtc_sysfs_show_name(struct device *dev, struct device_attribute *attr,
-		char *buf)
+name_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%s\n", to_rtc_device(dev)->name);
 }
+static DEVICE_ATTR_RO(name);
 
 static ssize_t
-rtc_sysfs_show_date(struct device *dev, struct device_attribute *attr,
-		char *buf)
+date_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	ssize_t retval;
 	struct rtc_time tm;
@@ -46,10 +45,10 @@ rtc_sysfs_show_date(struct device *dev, struct device_attribute *attr,
 
 	return retval;
 }
+static DEVICE_ATTR_RO(date);
 
 static ssize_t
-rtc_sysfs_show_time(struct device *dev, struct device_attribute *attr,
-		char *buf)
+time_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	ssize_t retval;
 	struct rtc_time tm;
@@ -62,10 +61,10 @@ rtc_sysfs_show_time(struct device *dev, struct device_attribute *attr,
 
 	return retval;
 }
+static DEVICE_ATTR_RO(time);
 
 static ssize_t
-rtc_sysfs_show_since_epoch(struct device *dev, struct device_attribute *attr,
-		char *buf)
+since_epoch_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	ssize_t retval;
 	struct rtc_time tm;
@@ -79,16 +78,16 @@ rtc_sysfs_show_since_epoch(struct device *dev, struct device_attribute *attr,
 
 	return retval;
 }
+static DEVICE_ATTR_RO(since_epoch);
 
 static ssize_t
-rtc_sysfs_show_max_user_freq(struct device *dev, struct device_attribute *attr,
-		char *buf)
+max_user_freq_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%d\n", to_rtc_device(dev)->max_user_freq);
 }
 
 static ssize_t
-rtc_sysfs_set_max_user_freq(struct device *dev, struct device_attribute *attr,
+max_user_freq_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t n)
 {
 	struct rtc_device *rtc = to_rtc_device(dev);
@@ -101,6 +100,7 @@ rtc_sysfs_set_max_user_freq(struct device *dev, struct device_attribute *attr,
 
 	return n;
 }
+static DEVICE_ATTR_RW(max_user_freq);
 
 /**
  * rtc_sysfs_show_hctosys - indicate if the given RTC set the system time
@@ -109,8 +109,7 @@ rtc_sysfs_set_max_user_freq(struct device *dev, struct device_attribute *attr,
  * boot or resume event.
  */
 static ssize_t
-rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *attr,
-		char *buf)
+hctosys_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
 	if (rtc_hctosys_ret == 0 &&
@@ -121,17 +120,18 @@ rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *attr,
 #endif
 		return sprintf(buf, "0\n");
 }
-
-static struct device_attribute rtc_attrs[] = {
-	__ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL),
-	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
-	__ATTR(time, S_IRUGO, rtc_sysfs_show_time, NULL),
-	__ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL),
-	__ATTR(max_user_freq, S_IRUGO | S_IWUSR, rtc_sysfs_show_max_user_freq,
-			rtc_sysfs_set_max_user_freq),
-	__ATTR(hctosys, S_IRUGO, rtc_sysfs_show_hctosys, NULL),
-	{ },
+static DEVICE_ATTR_RO(hctosys);
+
+static struct attribute *rtc_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_date.attr,
+	&dev_attr_time.attr,
+	&dev_attr_since_epoch.attr,
+	&dev_attr_max_user_freq.attr,
+	&dev_attr_hctosys.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(rtc);
 
 static ssize_t
 rtc_sysfs_show_wakealarm(struct device *dev, struct device_attribute *attr,
@@ -261,5 +261,5 @@ void rtc_sysfs_del_device(struct rtc_device *rtc)
 
 void __init rtc_sysfs_init(struct class *rtc_class)
 {
-	rtc_class->dev_attrs = rtc_attrs;
+	rtc_class->dev_groups = rtc_groups;
 }
-- 
1.8.3.rc0.20.gb99dd2e

