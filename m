Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaETN5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:57:12 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62160 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaETN5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:08 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 07/16] drm: sti: add sti layer interface definition
Date: Tue, 20 May 2014 15:56:17 +0200
Message-Id: <1400594186-8956-8-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STI hardware have various input sub-devices before mixing block.
Each type of sub-device have different capabilities for scaling,
filtering or accepted pixel format.
This layer interface abstract those differences and make the interaction
with compositor more simple.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/sti_layer.h | 104 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100644 drivers/gpu/drm/sti/sti_layer.h

diff --git a/drivers/gpu/drm/sti/sti_layer.h b/drivers/gpu/drm/sti/sti_layer.h
new file mode 100644
index 0000000..ed8386a
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_layer.h
@@ -0,0 +1,104 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_LAYER_H_
+#define _STI_LAYER_H_
+
+#include <drm/drmP.h>
+
+#define to_sti_layer(x) container_of(x, struct sti_layer, plane)
+
+#define STI_LAYER_TYPE_SHIFT 8
+#define STI_LAYER_TYPE_MASK (~((1<<STI_LAYER_TYPE_SHIFT)-1))
+
+
+enum sti_layer_type {
+	STI_GDP = 1 << STI_LAYER_TYPE_SHIFT,
+	STI_VID = 2 << STI_LAYER_TYPE_SHIFT,
+	STI_CUR = 3 << STI_LAYER_TYPE_SHIFT,
+	STI_BCK = 4 << STI_LAYER_TYPE_SHIFT
+};
+
+enum sti_layer_id_of_type {
+	STI_ID_0 = 0,
+	STI_ID_1 = 1,
+	STI_ID_2 = 2,
+	STI_ID_3 = 3
+};
+
+enum sti_layer_desc {
+	STI_GDP_0	= STI_GDP | STI_ID_0,
+	STI_GDP_1	= STI_GDP | STI_ID_1,
+	STI_GDP_2	= STI_GDP | STI_ID_2,
+	STI_GDP_3	= STI_GDP | STI_ID_3,
+	STI_VID_0	= STI_VID | STI_ID_0,
+	STI_VID_1	= STI_VID | STI_ID_1,
+	STI_CURSOR	= STI_CUR,
+	STI_BACK	= STI_BCK
+};
+
+struct sti_fps_info {
+	bool output;
+	int curr_frame_counter;
+	int last_frame_counter;
+	struct timespec last_timestamp;
+};
+
+/*
+ * STI layer structure
+ *
+ * @plane:		drm plane it is bound to (if any)
+ * @fb:			drm fb it is bound to
+ * @mode:		display mode
+ * @desc:		layer type & id
+ * @zorder:		layer z-order
+ * @enabled:		to know if the layer is active or not
+ * @src_x src_y:	coordinates of the input (fb) area
+ * @src_w src_h:	size of the input (fb) area
+ * @dst_x dst_y:	coordinates of the output (crtc) area
+ * @dst_w dst_h:	size of the output (crtc) area
+ * @format:		format
+ * @pitches:		pitch of 'planes' (eg: Y, U, V)
+ * @offsets:		offset of 'planes'
+ * @paddr:		physical address of the input buffer
+ * @fps_info:		frame per second info
+ */
+struct sti_layer {
+	struct drm_plane plane;
+	struct drm_framebuffer *fb;
+	struct drm_display_mode *mode;
+	enum sti_layer_desc desc;
+	int zorder;
+	bool enabled;
+	int src_x, src_y;
+	int src_w, src_h;
+	int dst_x, dst_y;
+	int dst_w, dst_h;
+	uint32_t format;
+	int pitches[4];
+	int offsets[4];
+	dma_addr_t paddr;
+	struct sti_fps_info fps_info;
+};
+
+struct sti_layer *sti_layer_create(struct device *dev, int desc,
+			void __iomem *baseaddr);
+int sti_layer_prepare(struct sti_layer *layer, struct drm_framebuffer *fb,
+			struct drm_display_mode *mode,
+			int dest_x, int dest_y,
+			int dest_w, int dest_h,
+			int src_x, int src_y,
+			int src_w, int src_h);
+int sti_layer_commit(struct sti_layer *layer);
+int sti_layer_disable(struct sti_layer *layer);
+const uint32_t *sti_layer_get_formats(struct sti_layer *layer);
+int sti_layer_get_nb_formats(struct sti_layer *layer);
+struct sti_layer *sti_layer_find_layer(struct sti_layer *layer[],
+			enum sti_layer_desc desc);
+const char *sti_layer_to_str(struct sti_layer *layer);
+#endif
-- 
1.9.1

