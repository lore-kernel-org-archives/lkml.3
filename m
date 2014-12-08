Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaLHPth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:49:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47757 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbaLHPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:49:26 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, gbeeresh@codeaurora.org,
        Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 4/4] drm/msm/mdp4: add YUV format support
Date: Mon,  8 Dec 2014 10:48:59 -0500
Message-Id: <1418053739-9386-5-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1418053739-9386-1-git-send-email-sviau@codeaurora.org>
References: <1418053739-9386-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Beeresh Gopal <gbeeresh@codeaurora.org>

The patch add support for YUV frame format
for MDP4 platform.

Signed-off-by: Beeresh Gopal <gbeeresh@codeaurora.org>
Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c | 104 +++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c
index 76d0a40..6e3c1ef 100644
--- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c
+++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c
@@ -17,6 +17,8 @@
 
 #include "mdp4_kms.h"
 
+#define DOWN_SCALE_MAX	8
+#define UP_SCALE_MAX	8
 
 struct mdp4_plane {
 	struct drm_plane base;
@@ -135,10 +137,6 @@ static void mdp4_plane_set_scanout(struct drm_plane *plane,
 	struct mdp4_plane *mdp4_plane = to_mdp4_plane(plane);
 	struct mdp4_kms *mdp4_kms = get_kms(plane);
 	enum mdp4_pipe pipe = mdp4_plane->pipe;
-	uint32_t iova = msm_framebuffer_iova(fb, mdp4_kms->id, 0);
-
-	DBG("%s: set_scanout: %08x (%u)", mdp4_plane->name,
-			iova, fb->pitches[0]);
 
 	mdp4_write(mdp4_kms, REG_MDP4_PIPE_SRC_STRIDE_A(pipe),
 			MDP4_PIPE_SRC_STRIDE_A_P0(fb->pitches[0]) |
@@ -148,11 +146,45 @@ static void mdp4_plane_set_scanout(struct drm_plane *plane,
 			MDP4_PIPE_SRC_STRIDE_B_P2(fb->pitches[2]) |
 			MDP4_PIPE_SRC_STRIDE_B_P3(fb->pitches[3]));
 
-	mdp4_write(mdp4_kms, REG_MDP4_PIPE_SRCP0_BASE(pipe), iova);
+	mdp4_write(mdp4_kms, REG_MDP4_PIPE_SRCP0_BASE(pipe),
+			msm_framebuffer_iova(fb, mdp4_kms->id, 0));
+	mdp4_write(mdp4_kms, REG_MDP4_PIPE_SRCP1_BASE(pipe),
+			msm_framebuffer_iova(fb, mdp4_kms->id, 1));
+	mdp4_write(mdp4_kms, REG_MDP4_PIPE_SRCP2_BASE(pipe),
+			msm_framebuffer_iova(fb, mdp4_kms->id, 2));
+	mdp4_write(mdp4_kms, REG_MDP4_PIPE_SRCP3_BASE(pipe),
+			msm_framebuffer_iova(fb, mdp4_kms->id, 3));
 
 	plane->fb = fb;
 }
 
+static void mdp4_write_csc_config(struct mdp4_kms *mdp4_kms,
+		enum mdp4_pipe pipe, struct csc_cfg *csc)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(csc->matrix); i++) {
+		mdp4_write(mdp4_kms, REG_MDP4_PIPE_CSC_MV(pipe, i),
+				csc->matrix[i]);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(csc->post_bias) ; i++) {
+		mdp4_write(mdp4_kms, REG_MDP4_PIPE_CSC_PRE_BV(pipe, i),
+				csc->pre_bias[i]);
+
+		mdp4_write(mdp4_kms, REG_MDP4_PIPE_CSC_POST_BV(pipe, i),
+				csc->post_bias[i]);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(csc->post_clamp) ; i++) {
+		mdp4_write(mdp4_kms, REG_MDP4_PIPE_CSC_PRE_LV(pipe, i),
+				csc->pre_clamp[i]);
+
+		mdp4_write(mdp4_kms, REG_MDP4_PIPE_CSC_POST_LV(pipe, i),
+				csc->post_clamp[i]);
+	}
+}
+
 #define MDP4_VG_PHASE_STEP_DEFAULT	0x20000000
 
 static int mdp4_plane_mode_set(struct drm_plane *plane,
@@ -162,6 +194,7 @@ static int mdp4_plane_mode_set(struct drm_plane *plane,
 		uint32_t src_x, uint32_t src_y,
 		uint32_t src_w, uint32_t src_h)
 {
+	struct drm_device *dev = plane->dev;
 	struct mdp4_plane *mdp4_plane = to_mdp4_plane(plane);
 	struct mdp4_kms *mdp4_kms = get_kms(plane);
 	enum mdp4_pipe pipe = mdp4_plane->pipe;
@@ -185,14 +218,59 @@ static int mdp4_plane_mode_set(struct drm_plane *plane,
 			fb->base.id, src_x, src_y, src_w, src_h,
 			crtc->base.id, crtc_x, crtc_y, crtc_w, crtc_h);
 
+	format = to_mdp_format(msm_framebuffer_format(fb));
+
+	if (src_w > (crtc_w * DOWN_SCALE_MAX)) {
+		dev_err(dev->dev, "Width down scaling exceeds limits!\n");
+		return -ERANGE;
+	}
+
+	if (src_h > (crtc_h * DOWN_SCALE_MAX)) {
+		dev_err(dev->dev, "Height down scaling exceeds limits!\n");
+		return -ERANGE;
+	}
+
+	if (crtc_w > (src_w * UP_SCALE_MAX)) {
+		dev_err(dev->dev, "Width up scaling exceeds limits!\n");
+		return -ERANGE;
+	}
+
+	if (crtc_h > (src_h * UP_SCALE_MAX)) {
+		dev_err(dev->dev, "Height up scaling exceeds limits!\n");
+		return -ERANGE;
+	}
+
 	if (src_w != crtc_w) {
+		uint32_t sel_unit = SCALE_FIR;
 		op_mode |= MDP4_PIPE_OP_MODE_SCALEX_EN;
-		/* TODO calc phasex_step */
+
+		if (MDP_FORMAT_IS_YUV(format)) {
+			if (crtc_w > src_w)
+				sel_unit = SCALE_PIXEL_RPT;
+			else if (crtc_w <= (src_w / 4))
+				sel_unit = SCALE_MN_PHASE;
+
+			op_mode |= MDP4_PIPE_OP_MODE_SCALEX_UNIT_SEL(sel_unit);
+			phasex_step = mult_frac(MDP4_VG_PHASE_STEP_DEFAULT,
+					src_w, crtc_w);
+		}
 	}
 
 	if (src_h != crtc_h) {
+		uint32_t sel_unit = SCALE_FIR;
 		op_mode |= MDP4_PIPE_OP_MODE_SCALEY_EN;
-		/* TODO calc phasey_step */
+
+		if (MDP_FORMAT_IS_YUV(format)) {
+
+			if (crtc_h > src_h)
+				sel_unit = SCALE_PIXEL_RPT;
+			else if (crtc_h <= (src_h / 4))
+				sel_unit = SCALE_MN_PHASE;
+
+			op_mode |= MDP4_PIPE_OP_MODE_SCALEY_UNIT_SEL(sel_unit);
+			phasey_step = mult_frac(MDP4_VG_PHASE_STEP_DEFAULT,
+					src_h, crtc_h);
+		}
 	}
 
 	mdp4_write(mdp4_kms, REG_MDP4_PIPE_SRC_SIZE(pipe),
@@ -213,8 +291,6 @@ static int mdp4_plane_mode_set(struct drm_plane *plane,
 
 	mdp4_plane_set_scanout(plane, fb);
 
-	format = to_mdp_format(msm_framebuffer_format(fb));
-
 	mdp4_write(mdp4_kms, REG_MDP4_PIPE_SRC_FORMAT(pipe),
 			MDP4_PIPE_SRC_FORMAT_A_BPC(format->bpc_a) |
 			MDP4_PIPE_SRC_FORMAT_R_BPC(format->bpc_r) |
@@ -223,6 +299,8 @@ static int mdp4_plane_mode_set(struct drm_plane *plane,
 			COND(format->alpha_enable, MDP4_PIPE_SRC_FORMAT_ALPHA_ENABLE) |
 			MDP4_PIPE_SRC_FORMAT_CPP(format->cpp - 1) |
 			MDP4_PIPE_SRC_FORMAT_UNPACK_COUNT(format->unpack_count - 1) |
+			MDP4_PIPE_SRC_FORMAT_FETCH_PLANES(format->fetch_type) |
+			MDP4_PIPE_SRC_FORMAT_CHROMA_SAMP(format->chroma_sample) |
 			COND(format->unpack_tight, MDP4_PIPE_SRC_FORMAT_UNPACK_TIGHT));
 
 	mdp4_write(mdp4_kms, REG_MDP4_PIPE_SRC_UNPACK(pipe),
@@ -231,6 +309,14 @@ static int mdp4_plane_mode_set(struct drm_plane *plane,
 			MDP4_PIPE_SRC_UNPACK_ELEM2(format->unpack[2]) |
 			MDP4_PIPE_SRC_UNPACK_ELEM3(format->unpack[3]));
 
+	if (MDP_FORMAT_IS_YUV(format)) {
+		struct csc_cfg *csc = mdp_get_default_csc_cfg(CSC_YUV2RGB);
+
+		op_mode |= MDP4_PIPE_OP_MODE_SRC_YCBCR;
+		op_mode |= MDP4_PIPE_OP_MODE_CSC_EN;
+		mdp4_write_csc_config(mdp4_kms, pipe, csc);
+	}
+
 	mdp4_write(mdp4_kms, REG_MDP4_PIPE_OP_MODE(pipe), op_mode);
 	mdp4_write(mdp4_kms, REG_MDP4_PIPE_PHASEX_STEP(pipe), phasex_step);
 	mdp4_write(mdp4_kms, REG_MDP4_PIPE_PHASEY_STEP(pipe), phasey_step);
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

