Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaHTNoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:44:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25541 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaHTNna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:43:30 -0400
X-AuditID: cbfee61b-f79f86d00000144c-30-53f4a600e6de
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v5 2/3] media: Add registration helpers for V4L2 flash
Date: Wed, 20 Aug 2014 15:43:10 +0200
Message-id: <1408542191-335-3-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542191-335-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542191-335-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jAV2GZV+CDXbOErXYOGM9q8XRnROZ
	LOYfOcdqseTnLiaL3qvPGS3ONr1ht7i8aw6bxdY36xgtejZsZbXYvespq8WZ/SvZHLg9pvze
	yOqxc9Zddo/DXxeyeOyZ/4PVo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDL+L9zIVtBxmbHi
	yLODjA2MizcwdjFyckgImEjM+HKXDcIWk7hwbz2QzcUhJLCIUeLEk+8sEE47k8SvGcdZQarY
	BAwlfr54zQRiiwiUS/S8fwbWzSzwg1FixkFJEFtYwEvi/o7HQDUcHCwCqhIvz5iChHkF3CQu
	9C1lAwlLCChIzJlkAxLmFHCX2H5uPjuILQRUsm9iG9MERt4FjAyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYID8Zn0DsZVDRaHGAU4GJV4eG8s+hIsxJpYVlyZe4hRgoNZSYS3vRMoxJuS
	WFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgXHrlS2p0w398r+0
	i//xFfC2T+W9O507LTlEyfyLxy6nyG+TfeTd93Im/3n+/FPsOx/dHeus7MoTP802bNB09f6m
	G7Oe+8QhnZDy1aYnotrPTc1PN0++Yl94eop18q5Th7W4TTbU3Anvk/j3Lu3GEVbpnrT/1v+/
	TzzIfnvb0pynT+8vOSlXME2JpTgj0VCLuag4EQBV/ydmQAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds helper functions for registering/unregistering
LED class flash devices as V4L2 subdevs. The functions should
be called from the LED subsystem device driver. In case the
support for V4L2 Flash sub-devices is disabled in the kernel
config the functions' empty versions will be used.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class-flash.c       |   25 ++
 drivers/media/v4l2-core/Kconfig      |   11 +
 drivers/media/v4l2-core/Makefile     |    2 +
 drivers/media/v4l2-core/v4l2-flash.c |  577 ++++++++++++++++++++++++++++++++++
 include/linux/led-class-flash.h      |   11 +
 include/media/v4l2-flash.h           |  121 +++++++
 6 files changed, 747 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/media/v4l2-flash.h

diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
index 4ff99a9..a73f5fd 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -16,6 +16,7 @@
 #include <linux/led-flash-manager.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <media/v4l2-flash.h>
 #include "leds.h"
 
 #define has_flash_op(flash, op)				\
@@ -355,6 +356,30 @@ static void led_flash_resume(struct led_classdev *led_cdev)
 				flash->indicator_brightness->val);
 }
 
+#ifdef CONFIG_V4L2_FLASH_LED_CLASS
+const struct v4l2_flash_ops led_flash_v4l2_ops = {
+	.torch_brightness_set = led_set_torch_brightness,
+	.torch_brightness_update = led_update_brightness,
+	.flash_brightness_set = led_set_flash_brightness,
+	.flash_brightness_update = led_update_flash_brightness,
+	.indicator_brightness_set = led_set_indicator_brightness,
+	.indicator_brightness_update = led_update_indicator_brightness,
+	.strobe_set = led_set_flash_strobe,
+	.strobe_get = led_get_flash_strobe,
+	.timeout_set = led_set_flash_timeout,
+	.external_strobe_set = led_set_external_strobe,
+	.fault_get = led_get_flash_fault,
+	.sysfs_lock = led_sysfs_lock,
+	.sysfs_unlock = led_sysfs_unlock,
+};
+
+const struct v4l2_flash_ops *led_get_v4l2_flash_ops(void)
+{
+	return &led_flash_v4l2_ops;
+}
+EXPORT_SYMBOL_GPL(led_get_v4l2_flash_ops);
+#endif
+
 static void led_flash_remove_sysfs_groups(struct led_classdev_flash *flash)
 {
 	struct led_classdev *led_cdev = &flash->led_cdev;
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 9ca0f8d..3ae3f0f 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -35,6 +35,17 @@ config V4L2_MEM2MEM_DEV
         tristate
         depends on VIDEOBUF2_CORE
 
+# Used by LED subsystem flash drivers
+config V4L2_FLASH_LED_CLASS
+	bool "Enable support for Flash sub-devices"
+	depends on VIDEO_V4L2_SUBDEV_API
+	depends on LEDS_CLASS_FLASH
+	---help---
+	  Say Y here to enable support for Flash sub-devices, which allow
+	  to control LED class devices with use of V4L2 Flash controls.
+
+	  When in doubt, say N.
+
 # Used by drivers that need Videobuf modules
 config VIDEOBUF_GEN
 	tristate
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 63d29f2..44e858c 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -22,6 +22,8 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
+obj-$(CONFIG_V4L2_FLASH_LED_CLASS) += v4l2-flash.o
+
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
 obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
new file mode 100644
index 0000000..51e7238
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-flash.c
@@ -0,0 +1,577 @@
+/*
+ * V4L2 Flash LED sub-device registration helpers.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#include <linux/led-class-flash.h>
+#include <linux/mutex.h>
+#include <linux/of_led_flash_manager.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <media/v4l2-flash.h>
+
+#define call_flash_op(v4l2_flash, op, args...)			\
+		(v4l2_flash->ops->op  ?				\
+			v4l2_flash->ops->op(args) :		\
+			-EINVAL)
+
+enum ctrl_init_data_id {
+	LED_MODE,
+	TORCH_INTENSITY,
+	STROBE_SOURCE,
+	FLASH_STROBE,
+	STROBE_STOP,
+	STROBE_STATUS,
+	FLASH_TIMEOUT,
+	FLASH_INTENSITY,
+	INDICATOR_INTENSITY,
+	FLASH_FAULT,
+	NUM_FLASH_CTRLS,
+};
+
+struct v4l2_flash_ctrl_data {
+	struct v4l2_ctrl_config config;
+	bool supported;
+};
+
+static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
+					struct v4l2_ctrl *ctrl,
+					s32 intensity)
+{
+	s64 __intensity = intensity - ctrl->minimum;
+
+	do_div(__intensity, ctrl->step);
+
+	return __intensity + 1;
+}
+
+static inline s32 v4l2_flash_led_brightness_to_intensity(
+					struct v4l2_ctrl *ctrl,
+					enum led_brightness brightness)
+{
+	return ((brightness - 1) * ctrl->step) + ctrl->minimum;
+}
+
+static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
+
+{
+	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
+	bool is_strobing;
+	int ret;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		/*
+		 * Update torch brightness only if in TORCH_MODE,
+		 * as otherwise brightness_update op returns 0,
+		 * which would spuriously inform user space that
+		 * V4L2_CID_FLASH_TORCH_INTENSITY control value
+		 * has changed.
+		 */
+		if (ctrls[LED_MODE]->val == V4L2_FLASH_LED_MODE_TORCH) {
+			ret = call_flash_op(v4l2_flash, torch_brightness_update,
+							led_cdev);
+			if (ret < 0)
+				return ret;
+			ctrls[TORCH_INTENSITY]->val =
+				v4l2_flash_led_brightness_to_intensity(
+						ctrls[TORCH_INTENSITY],
+						led_cdev->brightness);
+		}
+		return 0;
+	case V4L2_CID_FLASH_INTENSITY:
+		ret = call_flash_op(v4l2_flash, flash_brightness_update,
+					flash);
+		if (ret < 0)
+			return ret;
+		/* no conversion is needed */
+		c->val = flash->brightness.val;
+		return 0;
+	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
+		ret = call_flash_op(v4l2_flash, indicator_brightness_update,
+						flash);
+		if (ret < 0)
+			return ret;
+		/* no conversion is needed */
+		c->val = flash->indicator_brightness->val;
+		return 0;
+	case V4L2_CID_FLASH_STROBE_STATUS:
+		ret = call_flash_op(v4l2_flash, strobe_get, flash,
+							&is_strobing);
+		if (ret < 0)
+			return ret;
+		c->val = is_strobing;
+		return 0;
+	case V4L2_CID_FLASH_FAULT:
+		/* led faults map directly to V4L2 flash faults */
+		ret = call_flash_op(v4l2_flash, fault_get, flash, &c->val);
+		return ret;
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		c->val = flash->external_strobe;
+		return 0;
+	case V4L2_CID_FLASH_STROBE_PROVIDER:
+		c->val = flash->strobe_provider_id;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
+	enum led_brightness torch_brightness;
+	bool external_strobe;
+	int ret = 0;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_LED_MODE:
+		switch (c->val) {
+		case V4L2_FLASH_LED_MODE_NONE:
+			call_flash_op(v4l2_flash, torch_brightness_set,
+							&flash->led_cdev, 0);
+			return call_flash_op(v4l2_flash, strobe_set, flash,
+							false);
+		case V4L2_FLASH_LED_MODE_FLASH:
+			/* Turn off torch LED */
+			call_flash_op(v4l2_flash, torch_brightness_set,
+							&flash->led_cdev, 0);
+			external_strobe = (ctrls[STROBE_SOURCE]->val ==
+					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+			return call_flash_op(v4l2_flash, external_strobe_set,
+						flash, external_strobe);
+		case V4L2_FLASH_LED_MODE_TORCH:
+			/* Stop flash strobing */
+			ret = call_flash_op(v4l2_flash, strobe_set, flash,
+							false);
+			if (ret)
+				return ret;
+
+			torch_brightness =
+				v4l2_flash_intensity_to_led_brightness(
+						ctrls[TORCH_INTENSITY],
+						ctrls[TORCH_INTENSITY]->val);
+			call_flash_op(v4l2_flash, torch_brightness_set,
+					&flash->led_cdev, torch_brightness);
+			return ret;
+		}
+		break;
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		external_strobe = (c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+
+		return call_flash_op(v4l2_flash, external_strobe_set, flash,
+							external_strobe);
+	case V4L2_CID_FLASH_STROBE:
+		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_FLASH ||
+		    ctrls[STROBE_SOURCE]->val !=
+					V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
+			return -EINVAL;
+		return call_flash_op(v4l2_flash, strobe_set, flash, true);
+	case V4L2_CID_FLASH_STROBE_STOP:
+		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_FLASH ||
+		    flash->external_strobe)
+			return -EINVAL;
+		return call_flash_op(v4l2_flash, strobe_set, flash, false);
+	case V4L2_CID_FLASH_TIMEOUT:
+		return call_flash_op(v4l2_flash, timeout_set, flash, c->val);
+	case V4L2_CID_FLASH_INTENSITY:
+		/* no conversion is needed */
+		return call_flash_op(v4l2_flash, flash_brightness_set, flash,
+								c->val);
+	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
+		/* no conversion is needed */
+		return call_flash_op(v4l2_flash, indicator_brightness_set,
+						flash, c->val);
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		/*
+		 * If not in MODE_TORCH don't call led-class brightness_set
+		 * op, as it would result in turning the torch led on.
+		 * Instead the value is cached only and will be written
+		 * to the device upon transition to MODE_TORCH.
+		 */
+		if (ctrls[LED_MODE]->val == V4L2_FLASH_LED_MODE_TORCH) {
+			torch_brightness =
+				v4l2_flash_intensity_to_led_brightness(
+							ctrls[TORCH_INTENSITY],
+							c->val);
+			call_flash_op(v4l2_flash, torch_brightness_set,
+					&flash->led_cdev, torch_brightness);
+		}
+		return 0;
+	case V4L2_CID_FLASH_STROBE_PROVIDER:
+		flash->strobe_provider_id = c->val;
+		if (ctrls[LED_MODE]->val == V4L2_FLASH_LED_MODE_FLASH &&
+		    ctrls[STROBE_SOURCE]->val ==
+					V4L2_FLASH_STROBE_SOURCE_EXTERNAL)
+			ret = call_flash_op(v4l2_flash, external_strobe_set,
+						flash, true);
+		return ret;
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
+static int v4l2_flash_init_strobe_providers_menu(struct v4l2_flash *v4l2_flash)
+{
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	struct led_flash_strobe_provider *provider;
+	struct v4l2_ctrl *ctrl;
+	int i = 0;
+
+	v4l2_flash->strobe_providers_menu =
+			kcalloc((flash->num_strobe_providers), sizeof(char *),
+					GFP_KERNEL);
+	if (!v4l2_flash->strobe_providers_menu)
+		return -ENOMEM;
+
+	list_for_each_entry(provider, &flash->strobe_providers, list)
+		v4l2_flash->strobe_providers_menu[i++] =
+						(char *) provider->name;
+
+	ctrl = v4l2_ctrl_new_std_menu_items(
+		&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
+		V4L2_CID_FLASH_STROBE_PROVIDER,
+		flash->num_strobe_providers - 1,
+		0, 0,
+		(const char * const *) v4l2_flash->strobe_providers_menu);
+
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+	return 0;
+}
+
+static void fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
+			  struct v4l2_flash_ctrl_config *flash_cfg,
+			  struct v4l2_flash_ctrl_data *ctrl_init_data)
+{
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	const struct led_flash_ops *flash_ops = flash->ops;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct v4l2_ctrl_config *ctrl_cfg;
+	u32 mask;
+	s64 max;
+
+	/* Init FLASH_LED_MODE ctrl data */
+	mask = 1 << V4L2_FLASH_LED_MODE_NONE |
+	       1 << V4L2_FLASH_LED_MODE_TORCH;
+	if (flash)
+		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
+
+	ctrl_init_data[LED_MODE].supported = true;
+	ctrl_cfg = &ctrl_init_data[LED_MODE].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_LED_MODE;
+	ctrl_cfg->max = V4L2_FLASH_LED_MODE_TORCH;
+	ctrl_cfg->menu_skip_mask = ~mask;
+	ctrl_cfg->def = V4L2_FLASH_LED_MODE_NONE;
+	ctrl_cfg->flags = 0;
+
+	/* Init TORCH_INTENSITY ctrl data */
+	ctrl_init_data[TORCH_INTENSITY].supported = true;
+	ctrl_init_data[TORCH_INTENSITY].config = flash_cfg->torch_intensity;
+	ctrl_cfg = &ctrl_init_data[TORCH_INTENSITY].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_TORCH_INTENSITY;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
+
+	if (!(led_cdev->flags & LED_DEV_CAP_FLASH))
+		return;
+
+	/* Init FLASH_STROBE_SOURCE ctrl data */
+	mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+	if (flash->has_external_strobe) {
+		mask |= 1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+		max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+	} else {
+		max = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+	}
+
+	ctrl_init_data[STROBE_SOURCE].supported = true;
+	ctrl_cfg = &ctrl_init_data[STROBE_SOURCE].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE_SOURCE;
+	ctrl_cfg->max = max;
+	ctrl_cfg->menu_skip_mask = ~mask;
+	ctrl_cfg->def = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
+
+	/* Init FLASH_STROBE ctrl data */
+	ctrl_init_data[FLASH_STROBE].supported = true;
+	ctrl_cfg = &ctrl_init_data[FLASH_STROBE].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE;
+	ctrl_cfg->min = 0;
+	ctrl_cfg->max = 1;
+	ctrl_cfg->step = 1;
+	ctrl_cfg->def = 0;
+	ctrl_cfg->flags = 0;
+
+	/* Init STROBE_STOP ctrl data */
+	ctrl_init_data[STROBE_STOP].supported = true;
+	ctrl_cfg = &ctrl_init_data[STROBE_STOP].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE_STOP;
+	ctrl_cfg->min = 0;
+	ctrl_cfg->max = 1;
+	ctrl_cfg->step = 1;
+	ctrl_cfg->def = 0;
+	ctrl_cfg->flags = 0;
+
+	/* Init STROBE_STATUS ctrl data */
+	ctrl_init_data[STROBE_STATUS].supported = !!flash_ops->strobe_get;
+	ctrl_cfg = &ctrl_init_data[STROBE_STATUS].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE_STATUS;
+	ctrl_cfg->min = 0;
+	ctrl_cfg->max = 1;
+	ctrl_cfg->step = 1;
+	ctrl_cfg->def = 1;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
+			   V4L2_CTRL_FLAG_READ_ONLY;
+
+	/* Init FLASH_TIMEOUT ctrl data */
+	ctrl_init_data[FLASH_TIMEOUT].supported = !!flash_ops->timeout_set;
+	ctrl_init_data[FLASH_TIMEOUT].config = flash_cfg->flash_timeout;
+	ctrl_cfg = &ctrl_init_data[FLASH_TIMEOUT].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_TIMEOUT;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
+
+	/* Init FLASH_INTENSITY ctrl data */
+	ctrl_init_data[FLASH_INTENSITY].supported =
+					!!flash_ops->flash_brightness_set;
+	ctrl_init_data[FLASH_INTENSITY].config = flash_cfg->flash_intensity;
+	ctrl_cfg = &ctrl_init_data[FLASH_INTENSITY].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_INTENSITY;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
+
+	/* Init INDICATOR_INTENSITY ctrl data */
+	ctrl_init_data[INDICATOR_INTENSITY].supported =
+					led_cdev->flags & LED_DEV_CAP_INDICATOR;
+	ctrl_init_data[INDICATOR_INTENSITY].config = flash_cfg->flash_intensity;
+	ctrl_cfg = &ctrl_init_data[INDICATOR_INTENSITY].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_INDICATOR_INTENSITY;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
+
+	/* Init FLASH_FAULT ctrl data */
+	ctrl_init_data[FLASH_FAULT].supported = !!flash_cfg->flash_faults;
+	ctrl_cfg = &ctrl_init_data[FLASH_FAULT].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_FAULT;
+	ctrl_cfg->min = 0;
+	ctrl_cfg->max = flash_cfg->flash_faults;
+	ctrl_cfg->step = 0;
+	ctrl_cfg->def = 0;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE | V4L2_CTRL_FLAG_READ_ONLY;
+}
+
+static int v4l2_flash_init_controls(struct v4l2_flash *v4l2_flash,
+				struct v4l2_flash_ctrl_config *flash_cfg)
+
+{
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	bool has_strobe_providers = (flash->num_strobe_providers > 1);
+	struct v4l2_flash_ctrl_data *ctrl_init_data;
+	struct v4l2_ctrl *ctrl;
+	struct v4l2_ctrl_config *ctrl_cfg;
+	int i, ret, num_ctrls = 0;
+
+	/* allocate memory dynamically so as not to exceed stack frame size */
+	ctrl_init_data = kcalloc(NUM_FLASH_CTRLS, sizeof(*ctrl_init_data),
+					GFP_KERNEL);
+	if (!ctrl_init_data)
+		return -ENOMEM;
+
+	memset(ctrl_init_data, 0, sizeof(*ctrl_init_data));
+
+	fill_ctrl_init_data(v4l2_flash, flash_cfg, ctrl_init_data);
+
+	for (i = 0; i < NUM_FLASH_CTRLS; ++i)
+		if (ctrl_init_data[i].supported)
+			++num_ctrls;
+
+	if (has_strobe_providers)
+		++num_ctrls;
+
+	v4l2_ctrl_handler_init(&v4l2_flash->hdl, num_ctrls);
+
+	for (i = 0; i < NUM_FLASH_CTRLS; ++i) {
+		ctrl_cfg = &ctrl_init_data[i].config;
+		if (!ctrl_init_data[i].supported)
+			continue;
+
+		if (ctrl_cfg->id == V4L2_CID_FLASH_LED_MODE ||
+		    ctrl_cfg->id == V4L2_CID_FLASH_STROBE_SOURCE)
+			ctrl = v4l2_ctrl_new_std_menu(&v4l2_flash->hdl,
+						&v4l2_flash_ctrl_ops,
+						ctrl_cfg->id,
+						ctrl_cfg->max,
+						ctrl_cfg->menu_skip_mask,
+						ctrl_cfg->def);
+		else
+			ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl,
+						&v4l2_flash_ctrl_ops,
+						ctrl_cfg->id,
+						ctrl_cfg->min,
+						ctrl_cfg->max,
+						ctrl_cfg->step,
+						ctrl_cfg->def);
+
+		if (ctrl)
+			ctrl->flags |= ctrl_cfg->flags;
+
+		if (i <= STROBE_SOURCE)
+			v4l2_flash->ctrls[i] = ctrl;
+	}
+
+	kfree(ctrl_init_data);
+
+	if (has_strobe_providers) {
+		/* Configure V4L2_CID_FLASH_STROBE_PROVIDERS ctrl */
+		ret = v4l2_flash_init_strobe_providers_menu(v4l2_flash);
+		if (ret < 0)
+			goto error_free_handler;
+	}
+
+	if (v4l2_flash->hdl.error) {
+		ret = v4l2_flash->hdl.error;
+		goto error_free_handler;
+	}
+
+	v4l2_ctrl_handler_setup(&v4l2_flash->hdl);
+
+	v4l2_flash->sd.ctrl_handler = &v4l2_flash->hdl;
+
+	return 0;
+
+error_free_handler:
+	v4l2_ctrl_handler_free(&v4l2_flash->hdl);
+	return ret;
+}
+
+/*
+ * V4L2 subdev internal operations
+ */
+
+static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int ret = 0;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (!v4l2_fh_is_singular(&fh->vfh)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	call_flash_op(v4l2_flash, sysfs_lock, led_cdev);
+
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+
+	mutex_lock(&led_cdev->led_lock);
+	call_flash_op(v4l2_flash, sysfs_unlock, led_cdev);
+	mutex_unlock(&led_cdev->led_lock);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
+	.open = v4l2_flash_open,
+	.close = v4l2_flash_close,
+};
+
+static const struct v4l2_subdev_core_ops v4l2_flash_core_ops = {
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
+};
+
+static const struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
+	.core = &v4l2_flash_core_ops,
+};
+
+struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *flash,
+				   struct v4l2_flash_ctrl_config *config,
+				   const struct v4l2_flash_ops *flash_ops)
+{
+	struct v4l2_flash *v4l2_flash;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (!flash || !config)
+		return ERR_PTR(-EINVAL);
+
+	v4l2_flash = kzalloc(sizeof(*v4l2_flash), GFP_KERNEL);
+	if (!v4l2_flash)
+		return ERR_PTR(-ENOMEM);
+
+	sd = &v4l2_flash->sd;
+	v4l2_flash->flash = flash;
+	v4l2_flash->ops = flash_ops;
+	sd->dev = led_cdev->dev->parent;
+	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
+	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), led_cdev->name);
+
+	ret = v4l2_flash_init_controls(v4l2_flash, config);
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
+	return v4l2_flash;
+
+err_init_entity:
+	media_entity_cleanup(&sd->entity);
+err_init_controls:
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	kfree(v4l2_flash);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_init);
+
+void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
+{
+	struct v4l2_subdev *sd = &v4l2_flash->sd;
+
+	if (!v4l2_flash)
+		return;
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	kfree(v4l2_flash->strobe_providers_menu);
+	kfree(v4l2_flash);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_release);
diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
index a882263..40bc8ad 100644
--- a/include/linux/led-class-flash.h
+++ b/include/linux/led-class-flash.h
@@ -14,6 +14,7 @@
 
 #include <linux/leds.h>
 
+struct v4l2_flash_ops;
 struct led_classdev_flash;
 struct device_node;
 
@@ -269,5 +270,15 @@ extern int led_set_indicator_brightness(struct led_classdev_flash *flash,
  */
 extern int led_update_indicator_brightness(struct led_classdev_flash *flash);
 
+#ifdef CONFIG_V4L2_FLASH_LED_CLASS
+/**
+ * led_get_v4l2_flash_ops - get ops for controlling LED Flash Class
+			    device with use of V4L2 Flash controls
+ * Returns: v4l2_flash_ops
+ */
+const struct v4l2_flash_ops *led_get_v4l2_flash_ops(void);
+#else
+#define led_get_v4l2_flash_ops() (0)
+#endif
 
 #endif	/* __LINUX_FLASH_LEDS_H_INCLUDED */
diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
new file mode 100644
index 0000000..6612467
--- /dev/null
+++ b/include/media/v4l2-flash.h
@@ -0,0 +1,121 @@
+/*
+ * V4L2 Flash LED sub-device registration helpers.
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
+#include <media/v4l2-ioctl.h>
+
+struct led_classdev_flash;
+struct led_classdev;
+enum led_brightness;
+
+struct v4l2_flash_ops {
+	int (*torch_brightness_set)(struct led_classdev *led_cdev,
+					enum led_brightness brightness);
+	int (*torch_brightness_update)(struct led_classdev *led_cdev);
+	int (*flash_brightness_set)(struct led_classdev_flash *flash,
+					u32 brightness);
+	int (*flash_brightness_update)(struct led_classdev_flash *flash);
+	int (*strobe_set)(struct led_classdev_flash *flash, bool state);
+	int (*strobe_get)(struct led_classdev_flash *flash, bool *state);
+	int (*timeout_set)(struct led_classdev_flash *flash, u32 timeout);
+	int (*indicator_brightness_set)(struct led_classdev_flash *flash,
+					u32 brightness);
+	int (*indicator_brightness_update)(struct led_classdev_flash *flash);
+	int (*external_strobe_set)(struct led_classdev_flash *flash,
+					bool enable);
+	int (*fault_get)(struct led_classdev_flash *flash, u32 *fault);
+	void (*sysfs_lock)(struct led_classdev *led_cdev);
+	void (*sysfs_unlock)(struct led_classdev *led_cdev);
+};
+
+/**
+ * struct v4l2_flash_ctrl_config - V4L2 Flash controls initialization data
+ * @torch_intensity:		V4L2_CID_FLASH_TORCH_INTENSITY constraints
+ * @flash_intensity:		V4L2_CID_FLASH_INTENSITY constraints
+ * @indicator_intensity:	V4L2_CID_FLASH_INDICATOR_INTENSITY constraints
+ * @flash_timeout:		V4L2_CID_FLASH_TIMEOUT constraints
+ * @flash_fault:		possible flash faults
+ */
+struct v4l2_flash_ctrl_config {
+	struct v4l2_ctrl_config torch_intensity;
+	struct v4l2_ctrl_config flash_intensity;
+	struct v4l2_ctrl_config indicator_intensity;
+	struct v4l2_ctrl_config flash_timeout;
+	u32 flash_faults;
+};
+
+/**
+ * struct v4l2_flash - Flash sub-device context
+ * @flash:		LED Flash Class device controlled by this sub-device
+ * @ops:		LED Flash Class device ops
+ * @sd:			V4L2 sub-device
+ * @hdl:		flash controls handler
+ * @ctrls:		state defining controls
+ * @strobe_providers_menu: available external strobe sources
+ */
+struct v4l2_flash {
+	struct led_classdev_flash *flash;
+	const struct v4l2_flash_ops *ops;
+
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *ctrls[3];
+	char **strobe_providers_menu;
+};
+
+static inline struct v4l2_flash *v4l2_subdev_to_v4l2_flash(
+							struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct v4l2_flash, sd);
+}
+
+static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
+{
+	return container_of(c->handler, struct v4l2_flash, hdl);
+}
+
+#ifdef CONFIG_V4L2_FLASH_LED_CLASS
+/**
+ * v4l2_flash_init - initialize V4L2 flash led sub-device
+ * @led_fdev:	the LED Flash Class device to wrap
+ * @config:	initialization data for V4L2 Flash controls
+ * @flash_ops:	V4L2 Flash device ops
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+
+ * Returns: A valid pointer, or, when an error occurs, the return
+ * value is encoded using ERR_PTR(). Use IS_ERR() to check and
+ * PTR_ERR() to obtain the numeric return value.
+ */
+struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *led_fdev,
+				   struct v4l2_flash_ctrl_config *config,
+				   const struct v4l2_flash_ops *flash_ops);
+
+/**
+ * v4l2_flash_release - release V4L2 Flash sub-device
+ * @flash: the V4L2 Flash device to release
+ *
+ * Release V4L2 flash led subdev.
+ */
+void v4l2_flash_release(struct v4l2_flash *v4l2_flash);
+
+#else
+#define v4l2_flash_init(led_cdev, config, flash_ops) (0)
+#define v4l2_flash_release(v4l2_flash)
+#endif /* CONFIG_V4L2_FLASH_LED_CLASS */
+
+#endif /* _V4L2_FLASH_H */
-- 
1.7.9.5

