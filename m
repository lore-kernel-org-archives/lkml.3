Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbaLHPt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:49:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47736 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaLHPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:49:23 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, gbeeresh@codeaurora.org,
        Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 1/4] drm/msm/mdp: add register description for YUV support
Date: Mon,  8 Dec 2014 10:48:56 -0500
Message-Id: <1418053739-9386-2-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1418053739-9386-1-git-send-email-sviau@codeaurora.org>
References: <1418053739-9386-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YUV support addition implies that sub-modules of the ViG pipes
need to be configured: Color Space Converter (CSC) and Scaler are
the main components used to convert YUV to RGB data. Note that
the output of a pipe has to be in RGB888 format since only this
format is understood by the (layer) mixers.

Generated headers are kept in a separate change to ease the
actual driver's code review.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp4/mdp4.xml.h  |  44 +++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h  | 153 +++++++++++++++++++++++++++++--
 drivers/gpu/drm/msm/mdp/mdp_common.xml.h |  30 +++---
 3 files changed, 205 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4.xml.h b/drivers/gpu/drm/msm/mdp/mdp4/mdp4.xml.h
index a4a7f8c..b815c9c 100644
--- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4.xml.h
+++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4.xml.h
@@ -72,6 +72,18 @@ enum mdp4_cursor_format {
 	CURSOR_XRGB = 2,
 };
 
+enum mdp4_frame_format {
+	FRAME_LINEAR = 0,
+	FRAME_TILE_ARGB_4X4 = 1,
+	FRAME_TILE_YCBCR_420 = 2,
+};
+
+enum mdp4_scale_unit {
+	SCALE_FIR = 0,
+	SCALE_MN_PHASE = 1,
+	SCALE_PIXEL_RPT = 2,
+};
+
 enum mdp4_dma {
 	DMA_P = 0,
 	DMA_S = 1,
@@ -637,6 +649,8 @@ static inline uint32_t REG_MDP4_PIPE_SRCP1_BASE(enum mdp4_pipe i0) { return 0x00
 
 static inline uint32_t REG_MDP4_PIPE_SRCP2_BASE(enum mdp4_pipe i0) { return 0x00020018 + 0x10000*i0; }
 
+static inline uint32_t REG_MDP4_PIPE_SRCP3_BASE(enum mdp4_pipe i0) { return 0x0002001c + 0x10000*i0; }
+
 static inline uint32_t REG_MDP4_PIPE_SRC_STRIDE_A(enum mdp4_pipe i0) { return 0x00020040 + 0x10000*i0; }
 #define MDP4_PIPE_SRC_STRIDE_A_P0__MASK				0x0000ffff
 #define MDP4_PIPE_SRC_STRIDE_A_P0__SHIFT			0
@@ -720,7 +734,25 @@ static inline uint32_t MDP4_PIPE_SRC_FORMAT_UNPACK_COUNT(uint32_t val)
 }
 #define MDP4_PIPE_SRC_FORMAT_UNPACK_TIGHT			0x00020000
 #define MDP4_PIPE_SRC_FORMAT_UNPACK_ALIGN_MSB			0x00040000
+#define MDP4_PIPE_SRC_FORMAT_FETCH_PLANES__MASK			0x00180000
+#define MDP4_PIPE_SRC_FORMAT_FETCH_PLANES__SHIFT		19
+static inline uint32_t MDP4_PIPE_SRC_FORMAT_FETCH_PLANES(uint32_t val)
+{
+	return ((val) << MDP4_PIPE_SRC_FORMAT_FETCH_PLANES__SHIFT) & MDP4_PIPE_SRC_FORMAT_FETCH_PLANES__MASK;
+}
 #define MDP4_PIPE_SRC_FORMAT_SOLID_FILL				0x00400000
+#define MDP4_PIPE_SRC_FORMAT_CHROMA_SAMP__MASK			0x0c000000
+#define MDP4_PIPE_SRC_FORMAT_CHROMA_SAMP__SHIFT			26
+static inline uint32_t MDP4_PIPE_SRC_FORMAT_CHROMA_SAMP(enum mdp_chroma_samp_type val)
+{
+	return ((val) << MDP4_PIPE_SRC_FORMAT_CHROMA_SAMP__SHIFT) & MDP4_PIPE_SRC_FORMAT_CHROMA_SAMP__MASK;
+}
+#define MDP4_PIPE_SRC_FORMAT_FRAME_FORMAT__MASK			0x60000000
+#define MDP4_PIPE_SRC_FORMAT_FRAME_FORMAT__SHIFT		29
+static inline uint32_t MDP4_PIPE_SRC_FORMAT_FRAME_FORMAT(enum mdp4_frame_format val)
+{
+	return ((val) << MDP4_PIPE_SRC_FORMAT_FRAME_FORMAT__SHIFT) & MDP4_PIPE_SRC_FORMAT_FRAME_FORMAT__MASK;
+}
 
 static inline uint32_t REG_MDP4_PIPE_SRC_UNPACK(enum mdp4_pipe i0) { return 0x00020054 + 0x10000*i0; }
 #define MDP4_PIPE_SRC_UNPACK_ELEM0__MASK			0x000000ff
@@ -751,6 +783,18 @@ static inline uint32_t MDP4_PIPE_SRC_UNPACK_ELEM3(uint32_t val)
 static inline uint32_t REG_MDP4_PIPE_OP_MODE(enum mdp4_pipe i0) { return 0x00020058 + 0x10000*i0; }
 #define MDP4_PIPE_OP_MODE_SCALEX_EN				0x00000001
 #define MDP4_PIPE_OP_MODE_SCALEY_EN				0x00000002
+#define MDP4_PIPE_OP_MODE_SCALEX_UNIT_SEL__MASK			0x0000000c
+#define MDP4_PIPE_OP_MODE_SCALEX_UNIT_SEL__SHIFT		2
+static inline uint32_t MDP4_PIPE_OP_MODE_SCALEX_UNIT_SEL(enum mdp4_scale_unit val)
+{
+	return ((val) << MDP4_PIPE_OP_MODE_SCALEX_UNIT_SEL__SHIFT) & MDP4_PIPE_OP_MODE_SCALEX_UNIT_SEL__MASK;
+}
+#define MDP4_PIPE_OP_MODE_SCALEY_UNIT_SEL__MASK			0x00000030
+#define MDP4_PIPE_OP_MODE_SCALEY_UNIT_SEL__SHIFT		4
+static inline uint32_t MDP4_PIPE_OP_MODE_SCALEY_UNIT_SEL(enum mdp4_scale_unit val)
+{
+	return ((val) << MDP4_PIPE_OP_MODE_SCALEY_UNIT_SEL__SHIFT) & MDP4_PIPE_OP_MODE_SCALEY_UNIT_SEL__MASK;
+}
 #define MDP4_PIPE_OP_MODE_SRC_YCBCR				0x00000200
 #define MDP4_PIPE_OP_MODE_DST_YCBCR				0x00000400
 #define MDP4_PIPE_OP_MODE_CSC_EN				0x00000800
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
index e87ef55..26cdfd5 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
@@ -88,13 +88,6 @@ enum mdp5_pack_3d {
 	PACK_3D_COL_INT = 3,
 };
 
-enum mdp5_chroma_samp_type {
-	CHROMA_RGB = 0,
-	CHROMA_H2V1 = 1,
-	CHROMA_H1V2 = 2,
-	CHROMA_420 = 3,
-};
-
 enum mdp5_scale_filter {
 	SCALE_FILTER_NEAREST = 0,
 	SCALE_FILTER_BIL = 1,
@@ -142,6 +135,11 @@ enum mdp5_igc_type {
 	IGC_DSPP = 3,
 };
 
+enum mdp5_data_format {
+	DATA_FORMAT_RGB = 0,
+	DATA_FORMAT_YUV = 1,
+};
+
 #define MDP5_IRQ_INTF0_WB_ROT_COMP				0x00000001
 #define MDP5_IRQ_INTF1_WB_ROT_COMP				0x00000002
 #define MDP5_IRQ_INTF2_WB_ROT_COMP				0x00000004
@@ -463,12 +461,143 @@ static inline uint32_t __offset_PIPE(enum mdp5_pipe idx)
 }
 static inline uint32_t REG_MDP5_PIPE(enum mdp5_pipe i0) { return 0x00000000 + __offset_PIPE(i0); }
 
+static inline uint32_t REG_MDP5_PIPE_OP_MODE(enum mdp5_pipe i0) { return 0x00000200 + __offset_PIPE(i0); }
+#define MDP5_PIPE_OP_MODE_CSC_DST_DATA_FORMAT__MASK		0x00080000
+#define MDP5_PIPE_OP_MODE_CSC_DST_DATA_FORMAT__SHIFT		19
+static inline uint32_t MDP5_PIPE_OP_MODE_CSC_DST_DATA_FORMAT(enum mdp5_data_format val)
+{
+	return ((val) << MDP5_PIPE_OP_MODE_CSC_DST_DATA_FORMAT__SHIFT) & MDP5_PIPE_OP_MODE_CSC_DST_DATA_FORMAT__MASK;
+}
+#define MDP5_PIPE_OP_MODE_CSC_SRC_DATA_FORMAT__MASK		0x00040000
+#define MDP5_PIPE_OP_MODE_CSC_SRC_DATA_FORMAT__SHIFT		18
+static inline uint32_t MDP5_PIPE_OP_MODE_CSC_SRC_DATA_FORMAT(enum mdp5_data_format val)
+{
+	return ((val) << MDP5_PIPE_OP_MODE_CSC_SRC_DATA_FORMAT__SHIFT) & MDP5_PIPE_OP_MODE_CSC_SRC_DATA_FORMAT__MASK;
+}
+#define MDP5_PIPE_OP_MODE_CSC_1_EN				0x00020000
+
 static inline uint32_t REG_MDP5_PIPE_HIST_CTL_BASE(enum mdp5_pipe i0) { return 0x000002c4 + __offset_PIPE(i0); }
 
 static inline uint32_t REG_MDP5_PIPE_HIST_LUT_BASE(enum mdp5_pipe i0) { return 0x000002f0 + __offset_PIPE(i0); }
 
 static inline uint32_t REG_MDP5_PIPE_HIST_LUT_SWAP(enum mdp5_pipe i0) { return 0x00000300 + __offset_PIPE(i0); }
 
+static inline uint32_t REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_0(enum mdp5_pipe i0) { return 0x00000320 + __offset_PIPE(i0); }
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_11__MASK		0x00001fff
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_11__SHIFT		0
+static inline uint32_t MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_11(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_11__SHIFT) & MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_11__MASK;
+}
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_12__MASK		0x1fff0000
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_12__SHIFT		16
+static inline uint32_t MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_12(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_12__SHIFT) & MDP5_PIPE_CSC_1_MATRIX_COEFF_0_COEFF_12__MASK;
+}
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_1(enum mdp5_pipe i0) { return 0x00000324 + __offset_PIPE(i0); }
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_13__MASK		0x00001fff
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_13__SHIFT		0
+static inline uint32_t MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_13(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_13__SHIFT) & MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_13__MASK;
+}
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_21__MASK		0x1fff0000
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_21__SHIFT		16
+static inline uint32_t MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_21(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_21__SHIFT) & MDP5_PIPE_CSC_1_MATRIX_COEFF_1_COEFF_21__MASK;
+}
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_2(enum mdp5_pipe i0) { return 0x00000328 + __offset_PIPE(i0); }
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_22__MASK		0x00001fff
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_22__SHIFT		0
+static inline uint32_t MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_22(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_22__SHIFT) & MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_22__MASK;
+}
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_23__MASK		0x1fff0000
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_23__SHIFT		16
+static inline uint32_t MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_23(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_23__SHIFT) & MDP5_PIPE_CSC_1_MATRIX_COEFF_2_COEFF_23__MASK;
+}
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_3(enum mdp5_pipe i0) { return 0x0000032c + __offset_PIPE(i0); }
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_31__MASK		0x00001fff
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_31__SHIFT		0
+static inline uint32_t MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_31(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_31__SHIFT) & MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_31__MASK;
+}
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_32__MASK		0x1fff0000
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_32__SHIFT		16
+static inline uint32_t MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_32(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_32__SHIFT) & MDP5_PIPE_CSC_1_MATRIX_COEFF_3_COEFF_32__MASK;
+}
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_MATRIX_COEFF_4(enum mdp5_pipe i0) { return 0x00000330 + __offset_PIPE(i0); }
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_4_COEFF_33__MASK		0x00001fff
+#define MDP5_PIPE_CSC_1_MATRIX_COEFF_4_COEFF_33__SHIFT		0
+static inline uint32_t MDP5_PIPE_CSC_1_MATRIX_COEFF_4_COEFF_33(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_MATRIX_COEFF_4_COEFF_33__SHIFT) & MDP5_PIPE_CSC_1_MATRIX_COEFF_4_COEFF_33__MASK;
+}
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_PRE_CLAMP(enum mdp5_pipe i0, uint32_t i1) { return 0x00000334 + __offset_PIPE(i0) + 0x4*i1; }
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_PRE_CLAMP_REG(enum mdp5_pipe i0, uint32_t i1) { return 0x00000334 + __offset_PIPE(i0) + 0x4*i1; }
+#define MDP5_PIPE_CSC_1_PRE_CLAMP_REG_HIGH__MASK		0x000000ff
+#define MDP5_PIPE_CSC_1_PRE_CLAMP_REG_HIGH__SHIFT		0
+static inline uint32_t MDP5_PIPE_CSC_1_PRE_CLAMP_REG_HIGH(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_PRE_CLAMP_REG_HIGH__SHIFT) & MDP5_PIPE_CSC_1_PRE_CLAMP_REG_HIGH__MASK;
+}
+#define MDP5_PIPE_CSC_1_PRE_CLAMP_REG_LOW__MASK			0x0000ff00
+#define MDP5_PIPE_CSC_1_PRE_CLAMP_REG_LOW__SHIFT		8
+static inline uint32_t MDP5_PIPE_CSC_1_PRE_CLAMP_REG_LOW(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_PRE_CLAMP_REG_LOW__SHIFT) & MDP5_PIPE_CSC_1_PRE_CLAMP_REG_LOW__MASK;
+}
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_POST_CLAMP(enum mdp5_pipe i0, uint32_t i1) { return 0x00000340 + __offset_PIPE(i0) + 0x4*i1; }
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_POST_CLAMP_REG(enum mdp5_pipe i0, uint32_t i1) { return 0x00000340 + __offset_PIPE(i0) + 0x4*i1; }
+#define MDP5_PIPE_CSC_1_POST_CLAMP_REG_HIGH__MASK		0x000000ff
+#define MDP5_PIPE_CSC_1_POST_CLAMP_REG_HIGH__SHIFT		0
+static inline uint32_t MDP5_PIPE_CSC_1_POST_CLAMP_REG_HIGH(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_POST_CLAMP_REG_HIGH__SHIFT) & MDP5_PIPE_CSC_1_POST_CLAMP_REG_HIGH__MASK;
+}
+#define MDP5_PIPE_CSC_1_POST_CLAMP_REG_LOW__MASK		0x0000ff00
+#define MDP5_PIPE_CSC_1_POST_CLAMP_REG_LOW__SHIFT		8
+static inline uint32_t MDP5_PIPE_CSC_1_POST_CLAMP_REG_LOW(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_POST_CLAMP_REG_LOW__SHIFT) & MDP5_PIPE_CSC_1_POST_CLAMP_REG_LOW__MASK;
+}
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_PRE_BIAS(enum mdp5_pipe i0, uint32_t i1) { return 0x0000034c + __offset_PIPE(i0) + 0x4*i1; }
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_PRE_BIAS_REG(enum mdp5_pipe i0, uint32_t i1) { return 0x0000034c + __offset_PIPE(i0) + 0x4*i1; }
+#define MDP5_PIPE_CSC_1_PRE_BIAS_REG_VALUE__MASK		0x000001ff
+#define MDP5_PIPE_CSC_1_PRE_BIAS_REG_VALUE__SHIFT		0
+static inline uint32_t MDP5_PIPE_CSC_1_PRE_BIAS_REG_VALUE(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_PRE_BIAS_REG_VALUE__SHIFT) & MDP5_PIPE_CSC_1_PRE_BIAS_REG_VALUE__MASK;
+}
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_POST_BIAS(enum mdp5_pipe i0, uint32_t i1) { return 0x00000358 + __offset_PIPE(i0) + 0x4*i1; }
+
+static inline uint32_t REG_MDP5_PIPE_CSC_1_POST_BIAS_REG(enum mdp5_pipe i0, uint32_t i1) { return 0x00000358 + __offset_PIPE(i0) + 0x4*i1; }
+#define MDP5_PIPE_CSC_1_POST_BIAS_REG_VALUE__MASK		0x000001ff
+#define MDP5_PIPE_CSC_1_POST_BIAS_REG_VALUE__SHIFT		0
+static inline uint32_t MDP5_PIPE_CSC_1_POST_BIAS_REG_VALUE(uint32_t val)
+{
+	return ((val) << MDP5_PIPE_CSC_1_POST_BIAS_REG_VALUE__SHIFT) & MDP5_PIPE_CSC_1_POST_BIAS_REG_VALUE__MASK;
+}
+
 static inline uint32_t REG_MDP5_PIPE_SRC_SIZE(enum mdp5_pipe i0) { return 0x00000000 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SRC_SIZE_HEIGHT__MASK				0xffff0000
 #define MDP5_PIPE_SRC_SIZE_HEIGHT__SHIFT			16
@@ -618,15 +747,15 @@ static inline uint32_t MDP5_PIPE_SRC_FORMAT_UNPACK_COUNT(uint32_t val)
 }
 #define MDP5_PIPE_SRC_FORMAT_UNPACK_TIGHT			0x00020000
 #define MDP5_PIPE_SRC_FORMAT_UNPACK_ALIGN_MSB			0x00040000
-#define MDP5_PIPE_SRC_FORMAT_NUM_PLANES__MASK			0x00780000
+#define MDP5_PIPE_SRC_FORMAT_NUM_PLANES__MASK			0x00180000
 #define MDP5_PIPE_SRC_FORMAT_NUM_PLANES__SHIFT			19
-static inline uint32_t MDP5_PIPE_SRC_FORMAT_NUM_PLANES(uint32_t val)
+static inline uint32_t MDP5_PIPE_SRC_FORMAT_NUM_PLANES(enum mdp_sspp_fetch_type val)
 {
 	return ((val) << MDP5_PIPE_SRC_FORMAT_NUM_PLANES__SHIFT) & MDP5_PIPE_SRC_FORMAT_NUM_PLANES__MASK;
 }
 #define MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP__MASK			0x01800000
 #define MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP__SHIFT			23
-static inline uint32_t MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP(enum mdp5_chroma_samp_type val)
+static inline uint32_t MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP(enum mdp_chroma_samp_type val)
 {
 	return ((val) << MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP__SHIFT) & MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP__MASK;
 }
@@ -753,6 +882,10 @@ static inline uint32_t REG_MDP5_PIPE_SCALE_PHASE_STEP_X(enum mdp5_pipe i0) { ret
 
 static inline uint32_t REG_MDP5_PIPE_SCALE_PHASE_STEP_Y(enum mdp5_pipe i0) { return 0x00000214 + __offset_PIPE(i0); }
 
+static inline uint32_t REG_MDP5_PIPE_SCALE_CR_PHASE_STEP_X(enum mdp5_pipe i0) { return 0x00000218 + __offset_PIPE(i0); }
+
+static inline uint32_t REG_MDP5_PIPE_SCALE_CR_PHASE_STEP_Y(enum mdp5_pipe i0) { return 0x0000021c + __offset_PIPE(i0); }
+
 static inline uint32_t REG_MDP5_PIPE_SCALE_INIT_PHASE_X(enum mdp5_pipe i0) { return 0x00000220 + __offset_PIPE(i0); }
 
 static inline uint32_t REG_MDP5_PIPE_SCALE_INIT_PHASE_Y(enum mdp5_pipe i0) { return 0x00000224 + __offset_PIPE(i0); }
diff --git a/drivers/gpu/drm/msm/mdp/mdp_common.xml.h b/drivers/gpu/drm/msm/mdp/mdp_common.xml.h
index 64c1afd..39602bb 100644
--- a/drivers/gpu/drm/msm/mdp/mdp_common.xml.h
+++ b/drivers/gpu/drm/msm/mdp/mdp_common.xml.h
@@ -8,18 +8,11 @@ http://github.com/freedreno/envytools/
 git clone https://github.com/freedreno/envytools.git
 
 The rules-ng-ng source files this header was generated from are:
-- /home/robclark/src/freedreno/envytools/rnndb/msm.xml                 (    647 bytes, from 2013-11-30 14:45:35)
-- /home/robclark/src/freedreno/envytools/rnndb/freedreno_copyright.xml (   1453 bytes, from 2013-03-31 16:51:27)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp4.xml            (  17996 bytes, from 2013-12-01 19:10:31)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp_common.xml      (   1615 bytes, from 2013-11-30 15:00:52)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp5.xml            (  22517 bytes, from 2014-06-25 12:55:02)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/dsi.xml             (  11712 bytes, from 2013-08-17 17:13:43)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/sfpb.xml            (    344 bytes, from 2013-08-11 19:26:32)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/mmss_cc.xml         (   1544 bytes, from 2013-08-16 19:17:05)
-- /home/robclark/src/freedreno/envytools/rnndb/hdmi/qfprom.xml         (    600 bytes, from 2013-07-05 19:21:12)
-- /home/robclark/src/freedreno/envytools/rnndb/hdmi/hdmi.xml           (  23613 bytes, from 2014-06-25 12:53:44)
-
-Copyright (C) 2013 by the following authors:
+- /local/mnt2/workspace2/sviau/envytools/rnndb/mdp/mdp5.xml            (  27208 bytes, from 2014-10-28 19:05:31)
+- /local/mnt2/workspace2/sviau/envytools/rnndb/freedreno_copyright.xml (   1453 bytes, from 2014-06-02 18:31:15)
+- /local/mnt2/workspace2/sviau/envytools/rnndb/mdp/mdp_common.xml      (   2357 bytes, from 2014-10-07 21:41:04)
+
+Copyright (C) 2013-2014 by the following authors:
 - Rob Clark <robdclark@gmail.com> (robclark)
 
 Permission is hereby granted, free of charge, to any person obtaining
@@ -44,6 +37,19 @@ WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
 
 
+enum mdp_chroma_samp_type {
+	CHROMA_RGB = 0,
+	CHROMA_H2V1 = 1,
+	CHROMA_H1V2 = 2,
+	CHROMA_420 = 3,
+};
+
+enum mdp_sspp_fetch_type {
+	MDP_PLANE_INTERLEAVED = 0,
+	MDP_PLANE_PLANAR = 1,
+	MDP_PLANE_PSEUDO_PLANAR = 2,
+};
+
 enum mdp_mixer_stage_id {
 	STAGE_UNUSED = 0,
 	STAGE_BASE = 1,
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

