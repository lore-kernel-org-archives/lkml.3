Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaG3Rmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:42:51 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62374 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaG3Rmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:42:46 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v8 09/11] drm: sti: add Mixer
Date: Wed, 30 Jul 2014 19:42:05 +0200
Message-Id: <1406742127-27654-10-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mixer hardware IP is responsible of mixing the different inputs layers.
Z-order is managed by the mixer.
We could 2 mixers: one for main path and one for auxillary path

Mixers are part of Compositor hardware block

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 drivers/gpu/drm/sti/Makefile    |   3 +-
 drivers/gpu/drm/sti/sti_mixer.c | 243 ++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_mixer.h |  54 +++++++++
 3 files changed, 299 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/sti/sti_mixer.c
 create mode 100644 drivers/gpu/drm/sti/sti_mixer.h

diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index 9b613d2..4a3a816 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -1,4 +1,5 @@
 sticompositor-y := \
+	sti_mixer.o \
 	sti_gdp.o \
 	sti_vid.o
 
@@ -12,4 +13,4 @@ obj-$(CONFIG_DRM_STI) = \
 	stihdmi.o \
 	sti_hda.o \
 	sti_tvout.o \
-	sticompositor.o
+	sticompositor.o
\ No newline at end of file
diff --git a/drivers/gpu/drm/sti/sti_mixer.c b/drivers/gpu/drm/sti/sti_mixer.c
new file mode 100644
index 0000000..5fa6dc5
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_mixer.c
@@ -0,0 +1,243 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "sti_mixer.h"
+#include "sti_vtg.h"
+
+/* Identity: G=Y , B=Cb , R=Cr */
+static const u32 mixerColorSpaceMatIdentity[] = {
+	0x10000000, 0x00000000, 0x10000000, 0x00001000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000
+};
+
+/* regs offset */
+#define GAM_MIXER_CTL      0x00
+#define GAM_MIXER_BKC      0x04
+#define GAM_MIXER_BCO      0x0C
+#define GAM_MIXER_BCS      0x10
+#define GAM_MIXER_AVO      0x28
+#define GAM_MIXER_AVS      0x2C
+#define GAM_MIXER_CRB      0x34
+#define GAM_MIXER_ACT      0x38
+#define GAM_MIXER_MBP      0x3C
+#define GAM_MIXER_MX0      0x80
+
+/* id for depth of CRB reg */
+#define GAM_DEPTH_VID0_ID  1
+#define GAM_DEPTH_VID1_ID  2
+#define GAM_DEPTH_GDP0_ID  3
+#define GAM_DEPTH_GDP1_ID  4
+#define GAM_DEPTH_GDP2_ID  5
+#define GAM_DEPTH_GDP3_ID  6
+#define GAM_DEPTH_MASK_ID  7
+
+/* mask in CTL reg */
+#define GAM_CTL_BACK_MASK  BIT(0)
+#define GAM_CTL_VID0_MASK  BIT(1)
+#define GAM_CTL_VID1_MASK  BIT(2)
+#define GAM_CTL_GDP0_MASK  BIT(3)
+#define GAM_CTL_GDP1_MASK  BIT(4)
+#define GAM_CTL_GDP2_MASK  BIT(5)
+#define GAM_CTL_GDP3_MASK  BIT(6)
+
+const char *sti_mixer_to_str(struct sti_mixer *mixer)
+{
+	switch (mixer->id) {
+	case STI_MIXER_MAIN:
+		return "MAIN_MIXER";
+	case STI_MIXER_AUX:
+		return "AUX_MIXER";
+	default:
+		return "<UNKNOWN MIXER>";
+	}
+}
+
+static inline u32 sti_mixer_reg_read(struct sti_mixer *mixer, u32 reg_id)
+{
+	return readl(mixer->regs + reg_id);
+}
+
+static inline void sti_mixer_reg_write(struct sti_mixer *mixer,
+				       u32 reg_id, u32 val)
+{
+	writel(val, mixer->regs + reg_id);
+}
+
+void sti_mixer_set_background_status(struct sti_mixer *mixer, bool enable)
+{
+	u32 val = sti_mixer_reg_read(mixer, GAM_MIXER_CTL);
+
+	val &= ~GAM_CTL_BACK_MASK;
+	val |= enable;
+	sti_mixer_reg_write(mixer, GAM_MIXER_CTL, val);
+}
+
+static void sti_mixer_set_background_color(struct sti_mixer *mixer,
+					   u8 red, u8 green, u8 blue)
+{
+	u32 val = (red << 16) | (green << 8) | blue;
+
+	sti_mixer_reg_write(mixer, GAM_MIXER_BKC, val);
+}
+
+static void sti_mixer_set_background_area(struct sti_mixer *mixer,
+					  struct drm_display_mode *mode)
+{
+	u32 ydo, xdo, yds, xds;
+
+	ydo = sti_vtg_get_line_number(*mode, 0);
+	yds = sti_vtg_get_line_number(*mode, mode->vdisplay - 1);
+	xdo = sti_vtg_get_pixel_number(*mode, 0);
+	xds = sti_vtg_get_pixel_number(*mode, mode->hdisplay - 1);
+
+	sti_mixer_reg_write(mixer, GAM_MIXER_BCO, ydo << 16 | xdo);
+	sti_mixer_reg_write(mixer, GAM_MIXER_BCS, yds << 16 | xds);
+}
+
+int sti_mixer_set_layer_depth(struct sti_mixer *mixer, struct sti_layer *layer)
+{
+	int layer_id = 0, depth = layer->zorder;
+	u32 mask, val;
+
+	if (depth >= GAM_MIXER_NB_DEPTH_LEVEL)
+		return 1;
+
+	switch (layer->desc) {
+	case STI_GDP_0:
+		layer_id = GAM_DEPTH_GDP0_ID;
+		break;
+	case STI_GDP_1:
+		layer_id = GAM_DEPTH_GDP1_ID;
+		break;
+	case STI_GDP_2:
+		layer_id = GAM_DEPTH_GDP2_ID;
+		break;
+	case STI_GDP_3:
+		layer_id = GAM_DEPTH_GDP3_ID;
+		break;
+	case STI_VID_0:
+		layer_id = GAM_DEPTH_VID0_ID;
+		break;
+	case STI_VID_1:
+		layer_id = GAM_DEPTH_VID1_ID;
+		break;
+	default:
+		DRM_ERROR("Unknown layer %d\n", layer->desc);
+		return 1;
+	}
+	mask = GAM_DEPTH_MASK_ID << (3 * depth);
+	layer_id = layer_id << (3 * depth);
+
+	dev_dbg(mixer->dev, "GAM_MIXER_CRB val 0x%x mask 0x%x\n",
+		layer_id, mask);
+
+	val = sti_mixer_reg_read(mixer, GAM_MIXER_CRB);
+	val &= ~mask;
+	val |= layer_id;
+	sti_mixer_reg_write(mixer, GAM_MIXER_CRB, val);
+
+	dev_dbg(mixer->dev, "Read GAM_MIXER_CRB 0x%x\n",
+		sti_mixer_reg_read(mixer, GAM_MIXER_CRB));
+	return 0;
+}
+
+int sti_mixer_active_video_area(struct sti_mixer *mixer,
+				struct drm_display_mode *mode)
+{
+	u32 ydo, xdo, yds, xds;
+
+	ydo = sti_vtg_get_line_number(*mode, 0);
+	yds = sti_vtg_get_line_number(*mode, mode->vdisplay - 1);
+	xdo = sti_vtg_get_pixel_number(*mode, 0);
+	xds = sti_vtg_get_pixel_number(*mode, mode->hdisplay - 1);
+
+	DRM_DEBUG_DRIVER("%s active video area xdo:%d ydo:%d xds:%d yds:%d\n",
+			 sti_mixer_to_str(mixer), xdo, ydo, xds, yds);
+	sti_mixer_reg_write(mixer, GAM_MIXER_AVO, ydo << 16 | xdo);
+	sti_mixer_reg_write(mixer, GAM_MIXER_AVS, yds << 16 | xds);
+
+	sti_mixer_set_background_color(mixer, 0xFF, 0, 0);
+
+	sti_mixer_set_background_area(mixer, mode);
+	sti_mixer_set_background_status(mixer, true);
+	return 0;
+}
+
+static u32 sti_mixer_get_layer_mask(struct sti_layer *layer)
+{
+	switch (layer->desc) {
+	case STI_BACK:
+		return GAM_CTL_BACK_MASK;
+	case STI_GDP_0:
+		return GAM_CTL_GDP0_MASK;
+	case STI_GDP_1:
+		return GAM_CTL_GDP1_MASK;
+	case STI_GDP_2:
+		return GAM_CTL_GDP2_MASK;
+	case STI_GDP_3:
+		return GAM_CTL_GDP3_MASK;
+	case STI_VID_0:
+		return GAM_CTL_VID0_MASK;
+	case STI_VID_1:
+		return GAM_CTL_VID1_MASK;
+	default:
+		return 0;
+	}
+}
+
+int sti_mixer_set_layer_status(struct sti_mixer *mixer,
+			       struct sti_layer *layer, bool status)
+{
+	u32 mask, val;
+
+	mask = sti_mixer_get_layer_mask(layer);
+	if (!mask) {
+		DRM_ERROR("Can not find layer mask\n");
+		return -EINVAL;
+	}
+
+	val = sti_mixer_reg_read(mixer, GAM_MIXER_CTL);
+	val &= ~mask;
+	val |= status ? mask : 0;
+	sti_mixer_reg_write(mixer, GAM_MIXER_CTL, val);
+
+	return 0;
+}
+
+void sti_mixer_set_matrix(struct sti_mixer *mixer)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(mixerColorSpaceMatIdentity); i++)
+		sti_mixer_reg_write(mixer, GAM_MIXER_MX0 + (i * 4),
+				    mixerColorSpaceMatIdentity[i]);
+}
+
+struct sti_mixer *sti_mixer_create(struct device *dev, int id,
+				   void __iomem *baseaddr)
+{
+	struct sti_mixer *mixer = devm_kzalloc(dev, sizeof(*mixer), GFP_KERNEL);
+	struct device_node *np = dev->of_node;
+
+	dev_dbg(dev, "%s\n", __func__);
+	if (!mixer) {
+		DRM_ERROR("Failed to allocated memory for mixer\n");
+		return NULL;
+	}
+	mixer->regs = baseaddr;
+	mixer->dev = dev;
+	mixer->id = id;
+
+	if (of_device_is_compatible(np, "st,stih416-compositor"))
+		sti_mixer_set_matrix(mixer);
+
+	DRM_DEBUG_DRIVER("%s created. Regs=%p\n",
+			 sti_mixer_to_str(mixer), mixer->regs);
+
+	return mixer;
+}
diff --git a/drivers/gpu/drm/sti/sti_mixer.h b/drivers/gpu/drm/sti/sti_mixer.h
new file mode 100644
index 0000000..8743721
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_mixer.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_MIXER_H_
+#define _STI_MIXER_H_
+
+#include <drm/drmP.h>
+
+#include "sti_layer.h"
+
+#define to_sti_mixer(x) container_of(x, struct sti_mixer, drm_crtc)
+
+/**
+ * STI Mixer subdevice structure
+ *
+ * @dev: driver device
+ * @regs: mixer registers
+ * @id: id of the mixer
+ * @drm_crtc: crtc object link to the mixer
+ * @pending_event: set if a flip event is pending on crtc
+ */
+struct sti_mixer {
+	struct device *dev;
+	void __iomem *regs;
+	int id;
+	struct drm_crtc	drm_crtc;
+	struct drm_pending_vblank_event *pending_event;
+};
+
+const char *sti_mixer_to_str(struct sti_mixer *mixer);
+
+struct sti_mixer *sti_mixer_create(struct device *dev, int id,
+		void __iomem *baseaddr);
+
+int sti_mixer_set_layer_status(struct sti_mixer *mixer,
+		struct sti_layer *layer, bool status);
+int sti_mixer_set_layer_depth(struct sti_mixer *mixer, struct sti_layer *layer);
+int sti_mixer_active_video_area(struct sti_mixer *mixer,
+		struct drm_display_mode *mode);
+
+void sti_mixer_set_background_status(struct sti_mixer *mixer, bool enable);
+
+/* depth in Cross-bar control = z order */
+#define GAM_MIXER_NB_DEPTH_LEVEL 7
+
+#define STI_MIXER_MAIN 0
+#define STI_MIXER_AUX  1
+
+#endif
-- 
1.9.1

