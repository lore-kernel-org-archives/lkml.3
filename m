Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbbAMWSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:18:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44253 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbAMWSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:18:34 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, gbeeresh@codeaurora.org,
        Wentao Xu <wentaox@codeaurora.org>,
        Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 2/2] drm/msm/mdp5: Add hardware cursor support
Date: Tue, 13 Jan 2015 17:18:04 -0500
Message-Id: <1421187484-13875-3-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1421187484-13875-1-git-send-email-sviau@codeaurora.org>
References: <1421187484-13875-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Beeresh Gopal <gbeeresh@codeaurora.org>

This patch implements the hardware accelarated cursor
support for MDP5 platforms.

Signed-off-by: Beeresh Gopal <gbeeresh@codeaurora.org>
Signed-off-by: Wentao Xu <wentaox@codeaurora.org>
Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c | 164 +++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
index f021f96..2021f09 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
@@ -24,6 +24,9 @@
 #include "drm_crtc_helper.h"
 #include "drm_flip_work.h"
 
+#define CURSOR_WIDTH	64
+#define CURSOR_HEIGHT	64
+
 #define SSPP_MAX	(SSPP_RGB3 + 1) /* TODO: Add SSPP_MAX in mdp5.xml.h */
 
 struct mdp5_crtc {
@@ -47,8 +50,21 @@ struct mdp5_crtc {
 #define PENDING_FLIP   0x2
 	atomic_t pending;
 
+	/* for unref'ing cursor bo's after scanout completes: */
+	struct drm_flip_work unref_cursor_work;
+
 	struct mdp_irq vblank;
 	struct mdp_irq err;
+
+	struct {
+		/* protect REG_MDP5_LM_CURSOR* registers and cursor scanout_bo*/
+		spinlock_t lock;
+
+		/* current cursor being scanned out: */
+		struct drm_gem_object *scanout_bo;
+		uint32_t width;
+		uint32_t height;
+	} cursor;
 };
 #define to_mdp5_crtc(x) container_of(x, struct mdp5_crtc, base)
 
@@ -129,11 +145,22 @@ static void complete_flip(struct drm_crtc *crtc, struct drm_file *file)
 	}
 }
 
+static void unref_cursor_worker(struct drm_flip_work *work, void *val)
+{
+	struct mdp5_crtc *mdp5_crtc =
+		container_of(work, struct mdp5_crtc, unref_cursor_work);
+	struct mdp5_kms *mdp5_kms = get_kms(&mdp5_crtc->base);
+
+	msm_gem_put_iova(val, mdp5_kms->id);
+	drm_gem_object_unreference_unlocked(val);
+}
+
 static void mdp5_crtc_destroy(struct drm_crtc *crtc)
 {
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
 
 	drm_crtc_cleanup(crtc);
+	drm_flip_work_cleanup(&mdp5_crtc->unref_cursor_work);
 
 	kfree(mdp5_crtc);
 }
@@ -384,6 +411,132 @@ static int mdp5_crtc_set_property(struct drm_crtc *crtc,
 	return -EINVAL;
 }
 
+static int mdp5_crtc_cursor_set(struct drm_crtc *crtc,
+		struct drm_file *file, uint32_t handle,
+		uint32_t width, uint32_t height)
+{
+	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
+	struct drm_device *dev = crtc->dev;
+	struct mdp5_kms *mdp5_kms = get_kms(crtc);
+	struct drm_gem_object *cursor_bo, *old_bo;
+	uint32_t blendcfg, cursor_addr, stride;
+	int ret, bpp, lm;
+	unsigned int depth;
+	enum mdp5_cursor_alpha cur_alpha = CURSOR_ALPHA_PER_PIXEL;
+	uint32_t flush_mask = mdp_ctl_flush_mask_cursor(0);
+	unsigned long flags;
+
+	if ((width > CURSOR_WIDTH) || (height > CURSOR_HEIGHT)) {
+		dev_err(dev->dev, "bad cursor size: %dx%d\n", width, height);
+		return -EINVAL;
+	}
+
+	if (NULL == mdp5_crtc->ctl)
+		return -EINVAL;
+
+	if (!handle) {
+		DBG("Cursor off");
+		return mdp5_ctl_set_cursor(mdp5_crtc->ctl, false);
+	}
+
+	cursor_bo = drm_gem_object_lookup(dev, file, handle);
+	if (!cursor_bo)
+		return -ENOENT;
+
+	ret = msm_gem_get_iova(cursor_bo, mdp5_kms->id, &cursor_addr);
+	if (ret)
+		return -EINVAL;
+
+	lm = mdp5_crtc->lm;
+	drm_fb_get_bpp_depth(DRM_FORMAT_ARGB8888, &depth, &bpp);
+	stride = width * (bpp >> 3);
+
+	spin_lock_irqsave(&mdp5_crtc->cursor.lock, flags);
+	old_bo = mdp5_crtc->cursor.scanout_bo;
+
+	mdp5_write(mdp5_kms, REG_MDP5_LM_CURSOR_STRIDE(lm), stride);
+	mdp5_write(mdp5_kms, REG_MDP5_LM_CURSOR_FORMAT(lm),
+			MDP5_LM_CURSOR_FORMAT_FORMAT(CURSOR_FMT_ARGB8888));
+	mdp5_write(mdp5_kms, REG_MDP5_LM_CURSOR_IMG_SIZE(lm),
+			MDP5_LM_CURSOR_IMG_SIZE_SRC_H(height) |
+			MDP5_LM_CURSOR_IMG_SIZE_SRC_W(width));
+	mdp5_write(mdp5_kms, REG_MDP5_LM_CURSOR_SIZE(lm),
+			MDP5_LM_CURSOR_SIZE_ROI_H(height) |
+			MDP5_LM_CURSOR_SIZE_ROI_W(width));
+	mdp5_write(mdp5_kms, REG_MDP5_LM_CURSOR_BASE_ADDR(lm), cursor_addr);
+
+
+	blendcfg = MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_EN;
+	blendcfg |= MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_TRANSP_EN;
+	blendcfg |= MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_ALPHA_SEL(cur_alpha);
+	mdp5_write(mdp5_kms, REG_MDP5_LM_CURSOR_BLEND_CONFIG(lm), blendcfg);
+
+	mdp5_crtc->cursor.scanout_bo = cursor_bo;
+	mdp5_crtc->cursor.width = width;
+	mdp5_crtc->cursor.height = height;
+	spin_unlock_irqrestore(&mdp5_crtc->cursor.lock, flags);
+
+	ret = mdp5_ctl_set_cursor(mdp5_crtc->ctl, true);
+	if (ret)
+		goto end;
+
+	flush_mask |= mdp5_ctl_get_flush(mdp5_crtc->ctl);
+	crtc_flush(crtc, flush_mask);
+
+end:
+	if (old_bo) {
+		drm_flip_work_queue(&mdp5_crtc->unref_cursor_work, old_bo);
+		/* enable vblank to complete cursor work: */
+		request_pending(crtc, PENDING_CURSOR);
+	}
+	return ret;
+}
+
+static int mdp5_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
+{
+	struct mdp5_kms *mdp5_kms = get_kms(crtc);
+	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
+	uint32_t flush_mask = mdp_ctl_flush_mask_cursor(0);
+	uint32_t xres = crtc->mode.hdisplay;
+	uint32_t yres = crtc->mode.vdisplay;
+	uint32_t roi_w;
+	uint32_t roi_h;
+	unsigned long flags;
+
+	x = (x > 0) ? x : 0;
+	y = (y > 0) ? y : 0;
+
+	/*
+	 * Cursor Region Of Interest (ROI) is a plane read from cursor
+	 * buffer to render. The ROI region is determined by the visiblity of
+	 * the cursor point. In the default Cursor image the cursor point will
+	 * be at the top left of the cursor image, unless it is specified
+	 * otherwise using hotspot feature.
+	 *
+	 * If the cursor point reaches the right (xres - x < cursor.width) or
+	 * bottom (yres - y < cursor.height) boundary of the screen, then ROI
+	 * width and ROI height need to be evaluated to crop the cursor image
+	 * accordingly.
+	 * (xres-x) will be new cursor width when x > (xres - cursor.width)
+	 * (yres-y) will be new cursor height when y > (yres - cursor.height)
+	 */
+	roi_w = min(mdp5_crtc->cursor.width, xres - x);
+	roi_h = min(mdp5_crtc->cursor.height, yres - y);
+
+	spin_lock_irqsave(&mdp5_crtc->cursor.lock, flags);
+	mdp5_write(mdp5_kms, REG_MDP5_LM_CURSOR_SIZE(mdp5_crtc->lm),
+			MDP5_LM_CURSOR_SIZE_ROI_H(roi_h) |
+			MDP5_LM_CURSOR_SIZE_ROI_W(roi_w));
+	mdp5_write(mdp5_kms, REG_MDP5_LM_CURSOR_START_XY(mdp5_crtc->lm),
+			MDP5_LM_CURSOR_START_XY_Y_START(y) |
+			MDP5_LM_CURSOR_START_XY_X_START(x));
+	spin_unlock_irqrestore(&mdp5_crtc->cursor.lock, flags);
+
+	crtc_flush(crtc, flush_mask);
+
+	return 0;
+}
+
 static const struct drm_crtc_funcs mdp5_crtc_funcs = {
 	.set_config = drm_atomic_helper_set_config,
 	.destroy = mdp5_crtc_destroy,
@@ -392,6 +545,8 @@ static const struct drm_crtc_funcs mdp5_crtc_funcs = {
 	.reset = drm_atomic_helper_crtc_reset,
 	.atomic_duplicate_state = drm_atomic_helper_crtc_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_crtc_destroy_state,
+	.cursor_set = mdp5_crtc_cursor_set,
+	.cursor_move = mdp5_crtc_cursor_move,
 };
 
 static const struct drm_crtc_helper_funcs mdp5_crtc_helper_funcs = {
@@ -412,6 +567,7 @@ static void mdp5_crtc_vblank_irq(struct mdp_irq *irq, uint32_t irqstatus)
 {
 	struct mdp5_crtc *mdp5_crtc = container_of(irq, struct mdp5_crtc, vblank);
 	struct drm_crtc *crtc = &mdp5_crtc->base;
+	struct msm_drm_private *priv = crtc->dev->dev_private;
 	unsigned pending;
 
 	mdp_irq_unregister(&get_kms(crtc)->base, &mdp5_crtc->vblank);
@@ -421,6 +577,9 @@ static void mdp5_crtc_vblank_irq(struct mdp_irq *irq, uint32_t irqstatus)
 	if (pending & PENDING_FLIP) {
 		complete_flip(crtc, NULL);
 	}
+
+	if (pending & PENDING_CURSOR)
+		drm_flip_work_commit(&mdp5_crtc->unref_cursor_work, priv->wq);
 }
 
 static void mdp5_crtc_err_irq(struct mdp_irq *irq, uint32_t irqstatus)
@@ -520,6 +679,7 @@ struct drm_crtc *mdp5_crtc_init(struct drm_device *dev,
 	mdp5_crtc->lm = GET_LM_ID(id);
 
 	spin_lock_init(&mdp5_crtc->lm_lock);
+	spin_lock_init(&mdp5_crtc->cursor.lock);
 
 	mdp5_crtc->vblank.irq = mdp5_crtc_vblank_irq;
 	mdp5_crtc->err.irq = mdp5_crtc_err_irq;
@@ -528,6 +688,10 @@ struct drm_crtc *mdp5_crtc_init(struct drm_device *dev,
 			pipe2name(mdp5_plane_pipe(plane)), id);
 
 	drm_crtc_init_with_planes(dev, crtc, plane, NULL, &mdp5_crtc_funcs);
+
+	drm_flip_work_init(&mdp5_crtc->unref_cursor_work,
+			"unref cursor", unref_cursor_worker);
+
 	drm_crtc_helper_add(crtc, &mdp5_crtc_helper_funcs);
 	plane->crtc = crtc;
 
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

