Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaHDEuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:50:05 -0400
Received: from regular2.263xmail.com ([211.157.152.4]:33814 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaHDEuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:50:01 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: yzq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: yzq@rock-chips.com
X-UNIQUE-TAG: <e66d75cda23db93efa26deb6f29c5613>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: mark yao <yzq@rock-chips.com>
To: heiko@sntech.de, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, olof@lixom.net, djkurtz@chromium.org,
        xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com,
        cf@rock-chips.com, zyw@rock-chips.com, zwl@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        zhangqing@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, mark yao <yzq@rock-chips.com>
Subject: [PATCH 3/9] drm: add driver for panels used by the Rockchip DRM
Date: Mon,  4 Aug 2014 12:48:37 +0800
Message-Id: <1407127718-1692-1-git-send-email-yzq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: mark yao <yzq@rock-chips.com>
---
 drivers/gpu/drm/rockchip/Makefile         |    3 +-
 drivers/gpu/drm/rockchip/rockchip_panel.c |  297 +++++++++++++++++++++++++++++
 2 files changed, 299 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_panel.c

diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
index 45c9d50..a5e5132 100644
--- a/drivers/gpu/drm/rockchip/Makefile
+++ b/drivers/gpu/drm/rockchip/Makefile
@@ -5,7 +5,8 @@
 ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip
 
 rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_gem.o \
-		rockchip_drm_fb.o rockchip_drm_fbdev.o
+		rockchip_drm_fb.o rockchip_drm_fbdev.o \
+		rockchip_panel.o
 
 obj-$(CONFIG_DRM_ROCKCHIP_CONNECTOR) += rockchip_drm_connector.o
 obj-$(CONFIG_DRM_ROCKCHIP_LCDC) += rockchip_drm_lcdc.o
diff --git a/drivers/gpu/drm/rockchip/rockchip_panel.c b/drivers/gpu/drm/rockchip/rockchip_panel.c
new file mode 100644
index 0000000..87401a2
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_panel.c
@@ -0,0 +1,297 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on panel-simple.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <video/of_videomode.h>
+#include <video/videomode.h>
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_panel.h>
+
+#include "rockchip_drm_drv.h"
+
+/* TODO: convert to gpiod_*() API once it's been merged */
+#define GPIO_ACTIVE_LOW	(1 << 0)
+
+struct pwr_gpio {
+	struct list_head head;
+	unsigned long enable_gpio_flags;
+	int enable_gpio;
+};
+
+struct rockchip_panel {
+	struct drm_panel base;
+	bool enabled;
+
+	struct drm_display_mode mode;
+	struct rockchip_panel_special priv;
+
+	struct list_head pwrlist;
+};
+
+static inline struct rockchip_panel *to_rockchip_panel(struct drm_panel *panel)
+{
+	return container_of(panel, struct rockchip_panel, base);
+}
+
+static int rockchip_panel_disable(struct drm_panel *panel)
+{
+	struct rockchip_panel *p = to_rockchip_panel(panel);
+	struct pwr_gpio *pwr;
+	struct list_head *pos;
+
+	if (!p->enabled)
+		return 0;
+
+	list_for_each(pos, &p->pwrlist) {
+		pwr = list_entry(pos, struct pwr_gpio, head);
+		if (gpio_is_valid(pwr->enable_gpio)) {
+			if (pwr->enable_gpio_flags & GPIO_ACTIVE_LOW)
+				gpio_set_value(pwr->enable_gpio, 1);
+			else
+				gpio_set_value(pwr->enable_gpio, 0);
+		}
+	}
+
+	p->enabled = false;
+
+	return 0;
+}
+
+static int rockchip_panel_enable(struct drm_panel *panel)
+{
+	struct rockchip_panel *p = to_rockchip_panel(panel);
+	struct pwr_gpio *pwr;
+	struct list_head *pos;
+
+	if (p->enabled)
+		return 0;
+
+	list_for_each(pos, &p->pwrlist) {
+		pwr = list_entry(pos, struct pwr_gpio, head);
+		if (gpio_is_valid(pwr->enable_gpio)) {
+			if (pwr->enable_gpio_flags & GPIO_ACTIVE_LOW)
+				gpio_set_value(pwr->enable_gpio, 0);
+			else
+				gpio_set_value(pwr->enable_gpio, 1);
+		}
+	}
+
+	p->enabled = true;
+
+	return 0;
+}
+
+static int rockchip_panel_get_modes(struct drm_panel *panel)
+{
+	struct rockchip_panel *p = to_rockchip_panel(panel);
+	struct drm_device *drm = panel->drm;
+	struct drm_connector *connector = panel->connector;
+	const struct drm_display_mode *m = &p->mode;
+	struct drm_display_mode *mode;
+
+	mode = drm_mode_duplicate(drm, m);
+	if (!mode) {
+		dev_err(drm->dev, "failed to add mode %ux%u@%u\n",
+			m->hdisplay, m->vdisplay, m->vrefresh);
+		return 0;
+	}
+
+	drm_mode_set_name(mode);
+	drm_mode_probed_add(connector, mode);
+
+	return 1;
+}
+
+static const struct drm_panel_funcs rockchip_panel_funcs = {
+	.disable = rockchip_panel_disable,
+	.enable = rockchip_panel_enable,
+	.get_modes = rockchip_panel_get_modes,
+};
+
+static int rockchip_name_to_face(const char *s)
+{
+	if (!s)
+		return 0;
+
+	if (strncmp(s, "r8g8b8", 6) == 0)
+		return ROCKCHIP_OUTFACE_P888;
+	else if (strncmp(s, "r6g6b6", 6) == 0)
+		return ROCKCHIP_OUTFACE_P666;
+	else if (strncmp(s, "r5g6b5", 6) == 0)
+		return ROCKCHIP_OUTFACE_P565;
+
+	DRM_ERROR("unsupport display output face[%s]\n", s);
+
+	return 0;
+}
+
+static int rockchip_panel_probe(struct platform_device *pdev)
+{
+	struct rockchip_panel *panel;
+	struct device *dev = &pdev->dev;
+	struct rockchip_panel_special *priv;
+	struct device_node *dn = dev->of_node;
+	struct device_node *np;
+	enum of_gpio_flags flags;
+	struct videomode vm;
+	const char *name;
+	struct pwr_gpio *pwr;
+	struct list_head *pos;
+	int value;
+	int err, i;
+	int num_gpio;
+
+	panel = devm_kzalloc(dev, sizeof(*panel), GFP_KERNEL);
+	if (!panel)
+		return -ENOMEM;
+
+	priv = &panel->priv;
+
+	INIT_LIST_HEAD(&panel->pwrlist);
+	num_gpio = of_gpio_named_count(dn, "enable-gpios");
+	for (i = 0; i < num_gpio; i++) {
+		pwr = kmalloc(sizeof(*pwr), GFP_KERNEL);
+		pwr->enable_gpio = of_get_named_gpio_flags(dn,
+							   "enable-gpios", i,
+							   &flags);
+		if (flags & OF_GPIO_ACTIVE_LOW)
+			pwr->enable_gpio_flags |= GPIO_ACTIVE_LOW;
+
+		if (gpio_is_valid(pwr->enable_gpio)) {
+			err = gpio_request(pwr->enable_gpio, NULL);
+			if (err < 0) {
+				dev_err(dev, "failed to request GPIO#%u: %d\n",
+					pwr->enable_gpio, err);
+				gpio_free(pwr->enable_gpio);
+				kfree(pwr);
+				continue;
+			}
+			value = (pwr->enable_gpio_flags & GPIO_ACTIVE_LOW) != 0;
+			err = gpio_direction_output(pwr->enable_gpio, value);
+			if (err < 0) {
+				dev_err(dev, "failed to setup GPIO%u: %d\n",
+					pwr->enable_gpio, err);
+				gpio_free(pwr->enable_gpio);
+				kfree(pwr);
+				continue;
+			}
+
+			list_add_tail(&pwr->head, &panel->pwrlist);
+		}
+	}
+
+	if (of_property_read_bool(dn, "color-swap-rb"))
+		priv->color_swap = ROCKCHIP_COLOR_SWAP_RB;
+
+	if (of_property_read_bool(dn, "color-swap-rg"))
+		priv->color_swap |= ROCKCHIP_COLOR_SWAP_RG;
+
+	if (of_property_read_bool(dn, "color-swap-gb"))
+		priv->color_swap |= ROCKCHIP_COLOR_SWAP_GB;
+
+	if (of_property_read_string(dn, "rockchip,output-face", &name))
+		/* default set it as RGB screen */
+		priv->out_face = ROCKCHIP_OUTFACE_P666;
+	else
+		priv->out_face = rockchip_name_to_face(name);
+
+	priv->pwr18 = of_property_read_bool(dn, "lcd-vcc18");
+	priv->dither = of_property_read_bool(dn, "output-dither");
+
+	np = of_get_child_by_name(dn, "display-timings");
+	if (!np) {
+		DRM_ERROR("can't find display timings\n");
+		return 0;
+	}
+
+	of_node_put(np);
+	memset(&vm, 0, sizeof(vm));
+
+	err = of_get_videomode(dn, &vm, 0);
+	if (err < 0)
+		return err;
+
+	drm_display_mode_from_videomode(&vm, &panel->mode);
+	panel->mode.type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
+
+	priv->flags = vm.flags;
+	panel->mode.private = (void *)priv;
+
+	drm_panel_init(&panel->base);
+	panel->base.dev = dev;
+	panel->base.funcs = &rockchip_panel_funcs;
+
+	err = drm_panel_add(&panel->base);
+	if (err < 0)
+		goto free_gpio;
+
+	dev_set_drvdata(dev, panel);
+
+	return 0;
+
+free_gpio:
+	list_for_each(pos, &panel->pwrlist) {
+		pwr = list_entry(pos, struct pwr_gpio, head);
+		if (gpio_is_valid(pwr->enable_gpio))
+			gpio_free(pwr->enable_gpio);
+		kfree(pwr);
+	}
+	return err;
+}
+
+static const struct of_device_id platform_of_match[] = {
+	{
+		.compatible = "rockchip,panel",
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(of, platform_of_match);
+
+static int rockchip_panel_remove(struct platform_device *pdev)
+{
+	struct rockchip_panel *panel = dev_get_drvdata(&pdev->dev);
+	struct pwr_gpio *pwr;
+	struct list_head *pos;
+
+	drm_panel_detach(&panel->base);
+	drm_panel_remove(&panel->base);
+
+	list_for_each(pos, &panel->pwrlist) {
+		pwr = list_entry(pos, struct pwr_gpio, head);
+		if (gpio_is_valid(pwr->enable_gpio))
+			gpio_free(pwr->enable_gpio);
+		kfree(pwr);
+	}
+
+	return 0;
+}
+
+struct platform_driver rockchip_panel_platform_driver = {
+	.driver = {
+		.name = "rockchip,panel",
+		.owner = THIS_MODULE,
+		.of_match_table = platform_of_match,
+	},
+	.probe = rockchip_panel_probe,
+	.remove = rockchip_panel_remove,
+};
-- 
1.7.9.5


