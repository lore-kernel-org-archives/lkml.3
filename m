Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaGGOjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:39:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39955 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaGGOjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:39:43 -0400
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH] drm/msm/mdp5: add support for MDP5 v1.3
Date: Mon,  7 Jul 2014 10:34:01 -0400
Message-Id: <1404743641-16847-2-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1404743641-16847-1-git-send-email-sviau@codeaurora.org>
References: <1404743641-16847-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MDP5 has several functional blocks (ie: VIG/RGB pipes, LMs, ...).
>From one revision to another, these blocks' base addresses might
change due to the number of instances present in the MDP5 hw.
A way of dealing with these offset changes is to introduce
dynamic offsets 'per block'.

This change adds support for the new revision of MDP5: v1.3.
The idea is to define one hw config per MDP version and select
either one of them at runtime, after reading the MDP5 version.

Once the MDP version is known, 'per block' dynamic offsets
are initialized through a global pointer, which is then used for
read/write register access.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h | 442 +++++++++++++++++++-------------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c | 151 +++++++++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h |  25 ++
 3 files changed, 426 insertions(+), 192 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
index 0aa5151..15f13b8 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
@@ -8,18 +8,11 @@ http://github.com/freedreno/envytools/
 git clone https://github.com/freedreno/envytools.git
 
 The rules-ng-ng source files this header was generated from are:
-- /home/robclark/src/freedreno/envytools/rnndb/msm.xml                 (    647 bytes, from 2013-11-30 14:45:35)
-- /home/robclark/src/freedreno/envytools/rnndb/freedreno_copyright.xml (   1453 bytes, from 2013-03-31 16:51:27)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp4.xml            (  17996 bytes, from 2013-12-01 19:10:31)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp_common.xml      (   1615 bytes, from 2013-11-30 15:00:52)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp5.xml            (  22517 bytes, from 2013-12-03 20:59:13)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/dsi.xml             (  11712 bytes, from 2013-08-17 17:13:43)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/sfpb.xml            (    344 bytes, from 2013-08-11 19:26:32)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/mmss_cc.xml         (   1544 bytes, from 2013-08-16 19:17:05)
-- /home/robclark/src/freedreno/envytools/rnndb/hdmi/qfprom.xml         (    600 bytes, from 2013-07-05 19:21:12)
-- /home/robclark/src/freedreno/envytools/rnndb/hdmi/hdmi.xml           (  20932 bytes, from 2013-12-01 15:13:04)
-
-Copyright (C) 2013 by the following authors:
+- /local/mnt2/workspace2/sviau/envytools/rnndb/mdp/mdp5.xml            (  23963 bytes, from 2014-06-23 18:42:36)
+- /local/mnt2/workspace2/sviau/envytools/rnndb/freedreno_copyright.xml (   1453 bytes, from 2014-06-02 18:31:15)
+- /local/mnt2/workspace2/sviau/envytools/rnndb/mdp/mdp_common.xml      (   1940 bytes, from 2014-06-16 14:56:12)
+
+Copyright (C) 2013-2014 by the following authors:
 - Rob Clark <robdclark@gmail.com> (robclark)
 
 Permission is hereby granted, free of charge, to any person obtaining
@@ -68,6 +61,8 @@ enum mdp5_pipe {
 	SSPP_RGB2 = 5,
 	SSPP_DMA0 = 6,
 	SSPP_DMA1 = 7,
+	SSPP_VIG3 = 8,
+	SSPP_RGB3 = 9,
 };
 
 enum mdp5_ctl_mode {
@@ -126,7 +121,11 @@ enum mdp5_client_id {
 	CID_RGB0 = 16,
 	CID_RGB1 = 17,
 	CID_RGB2 = 18,
-	CID_MAX = 19,
+	CID_VIG3_Y = 19,
+	CID_VIG3_CR = 20,
+	CID_VIG3_CB = 21,
+	CID_RGB3 = 22,
+	CID_MAX = 23,
 };
 
 enum mdp5_igc_type {
@@ -299,11 +298,34 @@ static inline uint32_t MDP5_IGC_LUT_REG_VAL(uint32_t val)
 #define MDP5_IGC_LUT_REG_DISABLE_PIPE_1				0x20000000
 #define MDP5_IGC_LUT_REG_DISABLE_PIPE_2				0x40000000
 
-static inline uint32_t REG_MDP5_CTL(uint32_t i0) { return 0x00000600 + 0x100*i0; }
+static inline uint32_t __offset_CTL(uint32_t idx)
+{
+	switch (idx) {
+		case 0: return (mdp5_cfg->ctl.base[0]);
+		case 1: return (mdp5_cfg->ctl.base[1]);
+		case 2: return (mdp5_cfg->ctl.base[2]);
+		case 3: return (mdp5_cfg->ctl.base[3]);
+		case 4: return (mdp5_cfg->ctl.base[4]);
+		default: return INVALID_IDX(idx);
+	}
+}
+static inline uint32_t REG_MDP5_CTL(uint32_t i0) { return 0x00000000 + __offset_CTL(i0); }
 
-static inline uint32_t REG_MDP5_CTL_LAYER(uint32_t i0, uint32_t i1) { return 0x00000600 + 0x100*i0 + 0x4*i1; }
+static inline uint32_t __offset_LAYER(uint32_t idx)
+{
+	switch (idx) {
+		case 0: return 0x00000000;
+		case 1: return 0x00000004;
+		case 2: return 0x00000008;
+		case 3: return 0x0000000c;
+		case 4: return 0x00000010;
+		case 5: return 0x00000024;
+		default: return INVALID_IDX(idx);
+	}
+}
+static inline uint32_t REG_MDP5_CTL_LAYER(uint32_t i0, uint32_t i1) { return 0x00000000 + __offset_CTL(i0) + __offset_LAYER(i1); }
 
-static inline uint32_t REG_MDP5_CTL_LAYER_REG(uint32_t i0, uint32_t i1) { return 0x00000600 + 0x100*i0 + 0x4*i1; }
+static inline uint32_t REG_MDP5_CTL_LAYER_REG(uint32_t i0, uint32_t i1) { return 0x00000000 + __offset_CTL(i0) + __offset_LAYER(i1); }
 #define MDP5_CTL_LAYER_REG_VIG0__MASK				0x00000007
 #define MDP5_CTL_LAYER_REG_VIG0__SHIFT				0
 static inline uint32_t MDP5_CTL_LAYER_REG_VIG0(enum mdp_mixer_stage_id val)
@@ -354,8 +376,20 @@ static inline uint32_t MDP5_CTL_LAYER_REG_DMA1(enum mdp_mixer_stage_id val)
 }
 #define MDP5_CTL_LAYER_REG_BORDER_COLOR				0x01000000
 #define MDP5_CTL_LAYER_REG_CURSOR_OUT				0x02000000
+#define MDP5_CTL_LAYER_REG_VIG3__MASK				0x1c000000
+#define MDP5_CTL_LAYER_REG_VIG3__SHIFT				26
+static inline uint32_t MDP5_CTL_LAYER_REG_VIG3(enum mdp_mixer_stage_id val)
+{
+	return ((val) << MDP5_CTL_LAYER_REG_VIG3__SHIFT) & MDP5_CTL_LAYER_REG_VIG3__MASK;
+}
+#define MDP5_CTL_LAYER_REG_RGB3__MASK				0xe0000000
+#define MDP5_CTL_LAYER_REG_RGB3__SHIFT				29
+static inline uint32_t MDP5_CTL_LAYER_REG_RGB3(enum mdp_mixer_stage_id val)
+{
+	return ((val) << MDP5_CTL_LAYER_REG_RGB3__SHIFT) & MDP5_CTL_LAYER_REG_RGB3__MASK;
+}
 
-static inline uint32_t REG_MDP5_CTL_OP(uint32_t i0) { return 0x00000614 + 0x100*i0; }
+static inline uint32_t REG_MDP5_CTL_OP(uint32_t i0) { return 0x00000014 + __offset_CTL(i0); }
 #define MDP5_CTL_OP_MODE__MASK					0x0000000f
 #define MDP5_CTL_OP_MODE__SHIFT					0
 static inline uint32_t MDP5_CTL_OP_MODE(enum mdp5_ctl_mode val)
@@ -377,7 +411,7 @@ static inline uint32_t MDP5_CTL_OP_PACK_3D(enum mdp5_pack_3d val)
 	return ((val) << MDP5_CTL_OP_PACK_3D__SHIFT) & MDP5_CTL_OP_PACK_3D__MASK;
 }
 
-static inline uint32_t REG_MDP5_CTL_FLUSH(uint32_t i0) { return 0x00000618 + 0x100*i0; }
+static inline uint32_t REG_MDP5_CTL_FLUSH(uint32_t i0) { return 0x00000018 + __offset_CTL(i0); }
 #define MDP5_CTL_FLUSH_VIG0					0x00000001
 #define MDP5_CTL_FLUSH_VIG1					0x00000002
 #define MDP5_CTL_FLUSH_VIG2					0x00000004
@@ -387,26 +421,48 @@ static inline uint32_t REG_MDP5_CTL_FLUSH(uint32_t i0) { return 0x00000618 + 0x1
 #define MDP5_CTL_FLUSH_LM0					0x00000040
 #define MDP5_CTL_FLUSH_LM1					0x00000080
 #define MDP5_CTL_FLUSH_LM2					0x00000100
+#define MDP5_CTL_FLUSH_LM3					0x00000200
+#define MDP5_CTL_FLUSH_LM4					0x00000400
 #define MDP5_CTL_FLUSH_DMA0					0x00000800
 #define MDP5_CTL_FLUSH_DMA1					0x00001000
 #define MDP5_CTL_FLUSH_DSPP0					0x00002000
 #define MDP5_CTL_FLUSH_DSPP1					0x00004000
 #define MDP5_CTL_FLUSH_DSPP2					0x00008000
 #define MDP5_CTL_FLUSH_CTL					0x00020000
+#define MDP5_CTL_FLUSH_VIG3					0x00040000
+#define MDP5_CTL_FLUSH_RGB3					0x00080000
+#define MDP5_CTL_FLUSH_LM5					0x00100000
+#define MDP5_CTL_FLUSH_DSPP3					0x00200000
 
-static inline uint32_t REG_MDP5_CTL_START(uint32_t i0) { return 0x0000061c + 0x100*i0; }
+static inline uint32_t REG_MDP5_CTL_START(uint32_t i0) { return 0x0000001c + __offset_CTL(i0); }
 
-static inline uint32_t REG_MDP5_CTL_PACK_3D(uint32_t i0) { return 0x00000620 + 0x100*i0; }
+static inline uint32_t REG_MDP5_CTL_PACK_3D(uint32_t i0) { return 0x00000020 + __offset_CTL(i0); }
 
-static inline uint32_t REG_MDP5_PIPE(enum mdp5_pipe i0) { return 0x00001200 + 0x400*i0; }
+static inline uint32_t __offset_PIPE(enum mdp5_pipe idx)
+{
+	switch (idx) {
+		case SSPP_VIG0: return (mdp5_cfg->pipe_vig.base[0]);
+		case SSPP_VIG1: return (mdp5_cfg->pipe_vig.base[1]);
+		case SSPP_VIG2: return (mdp5_cfg->pipe_vig.base[2]);
+		case SSPP_RGB0: return (mdp5_cfg->pipe_rgb.base[0]);
+		case SSPP_RGB1: return (mdp5_cfg->pipe_rgb.base[1]);
+		case SSPP_RGB2: return (mdp5_cfg->pipe_rgb.base[2]);
+		case SSPP_DMA0: return (mdp5_cfg->pipe_dma.base[0]);
+		case SSPP_DMA1: return (mdp5_cfg->pipe_dma.base[1]);
+		case SSPP_VIG3: return (mdp5_cfg->pipe_vig.base[3]);
+		case SSPP_RGB3: return (mdp5_cfg->pipe_rgb.base[3]);
+		default: return INVALID_IDX(idx);
+	}
+}
+static inline uint32_t REG_MDP5_PIPE(enum mdp5_pipe i0) { return 0x00000000 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_HIST_CTL_BASE(enum mdp5_pipe i0) { return 0x000014c4 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_HIST_CTL_BASE(enum mdp5_pipe i0) { return 0x000002c4 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_HIST_LUT_BASE(enum mdp5_pipe i0) { return 0x000014f0 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_HIST_LUT_BASE(enum mdp5_pipe i0) { return 0x000002f0 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_HIST_LUT_SWAP(enum mdp5_pipe i0) { return 0x00001500 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_HIST_LUT_SWAP(enum mdp5_pipe i0) { return 0x00000300 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SRC_SIZE(enum mdp5_pipe i0) { return 0x00001200 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_SIZE(enum mdp5_pipe i0) { return 0x00000000 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SRC_SIZE_HEIGHT__MASK				0xffff0000
 #define MDP5_PIPE_SRC_SIZE_HEIGHT__SHIFT			16
 static inline uint32_t MDP5_PIPE_SRC_SIZE_HEIGHT(uint32_t val)
@@ -420,7 +476,7 @@ static inline uint32_t MDP5_PIPE_SRC_SIZE_WIDTH(uint32_t val)
 	return ((val) << MDP5_PIPE_SRC_SIZE_WIDTH__SHIFT) & MDP5_PIPE_SRC_SIZE_WIDTH__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_SRC_IMG_SIZE(enum mdp5_pipe i0) { return 0x00001204 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_IMG_SIZE(enum mdp5_pipe i0) { return 0x00000004 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SRC_IMG_SIZE_HEIGHT__MASK			0xffff0000
 #define MDP5_PIPE_SRC_IMG_SIZE_HEIGHT__SHIFT			16
 static inline uint32_t MDP5_PIPE_SRC_IMG_SIZE_HEIGHT(uint32_t val)
@@ -434,7 +490,7 @@ static inline uint32_t MDP5_PIPE_SRC_IMG_SIZE_WIDTH(uint32_t val)
 	return ((val) << MDP5_PIPE_SRC_IMG_SIZE_WIDTH__SHIFT) & MDP5_PIPE_SRC_IMG_SIZE_WIDTH__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_SRC_XY(enum mdp5_pipe i0) { return 0x00001208 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_XY(enum mdp5_pipe i0) { return 0x00000008 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SRC_XY_Y__MASK				0xffff0000
 #define MDP5_PIPE_SRC_XY_Y__SHIFT				16
 static inline uint32_t MDP5_PIPE_SRC_XY_Y(uint32_t val)
@@ -448,7 +504,7 @@ static inline uint32_t MDP5_PIPE_SRC_XY_X(uint32_t val)
 	return ((val) << MDP5_PIPE_SRC_XY_X__SHIFT) & MDP5_PIPE_SRC_XY_X__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_OUT_SIZE(enum mdp5_pipe i0) { return 0x0000120c + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_OUT_SIZE(enum mdp5_pipe i0) { return 0x0000000c + __offset_PIPE(i0); }
 #define MDP5_PIPE_OUT_SIZE_HEIGHT__MASK				0xffff0000
 #define MDP5_PIPE_OUT_SIZE_HEIGHT__SHIFT			16
 static inline uint32_t MDP5_PIPE_OUT_SIZE_HEIGHT(uint32_t val)
@@ -462,7 +518,7 @@ static inline uint32_t MDP5_PIPE_OUT_SIZE_WIDTH(uint32_t val)
 	return ((val) << MDP5_PIPE_OUT_SIZE_WIDTH__SHIFT) & MDP5_PIPE_OUT_SIZE_WIDTH__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_OUT_XY(enum mdp5_pipe i0) { return 0x00001210 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_OUT_XY(enum mdp5_pipe i0) { return 0x00000010 + __offset_PIPE(i0); }
 #define MDP5_PIPE_OUT_XY_Y__MASK				0xffff0000
 #define MDP5_PIPE_OUT_XY_Y__SHIFT				16
 static inline uint32_t MDP5_PIPE_OUT_XY_Y(uint32_t val)
@@ -476,15 +532,15 @@ static inline uint32_t MDP5_PIPE_OUT_XY_X(uint32_t val)
 	return ((val) << MDP5_PIPE_OUT_XY_X__SHIFT) & MDP5_PIPE_OUT_XY_X__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_SRC0_ADDR(enum mdp5_pipe i0) { return 0x00001214 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC0_ADDR(enum mdp5_pipe i0) { return 0x00000014 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SRC1_ADDR(enum mdp5_pipe i0) { return 0x00001218 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC1_ADDR(enum mdp5_pipe i0) { return 0x00000018 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SRC2_ADDR(enum mdp5_pipe i0) { return 0x0000121c + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC2_ADDR(enum mdp5_pipe i0) { return 0x0000001c + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SRC3_ADDR(enum mdp5_pipe i0) { return 0x00001220 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC3_ADDR(enum mdp5_pipe i0) { return 0x00000020 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SRC_STRIDE_A(enum mdp5_pipe i0) { return 0x00001224 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_STRIDE_A(enum mdp5_pipe i0) { return 0x00000024 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SRC_STRIDE_A_P0__MASK				0x0000ffff
 #define MDP5_PIPE_SRC_STRIDE_A_P0__SHIFT			0
 static inline uint32_t MDP5_PIPE_SRC_STRIDE_A_P0(uint32_t val)
@@ -498,7 +554,7 @@ static inline uint32_t MDP5_PIPE_SRC_STRIDE_A_P1(uint32_t val)
 	return ((val) << MDP5_PIPE_SRC_STRIDE_A_P1__SHIFT) & MDP5_PIPE_SRC_STRIDE_A_P1__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_SRC_STRIDE_B(enum mdp5_pipe i0) { return 0x00001228 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_STRIDE_B(enum mdp5_pipe i0) { return 0x00000028 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SRC_STRIDE_B_P2__MASK				0x0000ffff
 #define MDP5_PIPE_SRC_STRIDE_B_P2__SHIFT			0
 static inline uint32_t MDP5_PIPE_SRC_STRIDE_B_P2(uint32_t val)
@@ -512,9 +568,9 @@ static inline uint32_t MDP5_PIPE_SRC_STRIDE_B_P3(uint32_t val)
 	return ((val) << MDP5_PIPE_SRC_STRIDE_B_P3__SHIFT) & MDP5_PIPE_SRC_STRIDE_B_P3__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_STILE_FRAME_SIZE(enum mdp5_pipe i0) { return 0x0000122c + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_STILE_FRAME_SIZE(enum mdp5_pipe i0) { return 0x0000002c + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SRC_FORMAT(enum mdp5_pipe i0) { return 0x00001230 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_FORMAT(enum mdp5_pipe i0) { return 0x00000030 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SRC_FORMAT_G_BPC__MASK			0x00000003
 #define MDP5_PIPE_SRC_FORMAT_G_BPC__SHIFT			0
 static inline uint32_t MDP5_PIPE_SRC_FORMAT_G_BPC(enum mdp_bpc val)
@@ -568,7 +624,7 @@ static inline uint32_t MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP(enum mdp5_chroma_samp_ty
 	return ((val) << MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP__SHIFT) & MDP5_PIPE_SRC_FORMAT_CHROMA_SAMP__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_SRC_UNPACK(enum mdp5_pipe i0) { return 0x00001234 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_UNPACK(enum mdp5_pipe i0) { return 0x00000034 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SRC_UNPACK_ELEM0__MASK			0x000000ff
 #define MDP5_PIPE_SRC_UNPACK_ELEM0__SHIFT			0
 static inline uint32_t MDP5_PIPE_SRC_UNPACK_ELEM0(uint32_t val)
@@ -594,7 +650,7 @@ static inline uint32_t MDP5_PIPE_SRC_UNPACK_ELEM3(uint32_t val)
 	return ((val) << MDP5_PIPE_SRC_UNPACK_ELEM3__SHIFT) & MDP5_PIPE_SRC_UNPACK_ELEM3__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_SRC_OP_MODE(enum mdp5_pipe i0) { return 0x00001238 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_OP_MODE(enum mdp5_pipe i0) { return 0x00000038 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SRC_OP_MODE_BWC_EN				0x00000001
 #define MDP5_PIPE_SRC_OP_MODE_BWC__MASK				0x00000006
 #define MDP5_PIPE_SRC_OP_MODE_BWC__SHIFT			1
@@ -610,29 +666,29 @@ static inline uint32_t MDP5_PIPE_SRC_OP_MODE_BWC(enum mdp5_pipe_bwc val)
 #define MDP5_PIPE_SRC_OP_MODE_DEINTERLACE			0x00400000
 #define MDP5_PIPE_SRC_OP_MODE_DEINTERLACE_ODD			0x00800000
 
-static inline uint32_t REG_MDP5_PIPE_SRC_CONSTANT_COLOR(enum mdp5_pipe i0) { return 0x0000123c + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_CONSTANT_COLOR(enum mdp5_pipe i0) { return 0x0000003c + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_FETCH_CONFIG(enum mdp5_pipe i0) { return 0x00001248 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_FETCH_CONFIG(enum mdp5_pipe i0) { return 0x00000048 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_VC1_RANGE(enum mdp5_pipe i0) { return 0x0000124c + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_VC1_RANGE(enum mdp5_pipe i0) { return 0x0000004c + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_REQPRIO_FIFO_WM_0(enum mdp5_pipe i0) { return 0x00001250 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_REQPRIO_FIFO_WM_0(enum mdp5_pipe i0) { return 0x00000050 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_REQPRIO_FIFO_WM_1(enum mdp5_pipe i0) { return 0x00001254 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_REQPRIO_FIFO_WM_1(enum mdp5_pipe i0) { return 0x00000054 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_REQPRIO_FIFO_WM_2(enum mdp5_pipe i0) { return 0x00001258 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_REQPRIO_FIFO_WM_2(enum mdp5_pipe i0) { return 0x00000058 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SRC_ADDR_SW_STATUS(enum mdp5_pipe i0) { return 0x00001270 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SRC_ADDR_SW_STATUS(enum mdp5_pipe i0) { return 0x00000070 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_CURRENT_SRC0_ADDR(enum mdp5_pipe i0) { return 0x000012a4 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_CURRENT_SRC0_ADDR(enum mdp5_pipe i0) { return 0x000000a4 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_CURRENT_SRC1_ADDR(enum mdp5_pipe i0) { return 0x000012a8 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_CURRENT_SRC1_ADDR(enum mdp5_pipe i0) { return 0x000000a8 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_CURRENT_SRC2_ADDR(enum mdp5_pipe i0) { return 0x000012ac + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_CURRENT_SRC2_ADDR(enum mdp5_pipe i0) { return 0x000000ac + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_CURRENT_SRC3_ADDR(enum mdp5_pipe i0) { return 0x000012b0 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_CURRENT_SRC3_ADDR(enum mdp5_pipe i0) { return 0x000000b0 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_DECIMATION(enum mdp5_pipe i0) { return 0x000012b4 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_DECIMATION(enum mdp5_pipe i0) { return 0x000000b4 + __offset_PIPE(i0); }
 #define MDP5_PIPE_DECIMATION_VERT__MASK				0x000000ff
 #define MDP5_PIPE_DECIMATION_VERT__SHIFT			0
 static inline uint32_t MDP5_PIPE_DECIMATION_VERT(uint32_t val)
@@ -646,7 +702,7 @@ static inline uint32_t MDP5_PIPE_DECIMATION_HORZ(uint32_t val)
 	return ((val) << MDP5_PIPE_DECIMATION_HORZ__SHIFT) & MDP5_PIPE_DECIMATION_HORZ__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_SCALE_CONFIG(enum mdp5_pipe i0) { return 0x00001404 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SCALE_CONFIG(enum mdp5_pipe i0) { return 0x00000204 + __offset_PIPE(i0); }
 #define MDP5_PIPE_SCALE_CONFIG_SCALEX_EN			0x00000001
 #define MDP5_PIPE_SCALE_CONFIG_SCALEY_EN			0x00000002
 #define MDP5_PIPE_SCALE_CONFIG_SCALEX_MIN_FILTER__MASK		0x00000300
@@ -686,23 +742,34 @@ static inline uint32_t MDP5_PIPE_SCALE_CONFIG_SCALEY_MAX_FILTER(enum mdp5_scale_
 	return ((val) << MDP5_PIPE_SCALE_CONFIG_SCALEY_MAX_FILTER__SHIFT) & MDP5_PIPE_SCALE_CONFIG_SCALEY_MAX_FILTER__MASK;
 }
 
-static inline uint32_t REG_MDP5_PIPE_SCALE_PHASE_STEP_X(enum mdp5_pipe i0) { return 0x00001410 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SCALE_PHASE_STEP_X(enum mdp5_pipe i0) { return 0x00000210 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SCALE_PHASE_STEP_Y(enum mdp5_pipe i0) { return 0x00001414 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SCALE_PHASE_STEP_Y(enum mdp5_pipe i0) { return 0x00000214 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SCALE_INIT_PHASE_X(enum mdp5_pipe i0) { return 0x00001420 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SCALE_INIT_PHASE_X(enum mdp5_pipe i0) { return 0x00000220 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_PIPE_SCALE_INIT_PHASE_Y(enum mdp5_pipe i0) { return 0x00001424 + 0x400*i0; }
+static inline uint32_t REG_MDP5_PIPE_SCALE_INIT_PHASE_Y(enum mdp5_pipe i0) { return 0x00000224 + __offset_PIPE(i0); }
 
-static inline uint32_t REG_MDP5_LM(uint32_t i0) { return 0x00003200 + 0x400*i0; }
+static inline uint32_t __offset_LM(uint32_t idx)
+{
+	switch (idx) {
+		case 0: return (mdp5_cfg->lm.base[0]);
+		case 1: return (mdp5_cfg->lm.base[1]);
+		case 2: return (mdp5_cfg->lm.base[2]);
+		case 3: return (mdp5_cfg->lm.base[3]);
+		case 4: return (mdp5_cfg->lm.base[4]);
+		default: return INVALID_IDX(idx);
+	}
+}
+static inline uint32_t REG_MDP5_LM(uint32_t i0) { return 0x00000000 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_BLEND_COLOR_OUT(uint32_t i0) { return 0x00003200 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_BLEND_COLOR_OUT(uint32_t i0) { return 0x00000000 + __offset_LM(i0); }
 #define MDP5_LM_BLEND_COLOR_OUT_STAGE0_FG_ALPHA			0x00000002
 #define MDP5_LM_BLEND_COLOR_OUT_STAGE1_FG_ALPHA			0x00000004
 #define MDP5_LM_BLEND_COLOR_OUT_STAGE2_FG_ALPHA			0x00000008
 #define MDP5_LM_BLEND_COLOR_OUT_STAGE3_FG_ALPHA			0x00000010
 
-static inline uint32_t REG_MDP5_LM_OUT_SIZE(uint32_t i0) { return 0x00003204 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_OUT_SIZE(uint32_t i0) { return 0x00000004 + __offset_LM(i0); }
 #define MDP5_LM_OUT_SIZE_HEIGHT__MASK				0xffff0000
 #define MDP5_LM_OUT_SIZE_HEIGHT__SHIFT				16
 static inline uint32_t MDP5_LM_OUT_SIZE_HEIGHT(uint32_t val)
@@ -716,13 +783,13 @@ static inline uint32_t MDP5_LM_OUT_SIZE_WIDTH(uint32_t val)
 	return ((val) << MDP5_LM_OUT_SIZE_WIDTH__SHIFT) & MDP5_LM_OUT_SIZE_WIDTH__MASK;
 }
 
-static inline uint32_t REG_MDP5_LM_BORDER_COLOR_0(uint32_t i0) { return 0x00003208 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_BORDER_COLOR_0(uint32_t i0) { return 0x00000008 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_BORDER_COLOR_1(uint32_t i0) { return 0x00003210 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_BORDER_COLOR_1(uint32_t i0) { return 0x00000010 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_BLEND(uint32_t i0, uint32_t i1) { return 0x00003220 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND(uint32_t i0, uint32_t i1) { return 0x00000020 + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_OP_MODE(uint32_t i0, uint32_t i1) { return 0x00003220 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_OP_MODE(uint32_t i0, uint32_t i1) { return 0x00000020 + __offset_LM(i0) + 0x30*i1; }
 #define MDP5_LM_BLEND_OP_MODE_FG_ALPHA__MASK			0x00000003
 #define MDP5_LM_BLEND_OP_MODE_FG_ALPHA__SHIFT			0
 static inline uint32_t MDP5_LM_BLEND_OP_MODE_FG_ALPHA(enum mdp_alpha_type val)
@@ -744,57 +811,67 @@ static inline uint32_t MDP5_LM_BLEND_OP_MODE_BG_ALPHA(enum mdp_alpha_type val)
 #define MDP5_LM_BLEND_OP_MODE_BG_INV_MOD_ALPHA			0x00001000
 #define MDP5_LM_BLEND_OP_MODE_BG_TRANSP_EN			0x00002000
 
-static inline uint32_t REG_MDP5_LM_BLEND_FG_ALPHA(uint32_t i0, uint32_t i1) { return 0x00003224 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_FG_ALPHA(uint32_t i0, uint32_t i1) { return 0x00000024 + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_BG_ALPHA(uint32_t i0, uint32_t i1) { return 0x00003228 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_BG_ALPHA(uint32_t i0, uint32_t i1) { return 0x00000028 + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_FG_TRANSP_LOW0(uint32_t i0, uint32_t i1) { return 0x0000322c + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_FG_TRANSP_LOW0(uint32_t i0, uint32_t i1) { return 0x0000002c + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_FG_TRANSP_LOW1(uint32_t i0, uint32_t i1) { return 0x00003230 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_FG_TRANSP_LOW1(uint32_t i0, uint32_t i1) { return 0x00000030 + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_FG_TRANSP_HIGH0(uint32_t i0, uint32_t i1) { return 0x00003234 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_FG_TRANSP_HIGH0(uint32_t i0, uint32_t i1) { return 0x00000034 + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_FG_TRANSP_HIGH1(uint32_t i0, uint32_t i1) { return 0x00003238 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_FG_TRANSP_HIGH1(uint32_t i0, uint32_t i1) { return 0x00000038 + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_LOW0(uint32_t i0, uint32_t i1) { return 0x0000323c + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_LOW0(uint32_t i0, uint32_t i1) { return 0x0000003c + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_LOW1(uint32_t i0, uint32_t i1) { return 0x00003240 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_LOW1(uint32_t i0, uint32_t i1) { return 0x00000040 + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_HIGH0(uint32_t i0, uint32_t i1) { return 0x00003244 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_HIGH0(uint32_t i0, uint32_t i1) { return 0x00000044 + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_HIGH1(uint32_t i0, uint32_t i1) { return 0x00003248 + 0x400*i0 + 0x30*i1; }
+static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_HIGH1(uint32_t i0, uint32_t i1) { return 0x00000048 + __offset_LM(i0) + 0x30*i1; }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_IMG_SIZE(uint32_t i0) { return 0x000032e0 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_IMG_SIZE(uint32_t i0) { return 0x000000e0 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_SIZE(uint32_t i0) { return 0x000032e4 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_SIZE(uint32_t i0) { return 0x000000e4 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_XY(uint32_t i0) { return 0x000032e8 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_XY(uint32_t i0) { return 0x000000e8 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_STRIDE(uint32_t i0) { return 0x000032dc + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_STRIDE(uint32_t i0) { return 0x000000dc + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_FORMAT(uint32_t i0) { return 0x000032ec + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_FORMAT(uint32_t i0) { return 0x000000ec + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_BASE_ADDR(uint32_t i0) { return 0x000032f0 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_BASE_ADDR(uint32_t i0) { return 0x000000f0 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_START_XY(uint32_t i0) { return 0x000032f4 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_START_XY(uint32_t i0) { return 0x000000f4 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_CONFIG(uint32_t i0) { return 0x000032f8 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_CONFIG(uint32_t i0) { return 0x000000f8 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_PARAM(uint32_t i0) { return 0x000032fc + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_PARAM(uint32_t i0) { return 0x000000fc + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_TRANSP_LOW0(uint32_t i0) { return 0x00003300 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_TRANSP_LOW0(uint32_t i0) { return 0x00000100 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_TRANSP_LOW1(uint32_t i0) { return 0x00003304 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_TRANSP_LOW1(uint32_t i0) { return 0x00000104 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_TRANSP_HIGH0(uint32_t i0) { return 0x00003308 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_TRANSP_HIGH0(uint32_t i0) { return 0x00000108 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_TRANSP_HIGH1(uint32_t i0) { return 0x0000330c + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_TRANSP_HIGH1(uint32_t i0) { return 0x0000010c + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_LM_GC_LUT_BASE(uint32_t i0) { return 0x00003310 + 0x400*i0; }
+static inline uint32_t REG_MDP5_LM_GC_LUT_BASE(uint32_t i0) { return 0x00000110 + __offset_LM(i0); }
 
-static inline uint32_t REG_MDP5_DSPP(uint32_t i0) { return 0x00004600 + 0x400*i0; }
+static inline uint32_t __offset_DSPP(uint32_t idx)
+{
+	switch (idx) {
+		case 0: return (mdp5_cfg->dspp.base[0]);
+		case 1: return (mdp5_cfg->dspp.base[1]);
+		case 2: return (mdp5_cfg->dspp.base[2]);
+		case 3: return (mdp5_cfg->dspp.base[3]);
+		default: return INVALID_IDX(idx);
+	}
+}
+static inline uint32_t REG_MDP5_DSPP(uint32_t i0) { return 0x00000000 + __offset_DSPP(i0); }
 
-static inline uint32_t REG_MDP5_DSPP_OP_MODE(uint32_t i0) { return 0x00004600 + 0x400*i0; }
+static inline uint32_t REG_MDP5_DSPP_OP_MODE(uint32_t i0) { return 0x00000000 + __offset_DSPP(i0); }
 #define MDP5_DSPP_OP_MODE_IGC_LUT_EN				0x00000001
 #define MDP5_DSPP_OP_MODE_IGC_TBL_IDX__MASK			0x0000000e
 #define MDP5_DSPP_OP_MODE_IGC_TBL_IDX__SHIFT			1
@@ -811,29 +888,40 @@ static inline uint32_t MDP5_DSPP_OP_MODE_IGC_TBL_IDX(uint32_t val)
 #define MDP5_DSPP_OP_MODE_GAMUT_EN				0x00800000
 #define MDP5_DSPP_OP_MODE_GAMUT_ORDER				0x01000000
 
-static inline uint32_t REG_MDP5_DSPP_PCC_BASE(uint32_t i0) { return 0x00004630 + 0x400*i0; }
+static inline uint32_t REG_MDP5_DSPP_PCC_BASE(uint32_t i0) { return 0x00000030 + __offset_DSPP(i0); }
 
-static inline uint32_t REG_MDP5_DSPP_DITHER_DEPTH(uint32_t i0) { return 0x00004750 + 0x400*i0; }
+static inline uint32_t REG_MDP5_DSPP_DITHER_DEPTH(uint32_t i0) { return 0x00000150 + __offset_DSPP(i0); }
 
-static inline uint32_t REG_MDP5_DSPP_HIST_CTL_BASE(uint32_t i0) { return 0x00004810 + 0x400*i0; }
+static inline uint32_t REG_MDP5_DSPP_HIST_CTL_BASE(uint32_t i0) { return 0x00000210 + __offset_DSPP(i0); }
 
-static inline uint32_t REG_MDP5_DSPP_HIST_LUT_BASE(uint32_t i0) { return 0x00004830 + 0x400*i0; }
+static inline uint32_t REG_MDP5_DSPP_HIST_LUT_BASE(uint32_t i0) { return 0x00000230 + __offset_DSPP(i0); }
 
-static inline uint32_t REG_MDP5_DSPP_HIST_LUT_SWAP(uint32_t i0) { return 0x00004834 + 0x400*i0; }
+static inline uint32_t REG_MDP5_DSPP_HIST_LUT_SWAP(uint32_t i0) { return 0x00000234 + __offset_DSPP(i0); }
 
-static inline uint32_t REG_MDP5_DSPP_PA_BASE(uint32_t i0) { return 0x00004838 + 0x400*i0; }
+static inline uint32_t REG_MDP5_DSPP_PA_BASE(uint32_t i0) { return 0x00000238 + __offset_DSPP(i0); }
 
-static inline uint32_t REG_MDP5_DSPP_GAMUT_BASE(uint32_t i0) { return 0x000048dc + 0x400*i0; }
+static inline uint32_t REG_MDP5_DSPP_GAMUT_BASE(uint32_t i0) { return 0x000002dc + __offset_DSPP(i0); }
 
-static inline uint32_t REG_MDP5_DSPP_GC_BASE(uint32_t i0) { return 0x000048b0 + 0x400*i0; }
+static inline uint32_t REG_MDP5_DSPP_GC_BASE(uint32_t i0) { return 0x000002b0 + __offset_DSPP(i0); }
 
-static inline uint32_t REG_MDP5_INTF(uint32_t i0) { return 0x00012500 + 0x200*i0; }
+static inline uint32_t __offset_INTF(uint32_t idx)
+{
+	switch (idx) {
+		case 0: return (mdp5_cfg->intf.base[0]);
+		case 1: return (mdp5_cfg->intf.base[1]);
+		case 2: return (mdp5_cfg->intf.base[2]);
+		case 3: return (mdp5_cfg->intf.base[3]);
+		case 4: return (mdp5_cfg->intf.base[4]);
+		default: return INVALID_IDX(idx);
+	}
+}
+static inline uint32_t REG_MDP5_INTF(uint32_t i0) { return 0x00000000 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TIMING_ENGINE_EN(uint32_t i0) { return 0x00012500 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TIMING_ENGINE_EN(uint32_t i0) { return 0x00000000 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_CONFIG(uint32_t i0) { return 0x00012504 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_CONFIG(uint32_t i0) { return 0x00000004 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_HSYNC_CTL(uint32_t i0) { return 0x00012508 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_HSYNC_CTL(uint32_t i0) { return 0x00000008 + __offset_INTF(i0); }
 #define MDP5_INTF_HSYNC_CTL_PULSEW__MASK			0x0000ffff
 #define MDP5_INTF_HSYNC_CTL_PULSEW__SHIFT			0
 static inline uint32_t MDP5_INTF_HSYNC_CTL_PULSEW(uint32_t val)
@@ -847,23 +935,23 @@ static inline uint32_t MDP5_INTF_HSYNC_CTL_PERIOD(uint32_t val)
 	return ((val) << MDP5_INTF_HSYNC_CTL_PERIOD__SHIFT) & MDP5_INTF_HSYNC_CTL_PERIOD__MASK;
 }
 
-static inline uint32_t REG_MDP5_INTF_VSYNC_PERIOD_F0(uint32_t i0) { return 0x0001250c + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_VSYNC_PERIOD_F0(uint32_t i0) { return 0x0000000c + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_VSYNC_PERIOD_F1(uint32_t i0) { return 0x00012510 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_VSYNC_PERIOD_F1(uint32_t i0) { return 0x00000010 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_VSYNC_LEN_F0(uint32_t i0) { return 0x00012514 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_VSYNC_LEN_F0(uint32_t i0) { return 0x00000014 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_VSYNC_LEN_F1(uint32_t i0) { return 0x00012518 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_VSYNC_LEN_F1(uint32_t i0) { return 0x00000018 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_DISPLAY_VSTART_F0(uint32_t i0) { return 0x0001251c + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_DISPLAY_VSTART_F0(uint32_t i0) { return 0x0000001c + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_DISPLAY_VSTART_F1(uint32_t i0) { return 0x00012520 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_DISPLAY_VSTART_F1(uint32_t i0) { return 0x00000020 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_DISPLAY_VEND_F0(uint32_t i0) { return 0x00012524 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_DISPLAY_VEND_F0(uint32_t i0) { return 0x00000024 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_DISPLAY_VEND_F1(uint32_t i0) { return 0x00012528 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_DISPLAY_VEND_F1(uint32_t i0) { return 0x00000028 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_ACTIVE_VSTART_F0(uint32_t i0) { return 0x0001252c + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_ACTIVE_VSTART_F0(uint32_t i0) { return 0x0000002c + __offset_INTF(i0); }
 #define MDP5_INTF_ACTIVE_VSTART_F0_VAL__MASK			0x7fffffff
 #define MDP5_INTF_ACTIVE_VSTART_F0_VAL__SHIFT			0
 static inline uint32_t MDP5_INTF_ACTIVE_VSTART_F0_VAL(uint32_t val)
@@ -872,7 +960,7 @@ static inline uint32_t MDP5_INTF_ACTIVE_VSTART_F0_VAL(uint32_t val)
 }
 #define MDP5_INTF_ACTIVE_VSTART_F0_ACTIVE_V_ENABLE		0x80000000
 
-static inline uint32_t REG_MDP5_INTF_ACTIVE_VSTART_F1(uint32_t i0) { return 0x00012530 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_ACTIVE_VSTART_F1(uint32_t i0) { return 0x00000030 + __offset_INTF(i0); }
 #define MDP5_INTF_ACTIVE_VSTART_F1_VAL__MASK			0x7fffffff
 #define MDP5_INTF_ACTIVE_VSTART_F1_VAL__SHIFT			0
 static inline uint32_t MDP5_INTF_ACTIVE_VSTART_F1_VAL(uint32_t val)
@@ -880,11 +968,11 @@ static inline uint32_t MDP5_INTF_ACTIVE_VSTART_F1_VAL(uint32_t val)
 	return ((val) << MDP5_INTF_ACTIVE_VSTART_F1_VAL__SHIFT) & MDP5_INTF_ACTIVE_VSTART_F1_VAL__MASK;
 }
 
-static inline uint32_t REG_MDP5_INTF_ACTIVE_VEND_F0(uint32_t i0) { return 0x00012534 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_ACTIVE_VEND_F0(uint32_t i0) { return 0x00000034 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_ACTIVE_VEND_F1(uint32_t i0) { return 0x00012538 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_ACTIVE_VEND_F1(uint32_t i0) { return 0x00000038 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_DISPLAY_HCTL(uint32_t i0) { return 0x0001253c + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_DISPLAY_HCTL(uint32_t i0) { return 0x0000003c + __offset_INTF(i0); }
 #define MDP5_INTF_DISPLAY_HCTL_START__MASK			0x0000ffff
 #define MDP5_INTF_DISPLAY_HCTL_START__SHIFT			0
 static inline uint32_t MDP5_INTF_DISPLAY_HCTL_START(uint32_t val)
@@ -898,7 +986,7 @@ static inline uint32_t MDP5_INTF_DISPLAY_HCTL_END(uint32_t val)
 	return ((val) << MDP5_INTF_DISPLAY_HCTL_END__SHIFT) & MDP5_INTF_DISPLAY_HCTL_END__MASK;
 }
 
-static inline uint32_t REG_MDP5_INTF_ACTIVE_HCTL(uint32_t i0) { return 0x00012540 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_ACTIVE_HCTL(uint32_t i0) { return 0x00000040 + __offset_INTF(i0); }
 #define MDP5_INTF_ACTIVE_HCTL_START__MASK			0x00007fff
 #define MDP5_INTF_ACTIVE_HCTL_START__SHIFT			0
 static inline uint32_t MDP5_INTF_ACTIVE_HCTL_START(uint32_t val)
@@ -913,124 +1001,132 @@ static inline uint32_t MDP5_INTF_ACTIVE_HCTL_END(uint32_t val)
 }
 #define MDP5_INTF_ACTIVE_HCTL_ACTIVE_H_ENABLE			0x80000000
 
-static inline uint32_t REG_MDP5_INTF_BORDER_COLOR(uint32_t i0) { return 0x00012544 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_BORDER_COLOR(uint32_t i0) { return 0x00000044 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_UNDERFLOW_COLOR(uint32_t i0) { return 0x00012548 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_UNDERFLOW_COLOR(uint32_t i0) { return 0x00000048 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_HSYNC_SKEW(uint32_t i0) { return 0x0001254c + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_HSYNC_SKEW(uint32_t i0) { return 0x0000004c + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_POLARITY_CTL(uint32_t i0) { return 0x00012550 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_POLARITY_CTL(uint32_t i0) { return 0x00000050 + __offset_INTF(i0); }
 #define MDP5_INTF_POLARITY_CTL_HSYNC_LOW			0x00000001
 #define MDP5_INTF_POLARITY_CTL_VSYNC_LOW			0x00000002
 #define MDP5_INTF_POLARITY_CTL_DATA_EN_LOW			0x00000004
 
-static inline uint32_t REG_MDP5_INTF_TEST_CTL(uint32_t i0) { return 0x00012554 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TEST_CTL(uint32_t i0) { return 0x00000054 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TP_COLOR0(uint32_t i0) { return 0x00012558 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TP_COLOR0(uint32_t i0) { return 0x00000058 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TP_COLOR1(uint32_t i0) { return 0x0001255c + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TP_COLOR1(uint32_t i0) { return 0x0000005c + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_DSI_CMD_MODE_TRIGGER_EN(uint32_t i0) { return 0x00012584 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_DSI_CMD_MODE_TRIGGER_EN(uint32_t i0) { return 0x00000084 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_PANEL_FORMAT(uint32_t i0) { return 0x00012590 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_PANEL_FORMAT(uint32_t i0) { return 0x00000090 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_FRAME_LINE_COUNT_EN(uint32_t i0) { return 0x000125a8 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_FRAME_LINE_COUNT_EN(uint32_t i0) { return 0x000000a8 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_FRAME_COUNT(uint32_t i0) { return 0x000125ac + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_FRAME_COUNT(uint32_t i0) { return 0x000000ac + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_LINE_COUNT(uint32_t i0) { return 0x000125b0 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_LINE_COUNT(uint32_t i0) { return 0x000000b0 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_DEFLICKER_CONFIG(uint32_t i0) { return 0x000125f0 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_DEFLICKER_CONFIG(uint32_t i0) { return 0x000000f0 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_DEFLICKER_STRNG_COEFF(uint32_t i0) { return 0x000125f4 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_DEFLICKER_STRNG_COEFF(uint32_t i0) { return 0x000000f4 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_DEFLICKER_WEAK_COEFF(uint32_t i0) { return 0x000125f8 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_DEFLICKER_WEAK_COEFF(uint32_t i0) { return 0x000000f8 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TPG_ENABLE(uint32_t i0) { return 0x00012600 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TPG_ENABLE(uint32_t i0) { return 0x00000100 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TPG_MAIN_CONTROL(uint32_t i0) { return 0x00012604 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TPG_MAIN_CONTROL(uint32_t i0) { return 0x00000104 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TPG_VIDEO_CONFIG(uint32_t i0) { return 0x00012608 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TPG_VIDEO_CONFIG(uint32_t i0) { return 0x00000108 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TPG_COMPONENT_LIMITS(uint32_t i0) { return 0x0001260c + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TPG_COMPONENT_LIMITS(uint32_t i0) { return 0x0000010c + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TPG_RECTANGLE(uint32_t i0) { return 0x00012610 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TPG_RECTANGLE(uint32_t i0) { return 0x00000110 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TPG_INITIAL_VALUE(uint32_t i0) { return 0x00012614 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TPG_INITIAL_VALUE(uint32_t i0) { return 0x00000114 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TPG_BLK_WHITE_PATTERN_FRAME(uint32_t i0) { return 0x00012618 + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TPG_BLK_WHITE_PATTERN_FRAME(uint32_t i0) { return 0x00000118 + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_INTF_TPG_RGB_MAPPING(uint32_t i0) { return 0x0001261c + 0x200*i0; }
+static inline uint32_t REG_MDP5_INTF_TPG_RGB_MAPPING(uint32_t i0) { return 0x0000011c + __offset_INTF(i0); }
 
-static inline uint32_t REG_MDP5_AD(uint32_t i0) { return 0x00013100 + 0x200*i0; }
+static inline uint32_t __offset_AD(uint32_t idx)
+{
+	switch (idx) {
+		case 0: return (mdp5_cfg->ad.base[0]);
+		case 1: return (mdp5_cfg->ad.base[1]);
+		default: return INVALID_IDX(idx);
+	}
+}
+static inline uint32_t REG_MDP5_AD(uint32_t i0) { return 0x00000000 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_BYPASS(uint32_t i0) { return 0x00013100 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_BYPASS(uint32_t i0) { return 0x00000000 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_CTRL_0(uint32_t i0) { return 0x00013104 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_CTRL_0(uint32_t i0) { return 0x00000004 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_CTRL_1(uint32_t i0) { return 0x00013108 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_CTRL_1(uint32_t i0) { return 0x00000008 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_FRAME_SIZE(uint32_t i0) { return 0x0001310c + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_FRAME_SIZE(uint32_t i0) { return 0x0000000c + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_CON_CTRL_0(uint32_t i0) { return 0x00013110 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_CON_CTRL_0(uint32_t i0) { return 0x00000010 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_CON_CTRL_1(uint32_t i0) { return 0x00013114 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_CON_CTRL_1(uint32_t i0) { return 0x00000014 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_STR_MAN(uint32_t i0) { return 0x00013118 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_STR_MAN(uint32_t i0) { return 0x00000018 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_VAR(uint32_t i0) { return 0x0001311c + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_VAR(uint32_t i0) { return 0x0000001c + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_DITH(uint32_t i0) { return 0x00013120 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_DITH(uint32_t i0) { return 0x00000020 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_DITH_CTRL(uint32_t i0) { return 0x00013124 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_DITH_CTRL(uint32_t i0) { return 0x00000024 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_AMP_LIM(uint32_t i0) { return 0x00013128 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_AMP_LIM(uint32_t i0) { return 0x00000028 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_SLOPE(uint32_t i0) { return 0x0001312c + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_SLOPE(uint32_t i0) { return 0x0000002c + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_BW_LVL(uint32_t i0) { return 0x00013130 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_BW_LVL(uint32_t i0) { return 0x00000030 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_LOGO_POS(uint32_t i0) { return 0x00013134 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_LOGO_POS(uint32_t i0) { return 0x00000034 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_LUT_FI(uint32_t i0) { return 0x00013138 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_LUT_FI(uint32_t i0) { return 0x00000038 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_LUT_CC(uint32_t i0) { return 0x0001317c + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_LUT_CC(uint32_t i0) { return 0x0000007c + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_STR_LIM(uint32_t i0) { return 0x000131c8 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_STR_LIM(uint32_t i0) { return 0x000000c8 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_CALIB_AB(uint32_t i0) { return 0x000131cc + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_CALIB_AB(uint32_t i0) { return 0x000000cc + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_CALIB_CD(uint32_t i0) { return 0x000131d0 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_CALIB_CD(uint32_t i0) { return 0x000000d0 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_MODE_SEL(uint32_t i0) { return 0x000131d4 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_MODE_SEL(uint32_t i0) { return 0x000000d4 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_TFILT_CTRL(uint32_t i0) { return 0x000131d8 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_TFILT_CTRL(uint32_t i0) { return 0x000000d8 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_BL_MINMAX(uint32_t i0) { return 0x000131dc + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_BL_MINMAX(uint32_t i0) { return 0x000000dc + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_BL(uint32_t i0) { return 0x000131e0 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_BL(uint32_t i0) { return 0x000000e0 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_BL_MAX(uint32_t i0) { return 0x000131e8 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_BL_MAX(uint32_t i0) { return 0x000000e8 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_AL(uint32_t i0) { return 0x000131ec + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_AL(uint32_t i0) { return 0x000000ec + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_AL_MIN(uint32_t i0) { return 0x000131f0 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_AL_MIN(uint32_t i0) { return 0x000000f0 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_AL_FILT(uint32_t i0) { return 0x000131f4 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_AL_FILT(uint32_t i0) { return 0x000000f4 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_CFG_BUF(uint32_t i0) { return 0x000131f8 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_CFG_BUF(uint32_t i0) { return 0x000000f8 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_LUT_AL(uint32_t i0) { return 0x00013200 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_LUT_AL(uint32_t i0) { return 0x00000100 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_TARG_STR(uint32_t i0) { return 0x00013244 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_TARG_STR(uint32_t i0) { return 0x00000144 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_START_CALC(uint32_t i0) { return 0x00013248 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_START_CALC(uint32_t i0) { return 0x00000148 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_STR_OUT(uint32_t i0) { return 0x0001324c + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_STR_OUT(uint32_t i0) { return 0x0000014c + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_BL_OUT(uint32_t i0) { return 0x00013254 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_BL_OUT(uint32_t i0) { return 0x00000154 + __offset_AD(i0); }
 
-static inline uint32_t REG_MDP5_AD_CALC_DONE(uint32_t i0) { return 0x00013258 + 0x200*i0; }
+static inline uint32_t REG_MDP5_AD_CALC_DONE(uint32_t i0) { return 0x00000158 + __offset_AD(i0); }
 
 
 #endif /* MDP5_XML */
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
index ee8446c..b9b3f4f 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
@@ -22,14 +22,98 @@
 
 static struct mdp5_platform_config *mdp5_get_config(struct platform_device *dev);
 
-static int mdp5_hw_init(struct msm_kms *kms)
+const struct mdp5_config *mdp5_cfg;
+
+static const struct mdp5_config msm8x74_config = {
+	.name = "msm8x74",
+	.ctl = {
+		.count = 5,
+		.base = { 0x00600, 0x00700, 0x00800, 0x00900, 0x00a00 },
+	},
+	.pipe_vig = {
+		.count = 3,
+		.base = { 0x01200, 0x01600, 0x01a00 },
+	},
+	.pipe_rgb = {
+		.count = 3,
+		.base = { 0x01e00, 0x02200, 0x02600 },
+	},
+	.pipe_dma = {
+		.count = 2,
+		.base = { 0x02a00, 0x02e00 },
+	},
+	.lm = {
+		.count = 5,
+		.base = { 0x03200, 0x03600, 0x03a00, 0x03e00, 0x04200 },
+	},
+	.dspp = {
+		.count = 3,
+		.base = { 0x04600, 0x04a00, 0x04e00 },
+	},
+	.ad = {
+		.count = 2,
+		.base = { 0x13100, 0x13300 }, /* NOTE: no ad in v1.0 */
+	},
+	.intf = {
+		.count = 4,
+		.base = { 0x12500, 0x12700, 0x12900, 0x12b00 },
+	},
+};
+
+static const struct mdp5_config apq8084_config = {
+	.name = "apq8084",
+	.ctl = {
+		.count = 5,
+		.base = { 0x00600, 0x00700, 0x00800, 0x00900, 0x00a00 },
+	},
+	.pipe_vig = {
+		.count = 4,
+		.base = { 0x01200, 0x01600, 0x01a00, 0x01e00 },
+	},
+	.pipe_rgb = {
+		.count = 4,
+		.base = { 0x02200, 0x02600, 0x02a00, 0x02e00 },
+	},
+	.pipe_dma = {
+		.count = 2,
+		.base = { 0x03200, 0x03600 },
+	},
+	.lm = {
+		.count = 6,
+		.base = { 0x03a00, 0x03e00, 0x04200, 0x04600, 0x04a00, 0x04e00 },
+	},
+	.dspp = {
+		.count = 4,
+		.base = { 0x05200, 0x05600, 0x05a00, 0x05e00 },
+
+	},
+	.ad = {
+		.count = 3,
+		.base = { 0x13500, 0x13700, 0x13900 },
+	},
+	.intf = {
+		.count = 5,
+		.base = { 0x12500, 0x12700, 0x12900, 0x12b00, 0x12d00 },
+	},
+};
+
+struct mdp5_config_entry {
+	int revision;
+	const struct mdp5_config *config;
+};
+
+static const struct mdp5_config_entry mdp5_configs[] = {
+	{ .revision = 0, .config = &msm8x74_config },
+	{ .revision = 2, .config = &msm8x74_config },
+	{ .revision = 3, .config = &apq8084_config },
+};
+
+static int mdp5_select_hw_cfg(struct msm_kms *kms)
 {
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
 	struct drm_device *dev = mdp5_kms->dev;
 	uint32_t version, major, minor;
-	int ret = 0;
-
-	pm_runtime_get_sync(dev->dev);
+	int i, ret = 0;
 
 	mdp5_enable(mdp5_kms);
 	version = mdp5_read(mdp5_kms, REG_MDP5_MDP_VERSION);
@@ -40,8 +124,8 @@ static int mdp5_hw_init(struct msm_kms *kms)
 
 	DBG("found MDP5 version v%d.%d", major, minor);
 
-	if ((major != 1) || ((minor != 0) && (minor != 2))) {
-		dev_err(dev->dev, "unexpected MDP version: v%d.%d\n",
+	if (major != 1) {
+		dev_err(dev->dev, "unexpected MDP major version: v%d.%d\n",
 				major, minor);
 		ret = -ENXIO;
 		goto out;
@@ -49,6 +133,35 @@ static int mdp5_hw_init(struct msm_kms *kms)
 
 	mdp5_kms->rev = minor;
 
+	/* only after mdp5_cfg global pointer's init can we access the hw */
+	for (i = 0; i < ARRAY_SIZE(mdp5_configs); i++) {
+		if (mdp5_configs[i].revision != minor)
+			continue;
+		mdp5_kms->hw_cfg = mdp5_cfg = mdp5_configs[i].config;
+		break;
+	}
+	if (unlikely(!mdp5_kms->hw_cfg)) {
+		dev_err(dev->dev, "unexpected MDP minor revision: v%d.%d\n",
+				major, minor);
+		ret = -ENXIO;
+		goto out;
+	}
+
+	DBG("MDP5: %s config selected", mdp5_kms->hw_cfg->name);
+
+	return 0;
+out:
+	return ret;
+}
+
+static int mdp5_hw_init(struct msm_kms *kms)
+{
+	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
+	struct drm_device *dev = mdp5_kms->dev;
+	int i;
+
+	pm_runtime_get_sync(dev->dev);
+
 	/* Magic unknown register writes:
 	 *
 	 *    W VBIF:0x004 00000001      (mdss_mdp.c:839)
@@ -74,15 +187,13 @@ static int mdp5_hw_init(struct msm_kms *kms)
 	 */
 
 	mdp5_write(mdp5_kms, REG_MDP5_DISP_INTF_SEL, 0);
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_OP(0), 0);
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_OP(1), 0);
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_OP(2), 0);
-	mdp5_write(mdp5_kms, REG_MDP5_CTL_OP(3), 0);
 
-out:
+	for (i = 0; i < mdp5_kms->hw_cfg->ctl.count; i++)
+		mdp5_write(mdp5_kms, REG_MDP5_CTL_OP(i), 0);
+
 	pm_runtime_put_sync(dev->dev);
 
-	return ret;
+	return 0;
 }
 
 static long mdp5_round_pixclk(struct msm_kms *kms, unsigned long rate,
@@ -151,7 +262,7 @@ int mdp5_enable(struct mdp5_kms *mdp5_kms)
 static int modeset_init(struct mdp5_kms *mdp5_kms)
 {
 	static const enum mdp5_pipe crtcs[] = {
-			SSPP_RGB0, SSPP_RGB1, SSPP_RGB2,
+			SSPP_RGB0, SSPP_RGB1, SSPP_RGB2, SSPP_RGB3,
 	};
 	struct drm_device *dev = mdp5_kms->dev;
 	struct msm_drm_private *priv = dev->dev_private;
@@ -159,7 +270,7 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
 	int i, ret;
 
 	/* construct CRTCs: */
-	for (i = 0; i < ARRAY_SIZE(crtcs); i++) {
+	for (i = 0; i < mdp5_kms->hw_cfg->pipe_rgb.count; i++) {
 		struct drm_plane *plane;
 		struct drm_crtc *crtc;
 
@@ -240,7 +351,7 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 	struct mdp5_kms *mdp5_kms;
 	struct msm_kms *kms = NULL;
 	struct msm_mmu *mmu;
-	int ret;
+	int i, ret;
 
 	mdp5_kms = kzalloc(sizeof(*mdp5_kms), GFP_KERNEL);
 	if (!mdp5_kms) {
@@ -291,15 +402,17 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 
 	ret = clk_set_rate(mdp5_kms->src_clk, config->max_clk);
 
+	ret = mdp5_select_hw_cfg(kms);
+	if (ret)
+		goto fail;
+
 	/* make sure things are off before attaching iommu (bootloader could
 	 * have left things on, in which case we'll start getting faults if
 	 * we don't disable):
 	 */
 	mdp5_enable(mdp5_kms);
-	mdp5_write(mdp5_kms, REG_MDP5_INTF_TIMING_ENGINE_EN(0), 0);
-	mdp5_write(mdp5_kms, REG_MDP5_INTF_TIMING_ENGINE_EN(1), 0);
-	mdp5_write(mdp5_kms, REG_MDP5_INTF_TIMING_ENGINE_EN(2), 0);
-	mdp5_write(mdp5_kms, REG_MDP5_INTF_TIMING_ENGINE_EN(3), 0);
+	for (i = 0; i < mdp5_kms->hw_cfg->intf.count; i++)
+		mdp5_write(mdp5_kms, REG_MDP5_INTF_TIMING_ENGINE_EN(i), 0);
 	mdp5_disable(mdp5_kms);
 	mdelay(16);
 
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
index c8b1a25..ee7e5c6 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
@@ -21,6 +21,24 @@
 #include "msm_drv.h"
 #include "msm_kms.h"
 #include "mdp/mdp_kms.h"
+/* dynamic offsets used by mdp5.xml.h (initialized in mdp5_kms.c) */
+#define MDP5_MAX_BASES		8
+struct mdp5_sub_block {
+	int	count;
+	uint32_t base[MDP5_MAX_BASES];
+};
+struct mdp5_config {
+	char  *name;
+	struct mdp5_sub_block ctl;
+	struct mdp5_sub_block pipe_vig;
+	struct mdp5_sub_block pipe_rgb;
+	struct mdp5_sub_block pipe_dma;
+	struct mdp5_sub_block lm;
+	struct mdp5_sub_block dspp;
+	struct mdp5_sub_block ad;
+	struct mdp5_sub_block intf;
+};
+extern const struct mdp5_config *mdp5_cfg;
 #include "mdp5.xml.h"
 #include "mdp5_smp.h"
 
@@ -30,6 +48,7 @@ struct mdp5_kms {
 	struct drm_device *dev;
 
 	int rev;
+	const struct mdp5_config *hw_cfg;
 
 	/* mapper-id used to request GEM buffer mapped for scanout: */
 	int id;
@@ -81,6 +100,7 @@ static inline const char *pipe2name(enum mdp5_pipe pipe)
 		NAME(VIG0), NAME(VIG1), NAME(VIG2),
 		NAME(RGB0), NAME(RGB1), NAME(RGB2),
 		NAME(DMA0), NAME(DMA1),
+		NAME(VIG3), NAME(RGB3),
 #undef NAME
 	};
 	return names[pipe];
@@ -97,6 +117,8 @@ static inline uint32_t pipe2flush(enum mdp5_pipe pipe)
 	case SSPP_RGB2: return MDP5_CTL_FLUSH_RGB2;
 	case SSPP_DMA0: return MDP5_CTL_FLUSH_DMA0;
 	case SSPP_DMA1: return MDP5_CTL_FLUSH_DMA1;
+	case SSPP_VIG3: return MDP5_CTL_FLUSH_VIG3;
+	case SSPP_RGB3: return MDP5_CTL_FLUSH_RGB3;
 	default:        return 0;
 	}
 }
@@ -107,6 +129,7 @@ static inline int pipe2nclients(enum mdp5_pipe pipe)
 	case SSPP_RGB0:
 	case SSPP_RGB1:
 	case SSPP_RGB2:
+	case SSPP_RGB3:
 		return 1;
 	default:
 		return 3;
@@ -125,6 +148,8 @@ static inline enum mdp5_client_id pipe2client(enum mdp5_pipe pipe, int plane)
 	case SSPP_RGB2: return CID_RGB2;
 	case SSPP_DMA0: return CID_DMA0_Y + plane;
 	case SSPP_DMA1: return CID_DMA1_Y + plane;
+	case SSPP_VIG3: return CID_VIG3_Y + plane;
+	case SSPP_RGB3: return CID_RGB3;
 	default:        return CID_UNUSED;
 	}
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

