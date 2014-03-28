Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaC1Pab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:30:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41323 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaC1Pa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:30:26 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-ab-53359554a892
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v2 1/8] leds: Add sysfs and kernel internal API for flash
 LEDs
Date: Fri, 28 Mar 2014 16:28:58 +0100
Message-id: <1396020545-15727-2-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
References: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t9jQd2QqabBBtOnaFvcWneO1eLozolM
	FvOPAFm9V58zWpxtesNucXnXHDaLrW/WMVr0bNjKarF711NWi8Nv2lkduDx2zrrL7rFn/g9W
	j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MpoX6JUMO0YY8XVzj6mBsbzixi7GDk5JARMJHYf
	msQCYYtJXLi3nq2LkYtDSGA6o8THCfMZIZxOJonLO7eAVbEJGEr8fPGaCcQWESiXmDb1ERNI
	EbPAPkaJTdOOM4MkhAVCJDpm7GcFsVkEVCV+b2lgA7F5BTwkvp1pBBrEAbROQWLOJBuQMKeA
	p8TtF+1gFwkBlXyZc5J9AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBwfZMegfj
	qgaLQ4wCHIxKPLwCrabBQqyJZcWVuYcYJTiYlUR4syYChXhTEiurUovy44tKc1KLDzFKc7Ao
	ifMebLUOFBJITyxJzU5NLUgtgskycXBKNTBuFd7+/VKrtY7nlwK780cVdGUFvbJm5x+baqOq
	m2KWZNZ1aNeRKq+Nrv0S3PYXt0z9sHZn/4JeB3H1qm/f0rgmO4hkrt7MIcC3fEnHKYMp1SFW
	0cpPDk00cLnFYH1O/x3nwR0KxoZCMxbnTH6uZGdvdOeDq9tpf/a1XwVaTkQYb5uzao/50S1K
	LMUZiYZazEXFiQD3/I1jMgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LED devices support two operation modes - torch and
flash. This patch provides support for flash LED devices
in the LED subsystem by introducing new sysfs attributes
and kernel internal interface. The attributes being
introduced are: flash_brightness, flash_strobe, flash_timeout,
max_flash_timeout, max_flash_brightness, flash_fault and
hw_triggered. All the flash related features are placed
in a separate module.
The modifications aim to be compatible with V4L2 framework
requirements related to the flash devices management. The
design assumes that V4L2 sub-device can take of the LED class
device control and communicate with it through the kernel
internal interface. The LED sysfs interface is made
unavailable then.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig        |    8 +
 drivers/leds/Makefile       |    1 +
 drivers/leds/led-class.c    |   56 +++++--
 drivers/leds/led-flash.c    |  375 +++++++++++++++++++++++++++++++++++++++++++
 drivers/leds/led-triggers.c |   16 +-
 drivers/leds/leds.h         |    3 +
 include/linux/leds.h        |   24 ++-
 include/linux/leds_flash.h  |  189 ++++++++++++++++++++++
 8 files changed, 658 insertions(+), 14 deletions(-)
 create mode 100644 drivers/leds/led-flash.c
 create mode 100644 include/linux/leds_flash.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 2062682..1e1c81f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -19,6 +19,14 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
+config LEDS_CLASS_FLASH
+	tristate "Flash LEDs Support"
+	depends on LEDS_CLASS
+	help
+	  This option enables support for flash LED devices. Say Y if you
+	  want to use flash specific features of a LED device, if they
+	  are supported.
+
 comment "LED drivers"
 
 config LEDS_88PM860X
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 3cd76db..8861b86 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -2,6 +2,7 @@
 # LED Core
 obj-$(CONFIG_NEW_LEDS)			+= led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
+obj-$(CONFIG_LEDS_CLASS_FLASH)		+= led-flash.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f37d63c..5bac140 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -9,16 +9,18 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/device.h>
 #include <linux/timer.h>
-#include <linux/err.h>
-#include <linux/ctype.h>
 #include <linux/leds.h>
+#include <linux/leds_flash.h>
 #include "leds.h"
 
 static struct class *leds_class;
@@ -45,28 +47,38 @@ static ssize_t brightness_store(struct device *dev,
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
+		goto unlock;
+	}
 
 	ret = kstrtoul(buf, 10, &state);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	if (state == LED_OFF)
 		led_trigger_remove(led_cdev);
 	__led_set_brightness(led_cdev, state);
+	ret = size;
 
-	return size;
+unlock:
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
 
 #ifdef CONFIG_LEDS_TRIGGERS
 static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
@@ -173,7 +185,15 @@ EXPORT_SYMBOL_GPL(led_classdev_suspend);
  */
 void led_classdev_resume(struct led_classdev *led_cdev)
 {
+	struct led_flash *flash = led_cdev->flash;
+
 	led_cdev->brightness_set(led_cdev, led_cdev->brightness);
+	if (flash) {
+		call_flash_op(brightness_set, led_cdev,
+				flash->brightness);
+		call_flash_op(timeout_set, led_cdev,
+				&flash->timeout);
+	}
 	led_cdev->flags &= ~LED_SUSPENDED;
 }
 EXPORT_SYMBOL_GPL(led_classdev_resume);
@@ -210,14 +230,24 @@ static const struct dev_pm_ops leds_class_dev_pm_ops = {
  */
 int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 {
+	int ret;
+
 	led_cdev->dev = device_create(leds_class, parent, 0, led_cdev,
 				      "%s", led_cdev->name);
 	if (IS_ERR(led_cdev->dev))
 		return PTR_ERR(led_cdev->dev);
 
+	ret = led_classdev_init_flash(led_cdev);
+	if (ret < 0) {
+		dev_dbg(parent,
+			"Flash LED initialization failed for the %s\n device", led_cdev->name);
+		goto error_flash_init;
+	}
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	init_rwsem(&led_cdev->trigger_lock);
 #endif
+	mutex_init(&led_cdev->led_lock);
 	/* add to the list of leds */
 	down_write(&leds_list_lock);
 	list_add_tail(&led_cdev->node, &leds_list);
@@ -242,6 +272,10 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 			led_cdev->name);
 
 	return 0;
+
+error_flash_init:
+	device_destroy(leds_class, 0);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(led_classdev_register);
 
@@ -271,6 +305,8 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
 	down_write(&leds_list_lock);
 	list_del(&led_cdev->node);
 	up_write(&leds_list_lock);
+
+	mutex_destroy(&led_cdev->led_lock);
 }
 EXPORT_SYMBOL_GPL(led_classdev_unregister);
 
diff --git a/drivers/leds/led-flash.c b/drivers/leds/led-flash.c
new file mode 100644
index 0000000..72db06a
--- /dev/null
+++ b/drivers/leds/led-flash.c
@@ -0,0 +1,375 @@
+/*
+ * LED Class Flash interface
+ *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/leds_flash.h>
+#include "leds.h"
+
+static ssize_t flash_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	led_set_flash_brightness(led_cdev, state);
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	/* no lock needed for this */
+	led_update_flash_brightness(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->brightness);
+}
+static DEVICE_ATTR_RW(flash_brightness);
+
+static ssize_t max_flash_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	return sprintf(buf, "%u\n", flash->max_brightness);
+}
+static DEVICE_ATTR_RO(max_flash_brightness);
+
+static ssize_t flash_strobe_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	if (state < 0 || state > 1)
+		return -EINVAL;
+
+	ret = led_set_flash_strobe(led_cdev, state);
+	if (ret < 0)
+		goto unlock;
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_strobe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	int ret;
+
+	/* no lock needed for this */
+	ret = led_get_flash_strobe(led_cdev);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", ret);
+}
+static DEVICE_ATTR_RW(flash_strobe);
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
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &flash_timeout);
+	if (ret)
+		goto unlock;
+
+	ret = led_set_flash_timeout(led_cdev, &flash_timeout);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
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
+	return sprintf(buf, "0x%8.8x\n", fault);
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
+	return sprintf(buf, "%u\n", led_cdev->flash->hw_triggered);
+}
+static DEVICE_ATTR_RW(hw_triggered);
+
+static struct attribute *flash_led_attrs[] = {
+	&dev_attr_flash_brightness.attr,
+	&dev_attr_flash_strobe.attr,
+	&dev_attr_flash_timeout.attr,
+	&dev_attr_max_flash_timeout.attr,
+	&dev_attr_max_flash_brightness.attr,
+	&dev_attr_flash_fault.attr,
+	&dev_attr_hw_triggered.attr,
+	NULL,
+};
+
+static const struct attribute_group flash_led_group = {
+	.attrs = flash_led_attrs,
+};
+
+int led_classdev_init_flash(struct led_classdev *led_cdev)
+{
+	struct led_flash *flash = led_cdev->flash;
+	const struct led_flash_ops *ops;
+	int ret;
+
+	if (!flash)
+		return 0;
+
+	ops = &flash->ops;
+	if (!ops || !ops->brightness_set || !ops->brightness_get ||
+	    !ops->strobe_set || !ops->strobe_get || !ops->timeout_set ||
+	    !ops->hw_trig_set || !ops->fault_get)
+		return -EINVAL;
+
+	/* Create flash specific sysfs attributes */
+	ret = sysfs_create_group(&led_cdev->dev->kobj, &flash_led_group);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_classdev_init_flash);
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
+int led_set_flash_strobe(struct led_classdev *led_cdev, bool state)
+{
+	struct led_flash *flash = led_cdev->flash;
+
+	if (!flash)
+		return -EINVAL;
+
+	return call_flash_op(strobe_set, led_cdev, state);
+}
+EXPORT_SYMBOL(led_set_flash_strobe);
+
+int led_get_flash_strobe(struct led_classdev *led_cdev)
+{
+	struct led_flash *flash = led_cdev->flash;
+
+	if (!flash)
+		return -EINVAL;
+
+	return call_flash_op(strobe_get, led_cdev);
+}
+EXPORT_SYMBOL(led_get_flash_strobe);
+
+int led_set_flash_timeout(struct led_classdev *led_cdev, unsigned long *timeout)
+{
+	struct led_flash *flash = led_cdev->flash;
+	int ret = 0;
+
+	if (!flash)
+		return -EINVAL;
+
+	flash->timeout = min(*timeout, flash->max_timeout);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(timeout_set, led_cdev, &flash->timeout);
+
+	return ret;
+}
+EXPORT_SYMBOL(led_set_flash_timeout);
+
+int led_get_flash_fault(struct led_classdev *led_cdev, unsigned int *fault)
+{
+	if (!led_cdev->flash)
+		return -EINVAL;
+
+	return call_flash_op(fault_get, led_cdev, fault);
+}
+EXPORT_SYMBOL(led_get_flash_fault);
+
+int led_set_hw_triggered(struct led_classdev *led_cdev, bool enable)
+{
+	struct led_flash *flash = led_cdev->flash;
+	int ret;
+
+	if (!flash)
+		return -EINVAL;
+
+	if (flash->has_hw_trig) {
+		ret = call_flash_op(hw_trig_set, led_cdev, enable);
+		if (ret < 0)
+			return -EINVAL;
+		flash->hw_triggered = enable;
+	} else if (enable)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(led_set_hw_triggered);
+
+int led_set_flash_brightness(struct led_classdev *led_cdev, int brightness)
+{
+	struct led_flash *flash = led_cdev->flash;
+	int ret = 0;
+
+	flash->brightness = min(brightness, flash->max_brightness);
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(brightness_set, led_cdev,
+						flash->brightness);
+	return ret;
+}
+
+int led_update_flash_brightness(struct led_classdev *led_cdev)
+{
+	struct led_flash *flash = led_cdev->flash;
+	int ret;
+
+	ret = call_flash_op(brightness_get, led_cdev);
+	if (ret >= 0) {
+		flash->brightness = ret;
+		return 0;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(led_update_flash_brightness);
+
+static int __init flash_leds_init(void)
+{
+	return 0;
+}
+
+static void __exit flash_leds_exit(void)
+{
+}
+
+subsys_initcall(flash_leds_init);
+module_exit(flash_leds_exit);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LED Class Flash Interface");
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index df1a7c1..40e21c0 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -37,6 +37,14 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 	char trigger_name[TRIG_NAME_MAX];
 	struct led_trigger *trig;
 	size_t len;
+	int ret = count;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto exit_unlock;
+	}
 
 	trigger_name[sizeof(trigger_name) - 1] = '\0';
 	strncpy(trigger_name, buf, sizeof(trigger_name) - 1);
@@ -47,7 +55,7 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 
 	if (!strcmp(trigger_name, "none")) {
 		led_trigger_remove(led_cdev);
-		return count;
+		goto exit_unlock;
 	}
 
 	down_read(&triggers_list_lock);
@@ -58,12 +66,14 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
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
index 4c50365..f815ce7 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -17,6 +17,9 @@
 #include <linux/rwsem.h>
 #include <linux/leds.h>
 
+#define call_flash_op(op, args...)		\
+	((led_cdev)->flash->ops.op(args))
+
 static inline void __led_set_brightness(struct led_classdev *led_cdev,
 					enum led_brightness value)
 {
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 0287ab2..596555a 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -13,12 +13,14 @@
 #define __LINUX_LEDS_H_INCLUDED
 
 #include <linux/list.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/rwsem.h>
+#include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 
 struct device;
+struct led_flash;
 /*
  * LED Core
  */
@@ -42,6 +44,7 @@ struct led_classdev {
 #define LED_BLINK_ONESHOT	(1 << 17)
 #define LED_BLINK_ONESHOT_STOP	(1 << 18)
 #define LED_BLINK_INVERT	(1 << 19)
+#define LED_SYSFS_LOCK		(1 << 21)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
@@ -69,6 +72,12 @@ struct led_classdev {
 	unsigned long		 blink_delay_on, blink_delay_off;
 	struct timer_list	 blink_timer;
 	int			 blink_brightness;
+	struct led_flash	*flash;
+	/*
+	 * Ensures consistent LED sysfs access and protects
+	 * LED sysfs locking mechanism
+	 */
+	struct mutex		led_lock;
 
 	struct work_struct	set_brightness_work;
 	int			delayed_set_value;
@@ -90,6 +99,7 @@ extern int led_classdev_register(struct device *parent,
 extern void led_classdev_unregister(struct led_classdev *led_cdev);
 extern void led_classdev_suspend(struct led_classdev *led_cdev);
 extern void led_classdev_resume(struct led_classdev *led_cdev);
+extern int led_classdev_init_flash(struct led_classdev *led_cdev);
 
 /**
  * led_blink_set - set blinking with software fallback
@@ -139,6 +149,18 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
 extern void led_set_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness);
 
+/**
+ * led_sysfs_is_locked
+ * @led_cdev: the LED to query
+ *
+ * Returns: true if the sysfs interface of the led is disabled,
+ *	    false otherwise
+ */
+static inline bool led_sysfs_is_locked(struct led_classdev *led_cdev)
+{
+	return led_cdev->flags & LED_SYSFS_LOCK;
+}
+
 /*
  * LED Triggers
  */
diff --git a/include/linux/leds_flash.h b/include/linux/leds_flash.h
new file mode 100644
index 0000000..7363e0e
--- /dev/null
+++ b/include/linux/leds_flash.h
@@ -0,0 +1,189 @@
+/*
+ * Flash leds API
+ *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
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
+
+#define LED_FAULT_OVER_VOLTAGE		(1 << 0)
+#define LED_FAULT_TIMEOUT		(1 << 1)
+#define LED_FAULT_OVER_TEMPERATURE	(1 << 2)
+#define LED_FAULT_SHORT_CIRCUIT		(1 << 3)
+#define LED_FAULT_OVER_CURRENT		(1 << 4)
+#define LED_FAULT_UNDER_VOLTAGE		(1 << 6)
+#define LED_FAULT_INPUT_VOLTAGE		(1 << 7)
+#define LED_FAULT_LED_OVER_TEMPERATURE	(1 << 8)
+
+struct led_flash_ops {
+	/* set flash_brightness */
+	int	(*brightness_set)(struct led_classdev *led_cdev,
+					int brightness);
+	/* get flash_brightness */
+	int	(*brightness_get)(struct led_classdev *led_cdev);
+	/* setup flash strobe */
+	int	(*strobe_set)(struct led_classdev *led_cdev,
+					bool state);
+	/* get flash strobe state */
+	int	(*strobe_get)(struct led_classdev *led_cdev);
+	/* setup flash timeout */
+	int	(*timeout_set)(struct led_classdev *led_cdev,
+					unsigned long *timeout);
+	/* setup strobing the flash by hardware pin */
+	int	(*hw_trig_set)(struct led_classdev *led_cdev,
+					bool enable);
+	/* get the flash LED fault */
+	int	(*fault_get)(struct led_classdev *led_cdev,
+					unsigned int *fault);
+};
+
+struct led_flash {
+	/* flash led specific ops */
+	const struct led_flash_ops	ops;
+	/* flash led sysfs attributes */
+	const struct attribute_group	*sysfs_attrs;
+	/* current flash brightness */
+	int		brightness;
+	/*
+	 * maximum allowed flash brightness - it is read only and
+	 * must be initialized by the driver
+	 */
+	int		max_brightness;
+	/* current flash timeout */
+	unsigned long	timeout;
+	/*
+	 * maximum allowed flash timeout - it is read only and
+	 * must be initialized by the driver
+	 */
+	unsigned long	max_timeout;
+	/*
+	 * determines whether a device supports triggering a flash led
+	 * with use of a dedicated hardware pin
+	 */
+	bool		has_hw_trig;
+	/* if true then hardware pin triggers flash strobe */
+	bool		hw_triggered;
+};
+
+#ifdef CONFIG_LEDS_CLASS_FLASH
+/**
+ * led_classdev_init_flash - add support for flash led
+ * @led_cdev: the device to add flash led support to
+ *
+ * Returns: 0 on success, error code on failure.
+ */
+extern int led_classdev_init_flash(struct led_classdev *led_cdev);
+#else
+extern int led_classdev_init_flash(struct led_classdev *led_cdev)
+{
+	return 0;
+}
+#endif
+
+/**
+ * led_set_flash_strobe - setup flash strobe
+ * @led_cdev: the flash LED to set strobe on
+ * @state: 1 - strobe flash, 0 - stop flash strobe
+ *
+ * Setup flash strobe - trigger flash strobe
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_flash_strobe(struct led_classdev *led_cdev, bool state);
+
+/**
+ * led_get_flash_strobe - get flash strobe status
+ * @led_cdev: the LED to query
+ *
+ * Check whether the flash is strobing at the moment or not.
+ *
+ * Returns: flash strobe status (0 or 1) on success or negative
+ *	    error value on failure.
+ */
+extern int led_get_flash_strobe(struct led_classdev *led_cdev);
+
+/**
+ * led_set_flash_brightness - set flash LED brightness
+ * @led_cdev: the LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Set a flash LED's brightness.
+ */
+extern int led_set_flash_brightness(struct led_classdev *led_cdev,
+					int brightness);
+
+/**
+ * led_update_flash_brightness - update flash LED brightness
+ * @led_cdev: the LED to query
+ *
+ * Get a flash LED's current brightness and update led_flash->brightness
+ * member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_flash_brightness(struct led_classdev *led_cdev);
+
+/**
+ * led_set_flash_timeout - set flash LED timeout
+ * @led_cdev: the LED to set
+ * @timeout: the flash timeout to set it to
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Set the flash strobe duration. The duration set by the driver
+ * is returned in the timeout argument and may differ from the
+ * one that was originally passed.
+ */
+extern int led_set_flash_timeout(struct led_classdev *led_cdev,
+					unsigned long *timeout);
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
+					unsigned int *fault);
+
+/**
+ * led_set_hw_triggered - set the flash LED hw_triggered mode
+ * @led_cdev: the LED to set
+ * @enable: the state to set it to
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
+#endif	/* __LINUX_FLASH_LEDS_H_INCLUDED */
-- 
1.7.9.5

