Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbbAIPXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:23:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54998 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813AbbAIPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:23:29 -0500
X-AuditID: cbfee61a-f79c06d000004e71-82-54aff26fbe41
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v10 01/19] leds: Add LED Flash class extension to the LED
 subsystem
Date: Fri, 09 Jan 2015 16:22:51 +0100
Message-id: <1420816989-1808-2-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jQd38T+tDDLY2SVlsnLGe1eLozolM
	FvOPnGO16L36nNHibNMbdovLu+awWWx9s47RomfDVlaLu6eOslns3vWU1eLwm3ZWizP7V7I5
	8HjsnHWX3ePw14UsHnvm/2D16NuyitFjxerv7B6fN8kFsEVx2aSk5mSWpRbp2yVwZayfs529
	YPcuxoppO26yNTBOmMXYxcjJISFgInHm/0smCFtM4sK99WxdjFwcQgLTGSV+7jvADOG0M0lc
	P9TCAlLFJmAo8fPFa6AODg4RgWiJS8fqQWqYBV4wStyb/IANpEZYIFKi6/lOdhCbRUBV4tyK
	1awgNq+Au8TdRdcZQXolBBQk5kyyATE5BTwkWn47gZhCQBVvrhpOYORdwMiwilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4IJ9J7WBc2WBxiFGAg1GJh3eD3PoQIdbEsuLK3EOMEhzMSiK8
	DZuBQrwpiZVVqUX58UWlOanFhxilOViUxHmV7NtChATSE0tSs1NTC1KLYLJMHJxSDYynL8w3
	V/bx+P8sx9D2V+prjk2Wz/dwTbnDEP7Z3m7JnIT+6b/ZZD0zTG2vKx3Q4M8PdHTkzcl2EM34
	kfBkUZrLTSP5b7q9teGak6/WJRmtF72kaH3Wptd7UrpoaI9S7dE/tUIp73LtKn4ZF626l7qZ
	+fypLw6Cyw9MzOx5vvaz5sFvB+/uFVViKc5INNRiLipOBADPB7aYRAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LED devices support two operation modes - torch and flash.
This patch provides support for flash LED devices in the LED subsystem
by introducing new sysfs attributes and kernel internal interface.
The attributes being introduced are: flash_brightness, flash_strobe,
flash_timeout, max_flash_timeout, max_flash_brightness, flash_fault,
flash_sync_strobe and available_sync_leds. All the flash related
features are placed in a separate module.

The modifications aim to be compatible with V4L2 framework requirements
related to the flash devices management. The design assumes that V4L2
sub-device can take of the LED class device control and communicate
with it through the kernel internal interface. When V4L2 Flash sub-device
file is opened, the LED class device sysfs interface is made
unavailable.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig            |   10 +
 drivers/leds/Makefile           |    1 +
 drivers/leds/led-class-flash.c  |  486 +++++++++++++++++++++++++++++++++++++++
 drivers/leds/led-class.c        |    4 +
 include/linux/led-class-flash.h |  207 +++++++++++++++++
 include/linux/leds.h            |    3 +
 6 files changed, 711 insertions(+)
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 include/linux/led-class-flash.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 59f4228..95029df 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -19,6 +19,16 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
+config LEDS_CLASS_FLASH
+	tristate "LED Flash Class Support"
+	depends on LEDS_CLASS
+	help
+	  This option enables the flash led sysfs class in /sys/class/leds.
+	  It wrapps LED Class and adds flash LEDs specific sysfs attributes
+	  and kernel internal API to it. You'll need this to provide support
+	  for the flash related features of a LED device. It can be built
+	  as a module.
+
 comment "LED drivers"
 
 config LEDS_88PM860X
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 1c65a19..cbba921 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -2,6 +2,7 @@
 # LED Core
 obj-$(CONFIG_NEW_LEDS)			+= led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
+obj-$(CONFIG_LEDS_CLASS_FLASH)		+= led-class-flash.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
new file mode 100644
index 0000000..4a19fd4
--- /dev/null
+++ b/drivers/leds/led-class-flash.c
@@ -0,0 +1,486 @@
+/*
+ * LED Flash class interface
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/led-class-flash.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "leds.h"
+
+#define has_flash_op(fled_cdev, op)				\
+	(fled_cdev && fled_cdev->ops->op)
+
+#define call_flash_op(fled_cdev, op, args...)		\
+	((has_flash_op(fled_cdev, op)) ?			\
+			(fled_cdev->ops->op(fled_cdev, args)) :	\
+			-EINVAL)
+
+static const char * const led_flash_fault_names[] = {
+	"led-over-voltage",
+	"flash-timeout-exceeded",
+	"controller-over-temperature",
+	"controller-short-circuit",
+	"led-power-supply-over-current",
+	"indicator-led-fault",
+	"led-under-voltage",
+	"controller-under-voltage",
+	"led-over-temperature",
+};
+
+static ssize_t flash_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	unsigned long state;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_access);
+
+	if (led_sysfs_is_disabled(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	ret = led_set_flash_brightness(fled_cdev, state);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_access);
+	return ret;
+}
+
+static ssize_t flash_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+
+	/* no lock needed for this */
+	led_update_flash_brightness(fled_cdev);
+
+	return sprintf(buf, "%u\n", fled_cdev->brightness.val);
+}
+static DEVICE_ATTR_RW(flash_brightness);
+
+static ssize_t max_flash_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+
+	return sprintf(buf, "%u\n", fled_cdev->brightness.max);
+}
+static DEVICE_ATTR_RO(max_flash_brightness);
+
+static ssize_t flash_strobe_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	mutex_lock(&led_cdev->led_access);
+
+	if (led_sysfs_is_disabled(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	if (state < 0 || state > 1) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = led_set_flash_strobe(fled_cdev, state);
+	if (ret < 0)
+		goto unlock;
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_access);
+	return ret;
+}
+
+static ssize_t flash_strobe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	bool state;
+	int ret;
+
+	/* no lock needed for this */
+	ret = led_get_flash_strobe(fled_cdev, &state);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", state);
+}
+static DEVICE_ATTR_RW(flash_strobe);
+
+static ssize_t flash_timeout_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	unsigned long flash_timeout;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_access);
+
+	if (led_sysfs_is_disabled(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &flash_timeout);
+	if (ret)
+		goto unlock;
+
+	ret = led_set_flash_timeout(fled_cdev, flash_timeout);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_access);
+	return ret;
+}
+
+static ssize_t flash_timeout_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+
+	return sprintf(buf, "%u\n", fled_cdev->timeout.val);
+}
+static DEVICE_ATTR_RW(flash_timeout);
+
+static ssize_t max_flash_timeout_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+
+	return sprintf(buf, "%u\n", fled_cdev->timeout.max);
+}
+static DEVICE_ATTR_RO(max_flash_timeout);
+
+static ssize_t flash_fault_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	u32 fault, mask = 0x1;
+	char *pbuf = buf;
+	int i, ret, buf_len;
+
+	ret = led_get_flash_fault(fled_cdev, &fault);
+	if (ret < 0)
+		return -EINVAL;
+
+	*buf = '\0';
+
+	for (i = 0; i < LED_NUM_FLASH_FAULTS; ++i) {
+		if (fault & mask) {
+			buf_len = sprintf(pbuf, "%s ",
+					  led_flash_fault_names[i]);
+			pbuf += buf_len;
+		}
+		mask <<= 1;
+	}
+
+	return sprintf(buf, "%s\n", buf);
+}
+static DEVICE_ATTR_RO(flash_fault);
+
+static ssize_t available_sync_leds_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	char *pbuf = buf;
+	int i, buf_len;
+
+	buf_len = sprintf(pbuf, "[0: none] ");
+	pbuf += buf_len;
+
+	for (i = 0; i < fled_cdev->num_sync_leds; ++i) {
+		buf_len = sprintf(pbuf, "[%d: %s] ", i + 1,
+				  fled_cdev->sync_leds[i]->led_cdev.name);
+		pbuf += buf_len;
+	}
+
+	return sprintf(buf, "%s\n", buf);
+}
+static DEVICE_ATTR_RO(available_sync_leds);
+
+static ssize_t flash_sync_strobe_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	unsigned long led_id;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_access);
+
+	if (led_sysfs_is_disabled(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &led_id);
+	if (ret)
+		goto unlock;
+
+	if (led_id > fled_cdev->num_sync_leds) {
+		ret = -ERANGE;
+		goto unlock;
+	}
+
+	fled_cdev->sync_led_id = led_id;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_access);
+	return ret;
+}
+
+static ssize_t flash_sync_strobe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	int sled_id = fled_cdev->sync_led_id;
+	char *sync_led_name = "none";
+
+	if (fled_cdev->sync_led_id > 0)
+		sync_led_name = (char *)
+			fled_cdev->sync_leds[sled_id - 1]->led_cdev.name;
+
+	return sprintf(buf, "[%d: %s]\n", sled_id, sync_led_name);
+}
+static DEVICE_ATTR_RW(flash_sync_strobe);
+
+static struct attribute *led_flash_strobe_attrs[] = {
+	&dev_attr_flash_strobe.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_timeout_attrs[] = {
+	&dev_attr_flash_timeout.attr,
+	&dev_attr_max_flash_timeout.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_brightness_attrs[] = {
+	&dev_attr_flash_brightness.attr,
+	&dev_attr_max_flash_brightness.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_fault_attrs[] = {
+	&dev_attr_flash_fault.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_sync_strobe_attrs[] = {
+	&dev_attr_available_sync_leds.attr,
+	&dev_attr_flash_sync_strobe.attr,
+	NULL,
+};
+
+static const struct attribute_group led_flash_strobe_group = {
+	.attrs = led_flash_strobe_attrs,
+};
+
+static const struct attribute_group led_flash_timeout_group = {
+	.attrs = led_flash_timeout_attrs,
+};
+
+static const struct attribute_group led_flash_brightness_group = {
+	.attrs = led_flash_brightness_attrs,
+};
+
+static const struct attribute_group led_flash_fault_group = {
+	.attrs = led_flash_fault_attrs,
+};
+
+static const struct attribute_group led_flash_sync_strobe_group = {
+	.attrs = led_flash_sync_strobe_attrs,
+};
+
+static void led_flash_resume(struct led_classdev *led_cdev)
+{
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+
+	call_flash_op(fled_cdev, flash_brightness_set,
+					fled_cdev->brightness.val);
+	call_flash_op(fled_cdev, timeout_set, fled_cdev->timeout.val);
+}
+
+static void led_flash_init_sysfs_groups(struct led_classdev_flash *fled_cdev)
+{
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	const struct led_flash_ops *ops = fled_cdev->ops;
+	const struct attribute_group **flash_groups = fled_cdev->sysfs_groups;
+
+	int num_sysfs_groups = 0;
+
+	flash_groups[num_sysfs_groups++] = &led_flash_strobe_group;
+
+	if (ops->flash_brightness_set)
+		flash_groups[num_sysfs_groups++] = &led_flash_brightness_group;
+
+	if (ops->timeout_set)
+		flash_groups[num_sysfs_groups++] = &led_flash_timeout_group;
+
+	if (ops->fault_get)
+		flash_groups[num_sysfs_groups++] = &led_flash_fault_group;
+
+	if (led_cdev->flags & LED_DEV_CAP_SYNC_STROBE)
+		flash_groups[num_sysfs_groups++] = &led_flash_sync_strobe_group;
+
+	led_cdev->groups = flash_groups;
+}
+
+int led_classdev_flash_register(struct device *parent,
+				struct led_classdev_flash *fled_cdev)
+{
+	struct led_classdev *led_cdev;
+	const struct led_flash_ops *ops;
+	int ret;
+
+	if (!fled_cdev)
+		return -EINVAL;
+
+	led_cdev = &fled_cdev->led_cdev;
+
+	if (led_cdev->flags & LED_DEV_CAP_FLASH) {
+		if (!led_cdev->brightness_set_sync)
+			return -EINVAL;
+
+		ops = fled_cdev->ops;
+		if (!ops || !ops->strobe_set)
+			return -EINVAL;
+
+		led_cdev->flash_resume = led_flash_resume;
+
+		/* Select the sysfs attributes to be created for the device */
+		led_flash_init_sysfs_groups(fled_cdev);
+	}
+
+	/* Register led class device */
+	ret = led_classdev_register(parent, led_cdev);
+	if (ret < 0)
+		return ret;
+
+	/* Setting a torch brightness needs to have immediate effect */
+	led_cdev->flags &= ~SET_BRIGHTNESS_ASYNC;
+	led_cdev->flags |= SET_BRIGHTNESS_SYNC;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(led_classdev_flash_register);
+
+void led_classdev_flash_unregister(struct led_classdev_flash *fled_cdev)
+{
+	if (!fled_cdev)
+		return;
+
+	led_classdev_unregister(&fled_cdev->led_cdev);
+}
+EXPORT_SYMBOL_GPL(led_classdev_flash_unregister);
+
+static void led_clamp_align(struct led_flash_setting *s)
+{
+	u32 v, offset;
+
+	v = s->val + s->step / 2;
+	v = clamp(v, s->min, s->max);
+	offset = v - s->min;
+	offset = s->step * (offset / s->step);
+	s->val = s->min + offset;
+}
+
+int led_set_flash_timeout(struct led_classdev_flash *fled_cdev, u32 timeout)
+{
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct led_flash_setting *s = &fled_cdev->timeout;
+
+	s->val = timeout;
+	led_clamp_align(s);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		return call_flash_op(fled_cdev, timeout_set, s->val);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(led_set_flash_timeout);
+
+int led_get_flash_fault(struct led_classdev_flash *fled_cdev, u32 *fault)
+{
+	return call_flash_op(fled_cdev, fault_get, fault);
+}
+EXPORT_SYMBOL_GPL(led_get_flash_fault);
+
+int led_set_flash_brightness(struct led_classdev_flash *fled_cdev,
+				u32 brightness)
+{
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct led_flash_setting *s = &fled_cdev->brightness;
+
+	s->val = brightness;
+	led_clamp_align(s);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		return call_flash_op(fled_cdev, flash_brightness_set, s->val);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(led_set_flash_brightness);
+
+int led_update_flash_brightness(struct led_classdev_flash *fled_cdev)
+{
+	struct led_flash_setting *s = &fled_cdev->brightness;
+	u32 brightness;
+
+	if (has_flash_op(fled_cdev, flash_brightness_get)) {
+		int ret = call_flash_op(fled_cdev, flash_brightness_get,
+						&brightness);
+		if (ret < 0)
+			return ret;
+
+		s->val = brightness;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(led_update_flash_brightness);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_DESCRIPTION("LED Flash class interface");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 291ca45..795ec99 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -179,6 +179,10 @@ EXPORT_SYMBOL_GPL(led_classdev_suspend);
 void led_classdev_resume(struct led_classdev *led_cdev)
 {
 	led_cdev->brightness_set(led_cdev, led_cdev->brightness);
+
+	if (led_cdev->flash_resume)
+		led_cdev->flash_resume(led_cdev);
+
 	led_cdev->flags &= ~LED_SUSPENDED;
 }
 EXPORT_SYMBOL_GPL(led_classdev_resume);
diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
new file mode 100644
index 0000000..5ba2fac
--- /dev/null
+++ b/include/linux/led-class-flash.h
@@ -0,0 +1,207 @@
+/*
+ * LED Flash class interface
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef __LINUX_FLASH_LEDS_H_INCLUDED
+#define __LINUX_FLASH_LEDS_H_INCLUDED
+
+#include <linux/leds.h>
+#include <uapi/linux/v4l2-controls.h>
+
+struct device_node;
+struct led_classdev_flash;
+
+/*
+ * Supported led fault bits - must be kept in synch
+ * with V4L2_FLASH_FAULT bits.
+ */
+#define LED_FAULT_OVER_VOLTAGE		(1 << 0)
+#define LED_FAULT_TIMEOUT		(1 << 1)
+#define LED_FAULT_OVER_TEMPERATURE	(1 << 2)
+#define LED_FAULT_SHORT_CIRCUIT		(1 << 3)
+#define LED_FAULT_OVER_CURRENT		(1 << 4)
+#define LED_FAULT_INDICATOR		(1 << 5)
+#define LED_FAULT_UNDER_VOLTAGE		(1 << 6)
+#define LED_FAULT_INPUT_VOLTAGE		(1 << 7)
+#define LED_FAULT_LED_OVER_TEMPERATURE	(1 << 8)
+#define LED_NUM_FLASH_FAULTS		9
+
+#define LED_FLASH_MAX_SYSFS_GROUPS 7
+
+struct led_flash_ops {
+	/* set flash brightness */
+	int (*flash_brightness_set)(struct led_classdev_flash *fled_cdev,
+					u32 brightness);
+	/* get flash brightness */
+	int (*flash_brightness_get)(struct led_classdev_flash *fled_cdev,
+					u32 *brightness);
+	/* set flash strobe state */
+	int (*strobe_set)(struct led_classdev_flash *fled_cdev, bool state);
+	/* get flash strobe state */
+	int (*strobe_get)(struct led_classdev_flash *fled_cdev, bool *state);
+	/* set flash timeout */
+	int (*timeout_set)(struct led_classdev_flash *fled_cdev, u32 timeout);
+	/* get the flash LED fault */
+	int (*fault_get)(struct led_classdev_flash *fled_cdev, u32 *fault);
+};
+
+/*
+ * Current value of a flash setting along
+ * with its constraints.
+ */
+struct led_flash_setting {
+	/* maximum allowed value */
+	u32 min;
+	/* maximum allowed value */
+	u32 max;
+	/* step value */
+	u32 step;
+	/* current value */
+	u32 val;
+};
+
+struct led_classdev_flash {
+	/* led class device */
+	struct led_classdev led_cdev;
+
+	/* flash led specific ops */
+	const struct led_flash_ops *ops;
+
+	/* flash brightness value in microamperes along with its constraints */
+	struct led_flash_setting brightness;
+
+	/* flash timeout value in microseconds along with its constraints */
+	struct led_flash_setting timeout;
+
+	/* LED Flash class sysfs groups */
+	const struct attribute_group *sysfs_groups[LED_FLASH_MAX_SYSFS_GROUPS];
+
+	/* LEDs available for flash strobe synchronization */
+	struct led_classdev_flash **sync_leds;
+
+	/* Number of LEDs available for flash strobe synchronization */
+	int num_sync_leds;
+
+	/*
+	 * The identifier of the sub-led to synchronize the flash strobe with.
+	 * Identifiers start from 1, which reflects the first element from the
+	 * sync_leds array. 0 means that the flash strobe should not be
+	 * synchronized.
+	 */
+	u32 sync_led_id;
+};
+
+static inline struct led_classdev_flash *lcdev_to_flcdev(
+						struct led_classdev *lcdev)
+{
+	return container_of(lcdev, struct led_classdev_flash, led_cdev);
+}
+
+/**
+ * led_classdev_flash_register - register a new object of led_classdev class
+ *				 with support for flash LEDs
+ * @parent: the flash LED to register
+ * @fled_cdev: the led_classdev_flash structure for this device
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_classdev_flash_register(struct device *parent,
+				struct led_classdev_flash *fled_cdev);
+
+/**
+ * led_classdev_flash_unregister - unregisters an object of led_classdev class
+ *				   with support for flash LEDs
+ * @fled_cdev: the flash LED to unregister
+ *
+ * Unregister a previously registered via led_classdev_flash_register object
+ */
+extern void led_classdev_flash_unregister(struct led_classdev_flash *fled_cdev);
+
+/**
+ * led_set_flash_strobe - setup flash strobe
+ * @fled_cdev: the flash LED to set strobe on
+ * @state: 1 - strobe flash, 0 - stop flash strobe
+ *
+ * Strobe the flash LED.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+static inline int led_set_flash_strobe(struct led_classdev_flash *fled_cdev,
+					bool state)
+{
+	return fled_cdev->ops->strobe_set(fled_cdev, state);
+}
+
+/**
+ * led_get_flash_strobe - get flash strobe status
+ * @fled_cdev: the flash LED to query
+ * @state: 1 - flash is strobing, 0 - flash is off
+ *
+ * Check whether the flash is strobing at the moment.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+static inline int led_get_flash_strobe(struct led_classdev_flash *fled_cdev,
+					bool *state)
+{
+	if (fled_cdev->ops->strobe_get)
+		return fled_cdev->ops->strobe_get(fled_cdev, state);
+
+	return -EINVAL;
+}
+
+/**
+ * led_set_flash_brightness - set flash LED brightness
+ * @fled_cdev: the flash LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Set a flash LED's brightness.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_flash_brightness(struct led_classdev_flash *fled_cdev,
+					u32 brightness);
+
+/**
+ * led_update_flash_brightness - update flash LED brightness
+ * @fled_cdev: the flash LED to query
+ *
+ * Get a flash LED's current brightness and update led_flash->brightness
+ * member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_flash_brightness(struct led_classdev_flash *fled_cdev);
+
+/**
+ * led_set_flash_timeout - set flash LED timeout
+ * @fled_cdev: the flash LED to set
+ * @timeout: the flash timeout to set it to
+ *
+ * Set the flash strobe duration.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_flash_timeout(struct led_classdev_flash *fled_cdev,
+					u32 timeout);
+
+/**
+ * led_get_flash_fault - get the flash LED fault
+ * @fled_cdev: the flash LED to query
+ * @fault: bitmask containing flash faults
+ *
+ * Get the flash LED fault.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_get_flash_fault(struct led_classdev_flash *fled_cdev,
+					u32 *fault);
+
+#endif	/* __LINUX_FLASH_LEDS_H_INCLUDED */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index cfceef3..f70f84f 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -46,6 +46,8 @@ struct led_classdev {
 #define LED_SYSFS_DISABLE	(1 << 20)
 #define SET_BRIGHTNESS_ASYNC	(1 << 21)
 #define SET_BRIGHTNESS_SYNC	(1 << 22)
+#define LED_DEV_CAP_FLASH	(1 << 23)
+#define LED_DEV_CAP_SYNC_STROBE	(1 << 24)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
@@ -81,6 +83,7 @@ struct led_classdev {
 	unsigned long		 blink_delay_on, blink_delay_off;
 	struct timer_list	 blink_timer;
 	int			 blink_brightness;
+	void			(*flash_resume)(struct led_classdev *led_cdev);
 
 	struct work_struct	set_brightness_work;
 	int			delayed_set_value;
-- 
1.7.9.5

