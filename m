Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaETN7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:59:55 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:38718 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaETN5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:17 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 12/16] drm: sti: add debug to GDP
Date: Tue, 20 May 2014 15:56:22 +0200
Message-Id: <1400594186-8956-13-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to get more detailed debug information on GDP

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/sti_drm_drv.h |  36 ++++++
 drivers/gpu/drm/sti/sti_gdp.c     | 235 ++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_gdp.h     |   2 +
 3 files changed, 273 insertions(+)
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.h

diff --git a/drivers/gpu/drm/sti/sti_drm_drv.h b/drivers/gpu/drm/sti/sti_drm_drv.h
new file mode 100644
index 0000000..5660196
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_drm_drv.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_DRM_DRV_H_
+#define _STI_DRM_DRV_H_
+
+#include <linux/platform_device.h>
+
+#include <drm/drmP.h>
+
+#include "sti_compositor.h"
+#include "sti_tvout.h"
+
+/*
+ * STI drm private structure
+ * This structure is stored as private in the drm_device
+ *
+ * @compo:                 compositor
+ * @tvout:                 TV OUT
+ * @pageflip_evt_list:     list of pending page flip requests
+ * @plane_zorder_property: z-order property for CRTC planes
+ */
+struct sti_drm_private {
+	struct sti_compositor *compo;
+	struct sti_tvout *tvout;
+	struct list_head pageflip_evt_list;
+	struct drm_property *plane_zorder_property;
+};
+
+#define STI_MAX_FB_HEIGHT	4096
+#define STI_MAX_FB_WIDTH	4096
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_gdp.c b/drivers/gpu/drm/sti/sti_gdp.c
index 00ff7f9..095d707 100644
--- a/drivers/gpu/drm/sti/sti_gdp.c
+++ b/drivers/gpu/drm/sti/sti_gdp.c
@@ -9,9 +9,11 @@
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 
+#include "sti_drm_drv.h"
 #include "sti_layer.h"
 #include "sti_gdp.h"
 #include "sti_vtg_utils.h"
+#include "sti_compositor.h"
 
 #define ENA_COLOR_FILL  (1 << 8)
 #define WAIT_NEXT_VSYNC (1 << 31)
@@ -29,6 +31,25 @@
 #define GDP_YCBR422R	0x12
 #define GDP_AYCBR8888	0x15
 
+#define GDP2STR(fmt) { GDP_ ## fmt, #fmt }
+
+static struct gdp_format_to_str {
+	int format;
+	char name[20];
+} sti_gdp_format_to_str[] = {
+		GDP2STR(RGB565),
+		GDP2STR(RGB888),
+		GDP2STR(RGB888_32),
+		GDP2STR(ARGB8565),
+		GDP2STR(ARGB8888),
+		GDP2STR(ARGB1555),
+		GDP2STR(ARGB4444),
+		GDP2STR(CLUT8),
+		GDP2STR(YCBR888),
+		GDP2STR(YCBR422R),
+		GDP2STR(AYCBR8888)
+		};
+
 #define GAM_GDP_CTL_OFFSET	0x00
 #define GAM_GDP_AGC_OFFSET	0x04
 #define GAM_GDP_VPO_OFFSET	0x0C
@@ -137,6 +158,9 @@ static struct sti_gdp_node_list *sti_gdp_get_free_nodes(struct sti_layer *layer)
 			return &gdp->node_list[i];
 
 end:
+	DRM_DEBUG_DRIVER("Warning, inconsistent NVN for %s: 0x%08X\n",
+			sti_layer_to_str(layer), hw_nvn);
+
 	return &gdp->node_list[0];
 }
 
@@ -169,6 +193,8 @@ struct sti_gdp_node_list *sti_gdp_get_current_nodes(struct sti_layer *layer)
 			return &gdp->node_list[i];
 
 end:
+	DRM_DEBUG_DRIVER("Warning, NVN 0x%08X for %s does not match any node\n",
+				hw_nvn, sti_layer_to_str(layer));
 	return NULL;
 }
 
@@ -198,6 +224,9 @@ static int sti_gdp_prepare_layer(void *lay, bool first_prepare)
 	top_field = list->top_field;
 	btm_field = list->btm_field;
 
+	dev_dbg(dev, "%s %s top_node:0x%p btm_node:0x%p\n", __func__,
+			sti_layer_to_str(layer), top_field, btm_field);
+
 	/* Build the top field from layer params */
 	top_field->gam_gdp_agc = GAM_GDP_AGC_FULL_RANGE;
 	top_field->gam_gdp_ctl = WAIT_NEXT_VSYNC;
@@ -294,6 +323,9 @@ static int sti_gdp_commit_layer(void *lay)
 	u32 dma_updated_btm = virt_to_dma(gdp->dev, updated_btm_node);
 	struct sti_gdp_node_list *curr_list = sti_gdp_get_current_nodes(layer);
 
+	dev_dbg(gdp->dev, "%s %s top/btm_node:0x%p/0x%p\n", __func__,
+			sti_layer_to_str(layer),
+			updated_top_node, updated_btm_node);
 	dev_dbg(gdp->dev, "Current NVN:0x%X\n",
 		readl(gdp->regs + GAM_GDP_NVN_OFFSET));
 	dev_dbg(gdp->dev, "Posted buff: %lx current buff: %x\n",
@@ -303,6 +335,8 @@ static int sti_gdp_commit_layer(void *lay)
 	if (curr_list == NULL) {
 		/* First update or invalid node should directly write in the
 		 * hw register */
+		DRM_DEBUG_DRIVER("%s first update (or invalid node)",
+				sti_layer_to_str(layer));
 		writel(gdp->is_curr_top == true ?
 				dma_updated_btm : dma_updated_top,
 				gdp->regs + GAM_GDP_NVN_OFFSET);
@@ -342,6 +376,8 @@ static int sti_gdp_disable_layer(void *lay)
 	struct sti_layer *layer = (struct sti_layer *)lay;
 	struct sti_gdp *gdp = layer->gdp;
 
+	DRM_DEBUG_DRIVER("%s\n", sti_layer_to_str(layer));
+
 	/* Set the nodes as 'to be ignored on mixer' */
 	for (i = 0; i < GDP_NODE_NB_BANK; i++) {
 		gdp->node_list[i].top_field->gam_gdp_ppt |= GAM_GDP_PPT_IGNORE;
@@ -489,3 +525,202 @@ mem_err:
 	devm_kfree(dev, gdp);
 	return NULL;
 }
+
+static void sti_gdp_dbg_ctl(struct seq_file *m, int val)
+{
+	int i;
+
+	seq_puts(m, "\tColor:");
+	for (i = 0; i < ARRAY_SIZE(sti_gdp_format_to_str); i++) {
+		if (sti_gdp_format_to_str[i].format == (val & 0x1F)) {
+			seq_printf(m, sti_gdp_format_to_str[i].name);
+			break;
+		}
+	}
+	if (i == ARRAY_SIZE(sti_gdp_format_to_str))
+		seq_puts(m, "<UNKNOWN>");
+
+	seq_printf(m, "\tWaitNextVsync:%d", val & WAIT_NEXT_VSYNC ? 1 : 0);
+}
+
+static void sti_gdp_dbg_vpo(struct seq_file *m, int val)
+{
+	seq_printf(m, "\txdo:%4d\tydo:%4d", val & 0x0FFF, (val >> 16) & 0x0FFF);
+}
+
+static void sti_gdp_dbg_vps(struct seq_file *m, int val)
+{
+	seq_printf(m, "\txds:%4d\tyds:%4d", val & 0x0FFF, (val >> 16) & 0x0FFF);
+}
+
+static void sti_gdp_dbg_size(struct seq_file *m, int val)
+{
+	seq_printf(m, "\t%d x %d", val & 0x07FF, (val >> 16) & 0x07FF);
+}
+
+static void sti_gdp_dbg_nvn(struct seq_file *m, struct device *dev, int val)
+{
+	seq_puts(m, "\tVirt @: ");
+	if (val)
+		seq_printf(m, "%p", dma_to_virt(dev, (dma_addr_t) val));
+}
+
+static void sti_gdp_dbg_ppt(struct seq_file *m, int val)
+{
+	if (val & GAM_GDP_PPT_IGNORE)
+		seq_puts(m, "\tNot displayed on mixer!");
+}
+
+static void sti_gdp_dbg_mst(struct seq_file *m, int val)
+{
+	if (val & 1)
+		seq_puts(m, "\tBUFFER UNDERFLOW!");
+}
+
+#define GDP_DBG_DUMP(reg) seq_printf(m, "\n " #reg "\t 0x%08X", \
+		readl(gdp->regs + reg ## _OFFSET))
+
+int sti_gdp_dbg_show(struct seq_file *m, void *arg)
+{
+	struct drm_info_node *node = (struct drm_info_node *)m->private;
+	struct drm_device *dev = node->minor->dev;
+	struct sti_drm_private *dev_priv = dev->dev_private;
+	struct sti_compositor *compo = dev_priv->compo;
+	int i, ret;
+
+	ret = mutex_lock_interruptible(&dev->struct_mutex);
+	if (ret)
+		return ret;
+
+	if (compo == NULL) {
+		seq_puts(m, "No compositor available\n");
+		goto out;
+	}
+
+	for (i = 0; i < compo->nb_layers; i++) {
+		struct drm_plane *plane;
+		struct drm_crtc *crtc;
+		struct drm_framebuffer *fb;
+		struct sti_layer *layer = compo->layer[i];
+		struct sti_gdp *gdp = layer->gdp;
+		if ((layer->desc & STI_LAYER_TYPE_MASK) != STI_GDP)
+			continue;
+		seq_printf(m, "\n%s (associated with the mixer_id %d)",
+				sti_layer_to_str(layer), layer->mixer_id);
+		seq_printf(m, "\t %d frame updates",
+			   layer->fps_info.curr_frame_counter);
+
+		GDP_DBG_DUMP(GAM_GDP_CTL);
+		sti_gdp_dbg_ctl(m, readl(gdp->regs + GAM_GDP_CTL_OFFSET));
+		GDP_DBG_DUMP(GAM_GDP_AGC);
+		GDP_DBG_DUMP(GAM_GDP_VPO);
+		sti_gdp_dbg_vpo(m, readl(gdp->regs + GAM_GDP_VPO_OFFSET));
+		GDP_DBG_DUMP(GAM_GDP_VPS);
+		sti_gdp_dbg_vps(m, readl(gdp->regs + GAM_GDP_VPS_OFFSET));
+		GDP_DBG_DUMP(GAM_GDP_PML);
+		GDP_DBG_DUMP(GAM_GDP_PMP);
+		GDP_DBG_DUMP(GAM_GDP_SIZE);
+		sti_gdp_dbg_size(m, readl(gdp->regs + GAM_GDP_SIZE_OFFSET));
+		GDP_DBG_DUMP(GAM_GDP_NVN);
+		sti_gdp_dbg_nvn(m, gdp->dev,
+				readl(gdp->regs + GAM_GDP_NVN_OFFSET));
+		GDP_DBG_DUMP(GAM_GDP_KEY1);
+		GDP_DBG_DUMP(GAM_GDP_KEY2);
+		GDP_DBG_DUMP(GAM_GDP_PPT);
+		sti_gdp_dbg_ppt(m, readl(gdp->regs + GAM_GDP_PPT_OFFSET));
+		GDP_DBG_DUMP(GAM_GDP_CML);
+		GDP_DBG_DUMP(GAM_GDP_MST);
+		sti_gdp_dbg_mst(m, readl(gdp->regs + GAM_GDP_MST_OFFSET));
+		seq_puts(m, "\n");
+
+		plane = &layer->plane;
+		if (!plane->base.id) {
+			seq_puts(m, " Not connected to any DRM PLANE\n");
+			continue;
+		}
+		seq_printf(m, " Connected to DRM PLANE #%d which is:\n",
+			   plane->base.id);
+
+		crtc = plane->crtc;
+		if (!crtc) {
+			seq_puts(m, "\tNot connected to any DRM CRTC\n");
+			continue;
+		}
+		seq_printf(m, "\tConnected to DRM CRTC #%d\n", crtc->base.id);
+
+		fb = crtc->fb;
+		if (!fb) {
+			seq_puts(m, "\tNot connected to any DRM FB\n");
+			continue;
+		}
+		seq_printf(m, "\tConnected to DRM FB #%d, %dx%d, %.4s\n",
+			   fb->base.id,
+			   fb->width, fb->height, (char *)&fb->pixel_format);
+	}
+
+out:
+	mutex_unlock(&dev->struct_mutex);
+	return 0;
+}
+
+static void sti_gdp_node_dump_node(struct seq_file *m,
+				   struct sti_gdp_node *node)
+{
+	seq_printf(m, "\t@:0x%p", node);
+	seq_printf(m, "\n\tCTL  0x%08X", node->gam_gdp_ctl);
+	sti_gdp_dbg_ctl(m, node->gam_gdp_ctl);
+	seq_printf(m, "\n\tAGC  0x%08X", node->gam_gdp_agc);
+	seq_printf(m, "\n\tVPO  0x%08X", node->gam_gdp_vpo);
+	sti_gdp_dbg_vpo(m, node->gam_gdp_vpo);
+	seq_printf(m, "\n\tVPS  0x%08X", node->gam_gdp_vps);
+	sti_gdp_dbg_vps(m, node->gam_gdp_vps);
+	seq_printf(m, "\n\tPML  0x%08X", node->gam_gdp_pml);
+	seq_printf(m, "\n\tPMP  0x%08X", node->gam_gdp_pmp);
+	seq_printf(m, "\n\tSIZE 0x%08X", node->gam_gdp_size);
+	sti_gdp_dbg_size(m, node->gam_gdp_size);
+	seq_printf(m, "\n\tNVN  0x%08X", node->gam_gdp_nvn);
+	seq_printf(m, "\n\tKEY1 0x%08X", node->gam_gdp_key1);
+	seq_printf(m, "\n\tKEY2 0x%08X", node->gam_gdp_key2);
+	seq_printf(m, "\n\tPPT  0x%08X", node->gam_gdp_ppt);
+	sti_gdp_dbg_ppt(m, node->gam_gdp_ppt);
+	seq_printf(m, "\n\tCML  0x%08X", node->gam_gdp_cml);
+	seq_puts(m, "\n");
+}
+
+int sti_gdp_node_dbg_show(struct seq_file *m, void *arg)
+{
+	struct drm_info_node *node = (struct drm_info_node *)m->private;
+	struct drm_device *dev = node->minor->dev;
+	struct sti_drm_private *dev_priv = dev->dev_private;
+	struct sti_compositor *compo = dev_priv->compo;
+	int i, ret;
+
+	ret = mutex_lock_interruptible(&dev->struct_mutex);
+	if (ret)
+		return ret;
+
+	if (!compo) {
+		seq_puts(m, "No compositor available\n");
+		goto out;
+	}
+
+	for (i = 0; i < compo->nb_layers; i++) {
+		int b;
+		struct sti_layer *layer = compo->layer[i];
+		struct sti_gdp *gdp = layer->gdp;
+		if ((layer->desc & STI_LAYER_TYPE_MASK) != STI_GDP)
+			continue;
+
+		for (b = 0; b < GDP_NODE_NB_BANK; b++) {
+			seq_printf(m, "\n%s[%d].top",
+				   sti_layer_to_str(layer), b);
+			sti_gdp_node_dump_node(m, gdp->node_list[b].top_field);
+			seq_printf(m, "\n%s[%d].btm",
+				   sti_layer_to_str(layer), b);
+			sti_gdp_node_dump_node(m, gdp->node_list[b].btm_field);
+		}
+	}
+out:
+	mutex_unlock(&dev->struct_mutex);
+	return 0;
+}
diff --git a/drivers/gpu/drm/sti/sti_gdp.h b/drivers/gpu/drm/sti/sti_gdp.h
index 4f7f40b..84875ff 100644
--- a/drivers/gpu/drm/sti/sti_gdp.h
+++ b/drivers/gpu/drm/sti/sti_gdp.h
@@ -69,5 +69,7 @@ struct sti_gdp {
 
 struct sti_gdp *sti_gdp_create(struct device *dev, int id,
 		void __iomem *baseaddr);
+int sti_gdp_dbg_show(struct seq_file *m, void *arg);
+int sti_gdp_node_dbg_show(struct seq_file *m, void *arg);
 
 #endif
-- 
1.9.1

