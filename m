Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaC1P3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:29:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40179 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaC1P3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:29:46 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-eb-5335956931b2
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v2 6/8] media: Add registration helpers for V4L2 flash
 sub-devices
Date: Fri, 28 Mar 2014 16:29:03 +0100
Message-id: <1396020545-15727-7-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
References: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e+xoG7mVNNgg8stsha31p1jtZh/BEj0
	Xn3OaHG26Q27xeVdc9gstr5Zx2jRs2Erq8XhN+2sDhwefVtWMXp83iQXwBTFZZOSmpNZllqk
	b5fAldGzdi1jwe7CivXntzA3MF6K7WLk5JAQMJF42DSDDcIWk7hwbz2QzcUhJDCdUeLM489M
	EE4nk8TXOy9YQarYBAwlfr54zQRiiwiUS0yb+gjMZhaolPh8dQ/YJGGBCIk1m66zdDFycLAI
	qErMPJsJEuYV8JBo3TabESQsIaAgMWeSDUiYU8BT4vaLdkYQWwio5Muck+wTGHkXMDKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAgOn2fSOxhXNVgcYhTgYFTi4RVoNQ0WYk0sK67MPcQo
	wcGsJMKbNREoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1Oq
	gZHxN8uEjeH5kc1ex5qnXOYpd9BYWrsxqSr9ZEcE49+D1S6T2D59EdF4lCTlf/TMjzUvWJ/+
	EI07an87g8kgZ3VF/IWqx5G3E3723Lab9vZPW1CJ5vfJtoXdTHdf7Hhm8PGA67O4aVwrLVh3
	zmiYPTmI677ZO3mXlgv7n7Ckixb6zlr/Y1/ayblKLMUZiYZazEXFiQAYBvx8GwIAAA==
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
 drivers/media/v4l2-core/Kconfig      |   10 ++
 drivers/media/v4l2-core/Makefile     |    2 +
 drivers/media/v4l2-core/v4l2-flash.c |  302 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-flash.h           |  104 ++++++++++++
 4 files changed, 418 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/media/v4l2-flash.h

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 2189bfb..07b53e5 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -35,6 +35,16 @@ config V4L2_MEM2MEM_DEV
         tristate
         depends on VIDEOBUF2_CORE
 
+# Used by LED subsystem flash drivers
+config V4L2_FLASH
+	tristate "Enable support for V4L2 Flash sub-devices"
+	depends on LEDS_CLASS_FLASH
+	---help---
+	  Say Y here to enable support for V4L2 Flash sub-devices, which allow
+	  to control LED class devices with V4L2 API.
+
+	  When in doubt, say N.
+
 # Used by drivers that need Videobuf modules
 config VIDEOBUF_GEN
 	tristate
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index c6ae7ba..8e37ab4 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -22,6 +22,8 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
+obj-$(CONFIG_V4L2_FLASH) += v4l2-flash.o
+
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
 obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
new file mode 100644
index 0000000..81370f9
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-flash.c
@@ -0,0 +1,302 @@
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
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-flash.h>
+#include <media/v4l2-ioctl.h>
+
+static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
+
+{
+	struct v4l2_flash *flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev *led_cdev = flash->led_cdev;
+	unsigned int fault;
+	int ret;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		ret = led_update_brightness(led_cdev);
+		if (ret < 0)
+			return ret;
+		c->val = led_cdev->brightness;
+		return 0;
+	case V4L2_CID_FLASH_INTENSITY:
+		ret = led_update_flash_brightness(led_cdev);
+		if (ret < 0)
+			return ret;
+		c->val = led_cdev->flash->brightness;
+		return 0;
+	case V4L2_CID_FLASH_STROBE_STATUS:
+		ret = led_get_flash_strobe(led_cdev);
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
+static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
+{
+	struct v4l2_flash *flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev *led_cdev = flash->led_cdev;
+	bool hw_trig;
+	int ret;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_LED_MODE:
+		switch (c->val) {
+		case V4L2_FLASH_LED_MODE_NONE:
+			led_set_brightness(led_cdev, 0);
+			ret = led_set_flash_strobe(led_cdev, false);
+
+			mutex_lock(&led_cdev->led_lock);
+			led_sysfs_unlock(led_cdev);
+			mutex_unlock(&led_cdev->led_lock);
+			return ret;
+		case V4L2_FLASH_LED_MODE_FLASH:
+			mutex_lock(&led_cdev->led_lock);
+			led_sysfs_lock(led_cdev);
+			mutex_unlock(&led_cdev->led_lock);
+
+			/* Turn off torch LED */
+			led_set_brightness(led_cdev, 0);
+			hw_trig = (flash->ctrl.source->val ==
+					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+			return led_set_hw_triggered(led_cdev, hw_trig);
+		case V4L2_FLASH_LED_MODE_TORCH:
+			mutex_lock(&led_cdev->led_lock);
+			led_sysfs_lock(led_cdev);
+			mutex_unlock(&led_cdev->led_lock);
+
+			/* Stop flash strobing */
+			ret = led_set_flash_strobe(led_cdev, false);
+			if (ret)
+				return ret;
+			/* torch is always triggered by software */
+			ret = led_set_hw_triggered(led_cdev, false);
+			if (ret)
+				return ret;
+
+			led_set_brightness(led_cdev, flash->torch_intensity);
+			return ret;
+		}
+		break;
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		return led_set_hw_triggered(led_cdev,
+				c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+	case V4L2_CID_FLASH_STROBE:
+		if (flash->ctrl.led_mode->val != V4L2_FLASH_LED_MODE_FLASH ||
+		   flash->ctrl.source->val != V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
+			return -EINVAL;
+		return led_set_flash_strobe(led_cdev, true);
+	case V4L2_CID_FLASH_STROBE_STOP:
+		return led_set_flash_strobe(led_cdev, false);
+	case V4L2_CID_FLASH_TIMEOUT:
+		return led_set_flash_timeout(led_cdev,
+						(unsigned long *) &c->val);
+	case V4L2_CID_FLASH_INTENSITY:
+		return led_set_flash_brightness(led_cdev, c->val);
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		flash->torch_intensity = c->val;
+		if (flash->ctrl.led_mode->val == V4L2_FLASH_LED_MODE_TORCH)
+			led_set_brightness(led_cdev, flash->torch_intensity);
+		return 0;
+	}
+
+	return -EINVAL;
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
+	int ret, max, num_ctrls;
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
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+	if (has_flash) {
+		/* Configure FLASH_LED_MODE ctrl */
+		flash->ctrl.led_mode = v4l2_ctrl_new_std_menu(&flash->hdl,
+				&v4l2_flash_ctrl_ops, V4L2_CID_FLASH_LED_MODE,
+				V4L2_FLASH_LED_MODE_TORCH, ~mask,
+				V4L2_FLASH_LED_MODE_NONE);
+
+		/* Configure FLASH_STROBE_SOURCE ctrl */
+		mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+
+		if (config->flags & V4L2_FLASH_CFG_STROBE_SOURCE_EXTERNAL) {
+			mask |= 1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+			max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+		} else {
+			max = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+		}
+
+		flash->ctrl.source = v4l2_ctrl_new_std_menu(&flash->hdl,
+					&v4l2_flash_ctrl_ops,
+					V4L2_CID_FLASH_STROBE_SOURCE,
+					max,
+					~mask,
+					V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
+
+		/* Configure FLASH_STROBE ctrl */
+		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
+					  V4L2_CID_FLASH_STROBE, 0, 1, 1, 0);
+
+		/* Configure FLASH_STROBE_STOP ctrl */
+		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
+					  V4L2_CID_FLASH_STROBE_STOP,
+					  0, 1, 1, 0);
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
+		if (ctrl)
+			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+		if (config->flags & V4L2_FLASH_CFG_FAULTS_MASK) {
+			/* Configure FLASH_FAULT ctrl */
+			ctrl = v4l2_ctrl_new_std(&flash->hdl,
+						 &v4l2_flash_ctrl_ops,
+						 V4L2_CID_FLASH_FAULT, 0,
+						 config->flags &
+						 V4L2_FLASH_CFG_FAULTS_MASK,
+						 0, 0);
+			if (ctrl)
+				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
+					       V4L2_CTRL_FLAG_READ_ONLY;
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
+	v4l2_ctrl_handler_free(flash->subdev.ctrl_handler);
+	v4l2_async_unregister_subdev(&flash->subdev);
+	media_entity_cleanup(&flash->subdev.entity);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_release);
diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
new file mode 100644
index 0000000..457ed15
--- /dev/null
+++ b/include/media/v4l2-flash.h
@@ -0,0 +1,104 @@
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
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-event.h>
+#include <linux/leds_flash.h>
+#include <media/v4l2-ioctl.h>
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
+#define V4L2_FLASH_CFG_FAULT_UNDER_VOLTAGE	(1 << 6)
+#define V4L2_FLASH_CFG_FAULT_INPUT_VOLTAGE	(1 << 7)
+#define V4L2_FLASH_CFG_FAULT_LED_OVER_TEMPERATURE (1 << 8)
+#define V4L2_FLASH_CFG_FAULTS_MASK		0x1ff
+#define V4L2_FLASH_CFG_LED_FLASH		(1 << 9)
+#define V4L2_FLASH_CFG_LED_TORCH		(1 << 10)
+#define V4L2_FLASH_CFG_STROBE_SOURCE_EXTERNAL	(1 << 11)
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
+	unsigned int torch_intensity;
+};
+
+struct v4l2_flash_ctrl_config {
+	struct v4l2_ctrl_config flash_timeout;
+	struct v4l2_ctrl_config flash_intensity;
+	struct v4l2_ctrl_config torch_intensity;
+	unsigned int flags;
+};
+
+static inline struct v4l2_flash *v4l2_subdev_to_flash(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct v4l2_flash, subdev);
+}
+
+static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
+{
+	return container_of(c->handler, struct v4l2_flash, hdl);
+}
+
+#ifdef CONFIG_V4L2_FLASH
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
+#endif /* CONFIG_V4L2_FLASH */
+
+#endif /* _V4L2_FLASH_H */
-- 
1.7.9.5

