Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaHTNmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:42:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25440 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaHTNmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:42:35 -0400
X-AuditID: cbfee61a-f79e46d00000134f-2e-53f4a5c8ea34
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v5 4/4] leds: Add LED Flash Class wrapper to LED subsystem
Date: Wed, 20 Aug 2014 15:41:58 +0200
Message-id: <1408542118-32723-5-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jAd2TS78EG+yYyW6xccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktdu96yurA6bFz1l12jz3zf7B69G1Z
	xejxeZNcAEsUl01Kak5mWWqRvl0CV8bKb6fYC3Z9ZKz4uLGFsYGx+zhjFyMnh4SAicSW2a+Z
	IGwxiQv31rN1MXJxCAksYpRY8+AkC4TTziTR3zQZrIpNwFDi5wuIDhGBcome98/AOpgFVjNK
	3Nn6lRUkISzgJ/F53WF2EJtFQFXi/+PNLCA2r4CHxInzO4GaOYDWKUjMmWQDEuYU8JTYuuEH
	2EVCQCXNS8+wTGDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOMieSe1gXNlgcYhR
	gINRiYe3YcGXYCHWxLLiytxDjBIczEoivO2dQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qt
	A4UE0hNLUrNTUwtSi2CyTBycUg2MJ5asdX/qNN/D69fjKGPPLw9sCvQr/u17PWWhxwKhgkdP
	n7GLFVatTrbrjbjz6Wzz78Z56a53/Kax77r5vS2lY3HC4/WFGZa5h9zjNmzJ7Y97JFx6QP7T
	Hw+xhalHdj3u/lTIEao8sy72wRzeLQv4GQ1vO5324Fux/ErSK4/4TsNN/arNmgvXKLEUZyQa
	ajEXFScCAHxnRkwuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LED devices support two operation modes - torch and flash.
This patch provides support for flash LED devices in the LED subsystem
by introducing new sysfs attributes and kernel internal interface.
The attributes being introduced are: flash_brightness, flash_strobe,
flash_timeout, max_flash_timeout, max_flash_brightness, flash_fault,
external_strobe, indicator_brightness, max_indicator_brightness.
All the flash related features are placed in a separate module.

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
 drivers/leds/Kconfig            |   11 +
 drivers/leds/Makefile           |    1 +
 drivers/leds/led-class-flash.c  |  645 +++++++++++++++++++++++++++++++++++++++
 drivers/leds/led-class.c        |    4 +
 drivers/leds/led-triggers.c     |    5 +
 include/linux/led-class-flash.h |  273 +++++++++++++++++
 include/linux/leds.h            |    3 +
 7 files changed, 942 insertions(+)
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 include/linux/led-class-flash.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index f6e32ba..a22c211 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -19,6 +19,17 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
+config LEDS_CLASS_FLASH
+	tristate "LED Flash Class Support"
+	depends on LEDS_CLASS
+	depends on OF
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
index d8cc5f2..9238b8a 100644
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
index 0000000..4132769
--- /dev/null
+++ b/drivers/leds/led-class-flash.c
@@ -0,0 +1,645 @@
+/*
+ * LED Flash Class interface
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
+#include <linux/leds.h>
+#include <linux/led-class-flash.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "leds.h"
+
+#define has_flash_op(flash, op)				\
+	(flash && flash->ops->op)
+
+#define call_flash_op(flash, op, args...)		\
+	((has_flash_op(flash, op)) ?			\
+			(flash->ops->op(flash, args)) :	\
+			-EINVAL)
+
+static ssize_t flash_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
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
+	ret = led_set_flash_brightness(flash, state);
+	if (ret < 0)
+		goto unlock;
+
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
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	/* no lock needed for this */
+	led_update_flash_brightness(flash);
+
+	return sprintf(buf, "%u\n", flash->brightness.val);
+}
+static DEVICE_ATTR_RW(flash_brightness);
+
+static ssize_t max_flash_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->brightness.max);
+}
+static DEVICE_ATTR_RO(max_flash_brightness);
+
+static ssize_t indicator_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
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
+	ret = led_set_indicator_brightness(flash, state);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t indicator_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	/* no lock needed for this */
+	led_update_indicator_brightness(flash);
+
+	return sprintf(buf, "%u\n", flash->indicator_brightness->val);
+}
+static DEVICE_ATTR_RW(indicator_brightness);
+
+static ssize_t max_indicator_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->indicator_brightness->max);
+}
+static DEVICE_ATTR_RO(max_indicator_brightness);
+
+static ssize_t flash_strobe_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	unsigned long state;
+	ssize_t ret = -EINVAL;
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
+	if (state < 0 || state > 1) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = led_set_flash_strobe(flash, state);
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
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	bool state;
+	int ret;
+
+	/* no lock needed for this */
+	ret = led_get_flash_strobe(flash, &state);
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
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
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
+	ret = led_set_flash_timeout(flash, flash_timeout);
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
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->timeout.val);
+}
+static DEVICE_ATTR_RW(flash_timeout);
+
+static ssize_t max_flash_timeout_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->timeout.max);
+}
+static DEVICE_ATTR_RO(max_flash_timeout);
+
+static ssize_t flash_fault_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	u32 fault;
+	int ret;
+
+	ret = led_get_flash_fault(flash, &fault);
+	if (ret < 0)
+		return -EINVAL;
+
+	return sprintf(buf, "0x%8.8x\n", fault);
+}
+static DEVICE_ATTR_RO(flash_fault);
+
+static ssize_t external_strobe_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	unsigned long external_strobe;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &external_strobe);
+	if (ret)
+		goto unlock;
+
+	if (external_strobe > 1) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = led_set_external_strobe(flash, external_strobe);
+	if (ret < 0)
+		goto unlock;
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t external_strobe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->external_strobe);
+}
+static DEVICE_ATTR_RW(external_strobe);
+
+static struct attribute *led_flash_strobe_attrs[] = {
+	&dev_attr_flash_strobe.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_indicator_attrs[] = {
+	&dev_attr_indicator_brightness.attr,
+	&dev_attr_max_indicator_brightness.attr,
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
+static struct attribute *led_flash_external_strobe_attrs[] = {
+	&dev_attr_external_strobe.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_fault_attrs[] = {
+	&dev_attr_flash_fault.attr,
+	NULL,
+};
+
+static struct attribute_group led_flash_strobe_group = {
+	.attrs = led_flash_strobe_attrs,
+};
+
+static struct attribute_group led_flash_brightness_group = {
+	.attrs = led_flash_brightness_attrs,
+};
+
+static struct attribute_group led_flash_timeout_group = {
+	.attrs = led_flash_timeout_attrs,
+};
+
+static struct attribute_group led_flash_indicator_group = {
+	.attrs = led_flash_indicator_attrs,
+};
+
+static struct attribute_group led_flash_fault_group = {
+	.attrs = led_flash_fault_attrs,
+};
+
+static struct attribute_group led_flash_external_strobe_group = {
+	.attrs = led_flash_external_strobe_attrs,
+};
+
+static void led_flash_resume(struct led_classdev *led_cdev)
+{
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	call_flash_op(flash, flash_brightness_set, flash->brightness.val);
+	call_flash_op(flash, timeout_set, flash->timeout.val);
+	call_flash_op(flash, indicator_brightness_set,
+				flash->indicator_brightness->val);
+}
+
+static void led_flash_remove_sysfs_groups(struct led_classdev_flash *flash)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int i;
+
+	for (i = 0; i < LED_FLASH_MAX_SYSFS_GROUPS; ++i)
+		if (flash->sysfs_groups[i])
+			sysfs_remove_group(&led_cdev->dev->kobj,
+						flash->sysfs_groups[i]);
+}
+
+static int led_flash_create_sysfs_groups(struct led_classdev_flash *flash)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	const struct led_flash_ops *ops = flash->ops;
+	int ret, num_sysfs_groups = 0;
+
+	memset(flash->sysfs_groups, 0, sizeof(*flash->sysfs_groups) *
+						LED_FLASH_MAX_SYSFS_GROUPS);
+
+	ret = sysfs_create_group(&led_cdev->dev->kobj, &led_flash_strobe_group);
+	if (ret < 0)
+		goto err_create_group;
+	flash->sysfs_groups[num_sysfs_groups++] = &led_flash_strobe_group;
+
+	if (flash->indicator_brightness) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_indicator_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_indicator_group;
+	}
+
+	if (ops->flash_brightness_set) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_brightness_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_brightness_group;
+	}
+
+	if (ops->timeout_set) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_timeout_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_timeout_group;
+	}
+
+	if (ops->fault_get) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_fault_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_fault_group;
+	}
+
+	if (flash->has_external_strobe) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_external_strobe_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_external_strobe_group;
+	}
+
+	return 0;
+
+err_create_group:
+	led_flash_remove_sysfs_groups(flash);
+	return ret;
+}
+
+int led_classdev_flash_register(struct device *parent,
+				struct led_classdev_flash *flash,
+				struct device_node *node)
+{
+	struct led_classdev *led_cdev;
+	const struct led_flash_ops *ops;
+	int ret = -EINVAL;
+
+	if (!flash)
+		return -EINVAL;
+
+	led_cdev = &flash->led_cdev;
+
+	/* Torch capability is default for every LED Flash Class device */
+	led_cdev->flags |= LED_DEV_CAP_TORCH;
+
+	if (led_cdev->flags & LED_DEV_CAP_FLASH) {
+		if (!led_cdev->torch_brightness_set)
+			return -EINVAL;
+
+		ops = flash->ops;
+		if (!ops || !ops->strobe_set)
+			return -EINVAL;
+
+		if ((led_cdev->flags & LED_DEV_CAP_INDICATOR) &&
+		    (!flash->indicator_brightness ||
+		     !ops->indicator_brightness_set))
+			return -EINVAL;
+
+		led_cdev->flash_resume = led_flash_resume;
+	}
+
+	/* Register led class device */
+	ret = led_classdev_register(parent, led_cdev);
+	if (ret < 0)
+		return -EINVAL;
+
+	/* Create flash led specific sysfs attributes */
+	ret = led_flash_create_sysfs_groups(flash);
+	if (ret < 0)
+		goto err_create_sysfs_groups;
+
+	return 0;
+
+err_create_sysfs_groups:
+	led_classdev_unregister(led_cdev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_classdev_flash_register);
+
+void led_classdev_flash_unregister(struct led_classdev_flash *flash)
+{
+	if (!flash)
+		return;
+
+	led_flash_remove_sysfs_groups(flash);
+	led_classdev_unregister(&flash->led_cdev);
+}
+EXPORT_SYMBOL_GPL(led_classdev_flash_unregister);
+
+int led_set_flash_strobe(struct led_classdev_flash *flash, bool state)
+{
+	if (flash->external_strobe)
+		return -EBUSY;
+
+	return call_flash_op(flash, strobe_set, state);
+}
+EXPORT_SYMBOL_GPL(led_set_flash_strobe);
+
+int led_get_flash_strobe(struct led_classdev_flash *flash, bool *state)
+{
+	return call_flash_op(flash, strobe_get, state);
+}
+EXPORT_SYMBOL_GPL(led_get_flash_strobe);
+
+void led_clamp_align(struct led_flash_setting *s)
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
+int led_set_flash_timeout(struct led_classdev_flash *flash, u32 timeout)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct led_flash_setting *s = &flash->timeout;
+	int ret = 0;
+
+	s->val = timeout;
+	led_clamp_align(s);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(flash, timeout_set, s->val);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_set_flash_timeout);
+
+int led_get_flash_fault(struct led_classdev_flash *flash, u32 *fault)
+{
+	return call_flash_op(flash, fault_get, fault);
+}
+EXPORT_SYMBOL_GPL(led_get_flash_fault);
+
+int led_set_external_strobe(struct led_classdev_flash *flash, bool enable)
+{
+	int ret;
+
+	if (flash->has_external_strobe) {
+		/*
+		 * Some flash led devices need altering their register
+		 * settings to start listen to the external strobe signal.
+		 */
+		if (has_flash_op(flash, external_strobe_set)) {
+			ret = call_flash_op(flash, external_strobe_set, enable);
+			if (ret < 0)
+				return ret;
+		}
+
+		flash->external_strobe = enable;
+	} else if (enable) {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(led_set_external_strobe);
+
+int led_set_flash_brightness(struct led_classdev_flash *flash,
+				u32 brightness)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct led_flash_setting *s = &flash->brightness;
+	int ret = 0;
+
+	s->val = brightness;
+	led_clamp_align(s);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(flash, flash_brightness_set, s->val);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_set_flash_brightness);
+
+int led_update_flash_brightness(struct led_classdev_flash *flash)
+{
+	struct led_flash_setting *s = &flash->brightness;
+	u32 brightness;
+	int ret = 0;
+
+	if (has_flash_op(flash, flash_brightness_get)) {
+		ret = call_flash_op(flash, flash_brightness_get,
+						&brightness);
+		if (ret < 0)
+			return ret;
+		s->val = brightness;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_update_flash_brightness);
+
+int led_set_indicator_brightness(struct led_classdev_flash *flash,
+					u32 brightness)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct led_flash_setting *s = flash->indicator_brightness;
+	int ret = 0;
+
+	if (!s)
+		return -EINVAL;
+
+	s->val = brightness;
+	led_clamp_align(s);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(flash, indicator_brightness_set, s->val);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_set_indicator_brightness);
+
+int led_update_indicator_brightness(struct led_classdev_flash *flash)
+{
+	struct led_flash_setting *s = flash->indicator_brightness;
+	u32 brightness;
+	int ret = 0;
+
+	if (!s)
+		return -EINVAL;
+
+	if (has_flash_op(flash, indicator_brightness_get)) {
+		ret = call_flash_op(flash, indicator_brightness_get,
+							&brightness);
+		if (ret < 0)
+			return ret;
+		s->val = brightness;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_update_indicator_brightness);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LED Flash Class Interface");
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f640da9..86a03a0 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -189,6 +189,10 @@ EXPORT_SYMBOL_GPL(led_classdev_suspend);
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
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index d391a5d..d80a8f3 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -43,6 +43,11 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&led_cdev->led_lock);
 #endif
 
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto exit_unlock;
+	}
+
 	trigger_name[sizeof(trigger_name) - 1] = '\0';
 	strncpy(trigger_name, buf, sizeof(trigger_name) - 1);
 	len = strlen(trigger_name);
diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
new file mode 100644
index 0000000..a882263
--- /dev/null
+++ b/include/linux/led-class-flash.h
@@ -0,0 +1,273 @@
+/*
+ * LED Flash Class interface
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
+struct led_classdev_flash;
+struct device_node;
+
+/*
+ * Supported led fault bits - must be kept in synch
+ * with V4L2_FLASH_FAULT bits.
+ */
+#define LED_FAULT_OVER_VOLTAGE		 V4L2_FLASH_FAULT_OVER_VOLTAGE
+#define LED_FAULT_TIMEOUT		 V4L2_FLASH_FAULT_TIMEOUT
+#define LED_FAULT_OVER_TEMPERATURE	 V4L2_FLASH_FAULT_OVER_TEMPERATURE
+#define LED_FAULT_SHORT_CIRCUIT		 V4L2_FLASH_FAULT_SHORT_CIRCUIT
+#define LED_FAULT_OVER_CURRENT		 V4L2_FLASH_FAULT_OVER_CURRENT
+#define LED_FAULT_INDICATOR		 V4L2_FLASH_FAULT_INDICATOR
+#define LED_FAULT_UNDER_VOLTAGE		 V4L2_FLASH_FAULT_UNDER_VOLTAGE
+#define LED_FAULT_INPUT_VOLTAGE		 V4L2_FLASH_FAULT_INPUT_VOLTAGE
+#define LED_FAULT_LED_OVER_TEMPERATURE	 V4L2_FLASH_OVER_TEMPERATURE
+
+#define LED_FLASH_MAX_SYSFS_GROUPS 6
+
+struct led_flash_ops {
+	/* set flash brightness */
+	int (*flash_brightness_set)(struct led_classdev_flash *flash,
+					u32 brightness);
+	/* get flash brightness */
+	int (*flash_brightness_get)(struct led_classdev_flash *flash,
+					u32 *brightness);
+	/* set flash indicator brightness */
+	int (*indicator_brightness_set)(struct led_classdev_flash *flash,
+					u32 brightness);
+	/* get flash indicator brightness */
+	int (*indicator_brightness_get)(struct led_classdev_flash *flash,
+					u32 *brightness);
+	/* set flash strobe state */
+	int (*strobe_set)(struct led_classdev_flash *flash, bool state);
+	/* get flash strobe state */
+	int (*strobe_get)(struct led_classdev_flash *flash, bool *state);
+	/* set flash timeout */
+	int (*timeout_set)(struct led_classdev_flash *flash, u32 timeout);
+	/* setup the device to strobe the flash upon a pin state assertion */
+	int (*external_strobe_set)(struct led_classdev_flash *flash,
+					bool enable);
+	/* get the flash LED fault */
+	int (*fault_get)(struct led_classdev_flash *flash, u32 *fault);
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
+/*
+ * Aggregated flash settings - designed for ease
+ * of passing initialization data to the clients
+ * wrapping a LED Flash class device.
+ */
+struct led_flash_config {
+	struct led_flash_setting torch_brightness;
+	struct led_flash_setting flash_brightness;
+	struct led_flash_setting indicator_brightness;
+	struct led_flash_setting flash_timeout;
+	u32 flash_faults;
+};
+
+struct led_classdev_flash {
+	/* led-flash-manager uses it to link flashes */
+	struct list_head list;
+	/* led class device */
+	struct led_classdev led_cdev;
+	/* flash led specific ops */
+	const struct led_flash_ops *ops;
+
+	/* flash sysfs groups */
+	struct attribute_group *sysfs_groups[LED_FLASH_MAX_SYSFS_GROUPS];
+
+	/* flash brightness value in microamperes along with its constraints */
+	struct led_flash_setting brightness;
+
+	/* timeout value in microseconds along with its constraints */
+	struct led_flash_setting timeout;
+
+	/*
+	 * Indicator brightness value in microamperes along with
+	 * its constraints - this is an optional setting and must
+	 * be allocated by the driver if the device supports privacy
+	 * indicator led.
+	 */
+	struct led_flash_setting *indicator_brightness;
+
+	/*
+	 * determines if a device supports external
+	 * flash strobe sources
+	 */
+	bool has_external_strobe;
+
+	/* If true the flash led is strobed from external source */
+	bool external_strobe;
+
+	/* Flash manager data */
+	/* Strobe signals topology data */
+	struct list_head software_strobe_gates;
+	struct list_head strobe_providers;
+
+	/* identifier of the selected strobe signal provider */
+	int strobe_provider_id;
+
+	/* number of defined strobe providers */
+	int num_strobe_providers;
+};
+
+static inline struct led_classdev_flash *lcdev_to_flash(
+						struct led_classdev *lcdev)
+{
+	return container_of(lcdev, struct led_classdev_flash, led_cdev);
+}
+
+/**
+ * led_classdev_flash_register - register a new object of led_classdev class
+				 with support for flash LEDs
+ * @parent: the flash LED to register
+ * @flash: the led_classdev_flash structure for this device
+ * @node: device tree node of the LED Flash Class device - it must be
+	  initialized if the device is to be registered in the flash manager
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+int led_classdev_flash_register(struct device *parent,
+				struct led_classdev_flash *flash,
+				struct device_node *node);
+
+/**
+ * led_classdev_flash_unregister - unregisters an object of led_classdev class
+				   with support for flash LEDs
+ * @flash: the flash LED to unregister
+ *
+ * Unregisters a previously registered via led_classdev_flash_register object
+ */
+void led_classdev_flash_unregister(struct led_classdev_flash *flash);
+
+/**
+ * led_set_flash_strobe - setup flash strobe
+ * @flash: the flash LED to set strobe on
+ * @state: 1 - strobe flash, 0 - stop flash strobe
+ *
+ * Setup flash strobe - trigger flash strobe
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_flash_strobe(struct led_classdev_flash *flash,
+				bool state);
+
+/**
+ * led_get_flash_strobe - get flash strobe status
+ * @flash: the flash LED to query
+ * @state: 1 - flash is strobing, 0 - flash is off
+ *
+ * Check whether the flash is strobing at the moment or not.
+ *
+u* Returns: 0 on success or negative error value on failure
+ */
+extern int led_get_flash_strobe(struct led_classdev_flash *flash,
+				bool *state);
+/**
+ * led_set_flash_brightness - set flash LED brightness
+ * @flash: the flash LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Returns: 0 on success or negative error value on failure
+ *
+ * Set a flash LED's brightness.
+ */
+extern int led_set_flash_brightness(struct led_classdev_flash *flash,
+					u32 brightness);
+
+/**
+ * led_update_flash_brightness - update flash LED brightness
+ * @flash: the flash LED to query
+ *
+ * Get a flash LED's current brightness and update led_flash->brightness
+ * member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_flash_brightness(struct led_classdev_flash *flash);
+
+/**
+ * led_set_flash_timeout - set flash LED timeout
+ * @flash: the flash LED to set
+ * @timeout: the flash timeout to set it to
+ *
+ * Set the flash strobe duration. The duration set by the driver
+ * is returned in the timeout argument and may differ from the
+ * one that was originally passed.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_flash_timeout(struct led_classdev_flash *flash,
+					u32 timeout);
+
+/**
+ * led_get_flash_fault - get the flash LED fault
+ * @flash: the flash LED to query
+ * @fault: bitmask containing flash faults
+ *
+ * Get the flash LED fault.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_get_flash_fault(struct led_classdev_flash *flash,
+					u32 *fault);
+
+/**
+ * led_set_external_strobe - set the flash LED external_strobe mode
+ * @flash: the flash LED to set
+ * @enable: the state to set it to
+ *
+ * Enable/disable strobing the flash LED with use of external source
+ *
+  Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_external_strobe(struct led_classdev_flash *flash,
+					bool enable);
+
+/**
+ * led_set_indicator_brightness - set indicator LED brightness
+ * @flash: the flash LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Set an indicator LED's brightness.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_indicator_brightness(struct led_classdev_flash *flash,
+					u32 led_brightness);
+
+/**
+ * led_update_indicator_brightness - update flash indicator LED brightness
+ * @flash: the flash LED to query
+ *
+ * Get a flash indicator LED's current brightness and update
+ * led_flash->indicator_brightness member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_indicator_brightness(struct led_classdev_flash *flash);
+
+
+#endif	/* __LINUX_FLASH_LEDS_H_INCLUDED */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index df0715c..8e38eef 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -44,6 +44,8 @@ struct led_classdev {
 #define LED_BLINK_INVERT	(1 << 19)
 #define LED_SYSFS_LOCK		(1 << 20)
 #define LED_DEV_CAP_TORCH	(1 << 21)
+#define LED_DEV_CAP_FLASH	(1 << 22)
+#define LED_DEV_CAP_INDICATOR	(1 << 23)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
@@ -82,6 +84,7 @@ struct led_classdev {
 	unsigned long		 blink_delay_on, blink_delay_off;
 	struct delayed_work	 blink_work;
 	int			 blink_brightness;
+	void			(*flash_resume)(struct led_classdev *led_cdev);
 
 	struct work_struct	set_brightness_work;
 	int			delayed_set_value;
-- 
1.7.9.5

