Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaG3RoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:44:03 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45705 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbaG3Rmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:42:42 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v8 08/11] drm: sti: add VID layer
Date: Wed, 30 Jul 2014 19:42:04 +0200
Message-Id: <1406742127-27654-9-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VIDeo plug are one of the compositor input sub-devices.
VID are dedicated to video inputs like YUV plans.

Like GDP, VID are part of Compositor hardware block
and use sti_layer structure to provide an abstraction for
Compositor calls.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 drivers/gpu/drm/sti/Makefile  |   3 +-
 drivers/gpu/drm/sti/sti_vid.c | 138 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_vid.h |  12 ++++
 3 files changed, 152 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/sti/sti_vid.c
 create mode 100644 drivers/gpu/drm/sti/sti_vid.h

diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index 7de757f..9b613d2 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -1,5 +1,6 @@
 sticompositor-y := \
-	sti_gdp.o
+	sti_gdp.o \
+	sti_vid.o
 
 stihdmi-y := sti_hdmi.o \
 	sti_hdmi_tx3g0c55phy.o \
diff --git a/drivers/gpu/drm/sti/sti_vid.c b/drivers/gpu/drm/sti/sti_vid.c
new file mode 100644
index 0000000..10ced6a
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
+static int sti_vid_prepare_layer(struct sti_layer *vid, bool first_prepare)
+{
+	u32 val;
+
+	/* Unmask */
+	val = readl(vid->regs + VID_CTL);
+	val &= ~VID_CTL_IGNORE;
+	writel(val, vid->regs + VID_CTL);
+
+	return 0;
+}
+
+static int sti_vid_commit_layer(struct sti_layer *vid)
+{
+	struct drm_display_mode *mode = vid->mode;
+	u32 ydo, xdo, yds, xds;
+
+	ydo = sti_vtg_get_line_number(*mode, vid->dst_y);
+	yds = sti_vtg_get_line_number(*mode, vid->dst_y + vid->dst_h - 1);
+	xdo = sti_vtg_get_pixel_number(*mode, vid->dst_x);
+	xds = sti_vtg_get_pixel_number(*mode, vid->dst_x + vid->dst_w - 1);
+
+	writel((ydo << 16) | xdo, vid->regs + VID_VPO);
+	writel((yds << 16) | xds, vid->regs + VID_VPS);
+
+	return 0;
+}
+
+static int sti_vid_disable_layer(struct sti_layer *vid)
+{
+	u32 val;
+
+	/* Mask */
+	val = readl(vid->regs + VID_CTL);
+	val |= VID_CTL_IGNORE;
+	writel(val, vid->regs + VID_CTL);
+
+	return 0;
+}
+
+static const uint32_t *sti_vid_get_formats(struct sti_layer *layer)
+{
+	return NULL;
+}
+
+static unsigned int sti_vid_get_nb_formats(struct sti_layer *layer)
+{
+	return 0;
+}
+
+static void sti_vid_init(struct sti_layer *vid)
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
+static const struct sti_layer_funcs vid_ops = {
+	.get_formats = sti_vid_get_formats,
+	.get_nb_formats = sti_vid_get_nb_formats,
+	.init = sti_vid_init,
+	.prepare = sti_vid_prepare_layer,
+	.commit = sti_vid_commit_layer,
+	.disable = sti_vid_disable_layer,
+};
+
+struct sti_layer *sti_vid_create(struct device *dev)
+{
+	struct sti_layer *vid;
+
+	vid = devm_kzalloc(dev, sizeof(*vid), GFP_KERNEL);
+	if (!vid) {
+		DRM_ERROR("Failed to allocate memory for VID\n");
+		return NULL;
+	}
+
+	vid->ops = &vid_ops;
+
+	return vid;
+}
diff --git a/drivers/gpu/drm/sti/sti_vid.h b/drivers/gpu/drm/sti/sti_vid.h
new file mode 100644
index 0000000..2c0aecd
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vid.h
@@ -0,0 +1,12 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Author: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_VID_H_
+#define _STI_VID_H_
+
+struct sti_layer *sti_vid_create(struct device *dev);
+
+#endif
-- 
1.9.1

