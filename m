Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbaCTOvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:51:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44288 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964848AbaCTOvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:51:46 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-f4-532b00807c04
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC 4/8] media: Add registration helpers for V4L2 flash
 sub-devices
Date: Thu, 20 Mar 2014 15:51:06 +0100
Message-id: <1395327070-20215-5-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e+xoG4Dg3awwYsNSha31p1jtZh/BEj0
	Xn3OaHG26Q27xeVdc9gstr5Zx2jRs2Erq8XhN+2sDhwefVtWMXp83iQXwBTFZZOSmpNZllqk
	b5fAlXHiqULBrJyKDWs+MDYwbojoYuTkkBAwkbh15zIjhC0mceHeerYuRi4OIYHpjBKrLp9n
	hHA6mSQ693xhBaliEzCU+PniNROILSJQLjFt6iMwm1mgUuLz1T1sILawQKjE0TnvwGwWAVWJ
	iQ1HmbsYOTh4BTwkflwoBzElBBQk5kyyAangFPCUWLq0C6xCCKji7MSICYy8CxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEh84z6R2MqxosDjEKcDAq8fCu2KMZLMSaWFZcmXuIUYKD
	WUmE1+65VrAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkG
	xoTZzIV3fF63rFZxeJV86KvHj11pP6dlOz1RyGvL26LfXsDvfp135o15catuVGQqOt/Nujhv
	59v/P1kcci35GuY82sgakN1xau8Ua9G11xvTGqNYnWbOiTj/y3KX8ZY1Ez7ZS2qdOZC4PvCZ
	z9vPLKHWRQmXCyLsUkuUPjtPF3jyk3P72kIvYyWW4oxEQy3mouJEAHxfphAZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds helper functions for registering/unregistering
LED class flash devices as V4L2 subdevs. The functions should
be called from the LED subsystem device driver. In case the
Multimedia Framework support is disabled in the kernel config
the functions' empty versions will be used.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/Makefile     |    2 +-
 drivers/media/v4l2-core/v4l2-flash.c |  320 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-flash.h           |  102 +++++++++++
 3 files changed, 423 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/media/v4l2-flash.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index c6ae7ba..63e8f03 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -6,7 +6,7 @@ tuner-objs	:=	tuner-core.o
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
 			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
-			v4l2-async.o
+			v4l2-async.o v4l2-flash.o
 ifeq ($(CONFIG_COMPAT),y)
   videodev-objs += v4l2-compat-ioctl32.o
 endif
diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
new file mode 100644
index 0000000..6be0ba9
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-flash.c
@@ -0,0 +1,320 @@
+/*
+ * V4L2 flash LED subdevice registration helpers.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-flash.h>
+#include <media/v4l2-dev.h>
+
+static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
+
+{
+	struct v4l2_flash *flash = ctrl_to_flash(c);
+	struct led_classdev *led_cdev = flash->led_cdev;
+	unsigned int fault;
+	int ret;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_STROBE_STATUS:
+		ret = led_update_brightness(led_cdev);
+		if (ret < 0)
+			return ret;
+		c->val = !!ret;
+		return 0;
+	case V4L2_CID_FLASH_FAULT:
+		/* led faults map directly to V4L2 flash faults */
+		ret = led_get_flash_fault(led_cdev, &fault);
+		if (!ret)
+			c->val = fault;
+		return ret;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int v4l2_flash_set_intensity(struct v4l2_flash *flash,
+				    unsigned int intensity)
+{
+	struct led_classdev *led_cdev = flash->led_cdev;
+	unsigned int fault;
+	int ret;
+
+	ret = led_get_flash_fault(led_cdev, &fault);
+	if (ret < 0 || fault)
+		return -EINVAL;
+
+	led_set_brightness(led_cdev, intensity);
+
+	return ret;
+}
+
+static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
+{
+	struct v4l2_flash *flash = ctrl_to_flash(c);
+	struct led_classdev *led_cdev = flash->led_cdev;
+	int ret = 0;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_LED_MODE:
+		switch (c->val) {
+		case V4L2_FLASH_LED_MODE_NONE:
+			/* clear flash mode on releae */
+			ret = led_set_flash_mode(led_cdev, false);
+			if (ret < 0)
+				return ret;
+			mutex_lock(&led_cdev->led_lock);
+			led_sysfs_unlock(led_cdev);
+			mutex_unlock(&led_cdev->led_lock);
+			break;
+		case V4L2_FLASH_LED_MODE_FLASH:
+			mutex_lock(&led_cdev->led_lock);
+			led_sysfs_lock(led_cdev);
+			mutex_unlock(&led_cdev->led_lock);
+
+			ret = led_set_flash_mode(led_cdev, true);
+			if (ret < 0)
+				return ret;
+			if (flash->ctrl.source->val ==
+					V4L2_FLASH_STROBE_SOURCE_EXTERNAL) {
+				ret = led_set_hw_triggered(led_cdev, true);
+				if (ret < 0)
+					return ret;
+				ret = v4l2_flash_set_intensity(flash,
+						       flash->flash_intensity);
+			} else {
+				ret = led_set_hw_triggered(led_cdev, false);
+				if (ret < 0)
+					return ret;
+			}
+			break;
+		case V4L2_FLASH_LED_MODE_TORCH:
+			mutex_lock(&led_cdev->led_lock);
+			led_sysfs_lock(led_cdev);
+			mutex_unlock(&led_cdev->led_lock);
+
+			ret = led_set_flash_mode(led_cdev, false);
+			if (ret < 0)
+				return ret;
+			/* torch is always triggered by software */
+			ret = led_set_hw_triggered(led_cdev, false);
+			if (ret)
+				return -EINVAL;
+			ret = v4l2_flash_set_intensity(flash,
+						       flash->torch_intensity);
+			break;
+		}
+		break;
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		ret = led_set_hw_triggered(led_cdev,
+				c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+		break;
+	case V4L2_CID_FLASH_STROBE:
+		if (flash->ctrl.led_mode->val != V4L2_FLASH_LED_MODE_FLASH ||
+		   flash->ctrl.source->val != V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
+			return -EINVAL;
+		led_set_flash_timeout(led_cdev, flash->flash_timeout);
+		ret = v4l2_flash_set_intensity(flash,
+						flash->flash_intensity);
+		break;
+	case V4L2_CID_FLASH_STROBE_STOP:
+		led_set_brightness(led_cdev, 0);
+		break;
+	case V4L2_CID_FLASH_TIMEOUT:
+		flash->flash_timeout = c->val;
+		break;
+	case V4L2_CID_FLASH_INTENSITY:
+		flash->flash_intensity = c->val;
+		break;
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		flash->torch_intensity = c->val;
+		if (flash->ctrl.led_mode->val == V4L2_FLASH_LED_MODE_TORCH)
+			ret = v4l2_flash_set_intensity(flash,
+						       flash->torch_intensity);
+		break;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops v4l2_flash_ctrl_ops = {
+	.g_volatile_ctrl = v4l2_flash_g_volatile_ctrl,
+	.s_ctrl = v4l2_flash_s_ctrl,
+};
+
+static int v4l2_flash_init_controls(struct v4l2_flash *flash,
+				struct v4l2_flash_ctrl_config *config)
+
+{
+	unsigned int mask;
+	struct v4l2_ctrl *ctrl;
+	struct v4l2_ctrl_config *ctrl_cfg;
+	bool has_flash = config->flags & V4L2_FLASH_CFG_LED_FLASH;
+	bool has_torch = config->flags & V4L2_FLASH_CFG_LED_TORCH;
+	int ret, num_ctrls;
+
+	if (!has_flash && !has_torch)
+		return -EINVAL;
+
+	num_ctrls = has_flash ? 8 : 2;
+	if (config->flags & V4L2_FLASH_CFG_FAULTS_MASK)
+		++num_ctrls;
+
+	v4l2_ctrl_handler_init(&flash->hdl, num_ctrls);
+
+	mask = 1 << V4L2_FLASH_LED_MODE_NONE;
+	if (has_flash)
+		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
+	if (has_torch)
+		mask |= 1 << V4L2_FLASH_LED_MODE_TORCH;
+
+	/* Configure TORCH_INTENSITY ctrl */
+	ctrl_cfg = &config->torch_intensity;
+	ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
+				 V4L2_CID_FLASH_TORCH_INTENSITY,
+				 ctrl_cfg->min, ctrl_cfg->max,
+				 ctrl_cfg->step, ctrl_cfg->def);
+
+	if (has_flash) {
+		/* Configure FLASH_LED_MODE ctrl */
+		flash->ctrl.led_mode = v4l2_ctrl_new_std_menu(&flash->hdl,
+				&v4l2_flash_ctrl_ops, V4L2_CID_FLASH_LED_MODE,
+				V4L2_FLASH_LED_MODE_TORCH, ~mask,
+				V4L2_FLASH_LED_MODE_NONE);
+
+		/* Configure FLASH_STROBE_SOURCE ctrl */
+		mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE |
+		       1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+
+		flash->ctrl.source = v4l2_ctrl_new_std_menu(&flash->hdl,
+					&v4l2_flash_ctrl_ops,
+					V4L2_CID_FLASH_STROBE_SOURCE,
+					V4L2_FLASH_STROBE_SOURCE_EXTERNAL,
+					~mask,
+					V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
+
+		/* Configure FLASH_STROBE ctrl */
+		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
+					  V4L2_CID_FLASH_STROBE, 0, 1, 1, 0);
+		if (ctrl)
+			ctrl->type = V4L2_CTRL_TYPE_BUTTON;
+
+		/* Configure FLASH_STROBE_STOP ctrl */
+		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
+					  V4L2_CID_FLASH_STROBE_STOP,
+					  0, 1, 1, 0);
+		if (ctrl)
+			ctrl->type = V4L2_CTRL_TYPE_BUTTON;
+
+		/* Configure FLASH_STROBE_STATUS ctrl */
+		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
+					 V4L2_CID_FLASH_STROBE_STATUS,
+					 0, 1, 1, 1);
+		if (ctrl)
+			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
+				       V4L2_CTRL_FLAG_READ_ONLY;
+
+		/* Configure FLASH_TIMEOUT ctrl */
+		ctrl_cfg = &config->flash_timeout;
+		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
+					 V4L2_CID_FLASH_TIMEOUT, ctrl_cfg->min,
+					 ctrl_cfg->max, ctrl_cfg->step,
+					 ctrl_cfg->def);
+
+		/* Configure FLASH_INTENSITY ctrl */
+		ctrl_cfg = &config->flash_intensity;
+		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
+					 V4L2_CID_FLASH_INTENSITY,
+					 ctrl_cfg->min, ctrl_cfg->max,
+					 ctrl_cfg->step, ctrl_cfg->def);
+
+		if (config->flags & V4L2_FLASH_CFG_FAULTS_MASK) {
+			/* Configure FLASH_FAULT ctrl */
+			ctrl = v4l2_ctrl_new_std(&flash->hdl,
+						 &v4l2_flash_ctrl_ops,
+						 V4L2_CID_FLASH_FAULT, 0,
+						 config->flags &
+						 V4L2_FLASH_CFG_FAULTS_MASK,
+						 0, 0);
+			if (ctrl) {
+				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
+					       V4L2_CTRL_FLAG_READ_ONLY;
+				ctrl->type = V4L2_CTRL_TYPE_BITMASK;
+			}
+		}
+	}
+
+	if (flash->hdl.error) {
+		ret = flash->hdl.error;
+		goto error_free;
+	}
+
+	ret = v4l2_ctrl_handler_setup(&flash->hdl);
+	if (ret < 0)
+		goto error_free;
+
+	flash->subdev.ctrl_handler = &flash->hdl;
+
+	return 0;
+
+error_free:
+	v4l2_ctrl_handler_free(&flash->hdl);
+	return ret;
+}
+
+/* v4l2_subdev_init requires this structure */
+static struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
+};
+
+int v4l2_flash_init(struct led_classdev *led_cdev, struct v4l2_flash *flash,
+				struct v4l2_flash_ctrl_config *config)
+{
+	struct v4l2_subdev *sd = &flash->subdev;
+	int ret;
+
+	flash->led_cdev = led_cdev;
+	sd->dev = led_cdev->dev->parent;
+	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), led_cdev->name);
+
+	ret = v4l2_flash_init_controls(flash, config);
+	if (ret < 0)
+		goto err_init_controls;
+
+	ret = media_entity_init(&sd->entity, 0, NULL, 0);
+	if (ret < 0)
+		goto err_init_entity;
+
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
+
+	ret = v4l2_async_register_subdev(sd);
+	if (ret < 0)
+		goto err_init_entity;
+
+	return 0;
+
+err_init_entity:
+	media_entity_cleanup(&sd->entity);
+err_init_controls:
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_init);
+
+void v4l2_flash_release(struct v4l2_flash *flash)
+{
+	media_entity_cleanup(&flash->subdev.entity);
+	v4l2_ctrl_handler_free(flash->subdev.ctrl_handler);
+	v4l2_async_unregister_subdev(&flash->subdev);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_release);
diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
new file mode 100644
index 0000000..138edae
--- /dev/null
+++ b/include/media/v4l2-flash.h
@@ -0,0 +1,102 @@
+/*
+ * V4L2 flash LED subdevice registration helpers.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#ifndef _V4L2_FLASH_H
+#define _V4L2_FLASH_H
+
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-dev.h>
+#include <linux/leds.h>
+
+/*
+ * Supported led fault and mode bits -
+ * must be kept in synch with V4L2_FLASH_FAULT bits
+ */
+#define V4L2_FLASH_CFG_FAULT_OVER_VOLTAGE	(1 << 0)
+#define V4L2_FLASH_CFG_FAULT_TIMEOUT		(1 << 1)
+#define V4L2_FLASH_CFG_FAULT_OVER_TEMPERATURE	(1 << 2)
+#define V4L2_FLASH_CFG_FAULT_SHORT_CIRCUIT	(1 << 3)
+#define V4L2_FLASH_CFG_FAULT_OVER_CURRENT	(1 << 4)
+#define V4L2_FLASH_CFG_FAULT_INDICATOR		(1 << 5)
+#define V4L2_FLASH_CFG_FAULTS_MASK		0x3f
+#define V4L2_FLASH_CFG_LED_FLASH		(1 << 6)
+#define V4L2_FLASH_CFG_LED_TORCH		(1 << 7)
+
+/* Flash control config data initializer */
+
+struct v4l2_flash {
+	struct led_classdev *led_cdev;
+	struct v4l2_subdev subdev;
+	struct v4l2_ctrl_handler hdl;
+
+	struct {
+		struct v4l2_ctrl *source;
+		struct v4l2_ctrl *led_mode;
+	} ctrl;
+
+	unsigned int flash_intensity;
+	unsigned int torch_intensity;
+	unsigned int flash_timeout;
+};
+
+struct v4l2_flash_ctrl_config {
+	struct v4l2_ctrl_config flash_timeout;
+	struct v4l2_ctrl_config flash_intensity;
+	struct v4l2_ctrl_config torch_intensity;
+	unsigned int flags;
+};
+
+static inline struct v4l2_flash *subdev_to_flash(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct v4l2_flash, subdev);
+}
+
+static inline struct v4l2_flash *ctrl_to_flash(struct v4l2_ctrl *c)
+{
+	return container_of(c->handler, struct v4l2_flash, hdl);
+}
+
+#ifdef CONFIG_VIDEO_V4L2
+/**
+ * v4l2_flash_init - initialize V4L2 flash led sub-device
+ * @led_cdev: the LED to create subdev upon
+ * @flash: a structure representing V4L2 flash led device
+ * @config: initial data for the flash led subdev controls
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+ */
+int v4l2_flash_init(struct led_classdev *led_cdev, struct v4l2_flash *flash,
+				struct v4l2_flash_ctrl_config *config);
+
+/**
+ * v4l2_flash_release - release V4L2 flash led sub-device
+ * @flash: a structure representing V4L2 flash led device
+ *
+ * Release V4L2 flash led subdev.
+ */
+void v4l2_flash_release(struct v4l2_flash *flash);
+#else
+static inline int v4l2_flash_init(struct led_classdev *led_cdev,
+				  struct v4l2_flash *flash,
+				  struct v4l2_flash_ctrl_config *config)
+{
+	return 0;
+}
+
+static inline void v4l2_flash_release(struct v4l2_flash *flash)
+{
+}
+#endif
+
+#endif
-- 
1.7.9.5

