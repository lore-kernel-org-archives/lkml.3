Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaKRRu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:50:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36086 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaKRRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:50:09 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 3/3] drm/msm: add multiple CRTC and overlay support
Date: Tue, 18 Nov 2014 12:49:49 -0500
Message-Id: <1416332989-685-4-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1416332989-685-1-git-send-email-sviau@codeaurora.org>
References: <1416332989-685-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MDP5 currently support one single CRTC with its private pipe.
This change allows the configuration of multiple CRTCs with
the possibility to attach several public planes to these CRTCs.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/Makefile                |   1 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h     |   1 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c    | 265 +++++++++++++++++------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c     | 325 ++++++++++++++++++++++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h     | 121 +++++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c |  13 ++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c     |  48 +++-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h     |  48 ++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c   | 107 +++++++--
 9 files changed, 804 insertions(+), 125 deletions(-)
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h

diff --git a/drivers/gpu/drm/msm/Makefile b/drivers/gpu/drm/msm/Makefile
index 51045b0..135c0e5 100644
--- a/drivers/gpu/drm/msm/Makefile
+++ b/drivers/gpu/drm/msm/Makefile
@@ -25,6 +25,7 @@ msm-y := \
 	mdp/mdp4/mdp4_kms.o \
 	mdp/mdp4/mdp4_plane.o \
 	mdp/mdp5/mdp5_cfg.o \
+	mdp/mdp5/mdp5_ctl.o \
 	mdp/mdp5/mdp5_crtc.o \
 	mdp/mdp5/mdp5_encoder.o \
 	mdp/mdp5/mdp5_irq.o \
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h
index 00c8271..d0c98f9 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h
@@ -24,6 +24,7 @@
  */
 extern const struct mdp5_cfg_hw *mdp5_cfg;
 
+#define MAX_CTL			8
 #define MAX_BASES		8
 #define MAX_SMP_BLOCKS		44
 #define MAX_CLIENTS		32
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
index ebe2e60..fff012a 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014 The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
  *
@@ -22,16 +23,24 @@
 #include "drm_crtc_helper.h"
 #include "drm_flip_work.h"
 
+#define SSPP_MAX	(SSPP_RGB3 + 1) /* TODO: Add SSPP_MAX in mdp5.xml.h */
+
 struct mdp5_crtc {
 	struct drm_crtc base;
 	char name[8];
 	struct drm_plane *plane;
-	struct drm_plane *planes[8];
+	struct drm_plane *planes[SSPP_MAX];
+	int plane_count;
 	int id;
 	bool enabled;
 
-	/* which mixer/encoder we route output to: */
-	int mixer;
+	/* layer mixer used for this CRTC (+ its lock): */
+#define GET_LM_ID(crtc_id)	((crtc_id == 3) ? 5 : crtc_id)
+	int lm;
+	spinlock_t lm_lock;	/* protect REG_MDP5_LM_* registers */
+
+	/* CTL used for this CRTC: */
+	void *ctl;
 
 	/* if there is a pending flip, these will be non-null: */
 	struct drm_pending_vblank_event *event;
@@ -58,6 +67,7 @@ struct mdp5_crtc {
 	struct mdp_irq err;
 };
 #define to_mdp5_crtc(x) container_of(x, struct mdp5_crtc, base)
+#define is_private_plane(mdp5_crtc, drm_plane) (drm_plane == (mdp5_crtc)->plane)
 
 static struct mdp5_kms *get_kms(struct drm_crtc *crtc)
 {
@@ -73,26 +83,35 @@ static void request_pending(struct drm_crtc *crtc, uint32_t pending)
 	mdp_irq_register(&get_kms(crtc)->base, &mdp5_crtc->vblank);
 }
 
-static void crtc_flush(struct drm_crtc *crtc)
+#define mdp5_lm_get_flush(lm)	mdp_ctl_flush_mask_lm(lm)
+
+static void crtc_flush(struct drm_crtc *crtc, u32 flush_mask)
 {
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
-	struct mdp5_kms *mdp5_kms = get_kms(crtc);
-	int id = mdp5_crtc->id;
-	uint32_t i, flush = 0;
+
+	DBG("%s: flush=%08x", mdp5_crtc->name, flush_mask);
+	mdp5_ctl_commit(mdp5_crtc->ctl, flush_mask);
+}
+
+/*
+ * flush updates, to make sure hw is updated to new scanout fb,
+ * so that we can safely queue unref to current fb (ie. next
+ * vblank we know hw is done w/ previous scanout_fb).
+ */
+static void crtc_flush_all(struct drm_crtc *crtc)
+{
+	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
+	uint32_t i, flush_mask = 0;
 
 	for (i = 0; i < ARRAY_SIZE(mdp5_crtc->planes); i++) {
 		struct drm_plane *plane = mdp5_crtc->planes[i];
-		if (plane) {
-			enum mdp5_pipe pipe = mdp5_plane_pipe(plane);
-			flush |= pipe2flush(pipe);
-		}
+		if (plane)
+			flush_mask |= mdp5_plane_get_flush(plane);
 	}
-	flush |= mixer2flush(mdp5_crtc->id);
-	flush |= MDP5_CTL_FLUSH_CTL;
+	flush_mask |= mdp5_ctl_get_flush(mdp5_crtc->ctl);
+	flush_mask |= mdp5_lm_get_flush(mdp5_crtc->lm);
 
-	DBG("%s: flush=%08x", mdp5_crtc->name, flush);
-
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_FLUSH(id), flush);
+	crtc_flush(crtc, flush_mask);
 }
 
 static void update_fb(struct drm_crtc *crtc, struct drm_framebuffer *new_fb)
@@ -120,12 +139,6 @@ static void update_scanout(struct drm_crtc *crtc, struct drm_framebuffer *fb)
 {
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
 
-	/* flush updates, to make sure hw is updated to new scanout fb,
-	 * so that we can safely queue unref to current fb (ie. next
-	 * vblank we know hw is done w/ previous scanout_fb).
-	 */
-	crtc_flush(crtc);
-
 	if (mdp5_crtc->scanout_fb)
 		drm_flip_work_queue(&mdp5_crtc->unref_fb_work,
 				mdp5_crtc->scanout_fb);
@@ -178,6 +191,7 @@ static void pageflip_cb(struct msm_fence_cb *cb)
 	drm_framebuffer_reference(fb);
 	mdp5_plane_set_scanout(mdp5_crtc->plane, fb);
 	update_scanout(crtc, fb);
+	crtc_flush_all(crtc);
 }
 
 static void unref_fb_worker(struct drm_flip_work *work, void *val)
@@ -228,41 +242,66 @@ static bool mdp5_crtc_mode_fixup(struct drm_crtc *crtc,
 	return true;
 }
 
+/*
+ * blend_setup() - blend all the planes of a CRTC
+ *
+ * When border is enabled, the border color will ALWAYS be the base layer.
+ * Therefore, the first plane (private RGB pipe) will start at STAGE0.
+ * If disabled, the first plane starts at STAGE_BASE.
+ *
+ * Note:
+ * Border is not enabled here because the private plane is exactly
+ * the CRTC resolution.
+ */
 static void blend_setup(struct drm_crtc *crtc)
 {
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
 	struct mdp5_kms *mdp5_kms = get_kms(crtc);
-	int id = mdp5_crtc->id;
+	const struct mdp5_cfg_hw *hw_cfg;
+	uint32_t i, lm = mdp5_crtc->lm, blend_cfg = 0;
+	enum mdp_mixer_stage_id stage;
+	unsigned long flags;
+#define blender(stage)	((stage) - STAGE_BASE)
 
-	/*
-	 * Hard-coded setup for now until I figure out how the
-	 * layer-mixer works
-	 */
+	hw_cfg = mdp5_cfg_get_hw_config(mdp5_kms->cfg_priv);
 
-	/* LM[id]: */
-	mdp5_write(mdp5_kms, REG_MDP5_LM_BLEND_COLOR_OUT(id),
-			MDP5_LM_BLEND_COLOR_OUT_STAGE0_FG_ALPHA);
-	mdp5_write(mdp5_kms, REG_MDP5_LM_BLEND_OP_MODE(id, 0),
-			MDP5_LM_BLEND_OP_MODE_FG_ALPHA(FG_CONST) |
-			MDP5_LM_BLEND_OP_MODE_BG_ALPHA(FG_PIXEL) |
-			MDP5_LM_BLEND_OP_MODE_BG_INV_ALPHA);
-	mdp5_write(mdp5_kms, REG_MDP5_LM_BLEND_FG_ALPHA(id, 0), 0xff);
-	mdp5_write(mdp5_kms, REG_MDP5_LM_BLEND_BG_ALPHA(id, 0), 0x00);
-
-	/* NOTE: seems that LM[n] and CTL[m], we do not need n==m.. but
-	 * we want to be setting CTL[m].LAYER[n].  Not sure what the
-	 * point of having CTL[m].LAYER[o] (for o!=n).. maybe that is
-	 * used when chaining up mixers for high resolution displays?
-	 */
+	spin_lock_irqsave(&mdp5_crtc->lm_lock, flags);
+
+	for (i = 0; i < ARRAY_SIZE(mdp5_crtc->planes); i++) {
+		struct drm_plane *plane = mdp5_crtc->planes[i];
+		struct mdp5_overlay_info *overlay;
+
+		if (!plane)
+			continue;
+
+		overlay = mdp5_plane_get_overlay_info(plane);
+		stage = overlay->zorder;
 
-	/* CTL[id]: */
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_LAYER_REG(id, 0),
-			MDP5_CTL_LAYER_REG_RGB0(STAGE0) |
-			MDP5_CTL_LAYER_REG_BORDER_COLOR);
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_LAYER_REG(id, 1), 0);
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_LAYER_REG(id, 2), 0);
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_LAYER_REG(id, 3), 0);
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_LAYER_REG(id, 4), 0);
+		/*
+		 * Note: This cannot happen with current implementation but
+		 * we need to check this condition once z property is added
+		 */
+		BUG_ON(stage > hw_cfg->lm.nb_stages);
+
+		/* LM */
+		mdp5_write(mdp5_kms,
+				REG_MDP5_LM_BLEND_OP_MODE(lm, blender(stage)),
+				MDP5_LM_BLEND_OP_MODE_FG_ALPHA(FG_CONST) |
+				MDP5_LM_BLEND_OP_MODE_BG_ALPHA(BG_CONST));
+		mdp5_write(mdp5_kms, REG_MDP5_LM_BLEND_FG_ALPHA(lm,
+				blender(stage)), 0xff);
+		mdp5_write(mdp5_kms, REG_MDP5_LM_BLEND_BG_ALPHA(lm,
+				blender(stage)), 0x00);
+		/* CTL */
+		blend_cfg |= mdp_ctl_blend_mask(mdp5_plane_pipe(plane), stage);
+		DBG("%s: blending pipe %s on stage=%d", mdp5_crtc->name,
+				pipe2name(mdp5_plane_pipe(plane)), stage);
+	}
+
+	DBG("%s: lm%d: blend config = 0x%08x", mdp5_crtc->name, lm, blend_cfg);
+	mdp5_ctl_blend(mdp5_crtc->ctl, lm, blend_cfg);
+
+	spin_unlock_irqrestore(&mdp5_crtc->lm_lock, flags);
 }
 
 static int mdp5_crtc_mode_set(struct drm_crtc *crtc,
@@ -273,6 +312,7 @@ static int mdp5_crtc_mode_set(struct drm_crtc *crtc,
 {
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
 	struct mdp5_kms *mdp5_kms = get_kms(crtc);
+	unsigned long flags;
 	int ret;
 
 	mode = adjusted_mode;
@@ -286,6 +326,13 @@ static int mdp5_crtc_mode_set(struct drm_crtc *crtc,
 			mode->vsync_end, mode->vtotal,
 			mode->type, mode->flags);
 
+	/* request a free CTL, if none is already allocated for this CRTC */
+	if (!mdp5_crtc->ctl) {
+		mdp5_crtc->ctl = mdp5_ctl_request(mdp5_kms->ctl_priv, crtc);
+		if (!mdp5_crtc->ctl)
+			return -EBUSY;
+	}
+
 	/* grab extra ref for update_scanout() */
 	drm_framebuffer_reference(crtc->primary->fb);
 
@@ -300,12 +347,15 @@ static int mdp5_crtc_mode_set(struct drm_crtc *crtc,
 		return ret;
 	}
 
-	mdp5_write(mdp5_kms, REG_MDP5_LM_OUT_SIZE(mdp5_crtc->id),
+	spin_lock_irqsave(&mdp5_crtc->lm_lock, flags);
+	mdp5_write(mdp5_kms, REG_MDP5_LM_OUT_SIZE(mdp5_crtc->lm),
 			MDP5_LM_OUT_SIZE_WIDTH(mode->hdisplay) |
 			MDP5_LM_OUT_SIZE_HEIGHT(mode->vdisplay));
+	spin_unlock_irqrestore(&mdp5_crtc->lm_lock, flags);
 
 	update_fb(crtc, crtc->primary->fb);
 	update_scanout(crtc, crtc->primary->fb);
+	/* crtc_flush_all(crtc) will be called in _commit callback */
 
 	return 0;
 }
@@ -322,7 +372,7 @@ static void mdp5_crtc_prepare(struct drm_crtc *crtc)
 static void mdp5_crtc_commit(struct drm_crtc *crtc)
 {
 	mdp5_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
-	crtc_flush(crtc);
+	crtc_flush_all(crtc);
 	/* drop the ref to mdp clk's that we got in prepare: */
 	mdp5_disable(get_kms(crtc));
 }
@@ -349,6 +399,7 @@ static int mdp5_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 
 	update_fb(crtc, crtc->primary->fb);
 	update_scanout(crtc, crtc->primary->fb);
+	crtc_flush_all(crtc);
 
 	return 0;
 }
@@ -357,6 +408,19 @@ static void mdp5_crtc_load_lut(struct drm_crtc *crtc)
 {
 }
 
+static void mdp5_crtc_disable(struct drm_crtc *crtc)
+{
+	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
+
+	DBG("%s", mdp5_crtc->name);
+
+	if (mdp5_crtc->ctl) {
+		mdp5_ctl_release(mdp5_crtc->ctl);
+		mdp5_crtc->ctl = NULL;
+	}
+}
+
+
 static int mdp5_crtc_page_flip(struct drm_crtc *crtc,
 		struct drm_framebuffer *new_fb,
 		struct drm_pending_vblank_event *event,
@@ -405,6 +469,7 @@ static const struct drm_crtc_helper_funcs mdp5_crtc_helper_funcs = {
 	.commit = mdp5_crtc_commit,
 	.mode_set_base = mdp5_crtc_mode_set_base,
 	.load_lut = mdp5_crtc_load_lut,
+	.disable = mdp5_crtc_disable,
 };
 
 static void mdp5_crtc_vblank_irq(struct mdp_irq *irq, uint32_t irqstatus)
@@ -427,9 +492,8 @@ static void mdp5_crtc_vblank_irq(struct mdp_irq *irq, uint32_t irqstatus)
 static void mdp5_crtc_err_irq(struct mdp_irq *irq, uint32_t irqstatus)
 {
 	struct mdp5_crtc *mdp5_crtc = container_of(irq, struct mdp5_crtc, err);
-	struct drm_crtc *crtc = &mdp5_crtc->base;
+
 	DBG("%s: error: %08x", mdp5_crtc->name, irqstatus);
-	crtc_flush(crtc);
 }
 
 uint32_t mdp5_crtc_vblank(struct drm_crtc *crtc)
@@ -450,10 +514,9 @@ void mdp5_crtc_set_intf(struct drm_crtc *crtc, int intf,
 {
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
 	struct mdp5_kms *mdp5_kms = get_kms(crtc);
-	static const enum mdp5_intfnum intfnum[] = {
-			INTF0, INTF1, INTF2, INTF3,
-	};
+	uint32_t flush_mask = 0;
 	uint32_t intf_sel;
+	unsigned long flags;
 
 	/* now that we know what irq's we want: */
 	mdp5_crtc->err.irqmask = intf2err(intf);
@@ -463,6 +526,7 @@ void mdp5_crtc_set_intf(struct drm_crtc *crtc, int intf,
 	if (!mdp5_kms)
 		return;
 
+	spin_lock_irqsave(&mdp5_kms->resource_lock, flags);
 	intf_sel = mdp5_read(mdp5_kms, REG_MDP5_DISP_INTF_SEL);
 
 	switch (intf) {
@@ -487,16 +551,15 @@ void mdp5_crtc_set_intf(struct drm_crtc *crtc, int intf,
 		break;
 	}
 
-	blend_setup(crtc);
+	mdp5_write(mdp5_kms, REG_MDP5_DISP_INTF_SEL, intf_sel);
+	spin_unlock_irqrestore(&mdp5_kms->resource_lock, flags);
 
 	DBG("%s: intf_sel=%08x", mdp5_crtc->name, intf_sel);
+	mdp5_ctl_set_intf(mdp5_crtc->ctl, intf);
+	flush_mask |= mdp5_ctl_get_flush(mdp5_crtc->ctl);
+	flush_mask |= mdp5_lm_get_flush(mdp5_crtc->lm);
 
-	mdp5_write(mdp5_kms, REG_MDP5_DISP_INTF_SEL, intf_sel);
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_OP(mdp5_crtc->id),
-			MDP5_CTL_OP_MODE(MODE_NONE) |
-			MDP5_CTL_OP_INTF_NUM(intfnum[intf]));
-
-	crtc_flush(crtc);
+	crtc_flush(crtc, flush_mask);
 }
 
 static void set_attach(struct drm_crtc *crtc, enum mdp5_pipe pipe_id,
@@ -509,15 +572,72 @@ static void set_attach(struct drm_crtc *crtc, enum mdp5_pipe pipe_id,
 	if (mdp5_crtc->planes[pipe_id] == plane)
 		return;
 
+	/*
+	 * This function is called by both mdp5_crtc_attach()/detach()
+	 * if plane is NULL, detach happened -> decrement plane_count,
+	 * otherwise increment it (attach)
+	 */
+	mdp5_crtc->plane_count += (plane ? 1 : -1);
+	DBG("%s: %d planes attached", mdp5_crtc->name, mdp5_crtc->plane_count);
+
 	mdp5_crtc->planes[pipe_id] = plane;
 	blend_setup(crtc);
 	if (mdp5_crtc->enabled && (plane != mdp5_crtc->plane))
-		crtc_flush(crtc);
+		crtc_flush_all(crtc);
 }
 
-void mdp5_crtc_attach(struct drm_crtc *crtc, struct drm_plane *plane)
+int mdp5_crtc_attach(struct drm_crtc *crtc, struct drm_plane *plane)
 {
+	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
+	struct mdp5_kms *mdp5_kms = get_kms(crtc);
+	struct device *dev = crtc->dev->dev;
+	const struct mdp5_cfg_hw *hw_cfg;
+	bool private_plane = is_private_plane(mdp5_crtc, plane);
+	struct mdp5_overlay_info overlay_info;
+	enum mdp_mixer_stage_id stage = STAGE_BASE;
+	int i, max_nb_planes;
+
+	hw_cfg = mdp5_cfg_get_hw_config(mdp5_kms->cfg_priv);
+	max_nb_planes = hw_cfg->lm.nb_stages;
+
+	if (mdp5_crtc->plane_count >= max_nb_planes) {
+		dev_err(dev, "%s: max # of planes (%d) reached\n",
+				mdp5_crtc->name, max_nb_planes);
+		return -EBUSY;
+	}
+
+	/*
+	 * Set default z-ordering depending on the type of plane
+	 * private -> lower stage
+	 * public  -> topmost stage
+	 *
+	 * TODO: add a property to give userspace an API to change this...
+	 * (will come in a subsequent patch)
+	 */
+	if (private_plane) {
+		stage = STAGE_BASE;
+	} else {
+		for (i = 0; i < ARRAY_SIZE(mdp5_crtc->planes); i++) {
+			struct drm_plane *attached_plane = mdp5_crtc->planes[i];
+			struct mdp5_overlay_info *overlay;
+
+			if (!attached_plane)
+				continue;
+			overlay = mdp5_plane_get_overlay_info(attached_plane);
+			stage = max(stage, overlay->zorder);
+		}
+		stage++;
+	}
+	overlay_info.zorder = stage;
+	mdp5_plane_set_overlay_info(plane, &overlay_info);
+
+	DBG("%s: %s plane %s set to stage %d by default", mdp5_crtc->name,
+			private_plane ? "private" : "public",
+			pipe2name(mdp5_plane_pipe(plane)), overlay_info.zorder);
+
 	set_attach(crtc, mdp5_plane_pipe(plane), plane);
+
+	return 0;
 }
 
 void mdp5_crtc_detach(struct drm_crtc *crtc, struct drm_plane *plane)
@@ -528,6 +648,16 @@ void mdp5_crtc_detach(struct drm_crtc *crtc, struct drm_plane *plane)
 	set_attach(crtc, mdp5_plane_pipe(plane), NULL);
 }
 
+int mdp5_crtc_get_lm(struct drm_crtc *crtc)
+{
+	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
+
+	if (WARN_ON(!crtc))
+		return -EINVAL;
+
+	return mdp5_crtc->lm;
+}
+
 /* initialize crtc */
 struct drm_crtc *mdp5_crtc_init(struct drm_device *dev,
 		struct drm_plane *plane, int id)
@@ -546,6 +676,9 @@ struct drm_crtc *mdp5_crtc_init(struct drm_device *dev,
 
 	mdp5_crtc->plane = plane;
 	mdp5_crtc->id = id;
+	mdp5_crtc->lm = GET_LM_ID(id);
+
+	spin_lock_init(&mdp5_crtc->lm_lock);
 
 	mdp5_crtc->vblank.irq = mdp5_crtc_vblank_irq;
 	mdp5_crtc->err.irq = mdp5_crtc_err_irq;
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c
new file mode 100644
index 0000000..a6155b7
--- /dev/null
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c
@@ -0,0 +1,325 @@
+/*
+ * Copyright (c) 2014 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "mdp5_kms.h"
+#include "mdp5_ctl.h"
+
+/*
+ * CTL - MDP Control Pool Manager
+ *
+ * Controls are shared between all CRTCs.
+ *
+ * They are intended to be used for data path configuration.
+ * The top level register programming describes the complete data path for
+ * a specific data path ID - REG_MDP5_CTL_*(<id>, ...)
+ *
+ * Hardware capabilities determine the number of concurrent data paths
+ *
+ * In certain use cases (high-resolution dual pipe), one single CTL can be
+ * shared across multiple CRTCs.
+ *
+ * Because the number of CTLs can be less than the number of CRTCs,
+ * CTLs are dynamically allocated from a pool of CTLs, only once a CRTC is
+ * requested by the client (in mdp5_crtc_mode_set()).
+ */
+
+struct mdp5_ctl {
+	u32 id;
+
+	/* whether this CTL has been allocated or not: */
+	bool busy;
+
+	/* memory output connection (@see mdp5_ctl_mode): */
+	u32 mode;
+
+	/* REG_MDP5_CTL_*(<id>) registers access info + lock: */
+	spinlock_t hw_lock;
+	u32 reg_offset;
+
+	/* flush mask used to commit CTL registers */
+	u32 flush_mask;
+
+	bool cursor_on;
+	void *crtc;
+};
+
+struct mdp5_ctl_manager {
+	struct drm_device *dev;
+
+	/* number of CTL / Layer Mixers in this hw config: */
+	u32 nlm;
+	u32 nctl;
+
+	/* pool of CTLs + lock to protect resource allocation (ctls[i].busy) */
+	spinlock_t pool_lock;
+	struct mdp5_ctl ctls[MAX_CTL];
+};
+
+static struct mdp5_ctl_manager mdp5_ctl_mgr;
+
+static inline
+struct mdp5_kms *get_kms(struct mdp5_ctl_manager *ctl_mgr)
+{
+	struct msm_drm_private *priv = ctl_mgr->dev->dev_private;
+
+	return to_mdp5_kms(to_mdp_kms(priv->kms));
+}
+
+static inline
+void ctl_write(struct mdp5_ctl *ctl, u32 reg, u32 data)
+{
+	struct mdp5_ctl_manager *ctl_mgr = &mdp5_ctl_mgr;
+	struct mdp5_kms *mdp5_kms = get_kms(ctl_mgr);
+
+	(void)ctl->reg_offset; /* TODO use this instead of mdp5_write */
+	mdp5_write(mdp5_kms, reg, data);
+}
+
+static inline
+u32 ctl_read(struct mdp5_ctl *ctl, u32 reg)
+{
+	struct mdp5_ctl_manager *ctl_mgr = &mdp5_ctl_mgr;
+	struct mdp5_kms *mdp5_kms = get_kms(ctl_mgr);
+
+	(void)ctl->reg_offset; /* TODO use this instead of mdp5_write */
+	return mdp5_read(mdp5_kms, reg);
+}
+
+
+int mdp5_ctl_set_intf(void *c, enum mdp5_intf intf)
+{
+	struct mdp5_ctl *ctl = c;
+	unsigned long flags;
+	static const enum mdp5_intfnum intfnum[] = {
+			INTF0, INTF1, INTF2, INTF3,
+	};
+
+	spin_lock_irqsave(&ctl->hw_lock, flags);
+	ctl_write(ctl, REG_MDP5_CTL_OP(ctl->id),
+			MDP5_CTL_OP_MODE(ctl->mode) |
+			MDP5_CTL_OP_INTF_NUM(intfnum[intf]));
+	spin_unlock_irqrestore(&ctl->hw_lock, flags);
+
+	return 0;
+}
+
+int mdp5_ctl_set_cursor(void *c, bool enable)
+{
+	struct mdp5_ctl_manager *ctl_mgr = &mdp5_ctl_mgr;
+	struct mdp5_ctl *ctl = c;
+	unsigned long flags;
+	u32 blend_cfg;
+	int lm;
+
+	lm = mdp5_crtc_get_lm(ctl->crtc);
+	if (unlikely(WARN_ON(lm < 0))) {
+		dev_err(ctl_mgr->dev->dev, "CTL %d cannot find LM: %d",
+				ctl->id, lm);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&ctl->hw_lock, flags);
+
+	blend_cfg = ctl_read(ctl, REG_MDP5_CTL_LAYER_REG(ctl->id, lm));
+
+	if (enable)
+		blend_cfg |=  MDP5_CTL_LAYER_REG_CURSOR_OUT;
+	else
+		blend_cfg &= ~MDP5_CTL_LAYER_REG_CURSOR_OUT;
+
+	ctl_write(ctl, REG_MDP5_CTL_LAYER_REG(ctl->id, lm), blend_cfg);
+
+	spin_unlock_irqrestore(&ctl->hw_lock, flags);
+
+	ctl->cursor_on = enable;
+
+	return 0;
+}
+
+
+int mdp5_ctl_blend(void *c, u32 lm, u32 blend_cfg)
+{
+	struct mdp5_ctl *ctl = c;
+	unsigned long flags;
+
+	if (ctl->cursor_on)
+		blend_cfg |=  MDP5_CTL_LAYER_REG_CURSOR_OUT;
+	else
+		blend_cfg &= ~MDP5_CTL_LAYER_REG_CURSOR_OUT;
+
+	spin_lock_irqsave(&ctl->hw_lock, flags);
+	ctl_write(ctl, REG_MDP5_CTL_LAYER_REG(ctl->id, lm), blend_cfg);
+	spin_unlock_irqrestore(&ctl->hw_lock, flags);
+
+	return 0;
+}
+
+int mdp5_ctl_commit(void *c, u32 flush_mask)
+{
+	struct mdp5_ctl_manager *ctl_mgr = &mdp5_ctl_mgr;
+	struct mdp5_ctl *ctl = c;
+	unsigned long flags;
+
+	if (flush_mask & MDP5_CTL_FLUSH_CURSOR_DUMMY) {
+		int lm = mdp5_crtc_get_lm(ctl->crtc);
+
+		if (unlikely(WARN_ON(lm < 0))) {
+			dev_err(ctl_mgr->dev->dev, "CTL %d cannot find LM: %d",
+					ctl->id, lm);
+			return -EINVAL;
+		}
+
+		/* for current targets, cursor bit is the same as LM bit */
+		flush_mask |= mdp_ctl_flush_mask_lm(lm);
+	}
+
+	spin_lock_irqsave(&ctl->hw_lock, flags);
+	ctl_write(ctl, REG_MDP5_CTL_FLUSH(ctl->id), flush_mask);
+	spin_unlock_irqrestore(&ctl->hw_lock, flags);
+
+	return 0;
+}
+
+u32 mdp5_ctl_get_flush(void *c)
+{
+	struct mdp5_ctl *ctl = c;
+
+	return ctl->flush_mask;
+}
+
+void mdp5_ctl_release(void *c)
+{
+	struct mdp5_ctl_manager *ctl_mgr = &mdp5_ctl_mgr;
+	struct mdp5_ctl *ctl = c;
+	unsigned long flags;
+
+	if (unlikely(WARN_ON(ctl->id >= MAX_CTL) || !ctl->busy)) {
+		dev_err(ctl_mgr->dev->dev, "CTL %d in bad state (%d)",
+				ctl->id, ctl->busy);
+		return;
+	}
+
+	spin_lock_irqsave(&ctl_mgr->pool_lock, flags);
+	ctl->busy = false;
+	spin_unlock_irqrestore(&ctl_mgr->pool_lock, flags);
+
+	DBG("CTL %d released", ctl->id);
+}
+
+/*
+ * mdp5_ctl_request() - CTL dynamic allocation
+ *
+ * Note: Current implementation considers that we can only have one CRTC per CTL
+ *
+ * @return first free CTL
+ */
+void *mdp5_ctl_request(void *ctlm, void *crtc)
+{
+	struct mdp5_ctl_manager *ctl_mgr = ctlm;
+	struct mdp5_ctl *ctl = NULL;
+	unsigned long flags;
+	int c;
+
+	spin_lock_irqsave(&ctl_mgr->pool_lock, flags);
+
+	for (c = 0; c < ctl_mgr->nctl; c++)
+		if (!ctl_mgr->ctls[c].busy)
+			break;
+
+	if (unlikely(c >= ctl_mgr->nctl)) {
+		dev_err(ctl_mgr->dev->dev, "No more CTL available!");
+		goto unlock;
+	}
+
+	ctl = &ctl_mgr->ctls[c];
+
+	ctl->crtc = crtc;
+	ctl->busy = true;
+	DBG("CTL %d allocated", ctl->id);
+
+unlock:
+	spin_unlock_irqrestore(&ctl_mgr->pool_lock, flags);
+	return ctl;
+}
+
+void mdp5_ctlm_hw_reset(void *ctlm)
+{
+	struct mdp5_ctl_manager *ctl_mgr = ctlm;
+	unsigned long flags;
+	int c;
+
+	for (c = 0; c < ctl_mgr->nctl; c++) {
+		struct mdp5_ctl *ctl = &ctl_mgr->ctls[c];
+
+		spin_lock_irqsave(&ctl->hw_lock, flags);
+		ctl_write(ctl, REG_MDP5_CTL_OP(ctl->id), 0);
+		spin_unlock_irqrestore(&ctl->hw_lock, flags);
+	}
+}
+
+void mdp5_ctlm_destroy(void *ctlm)
+{
+	struct mdp5_ctl_manager *ctl_mgr = ctlm;
+
+	kfree(ctl_mgr);
+}
+
+void *mdp5_ctlm_init(struct drm_device *dev, void __iomem *mmio_base,
+		const struct mdp5_cfg_hw *hw_cfg)
+{
+	struct mdp5_ctl_manager *ctl_mgr = &mdp5_ctl_mgr;
+	const struct mdp5_sub_block *ctl_cfg = &hw_cfg->ctl;
+	unsigned long flags;
+	int c, ret;
+
+	if (unlikely(WARN_ON(ctl_cfg->count > MAX_CTL))) {
+		dev_err(dev->dev, "Increase static pool size to at least %d\n",
+				ctl_cfg->count);
+		ret = -ENOSPC;
+		goto fail;
+	}
+
+	/* initialize the CTL manager: */
+	ctl_mgr->dev = dev;
+	ctl_mgr->nlm = hw_cfg->lm.count;
+	ctl_mgr->nctl = ctl_cfg->count;
+	spin_lock_init(&ctl_mgr->pool_lock);
+
+	/* initialize each CTL of the pool: */
+	spin_lock_irqsave(&ctl_mgr->pool_lock, flags);
+	for (c = 0; c < ctl_mgr->nctl; c++) {
+		struct mdp5_ctl *ctl = &ctl_mgr->ctls[c];
+
+		if (WARN_ON(!ctl_cfg->base[c])) {
+			dev_err(dev->dev, "CTL_%d: base is null!\n", c);
+			ret = -EINVAL;
+			goto fail;
+		}
+		ctl->id = c;
+		ctl->mode = MODE_NONE;
+		ctl->reg_offset = ctl_cfg->base[c];
+		ctl->flush_mask = MDP5_CTL_FLUSH_CTL;
+		ctl->busy = false;
+		spin_lock_init(&ctl->hw_lock);
+	}
+	spin_unlock_irqrestore(&ctl_mgr->pool_lock, flags);
+	DBG("Pool of %d CTLs created.", ctl_mgr->nctl);
+
+	return ctl_mgr;
+
+fail:
+	if (ctl_mgr)
+		mdp5_ctlm_destroy(ctl_mgr);
+
+	return ERR_PTR(ret);
+}
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h
new file mode 100644
index 0000000..dbe1cae
--- /dev/null
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h
@@ -0,0 +1,121 @@
+/*
+ * Copyright (c) 2014 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MDP5_CTL_H__
+#define __MDP5_CTL_H__
+
+#include "msm_drv.h"
+
+/*
+ * CTL Manager prototypes:
+ * mdp5_ctlm_init() returns a ctlm (CTL Manager) handler,
+ * which is then used to call the other mdp5_ctlm_*(ctlm, ...) functions.
+ */
+void *mdp5_ctlm_init(struct drm_device *dev, void __iomem *mmio_base,
+		const struct mdp5_cfg_hw *hw_cfg);
+void  mdp5_ctlm_hw_reset(void *ctlm);
+void  mdp5_ctlm_destroy(void *ctlm);
+
+/*
+ * CTL prototypes:
+ * mdp5_ctl_request(ctlm, ...) returns a ctl (CTL resource) handler,
+ * which is then used to call the other mdp5_ctl_*(ctl, ...) functions.
+ */
+void *mdp5_ctl_request(void *ctlm, void *crtc);
+
+int mdp5_ctl_set_intf(void *ctl, enum mdp5_intf intf);
+
+int mdp5_ctl_set_cursor(void *ctl, bool enable);
+
+/* @blend_cfg: see LM blender config definition below */
+int mdp5_ctl_blend(void *ctl, u32 lm, u32 blend_cfg);
+
+/* @flush_mask: see CTL flush masks definitions below */
+int mdp5_ctl_commit(void *ctl, u32 flush_mask);
+u32 mdp5_ctl_get_flush(void *ctl);
+
+void mdp5_ctl_release(void *ctl);
+
+/*
+ * blend_cfg (LM blender config):
+ *
+ * The function below allows the caller of mdp5_ctl_blend() to specify how pipes
+ * are being blended according to their stage (z-order), through @blend_cfg arg.
+ */
+static inline u32 mdp_ctl_blend_mask(enum mdp5_pipe pipe,
+		enum mdp_mixer_stage_id stage)
+{
+	switch (pipe) {
+	case SSPP_VIG0: return MDP5_CTL_LAYER_REG_VIG0(stage);
+	case SSPP_VIG1: return MDP5_CTL_LAYER_REG_VIG1(stage);
+	case SSPP_VIG2: return MDP5_CTL_LAYER_REG_VIG2(stage);
+	case SSPP_RGB0: return MDP5_CTL_LAYER_REG_RGB0(stage);
+	case SSPP_RGB1: return MDP5_CTL_LAYER_REG_RGB1(stage);
+	case SSPP_RGB2: return MDP5_CTL_LAYER_REG_RGB2(stage);
+	case SSPP_DMA0: return MDP5_CTL_LAYER_REG_DMA0(stage);
+	case SSPP_DMA1: return MDP5_CTL_LAYER_REG_DMA1(stage);
+	case SSPP_VIG3: return MDP5_CTL_LAYER_REG_VIG3(stage);
+	case SSPP_RGB3: return MDP5_CTL_LAYER_REG_RGB3(stage);
+	default:	return 0;
+	}
+}
+
+/*
+ * flush_mask (CTL flush masks):
+ *
+ * The following functions allow each DRM entity to get and store
+ * their own flush mask.
+ * Once stored, these masks will then be accessed through each DRM's
+ * interface and used by the caller of mdp5_ctl_commit() to specify
+ * which block(s) need to be flushed through @flush_mask parameter.
+ */
+
+#define MDP5_CTL_FLUSH_CURSOR_DUMMY	0x80000000
+
+static inline u32 mdp_ctl_flush_mask_cursor(int cursor_id)
+{
+	/* TODO: use id once multiple cursor support is present */
+	(void)cursor_id;
+
+	return MDP5_CTL_FLUSH_CURSOR_DUMMY;
+}
+
+static inline u32 mdp_ctl_flush_mask_lm(int lm)
+{
+	switch (lm) {
+	case 0:  return MDP5_CTL_FLUSH_LM0;
+	case 1:  return MDP5_CTL_FLUSH_LM1;
+	case 2:  return MDP5_CTL_FLUSH_LM2;
+	case 5:  return MDP5_CTL_FLUSH_LM5;
+	default: return 0;
+	}
+}
+
+static inline u32 mdp_ctl_flush_mask_pipe(enum mdp5_pipe pipe)
+{
+	switch (pipe) {
+	case SSPP_VIG0: return MDP5_CTL_FLUSH_VIG0;
+	case SSPP_VIG1: return MDP5_CTL_FLUSH_VIG1;
+	case SSPP_VIG2: return MDP5_CTL_FLUSH_VIG2;
+	case SSPP_RGB0: return MDP5_CTL_FLUSH_RGB0;
+	case SSPP_RGB1: return MDP5_CTL_FLUSH_RGB1;
+	case SSPP_RGB2: return MDP5_CTL_FLUSH_RGB2;
+	case SSPP_DMA0: return MDP5_CTL_FLUSH_DMA0;
+	case SSPP_DMA1: return MDP5_CTL_FLUSH_DMA1;
+	case SSPP_VIG3: return MDP5_CTL_FLUSH_VIG3;
+	case SSPP_RGB3: return MDP5_CTL_FLUSH_RGB3;
+	default:        return 0;
+	}
+}
+
+#endif /* __MDP5_CTL_H__ */
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c
index edec7bf..25c2fcb 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c
@@ -24,6 +24,7 @@ struct mdp5_encoder {
 	struct drm_encoder base;
 	int intf;
 	enum mdp5_intf intf_id;
+	spinlock_t intf_lock;	/* protect REG_MDP5_INTF_* registers */
 	bool enabled;
 	uint32_t bsc;
 };
@@ -115,6 +116,7 @@ static void mdp5_encoder_dpms(struct drm_encoder *encoder, int mode)
 	struct mdp5_kms *mdp5_kms = get_kms(encoder);
 	int intf = mdp5_encoder->intf;
 	bool enabled = (mode == DRM_MODE_DPMS_ON);
+	unsigned long flags;
 
 	DBG("mode=%d", mode);
 
@@ -123,9 +125,13 @@ static void mdp5_encoder_dpms(struct drm_encoder *encoder, int mode)
 
 	if (enabled) {
 		bs_set(mdp5_encoder, 1);
+		spin_lock_irqsave(&mdp5_encoder->intf_lock, flags);
 		mdp5_write(mdp5_kms, REG_MDP5_INTF_TIMING_ENGINE_EN(intf), 1);
+		spin_unlock_irqrestore(&mdp5_encoder->intf_lock, flags);
 	} else {
+		spin_lock_irqsave(&mdp5_encoder->intf_lock, flags);
 		mdp5_write(mdp5_kms, REG_MDP5_INTF_TIMING_ENGINE_EN(intf), 0);
+		spin_unlock_irqrestore(&mdp5_encoder->intf_lock, flags);
 		bs_set(mdp5_encoder, 0);
 	}
 
@@ -150,6 +156,7 @@ static void mdp5_encoder_mode_set(struct drm_encoder *encoder,
 	uint32_t display_v_start, display_v_end;
 	uint32_t hsync_start_x, hsync_end_x;
 	uint32_t format;
+	unsigned long flags;
 
 	mode = adjusted_mode;
 
@@ -180,6 +187,8 @@ static void mdp5_encoder_mode_set(struct drm_encoder *encoder,
 	display_v_start = (mode->vtotal - mode->vsync_start) * mode->htotal + dtv_hsync_skew;
 	display_v_end = vsync_period - ((mode->vsync_start - mode->vdisplay) * mode->htotal) + dtv_hsync_skew - 1;
 
+	spin_lock_irqsave(&mdp5_encoder->intf_lock, flags);
+
 	mdp5_write(mdp5_kms, REG_MDP5_INTF_HSYNC_CTL(intf),
 			MDP5_INTF_HSYNC_CTL_PULSEW(mode->hsync_end - mode->hsync_start) |
 			MDP5_INTF_HSYNC_CTL_PERIOD(mode->htotal));
@@ -201,6 +210,8 @@ static void mdp5_encoder_mode_set(struct drm_encoder *encoder,
 	mdp5_write(mdp5_kms, REG_MDP5_INTF_ACTIVE_VEND_F0(intf), 0);
 	mdp5_write(mdp5_kms, REG_MDP5_INTF_PANEL_FORMAT(intf), format);
 	mdp5_write(mdp5_kms, REG_MDP5_INTF_FRAME_LINE_COUNT_EN(intf), 0x3);  /* frame+line? */
+
+	spin_unlock_irqrestore(&mdp5_encoder->intf_lock, flags);
 }
 
 static void mdp5_encoder_prepare(struct drm_encoder *encoder)
@@ -242,6 +253,8 @@ struct drm_encoder *mdp5_encoder_init(struct drm_device *dev, int intf,
 	mdp5_encoder->intf_id = intf_id;
 	encoder = &mdp5_encoder->base;
 
+	spin_lock_init(&mdp5_encoder->intf_lock);
+
 	drm_encoder_init(dev, encoder, &mdp5_encoder_funcs,
 			 DRM_MODE_ENCODER_TMDS);
 	drm_encoder_helper_add(encoder, &mdp5_encoder_helper_funcs);
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
index 76bd860..83feb9e 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
@@ -28,9 +28,8 @@ static const char *iommu_ports[] = {
 static int mdp5_hw_init(struct msm_kms *kms)
 {
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
-	const struct mdp5_cfg_hw *hw_cfg;
 	struct drm_device *dev = mdp5_kms->dev;
-	int i;
+	unsigned long flags;
 
 	pm_runtime_get_sync(dev->dev);
 
@@ -58,12 +57,11 @@ static int mdp5_hw_init(struct msm_kms *kms)
 	 * care.
 	 */
 
+	spin_lock_irqsave(&mdp5_kms->resource_lock, flags);
 	mdp5_write(mdp5_kms, REG_MDP5_DISP_INTF_SEL, 0);
+	spin_unlock_irqrestore(&mdp5_kms->resource_lock, flags);
 
-	hw_cfg = mdp5_cfg_get_hw_config(mdp5_kms->cfg_priv);
-
-	for (i = 0; i < hw_cfg->ctl.count; i++)
-		mdp5_write(mdp5_kms, REG_MDP5_CTL_OP(i), 0);
+	mdp5_ctlm_hw_reset(mdp5_kms->ctl_priv);
 
 	pm_runtime_put_sync(dev->dev);
 
@@ -92,11 +90,14 @@ static void mdp5_destroy(struct msm_kms *kms)
 	struct msm_mmu *mmu = mdp5_kms->mmu;
 	void *smp = mdp5_kms->smp_priv;
 	void *cfg = mdp5_kms->cfg_priv;
+	void *ctl = mdp5_kms->ctl_priv;
 
 	if (mmu) {
 		mmu->funcs->detach(mmu, iommu_ports, ARRAY_SIZE(iommu_ports));
 		mmu->funcs->destroy(mmu);
 	}
+	if (ctl)
+		mdp5_ctlm_destroy(ctl);
 	if (smp)
 		mdp5_smp_destroy(smp);
 	if (cfg)
@@ -151,6 +152,9 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
 	static const enum mdp5_pipe crtcs[] = {
 			SSPP_RGB0, SSPP_RGB1, SSPP_RGB2, SSPP_RGB3,
 	};
+	static const enum mdp5_pipe pub_planes[] = {
+			SSPP_VIG0, SSPP_VIG1, SSPP_VIG2, SSPP_VIG3,
+	};
 	struct drm_device *dev = mdp5_kms->dev;
 	struct msm_drm_private *priv = dev->dev_private;
 	struct drm_encoder *encoder;
@@ -159,12 +163,13 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
 
 	hw_cfg = mdp5_cfg_get_hw_config(mdp5_kms->cfg_priv);
 
-	/* construct CRTCs: */
+	/* construct CRTCs and their private planes: */
 	for (i = 0; i < hw_cfg->pipe_rgb.count; i++) {
 		struct drm_plane *plane;
 		struct drm_crtc *crtc;
 
-		plane = mdp5_plane_init(dev, crtcs[i], true);
+		plane = mdp5_plane_init(dev, crtcs[i], true,
+				hw_cfg->pipe_rgb.base[i]);
 		if (IS_ERR(plane)) {
 			ret = PTR_ERR(plane);
 			dev_err(dev->dev, "failed to construct plane for %s (%d)\n",
@@ -182,6 +187,20 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
 		priv->crtcs[priv->num_crtcs++] = crtc;
 	}
 
+	/* Construct public planes: */
+	for (i = 0; i < hw_cfg->pipe_vig.count; i++) {
+		struct drm_plane *plane;
+
+		plane = mdp5_plane_init(dev, pub_planes[i], false,
+				hw_cfg->pipe_vig.base[i]);
+		if (IS_ERR(plane)) {
+			ret = PTR_ERR(plane);
+			dev_err(dev->dev, "failed to construct %s plane: %d\n",
+					pipe2name(pub_planes[i]), ret);
+			goto fail;
+		}
+	}
+
 	/* NOTE: the vsync and error irq's are actually associated with
 	 * the INTF/encoder.. the easiest way to deal with this (ie. what
 	 * we do now) is assume a fixed relationship between crtc's and
@@ -199,9 +218,7 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
 			goto fail;
 		}
 
-		encoder->possible_crtcs = BIT(0);
-		mdp5_crtc_set_intf(priv->crtcs[0], 3, INTF_HDMI);
-
+		encoder->possible_crtcs = (1 << priv->num_crtcs) - 1;
 		priv->encoders[priv->num_encoders++] = encoder;
 
 		ret = hdmi_set_encoder(priv->hdmi_pdev, encoder);
@@ -267,6 +284,8 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 		goto fail;
 	}
 
+	spin_lock_init(&mdp5_kms->resource_lock);
+
 	mdp_kms_init(&mdp5_kms->base, &kms_funcs);
 
 	kms = &mdp5_kms->base.base;
@@ -335,6 +354,13 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 	}
 	mdp5_kms->smp_priv = priv;
 
+	priv = mdp5_ctlm_init(dev, mdp5_kms->mmio, config->hw);
+	if (IS_ERR(priv)) {
+		ret = PTR_ERR(priv);
+		goto fail;
+	}
+	mdp5_kms->ctl_priv = priv;
+
 	/* make sure things are off before attaching iommu (bootloader could
 	 * have left things on, in which case we'll start getting faults if
 	 * we don't disable):
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
index 7616a3b..5e7cc91 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
@@ -23,6 +23,7 @@
 #include "mdp/mdp_kms.h"
 #include "mdp5_cfg.h"	/* must be included before mdp5.xml.h */
 #include "mdp5.xml.h"
+#include "mdp5_ctl.h"
 #include "mdp5_smp.h"
 
 struct mdp5_kms {
@@ -37,6 +38,7 @@ struct mdp5_kms {
 	struct msm_mmu *mmu;
 
 	void *smp_priv;
+	void *ctl_priv;
 
 	/* io/register spaces: */
 	void __iomem *mmio, *vbif;
@@ -50,10 +52,20 @@ struct mdp5_kms {
 	struct clk *lut_clk;
 	struct clk *vsync_clk;
 
+	/*
+	 * lock to protect access to global resources: ie., following register:
+	 *	- REG_MDP5_DISP_INTF_SEL
+	 */
+	spinlock_t resource_lock;
+
 	struct mdp_irq error_handler;
 };
 #define to_mdp5_kms(x) container_of(x, struct mdp5_kms, base)
 
+struct mdp5_overlay_info {
+	enum mdp_mixer_stage_id zorder;
+};
+
 static inline void mdp5_write(struct mdp5_kms *mdp5_kms, u32 reg, u32 data)
 {
 	msm_writel(data, mdp5_kms->mmio + reg);
@@ -77,23 +89,6 @@ static inline const char *pipe2name(enum mdp5_pipe pipe)
 	return names[pipe];
 }
 
-static inline uint32_t pipe2flush(enum mdp5_pipe pipe)
-{
-	switch (pipe) {
-	case SSPP_VIG0: return MDP5_CTL_FLUSH_VIG0;
-	case SSPP_VIG1: return MDP5_CTL_FLUSH_VIG1;
-	case SSPP_VIG2: return MDP5_CTL_FLUSH_VIG2;
-	case SSPP_RGB0: return MDP5_CTL_FLUSH_RGB0;
-	case SSPP_RGB1: return MDP5_CTL_FLUSH_RGB1;
-	case SSPP_RGB2: return MDP5_CTL_FLUSH_RGB2;
-	case SSPP_DMA0: return MDP5_CTL_FLUSH_DMA0;
-	case SSPP_DMA1: return MDP5_CTL_FLUSH_DMA1;
-	case SSPP_VIG3: return MDP5_CTL_FLUSH_VIG3;
-	case SSPP_RGB3: return MDP5_CTL_FLUSH_RGB3;
-	default:        return 0;
-	}
-}
-
 static inline int pipe2nclients(enum mdp5_pipe pipe)
 {
 	switch (pipe) {
@@ -107,16 +102,6 @@ static inline int pipe2nclients(enum mdp5_pipe pipe)
 	}
 }
 
-static inline uint32_t mixer2flush(int lm)
-{
-	switch (lm) {
-	case 0:  return MDP5_CTL_FLUSH_LM0;
-	case 1:  return MDP5_CTL_FLUSH_LM1;
-	case 2:  return MDP5_CTL_FLUSH_LM2;
-	default: return 0;
-	}
-}
-
 static inline uint32_t intf2err(int intf)
 {
 	switch (intf) {
@@ -162,6 +147,10 @@ uint32_t mdp5_get_formats(enum mdp5_pipe pipe, uint32_t *pixel_formats,
 
 void mdp5_plane_install_properties(struct drm_plane *plane,
 		struct drm_mode_object *obj);
+void mdp5_plane_set_overlay_info(struct drm_plane *plane,
+		const struct mdp5_overlay_info *overlay_info);
+struct mdp5_overlay_info *mdp5_plane_get_overlay_info(struct drm_plane *plane);
+uint32_t mdp5_plane_get_flush(struct drm_plane *plane);
 void mdp5_plane_set_scanout(struct drm_plane *plane,
 		struct drm_framebuffer *fb);
 int mdp5_plane_mode_set(struct drm_plane *plane,
@@ -173,14 +162,15 @@ int mdp5_plane_mode_set(struct drm_plane *plane,
 void mdp5_plane_complete_flip(struct drm_plane *plane);
 enum mdp5_pipe mdp5_plane_pipe(struct drm_plane *plane);
 struct drm_plane *mdp5_plane_init(struct drm_device *dev,
-		enum mdp5_pipe pipe, bool private_plane);
+		enum mdp5_pipe pipe, bool private_plane, uint32_t reg_offset);
 
 uint32_t mdp5_crtc_vblank(struct drm_crtc *crtc);
 
+int mdp5_crtc_get_lm(struct drm_crtc *crtc);
 void mdp5_crtc_cancel_pending_flip(struct drm_crtc *crtc, struct drm_file *file);
 void mdp5_crtc_set_intf(struct drm_crtc *crtc, int intf,
 		enum mdp5_intf intf_id);
-void mdp5_crtc_attach(struct drm_crtc *crtc, struct drm_plane *plane);
+int  mdp5_crtc_attach(struct drm_crtc *crtc, struct drm_plane *plane);
 void mdp5_crtc_detach(struct drm_crtc *crtc, struct drm_plane *plane);
 struct drm_crtc *mdp5_crtc_init(struct drm_device *dev,
 		struct drm_plane *plane, int id);
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
index 633ca08..59703fa 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014 The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
  *
@@ -17,6 +18,7 @@
 
 #include "mdp5_kms.h"
 
+#define MAX_PLANE	4
 
 struct mdp5_plane {
 	struct drm_plane base;
@@ -24,6 +26,13 @@ struct mdp5_plane {
 
 	enum mdp5_pipe pipe;
 
+	spinlock_t pipe_lock;	/* protect REG_MDP5_PIPE_* registers */
+	uint32_t reg_offset;
+
+	uint32_t flush_mask;	/* used to commit pipe registers */
+
+	struct mdp5_overlay_info overlay_info;
+
 	uint32_t nformats;
 	uint32_t formats[32];
 
@@ -95,6 +104,22 @@ static void mdp5_plane_destroy(struct drm_plane *plane)
 	kfree(mdp5_plane);
 }
 
+void mdp5_plane_set_overlay_info(struct drm_plane *plane,
+		const struct mdp5_overlay_info *overlay_info)
+{
+	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
+
+	memcpy(&mdp5_plane->overlay_info, overlay_info, sizeof(*overlay_info));
+}
+
+struct mdp5_overlay_info *mdp5_plane_get_overlay_info(
+		struct drm_plane *plane)
+{
+	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
+
+	return &mdp5_plane->overlay_info;
+}
+
 /* helper to install properties which are common to planes and crtcs */
 void mdp5_plane_install_properties(struct drm_plane *plane,
 		struct drm_mode_object *obj)
@@ -116,35 +141,58 @@ static const struct drm_plane_funcs mdp5_plane_funcs = {
 		.set_property = mdp5_plane_set_property,
 };
 
-void mdp5_plane_set_scanout(struct drm_plane *plane,
-		struct drm_framebuffer *fb)
+static int get_fb_addr(struct drm_plane *plane, struct drm_framebuffer *fb,
+		uint32_t iova[MAX_PLANE])
 {
-	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
 	struct mdp5_kms *mdp5_kms = get_kms(plane);
-	enum mdp5_pipe pipe = mdp5_plane->pipe;
 	uint32_t nplanes = drm_format_num_planes(fb->pixel_format);
-	uint32_t iova[4];
 	int i;
 
 	for (i = 0; i < nplanes; i++) {
 		struct drm_gem_object *bo = msm_framebuffer_bo(fb, i);
 		msm_gem_get_iova(bo, mdp5_kms->id, &iova[i]);
 	}
-	for (; i < 4; i++)
+	for (; i < MAX_PLANE; i++)
 		iova[i] = 0;
 
+	return 0;
+}
+
+static void set_scanout_locked(struct drm_plane *plane,
+		uint32_t pitches[MAX_PLANE], uint32_t src_addr[MAX_PLANE])
+{
+	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
+	struct mdp5_kms *mdp5_kms = get_kms(plane);
+	enum mdp5_pipe pipe = mdp5_plane->pipe;
+
+	WARN_ON(!spin_is_locked(&mdp5_plane->pipe_lock));
+
 	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC_STRIDE_A(pipe),
-			MDP5_PIPE_SRC_STRIDE_A_P0(fb->pitches[0]) |
-			MDP5_PIPE_SRC_STRIDE_A_P1(fb->pitches[1]));
+			MDP5_PIPE_SRC_STRIDE_A_P0(pitches[0]) |
+			MDP5_PIPE_SRC_STRIDE_A_P1(pitches[1]));
 
 	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC_STRIDE_B(pipe),
-			MDP5_PIPE_SRC_STRIDE_B_P2(fb->pitches[2]) |
-			MDP5_PIPE_SRC_STRIDE_B_P3(fb->pitches[3]));
+			MDP5_PIPE_SRC_STRIDE_B_P2(pitches[2]) |
+			MDP5_PIPE_SRC_STRIDE_B_P3(pitches[3]));
+
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC0_ADDR(pipe), src_addr[0]);
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC1_ADDR(pipe), src_addr[1]);
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC2_ADDR(pipe), src_addr[2]);
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC3_ADDR(pipe), src_addr[3]);
+}
+
+void mdp5_plane_set_scanout(struct drm_plane *plane,
+		struct drm_framebuffer *fb)
+{
+	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
+	uint32_t src_addr[MAX_PLANE];
+	unsigned long flags;
 
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC0_ADDR(pipe), iova[0]);
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC1_ADDR(pipe), iova[1]);
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC2_ADDR(pipe), iova[2]);
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC3_ADDR(pipe), iova[3]);
+	get_fb_addr(plane, fb, src_addr);
+
+	spin_lock_irqsave(&mdp5_plane->pipe_lock, flags);
+	set_scanout_locked(plane, fb->pitches, src_addr);
+	spin_unlock_irqrestore(&mdp5_plane->pipe_lock, flags);
 
 	plane->fb = fb;
 }
@@ -163,6 +211,8 @@ int mdp5_plane_mode_set(struct drm_plane *plane,
 	uint32_t nplanes, config = 0;
 	uint32_t phasex_step = 0, phasey_step = 0;
 	uint32_t hdecm = 0, vdecm = 0;
+	uint32_t src_addr[MAX_PLANE];
+	unsigned long flags;
 	int ret;
 
 	nplanes = drm_format_num_planes(fb->pixel_format);
@@ -205,6 +255,12 @@ int mdp5_plane_mode_set(struct drm_plane *plane,
 		/* TODO calc phasey_step, vdecm */
 	}
 
+	ret = get_fb_addr(plane, fb, src_addr);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&mdp5_plane->pipe_lock, flags);
+
 	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC_IMG_SIZE(pipe),
 			MDP5_PIPE_SRC_IMG_SIZE_WIDTH(src_w) |
 			MDP5_PIPE_SRC_IMG_SIZE_HEIGHT(src_h));
@@ -225,8 +281,6 @@ int mdp5_plane_mode_set(struct drm_plane *plane,
 			MDP5_PIPE_OUT_XY_X(crtc_x) |
 			MDP5_PIPE_OUT_XY_Y(crtc_y));
 
-	mdp5_plane_set_scanout(plane, fb);
-
 	format = to_mdp_format(msm_framebuffer_format(fb));
 
 	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC_FORMAT(pipe),
@@ -266,10 +320,14 @@ int mdp5_plane_mode_set(struct drm_plane *plane,
 			MDP5_PIPE_SCALE_CONFIG_SCALEX_MAX_FILTER(SCALE_FILTER_NEAREST) |
 			MDP5_PIPE_SCALE_CONFIG_SCALEY_MAX_FILTER(SCALE_FILTER_NEAREST));
 
+	set_scanout_locked(plane, fb->pitches, src_addr);
+
+	spin_unlock_irqrestore(&mdp5_plane->pipe_lock, flags);
+
 	/* TODO detach from old crtc (if we had more than one) */
-	mdp5_crtc_attach(crtc, plane);
+	ret = mdp5_crtc_attach(crtc, plane);
 
-	return 0;
+	return ret;
 }
 
 void mdp5_plane_complete_flip(struct drm_plane *plane)
@@ -286,9 +344,16 @@ enum mdp5_pipe mdp5_plane_pipe(struct drm_plane *plane)
 	return mdp5_plane->pipe;
 }
 
+uint32_t mdp5_plane_get_flush(struct drm_plane *plane)
+{
+	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
+
+	return mdp5_plane->flush_mask;
+}
+
 /* initialize plane */
 struct drm_plane *mdp5_plane_init(struct drm_device *dev,
-		enum mdp5_pipe pipe, bool private_plane)
+		enum mdp5_pipe pipe, bool private_plane, uint32_t reg_offset)
 {
 	struct drm_plane *plane = NULL;
 	struct mdp5_plane *mdp5_plane;
@@ -309,6 +374,10 @@ struct drm_plane *mdp5_plane_init(struct drm_device *dev,
 	mdp5_plane->nformats = mdp5_get_formats(pipe, mdp5_plane->formats,
 			ARRAY_SIZE(mdp5_plane->formats));
 
+	mdp5_plane->flush_mask = mdp_ctl_flush_mask_pipe(pipe);
+	mdp5_plane->reg_offset = reg_offset;
+	spin_lock_init(&mdp5_plane->pipe_lock);
+
 	type = private_plane ? DRM_PLANE_TYPE_PRIMARY : DRM_PLANE_TYPE_OVERLAY;
 	drm_universal_plane_init(dev, plane, 0xff, &mdp5_plane_funcs,
 				 mdp5_plane->formats, mdp5_plane->nformats,
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

