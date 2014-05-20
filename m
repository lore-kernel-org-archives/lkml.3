Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaETN5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:57:19 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44929 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaETN5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:16 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 11/16] drm: sti: add Compositor
Date: Tue, 20 May 2014 15:56:21 +0200
Message-Id: <1400594186-8956-12-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compositor control all the input sub-devices and the mixer.
It is the main entry point for composition.
Layer interface is used to control the layer.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/Kconfig          |   1 +
 drivers/gpu/drm/sti/Makefile         |   2 +
 drivers/gpu/drm/sti/sti_compositor.c | 219 +++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_compositor.h |  84 ++++++++++
 drivers/gpu/drm/sti/sti_layer.c      | 309 +++++++++++++++++++++++++++++++++++
 5 files changed, 615 insertions(+)
 create mode 100644 drivers/gpu/drm/sti/sti_compositor.c
 create mode 100644 drivers/gpu/drm/sti/sti_compositor.h
 create mode 100644 drivers/gpu/drm/sti/sti_layer.c

diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
index 87e6128..76c2e4f 100644
--- a/drivers/gpu/drm/sti/Kconfig
+++ b/drivers/gpu/drm/sti/Kconfig
@@ -1,6 +1,7 @@
 config DRM_STI
 	bool "DRM Support for STMicroelectronics SoC stiH41x Series"
 	depends on DRM && (SOC_STIH415 || SOC_STIH416 || ARCH_MULTIPLATFORM)
+	select DRM_KMS_CMA_HELPER
 	help
 	  Choose this option to enable DRM on STM stiH41x chipset
 
diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index 3d52d2a..3b804d4 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -5,6 +5,8 @@ stidrm-y := sti_tvout.o \
 			sti_hdmi_tx3g0c55phy.o \
 			sti_hdmi_tx3g4c28phy.o \
 			sti_hda.o \
+			sti_compositor.o \
+			sti_layer.o \
 			sti_mixer.o \
 			sti_gdp.o \
 			sti_vid.o \
diff --git a/drivers/gpu/drm/sti/sti_compositor.c b/drivers/gpu/drm/sti/sti_compositor.c
new file mode 100644
index 0000000..0c9ef6d
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_compositor.c
@@ -0,0 +1,219 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/component.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#include <drm/drmP.h>
+
+#include "sti_compositor.h"
+#include "sti_gdp.h"
+
+static const struct of_device_id compositor_match_types[];
+
+/*
+ * stiH407 compositor properties
+ */
+struct sti_compositor_data stih407_compositor_data = {
+	.nb_subdev = 6,
+	.subdev_desc = {
+			{STI_GPD_SUBDEV, (int)STI_GDP_0, 0x100},
+			{STI_GPD_SUBDEV, (int)STI_GDP_1, 0x200},
+			{STI_GPD_SUBDEV, (int)STI_GDP_2, 0x300},
+			{STI_GPD_SUBDEV, (int)STI_GDP_3, 0x400},
+			{STI_VID_SUBDEV, (int)STI_VID_0, 0x700},
+			{STI_MIXER_MAIN_SUBDEV, STI_MIXER_MAIN, 0xC00}
+			},
+};
+
+/*
+ * stiH416 compositor properties
+ * Note:
+ * on stih416 MIXER_AUX has a different base address from MIXER_MAIN
+ * Moreover, GDPx is different for Main and Aux Mixer. So this subdev map does
+ * not fit for stiH416 if we want to enable the MIXER_AUX.
+ */
+struct sti_compositor_data stih416_compositor_data = {
+	.nb_subdev = 3,
+	.subdev_desc = {
+			{STI_GPD_SUBDEV, (int)STI_GDP_0, 0x100},
+			{STI_GPD_SUBDEV, (int)STI_GDP_1, 0x200},
+			{STI_MIXER_MAIN_SUBDEV, STI_MIXER_MAIN, 0xC00}
+			},
+};
+
+static int sti_compositor_init_subdev(struct sti_compositor *compo,
+		struct sti_compositor_subdev_descriptor *desc,
+		int array_size)
+{
+	int i, mixer_id = 0, layer_id = 0;
+
+	dev_dbg(compo->dev, "%s\n", __func__);
+	for (i = 0; i < array_size; i++) {
+		switch (desc[i].type) {
+		case STI_MIXER_MAIN_SUBDEV:
+		case STI_MIXER_AUX_SUBDEV:
+			compo->mixer[mixer_id++] =
+			    sti_mixer_create(compo->dev, desc[i].id,
+					     compo->regs + desc[i].offset);
+			break;
+		case STI_GPD_SUBDEV:
+		case STI_VID_SUBDEV:
+			compo->layer[layer_id++] =
+			    sti_layer_create(compo->dev, desc[i].id,
+					     compo->regs + desc[i].offset);
+			break;
+			/* case STI_CURSOR_SUBDEV : TODO */
+		default:
+			DRM_ERROR("Unknow subdev compoment type\n");
+			return 1;
+		}
+
+	}
+	compo->nb_mixers = mixer_id;
+	compo->nb_layers = layer_id;
+
+	return 0;
+}
+
+static int sti_compositor_bind(struct device *dev, struct device *master,
+	void *data)
+{
+	return 0;
+}
+
+static void sti_compositor_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	/* do nothing */
+}
+
+static const struct component_ops sti_compositor_ops = {
+	.bind	= sti_compositor_bind,
+	.unbind	= sti_compositor_unbind,
+};
+
+static int sti_compositor_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct sti_compositor *compo;
+	struct resource *res;
+	int err;
+
+	DRM_INFO("%s\n", __func__);
+	compo = devm_kzalloc(dev, sizeof(*compo), GFP_KERNEL);
+	if (!compo) {
+		DRM_ERROR("Failed to allocate compositor context\n");
+		return -ENOMEM;
+	}
+	DRM_DEBUG_DRIVER("Compositor %p\n", compo);
+	compo->dev = dev;
+
+	/* populate data structure depending on compatibility */
+	BUG_ON(!of_match_node(compositor_match_types, np)->data);
+
+	memcpy(&compo->data, of_match_node(compositor_match_types, np)->data,
+	       sizeof(struct sti_compositor_data));
+
+	/* Get Memory ressources */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		DRM_ERROR("Get memory resource failed\n");
+		return -ENXIO;
+	}
+	compo->regs = devm_ioremap(dev, res->start, resource_size(res));
+	if (compo->regs == NULL) {
+		DRM_ERROR("Register mapping failed\n");
+		return -ENXIO;
+	}
+
+	/* Get clock resources */
+	compo->clk_compo_main = devm_clk_get(dev, "compo_main");
+	if (IS_ERR(compo->clk_compo_main)) {
+		DRM_ERROR("Cannot get compo_main clock\n");
+		return PTR_ERR(compo->clk_compo_main);
+	}
+
+	compo->clk_compo_aux = devm_clk_get(dev, "compo_aux");
+	if (IS_ERR(compo->clk_compo_aux)) {
+		DRM_ERROR("Cannot get compo_aux clock\n");
+		return PTR_ERR(compo->clk_compo_aux);
+	}
+
+	compo->clk_pix_main = devm_clk_get(dev, "pix_main");
+	if (IS_ERR(compo->clk_pix_main)) {
+		DRM_ERROR("Cannot get pix_main clock\n");
+		return PTR_ERR(compo->clk_pix_main);
+	}
+
+	compo->clk_pix_aux = devm_clk_get(dev, "pix_aux");
+	if (IS_ERR(compo->clk_pix_aux)) {
+		DRM_ERROR("Cannot get pix_aux clock\n");
+		return PTR_ERR(compo->clk_pix_aux);
+	}
+
+	/* Get reset resources */
+	compo->rst_main = devm_reset_control_get(dev, "compo-main");
+	/* Take compo main out of reset */
+	if (!IS_ERR(compo->rst_main))
+		reset_control_deassert(compo->rst_main);
+
+	compo->rst_aux = devm_reset_control_get(dev, "compo-aux");
+	/* Take compo aux out of reset */
+	if (!IS_ERR(compo->rst_aux))
+		reset_control_deassert(compo->rst_aux);
+
+	/* Initialize compositor subdevices */
+	err = sti_compositor_init_subdev(compo, compo->data.subdev_desc,
+					 compo->data.nb_subdev);
+	if (err)
+		return err;
+
+	platform_set_drvdata(pdev, compo);
+
+	return component_add(&pdev->dev, &sti_compositor_ops);
+}
+
+static int sti_compositor_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &sti_compositor_ops);
+	return 0;
+}
+
+static const struct of_device_id compositor_match_types[] = {
+	{
+	 .compatible = "st,stih416-compositor",
+	 .data = &stih416_compositor_data,
+	 },
+	{
+	 .compatible = "st,stih407-compositor",
+	 .data = &stih407_compositor_data,
+	 },
+	{ /* end node */ }
+
+};
+MODULE_DEVICE_TABLE(of, compositor_match_types);
+
+static struct platform_driver sti_compositor_driver = {
+	.driver = {
+		   .name = "sti-compositor",
+		   .owner = THIS_MODULE,
+		   .of_match_table = compositor_match_types,
+		   },
+	.probe = sti_compositor_probe,
+	.remove = sti_compositor_remove,
+};
+
+module_platform_driver(sti_compositor_driver);
+
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics SoC DRM driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/sti/sti_compositor.h b/drivers/gpu/drm/sti/sti_compositor.h
new file mode 100644
index 0000000..599a60d
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_compositor.h
@@ -0,0 +1,84 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_COMPOSITOR_H_
+#define _STI_COMPOSITOR_H_
+
+#include <linux/clk.h>
+#include <linux/kernel.h>
+
+#include "sti_layer.h"
+#include "sti_mixer.h"
+
+#define STI_MAX_LAYER 8
+#define STI_MAX_MIXER 2
+
+enum sti_compositor_subdev_type {
+	STI_MIXER_MAIN_SUBDEV,
+	STI_MIXER_AUX_SUBDEV,
+	STI_GPD_SUBDEV,
+	STI_VID_SUBDEV,
+	STI_CURSOR_SUBDEV,
+};
+
+struct sti_compositor_subdev_descriptor {
+	enum sti_compositor_subdev_type type;
+	int id;
+	unsigned int offset;
+};
+
+/*
+ * STI Compositor data structure
+ *
+ * @nb_subdev: number of subdevices supported by the compositor
+ * @subdev_desc: subdev list description
+ */
+#define MAX_SUBDEV 9
+struct sti_compositor_data {
+	int nb_subdev;
+	struct sti_compositor_subdev_descriptor subdev_desc[MAX_SUBDEV];
+};
+
+/*
+ * STI Compositor structure
+ *
+ * @dev: driver device
+ * @regs: registers (main)
+ * @data: device data
+ * @clk_compo_main: clock for main compo
+ * @clk_compo_aux: clock for aux compo
+ * @clk_pix_main: pixel clock for main path
+ * @clk_pix_aux: pixel clock for aux path
+ * @rst_main: reset control of the main path
+ * @rst_aux: reset control of the aux path
+ * @mixer: array of mixers
+ * @layer: array of layers
+ * @nb_mixers: number of mixers for this compositor
+ * @nb_layers: number of layers (GDP,VID,...) for this compositor
+ * @enable: true if compositor is enable else false
+ * @vtg_vblank_nb: callback for VTG VSYNC notification
+ */
+struct sti_compositor {
+	struct device *dev;
+	void __iomem *regs;
+	struct sti_compositor_data data;
+	struct clk *clk_compo_main;
+	struct clk *clk_compo_aux;
+	struct clk *clk_pix_main;
+	struct clk *clk_pix_aux;
+	struct reset_control *rst_main;
+	struct reset_control *rst_aux;
+	struct sti_mixer *mixer[STI_MAX_MIXER];
+	struct sti_layer *layer[STI_MAX_LAYER];
+	int nb_mixers;
+	int nb_layers;
+	bool enable;
+	struct notifier_block vtg_vblank_nb;
+};
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_layer.c b/drivers/gpu/drm/sti/sti_layer.c
new file mode 100644
index 0000000..54c8694
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_layer.c
@@ -0,0 +1,309 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "sti_layer.h"
+#include "sti_compositor.h"
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+
+#define STI_FPS_INTERVAL_MS     3000
+
+struct sti_layer *sti_layer_find_layer(struct sti_layer *layer[],
+				       enum sti_layer_desc desc)
+{
+	int i;
+
+	for (i = 0; i < STI_MAX_LAYER; i++)
+		if (layer[i] && (layer[i]->desc == desc))
+			return layer[i];
+	return NULL;
+}
+
+const char *sti_layer_to_str(struct sti_layer *layer)
+{
+	switch (layer->desc) {
+	case STI_GDP_0:
+		return "GDP0";
+	case STI_GDP_1:
+		return "GDP1";
+	case STI_GDP_2:
+		return "GDP2";
+	case STI_GDP_3:
+		return "GDP3";
+	case STI_VID_0:
+		return "VID0";
+	case STI_VID_1:
+		return "VID1";
+	case STI_CURSOR:
+		return "CURSOR";
+	default:
+		return "<UNKNOWN LAYER>";
+	}
+}
+
+static int timespec_ms_diff(struct timespec lhs, struct timespec rhs)
+{
+	struct timespec tmp_ts = timespec_sub(lhs, rhs);
+	u64 tmp_ns = (u64) timespec_to_ns(&tmp_ts);
+
+	do_div(tmp_ns, NSEC_PER_MSEC);
+
+	return (u32) tmp_ns;
+}
+
+static void sti_layer_update_fps(struct sti_layer *layer)
+{
+	struct timespec now;
+	struct sti_fps_info *fps;
+	int fpks, ms_since_last, num_frames;
+
+	getrawmonotonic(&now);
+
+	fps = &layer->fps_info;
+	fps->curr_frame_counter++;
+	ms_since_last = timespec_ms_diff(now, fps->last_timestamp);
+	num_frames = fps->curr_frame_counter - fps->last_frame_counter;
+
+	if (num_frames > 1 && ms_since_last >= STI_FPS_INTERVAL_MS) {
+		fps->last_timestamp = now;
+		fps->last_frame_counter = fps->curr_frame_counter;
+		fpks = (num_frames * 1000000) / ms_since_last;
+		if (fps->output)
+			DRM_INFO("%s @ %d.%.3d fps\n", sti_layer_to_str(layer),
+				 fpks / 1000, fpks % 1000);
+	}
+}
+
+struct sti_layer *sti_layer_create(struct device *dev, int desc,
+				   void __iomem *baseaddr)
+{
+	struct sti_layer *layer;
+
+	layer = devm_kzalloc(dev, sizeof(*layer), GFP_KERNEL);
+	if (!layer) {
+		DRM_ERROR("Failed to allocate memory for layer\n");
+		return NULL;
+	}
+
+	switch (desc & STI_LAYER_TYPE_MASK) {
+	case STI_GDP:
+		layer->gdp = sti_gdp_create(dev, desc, baseaddr);
+		if (!layer->gdp)
+			goto err;
+		break;
+	case STI_VID:
+		layer->vid = sti_vid_create(dev, baseaddr);
+		if (!layer->vid)
+			goto err;
+		break;
+	default:
+		goto err;
+	}
+
+	layer->desc = desc;
+	DRM_DEBUG_DRIVER("%s created\n", sti_layer_to_str(layer));
+
+	return layer;
+err:
+	devm_kfree(dev, layer);
+	DRM_ERROR("Failed to create layer\n");
+	return NULL;
+}
+
+int sti_layer_prepare(struct sti_layer *layer, struct drm_framebuffer *fb,
+		      struct drm_display_mode *mode, int mixer_id,
+		      int dest_x, int dest_y, int dest_w, int dest_h,
+		      int src_x, int src_y, int src_w, int src_h)
+{
+	int ret, i;
+	struct drm_gem_cma_object *cma_obj;
+
+	if (!layer || !fb || !mode) {
+		DRM_ERROR("Null fb, layer or mode\n");
+		return 1;
+	}
+
+	cma_obj = drm_fb_cma_get_gem_obj(fb, 0);
+	if (!cma_obj) {
+		DRM_ERROR("Can't get CMA GEM object for fb\n");
+		return 1;
+	}
+
+	layer->fb = fb;
+	layer->mode = mode;
+	layer->mixer_id = mixer_id;
+	layer->dst_x = dest_x;
+	layer->dst_y = dest_y;
+	layer->dst_w = clamp_val(dest_w, 0, mode->crtc_hdisplay - dest_x);
+	layer->dst_h = clamp_val(dest_h, 0, mode->crtc_vdisplay - dest_y);
+	layer->src_x = src_x;
+	layer->src_y = src_y;
+	layer->src_w = src_w;
+	layer->src_h = src_h;
+	layer->format = fb->pixel_format;
+	layer->paddr = cma_obj->paddr;
+	for (i = 0; i < 4; i++) {
+		layer->pitches[i] = fb->pitches[i];
+		layer->offsets[i] = fb->offsets[i];
+	}
+
+	DRM_DEBUG_DRIVER("%s is associated with mixer_id %d\n",
+			 sti_layer_to_str(layer),
+			 layer->mixer_id);
+	DRM_DEBUG_DRIVER("%s dst=(%dx%d)@(%d,%d) - src=(%dx%d)@(%d,%d)\n",
+			 sti_layer_to_str(layer),
+			 layer->dst_w, layer->dst_h, layer->dst_x, layer->dst_y,
+			 layer->src_w, layer->src_h, layer->src_x,
+			 layer->src_y);
+
+	DRM_DEBUG_DRIVER("drm FB:%d format:%.4s phys@:0x%lx\n", fb->base.id,
+			 (char *)&layer->format, (unsigned long)layer->paddr);
+
+	/* Prepare layer specificities */
+	switch (layer->desc & STI_LAYER_TYPE_MASK) {
+	case STI_GDP:
+		if (!layer->gdp)
+			goto err_no_prepare;
+		ret = layer->gdp->prepare(layer, !layer->enabled);
+		break;
+	case STI_VID:
+		if (!layer->vid)
+			goto err_no_prepare;
+		ret = layer->vid->prepare(layer, !layer->enabled);
+		break;
+	default:
+		goto err_no_prepare;
+	}
+
+	if (!ret)
+		layer->enabled = true;
+
+	return ret;
+
+err_no_prepare:
+	DRM_ERROR("Cannot prepare\n");
+	return 1;
+}
+
+int sti_layer_commit(struct sti_layer *layer)
+{
+	int ret;
+
+	if (!layer)
+		return 1;
+
+	switch (layer->desc & STI_LAYER_TYPE_MASK) {
+	case STI_GDP:
+		if (!layer->gdp)
+			goto err_no_commit;
+		ret = layer->gdp->commit(layer);
+		break;
+	case STI_VID:
+		if (!layer->vid)
+			goto err_no_commit;
+		ret = layer->vid->commit(layer);
+		break;
+	default:
+		goto err_no_commit;
+	}
+
+	if (!ret)
+		sti_layer_update_fps(layer);
+
+	return ret;
+
+err_no_commit:
+	DRM_ERROR("Cannot commit\n");
+	return 1;
+}
+
+int sti_layer_disable(struct sti_layer *layer)
+{
+	int ret;
+
+	DRM_DEBUG_DRIVER("%s\n", sti_layer_to_str(layer));
+	if (!layer)
+		return 1;
+
+	if (!layer->enabled)
+		return 0;
+
+	switch (layer->desc & STI_LAYER_TYPE_MASK) {
+	case STI_GDP:
+		if (!layer->gdp)
+			goto err_no_disable;
+		ret = layer->gdp->disable(layer);
+		break;
+	case STI_VID:
+		if (!layer->vid)
+			goto err_no_disable;
+		ret = layer->vid->disable(layer);
+		break;
+	default:
+		goto err_no_disable;
+	}
+
+	if (!ret)
+		layer->enabled = false;
+	else
+		DRM_ERROR("Disable failed\n");
+
+	return ret;
+
+err_no_disable:
+	DRM_ERROR("Cannot disable\n");
+	return 1;
+}
+
+const uint32_t *sti_layer_get_formats(struct sti_layer *layer)
+{
+	const uint32_t *(*get_formats)(void) = NULL;
+
+	if (!layer)
+		return NULL;
+
+	switch (layer->desc & STI_LAYER_TYPE_MASK) {
+	case STI_GDP:
+		if (layer->gdp)
+			get_formats = layer->gdp->get_formats;
+		break;
+	default:
+		break;
+	}
+
+	if (!get_formats) {
+		DRM_ERROR("Cannot get formats\n");
+		return NULL;
+	}
+
+	return get_formats();
+}
+
+int sti_layer_get_nb_formats(struct sti_layer *layer)
+{
+	int (*get_nb_formats)(void) = NULL;
+
+	if (!layer)
+		return 0;
+
+	switch (layer->desc & STI_LAYER_TYPE_MASK) {
+	case STI_GDP:
+		if (layer->gdp)
+			get_nb_formats = layer->gdp->get_nb_formats;
+		break;
+	default:
+		break;
+	}
+
+	if (!get_nb_formats) {
+		DRM_ERROR("Cannot get nb formats\n");
+		return 0;
+	}
+
+	return get_nb_formats();
+}
-- 
1.9.1

