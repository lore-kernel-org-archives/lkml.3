Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbaCQJze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:55:34 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:45227 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaCQJz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:55:29 -0400
X-Mailbox-Line: From 54e457a9a41098bef5adc82d708c61c8e8cd5c62 Mon Sep 17 00:00:00 2001
Message-Id: <54e457a9a41098bef5adc82d708c61c8e8cd5c62.1395049204.git.moinejf@free.fr>
In-Reply-To: <cover.1395049204.git.moinejf@free.fr>
References: <cover.1395049204.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 17 Mar 2014 09:36:34 +0100
Subject: [PATCH RFC 2/5] drm/tilcdc: Change the interface with the tda998x driver
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tda998x being moved from a 'slave encoder' to a normal DRM
encoder/connector, the tilcdc_slave glue is not needed anymore.

This patch uses the infrastructure for componentised subsystems
for waiting to the tda998x full start and to give it the pointer
to the DRM device.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/tilcdc/Makefile       |   1 -
 drivers/gpu/drm/tilcdc/tilcdc_drv.c   |  81 +++++--
 drivers/gpu/drm/tilcdc/tilcdc_slave.c | 406 ----------------------------------
 drivers/gpu/drm/tilcdc/tilcdc_slave.h |  26 ---
 4 files changed, 64 insertions(+), 450 deletions(-)
 delete mode 100644 drivers/gpu/drm/tilcdc/tilcdc_slave.c
 delete mode 100644 drivers/gpu/drm/tilcdc/tilcdc_slave.h

diff --git a/drivers/gpu/drm/tilcdc/Makefile b/drivers/gpu/drm/tilcdc/Makefile
index 7d2eefe..44485f9 100644
--- a/drivers/gpu/drm/tilcdc/Makefile
+++ b/drivers/gpu/drm/tilcdc/Makefile
@@ -6,7 +6,6 @@ endif
 tilcdc-y := \
 	tilcdc_crtc.o \
 	tilcdc_tfp410.o \
-	tilcdc_slave.o \
 	tilcdc_panel.o \
 	tilcdc_drv.o
 
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 171a820..b5b9007 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -17,16 +17,16 @@
 
 /* LCDC DRM driver, based on da8xx-fb */
 
+#include <linux/component.h>
+
 #include "tilcdc_drv.h"
 #include "tilcdc_regs.h"
 #include "tilcdc_tfp410.h"
-#include "tilcdc_slave.h"
 #include "tilcdc_panel.h"
 
 #include "drm_fb_helper.h"
 
 static LIST_HEAD(module_list);
-static bool slave_probing;
 
 void tilcdc_module_init(struct tilcdc_module *mod, const char *name,
 		const struct tilcdc_module_ops *funcs)
@@ -42,11 +42,6 @@ void tilcdc_module_cleanup(struct tilcdc_module *mod)
 	list_del(&mod->list);
 }
 
-void tilcdc_slave_probedefer(bool defered)
-{
-	slave_probing = defered;
-}
-
 static struct of_device_id tilcdc_of_match[];
 
 static struct drm_framebuffer *tilcdc_fb_create(struct drm_device *dev,
@@ -577,6 +572,66 @@ static const struct dev_pm_ops tilcdc_pm_ops = {
  * Platform driver:
  */
 
+/* component stuff */
+static int of_dev_node_match(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
+
+static int tilcdc_add_components(struct device *master, struct master *m)
+{
+	struct device_node *np = master->of_node, *child;
+	int ret;
+
+	/* scan the video ports */
+	child = NULL;
+	for (;;) {
+		struct device_node *endpoint, *port, *i2c_node;
+
+		child = of_get_next_child(np, child);
+		if (!child)
+			break;
+		if (strcmp(child->name, "port") != 0)
+			continue;
+
+		endpoint = of_get_next_child(child, NULL);
+		if (!endpoint) {
+			dev_err(master, "tilcdc: no port endpoint\n");
+			return -EINVAL;
+		}
+		port = of_parse_phandle(endpoint, "remote-endpoint", 0);
+		of_node_put(endpoint);
+		if (!port) {
+			dev_err(master, "ticldc: no remote-endpoint\n");
+			return -EINVAL;
+		}
+		i2c_node = of_get_parent(of_get_parent(port));
+		of_node_put(port);
+		ret = component_master_add_child(m, of_dev_node_match,
+						 i2c_node);
+		of_node_put(i2c_node);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+static int tilcdc_bind(struct device *dev)
+{
+	return drm_platform_init(&tilcdc_driver, to_platform_device(dev));
+}
+
+static void tilcdc_unbind(struct device *dev)
+{
+	drm_put_dev(dev_get_drvdata(dev));
+}
+
+static const struct component_master_ops tilcdc_comp_ops = {
+	.add_components = tilcdc_add_components,
+	.bind = tilcdc_bind,
+	.unbind = tilcdc_unbind,
+};
+
 static int tilcdc_pdev_probe(struct platform_device *pdev)
 {
 	/* bail out early if no DT data: */
@@ -584,18 +639,12 @@ static int tilcdc_pdev_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "device-tree data is missing\n");
 		return -ENXIO;
 	}
-
-	/* defer probing if slave is in deferred probing */
-	if (slave_probing == true)
-		return -EPROBE_DEFER;
-
-	return drm_platform_init(&tilcdc_driver, pdev);
+	return component_master_add(&pdev->dev, &tilcdc_comp_ops);
 }
 
 static int tilcdc_pdev_remove(struct platform_device *pdev)
 {
-	drm_put_dev(platform_get_drvdata(pdev));
-
+	component_master_del(&pdev->dev, &tilcdc_comp_ops);
 	return 0;
 }
 
@@ -620,7 +669,6 @@ static int __init tilcdc_drm_init(void)
 {
 	DBG("init");
 	tilcdc_tfp410_init();
-	tilcdc_slave_init();
 	tilcdc_panel_init();
 	return platform_driver_register(&tilcdc_platform_driver);
 }
@@ -629,7 +677,6 @@ static void __exit tilcdc_drm_fini(void)
 {
 	DBG("fini");
 	tilcdc_tfp410_fini();
-	tilcdc_slave_fini();
 	tilcdc_panel_fini();
 	platform_driver_unregister(&tilcdc_platform_driver);
 }
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.c b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
deleted file mode 100644
index 595068b..0000000
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ /dev/null
@@ -1,406 +0,0 @@
-/*
- * Copyright (C) 2012 Texas Instruments
- * Author: Rob Clark <robdclark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published by
- * the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/i2c.h>
-#include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
-#include <drm/drm_encoder_slave.h>
-
-#include "tilcdc_drv.h"
-
-struct slave_module {
-	struct tilcdc_module base;
-	struct i2c_adapter *i2c;
-};
-#define to_slave_module(x) container_of(x, struct slave_module, base)
-
-static const struct tilcdc_panel_info slave_info = {
-		.bpp                    = 16,
-		.ac_bias                = 255,
-		.ac_bias_intrpt         = 0,
-		.dma_burst_sz           = 16,
-		.fdd                    = 0x80,
-		.tft_alt_mode           = 0,
-		.sync_edge              = 0,
-		.sync_ctrl              = 1,
-		.raster_order           = 0,
-};
-
-
-/*
- * Encoder:
- */
-
-struct slave_encoder {
-	struct drm_encoder_slave base;
-	struct slave_module *mod;
-};
-#define to_slave_encoder(x) container_of(to_encoder_slave(x), struct slave_encoder, base)
-
-static inline struct drm_encoder_slave_funcs *
-get_slave_funcs(struct drm_encoder *enc)
-{
-	return to_encoder_slave(enc)->slave_funcs;
-}
-
-static void slave_encoder_destroy(struct drm_encoder *encoder)
-{
-	struct slave_encoder *slave_encoder = to_slave_encoder(encoder);
-	if (get_slave_funcs(encoder))
-		get_slave_funcs(encoder)->destroy(encoder);
-	drm_encoder_cleanup(encoder);
-	kfree(slave_encoder);
-}
-
-static void slave_encoder_prepare(struct drm_encoder *encoder)
-{
-	drm_i2c_encoder_prepare(encoder);
-	tilcdc_crtc_set_panel_info(encoder->crtc, &slave_info);
-}
-
-static bool slave_encoder_fixup(struct drm_encoder *encoder,
-		const struct drm_display_mode *mode,
-		struct drm_display_mode *adjusted_mode)
-{
-	/*
-	 * tilcdc does not generate VESA-complient sync but aligns
-	 * VS on the second edge of HS instead of first edge.
-	 * We use adjusted_mode, to fixup sync by aligning both rising
-	 * edges and add HSKEW offset to let the slave encoder fix it up.
-	 */
-	adjusted_mode->hskew = mode->hsync_end - mode->hsync_start;
-	adjusted_mode->flags |= DRM_MODE_FLAG_HSKEW;
-
-	if (mode->flags & DRM_MODE_FLAG_NHSYNC) {
-		adjusted_mode->flags |= DRM_MODE_FLAG_PHSYNC;
-		adjusted_mode->flags &= ~DRM_MODE_FLAG_NHSYNC;
-	} else {
-		adjusted_mode->flags |= DRM_MODE_FLAG_NHSYNC;
-		adjusted_mode->flags &= ~DRM_MODE_FLAG_PHSYNC;
-	}
-
-	return drm_i2c_encoder_mode_fixup(encoder, mode, adjusted_mode);
-}
-
-
-static const struct drm_encoder_funcs slave_encoder_funcs = {
-		.destroy        = slave_encoder_destroy,
-};
-
-static const struct drm_encoder_helper_funcs slave_encoder_helper_funcs = {
-		.dpms           = drm_i2c_encoder_dpms,
-		.mode_fixup     = slave_encoder_fixup,
-		.prepare        = slave_encoder_prepare,
-		.commit         = drm_i2c_encoder_commit,
-		.mode_set       = drm_i2c_encoder_mode_set,
-		.save           = drm_i2c_encoder_save,
-		.restore        = drm_i2c_encoder_restore,
-};
-
-static const struct i2c_board_info info = {
-		I2C_BOARD_INFO("tda998x", 0x70)
-};
-
-static struct drm_encoder *slave_encoder_create(struct drm_device *dev,
-		struct slave_module *mod)
-{
-	struct slave_encoder *slave_encoder;
-	struct drm_encoder *encoder;
-	int ret;
-
-	slave_encoder = kzalloc(sizeof(*slave_encoder), GFP_KERNEL);
-	if (!slave_encoder) {
-		dev_err(dev->dev, "allocation failed\n");
-		return NULL;
-	}
-
-	slave_encoder->mod = mod;
-
-	encoder = &slave_encoder->base.base;
-	encoder->possible_crtcs = 1;
-
-	ret = drm_encoder_init(dev, encoder, &slave_encoder_funcs,
-			DRM_MODE_ENCODER_TMDS);
-	if (ret)
-		goto fail;
-
-	drm_encoder_helper_add(encoder, &slave_encoder_helper_funcs);
-
-	ret = drm_i2c_encoder_init(dev, to_encoder_slave(encoder), mod->i2c, &info);
-	if (ret)
-		goto fail;
-
-	return encoder;
-
-fail:
-	slave_encoder_destroy(encoder);
-	return NULL;
-}
-
-/*
- * Connector:
- */
-
-struct slave_connector {
-	struct drm_connector base;
-
-	struct drm_encoder *encoder;  /* our connected encoder */
-	struct slave_module *mod;
-};
-#define to_slave_connector(x) container_of(x, struct slave_connector, base)
-
-static void slave_connector_destroy(struct drm_connector *connector)
-{
-	struct slave_connector *slave_connector = to_slave_connector(connector);
-	drm_connector_cleanup(connector);
-	kfree(slave_connector);
-}
-
-static enum drm_connector_status slave_connector_detect(
-		struct drm_connector *connector,
-		bool force)
-{
-	struct drm_encoder *encoder = to_slave_connector(connector)->encoder;
-	return get_slave_funcs(encoder)->detect(encoder, connector);
-}
-
-static int slave_connector_get_modes(struct drm_connector *connector)
-{
-	struct drm_encoder *encoder = to_slave_connector(connector)->encoder;
-	return get_slave_funcs(encoder)->get_modes(encoder, connector);
-}
-
-static int slave_connector_mode_valid(struct drm_connector *connector,
-		  struct drm_display_mode *mode)
-{
-	struct drm_encoder *encoder = to_slave_connector(connector)->encoder;
-	struct tilcdc_drm_private *priv = connector->dev->dev_private;
-	int ret;
-
-	ret = tilcdc_crtc_mode_valid(priv->crtc, mode);
-	if (ret != MODE_OK)
-		return ret;
-
-	return get_slave_funcs(encoder)->mode_valid(encoder, mode);
-}
-
-static struct drm_encoder *slave_connector_best_encoder(
-		struct drm_connector *connector)
-{
-	struct slave_connector *slave_connector = to_slave_connector(connector);
-	return slave_connector->encoder;
-}
-
-static int slave_connector_set_property(struct drm_connector *connector,
-		struct drm_property *property, uint64_t value)
-{
-	struct drm_encoder *encoder = to_slave_connector(connector)->encoder;
-	return get_slave_funcs(encoder)->set_property(encoder,
-			connector, property, value);
-}
-
-static const struct drm_connector_funcs slave_connector_funcs = {
-	.destroy            = slave_connector_destroy,
-	.dpms               = drm_helper_connector_dpms,
-	.detect             = slave_connector_detect,
-	.fill_modes         = drm_helper_probe_single_connector_modes,
-	.set_property       = slave_connector_set_property,
-};
-
-static const struct drm_connector_helper_funcs slave_connector_helper_funcs = {
-	.get_modes          = slave_connector_get_modes,
-	.mode_valid         = slave_connector_mode_valid,
-	.best_encoder       = slave_connector_best_encoder,
-};
-
-static struct drm_connector *slave_connector_create(struct drm_device *dev,
-		struct slave_module *mod, struct drm_encoder *encoder)
-{
-	struct slave_connector *slave_connector;
-	struct drm_connector *connector;
-	int ret;
-
-	slave_connector = kzalloc(sizeof(*slave_connector), GFP_KERNEL);
-	if (!slave_connector) {
-		dev_err(dev->dev, "allocation failed\n");
-		return NULL;
-	}
-
-	slave_connector->encoder = encoder;
-	slave_connector->mod = mod;
-
-	connector = &slave_connector->base;
-
-	drm_connector_init(dev, connector, &slave_connector_funcs,
-			DRM_MODE_CONNECTOR_HDMIA);
-	drm_connector_helper_add(connector, &slave_connector_helper_funcs);
-
-	connector->polled = DRM_CONNECTOR_POLL_CONNECT |
-			DRM_CONNECTOR_POLL_DISCONNECT;
-
-	connector->interlace_allowed = 0;
-	connector->doublescan_allowed = 0;
-
-	get_slave_funcs(encoder)->create_resources(encoder, connector);
-
-	ret = drm_mode_connector_attach_encoder(connector, encoder);
-	if (ret)
-		goto fail;
-
-	drm_sysfs_connector_add(connector);
-
-	return connector;
-
-fail:
-	slave_connector_destroy(connector);
-	return NULL;
-}
-
-/*
- * Module:
- */
-
-static int slave_modeset_init(struct tilcdc_module *mod, struct drm_device *dev)
-{
-	struct slave_module *slave_mod = to_slave_module(mod);
-	struct tilcdc_drm_private *priv = dev->dev_private;
-	struct drm_encoder *encoder;
-	struct drm_connector *connector;
-
-	encoder = slave_encoder_create(dev, slave_mod);
-	if (!encoder)
-		return -ENOMEM;
-
-	connector = slave_connector_create(dev, slave_mod, encoder);
-	if (!connector)
-		return -ENOMEM;
-
-	priv->encoders[priv->num_encoders++] = encoder;
-	priv->connectors[priv->num_connectors++] = connector;
-
-	return 0;
-}
-
-static void slave_destroy(struct tilcdc_module *mod)
-{
-	struct slave_module *slave_mod = to_slave_module(mod);
-
-	tilcdc_module_cleanup(mod);
-	kfree(slave_mod);
-}
-
-static const struct tilcdc_module_ops slave_module_ops = {
-		.modeset_init = slave_modeset_init,
-		.destroy = slave_destroy,
-};
-
-/*
- * Device:
- */
-
-static struct of_device_id slave_of_match[];
-
-static int slave_probe(struct platform_device *pdev)
-{
-	struct device_node *node = pdev->dev.of_node;
-	struct device_node *i2c_node;
-	struct slave_module *slave_mod;
-	struct tilcdc_module *mod;
-	struct pinctrl *pinctrl;
-	uint32_t i2c_phandle;
-	struct i2c_adapter *slavei2c;
-	int ret = -EINVAL;
-
-	/* bail out early if no DT data: */
-	if (!node) {
-		dev_err(&pdev->dev, "device-tree data is missing\n");
-		return -ENXIO;
-	}
-
-	/* Bail out early if i2c not specified */
-	if (of_property_read_u32(node, "i2c", &i2c_phandle)) {
-		dev_err(&pdev->dev, "could not get i2c bus phandle\n");
-		return ret;
-	}
-
-	i2c_node = of_find_node_by_phandle(i2c_phandle);
-	if (!i2c_node) {
-		dev_err(&pdev->dev, "could not get i2c bus node\n");
-		return ret;
-	}
-
-	/* but defer the probe if it can't be initialized it might come later */
-	slavei2c = of_find_i2c_adapter_by_node(i2c_node);
-	of_node_put(i2c_node);
-
-	if (!slavei2c) {
-		ret = -EPROBE_DEFER;
-		tilcdc_slave_probedefer(true);
-		dev_err(&pdev->dev, "could not get i2c\n");
-		return ret;
-	}
-
-	slave_mod = kzalloc(sizeof(*slave_mod), GFP_KERNEL);
-	if (!slave_mod)
-		return -ENOMEM;
-
-	mod = &slave_mod->base;
-
-	mod->preferred_bpp = slave_info.bpp;
-
-	slave_mod->i2c = slavei2c;
-
-	tilcdc_module_init(mod, "slave", &slave_module_ops);
-
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "pins are not configured\n");
-
-	tilcdc_slave_probedefer(false);
-
-	return 0;
-}
-
-static int slave_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
-static struct of_device_id slave_of_match[] = {
-		{ .compatible = "ti,tilcdc,slave", },
-		{ },
-};
-
-struct platform_driver slave_driver = {
-	.probe = slave_probe,
-	.remove = slave_remove,
-	.driver = {
-		.owner = THIS_MODULE,
-		.name = "slave",
-		.of_match_table = slave_of_match,
-	},
-};
-
-int __init tilcdc_slave_init(void)
-{
-	return platform_driver_register(&slave_driver);
-}
-
-void __exit tilcdc_slave_fini(void)
-{
-	platform_driver_unregister(&slave_driver);
-}
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.h b/drivers/gpu/drm/tilcdc/tilcdc_slave.h
deleted file mode 100644
index 2f85048..0000000
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * Copyright (C) 2012 Texas Instruments
- * Author: Rob Clark <robdclark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published by
- * the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __TILCDC_SLAVE_H__
-#define __TILCDC_SLAVE_H__
-
-/* sub-module for i2c slave encoder output */
-
-int tilcdc_slave_init(void);
-void tilcdc_slave_fini(void);
-
-#endif /* __TILCDC_SLAVE_H__ */
-- 
1.9.0

