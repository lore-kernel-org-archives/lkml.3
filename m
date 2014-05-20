Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaETN5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:57:51 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:59894 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaETN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:23 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 15/16] drm: sti: add debug to mixer
Date: Tue, 20 May 2014 15:56:25 +0200
Message-Id: <1400594186-8956-16-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make mixer driver more verbose

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/sti_mixer.c | 164 ++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_mixer.h |   2 +
 2 files changed, 166 insertions(+)

diff --git a/drivers/gpu/drm/sti/sti_mixer.c b/drivers/gpu/drm/sti/sti_mixer.c
index b6c8214..73d5405 100644
--- a/drivers/gpu/drm/sti/sti_mixer.c
+++ b/drivers/gpu/drm/sti/sti_mixer.c
@@ -6,7 +6,9 @@
  * License terms:  GNU General Public License (GPL), version 2
  */
 
+#include "sti_drm_drv.h"
 #include "sti_mixer.h"
+#include "sti_compositor.h"
 #include "sti_vtg_utils.h"
 
 /* Identity: G=Y , B=Cb , R=Cr */
@@ -139,6 +141,8 @@ int sti_mixer_set_layer_depth(struct sti_mixer *mixer, struct sti_layer *layer)
 	mask = GAM_DEPTH_MASK_ID << (3 * depth);
 	layer_id = layer_id << (3 * depth);
 
+	DRM_DEBUG_DRIVER("%s %s depth=%d\n", sti_mixer_to_str(mixer),
+			 sti_layer_to_str(layer), depth);
 	dev_dbg(mixer->dev, "GAM_MIXER_CRB val 0x%x mask 0x%x\n",
 		layer_id, mask);
 	sti_mixer_reg_writemask(mixer, GAM_MIXER_CRB, layer_id, mask);
@@ -197,6 +201,9 @@ int sti_mixer_set_layer_status(struct sti_mixer *mixer,
 {
 	u32 mask, val;
 
+	DRM_DEBUG_DRIVER("%s %s %s\n", status ? "enable" : "disable",
+			 sti_mixer_to_str(mixer), sti_layer_to_str(layer));
+
 	mask = sti_mixer_get_layer_mask(layer);
 	if (!mask) {
 		DRM_ERROR("Can not find layer mask\n");
@@ -239,3 +246,160 @@ struct sti_mixer *sti_mixer_create(struct device *dev, int id,
 
 	return mixer;
 }
+
+static void sti_mixer_dbg_ctl(struct seq_file *m, int val)
+{
+	int count = 0;
+
+	seq_puts(m, "\tEnabled: ");
+	if (val & 1) {
+		seq_puts(m, "BKG ");
+		count++;
+	}
+	val = val >> 1;
+
+	if (val & 1) {
+		seq_puts(m, "VID0 ");
+		count++;
+	}
+	val = val >> 1;
+	if (val & 1) {
+		seq_puts(m, "VID1 ");
+		count++;
+	}
+	val = val >> 1;
+	if (val & 1) {
+		seq_puts(m, "GDP0 ");
+		count++;
+	}
+	val = val >> 1;
+	if (val & 1) {
+		seq_puts(m, "GDP1 ");
+		count++;
+	}
+	val = val >> 1;
+	if (val & 1) {
+		seq_puts(m, "GDP2 ");
+		count++;
+	}
+	val = val >> 1;
+	if (val & 1) {
+		seq_puts(m, "GDP3 ");
+		count++;
+	}
+	if (!count)
+		seq_puts(m, "Nothing");
+}
+
+static void sti_mixer_dbg_crb(struct seq_file *m, int val)
+{
+	int i;
+
+	seq_puts(m, "\tDepth: ");
+	for (i = 0; i < GAM_MIXER_NB_DEPTH_LEVEL; i++) {
+		switch (val & GAM_DEPTH_MASK_ID) {
+		case GAM_DEPTH_VID0_ID:
+			seq_puts(m, "VID0");
+			break;
+		case GAM_DEPTH_VID1_ID:
+			seq_puts(m, "VID1");
+			break;
+		case GAM_DEPTH_GDP0_ID:
+			seq_puts(m, "GDP0");
+			break;
+		case GAM_DEPTH_GDP1_ID:
+			seq_puts(m, "GDP1");
+			break;
+		case GAM_DEPTH_GDP2_ID:
+			seq_puts(m, "GDP2");
+			break;
+		case GAM_DEPTH_GDP3_ID:
+			seq_puts(m, "GDP3");
+			break;
+		default:
+			seq_puts(m, "---");
+		}
+		if (i < GAM_MIXER_NB_DEPTH_LEVEL - 1)
+			seq_puts(m, " < ");
+		val = val >> 3;
+	}
+}
+
+static void sti_mixer_dbg_mxn(struct seq_file *m, void *addr)
+{
+	int i;
+
+	for (i = 1; i < 8; i++)
+		seq_printf(m, "-0x%08X", (int)readl(addr + i * 4));
+}
+
+#define MIXER_DBG_DUMP(reg) seq_printf(m, "\n " #reg "\t 0x%08X", \
+		sti_mixer_reg_read(mixer, reg))
+
+int sti_mixer_dbg_show(struct seq_file *m, void *arg)
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
+	for (i = 0; i < compo->nb_mixers; i++) {
+		struct drm_crtc *crtc;
+		struct drm_framebuffer *fb;
+		struct sti_mixer *mixer = compo->mixer[i];
+
+		seq_printf(m, "\n%s", sti_mixer_to_str(mixer));
+		MIXER_DBG_DUMP(GAM_MIXER_CTL);
+		sti_mixer_dbg_ctl(m,
+				  sti_mixer_reg_read(mixer,
+						     GAM_MIXER_CTL));
+		MIXER_DBG_DUMP(GAM_MIXER_BKC);
+		MIXER_DBG_DUMP(GAM_MIXER_BCO);
+		MIXER_DBG_DUMP(GAM_MIXER_BCS);
+		MIXER_DBG_DUMP(GAM_MIXER_AVO);
+		MIXER_DBG_DUMP(GAM_MIXER_AVS);
+		MIXER_DBG_DUMP(GAM_MIXER_CRB);
+		sti_mixer_dbg_crb(m,
+				  sti_mixer_reg_read(mixer,
+						     GAM_MIXER_CRB));
+		MIXER_DBG_DUMP(GAM_MIXER_ACT);
+		MIXER_DBG_DUMP(GAM_MIXER_MBP);
+		MIXER_DBG_DUMP(GAM_MIXER_MX0);
+		sti_mixer_dbg_mxn(m, mixer->regs + GAM_MIXER_MX0);
+		seq_puts(m, "\n");
+
+		crtc = &mixer->drm_crtc;
+		if (!crtc) {
+			seq_puts(m, " Not connected to any DRM CRTC\n");
+			continue;
+		}
+		seq_printf(m, " Connected to DRM CRTC #%d which is:\n",
+			   crtc->base.id);
+		seq_puts(m, crtc->enabled ? "\tEnabled\n" : "\tDisabled\n");
+		seq_printf(m, "\tMode: %s %dHz\n",
+			   crtc->mode.name, crtc->mode.vrefresh);
+		seq_printf(m, "\tat %d,%d\n", crtc->x, crtc->y);
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
+out:
+	mutex_unlock(&dev->struct_mutex);
+	return 0;
+}
diff --git a/drivers/gpu/drm/sti/sti_mixer.h b/drivers/gpu/drm/sti/sti_mixer.h
index a05e21f..abdd1ad 100644
--- a/drivers/gpu/drm/sti/sti_mixer.h
+++ b/drivers/gpu/drm/sti/sti_mixer.h
@@ -43,6 +43,8 @@ int sti_mixer_active_video_area(struct sti_mixer *mixer,
 
 void sti_mixer_set_background_status(struct sti_mixer *mixer, bool enable);
 
+int sti_mixer_dbg_show(struct seq_file *m, void *arg);
+
 /* depth in Cross-bar control = z order */
 #define GAM_MIXER_NB_DEPTH_LEVEL	7
 
-- 
1.9.1

