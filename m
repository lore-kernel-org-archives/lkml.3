Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaETN5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:57:24 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34593 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaETN5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:19 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 13/16] drm: sti: add debug to VID
Date: Tue, 20 May 2014 15:56:23 +0200
Message-Id: <1400594186-8956-14-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make VIdeo plug more verbose on what is on going

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/sti_vid.c | 121 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_vid.h |   1 +
 2 files changed, 122 insertions(+)

diff --git a/drivers/gpu/drm/sti/sti_vid.c b/drivers/gpu/drm/sti/sti_vid.c
index 710665d..35f60d8 100644
--- a/drivers/gpu/drm/sti/sti_vid.c
+++ b/drivers/gpu/drm/sti/sti_vid.c
@@ -8,6 +8,8 @@
 
 #include "sti_vid.h"
 #include "sti_layer.h"
+#include "sti_compositor.h"
+#include "sti_drm_drv.h"
 #include "sti_vtg_utils.h"
 
 /* Registers */
@@ -49,6 +51,8 @@ static int sti_vid_prepare_layer(void *lay, bool first_prepare)
 	struct sti_layer *layer = (struct sti_layer *)lay;
 	struct sti_vid *vid = layer->vid;
 
+	dev_dbg(vid->dev, "%s %s\n", __func__, sti_layer_to_str(layer));
+
 	/* Unmask */
 	val = readl(vid->regs + VID_CTL);
 	val &= ~VID_CTL_IGNORE;
@@ -64,6 +68,8 @@ static int sti_vid_commit_layer(void *lay)
 	struct drm_display_mode *mode = layer->mode;
 	u32 ydo, xdo, yds, xds;
 
+	dev_dbg(vid->dev, "%s %s\n", __func__, sti_layer_to_str(layer));
+
 	ydo = sti_vtg_get_line_number(*mode, layer->dst_y);
 	yds = sti_vtg_get_line_number(*mode, layer->dst_y + layer->dst_h - 1);
 	xdo = sti_vtg_get_pixel_number(*mode, layer->dst_x);
@@ -81,6 +87,8 @@ static int sti_vid_disable_layer(void *lay)
 	struct sti_layer *layer = (struct sti_layer *)lay;
 	struct sti_vid *vid = layer->vid;
 
+	DRM_DEBUG_DRIVER("%s\n", sti_layer_to_str(layer));
+
 	/* Mask */
 	val = readl(vid->regs + VID_CTL);
 	val |= VID_CTL_IGNORE;
@@ -136,3 +144,116 @@ struct sti_vid *sti_vid_create(struct device *dev, void __iomem *baseaddr)
 
 	return vid;
 }
+
+static void sti_vid_dbg_ctl(struct seq_file *m, int val)
+{
+	val = val >> 30;
+	seq_puts(m, "\t");
+
+	if (!(val & 1))
+		seq_puts(m, "NOT ");
+	seq_puts(m, "ignored on main mixer - ");
+
+	if (!(val & 2))
+		seq_puts(m, "NOT ");
+	seq_puts(m, "ignored on aux mixer");
+}
+
+static void sti_vid_dbg_vpo(struct seq_file *m, int val)
+{
+	seq_printf(m, "\txdo:%4d\tydo:%4d", val & 0x0FFF, (val >> 16) & 0x0FFF);
+}
+
+static void sti_vid_dbg_vps(struct seq_file *m, int val)
+{
+	seq_printf(m, "\txds:%4d\tyds:%4d", val & 0x0FFF, (val >> 16) & 0x0FFF);
+}
+
+static void sti_vid_dbg_mst(struct seq_file *m, int val)
+{
+	if (val & 1)
+		seq_puts(m, "\tBUFFER UNDERFLOW!");
+}
+
+#define DBG_DUMP(reg) \
+	seq_printf(m, "\n " #reg "\t 0x%08X", readl(vid->regs + reg))
+
+int sti_vid_dbg_show(struct seq_file *m, void *arg)
+{
+	struct drm_info_node *node = (struct drm_info_node *)m->private;
+	struct drm_device *dev = node->minor->dev;
+	struct sti_drm_private *dev_priv = dev->dev_private;
+	struct sti_compositor *compo = dev_priv->compo;
+	enum sti_layer_desc vid_id = *(enum sti_layer_desc *)arg;
+	struct sti_layer *layer;
+	struct sti_vid *vid;
+	struct drm_plane *plane;
+	struct drm_crtc *crtc;
+	struct drm_framebuffer *fb;
+
+	if (compo == NULL) {
+		seq_puts(m, "No compo available\n");
+		goto out;
+	}
+
+	layer = sti_layer_find_layer(compo->layer, vid_id);
+	if (!layer) {
+		seq_puts(m, "Cannot find video layer\n");
+		goto out;
+	}
+	vid = layer->vid;
+
+	seq_printf(m, "\n%s (associated with the mixer_id %d)",
+			sti_layer_to_str(layer), layer->mixer_id);
+	seq_printf(m, "\t %d frame updates",
+		   layer->fps_info.curr_frame_counter);
+
+	DBG_DUMP(VID_CTL);
+	sti_vid_dbg_ctl(m, readl(vid->regs + VID_CTL));
+	DBG_DUMP(VID_ALP);
+	DBG_DUMP(VID_CLF);
+	DBG_DUMP(VID_VPO);
+	sti_vid_dbg_vpo(m, readl(vid->regs + VID_VPO));
+	DBG_DUMP(VID_VPS);
+	sti_vid_dbg_vps(m, readl(vid->regs + VID_VPS));
+	DBG_DUMP(VID_KEY1);
+	DBG_DUMP(VID_KEY2);
+	DBG_DUMP(VID_MPR0);
+	DBG_DUMP(VID_MPR1);
+	DBG_DUMP(VID_MPR2);
+	DBG_DUMP(VID_MPR3);
+	DBG_DUMP(VID_MST);
+	sti_vid_dbg_mst(m, readl(vid->regs + VID_MST));
+	DBG_DUMP(VID_BC);
+	DBG_DUMP(VID_TINT);
+	DBG_DUMP(VID_CSAT);
+
+	seq_puts(m, "\n");
+
+	plane = &layer->plane;
+	if (!plane->base.id) {
+		seq_puts(m, " Not connected to any DRM PLANE\n");
+		goto out;
+	}
+	seq_printf(m, " Connected to DRM PLANE #%d which is:\n",
+		   plane->base.id);
+
+	crtc = plane->crtc;
+	if (!crtc) {
+		seq_puts(m, "\tNot connected to any DRM CRTC\n");
+		goto out;
+	}
+	seq_printf(m, "\tConnected to DRM CRTC #%d\n", crtc->base.id);
+
+	fb = crtc->fb;
+	if (!fb) {
+		seq_puts(m, "\tNot connected to any DRM FB\n");
+		goto out;
+	}
+	seq_printf(m, "\tConnected to DRM FB #%d, %dx%d, %.4s\n",
+		   fb->base.id,
+		   fb->width, fb->height, (char *)&fb->pixel_format);
+
+out:
+	return 0;
+}
diff --git a/drivers/gpu/drm/sti/sti_vid.h b/drivers/gpu/drm/sti/sti_vid.h
index dd4fd95..6261ade 100644
--- a/drivers/gpu/drm/sti/sti_vid.h
+++ b/drivers/gpu/drm/sti/sti_vid.h
@@ -29,5 +29,6 @@ struct sti_vid {
 };
 
 struct sti_vid *sti_vid_create(struct device *dev, void __iomem *baseaddr);
+int sti_vid_dbg_show(struct seq_file *m, void *arg);
 
 #endif
-- 
1.9.1

