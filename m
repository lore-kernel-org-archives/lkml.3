Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaLHPtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:49:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47749 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbaLHPtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:49:24 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, gbeeresh@codeaurora.org,
        Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 3/4] drm/msm/mdp5: add NV12 support for MDP5
Date: Mon,  8 Dec 2014 10:48:58 -0500
Message-Id: <1418053739-9386-4-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1418053739-9386-1-git-send-email-sviau@codeaurora.org>
References: <1418053739-9386-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds the NV12 format support for public planes.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c | 213 +++++++++++++++++++++++++++---
 drivers/gpu/drm/msm/msm_fb.c              |   2 +-
 2 files changed, 194 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
index 9a57e87..263a16b 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
@@ -274,6 +274,155 @@ static void set_scanout_locked(struct drm_plane *plane,
 	plane->fb = fb;
 }
 
+/* Note: mdp5_plane->pipe_lock must be locked */
+static void csc_disable(struct mdp5_kms *mdp5_kms, enum mdp5_pipe pipe)
+{
+	uint32_t value = mdp5_read(mdp5_kms, REG_MDP5_PIPE_OP_MODE(pipe)) &
+			 ~MDP5_PIPE_OP_MODE_CSC_1_EN;
+
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_OP_MODE(pipe), value);
+}
+
+/* Note: mdp5_plane->pipe_lock must be locked */
+static void csc_enable(struct mdp5_kms *mdp5_kms, enum mdp5_pipe pipe,
+		struct csc_cfg *csc)
+{
+	uint32_t  i, mode = 0; /* RGB, no CSC */
+	uint32_t *matrix;
+
+	if (unlikely(!csc))
+		return;
+
+	if ((csc->type == CSC_YUV2RGB) || (CSC_YUV2YUV == csc->type))
+		mode |= MDP5_PIPE_OP_MODE_CSC_SRC_DATA_FORMAT(DATA_FORMAT_YUV);
+	if ((csc->type == CSC_RGB2YUV) || (CSC_YUV2YUV == csc->type))
+		mode |= MDP5_PIPE_OP_MODE_CSC_DST_DATA_FORMAT(DATA_FORMAT_YUV);
+	mode |= MDP5_PIPE_OP_MODE_CSC_1_EN;
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_OP_MODE(pipe), mode);
+
+	matrix = csc->matrix;
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_0(pipe),
+			MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_11(matrix[0]) |
+			MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_12(matrix[1]));
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_1(pipe),
+			MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_13(matrix[2]) |
+			MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_21(matrix[3]));
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_2(pipe),
+			MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_22(matrix[4]) |
+			MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_23(matrix[5]));
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_3(pipe),
+			MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_31(matrix[6]) |
+			MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_32(matrix[7]));
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_4(pipe),
+			MDP5_PIPE_CSC_1_MATRIX_COEFF_4_COEFF_33(matrix[8]));
+
+	for (i = 0; i < ARRAY_SIZE(csc->pre_bias); i++) {
+		uint32_t *pre_clamp = csc->pre_clamp;
+		uint32_t *post_clamp = csc->post_clamp;
+
+		mdp5_write(mdp5_kms, REG_MDP5_PIPE_CSC_1_PRE_CLAMP(pipe, i),
+			MDP5_PIPE_CSC_1_PRE_CLAMP_REG_HIGH(pre_clamp[2*i+1]) |
+			MDP5_PIPE_CSC_1_PRE_CLAMP_REG_LOW(pre_clamp[2*i]));
+
+		mdp5_write(mdp5_kms, REG_MDP5_PIPE_CSC_1_POST_CLAMP(pipe, i),
+			MDP5_PIPE_CSC_1_POST_CLAMP_REG_HIGH(post_clamp[2*i+1]) |
+			MDP5_PIPE_CSC_1_POST_CLAMP_REG_LOW(post_clamp[2*i]));
+
+		mdp5_write(mdp5_kms, REG_MDP5_PIPE_CSC_1_PRE_BIAS(pipe, i),
+			MDP5_PIPE_CSC_1_PRE_BIAS_REG_VALUE(csc->pre_bias[i]));
+
+		mdp5_write(mdp5_kms, REG_MDP5_PIPE_CSC_1_POST_BIAS(pipe, i),
+			MDP5_PIPE_CSC_1_POST_BIAS_REG_VALUE(csc->post_bias[i]));
+	}
+}
+
+#define PHASE_STEP_SHIFT	21
+#define DOWN_SCALE_RATIO_MAX	32	/* 2^(26-21) */
+
+static int calc_phase_step(uint32_t src, uint32_t dst, uint32_t *out_phase)
+{
+	uint32_t unit;
+
+	if (src == 0 || dst == 0)
+		return -EINVAL;
+
+	/*
+	 * PHASE_STEP_X/Y is coded on 26 bits (25:0),
+	 * where 2^21 represents the unity "1" in fixed-point hardware design.
+	 * This leaves 5 bits for the integer part (downscale case):
+	 *	-> maximum downscale ratio = 0b1_1111 = 31
+	 */
+	if (src > (dst * DOWN_SCALE_RATIO_MAX))
+		return -EOVERFLOW;
+
+	unit = 1 << PHASE_STEP_SHIFT;
+	*out_phase = mult_frac(unit, src, dst);
+
+	return 0;
+}
+
+static int calc_scalex_steps(uint32_t pixel_format, uint32_t src, uint32_t dest,
+		uint32_t phasex_steps[2])
+{
+	uint32_t phasex_step;
+	unsigned int hsub;
+	int ret;
+
+	ret = calc_phase_step(src, dest, &phasex_step);
+	if (ret)
+		return ret;
+
+	hsub = drm_format_horz_chroma_subsampling(pixel_format);
+
+	phasex_steps[0] = phasex_step;
+	phasex_steps[1] = phasex_step / hsub;
+
+	return 0;
+}
+
+static int calc_scaley_steps(uint32_t pixel_format, uint32_t src, uint32_t dest,
+		uint32_t phasey_steps[2])
+{
+	uint32_t phasey_step;
+	unsigned int vsub;
+	int ret;
+
+	ret = calc_phase_step(src, dest, &phasey_step);
+	if (ret)
+		return ret;
+
+	vsub = drm_format_vert_chroma_subsampling(pixel_format);
+
+	phasey_steps[0] = phasey_step;
+	phasey_steps[1] = phasey_step / vsub;
+
+	return 0;
+}
+
+static uint32_t get_scalex_config(uint32_t src, uint32_t dest)
+{
+	uint32_t filter;
+
+	filter = (src <= dest) ? SCALE_FILTER_BIL : SCALE_FILTER_PCMN;
+
+	return  MDP5_PIPE_SCALE_CONFIG_SCALEX_EN |
+		MDP5_PIPE_SCALE_CONFIG_SCALEX_MIN_FILTER(filter) |
+		MDP5_PIPE_SCALE_CONFIG_SCALEX_CR_FILTER(filter)  |
+		MDP5_PIPE_SCALE_CONFIG_SCALEX_MAX_FILTER(filter);
+}
+
+static uint32_t get_scaley_config(uint32_t src, uint32_t dest)
+{
+	uint32_t filter;
+
+	filter = (src <= dest) ? SCALE_FILTER_BIL : SCALE_FILTER_PCMN;
+
+	return  MDP5_PIPE_SCALE_CONFIG_SCALEY_EN |
+		MDP5_PIPE_SCALE_CONFIG_SCALEY_MIN_FILTER(filter) |
+		MDP5_PIPE_SCALE_CONFIG_SCALEY_CR_FILTER(filter)  |
+		MDP5_PIPE_SCALE_CONFIG_SCALEY_MAX_FILTER(filter);
+}
+
 static int mdp5_plane_mode_set(struct drm_plane *plane,
 		struct drm_crtc *crtc, struct drm_framebuffer *fb,
 		int crtc_x, int crtc_y,
@@ -283,11 +432,14 @@ static int mdp5_plane_mode_set(struct drm_plane *plane,
 {
 	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
 	struct mdp5_kms *mdp5_kms = get_kms(plane);
+	struct device *dev = mdp5_kms->dev->dev;
 	enum mdp5_pipe pipe = mdp5_plane->pipe;
 	const struct mdp_format *format;
 	uint32_t nplanes, config = 0;
-	uint32_t phasex_step = 0, phasey_step = 0;
+	/* below array -> index 0: comp 0/3 ; index 1: comp 1/2 */
+	uint32_t phasex_step[2] = {0,}, phasey_step[2] = {0,};
 	uint32_t hdecm = 0, vdecm = 0;
+	uint32_t pix_format;
 	unsigned long flags;
 	int ret;
 
@@ -297,6 +449,9 @@ static int mdp5_plane_mode_set(struct drm_plane *plane,
 	if (WARN_ON(nplanes > pipe2nclients(pipe)))
 		return -EINVAL;
 
+	format = to_mdp_format(msm_framebuffer_format(fb));
+	pix_format = format->base.pixel_format;
+
 	/* src values are in Q16 fixed point, convert to integer: */
 	src_x = src_x >> 16;
 	src_y = src_y >> 16;
@@ -321,14 +476,28 @@ static int mdp5_plane_mode_set(struct drm_plane *plane,
 	 */
 	mdp5_smp_configure(mdp5_kms->smp, pipe);
 
-	if (src_w != crtc_w) {
-		config |= MDP5_PIPE_SCALE_CONFIG_SCALEX_EN;
-		/* TODO calc phasex_step, hdecm */
+	/* SCALE is used to both scale and up-sample chroma components */
+
+	if ((src_w != crtc_w) || MDP_FORMAT_IS_YUV(format)) {
+		/* TODO calc hdecm */
+		ret = calc_scalex_steps(pix_format, src_w, crtc_w, phasex_step);
+		if (ret) {
+			dev_err(dev, "X scaling (%d -> %d) failed: %d\n",
+					src_w, crtc_w, ret);
+			return ret;
+		}
+		config |= get_scalex_config(src_w, crtc_w);
 	}
 
-	if (src_h != crtc_h) {
-		config |= MDP5_PIPE_SCALE_CONFIG_SCALEY_EN;
-		/* TODO calc phasey_step, vdecm */
+	if ((src_h != crtc_h) || MDP_FORMAT_IS_YUV(format)) {
+		/* TODO calc vdecm */
+		ret = calc_scaley_steps(pix_format, src_h, crtc_h, phasey_step);
+		if (ret) {
+			dev_err(dev, "Y scaling (%d -> %d) failed: %d\n",
+					src_h, crtc_h, ret);
+			return ret;
+		}
+		config |= get_scaley_config(src_h, crtc_h);
 	}
 
 	spin_lock_irqsave(&mdp5_plane->pipe_lock, flags);
@@ -353,8 +522,6 @@ static int mdp5_plane_mode_set(struct drm_plane *plane,
 			MDP5_PIPE_OUT_XY_X(crtc_x) |
 			MDP5_PIPE_OUT_XY_Y(crtc_y));
 
-	format = to_mdp_format(msm_framebuffer_format(fb));
-
 	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC_FORMAT(pipe),
 			MDP5_PIPE_SRC_FORMAT_A_BPC(format->bpc_a) |
 			MDP5_PIPE_SRC_FORMAT_R_BPC(format->bpc_r) |
@@ -364,8 +531,8 @@ static int mdp5_plane_mode_set(struct drm_plane *plane,
 			MDP5_PIPE_SRC_FORMAT_CPP(format->cpp - 1) |
 			MDP5_PIPE_SRC_FORMAT_UNPACK_COUNT(format->unpack_count - 1) |
 			COND(format->unpack_tight, MDP5_PIPE_SRC_FORMAT_UNPACK_TIGHT) |
-			MDP5_PIPE_SRC_FORMAT_NUM_PLANES(nplanes - 1) |
-			MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP(CHROMA_RGB));
+			MDP5_PIPE_SRC_FORMAT_NUM_PLANES(format->fetch_type) |
+			MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP(format->chroma_sample));
 
 	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC_UNPACK(pipe),
 			MDP5_PIPE_SRC_UNPACK_ELEM0(format->unpack[0]) |
@@ -379,18 +546,24 @@ static int mdp5_plane_mode_set(struct drm_plane *plane,
 	/* not using secure mode: */
 	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SRC_ADDR_SW_STATUS(pipe), 0);
 
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SCALE_PHASE_STEP_X(pipe), phasex_step);
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SCALE_PHASE_STEP_Y(pipe), phasey_step);
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SCALE_PHASE_STEP_X(pipe),
+			phasex_step[0]);
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SCALE_PHASE_STEP_Y(pipe),
+			phasey_step[0]);
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SCALE_CR_PHASE_STEP_X(pipe),
+			phasex_step[1]);
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SCALE_CR_PHASE_STEP_Y(pipe),
+			phasey_step[1]);
 	mdp5_write(mdp5_kms, REG_MDP5_PIPE_DECIMATION(pipe),
 			MDP5_PIPE_DECIMATION_VERT(vdecm) |
 			MDP5_PIPE_DECIMATION_HORZ(hdecm));
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SCALE_CONFIG(pipe),
-			MDP5_PIPE_SCALE_CONFIG_SCALEX_MIN_FILTER(SCALE_FILTER_NEAREST) |
-			MDP5_PIPE_SCALE_CONFIG_SCALEY_MIN_FILTER(SCALE_FILTER_NEAREST) |
-			MDP5_PIPE_SCALE_CONFIG_SCALEX_CR_FILTER(SCALE_FILTER_NEAREST) |
-			MDP5_PIPE_SCALE_CONFIG_SCALEY_CR_FILTER(SCALE_FILTER_NEAREST) |
-			MDP5_PIPE_SCALE_CONFIG_SCALEX_MAX_FILTER(SCALE_FILTER_NEAREST) |
-			MDP5_PIPE_SCALE_CONFIG_SCALEY_MAX_FILTER(SCALE_FILTER_NEAREST));
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_SCALE_CONFIG(pipe), config);
+
+	if (MDP_FORMAT_IS_YUV(format))
+		csc_enable(mdp5_kms, pipe,
+				mdp_get_default_csc_cfg(CSC_YUV2RGB));
+	else
+		csc_disable(mdp5_kms, pipe);
 
 	set_scanout_locked(plane, fb);
 
diff --git a/drivers/gpu/drm/msm/msm_fb.c b/drivers/gpu/drm/msm/msm_fb.c
index d1a7a45..6b573e6 100644
--- a/drivers/gpu/drm/msm/msm_fb.c
+++ b/drivers/gpu/drm/msm/msm_fb.c
@@ -122,7 +122,7 @@ uint32_t msm_framebuffer_iova(struct drm_framebuffer *fb, int id, int plane)
 	struct msm_framebuffer *msm_fb = to_msm_framebuffer(fb);
 	if (!msm_fb->planes[plane])
 		return 0;
-	return msm_gem_iova(msm_fb->planes[plane], id);
+	return msm_gem_iova(msm_fb->planes[plane], id) + fb->offsets[plane];
 }
 
 struct drm_gem_object *msm_framebuffer_bo(struct drm_framebuffer *fb, int plane)
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

