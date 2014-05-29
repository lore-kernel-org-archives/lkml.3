Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbaE2GjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:39:09 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:35749 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbaE2Gh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:37:58 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v4 08/11] drm: sti: add VID layer
Date: Thu, 29 May 2014 08:37:04 +0200
Message-Id: <1401345427-5299-9-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401345427-5299-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1401345427-5299-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VIDeo plug are one of the compositor input sub-devices.
VID are dedicated to video inputs like YUV plans.

Like GDP, VID are part of Compositor hardware block
and use sti_layer structure to provide an abstraction for
Compositor calls.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/Makefile    |   3 +-
 drivers/gpu/drm/sti/sti_layer.h |   3 +
 drivers/gpu/drm/sti/sti_vid.c   | 138 ++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_vid.h   |  33 ++++++++++
 4 files changed, 176 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/sti/sti_vid.c
 create mode 100644 drivers/gpu/drm/sti/sti_vid.h

diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index 1745697..bb0f6b3 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_DRM_STI) += \
 	sti_hdmi_tx3g4c28phy.o \
 	sti_hda.o \
 	sti_tvout.o \
-	sti_gdp.o
\ No newline at end of file
+	sti_gdp.o \
+	sti_vid.o
\ No newline at end of file
diff --git a/drivers/gpu/drm/sti/sti_layer.h b/drivers/gpu/drm/sti/sti_layer.h
index 7ba5a40..c8a159d 100644
--- a/drivers/gpu/drm/sti/sti_layer.h
+++ b/drivers/gpu/drm/sti/sti_layer.h
@@ -11,6 +11,7 @@
 
 #include <drm/drmP.h>
 #include "sti_gdp.h"
+#include "sti_vid.h"
 
 #define to_sti_layer(x) container_of(x, struct sti_layer, plane)
 
@@ -70,6 +71,7 @@ struct sti_fps_info {
  * @paddr:              physical address of the input buffer
  * @fps_info:           frame per second info
  * @gdp:                related GDP (if the layer is a GDP)
+ * @vid:                related VID (if the layer is a VID/VDP)
  */
 struct sti_layer {
 	struct drm_plane plane;
@@ -89,6 +91,7 @@ struct sti_layer {
 	dma_addr_t paddr;
 	struct sti_fps_info fps_info;
 	struct sti_gdp *gdp;
+	struct sti_vid *vid;
 };
 
 struct sti_layer *sti_layer_create(struct device *dev, int desc,
diff --git a/drivers/gpu/drm/sti/sti_vid.c b/drivers/gpu/drm/sti/sti_vid.c
new file mode 100644
index 0000000..0197291
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vid.c
@@ -0,0 +1,138 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Author: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <drm/drmP.h>
+
+#include "sti_layer.h"
+#include "sti_vid.h"
+#include "sti_vtg.h"
+
+/* Registers */
+#define VID_CTL                 0x00
+#define VID_ALP                 0x04
+#define VID_CLF                 0x08
+#define VID_VPO                 0x0C
+#define VID_VPS                 0x10
+#define VID_KEY1                0x28
+#define VID_KEY2                0x2C
+#define VID_MPR0                0x30
+#define VID_MPR1                0x34
+#define VID_MPR2                0x38
+#define VID_MPR3                0x3C
+#define VID_MST                 0x68
+#define VID_BC                  0x70
+#define VID_TINT                0x74
+#define VID_CSAT                0x78
+
+/* Registers values */
+#define VID_CTL_IGNORE          (BIT(31) | BIT(30))
+#define VID_CTL_PSI_ENABLE      (BIT(2) | BIT(1) | BIT(0))
+#define VID_ALP_OPAQUE          0x00000080
+#define VID_BC_DFLT             0x00008000
+#define VID_TINT_DFLT           0x00000000
+#define VID_CSAT_DFLT           0x00000080
+/* YCbCr to RGB BT709:
+ * R = Y+1.5391Cr
+ * G = Y-0.4590Cr-0.1826Cb
+ * B = Y+1.8125Cb */
+#define VID_MPR0_BT709          0x0A800000
+#define VID_MPR1_BT709          0x0AC50000
+#define VID_MPR2_BT709          0x07150545
+#define VID_MPR3_BT709          0x00000AE8
+
+static int sti_vid_prepare_layer(void *lay, bool first_prepare)
+{
+	u32 val;
+	struct sti_layer *layer = (struct sti_layer *)lay;
+	struct sti_vid *vid = layer->vid;
+
+	/* Unmask */
+	val = readl(vid->regs + VID_CTL);
+	val &= ~VID_CTL_IGNORE;
+	writel(val, vid->regs + VID_CTL);
+
+	return 0;
+}
+
+static int sti_vid_commit_layer(void *lay)
+{
+	struct sti_layer *layer = (struct sti_layer *)lay;
+	struct sti_vid *vid = layer->vid;
+	struct drm_display_mode *mode = layer->mode;
+	u32 ydo, xdo, yds, xds;
+
+	ydo = sti_vtg_get_line_number(*mode, layer->dst_y);
+	yds = sti_vtg_get_line_number(*mode, layer->dst_y + layer->dst_h - 1);
+	xdo = sti_vtg_get_pixel_number(*mode, layer->dst_x);
+	xds = sti_vtg_get_pixel_number(*mode, layer->dst_x + layer->dst_w - 1);
+
+	writel((ydo << 16) | xdo, vid->regs + VID_VPO);
+	writel((yds << 16) | xds, vid->regs + VID_VPS);
+
+	return 0;
+}
+
+static int sti_vid_disable_layer(void *lay)
+{
+	u32 val;
+	struct sti_layer *layer = (struct sti_layer *)lay;
+	struct sti_vid *vid = layer->vid;
+
+	/* Mask */
+	val = readl(vid->regs + VID_CTL);
+	val |= VID_CTL_IGNORE;
+	writel(val, vid->regs + VID_CTL);
+
+	return 0;
+}
+
+static void sti_vid_set_default(struct sti_vid *vid)
+{
+	/* Enable PSI, Mask layer */
+	writel(VID_CTL_PSI_ENABLE | VID_CTL_IGNORE, vid->regs + VID_CTL);
+
+	/* Opaque */
+	writel(VID_ALP_OPAQUE, vid->regs + VID_ALP);
+
+	/* Color conversion parameters */
+	writel(VID_MPR0_BT709, vid->regs + VID_MPR0);
+	writel(VID_MPR1_BT709, vid->regs + VID_MPR1);
+	writel(VID_MPR2_BT709, vid->regs + VID_MPR2);
+	writel(VID_MPR3_BT709, vid->regs + VID_MPR3);
+
+	/* Brightness, contrast, tint, saturation */
+	writel(VID_BC_DFLT, vid->regs + VID_BC);
+	writel(VID_TINT_DFLT, vid->regs + VID_TINT);
+	writel(VID_CSAT_DFLT, vid->regs + VID_CSAT);
+}
+
+struct sti_vid *sti_vid_create(struct device *dev, void __iomem *baseaddr)
+{
+	struct sti_vid *vid;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	vid = devm_kzalloc(dev, sizeof(*vid), GFP_KERNEL);
+	if (!vid) {
+		DRM_ERROR("Failed to allocate memory for VID\n");
+		return NULL;
+	}
+
+	vid->dev = dev;
+	vid->regs = baseaddr;
+	vid->prepare = sti_vid_prepare_layer;
+	vid->commit = sti_vid_commit_layer;
+	vid->disable = sti_vid_disable_layer;
+	/* As the VID input is HW-mapped to the VDP output, the supported
+	 * formats are under the VDP control */
+	vid->get_formats = NULL;
+	vid->get_nb_formats = NULL;
+
+	/* Set default configuration (static) */
+	sti_vid_set_default(vid);
+
+	return vid;
+}
diff --git a/drivers/gpu/drm/sti/sti_vid.h b/drivers/gpu/drm/sti/sti_vid.h
new file mode 100644
index 0000000..4a502b0
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vid.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Author: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_VID_H_
+#define _STI_VID_H_
+
+/*
+ * STI VID structure
+ *
+ * @device:		driver device
+ * @regs:		subdevice register
+ * @get_formats:	get VID supported formats
+ * @get_nb_formats:	get number of format supported
+ * @prepare:		prepare VID before rendering
+ * @commit:		set VID for rendering
+ * @disable:		disable VID
+ */
+struct sti_vid {
+	struct device *dev;
+	void __iomem *regs;
+	const uint32_t* (*get_formats)(void);
+	unsigned int (*get_nb_formats)(void);
+	int (*prepare)(void *layer, bool first_prepare);
+	int (*commit)(void *layer);
+	int (*disable)(void *layer);
+};
+
+struct sti_vid *sti_vid_create(struct device *dev, void __iomem *baseaddr);
+
+#endif
-- 
1.9.1

