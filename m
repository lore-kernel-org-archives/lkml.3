Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbaETN5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:57:30 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63499 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaETN5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:25 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 16/16] drm: sti: Add DRM driver itself
Date: Tue, 20 May 2014 15:56:26 +0200
Message-Id: <1400594186-8956-17-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the link between all the hardware drivers and DRM/KMS interface.
Create the driver itself and make it register all the sub-components.
Use GEM CMA helpers for buffer allocation.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/Kconfig             |   8 +
 drivers/gpu/drm/sti/Makefile            |   7 +-
 drivers/gpu/drm/sti/sti_compositor.c    |  48 ++++
 drivers/gpu/drm/sti/sti_drm_connector.c | 195 ++++++++++++++
 drivers/gpu/drm/sti/sti_drm_connector.h |  16 ++
 drivers/gpu/drm/sti/sti_drm_crtc.c      | 440 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_drm_crtc.h      |  21 ++
 drivers/gpu/drm/sti/sti_drm_drv.c       | 338 ++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_drm_encoder.c   | 201 +++++++++++++++
 drivers/gpu/drm/sti/sti_drm_encoder.h   |  16 ++
 drivers/gpu/drm/sti/sti_drm_plane.c     | 195 ++++++++++++++
 drivers/gpu/drm/sti/sti_drm_plane.h     |  16 ++
 drivers/gpu/drm/sti/sti_tvout.c         |  21 ++
 13 files changed, 1521 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/sti/sti_drm_connector.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_connector.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_encoder.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_encoder.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.h

diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
index 76c2e4f..2c80bcf 100644
--- a/drivers/gpu/drm/sti/Kconfig
+++ b/drivers/gpu/drm/sti/Kconfig
@@ -1,10 +1,18 @@
 config DRM_STI
 	bool "DRM Support for STMicroelectronics SoC stiH41x Series"
 	depends on DRM && (SOC_STIH415 || SOC_STIH416 || ARCH_MULTIPLATFORM)
+	select DRM_KMS_HELPER
+	select DRM_GEM_CMA_HELPER
 	select DRM_KMS_CMA_HELPER
 	help
 	  Choose this option to enable DRM on STM stiH41x chipset
 
+config DRM_STI_FBDEV
+	bool "DRM frame buffer device for STMicroelectronics SoC stiH41x Serie"
+	depends on DRM_STI
+	help
+	  Choose this option to enable FBDEV on top of DRM for STM stiH41x chipset
+
 config VTAC_STI
 	bool "Video Trafic Advance Communication Rx and Tx for STMicroelectronics SoC stiH41x Series"
 	depends on DRM_STI
diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index 3b804d4..8eee160 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -1,6 +1,11 @@
 ccflags-y := -Iinclude/drm
 
-stidrm-y := sti_tvout.o \
+stidrm-y := sti_drm_drv.o \
+			sti_drm_crtc.o \
+			sti_drm_plane.o \
+			sti_drm_connector.o \
+			sti_drm_encoder.o \
+			sti_tvout.o \
 			sti_hdmi.o \
 			sti_hdmi_tx3g0c55phy.o \
 			sti_hdmi_tx3g4c28phy.o \
diff --git a/drivers/gpu/drm/sti/sti_compositor.c b/drivers/gpu/drm/sti/sti_compositor.c
index 0c9ef6d..b0e2968 100644
--- a/drivers/gpu/drm/sti/sti_compositor.c
+++ b/drivers/gpu/drm/sti/sti_compositor.c
@@ -14,7 +14,10 @@
 #include <drm/drmP.h>
 
 #include "sti_compositor.h"
+#include "sti_drm_drv.h"
+#include "sti_drm_plane.h"
 #include "sti_gdp.h"
+#include "sti_drm_crtc.h"
 
 static const struct of_device_id compositor_match_types[];
 
@@ -86,6 +89,50 @@ static int sti_compositor_init_subdev(struct sti_compositor *compo,
 static int sti_compositor_bind(struct device *dev, struct device *master,
 	void *data)
 {
+	struct sti_compositor *compo = dev_get_drvdata(master);
+	struct drm_device *drm_dev = data;
+	int i, crtc = 0, plane = 0;
+	struct sti_drm_private *dev_priv = drm_dev->dev_private;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	dev_priv->compo = compo;
+	INIT_LIST_HEAD(&dev_priv->pageflip_evt_list);
+
+	for (i = 0; i < compo->nb_mixers; i++) {
+		if (compo->mixer[i]) {
+			sti_drm_crtc_init(drm_dev, compo->mixer[i]);
+			crtc++;
+		}
+	}
+	if (crtc == 0) {
+		DRM_ERROR("No CRTC available\n");
+		return 1;
+	}
+
+	drm_vblank_init(drm_dev, crtc);
+	/* Allow usage of vblank without having to call drm_irq_install */
+	drm_dev->irq_enabled = 1;
+
+	for (i = 0; i < compo->nb_layers; i++) {
+		if (compo->layer[i]) {
+			/* Create planes for GDP.
+			 * except GDP0 as it is reserved for CRTC FB */
+			enum sti_layer_desc desc = compo->layer[i]->desc;
+			enum sti_layer_type type = desc & STI_LAYER_TYPE_MASK;
+
+			if ((type == STI_GDP) && (desc != STI_GDP_0)) {
+				sti_drm_plane_init(drm_dev, compo->layer[i],
+						   (1 << crtc) - 1);
+				plane++;
+			}
+		}
+	}
+
+	DRM_DEBUG_DRIVER("Initialized %d DRM CRTC(s) and %d DRM plane(s)\n",
+			 crtc, plane);
+	DRM_DEBUG_DRIVER("DRM plane(s) for VID/VDP not created yet\n");
+
 	return 0;
 }
 
@@ -116,6 +163,7 @@ static int sti_compositor_probe(struct platform_device *pdev)
 	}
 	DRM_DEBUG_DRIVER("Compositor %p\n", compo);
 	compo->dev = dev;
+	compo->vtg_vblank_nb.notifier_call = sti_drm_crtc_vblank_cb;
 
 	/* populate data structure depending on compatibility */
 	BUG_ON(!of_match_node(compositor_match_types, np)->data);
diff --git a/drivers/gpu/drm/sti/sti_drm_connector.c b/drivers/gpu/drm/sti/sti_drm_connector.c
new file mode 100644
index 0000000..b34a402
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_connector.c
@@ -0,0 +1,195 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+
+#include "sti_drm_connector.h"
+#include "sti_drm_drv.h"
+
+#define to_sti_connector(x) container_of(x, struct sti_connector, drm_connector)
+
+/*
+ * sti specific connector structure
+ *
+ * @drm_encoder: connector object
+ * @encoder: associated encoder
+ * @tvout: pointer on tvout driver
+ * @type: tvout connector type
+ */
+struct sti_connector {
+	struct drm_connector drm_connector;
+	struct drm_encoder *encoder;
+	struct sti_tvout *tvout;
+	enum sti_tvout_connector_type type;
+};
+
+static int sti_drm_connector_get_modes(struct drm_connector *connector)
+{
+	struct sti_connector *sti_connector = to_sti_connector(connector);
+	struct drm_device *dev = connector->dev;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	return sti_tvout_get_modes(sti_connector->tvout, sti_connector->type,
+				   connector);
+}
+
+static int sti_drm_connector_mode_valid(struct drm_connector *connector,
+					struct drm_display_mode *mode)
+{
+	struct sti_connector *sti_connector = to_sti_connector(connector);
+	struct drm_device *dev = connector->dev;
+	int ret = MODE_BAD;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	if (!sti_tvout_check_mode
+	    (sti_connector->tvout, sti_connector->type, mode))
+		ret = MODE_OK;
+
+	return ret;
+}
+
+struct drm_encoder *sti_drm_best_encoder(struct drm_connector *connector)
+{
+	struct sti_connector *sti_connector = to_sti_connector(connector);
+	struct drm_device *dev = connector->dev;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	/* Best encoder is the one associated during connector creation */
+	return sti_connector->encoder;
+}
+
+static struct drm_connector_helper_funcs sti_drm_connector_helper_funcs = {
+	.get_modes = sti_drm_connector_get_modes,
+	.mode_valid = sti_drm_connector_mode_valid,
+	.best_encoder = sti_drm_best_encoder,
+};
+
+static void sti_drm_connector_dpms(struct drm_connector *connector, int mode)
+{
+	struct drm_device *dev = connector->dev;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	drm_helper_connector_dpms(connector, mode);
+}
+
+/* get detection status of display device. */
+static enum drm_connector_status
+sti_drm_connector_detect(struct drm_connector *connector, bool force)
+{
+	enum drm_connector_status status = connector_status_disconnected;
+	struct sti_connector *sti_connector = to_sti_connector(connector);
+	struct drm_device *dev = connector->dev;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	if (sti_tvout_connector_detect(sti_connector->tvout,
+				       sti_connector->type))
+		status = connector_status_connected;
+
+	return status;
+}
+
+static void sti_drm_connector_destroy(struct drm_connector *connector)
+{
+	struct sti_connector *sti_connector = to_sti_connector(connector);
+	struct drm_device *dev = connector->dev;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+	kfree(sti_connector);
+}
+
+static struct drm_connector_funcs sti_drm_connector_funcs = {
+	.dpms = sti_drm_connector_dpms,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.detect = sti_drm_connector_detect,
+	.destroy = sti_drm_connector_destroy,
+};
+
+struct drm_connector *sti_drm_connector_create(struct drm_device *dev,
+					       struct sti_tvout *tvout,
+					       struct drm_encoder *encoder,
+					       enum sti_tvout_connector_type
+					       type)
+{
+	struct sti_connector *sti_connector;
+	struct drm_connector *connector;
+	int connector_type;
+	int err;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	/* Create the tvout connector according to the type */
+	tvout->connector[type] = tvout->connector_create[type] (tvout);
+	if (!tvout->connector[type]) {
+		DRM_INFO("%s: failed to create connector (type = %d)\n",
+			 __func__, type);
+		return NULL;
+	}
+
+	sti_connector = kzalloc(sizeof(*sti_connector), GFP_KERNEL);
+	if (!sti_connector) {
+		DRM_ERROR("failed to allocate connector\n");
+		return NULL;
+	}
+
+	connector = &sti_connector->drm_connector;
+
+	switch (type) {
+	case STI_TVOUT_CONNECTOR_HDMI:
+		connector_type = DRM_MODE_CONNECTOR_HDMIA;
+		connector->polled = DRM_CONNECTOR_POLL_HPD;
+		break;
+	case STI_TVOUT_CONNECTOR_HDA:
+		connector_type = DRM_MODE_CONNECTOR_Component;
+		break;
+	case STI_TVOUT_CONNECTOR_DVO:
+		connector_type = DRM_MODE_CONNECTOR_LVDS;
+		break;
+	case STI_TVOUT_CONNECTOR_DENC:
+		connector_type = DRM_MODE_CONNECTOR_Composite;
+		break;
+	default:
+		connector_type = DRM_MODE_CONNECTOR_Unknown;
+		break;
+	}
+
+	drm_connector_init(dev, connector, &sti_drm_connector_funcs,
+			   connector_type);
+	drm_connector_helper_add(connector, &sti_drm_connector_helper_funcs);
+
+	err = drm_sysfs_connector_add(connector);
+	if (err)
+		goto err_connector;
+
+	sti_connector->tvout = tvout;
+	sti_connector->encoder = encoder;
+	sti_connector->type = type;
+
+	err = drm_mode_connector_attach_encoder(connector, encoder);
+	if (err) {
+		DRM_ERROR("Failed to attach a connector to a encoder\n");
+		goto err_sysfs;
+	}
+
+	DRM_DEBUG_DRIVER("Connector has been created\n");
+
+	return connector;
+
+err_sysfs:
+	drm_sysfs_connector_remove(connector);
+err_connector:
+	drm_connector_cleanup(connector);
+	kfree(sti_connector);
+	return NULL;
+}
diff --git a/drivers/gpu/drm/sti/sti_drm_connector.h b/drivers/gpu/drm/sti/sti_drm_connector.h
new file mode 100644
index 0000000..068c674
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_connector.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_DRM_CONNECTOR_H_
+#define _STI_DRM_CONNECTOR_H_
+
+#include "sti_tvout.h"
+
+struct drm_connector *sti_drm_connector_create(struct drm_device *dev,
+		struct sti_tvout *tvout, struct drm_encoder *encoder,
+		enum sti_tvout_connector_type type);
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_drm_crtc.c b/drivers/gpu/drm/sti/sti_drm_crtc.c
new file mode 100644
index 0000000..5c06d70
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_crtc.c
@@ -0,0 +1,440 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/clk.h>
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+
+#include "sti_drm_drv.h"
+#include "sti_drm_crtc.h"
+#include "sti_compositor.h"
+#include "sti_vtg_utils.h"
+
+static void sti_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	DRM_DEBUG_KMS("\n");
+}
+
+static void sti_drm_crtc_prepare(struct drm_crtc *crtc)
+{
+	struct sti_mixer *mixer = to_sti_mixer(crtc);
+	struct device *dev = mixer->dev;
+	struct sti_compositor *compo = dev_get_drvdata(dev);
+
+	compo->enable = true;
+
+	/* Prepare and enable the compo IP clock */
+	if (mixer->id == STI_MIXER_MAIN) {
+		if (clk_prepare_enable(compo->clk_compo_main))
+			DRM_INFO("Failed to prepare/enable compo_main clk\n");
+	} else {
+		if (clk_prepare_enable(compo->clk_compo_aux))
+			DRM_INFO("Failed to prepare/enable compo_aux clk\n");
+	}
+}
+
+static void sti_drm_crtc_commit(struct drm_crtc *crtc)
+{
+	struct sti_mixer *mixer = to_sti_mixer(crtc);
+	struct device *dev = mixer->dev;
+	struct sti_compositor *compo = dev_get_drvdata(dev);
+	struct sti_layer *layer;
+
+	dev_dbg(dev, "%s\n", __func__);
+	if ((!mixer || !compo)) {
+		DRM_ERROR("Can not find mixer or compositor)\n");
+		return;
+	}
+
+	/* Find GDP0 which is reserved to the CRTC FB */
+	layer = sti_layer_find_layer(compo->layer, STI_GDP_0);
+	if (layer)
+		sti_layer_commit(layer);
+	else
+		DRM_ERROR("Can not find CRTC dedicated plane (GDP0)\n");
+
+	/* Enable layer on mixer */
+	if (sti_mixer_set_layer_status(mixer, layer, true))
+		DRM_ERROR("Can not enable layer at mixer\n");
+}
+
+static bool sti_drm_crtc_mode_fixup(struct drm_crtc *crtc,
+				    const struct drm_display_mode *mode,
+				    struct drm_display_mode *adjusted_mode)
+{
+	/* accept the provided drm_display_mode, do not fix it up */
+	dev_dbg(crtc->dev->dev, "%s\n", __func__);
+	return true;
+}
+
+static int
+sti_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
+		      struct drm_display_mode *adjusted_mode, int x, int y,
+		      struct drm_framebuffer *old_fb)
+{
+	struct sti_mixer *mixer = to_sti_mixer(crtc);
+	struct device *dev = mixer->dev;
+	struct sti_compositor *compo = dev_get_drvdata(dev);
+	struct sti_layer *layer;
+	struct clk *clk;
+	int rate = mode->clock * 1000;
+	int res;
+	unsigned int w, h;
+
+	DRM_DEBUG_KMS("CRTC:%d (%s) fb:%d mode:%d (%s)\n",
+		      crtc->base.id, sti_mixer_to_str(mixer),
+		      crtc->fb->base.id, mode->base.id, mode->name);
+
+	DRM_DEBUG_KMS("%d %d %d %d %d %d %d %d %d %d 0x%x 0x%x\n",
+		      mode->vrefresh, mode->clock,
+		      mode->hdisplay,
+		      mode->hsync_start, mode->hsync_end,
+		      mode->htotal,
+		      mode->vdisplay,
+		      mode->vsync_start, mode->vsync_end,
+		      mode->vtotal, mode->type, mode->flags);
+
+	/* Set rate and prepare/enable pixel clock */
+	if (mixer->id == STI_MIXER_MAIN)
+		clk = compo->clk_pix_main;
+	else
+		clk = compo->clk_pix_aux;
+
+	res = clk_set_rate(clk, rate);
+	if (res < 0) {
+		DRM_ERROR("Cannot set rate (%dHz) for pix clk\n", rate);
+		return 1;
+	}
+	if (clk_prepare_enable(clk)) {
+		DRM_ERROR("Failed to prepare/enable pix clk\n");
+		return 1;
+	}
+
+	sti_vtg_setconfig(mixer->id == STI_MIXER_MAIN ? VTG_MAIN : VTG_AUX,
+			  &crtc->mode);
+
+	/* GDP0 is reserved to the CRTC FB */
+	layer = sti_layer_find_layer(compo->layer, STI_GDP_0);
+	if (!layer) {
+		DRM_ERROR("Can not find GDP0)\n");
+		return 1;
+	}
+
+	/* copy the mode data adjusted by mode_fixup() into crtc->mode
+	 * so that hardware can be set to proper mode */
+	memcpy(&crtc->mode, adjusted_mode, sizeof(*adjusted_mode));
+
+	res = sti_mixer_set_layer_depth(mixer, layer);
+	if (res) {
+		DRM_ERROR("Can not set layer depth\n");
+		return 1;
+	}
+	res = sti_mixer_active_video_area(mixer, &crtc->mode);
+	if (res) {
+		DRM_ERROR("Can not set active video area\n");
+		return 1;
+	}
+
+	if ((mode->hdisplay != crtc->fb->width) ||
+	    (mode->vdisplay != crtc->fb->height))
+		DRM_DEBUG_KMS("WARNING: fb and display mode sizes differ\n");
+
+	w = crtc->fb->width - x;
+	h = crtc->fb->height - y;
+
+	if ((w <= 0) || (h <= 0)) {
+		DRM_ERROR("Coordinates outside FB\n");
+		return -EINVAL;
+	}
+
+	return sti_layer_prepare(layer, crtc->fb, &crtc->mode, mixer->id,
+			0, 0, w, h, x, y, w, h);
+}
+
+static int sti_drm_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
+				      struct drm_framebuffer *old_fb)
+{
+	struct sti_mixer *mixer = to_sti_mixer(crtc);
+	struct device *dev = mixer->dev;
+	struct sti_compositor *compo = dev_get_drvdata(dev);
+	struct sti_layer *layer;
+	unsigned int w, h;
+	int ret = 0;
+
+	DRM_DEBUG_KMS("CRTC:%d (%s) fb:%d (%d,%d)\n",
+		      crtc->base.id, sti_mixer_to_str(mixer),
+		      crtc->fb->base.id, x, y);
+
+	/* GDP0 is reserved to the CRTC FB */
+	layer = sti_layer_find_layer(compo->layer, STI_GDP_0);
+	if (!layer) {
+		DRM_ERROR("Can not find GDP0)\n");
+		ret = -1;
+		goto out;
+	}
+
+	w = crtc->fb->width - crtc->x;
+	h = crtc->fb->height - crtc->y;
+
+	if ((w <= 0) || (h <= 0)) {
+		DRM_ERROR("Coordinates outside FB\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = sti_layer_prepare(layer, crtc->fb, &crtc->mode, mixer->id,
+				0, 0, w, h,
+				crtc->x, crtc->y, w, h);
+	if (ret) {
+		DRM_ERROR("Can not prepare layer\n");
+		goto out;
+	}
+
+	sti_drm_crtc_commit(crtc);
+out:
+	return ret;
+}
+
+static void sti_drm_crtc_load_lut(struct drm_crtc *crtc)
+{
+	dev_dbg(crtc->dev->dev, "%s\n", __func__);
+}
+
+static void sti_drm_crtc_disable(struct drm_crtc *crtc)
+{
+	struct sti_mixer *mixer = to_sti_mixer(crtc);
+	struct device *dev = mixer->dev;
+	struct sti_compositor *compo = dev_get_drvdata(dev);
+	struct sti_layer *layer;
+
+	if (!compo->enable)
+		return;
+
+	DRM_DEBUG_KMS("CRTC:%d (%s)\n", crtc->base.id, sti_mixer_to_str(mixer));
+
+	/* Disable Background */
+	sti_mixer_set_background_status(mixer, false);
+
+	/* Disable GDP0 */
+	layer = sti_layer_find_layer(compo->layer, STI_GDP_0);
+	if (!layer) {
+		DRM_ERROR("Cannot find GDP0\n");
+		return;
+	}
+
+	/* Disable layer at mixer level */
+	if (sti_mixer_set_layer_status(mixer, layer, false))
+		DRM_ERROR("Can not disable %s layer at mixer\n",
+				sti_layer_to_str(layer));
+
+	/* Wait a while to be sure that a Vsync event is received */
+	msleep(WAIT_NEXT_VSYNC_MS);
+
+	/* Then disable layer itself */
+	sti_layer_disable(layer);
+
+	drm_vblank_off(crtc->dev, mixer->id);
+
+	/* Disable pixel clock and compo IP clocks */
+	if (mixer->id == STI_MIXER_MAIN) {
+		clk_disable_unprepare(compo->clk_pix_main);
+		clk_disable_unprepare(compo->clk_compo_main);
+	} else {
+		clk_disable_unprepare(compo->clk_pix_aux);
+		clk_disable_unprepare(compo->clk_compo_aux);
+	}
+
+	compo->enable = false;
+}
+
+static struct drm_crtc_helper_funcs sti_crtc_helper_funcs = {
+	.dpms = sti_drm_crtc_dpms,
+	.prepare = sti_drm_crtc_prepare,
+	.commit = sti_drm_crtc_commit,
+	.mode_fixup = sti_drm_crtc_mode_fixup,
+	.mode_set = sti_drm_crtc_mode_set,
+	.mode_set_base = sti_drm_crtc_mode_set_base,
+	.load_lut = sti_drm_crtc_load_lut,
+	.disable = sti_drm_crtc_disable,
+};
+
+static int sti_drm_crtc_page_flip(struct drm_crtc *crtc,
+				  struct drm_framebuffer *fb,
+				  struct drm_pending_vblank_event *event,
+				  uint32_t page_flip_flags)
+{
+	struct drm_device *drm_dev = crtc->dev;
+	struct sti_drm_private *dev_priv = drm_dev->dev_private;
+	struct drm_framebuffer *old_fb;
+	struct sti_mixer *mixer = to_sti_mixer(crtc);
+	unsigned long flags;
+	int ret = 0;
+
+	DRM_DEBUG_KMS("fb %d --> fb %d\n", crtc->fb->base.id, fb->base.id);
+
+	mutex_lock(&drm_dev->struct_mutex);
+
+	old_fb = crtc->fb;
+	crtc->fb = fb;
+	ret = sti_drm_crtc_mode_set_base(crtc, crtc->x, crtc->y, old_fb);
+	if (ret) {
+		DRM_ERROR("failed\n");
+		crtc->fb = old_fb;
+		goto out;
+	}
+
+	if (event) {
+		event->pipe = mixer->id;
+
+		ret = drm_vblank_get(drm_dev, event->pipe);
+		if (ret) {
+			DRM_ERROR("Cannot get vblank\n");
+			goto out;
+		}
+
+		spin_lock_irqsave(&drm_dev->event_lock, flags);
+		list_add_tail(&event->base.link, &dev_priv->pageflip_evt_list);
+		spin_unlock_irqrestore(&drm_dev->event_lock, flags);
+	}
+out:
+	mutex_unlock(&drm_dev->struct_mutex);
+	return ret;
+}
+
+static void sti_drm_crtc_destroy(struct drm_crtc *crtc)
+{
+	DRM_DEBUG_KMS("\n");
+
+	drm_crtc_cleanup(crtc);
+}
+
+static int sti_drm_crtc_set_property(struct drm_crtc *crtc,
+				     struct drm_property *property,
+				     uint64_t val)
+{
+	DRM_DEBUG_KMS("\n");
+
+	return 0;
+}
+
+int sti_drm_crtc_vblank_cb(struct notifier_block *nb,
+			   unsigned long event, void *data)
+{
+	struct sti_compositor *compo = container_of(nb,
+						    struct sti_compositor,
+						    vtg_vblank_nb);
+	struct drm_device *drm_dev;
+	int *crtc = data;
+	unsigned long flags;
+	struct drm_pending_vblank_event *e, *t;
+	struct sti_drm_private *priv;
+
+	drm_dev = compo->mixer[*crtc]->drm_crtc.dev;
+	priv = drm_dev->dev_private;
+
+	dev_dbg(drm_dev->dev, "%s\n", __func__);
+
+	if ((event != VTG_TOP_FIELD_EVENT) &&
+	    (event != VTG_BOTTOM_FIELD_EVENT)) {
+		DRM_ERROR("unknown event: %lu\n", event);
+		return -EINVAL;
+	}
+
+	drm_handle_vblank(drm_dev, *crtc);
+
+	spin_lock_irqsave(&drm_dev->event_lock, flags);
+	list_for_each_entry_safe(e, t, &priv->pageflip_evt_list, base.link) {
+		if (*crtc != e->pipe)
+			continue;
+
+		list_del(&e->base.link);
+		drm_send_vblank_event(drm_dev, -1, e);
+		drm_vblank_put(drm_dev, *crtc);
+	}
+	spin_unlock_irqrestore(&drm_dev->event_lock, flags);
+
+	return 0;
+}
+
+int sti_drm_crtc_enable_vblank(struct drm_device *dev, int crtc)
+{
+	struct sti_drm_private *dev_priv = dev->dev_private;
+	struct sti_compositor *compo = dev_priv->compo;
+	struct notifier_block *vtg_vblank_nb = &compo->vtg_vblank_nb;
+	DRM_DEBUG_DRIVER("\n");
+
+	if (sti_vtg_register_client(crtc, vtg_vblank_nb)) {
+		DRM_ERROR("Cannot register VTG notifier\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+void sti_drm_crtc_disable_vblank(struct drm_device *dev, int crtc)
+{
+	struct sti_drm_private *dev_priv = dev->dev_private;
+	struct sti_compositor *compo = dev_priv->compo;
+	struct notifier_block *vtg_vblank_nb = &compo->vtg_vblank_nb;
+	unsigned long flags;
+	struct drm_pending_vblank_event *e, *t;
+	struct sti_drm_private *priv = dev->dev_private;
+	DRM_DEBUG_DRIVER("\n");
+
+	if (sti_vtg_unregister_client(crtc, vtg_vblank_nb))
+		DRM_DEBUG_DRIVER("Warning: cannot unregister VTG notifier\n");
+
+	/* free the resources of the pending requests */
+	spin_lock_irqsave(&dev->event_lock, flags);
+	list_for_each_entry_safe(e, t, &priv->pageflip_evt_list, base.link) {
+		if (crtc != e->pipe)
+			continue;
+		list_del(&e->base.link);
+		drm_vblank_put(dev, crtc);
+	}
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+}
+
+static struct drm_crtc_funcs sti_crtc_funcs = {
+	.set_config = drm_crtc_helper_set_config,
+	.page_flip = sti_drm_crtc_page_flip,
+	.destroy = sti_drm_crtc_destroy,
+	.set_property = sti_drm_crtc_set_property,
+};
+
+bool sti_drm_crtc_is_main(struct drm_crtc *crtc)
+{
+	struct sti_mixer *mixer = to_sti_mixer(crtc);
+
+	if (mixer->id == STI_MIXER_MAIN)
+		return true;
+
+	return false;
+}
+
+int sti_drm_crtc_init(struct drm_device *drm_dev, struct sti_mixer *mixer)
+{
+	struct drm_crtc *crtc = &mixer->drm_crtc;
+	int res;
+
+	dev_dbg(drm_dev->dev, "%s\n", __func__);
+	res = drm_crtc_init(drm_dev, crtc, &sti_crtc_funcs);
+	if (res) {
+		DRM_ERROR("Can not initialze CRTC\n");
+		return 1;
+	}
+
+	drm_crtc_helper_add(crtc, &sti_crtc_helper_funcs);
+
+	DRM_DEBUG_DRIVER("drm CRTC:%d mapped to %s\n",
+			 crtc->base.id, sti_mixer_to_str(mixer));
+
+	return 0;
+}
diff --git a/drivers/gpu/drm/sti/sti_drm_crtc.h b/drivers/gpu/drm/sti/sti_drm_crtc.h
new file mode 100644
index 0000000..9d31e41
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_crtc.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_DRM_CRTC_H_
+#define _STI_DRM_CRTC_H_
+
+#include <drm/drmP.h>
+
+#include "sti_mixer.h"
+
+int sti_drm_crtc_init(struct drm_device *drm_dev, struct sti_mixer *mixer);
+int sti_drm_crtc_enable_vblank(struct drm_device *dev, int crtc);
+void sti_drm_crtc_disable_vblank(struct drm_device *dev, int crtc);
+int sti_drm_crtc_vblank_cb(struct notifier_block *nb,
+		unsigned long event, void *data);
+bool sti_drm_crtc_is_main(struct drm_crtc *drm_crtc);
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_drm_drv.c b/drivers/gpu/drm/sti/sti_drm_drv.c
new file mode 100644
index 0000000..30a2009
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_drv.c
@@ -0,0 +1,338 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <drm/drmP.h>
+
+#include <linux/component.h>
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+
+#include "sti_drm_drv.h"
+#include "sti_drm_crtc.h"
+#include "sti_compositor.h"
+#include "sti_gdp.h"
+#include "sti_tvout.h"
+
+#define DRIVER_NAME	"sti"
+#define DRIVER_DESC	"STMicroelectronics SoC DRM"
+#define DRIVER_DATE	"20130905"
+#define DRIVER_MAJOR	1
+#define DRIVER_MINOR	0
+
+#ifdef CONFIG_DRM_STI_FBDEV
+#define FBDEV_CREATE_DELAY      2000
+struct drm_device *sti_drm_device;
+
+static void stid_fbdev_create(struct work_struct *dummy)
+{
+	if (!sti_drm_device)
+		return;
+
+	drm_fbdev_cma_init(sti_drm_device, 32,
+			   sti_drm_device->mode_config.num_crtc,
+			   sti_drm_device->mode_config.num_connector);
+}
+
+static DECLARE_DELAYED_WORK(sti_fbdev_work, stid_fbdev_create);
+#endif
+
+static struct drm_mode_config_funcs sti_drm_mode_config_funcs = {
+	.fb_create = drm_fb_cma_create,
+};
+
+#ifdef CONFIG_DEBUG_FS
+static struct drm_info_list sti_drm_dbg_list[] = {
+	{"gdp", sti_gdp_dbg_show, 0},
+	{"node", sti_gdp_node_dbg_show, 0},
+	{"mixer", sti_mixer_dbg_show, 0},
+	{"hdmi", sti_tvout_hdmi_dbg_show, 0, NULL},
+	{"hda", sti_tvout_hda_dbg_show, 0, NULL},
+};
+
+static int sti_drm_fps_get(void *data, u64 *val)
+{
+	struct drm_device *dev = data;
+	struct sti_drm_private *dev_priv = dev->dev_private;
+	struct sti_compositor *compo = dev_priv->compo;
+	int i;
+
+	*val = 0;
+	for (i = 0; i < compo->nb_layers; i++)
+		*val |= (compo->layer[i]->fps_info.output) << i;
+
+	return 0;
+}
+
+static int sti_drm_fps_set(void *data, u64 val)
+{
+	struct drm_device *dev = data;
+	struct sti_drm_private *dev_priv = dev->dev_private;
+	struct sti_compositor *compo = dev_priv->compo;
+	int i;
+
+	for (i = 0; i < compo->nb_layers; i++)
+		compo->layer[i]->fps_info.output = (val >> i) & 1;
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(sti_drm_fps_fops,
+			sti_drm_fps_get, sti_drm_fps_set, "%llu\n");
+
+static int sti_drm_debugfs_create(struct dentry *root, struct drm_minor *minor,
+				  const char *name,
+				  const struct file_operations *fops)
+{
+	struct drm_device *dev = minor->dev;
+	struct drm_info_node *node;
+	struct dentry *ent;
+
+	ent = debugfs_create_file(name, S_IRUGO | S_IWUSR, root, dev, fops);
+	if (IS_ERR(ent))
+		return PTR_ERR(ent);
+
+	node = kmalloc(sizeof(struct drm_info_node), GFP_KERNEL);
+	if (node == NULL) {
+		debugfs_remove(ent);
+		return -ENOMEM;
+	}
+
+	node->minor = minor;
+	node->dent = ent;
+	node->info_ent = (void *)fops;
+
+	mutex_lock(&minor->debugfs_lock);
+	list_add(&node->list, &minor->debugfs_list);
+	mutex_unlock(&minor->debugfs_lock);
+
+	return 0;
+}
+
+int sti_drm_dbg_init(struct drm_minor *minor)
+{
+	int ret;
+
+	ret = sti_drm_debugfs_create(minor->debugfs_root, minor, "fps_show",
+				     &sti_drm_fps_fops);
+	if (ret)
+		goto err;
+
+	ret = drm_debugfs_create_files(sti_drm_dbg_list,
+				       ARRAY_SIZE(sti_drm_dbg_list),
+				       minor->debugfs_root, minor);
+	if (ret)
+		goto err;
+
+	DRM_INFO("%s debugfs installed\n", DRIVER_NAME);
+
+	return ret;
+err:
+	DRM_ERROR("Cannot install debugfs\n");
+	return ret;
+}
+
+void sti_drm_dbg_cleanup(struct drm_minor *minor)
+{
+	drm_debugfs_remove_files(sti_drm_dbg_list,
+				 ARRAY_SIZE(sti_drm_dbg_list), minor);
+
+	drm_debugfs_remove_files((struct drm_info_list *)&sti_drm_fps_fops,
+				 1, minor);
+}
+#endif
+
+static void sti_drm_mode_config_init(struct drm_device *dev)
+{
+	dev->mode_config.min_width = 0;
+	dev->mode_config.min_height = 0;
+
+	/*
+	 * set max width and height as default value.
+	 * this value would be used to check framebuffer size limitation
+	 * at drm_mode_addfb().
+	 */
+	dev->mode_config.max_width = STI_MAX_FB_HEIGHT;
+	dev->mode_config.max_height = STI_MAX_FB_WIDTH;
+
+	dev->mode_config.funcs = &sti_drm_mode_config_funcs;
+}
+
+static int sti_drm_load(struct drm_device *dev, unsigned long flags)
+{
+	struct sti_drm_private *private;
+	int err;
+
+	DRM_INFO("%s drm_device: %p\n", __func__, dev);
+
+	private = kzalloc(sizeof(struct sti_drm_private), GFP_KERNEL);
+	if (!private) {
+		DRM_ERROR("Failed to allocate private\n");
+		return -ENOMEM;
+	}
+	dev->dev_private = (void *)private;
+
+	drm_mode_config_init(dev);
+	drm_kms_helper_poll_init(dev);
+
+	sti_drm_mode_config_init(dev);
+
+	component_bind_all(dev->dev, dev);
+
+	drm_helper_disable_unused_functions(dev);
+#ifdef CONFIG_DRM_STI_FBDEV
+	sti_drm_device = dev;
+
+	schedule_delayed_work(&sti_fbdev_work,
+			      msecs_to_jiffies(FBDEV_CREATE_DELAY));
+#endif
+	return err;
+}
+
+static const struct file_operations sti_drm_driver_fops = {
+	.owner = THIS_MODULE,
+	.open = drm_open,
+	.mmap = drm_gem_cma_mmap,
+	.poll = drm_poll,
+	.read = drm_read,
+	.unlocked_ioctl = drm_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
+	.release = drm_release,
+};
+
+static struct dma_buf *sti_drm_gem_prime_export(struct drm_device *dev,
+						struct drm_gem_object *obj,
+						int flags)
+{
+	/* we want to be able to write in mmapped buffer */
+	flags |= O_RDWR;
+	return drm_gem_prime_export(dev, obj, flags);
+}
+
+static struct drm_driver sti_drm_driver = {
+	.driver_features = DRIVER_HAVE_IRQ | DRIVER_MODESET |
+	    DRIVER_GEM | DRIVER_PRIME,
+	.load = sti_drm_load,
+	.gem_free_object = drm_gem_cma_free_object,
+	.gem_vm_ops = &drm_gem_cma_vm_ops,
+	.dumb_create = drm_gem_cma_dumb_create,
+	.dumb_map_offset = drm_gem_cma_dumb_map_offset,
+	.dumb_destroy = drm_gem_dumb_destroy,
+	.fops = &sti_drm_driver_fops,
+
+	.get_vblank_counter = drm_vblank_count,
+	.enable_vblank = sti_drm_crtc_enable_vblank,
+	.disable_vblank = sti_drm_crtc_disable_vblank,
+
+	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
+	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
+	.gem_prime_export = sti_drm_gem_prime_export,
+	.gem_prime_import = drm_gem_prime_import,
+	.gem_prime_get_sg_table = drm_gem_cma_prime_get_sg_table,
+	.gem_prime_import_sg_table = drm_gem_cma_prime_import_sg_table,
+	.gem_prime_vmap = drm_gem_cma_prime_vmap,
+	.gem_prime_vunmap = drm_gem_cma_prime_vunmap,
+	.gem_prime_mmap = drm_gem_cma_prime_mmap,
+
+#ifdef CONFIG_DEBUG_FS
+	.debugfs_init = sti_drm_dbg_init,
+	.debugfs_cleanup = sti_drm_dbg_cleanup,
+#endif
+	.name = DRIVER_NAME,
+	.desc = DRIVER_DESC,
+	.date = DRIVER_DATE,
+	.major = DRIVER_MAJOR,
+	.minor = DRIVER_MINOR,
+};
+
+static int compare_of(struct device *dev, void *data)
+{
+	return 1;
+}
+
+static int sti_drm_add_components(struct device *master, struct master *m)
+{
+	struct device_node *np	= master->of_node;
+	struct device_node *child_np;
+
+	child_np = of_get_next_available_child(np, NULL);
+
+	while (child_np) {
+		DRM_INFO("add child %s\n", child_np->name);
+		component_master_add_child(m, compare_of, child_np);
+		of_node_put(child_np);
+		child_np = of_get_next_available_child(np, child_np);
+	}
+
+	return 0;
+}
+
+static int sti_drm_bind(struct device *dev)
+{
+	return drm_platform_init(&sti_drm_driver, to_platform_device(dev));
+}
+
+static void sti_drm_unbind(struct device *dev)
+{
+	drm_put_dev(dev_get_drvdata(dev));
+}
+
+static const struct component_master_ops sti_drm_ops = {
+	.add_components = sti_drm_add_components,
+	.bind = sti_drm_bind,
+	.unbind = sti_drm_unbind,
+};
+
+static int sti_drm_platform_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+
+	DRM_INFO("%s\n", __func__);
+
+	of_platform_populate(node, NULL, NULL, dev);
+
+	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+
+	return component_master_add(&pdev->dev, &sti_drm_ops);
+}
+
+static int sti_drm_platform_remove(struct platform_device *pdev)
+{
+	DRM_INFO("%s\n", __func__);
+
+	component_master_del(&pdev->dev, &sti_drm_ops);
+
+	return 0;
+}
+
+static const struct of_device_id sti_drm_dt_ids[] = {
+	{ .compatible = "st,sti-display-subsystem", },
+	{ /* end node */ },
+};
+MODULE_DEVICE_TABLE(of, sti_drm_dt_ids);
+
+static struct platform_driver sti_drm_platform_driver = {
+	.probe = sti_drm_platform_probe,
+	.remove = sti_drm_platform_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRIVER_NAME,
+		.of_match_table = sti_drm_dt_ids,
+	},
+};
+
+module_platform_driver(sti_drm_platform_driver);
+
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics SoC DRM driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/sti/sti_drm_encoder.c b/drivers/gpu/drm/sti/sti_drm_encoder.c
new file mode 100644
index 0000000..96194cf
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_encoder.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+
+#include "sti_drm_crtc.h"
+#include "sti_drm_encoder.h"
+#include "sti_tvout.h"
+
+#define to_sti_encoder(x) container_of(x, struct sti_encoder, drm_encoder)
+
+#define ENCODER_MAIN_CRTC_MASK (1 << 0)
+
+/*
+ * sti specific encoder structure.
+ *
+ * @drm_encoder: encoder object.
+ * @tvout: pointer on tvout driver.
+ * @type: tvout connector type.
+ */
+struct sti_encoder {
+	struct drm_encoder drm_encoder;
+	struct sti_tvout *tvout;
+	enum sti_tvout_connector_type type;
+};
+
+static void sti_drm_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+}
+
+static bool sti_drm_encoder_mode_fixup(struct drm_encoder *encoder,
+				       const struct drm_display_mode *mode,
+				       struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void sti_drm_encoder_mode_set(struct drm_encoder *encoder,
+				     struct drm_display_mode *mode,
+				     struct drm_display_mode *adjusted_mode)
+{
+	struct sti_encoder *sti_encoder = to_sti_encoder(encoder);
+	struct drm_device *dev = encoder->dev;
+	struct drm_connector *connector;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		if (connector->encoder == encoder) {
+			sti_tvout_set_mode(sti_encoder->tvout, mode,
+					   sti_encoder->type);
+			break;
+		}
+	}
+}
+
+static void sti_drm_encoder_prepare(struct drm_encoder *encoder)
+{
+	struct sti_encoder *sti_encoder = to_sti_encoder(encoder);
+	struct drm_device *dev = encoder->dev;
+	struct drm_connector *connector;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		if (connector->encoder == encoder) {
+			sti_tvout_prepare(sti_encoder->tvout,
+					  sti_encoder->type);
+			break;
+		}
+	}
+}
+
+static void sti_drm_encoder_commit(struct drm_encoder *encoder)
+{
+	struct sti_encoder *sti_encoder = to_sti_encoder(encoder);
+	struct drm_device *dev = encoder->dev;
+	struct drm_connector *connector;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		if (connector->encoder == encoder) {
+			sti_tvout_commit(sti_encoder->tvout,
+					 sti_encoder->type,
+					 sti_drm_crtc_is_main(encoder->crtc));
+			break;
+		}
+	}
+}
+
+static void sti_drm_encoder_disable(struct drm_encoder *encoder)
+{
+	struct sti_encoder *sti_encoder = to_sti_encoder(encoder);
+	struct drm_device *dev = encoder->dev;
+	struct drm_connector *connector;
+	struct drm_connector_helper_funcs *connector_funcs;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		connector_funcs = connector->helper_private;
+		if (connector_funcs->best_encoder(connector) == encoder) {
+			sti_tvout_disable(sti_encoder->tvout,
+					  sti_encoder->type);
+			break;
+		}
+	}
+}
+
+static const struct drm_encoder_helper_funcs sti_drm_encoder_helper_funcs = {
+	.dpms = sti_drm_encoder_dpms,
+	.mode_fixup = sti_drm_encoder_mode_fixup,
+	.mode_set = sti_drm_encoder_mode_set,
+	.prepare = sti_drm_encoder_prepare,
+	.commit = sti_drm_encoder_commit,
+	.disable = sti_drm_encoder_disable,
+};
+
+static void sti_drm_encoder_destroy(struct drm_encoder *encoder)
+{
+	struct sti_encoder *sti_encoder = to_sti_encoder(encoder);
+	struct drm_device *dev = encoder->dev;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	drm_encoder_cleanup(encoder);
+	kfree(sti_encoder);
+}
+
+static const struct drm_encoder_funcs sti_drm_encoder_funcs = {
+	.destroy = sti_drm_encoder_destroy,
+};
+
+struct drm_encoder *sti_drm_encoder_create(struct drm_device *dev,
+					   struct sti_tvout *tvout,
+					   unsigned int possible_crtcs,
+					   enum sti_tvout_connector_type type)
+{
+	struct sti_encoder *sti_encoder;
+	struct drm_encoder *encoder;
+	int encoder_type;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	if (!dev || !tvout || !possible_crtcs)
+		return NULL;
+
+	sti_encoder = kzalloc(sizeof(*sti_encoder), GFP_KERNEL);
+	if (!sti_encoder) {
+		DRM_ERROR("failed to allocate encoder\n");
+		return NULL;
+	}
+
+	sti_encoder->tvout = tvout;
+	sti_encoder->type = type;
+	encoder = &sti_encoder->drm_encoder;
+	encoder->possible_crtcs = possible_crtcs;
+
+	/* HDMI connector only supports main crtc */
+	if (type == STI_TVOUT_CONNECTOR_HDMI)
+		encoder->possible_crtcs &= ENCODER_MAIN_CRTC_MASK;
+
+	/* HD Analog connector may support aux CRTC. Not implemented yet */
+	if (type == STI_TVOUT_CONNECTOR_HDA)
+		encoder->possible_crtcs &= ENCODER_MAIN_CRTC_MASK;
+
+	DRM_DEBUG_DRIVER("possible_crtcs = 0x%x\n", encoder->possible_crtcs);
+
+	switch (type) {
+	case STI_TVOUT_CONNECTOR_HDMI:
+		encoder_type = DRM_MODE_ENCODER_TMDS;
+		encoder->possible_clones = 1 << STI_TVOUT_CONNECTOR_HDA;
+		break;
+	case STI_TVOUT_CONNECTOR_HDA:
+		encoder_type = DRM_MODE_ENCODER_DAC;
+		encoder->possible_clones = 1 << STI_TVOUT_CONNECTOR_HDMI;
+		break;
+	case STI_TVOUT_CONNECTOR_DENC:
+		encoder_type = DRM_MODE_ENCODER_DAC;
+		break;
+	case STI_TVOUT_CONNECTOR_DVO:
+		encoder_type = DRM_MODE_ENCODER_LVDS;
+		break;
+	default:
+		encoder_type = DRM_MODE_ENCODER_NONE;
+		break;
+	}
+
+	drm_encoder_init(dev, encoder, &sti_drm_encoder_funcs, encoder_type);
+
+	drm_encoder_helper_add(encoder, &sti_drm_encoder_helper_funcs);
+
+	DRM_DEBUG_DRIVER("encoder has been created\n");
+
+	return encoder;
+}
diff --git a/drivers/gpu/drm/sti/sti_drm_encoder.h b/drivers/gpu/drm/sti/sti_drm_encoder.h
new file mode 100644
index 0000000..35d9945
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_encoder.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_DRM_ENCODER_H_
+#define _STI_DRM_ENCODER_H_
+
+#include "sti_tvout.h"
+
+struct drm_encoder *sti_drm_encoder_create(struct drm_device *dev,
+		struct sti_tvout *tvout, unsigned int possible_crtcs,
+		enum sti_tvout_connector_type type);
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_drm_plane.c b/drivers/gpu/drm/sti/sti_drm_plane.c
new file mode 100644
index 0000000..e34c33a
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_plane.c
@@ -0,0 +1,195 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+#include "sti_drm_drv.h"
+#include "sti_drm_plane.h"
+#include "sti_compositor.h"
+#include "sti_vtg_utils.h"
+
+enum sti_layer_desc sti_layer_default_zorder[] = {
+	STI_GDP_0,
+	STI_VID_0,
+	STI_GDP_1,
+	STI_VID_1,
+	STI_GDP_2,
+	STI_GDP_3,
+};
+
+/* (Background) < GDP0 < VID0 < GDP1 < VID1 < GDP2 < GDP3 < (ForeGround) */
+
+static int
+sti_drm_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
+		     struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+		     unsigned int crtc_w, unsigned int crtc_h,
+		     uint32_t src_x, uint32_t src_y,
+		     uint32_t src_w, uint32_t src_h)
+{
+	struct sti_layer *layer = to_sti_layer(plane);
+	struct sti_mixer *mixer = to_sti_mixer(crtc);
+	int res;
+
+	DRM_DEBUG_KMS("CRTC:%d (%s) drm plane:%d (%s) drm fb:%d\n",
+		      crtc->base.id, sti_mixer_to_str(mixer),
+		      plane->base.id, sti_layer_to_str(layer), fb->base.id);
+	DRM_DEBUG_KMS("(%dx%d)@(%d,%d)\n", crtc_w, crtc_h, crtc_x, crtc_y);
+
+	res = sti_mixer_set_layer_depth(mixer, layer);
+	if (res) {
+		DRM_ERROR("Can not set layer depth\n");
+		return res;
+	}
+
+	/* src_x are in 16.16 format. */
+	res = sti_layer_prepare(layer, fb, &crtc->mode, mixer->id,
+			crtc_x, crtc_y, crtc_w, crtc_h,
+			src_x >> 16, src_y >> 16,
+			src_w >> 16, src_h >> 16);
+	if (res) {
+		DRM_ERROR("Layer prepare failed\n");
+		return res;
+	}
+
+	res = sti_layer_commit(layer);
+	if (res) {
+		DRM_ERROR("Layer commit failed\n");
+		return res;
+	}
+
+	res = sti_mixer_set_layer_status(mixer, layer, true);
+	if (res) {
+		DRM_ERROR("Can not enable layer at mixer\n");
+		return res;
+	}
+
+	return 0;
+}
+
+static int sti_drm_disable_plane(struct drm_plane *plane)
+{
+	struct sti_layer *layer;
+	struct sti_mixer *mixer;
+	int lay_res, mix_res;
+
+	if (!plane->crtc) {
+		DRM_DEBUG_DRIVER("drm plane:%d not enabled\n", plane->base.id);
+		return 0;
+	}
+	layer = to_sti_layer(plane);
+	mixer = to_sti_mixer(plane->crtc);
+
+	DRM_DEBUG_DRIVER("CRTC:%d (%s) drm plane:%d (%s)\n",
+			plane->crtc->base.id, sti_mixer_to_str(mixer),
+			plane->base.id, sti_layer_to_str(layer));
+
+	/* Disable layer at mixer level */
+	mix_res = sti_mixer_set_layer_status(mixer, layer, false);
+	if (mix_res)
+		DRM_ERROR("Can not disable layer at mixer\n");
+
+	/* Wait a while to be sure that a Vsync event is received */
+	msleep(WAIT_NEXT_VSYNC_MS);
+
+	/* Then disable layer itself */
+	lay_res = sti_layer_disable(layer);
+	if (lay_res)
+		DRM_ERROR("Layer disable failed\n");
+
+	if (lay_res || mix_res)
+		return 1;
+	else
+		return 0;
+}
+
+static void sti_drm_plane_destroy(struct drm_plane *plane)
+{
+	DRM_DEBUG_DRIVER("\n");
+
+	sti_drm_disable_plane(plane);
+	drm_plane_cleanup(plane);
+}
+
+static int sti_drm_plane_set_property(struct drm_plane *plane,
+				      struct drm_property *property,
+				      uint64_t val)
+{
+	struct drm_device *dev = plane->dev;
+	struct sti_drm_private *private = dev->dev_private;
+	struct sti_layer *layer = to_sti_layer(plane);
+
+	DRM_DEBUG_DRIVER("\n");
+
+	if (property == private->plane_zorder_property) {
+		layer->zorder = val;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct drm_plane_funcs sti_drm_plane_funcs = {
+	.update_plane = sti_drm_update_plane,
+	.disable_plane = sti_drm_disable_plane,
+	.destroy = sti_drm_plane_destroy,
+	.set_property = sti_drm_plane_set_property,
+};
+
+static void sti_drm_plane_attach_zorder_property(struct drm_plane *plane,
+						 uint64_t default_val)
+{
+	struct drm_device *dev = plane->dev;
+	struct sti_drm_private *private = dev->dev_private;
+	struct drm_property *prop;
+	struct sti_layer *layer = to_sti_layer(plane);
+
+	dev_dbg(dev->dev, "%s zorder:%llu\n", __func__, default_val);
+
+	prop = private->plane_zorder_property;
+	if (!prop) {
+		prop = drm_property_create_range(dev, 0, "zpos", 0,
+						 GAM_MIXER_NB_DEPTH_LEVEL - 1);
+		if (!prop)
+			return;
+
+		private->plane_zorder_property = prop;
+	}
+
+	drm_object_attach_property(&plane->base, prop, default_val);
+	layer->zorder = default_val;
+}
+
+struct drm_plane *sti_drm_plane_init(struct drm_device *dev,
+				     struct sti_layer *layer,
+				     unsigned int possible_crtcs)
+{
+	int err, i;
+	uint64_t default_zorder = 0;
+
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	err = drm_plane_init(dev, &layer->plane, possible_crtcs,
+			     &sti_drm_plane_funcs,
+			     sti_layer_get_formats(layer),
+			     sti_layer_get_nb_formats(layer), false);
+	if (err) {
+		DRM_ERROR("Failed to initialize plane\n");
+		return NULL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sti_layer_default_zorder); i++)
+		if (sti_layer_default_zorder[i] == layer->desc)
+			break;
+
+	default_zorder = i;
+
+	sti_drm_plane_attach_zorder_property(&layer->plane, default_zorder);
+
+	DRM_DEBUG_DRIVER("drm plane:%d mapped to %s with zorder:%llu\n",
+			 layer->plane.base.id,
+			 sti_layer_to_str(layer), default_zorder);
+
+	return &layer->plane;
+}
diff --git a/drivers/gpu/drm/sti/sti_drm_plane.h b/drivers/gpu/drm/sti/sti_drm_plane.h
new file mode 100644
index 0000000..d182066
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_plane.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_DRM_PLANE_H_
+#define _STI_DRM_PLANE_H_
+
+#include <drm/drmP.h>
+#include "sti_layer.h"
+
+struct drm_plane *sti_drm_plane_init(struct drm_device *dev,
+		struct sti_layer *layer, unsigned int possible_crtcs);
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_tvout.c b/drivers/gpu/drm/sti/sti_tvout.c
index fb199c4..c25a104 100644
--- a/drivers/gpu/drm/sti/sti_tvout.c
+++ b/drivers/gpu/drm/sti/sti_tvout.c
@@ -19,6 +19,8 @@
 #include "sti_hdmi.h"
 #include "sti_hda.h"
 #include "sti_drm_drv.h"
+#include "sti_drm_encoder.h"
+#include "sti_drm_connector.h"
 
 /* glue regsiters */
 #define TVO_CSC_MAIN_M0                  0x000
@@ -788,6 +790,25 @@ int sti_tvout_hda_dbg_show(struct seq_file *m, void *arg)
 
 static int sti_tvout_bind(struct device *dev, struct device *master, void *data)
 {
+	struct sti_tvout *tvout = dev_get_drvdata(dev);
+	struct drm_device *drm_dev = data;
+	struct drm_encoder *encoder;
+	int i;
+	struct sti_drm_private *dev_priv = drm_dev->dev_private;
+
+	dev_priv->tvout = tvout;
+
+	tvout->drm_dev = drm_dev;
+
+	/* Register all encoder/connector couples supported by tvout */
+	for (i = 0; i < STI_TVOUT_CONNECTOR_MAX; i++) {
+		if (tvout->connector_create[i] != NULL) {
+			encoder = sti_drm_encoder_create(drm_dev, tvout,
+							 1 << 0, i);
+			sti_drm_connector_create(drm_dev, tvout, encoder, i);
+		}
+	}
+
 	return 0;
 }
 
-- 
1.9.1

