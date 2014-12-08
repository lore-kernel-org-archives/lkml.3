Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaLHPt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:49:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47743 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaLHPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:49:23 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, gbeeresh@codeaurora.org,
        Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 2/4] drm/msm/mdp: add common YUV information for MDP4/MDP5
Date: Mon,  8 Dec 2014 10:48:57 -0500
Message-Id: <1418053739-9386-3-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1418053739-9386-1-git-send-email-sviau@codeaurora.org>
References: <1418053739-9386-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both MDP4 and MDP5 share some code as far as YUV support is
concerned. This change adds this information and will be followed
by the actual MDP4 and MDP5 YUV support patches.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h   |  19 ++++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h   |  19 ++++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c |   2 -
 drivers/gpu/drm/msm/mdp/mdp_format.c      | 108 +++++++++++++++++++++++++++---
 drivers/gpu/drm/msm/mdp/mdp_kms.h         |  24 ++++++-
 drivers/gpu/drm/msm/msm_fb.c              |   2 +-
 drivers/gpu/drm/msm/msm_kms.h             |   2 +
 7 files changed, 154 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h
index cbd77bc..0a5c58b 100644
--- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h
+++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h
@@ -175,14 +175,25 @@ irqreturn_t mdp4_irq(struct msm_kms *kms);
 int mdp4_enable_vblank(struct msm_kms *kms, struct drm_crtc *crtc);
 void mdp4_disable_vblank(struct msm_kms *kms, struct drm_crtc *crtc);
 
+static inline bool pipe_supports_yuv(enum mdp4_pipe pipe)
+{
+	switch (pipe) {
+	case VG1:
+	case VG2:
+	case VG3:
+	case VG4:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static inline
 uint32_t mdp4_get_formats(enum mdp4_pipe pipe_id, uint32_t *pixel_formats,
 		uint32_t max_formats)
 {
-	/* TODO when we have YUV, we need to filter supported formats
-	 * based on pipe_id..
-	 */
-	return mdp_get_formats(pixel_formats, max_formats);
+	return mdp_get_formats(pixel_formats, max_formats,
+				!pipe_supports_yuv(pipe_id));
 }
 
 void mdp4_plane_install_properties(struct drm_plane *plane,
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
index dd69c77..49d011e 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
@@ -165,14 +165,25 @@ void mdp5_disable_vblank(struct msm_kms *kms, struct drm_crtc *crtc);
 int mdp5_irq_domain_init(struct mdp5_kms *mdp5_kms);
 void mdp5_irq_domain_fini(struct mdp5_kms *mdp5_kms);
 
+static inline bool pipe_supports_yuv(enum mdp5_pipe pipe)
+{
+	switch (pipe) {
+	case SSPP_VIG0:
+	case SSPP_VIG1:
+	case SSPP_VIG2:
+	case SSPP_VIG3:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static inline
 uint32_t mdp5_get_formats(enum mdp5_pipe pipe, uint32_t *pixel_formats,
 		uint32_t max_formats)
 {
-	/* TODO when we have YUV, we need to filter supported formats
-	 * based on pipe id..
-	 */
-	return mdp_get_formats(pixel_formats, max_formats);
+	return mdp_get_formats(pixel_formats, max_formats,
+				!pipe_supports_yuv(pipe));
 }
 
 void mdp5_plane_install_properties(struct drm_plane *plane,
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
index 533df7c..9a57e87 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
@@ -18,8 +18,6 @@
 
 #include "mdp5_kms.h"
 
-#define MAX_PLANE	4
-
 struct mdp5_plane {
 	struct drm_plane base;
 	const char *name;
diff --git a/drivers/gpu/drm/msm/mdp/mdp_format.c b/drivers/gpu/drm/msm/mdp/mdp_format.c
index e0a6ffb..f683433 100644
--- a/drivers/gpu/drm/msm/mdp/mdp_format.c
+++ b/drivers/gpu/drm/msm/mdp/mdp_format.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014 The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
  *
@@ -19,7 +20,58 @@
 #include "msm_drv.h"
 #include "mdp_kms.h"
 
-#define FMT(name, a, r, g, b, e0, e1, e2, e3, alpha, tight, c, cnt) { \
+static struct csc_cfg csc_convert[CSC_MAX] = {
+	[CSC_RGB2RGB] = {
+		.type = CSC_RGB2RGB,
+		.matrix = {
+			0x0200, 0x0000, 0x0000,
+			0x0000, 0x0200, 0x0000,
+			0x0000, 0x0000, 0x0200
+		},
+		.pre_bias =	{ 0x0, 0x0, 0x0 },
+		.post_bias =	{ 0x0, 0x0, 0x0 },
+		.pre_clamp =	{ 0x0, 0xff, 0x0, 0xff, 0x0, 0xff },
+		.post_clamp =	{ 0x0, 0xff, 0x0, 0xff, 0x0, 0xff },
+	},
+	[CSC_YUV2RGB] = {
+		.type = CSC_YUV2RGB,
+		.matrix = {
+			0x0254, 0x0000, 0x0331,
+			0x0254, 0xff37, 0xfe60,
+			0x0254, 0x0409, 0x0000
+		},
+		.pre_bias =	{ 0xfff0, 0xff80, 0xff80 },
+		.post_bias =	{ 0x00, 0x00, 0x00 },
+		.pre_clamp =	{ 0x00, 0xff, 0x00, 0xff, 0x00, 0xff },
+		.post_clamp =	{ 0x00, 0xff, 0x00, 0xff, 0x00, 0xff },
+	},
+	[CSC_RGB2YUV] = {
+		.type = CSC_RGB2YUV,
+		.matrix = {
+			0x0083, 0x0102, 0x0032,
+			0x1fb5, 0x1f6c, 0x00e1,
+			0x00e1, 0x1f45, 0x1fdc
+		},
+		.pre_bias =	{ 0x00, 0x00, 0x00 },
+		.post_bias =	{ 0x10, 0x80, 0x80 },
+		.pre_clamp =	{ 0x00, 0xff, 0x00, 0xff, 0x00, 0xff },
+		.post_clamp =	{ 0x10, 0xeb, 0x10, 0xf0, 0x10, 0xf0 },
+	},
+	[CSC_YUV2YUV] = {
+		.type = CSC_YUV2YUV,
+		.matrix = {
+			0x0200, 0x0000, 0x0000,
+			0x0000, 0x0200, 0x0000,
+			0x0000, 0x0000, 0x0200
+		},
+		.pre_bias =	{ 0x00, 0x00, 0x00 },
+		.post_bias =	{ 0x00, 0x00, 0x00 },
+		.pre_clamp =	{ 0x00, 0xff, 0x00, 0xff, 0x00, 0xff },
+		.post_clamp =	{ 0x00, 0xff, 0x00, 0xff, 0x00, 0xff },
+	},
+};
+
+#define FMT(name, a, r, g, b, e0, e1, e2, e3, alpha, tight, c, cnt, fp, cs) { \
 		.base = { .pixel_format = DRM_FORMAT_ ## name }, \
 		.bpc_a = BPC ## a ## A,                          \
 		.bpc_r = BPC ## r,                               \
@@ -30,21 +82,46 @@
 		.unpack_tight = tight,                           \
 		.cpp = c,                                        \
 		.unpack_count = cnt,                             \
-	}
+		.fetch_type = fp,                                \
+		.chroma_sample = cs                              \
+}
 
 #define BPC0A 0
 
+/*
+ * Note: Keep RGB formats 1st, followed by YUV formats to avoid breaking
+ * mdp_get_rgb_formats()'s implementation.
+ */
 static const struct mdp_format formats[] = {
-	/*  name      a  r  g  b   e0 e1 e2 e3  alpha   tight  cpp cnt */
-	FMT(ARGB8888, 8, 8, 8, 8,  1, 0, 2, 3,  true,   true,  4,  4),
-	FMT(XRGB8888, 8, 8, 8, 8,  1, 0, 2, 3,  false,  true,  4,  4),
-	FMT(RGB888,   0, 8, 8, 8,  1, 0, 2, 0,  false,  true,  3,  3),
-	FMT(BGR888,   0, 8, 8, 8,  2, 0, 1, 0,  false,  true,  3,  3),
-	FMT(RGB565,   0, 5, 6, 5,  1, 0, 2, 0,  false,  true,  2,  3),
-	FMT(BGR565,   0, 5, 6, 5,  2, 0, 1, 0,  false,  true,  2,  3),
+	/*  name      a  r  g  b   e0 e1 e2 e3  alpha   tight  cpp cnt ... */
+	FMT(ARGB8888, 8, 8, 8, 8,  1, 0, 2, 3,  true,   true,  4,  4,
+			MDP_PLANE_INTERLEAVED, CHROMA_RGB),
+	FMT(XRGB8888, 8, 8, 8, 8,  1, 0, 2, 3,  false,  true,  4,  4,
+			MDP_PLANE_INTERLEAVED, CHROMA_RGB),
+	FMT(RGB888,   0, 8, 8, 8,  1, 0, 2, 0,  false,  true,  3,  3,
+			MDP_PLANE_INTERLEAVED, CHROMA_RGB),
+	FMT(BGR888,   0, 8, 8, 8,  2, 0, 1, 0,  false,  true,  3,  3,
+			MDP_PLANE_INTERLEAVED, CHROMA_RGB),
+	FMT(RGB565,   0, 5, 6, 5,  1, 0, 2, 0,  false,  true,  2,  3,
+			MDP_PLANE_INTERLEAVED, CHROMA_RGB),
+	FMT(BGR565,   0, 5, 6, 5,  2, 0, 1, 0,  false,  true,  2,  3,
+			MDP_PLANE_INTERLEAVED, CHROMA_RGB),
+
+	/* --- RGB formats above / YUV formats below this line --- */
+
+	FMT(NV12,     0, 8, 8, 8,  1, 2, 0, 0,  false,  true,  2, 2,
+			MDP_PLANE_PSEUDO_PLANAR, CHROMA_420),
+	FMT(NV21,     0, 8, 8, 8,  2, 1, 0, 0,  false,  true,  2, 2,
+			MDP_PLANE_PSEUDO_PLANAR, CHROMA_420),
 };
 
-uint32_t mdp_get_formats(uint32_t *pixel_formats, uint32_t max_formats)
+/*
+ * Note:
+ * @rgb_only must be set to true, when requesting
+ * supported formats for RGB pipes.
+ */
+uint32_t mdp_get_formats(uint32_t *pixel_formats, uint32_t max_formats,
+		bool rgb_only)
 {
 	uint32_t i;
 	for (i = 0; i < ARRAY_SIZE(formats); i++) {
@@ -53,6 +130,9 @@ uint32_t mdp_get_formats(uint32_t *pixel_formats, uint32_t max_formats)
 		if (i == max_formats)
 			break;
 
+		if (rgb_only && MDP_FORMAT_IS_YUV(f))
+			break;
+
 		pixel_formats[i] = f->base.pixel_format;
 	}
 
@@ -69,3 +149,11 @@ const struct msm_format *mdp_get_format(struct msm_kms *kms, uint32_t format)
 	}
 	return NULL;
 }
+
+struct csc_cfg *mdp_get_default_csc_cfg(enum csc_type type)
+{
+	if (unlikely(WARN_ON(type >= CSC_MAX)))
+		return NULL;
+
+	return &csc_convert[type];
+}
diff --git a/drivers/gpu/drm/msm/mdp/mdp_kms.h b/drivers/gpu/drm/msm/mdp/mdp_kms.h
index 99557b5..64c83a9 100644
--- a/drivers/gpu/drm/msm/mdp/mdp_kms.h
+++ b/drivers/gpu/drm/msm/mdp/mdp_kms.h
@@ -88,10 +88,32 @@ struct mdp_format {
 	uint8_t unpack[4];
 	bool alpha_enable, unpack_tight;
 	uint8_t cpp, unpack_count;
+	enum mdp_sspp_fetch_type fetch_type;
+	enum mdp_chroma_samp_type chroma_sample;
 };
 #define to_mdp_format(x) container_of(x, struct mdp_format, base)
+#define MDP_FORMAT_IS_YUV(mdp_format) ((mdp_format)->chroma_sample > CHROMA_RGB)
 
-uint32_t mdp_get_formats(uint32_t *formats, uint32_t max_formats);
+uint32_t mdp_get_formats(uint32_t *formats, uint32_t max_formats, bool rgb_only);
 const struct msm_format *mdp_get_format(struct msm_kms *kms, uint32_t format);
 
+enum csc_type {
+	CSC_RGB2RGB = 0,
+	CSC_YUV2RGB,
+	CSC_RGB2YUV,
+	CSC_YUV2YUV,
+	CSC_MAX
+};
+
+struct csc_cfg {
+	enum csc_type type;
+	uint32_t matrix[9];
+	uint32_t pre_bias[3];
+	uint32_t post_bias[3];
+	uint32_t pre_clamp[6];
+	uint32_t post_clamp[6];
+};
+
+struct csc_cfg *mdp_get_default_csc_cfg(enum csc_type);
+
 #endif /* __MDP_KMS_H__ */
diff --git a/drivers/gpu/drm/msm/msm_fb.c b/drivers/gpu/drm/msm/msm_fb.c
index 84dec16..d1a7a45 100644
--- a/drivers/gpu/drm/msm/msm_fb.c
+++ b/drivers/gpu/drm/msm/msm_fb.c
@@ -24,7 +24,7 @@
 struct msm_framebuffer {
 	struct drm_framebuffer base;
 	const struct msm_format *format;
-	struct drm_gem_object *planes[3];
+	struct drm_gem_object *planes[MAX_PLANE];
 };
 #define to_msm_framebuffer(x) container_of(x, struct msm_framebuffer, base)
 
diff --git a/drivers/gpu/drm/msm/msm_kms.h b/drivers/gpu/drm/msm/msm_kms.h
index 7fb4876..6a28835 100644
--- a/drivers/gpu/drm/msm/msm_kms.h
+++ b/drivers/gpu/drm/msm/msm_kms.h
@@ -23,6 +23,8 @@
 
 #include "msm_drv.h"
 
+#define MAX_PLANE	4
+
 /* As there are different display controller blocks depending on the
  * snapdragon version, the kms support is split out and the appropriate
  * implementation is loaded at runtime.  The kms module is responsible
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

