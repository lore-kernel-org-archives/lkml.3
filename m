Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaG3Rm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:42:56 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46035 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbaG3Rmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:42:51 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v8 11/11] drm: sti: Add DRM driver itself
Date: Wed, 30 Jul 2014 19:42:07 +0200
Message-Id: <1406742127-27654-12-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the link between all the hardware drivers and DRM/KMS interface.
Create the driver itself and make it register all the sub-components.
Use GEM CMA helpers for buffer allocation.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 drivers/gpu/drm/sti/Kconfig          |   8 +
 drivers/gpu/drm/sti/Makefile         |   7 +-
 drivers/gpu/drm/sti/sti_compositor.c |  43 ++++
 drivers/gpu/drm/sti/sti_drm_crtc.c   | 423 +++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_drm_crtc.h   |  22 ++
 drivers/gpu/drm/sti/sti_drm_drv.c    | 241 ++++++++++++++++++++
 drivers/gpu/drm/sti/sti_drm_drv.h    |  29 +++
 drivers/gpu/drm/sti/sti_drm_plane.c  | 195 ++++++++++++++++
 drivers/gpu/drm/sti/sti_drm_plane.h  |  18 ++
 9 files changed, 984 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.h

diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
index 11d372c..2d9d425 100644
--- a/drivers/gpu/drm/sti/Kconfig
+++ b/drivers/gpu/drm/sti/Kconfig
@@ -1,6 +1,14 @@
 config DRM_STI
 	tristate "DRM Support for STMicroelectronics SoC stiH41x Series"
 	depends on DRM && (SOC_STIH415 || SOC_STIH416 || ARCH_MULTIPLATFORM)
+	select DRM_KMS_HELPER
+	select DRM_GEM_CMA_HELPER
 	select DRM_KMS_CMA_HELPER
 	help
 	  Choose this option to enable DRM on STM stiH41x chipset
+
+config DRM_STI_FBDEV
+	bool "DRM frame buffer device for STMicroelectronics SoC stiH41x Serie"
+	depends on DRM_STI
+	help
+	  Choose this option to enable FBDEV on top of DRM for STM stiH41x chipset
diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index c5838f2..04ac2ce 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -3,7 +3,9 @@ sticompositor-y := \
 	sti_mixer.o \
 	sti_gdp.o \
 	sti_vid.o \
-	sti_compositor.o
+	sti_compositor.o \
+	sti_drm_crtc.o \
+	sti_drm_plane.o
 
 stihdmi-y := sti_hdmi.o \
 	sti_hdmi_tx3g0c55phy.o \
@@ -15,4 +17,5 @@ obj-$(CONFIG_DRM_STI) = \
 	stihdmi.o \
 	sti_hda.o \
 	sti_tvout.o \
-	sticompositor.o
\ No newline at end of file
+	sticompositor.o \
+	sti_drm_drv.o
\ No newline at end of file
diff --git a/drivers/gpu/drm/sti/sti_compositor.c b/drivers/gpu/drm/sti/sti_compositor.c
index a4164cf..9efd017 100644
--- a/drivers/gpu/drm/sti/sti_compositor.c
+++ b/drivers/gpu/drm/sti/sti_compositor.c
@@ -14,6 +14,9 @@
 #include <drm/drmP.h>
 
 #include "sti_compositor.h"
+#include "sti_drm_crtc.h"
+#include "sti_drm_drv.h"
+#include "sti_drm_plane.h"
 #include "sti_gdp.h"
 #include "sti_vtg.h"
 
@@ -87,11 +90,50 @@ static int sti_compositor_bind(struct device *dev, struct device *master,
 	struct sti_compositor *compo = dev_get_drvdata(dev);
 	struct drm_device *drm_dev = data;
 	unsigned int i, crtc = 0, plane = 0;
+	struct sti_drm_private *dev_priv = drm_dev->dev_private;
+	struct drm_plane *cursor = NULL;
+	struct drm_plane *primary = NULL;
+
+	dev_priv->compo = compo;
 
 	drm_vblank_init(drm_dev, crtc);
 	/* Allow usage of vblank without having to call drm_irq_install */
 	drm_dev->irq_enabled = 1;
 
+	for (i = 0; i < compo->nb_layers; i++) {
+		if (compo->layer[i]) {
+			enum sti_layer_desc desc = compo->layer[i]->desc;
+			enum sti_layer_type type = desc & STI_LAYER_TYPE_MASK;
+			enum drm_plane_type plane_type = DRM_PLANE_TYPE_OVERLAY;
+
+			if (compo->mixer[crtc])
+				plane_type = DRM_PLANE_TYPE_PRIMARY;
+
+			switch (type) {
+			case STI_CUR:
+				cursor = sti_drm_plane_init(drm_dev,
+						compo->layer[i],
+						(1 << crtc) - 1,
+						DRM_PLANE_TYPE_CURSOR);
+				break;
+			case STI_GDP:
+			case STI_VID:
+				primary = sti_drm_plane_init(drm_dev,
+						compo->layer[i],
+						(1 << crtc) - 1, plane_type);
+				plane++;
+				break;
+			}
+
+			/* The first planes are reserved for primary planes*/
+			if (compo->mixer[crtc]) {
+				sti_drm_crtc_init(drm_dev, compo->mixer[crtc],
+						primary, cursor);
+				crtc++;
+				cursor = NULL;
+			}
+		}
+	}
 
 	DRM_DEBUG_DRIVER("Initialized %d DRM CRTC(s) and %d DRM plane(s)\n",
 			 crtc, plane);
@@ -139,6 +181,7 @@ static int sti_compositor_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	compo->dev = dev;
+	compo->vtg_vblank_nb.notifier_call = sti_drm_crtc_vblank_cb;
 
 	/* populate data structure depending on compatibility */
 	BUG_ON(!of_match_node(compositor_of_match, np)->data);
diff --git a/drivers/gpu/drm/sti/sti_drm_crtc.c b/drivers/gpu/drm/sti/sti_drm_crtc.c
new file mode 100644
index 0000000..6eba648
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_crtc.c
@@ -0,0 +1,423 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
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
+#include "sti_compositor.h"
+#include "sti_drm_drv.h"
+#include "sti_drm_crtc.h"
+#include "sti_vtg.h"
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
+	if ((!mixer || !compo)) {
+		DRM_ERROR("Can not find mixer or compositor)\n");
+		return;
+	}
+
+	/* get GDP which is reserved to the CRTC FB */
+	layer = to_sti_layer(crtc->primary);
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
+		      crtc->primary->fb->base.id, mode->base.id, mode->name);
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
+		return -EINVAL;
+	}
+	if (clk_prepare_enable(clk)) {
+		DRM_ERROR("Failed to prepare/enable pix clk\n");
+		return -EINVAL;
+	}
+
+	sti_vtg_set_config(mixer->id == STI_MIXER_MAIN ?
+			compo->vtg_main : compo->vtg_aux, &crtc->mode);
+
+	/* a GDP is reserved to the CRTC FB */
+	layer = to_sti_layer(crtc->primary);
+	if (!layer) {
+		DRM_ERROR("Can not find GDP0)\n");
+		return -EINVAL;
+	}
+
+	/* copy the mode data adjusted by mode_fixup() into crtc->mode
+	 * so that hardware can be set to proper mode
+	 */
+	memcpy(&crtc->mode, adjusted_mode, sizeof(*adjusted_mode));
+
+	res = sti_mixer_set_layer_depth(mixer, layer);
+	if (res) {
+		DRM_ERROR("Can not set layer depth\n");
+		return -EINVAL;
+	}
+	res = sti_mixer_active_video_area(mixer, &crtc->mode);
+	if (res) {
+		DRM_ERROR("Can not set active video area\n");
+		return -EINVAL;
+	}
+
+	w = crtc->primary->fb->width - x;
+	h = crtc->primary->fb->height - y;
+
+	return sti_layer_prepare(layer, crtc->primary->fb, &crtc->mode,
+			mixer->id, 0, 0, w, h, x, y, w, h);
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
+	int ret;
+
+	DRM_DEBUG_KMS("CRTC:%d (%s) fb:%d (%d,%d)\n",
+		      crtc->base.id, sti_mixer_to_str(mixer),
+		      crtc->primary->fb->base.id, x, y);
+
+	/* GDP is reserved to the CRTC FB */
+	layer = to_sti_layer(crtc->primary);
+	if (!layer) {
+		DRM_ERROR("Can not find GDP0)\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	w = crtc->primary->fb->width - crtc->x;
+	h = crtc->primary->fb->height - crtc->y;
+
+	ret = sti_layer_prepare(layer, crtc->primary->fb, &crtc->mode,
+				mixer->id, 0, 0, w, h,
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
+	/* do nothing */
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
+	/* Disable GDP */
+	layer = to_sti_layer(crtc->primary);
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
+	struct drm_framebuffer *old_fb;
+	struct sti_mixer *mixer = to_sti_mixer(crtc);
+	unsigned long flags;
+	int ret;
+
+	DRM_DEBUG_KMS("fb %d --> fb %d\n",
+			crtc->primary->fb->base.id, fb->base.id);
+
+	mutex_lock(&drm_dev->struct_mutex);
+
+	old_fb = crtc->primary->fb;
+	crtc->primary->fb = fb;
+	ret = sti_drm_crtc_mode_set_base(crtc, crtc->x, crtc->y, old_fb);
+	if (ret) {
+		DRM_ERROR("failed\n");
+		crtc->primary->fb = old_fb;
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
+		if (mixer->pending_event) {
+			drm_vblank_put(drm_dev, event->pipe);
+			ret = -EBUSY;
+		} else {
+			mixer->pending_event = event;
+		}
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
+	drm_crtc_cleanup(crtc);
+}
+
+static int sti_drm_crtc_set_property(struct drm_crtc *crtc,
+				     struct drm_property *property,
+				     uint64_t val)
+{
+	DRM_DEBUG_KMS("\n");
+	return 0;
+}
+
+int sti_drm_crtc_vblank_cb(struct notifier_block *nb,
+			   unsigned long event, void *data)
+{
+	struct drm_device *drm_dev;
+	struct sti_compositor *compo =
+		container_of(nb, struct sti_compositor, vtg_vblank_nb);
+	int *crtc = data;
+	unsigned long flags;
+	struct sti_drm_private *priv;
+
+	drm_dev = compo->mixer[*crtc]->drm_crtc.dev;
+	priv = drm_dev->dev_private;
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
+	if (compo->mixer[*crtc]->pending_event) {
+		drm_send_vblank_event(drm_dev, -1,
+				compo->mixer[*crtc]->pending_event);
+		drm_vblank_put(drm_dev, *crtc);
+		compo->mixer[*crtc]->pending_event = NULL;
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
+
+	if (sti_vtg_register_client(crtc == STI_MIXER_MAIN ?
+			compo->vtg_main : compo->vtg_aux,
+			vtg_vblank_nb, crtc)) {
+		DRM_ERROR("Cannot register VTG notifier\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(sti_drm_crtc_enable_vblank);
+
+void sti_drm_crtc_disable_vblank(struct drm_device *dev, int crtc)
+{
+	struct sti_drm_private *priv = dev->dev_private;
+	struct sti_compositor *compo = priv->compo;
+	struct notifier_block *vtg_vblank_nb = &compo->vtg_vblank_nb;
+	unsigned long flags;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	if (sti_vtg_unregister_client(crtc == STI_MIXER_MAIN ?
+			compo->vtg_main : compo->vtg_aux, vtg_vblank_nb))
+		DRM_DEBUG_DRIVER("Warning: cannot unregister VTG notifier\n");
+
+	/* free the resources of the pending requests */
+	spin_lock_irqsave(&dev->event_lock, flags);
+	if (compo->mixer[crtc]->pending_event) {
+		drm_vblank_put(dev, crtc);
+		compo->mixer[crtc]->pending_event = NULL;
+	}
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+}
+EXPORT_SYMBOL(sti_drm_crtc_disable_vblank);
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
+int sti_drm_crtc_init(struct drm_device *drm_dev, struct sti_mixer *mixer,
+		struct drm_plane *primary, struct drm_plane *cursor)
+{
+	struct drm_crtc *crtc = &mixer->drm_crtc;
+	int res;
+
+	res = drm_crtc_init_with_planes(drm_dev, crtc, primary, cursor,
+			&sti_crtc_funcs);
+	if (res) {
+		DRM_ERROR("Can not initialze CRTC\n");
+		return -EINVAL;
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
index 0000000..caca8b1
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_crtc.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_DRM_CRTC_H_
+#define _STI_DRM_CRTC_H_
+
+#include <drm/drmP.h>
+
+struct sti_mixer;
+
+int sti_drm_crtc_init(struct drm_device *drm_dev, struct sti_mixer *mixer,
+		struct drm_plane *primary, struct drm_plane *cursor);
+int sti_drm_crtc_enable_vblank(struct drm_device *dev, int crtc);
+void sti_drm_crtc_disable_vblank(struct drm_device *dev, int crtc);
+int sti_drm_crtc_vblank_cb(struct notifier_block *nb,
+		unsigned long event, void *data);
+bool sti_drm_crtc_is_main(struct drm_crtc *drm_crtc);
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_drm_drv.c b/drivers/gpu/drm/sti/sti_drm_drv.c
new file mode 100644
index 0000000..a7cc249
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_drv.c
@@ -0,0 +1,241 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
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
+
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+
+#include "sti_drm_drv.h"
+#include "sti_drm_crtc.h"
+
+#define DRIVER_NAME	"sti"
+#define DRIVER_DESC	"STMicroelectronics SoC DRM"
+#define DRIVER_DATE	"20140601"
+#define DRIVER_MAJOR	1
+#define DRIVER_MINOR	0
+
+#define STI_MAX_FB_HEIGHT	4096
+#define STI_MAX_FB_WIDTH	4096
+
+static struct drm_mode_config_funcs sti_drm_mode_config_funcs = {
+	.fb_create = drm_fb_cma_create,
+};
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
+	int ret;
+
+	private = kzalloc(sizeof(struct sti_drm_private), GFP_KERNEL);
+	if (!private) {
+		DRM_ERROR("Failed to allocate private\n");
+		return -ENOMEM;
+	}
+	dev->dev_private = (void *)private;
+	private->drm_dev = dev;
+
+	drm_mode_config_init(dev);
+	drm_kms_helper_poll_init(dev);
+
+	sti_drm_mode_config_init(dev);
+
+	ret = component_bind_all(dev->dev, dev);
+	if (ret)
+		return ret;
+
+	drm_helper_disable_unused_functions(dev);
+
+#ifdef CONFIG_DRM_STI_FBDEV
+	drm_fbdev_cma_init(dev, 32,
+		   dev->mode_config.num_crtc,
+		   dev->mode_config.num_connector);
+#endif
+	return 0;
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
+	.name = DRIVER_NAME,
+	.desc = DRIVER_DESC,
+	.date = DRIVER_DATE,
+	.major = DRIVER_MAJOR,
+	.minor = DRIVER_MINOR,
+};
+
+static int compare_of(struct device *dev, void *data)
+{
+	return dev->of_node == data;
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
+	.bind = sti_drm_bind,
+	.unbind = sti_drm_unbind,
+};
+
+static int sti_drm_master_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->parent->of_node;
+	struct device_node *child_np;
+	struct component_match *match = NULL;
+
+	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+
+	child_np = of_get_next_available_child(node, NULL);
+
+	while (child_np) {
+		component_match_add(dev, &match, compare_of, child_np);
+		of_node_put(child_np);
+		child_np = of_get_next_available_child(node, child_np);
+	}
+
+	return component_master_add_with_match(dev, &sti_drm_ops, match);
+}
+
+static int sti_drm_master_remove(struct platform_device *pdev)
+{
+	component_master_del(&pdev->dev, &sti_drm_ops);
+	return 0;
+}
+
+static struct platform_driver sti_drm_master_driver = {
+	.probe = sti_drm_master_probe,
+	.remove = sti_drm_master_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRIVER_NAME "__master",
+	},
+};
+
+static int sti_drm_platform_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct platform_device *master;
+
+	of_platform_populate(node, NULL, NULL, dev);
+
+	platform_driver_register(&sti_drm_master_driver);
+	master = platform_device_register_resndata(dev,
+			DRIVER_NAME "__master", -1,
+			NULL, 0, NULL, 0);
+	if (!master)
+		return -EINVAL;
+
+	platform_set_drvdata(pdev, master);
+	return 0;
+}
+
+static int sti_drm_platform_remove(struct platform_device *pdev)
+{
+	struct platform_device *master = platform_get_drvdata(pdev);
+
+	of_platform_depopulate(&pdev->dev);
+	platform_device_unregister(master);
+	platform_driver_unregister(&sti_drm_master_driver);
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
diff --git a/drivers/gpu/drm/sti/sti_drm_drv.h b/drivers/gpu/drm/sti/sti_drm_drv.h
new file mode 100644
index 0000000..ec5e2eb
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_drv.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_DRM_DRV_H_
+#define _STI_DRM_DRV_H_
+
+#include <drm/drmP.h>
+
+struct sti_compositor;
+struct sti_tvout;
+
+/**
+ * STI drm private structure
+ * This structure is stored as private in the drm_device
+ *
+ * @compo:                 compositor
+ * @plane_zorder_property: z-order property for CRTC planes
+ * @drm_dev:               drm device
+ */
+struct sti_drm_private {
+	struct sti_compositor *compo;
+	struct drm_property *plane_zorder_property;
+	struct drm_device *drm_dev;
+};
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_drm_plane.c b/drivers/gpu/drm/sti/sti_drm_plane.c
new file mode 100644
index 0000000..f4118d4
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_plane.c
@@ -0,0 +1,195 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "sti_compositor.h"
+#include "sti_drm_drv.h"
+#include "sti_drm_plane.h"
+#include "sti_vtg.h"
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
+		return -EINVAL;
+
+	return 0;
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
+				     unsigned int possible_crtcs,
+				     enum drm_plane_type type)
+{
+	int err, i;
+	uint64_t default_zorder = 0;
+
+	err = drm_universal_plane_init(dev, &layer->plane, possible_crtcs,
+			     &sti_drm_plane_funcs,
+			     sti_layer_get_formats(layer),
+			     sti_layer_get_nb_formats(layer), type);
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
+	if (type == DRM_PLANE_TYPE_OVERLAY)
+		sti_drm_plane_attach_zorder_property(&layer->plane,
+				default_zorder);
+
+	DRM_DEBUG_DRIVER("drm plane:%d mapped to %s with zorder:%llu\n",
+			 layer->plane.base.id,
+			 sti_layer_to_str(layer), default_zorder);
+
+	return &layer->plane;
+}
diff --git a/drivers/gpu/drm/sti/sti_drm_plane.h b/drivers/gpu/drm/sti/sti_drm_plane.h
new file mode 100644
index 0000000..4f19183
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_plane.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_DRM_PLANE_H_
+#define _STI_DRM_PLANE_H_
+
+#include <drm/drmP.h>
+
+struct sti_layer;
+
+struct drm_plane *sti_drm_plane_init(struct drm_device *dev,
+		struct sti_layer *layer,
+		unsigned int possible_crtcs,
+		enum drm_plane_type type);
+#endif
-- 
1.9.1

