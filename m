Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbaCTOvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:51:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29144 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933697AbaCTOvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:51:35 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-ea-532b00752fa2
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC 1/8] leds: Add sysfs and kernel internal API for flash LEDs
Date: Thu, 20 Mar 2014 15:51:03 +0100
Message-id: <1395327070-20215-2-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jQd1SBu1gg/Vdaha31p1jtTi6cyKT
	xfwjQFbv1eeMFmeb3rBbXN41h81i65t1jBY9G7ayWuze9ZTV4vCbdlYHLo+ds+6ye+yZ/4PV
	o2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDI2TS4u2LKYsWLZlcssDYz7Whm7GDk5JARMJBY+
	OMgCYYtJXLi3nq2LkYtDSGA6o8TfLbdZIJxOJom1278wgVSxCRhK/HzxGswWESiXmDb1ERNI
	EbPAPkaJTdOOM4MkhAX8JZqv3GUFsVkEVCVOt14GW8cr4CHR/7wLyOYAWqcgMWeSDUiYU8BT
	YunSLmaQsBBQydmJERMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA61Z9I7GFc1
	WBxiFOBgVOLhXbFHM1iINbGsuDL3EKMEB7OSCK/dc61gId6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYyC9299vZm0ueOlxqt7ft+ErQ8dcVPP5WZvVrfs
	ChZ3vLAyfPKCxZd+LVERuvx6o75m4OmGNuYpy9+din3w/HRg0vTNXu19+kUvfz7d4ezsvoa/
	ylCuVOtVpddZW4M7h/ue1fbEsDAt1hBaXlOs3rXcyfaGtOLMy1Wnfudv0ZAKir5QtrO45owS
	S3FGoqEWc1FxIgATyEkIMQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LED devices support two operation modes - torch and
flash. This patch provides support for flash LED devices
in the LED subsystem by introducing new sysfs attributes
and kernel internal interface. The attributes being
introduced are: flash_mode, flash_timeout, max_flash_timeout,
flash_fault and hw_triggered.
The modifications aim to be compatible with V4L2 framework
requirements related to the flash devices management. The
design assumes that V4L2 driver can take of the LED class
device control and communicate with it through the kernel
internal interface. The LED sysfs interface is made
unavailable then.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c    |  216 +++++++++++++++++++++++++++++++++++++++++--
 drivers/leds/led-core.c     |  124 +++++++++++++++++++++++--
 drivers/leds/led-triggers.c |   17 +++-
 drivers/leds/leds.h         |    9 ++
 include/linux/leds.h        |  136 +++++++++++++++++++++++++++
 5 files changed, 486 insertions(+), 16 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f37d63c..0510532 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -4,6 +4,9 @@
  * Copyright (C) 2005 John Lenz <lenz@cs.wisc.edu>
  * Copyright (C) 2005-2007 Richard Purdie <rpurdie@openedhand.com>
  *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -13,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/timer.h>
@@ -45,28 +49,186 @@ static ssize_t brightness_store(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	unsigned long state;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto exit_unlock;
+	}
 
 	ret = kstrtoul(buf, 10, &state);
 	if (ret)
-		return ret;
+		goto exit_unlock;
 
 	if (state == LED_OFF)
 		led_trigger_remove(led_cdev);
-	__led_set_brightness(led_cdev, state);
+	led_set_brightness(led_cdev, state);
+	ret = size;
 
-	return size;
+exit_unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
 }
 static DEVICE_ATTR_RW(brightness);
 
-static ssize_t led_max_brightness_show(struct device *dev,
+static ssize_t max_brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%u\n", led_cdev->max_brightness);
 }
-static DEVICE_ATTR(max_brightness, 0444, led_max_brightness_show, NULL);
+static DEVICE_ATTR_RO(max_brightness);
+
+static ssize_t flash_mode_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long flash_mode;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto exit_unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &flash_mode);
+	if (ret)
+		goto exit_unlock;
+
+	if (flash_mode < 0 && flash_mode > 1)
+		return -EINVAL;
+
+	if (led_is_flash_mode(led_cdev) == flash_mode) {
+		ret = size;
+		goto exit_unlock;
+	}
+
+	led_trigger_remove(led_cdev);
+
+	led_set_flash_mode(led_cdev, flash_mode);
+	ret = size;
+
+exit_unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_mode_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", led_is_flash_mode(led_cdev));
+}
+static DEVICE_ATTR_RW(flash_mode);
+
+static ssize_t flash_timeout_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long flash_timeout;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto exit_unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &flash_timeout);
+	if (ret)
+		goto exit_unlock;
+
+	led_set_flash_timeout(led_cdev, flash_timeout);
+	ret = size;
+
+exit_unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_timeout_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	return sprintf(buf, "%lu\n", flash->timeout);
+}
+static DEVICE_ATTR_RW(flash_timeout);
+
+static ssize_t max_flash_timeout_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	return sprintf(buf, "%lu\n", flash->max_timeout);
+}
+static DEVICE_ATTR_RO(max_flash_timeout);
+
+static ssize_t flash_fault_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned int fault;
+	int ret;
+
+	ret = led_get_flash_fault(led_cdev, &fault);
+	if (ret < 0)
+		return -EINVAL;
+
+	return sprintf(buf, "%x\n", fault);
+}
+static DEVICE_ATTR_RO(flash_fault);
+
+static ssize_t hw_triggered_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long hw_triggered;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &hw_triggered);
+	if (ret)
+		goto unlock;
+
+	if (hw_triggered > 1) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = led_set_hw_triggered(led_cdev, hw_triggered);
+	if (ret < 0)
+		goto unlock;
+	ret = size;
+
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t hw_triggered_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", led_cdev->hw_triggered);
+}
+static DEVICE_ATTR_RW(hw_triggered);
 
 #ifdef CONFIG_LEDS_TRIGGERS
 static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
@@ -82,6 +244,11 @@ static const struct attribute_group led_trigger_group = {
 static struct attribute *led_class_attrs[] = {
 	&dev_attr_brightness.attr,
 	&dev_attr_max_brightness.attr,
+	&dev_attr_flash_mode.attr,
+	&dev_attr_flash_timeout.attr,
+	&dev_attr_max_flash_timeout.attr,
+	&dev_attr_flash_fault.attr,
+	&dev_attr_hw_triggered.attr,
 	NULL,
 };
 
@@ -204,20 +371,54 @@ static const struct dev_pm_ops leds_class_dev_pm_ops = {
 };
 
 /**
+ * led_classdev_init_flash - add support for flash led
+ * @led_cdev: the device to add flash led support to
+ *
+ * Returns: 0 on success, error code on failure.
+ */
+int led_classdev_init_flash(struct led_classdev *led_cdev)
+{
+	if (led_cdev->flash)
+		return -EINVAL;
+
+	led_cdev->flash = kzalloc(sizeof(struct led_flash), GFP_KERNEL);
+	if (!led_cdev->flash)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(led_classdev_init_flash);
+
+/**
  * led_classdev_register - register a new object of led_classdev class.
  * @parent: The device to register.
  * @led_cdev: the led_classdev structure for this device.
  */
 int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 {
+	struct led_flash_ops *ops;
+
+	if (led_cdev->flash) {
+		ops = &led_cdev->flash->ops;
+		if (!ops || !ops->strobe_set || !ops->mode_set ||
+			!ops->fault_get) {
+			dev_dbg(parent,
+				"Flash LED ops validation failed for the %s\n"
+				"LED device", led_cdev->name);
+			return -EINVAL;
+		}
+	}
+
 	led_cdev->dev = device_create(leds_class, parent, 0, led_cdev,
 				      "%s", led_cdev->name);
 	if (IS_ERR(led_cdev->dev))
 		return PTR_ERR(led_cdev->dev);
 
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	init_rwsem(&led_cdev->trigger_lock);
 #endif
+	mutex_init(&led_cdev->led_lock);
 	/* add to the list of leds */
 	down_write(&leds_list_lock);
 	list_add_tail(&led_cdev->node, &leds_list);
@@ -271,6 +472,8 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
 	down_write(&leds_list_lock);
 	list_del(&led_cdev->node);
 	up_write(&leds_list_lock);
+
+	kfree(led_cdev->flash);
 }
 EXPORT_SYMBOL_GPL(led_classdev_unregister);
 
@@ -293,5 +496,6 @@ subsys_initcall(leds_init);
 module_exit(leds_exit);
 
 MODULE_AUTHOR("John Lenz, Richard Purdie");
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LED Class Interface");
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 71b40d3..093703c 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -5,6 +5,9 @@
  *
  * Author: Richard Purdie <rpurdie@openedhand.com>
  *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -71,10 +74,27 @@ static void led_blink_setup(struct led_classdev *led_cdev,
 	led_set_software_blink(led_cdev, *delay_on, *delay_off);
 }
 
+static int led_flash_strobe_set(struct led_classdev *led_cdev,
+			enum led_brightness brightness,
+			unsigned long *timeout)
+{
+	if (!get_flash_op(led_cdev, strobe_set))
+		return -EINVAL;
+
+	if (brightness > led_cdev->max_brightness)
+		brightness = led_cdev->max_brightness;
+	call_flash_op(strobe_set, led_cdev, brightness, timeout);
+
+	return 0;
+}
+
 void led_blink_set(struct led_classdev *led_cdev,
 		   unsigned long *delay_on,
 		   unsigned long *delay_off)
 {
+	if (led_is_flash_mode(led_cdev))
+		return;
+
 	del_timer_sync(&led_cdev->blink_timer);
 
 	led_cdev->flags &= ~LED_BLINK_ONESHOT;
@@ -89,6 +109,9 @@ void led_blink_set_oneshot(struct led_classdev *led_cdev,
 			   unsigned long *delay_off,
 			   int invert)
 {
+	if (led_is_flash_mode(led_cdev))
+		return;
+
 	if ((led_cdev->flags & LED_BLINK_ONESHOT) &&
 	     timer_pending(&led_cdev->blink_timer))
 		return;
@@ -116,13 +139,100 @@ EXPORT_SYMBOL_GPL(led_stop_software_blink);
 void led_set_brightness(struct led_classdev *led_cdev,
 			enum led_brightness brightness)
 {
-	/* delay brightness setting if need to stop soft-blink timer */
-	if (led_cdev->blink_delay_on || led_cdev->blink_delay_off) {
-		led_cdev->delayed_set_value = brightness;
-		schedule_work(&led_cdev->set_brightness_work);
-		return;
+	struct led_flash *flash = led_cdev->flash;
+	int ret;
+
+	if (led_is_flash_mode(led_cdev)) {
+		if (brightness > 0) {
+			ret = led_flash_strobe_set(led_cdev,
+					brightness,
+					&flash->timeout);
+			if (ret < 0)
+				dev_err(led_cdev->dev,
+					"Failed to setup flash strobe (%d)",
+					ret);
+		} else {
+			__led_set_brightness(led_cdev, 0);
+		}
+	} else {
+		/* delay brightness setting if need to stop soft-blink timer */
+		if (led_cdev->blink_delay_on || led_cdev->blink_delay_off) {
+			led_cdev->delayed_set_value = brightness;
+			schedule_work(&led_cdev->set_brightness_work);
+			return;
+		}
+		__led_set_brightness(led_cdev, brightness);
 	}
-
-	__led_set_brightness(led_cdev, brightness);
 }
 EXPORT_SYMBOL(led_set_brightness);
+
+int led_set_flash_mode(struct led_classdev *led_cdev,
+			bool flash_mode)
+{
+	if (!get_flash_op(led_cdev, mode_set))
+		return -EINVAL;
+
+	call_flash_op(mode_set, led_cdev, flash_mode);
+
+	if (flash_mode)
+		led_cdev->flags |= LED_MODE_FLASH;
+	else
+		led_cdev->flags &= ~LED_MODE_FLASH;
+
+	led_set_brightness(led_cdev, 0);
+
+	return 0;
+}
+EXPORT_SYMBOL(led_set_flash_mode);
+
+/* Caller must ensure led_cdev->led_lock held */
+void led_sysfs_lock(struct led_classdev *led_cdev)
+{
+	led_cdev->flags |= LED_SYSFS_LOCK;
+}
+EXPORT_SYMBOL(led_sysfs_lock);
+
+/* Caller must ensure led_cdev->led_lock held */
+void led_sysfs_unlock(struct led_classdev *led_cdev)
+{
+	led_cdev->flags &= ~LED_SYSFS_LOCK;
+}
+EXPORT_SYMBOL(led_sysfs_unlock);
+
+void led_set_flash_timeout(struct led_classdev *led_cdev, unsigned long timeout)
+{
+	struct led_flash *flash = led_cdev->flash;
+
+	/*
+	 * Flash timeout is passed to a flash LED driver
+	 * through the strobe_set callback - here we only
+	 * cache the value.
+	 */
+	if (timeout > flash->max_timeout)
+		flash->timeout = flash->max_timeout;
+	else
+		flash->timeout = timeout;
+}
+EXPORT_SYMBOL(led_set_flash_timeout);
+
+int led_get_flash_fault(struct led_classdev *led_cdev, unsigned int *fault)
+{
+	if (!get_flash_op(led_cdev, fault_get))
+		return -EINVAL;
+
+	return call_flash_op(fault_get, led_cdev, fault);
+}
+EXPORT_SYMBOL(led_get_flash_fault);
+
+int led_set_hw_triggered(struct led_classdev *led_cdev, bool enable)
+{
+	if (led_cdev->has_hw_trig) {
+		__led_set_brightness(led_cdev, 0);
+		led_cdev->hw_triggered = enable;
+	} else if (enable) {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(led_set_hw_triggered);
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index df1a7c1..448e7c8 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -37,6 +37,15 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 	char trigger_name[TRIG_NAME_MAX];
 	struct led_trigger *trig;
 	size_t len;
+	int ret = count;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev) ||
+	    led_is_flash_mode(led_cdev)) {
+		ret = -EBUSY;
+		goto exit_unlock;
+	}
 
 	trigger_name[sizeof(trigger_name) - 1] = '\0';
 	strncpy(trigger_name, buf, sizeof(trigger_name) - 1);
@@ -47,7 +56,7 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 
 	if (!strcmp(trigger_name, "none")) {
 		led_trigger_remove(led_cdev);
-		return count;
+		goto exit_unlock;
 	}
 
 	down_read(&triggers_list_lock);
@@ -58,12 +67,14 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 			up_write(&led_cdev->trigger_lock);
 
 			up_read(&triggers_list_lock);
-			return count;
+			goto exit_unlock;
 		}
 	}
 	up_read(&triggers_list_lock);
 
-	return -EINVAL;
+exit_unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(led_trigger_store);
 
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index 4c50365..44cc384 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -17,6 +17,15 @@
 #include <linux/rwsem.h>
 #include <linux/leds.h>
 
+
+#define call_flash_op(op, args...)		\
+	((led_cdev)->flash->ops.op(args))
+
+#define get_flash_op(led_cdev, op)		\
+	((led_cdev)->flash ?			\
+		(led_cdev)->flash->ops.op :	\
+		0)
+
 static inline void __led_set_brightness(struct led_classdev *led_cdev,
 					enum led_brightness value)
 {
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 0287ab2..1bf0ab3 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -17,6 +17,14 @@
 #include <linux/rwsem.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <media/v4l2-device.h>
+
+#define LED_FAULT_OVER_VOLTAGE		(1 << 0)
+#define LED_FAULT_TIMEOUT		(1 << 1)
+#define LED_FAULT_OVER_TEMPERATURE	(1 << 2)
+#define LED_FAULT_SHORT_CIRCUIT		(1 << 3)
+#define LED_FAULT_OVER_CURRENT		(1 << 4)
 
 struct device;
 /*
@@ -29,6 +37,33 @@ enum led_brightness {
 	LED_FULL	= 255,
 };
 
+struct led_classdev;
+
+struct led_flash_ops {
+	/* Set torch/flash LED mode */
+	void	(*mode_set)(struct led_classdev *led_cdev,
+					bool flash_mode);
+	/* Setup flash strobe */
+	void	(*strobe_set)(struct led_classdev *led_cdev,
+					enum led_brightness brightness,
+					unsigned long *timeout);
+	/* Get the flash LED fault */
+	int	(*fault_get)(struct led_classdev *led_cdev,
+					unsigned int *fault);
+};
+
+struct led_flash {
+	/* flash led specific ops */
+	struct led_flash_ops	ops;
+	/*
+	 * maximum allowed flash timeout - it is read only and
+	 * should be initialized by the driver
+	 */
+	unsigned long		max_timeout;
+	/* current flash timeout */
+	unsigned long		timeout;
+};
+
 struct led_classdev {
 	const char		*name;
 	int			 brightness;
@@ -42,6 +77,8 @@ struct led_classdev {
 #define LED_BLINK_ONESHOT	(1 << 17)
 #define LED_BLINK_ONESHOT_STOP	(1 << 18)
 #define LED_BLINK_INVERT	(1 << 19)
+#define LED_MODE_FLASH		(1 << 20)
+#define LED_SYSFS_LOCK		(1 << 21)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
@@ -69,6 +106,19 @@ struct led_classdev {
 	unsigned long		 blink_delay_on, blink_delay_off;
 	struct timer_list	 blink_timer;
 	int			 blink_brightness;
+	struct led_flash	*flash;
+	/*
+	 * Determines whether a device supports triggering a flash led
+	 * with use of a dedicated hardware pin
+	 */
+	bool			has_hw_trig;
+	/* If true then hardware pin triggers flash strobe */
+	bool			hw_triggered;
+	/*
+	 * Ensures consistent LED sysfs access and protects
+	 * LED sysfs locking mechanism
+	 */
+	struct mutex		led_lock;
 
 	struct work_struct	set_brightness_work;
 	int			delayed_set_value;
@@ -90,6 +140,7 @@ extern int led_classdev_register(struct device *parent,
 extern void led_classdev_unregister(struct led_classdev *led_cdev);
 extern void led_classdev_suspend(struct led_classdev *led_cdev);
 extern void led_classdev_resume(struct led_classdev *led_cdev);
+extern int led_classdev_init_flash(struct led_classdev *led_cdev);
 
 /**
  * led_blink_set - set blinking with software fallback
@@ -138,6 +189,91 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
  */
 extern void led_set_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness);
+/**
+/**
+ * led_set_flash_mode - set LED flash mode
+ * @led_cdev: the LED to set
+ * @flash_mode: true - flash mode, false - torch mode
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Switch an LED's flash mode and set brightness to 0.
+ */
+extern int led_set_flash_mode(struct led_classdev *led_cdev,
+			      bool flash_mode);
+
+/**
+ * led_set_flash_timeout - set flash LED timeout
+ * @led_cdev: the LED to set
+ * @timeout: the flash timeout to be set
+ *
+ * Set the flash strobe duration.
+ */
+extern void led_set_flash_timeout(struct led_classdev *led_cdev,
+				  unsigned long timeout);
+
+/**
+ * led_get_flash_fault - get the flash LED fault
+ * @led_cdev: the LED to query
+ * @fault: bitmask containing flash faults
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Get the flash LED fault.
+ */
+extern int led_get_flash_fault(struct led_classdev *led_cdev,
+			       unsigned int *fault);
+
+/**
+ * led_set_hw_triggered - set the flash LED hw_triggered mode
+ * @led_cdev: the LED to set
+ * @enable: the state to set
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Enable/disable triggering the flash LED via hardware pin
+ */
+extern int led_set_hw_triggered(struct led_classdev *led_cdev, bool enable);
+
+/**
+ * led_sysfs_lock - lock LED sysfs interface
+ * @led_cdev: the LED to set
+ *
+ * Lock the LED's sysfs interface
+ */
+extern void led_sysfs_lock(struct led_classdev *led_cdev);
+
+/**
+ * led_sysfs_unlock - unlock LED sysfs interface
+ * @led_cdev: the LED to set
+ *
+ * Unlock the LED's sysfs interface
+ */
+extern void led_sysfs_unlock(struct led_classdev *led_cdev);
+
+/**
+ * led_is_flash_mode
+ * @led_cdev: the LED query
+ *
+ * Returns: true if a led device is in the flash mode, false if it is
+	    is in the torch mode
+ */
+static inline bool led_is_flash_mode(struct led_classdev *led_cdev)
+{
+	return !!(led_cdev->flags & LED_MODE_FLASH);
+}
+
+/**
+ * led_sysfs_is_locked
+ * @led_cdev: the LED query about
+ *
+ * Returns: true if the sysfs interface of the led is disabled,
+ *	    false otherwise
+ */
+static inline bool led_sysfs_is_locked(struct led_classdev *led_cdev)
+{
+	return !!(led_cdev->flags & LED_SYSFS_LOCK);
+}
 
 /*
  * LED Triggers
-- 
1.7.9.5

