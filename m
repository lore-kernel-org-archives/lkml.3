Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaESKyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:54:43 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26092 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaESKyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:40 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-6c-5379e2ee3044
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH 6/8] drm/exynos/fimc: replace hw access macros with functions
Date: Mon, 19 May 2014 12:54:08 +0200
Message-id: <1400496850-23860-7-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
References: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7rvHlUGG1xZw2Jxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVx99RPxoLNtxgrlv6axdTA+HgrYxcjJ4eEgInE7VNHWCFsMYkL
	99azdTFycQgJLGWUWL3uGTuE08ck0br1HxNIFZuApsTfzTfZQGwRAR2J6z3dzCBFzALPmCTu
	3F0H1MHBISzgK9H6GsxkEVCV2PzBEKScV8BZYuvzyVCL5SROHpsMtphTwEXixLHlYLYQUM3j
	XUfZJzDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kRElhfdjAuPmZ1iFGAg1GJh/dD
	QmWwEGtiWXFl7iFGCQ5mJRHebTeAQrwpiZVVqUX58UWlOanFhxiZODilGhiXC0VV8qxfuX72
	Rae4SRzaTmYtf/6cfPN/5vIfksKatoK9V1frPugpSLvTeKVszhUzeUuDItGDNbdjLh5YONn7
	01WdA6/5Jh3Yv1Kk74C7eaKgxBWPKOaQc4vZbv7bPrk362H7IeHrtR+qelKFn2QKdor+iV/k
	fP59qQ/DY2GtTWsP2erYrj+uxFKckWioxVxUnAgAchsmCwoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HW access macros implicitly depended on presence of ctx local variable.
This patch replaces them with C functions.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 311 +++++++++++++++----------------
 1 file changed, 150 insertions(+), 161 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 409775f..7a66f18 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -69,9 +69,6 @@
 #define get_fimc_context(dev)	platform_get_drvdata(to_platform_device(dev))
 #define get_ctx_from_ippdrv(ippdrv)	container_of(ippdrv,\
 					struct fimc_context, ippdrv);
-#define fimc_read(offset)		readl(ctx->regs + (offset))
-#define fimc_write(cfg, offset)	writel(cfg, ctx->regs + (offset))
-
 enum fimc_wb {
 	FIMC_WB_NONE,
 	FIMC_WB_A,
@@ -172,39 +169,53 @@ struct fimc_context {
 	bool	suspended;
 };
 
+static u32 fimc_read(struct fimc_context *ctx, u32 reg)
+{
+	return readl(ctx->regs + reg);
+}
+
+static void fimc_write(struct fimc_context *ctx, u32 val, u32 reg)
+{
+	writel(val, ctx->regs + reg);
+}
+
+static void fimc_set_bits(struct fimc_context *ctx, u32 reg, u32 bits)
+{
+	void __iomem *r = ctx->regs + reg;
+
+	writel(readl(r) | bits, r);
+}
+
+static void fimc_clear_bits(struct fimc_context *ctx, u32 reg, u32 bits)
+{
+	void __iomem *r = ctx->regs + reg;
+
+	writel(readl(r) & ~bits, r);
+}
+
 static void fimc_sw_reset(struct fimc_context *ctx)
 {
 	u32 cfg;
 
 	/* stop dma operation */
-	cfg = fimc_read(EXYNOS_CISTATUS);
-	if (EXYNOS_CISTATUS_GET_ENVID_STATUS(cfg)) {
-		cfg = fimc_read(EXYNOS_MSCTRL);
-		cfg &= ~EXYNOS_MSCTRL_ENVID;
-		fimc_write(cfg, EXYNOS_MSCTRL);
-	}
+	cfg = fimc_read(ctx, EXYNOS_CISTATUS);
+	if (EXYNOS_CISTATUS_GET_ENVID_STATUS(cfg))
+		fimc_clear_bits(ctx, EXYNOS_MSCTRL, EXYNOS_MSCTRL_ENVID);
 
-	cfg = fimc_read(EXYNOS_CISRCFMT);
-	cfg |= EXYNOS_CISRCFMT_ITU601_8BIT;
-	fimc_write(cfg, EXYNOS_CISRCFMT);
+	fimc_set_bits(ctx, EXYNOS_CISRCFMT, EXYNOS_CISRCFMT_ITU601_8BIT);
 
 	/* disable image capture */
-	cfg = fimc_read(EXYNOS_CIIMGCPT);
-	cfg &= ~(EXYNOS_CIIMGCPT_IMGCPTEN_SC | EXYNOS_CIIMGCPT_IMGCPTEN);
-	fimc_write(cfg, EXYNOS_CIIMGCPT);
+	fimc_clear_bits(ctx, EXYNOS_CIIMGCPT,
+		EXYNOS_CIIMGCPT_IMGCPTEN_SC | EXYNOS_CIIMGCPT_IMGCPTEN);
 
 	/* s/w reset */
-	cfg = fimc_read(EXYNOS_CIGCTRL);
-	cfg |= (EXYNOS_CIGCTRL_SWRST);
-	fimc_write(cfg, EXYNOS_CIGCTRL);
+	fimc_set_bits(ctx, EXYNOS_CIGCTRL, EXYNOS_CIGCTRL_SWRST);
 
 	/* s/w reset complete */
-	cfg = fimc_read(EXYNOS_CIGCTRL);
-	cfg &= ~EXYNOS_CIGCTRL_SWRST;
-	fimc_write(cfg, EXYNOS_CIGCTRL);
+	fimc_clear_bits(ctx, EXYNOS_CIGCTRL, EXYNOS_CIGCTRL_SWRST);
 
 	/* reset sequence */
-	fimc_write(0x0, EXYNOS_CIFCNTSEQ);
+	fimc_write(ctx, 0x0, EXYNOS_CIFCNTSEQ);
 }
 
 static int fimc_set_camblk_fimd0_wb(struct fimc_context *ctx)
@@ -220,7 +231,7 @@ static void fimc_set_type_ctrl(struct fimc_context *ctx, enum fimc_wb wb)
 
 	DRM_DEBUG_KMS("wb[%d]\n", wb);
 
-	cfg = fimc_read(EXYNOS_CIGCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CIGCTRL);
 	cfg &= ~(EXYNOS_CIGCTRL_TESTPATTERN_MASK |
 		EXYNOS_CIGCTRL_SELCAM_ITU_MASK |
 		EXYNOS_CIGCTRL_SELCAM_MIPI_MASK |
@@ -246,7 +257,7 @@ static void fimc_set_type_ctrl(struct fimc_context *ctx, enum fimc_wb wb)
 		break;
 	}
 
-	fimc_write(cfg, EXYNOS_CIGCTRL);
+	fimc_write(ctx, cfg, EXYNOS_CIGCTRL);
 }
 
 static void fimc_set_polarity(struct fimc_context *ctx,
@@ -259,7 +270,7 @@ static void fimc_set_polarity(struct fimc_context *ctx,
 	DRM_DEBUG_KMS("inv_href[%d]inv_hsync[%d]\n",
 		pol->inv_href, pol->inv_hsync);
 
-	cfg = fimc_read(EXYNOS_CIGCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CIGCTRL);
 	cfg &= ~(EXYNOS_CIGCTRL_INVPOLPCLK | EXYNOS_CIGCTRL_INVPOLVSYNC |
 		 EXYNOS_CIGCTRL_INVPOLHREF | EXYNOS_CIGCTRL_INVPOLHSYNC);
 
@@ -272,7 +283,7 @@ static void fimc_set_polarity(struct fimc_context *ctx,
 	if (pol->inv_hsync)
 		cfg |= EXYNOS_CIGCTRL_INVPOLHSYNC;
 
-	fimc_write(cfg, EXYNOS_CIGCTRL);
+	fimc_write(ctx, cfg, EXYNOS_CIGCTRL);
 }
 
 static void fimc_handle_jpeg(struct fimc_context *ctx, bool enable)
@@ -281,13 +292,13 @@ static void fimc_handle_jpeg(struct fimc_context *ctx, bool enable)
 
 	DRM_DEBUG_KMS("enable[%d]\n", enable);
 
-	cfg = fimc_read(EXYNOS_CIGCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CIGCTRL);
 	if (enable)
 		cfg |= EXYNOS_CIGCTRL_CAM_JPEG;
 	else
 		cfg &= ~EXYNOS_CIGCTRL_CAM_JPEG;
 
-	fimc_write(cfg, EXYNOS_CIGCTRL);
+	fimc_write(ctx, cfg, EXYNOS_CIGCTRL);
 }
 
 static void fimc_mask_irq(struct fimc_context *ctx, bool enable)
@@ -296,48 +307,39 @@ static void fimc_mask_irq(struct fimc_context *ctx, bool enable)
 
 	DRM_DEBUG_KMS("enable[%d]\n", enable);
 
-	cfg = fimc_read(EXYNOS_CIGCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CIGCTRL);
 	if (enable) {
 		cfg &= ~EXYNOS_CIGCTRL_IRQ_OVFEN;
 		cfg |= EXYNOS_CIGCTRL_IRQ_ENABLE | EXYNOS_CIGCTRL_IRQ_LEVEL;
 	} else
 		cfg &= ~EXYNOS_CIGCTRL_IRQ_ENABLE;
-	fimc_write(cfg, EXYNOS_CIGCTRL);
+	fimc_write(ctx, cfg, EXYNOS_CIGCTRL);
 }
 
 static void fimc_clear_irq(struct fimc_context *ctx)
 {
-	u32 cfg;
-
-	cfg = fimc_read(EXYNOS_CIGCTRL);
-	cfg |= EXYNOS_CIGCTRL_IRQ_CLR;
-	fimc_write(cfg, EXYNOS_CIGCTRL);
+	fimc_set_bits(ctx, EXYNOS_CIGCTRL, EXYNOS_CIGCTRL_IRQ_CLR);
 }
 
 static bool fimc_check_ovf(struct fimc_context *ctx)
 {
 	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
-	u32 cfg, status, flag;
+	u32 status, flag;
 
-	status = fimc_read(EXYNOS_CISTATUS);
+	status = fimc_read(ctx, EXYNOS_CISTATUS);
 	flag = EXYNOS_CISTATUS_OVFIY | EXYNOS_CISTATUS_OVFICB |
 		EXYNOS_CISTATUS_OVFICR;
 
 	DRM_DEBUG_KMS("flag[0x%x]\n", flag);
 
 	if (status & flag) {
-		cfg = fimc_read(EXYNOS_CIWDOFST);
-		cfg |= (EXYNOS_CIWDOFST_CLROVFIY | EXYNOS_CIWDOFST_CLROVFICB |
+		fimc_set_bits(ctx, EXYNOS_CIWDOFST,
+			EXYNOS_CIWDOFST_CLROVFIY | EXYNOS_CIWDOFST_CLROVFICB |
 			EXYNOS_CIWDOFST_CLROVFICR);
-
-		fimc_write(cfg, EXYNOS_CIWDOFST);
-
-		cfg = fimc_read(EXYNOS_CIWDOFST);
-		cfg &= ~(EXYNOS_CIWDOFST_CLROVFIY | EXYNOS_CIWDOFST_CLROVFICB |
+		fimc_clear_bits(ctx, EXYNOS_CIWDOFST,
+			EXYNOS_CIWDOFST_CLROVFIY | EXYNOS_CIWDOFST_CLROVFICB |
 			EXYNOS_CIWDOFST_CLROVFICR);
 
-		fimc_write(cfg, EXYNOS_CIWDOFST);
-
 		dev_err(ippdrv->dev, "occurred overflow at %d, status 0x%x.\n",
 			ctx->id, status);
 		return true;
@@ -350,7 +352,7 @@ static bool fimc_check_frame_end(struct fimc_context *ctx)
 {
 	u32 cfg;
 
-	cfg = fimc_read(EXYNOS_CISTATUS);
+	cfg = fimc_read(ctx, EXYNOS_CISTATUS);
 
 	DRM_DEBUG_KMS("cfg[0x%x]\n", cfg);
 
@@ -358,7 +360,7 @@ static bool fimc_check_frame_end(struct fimc_context *ctx)
 		return false;
 
 	cfg &= ~(EXYNOS_CISTATUS_FRAMEEND);
-	fimc_write(cfg, EXYNOS_CISTATUS);
+	fimc_write(ctx, cfg, EXYNOS_CISTATUS);
 
 	return true;
 }
@@ -368,7 +370,7 @@ static int fimc_get_buf_id(struct fimc_context *ctx)
 	u32 cfg;
 	int frame_cnt, buf_id;
 
-	cfg = fimc_read(EXYNOS_CISTATUS2);
+	cfg = fimc_read(ctx, EXYNOS_CISTATUS2);
 	frame_cnt = EXYNOS_CISTATUS2_GET_FRAMECOUNT_BEFORE(cfg);
 
 	if (frame_cnt == 0)
@@ -395,13 +397,13 @@ static void fimc_handle_lastend(struct fimc_context *ctx, bool enable)
 
 	DRM_DEBUG_KMS("enable[%d]\n", enable);
 
-	cfg = fimc_read(EXYNOS_CIOCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CIOCTRL);
 	if (enable)
 		cfg |= EXYNOS_CIOCTRL_LASTENDEN;
 	else
 		cfg &= ~EXYNOS_CIOCTRL_LASTENDEN;
 
-	fimc_write(cfg, EXYNOS_CIOCTRL);
+	fimc_write(ctx, cfg, EXYNOS_CIOCTRL);
 }
 
 
@@ -413,18 +415,18 @@ static int fimc_src_set_fmt_order(struct fimc_context *ctx, u32 fmt)
 	DRM_DEBUG_KMS("fmt[0x%x]\n", fmt);
 
 	/* RGB */
-	cfg = fimc_read(EXYNOS_CISCCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CISCCTRL);
 	cfg &= ~EXYNOS_CISCCTRL_INRGB_FMT_RGB_MASK;
 
 	switch (fmt) {
 	case DRM_FORMAT_RGB565:
 		cfg |= EXYNOS_CISCCTRL_INRGB_FMT_RGB565;
-		fimc_write(cfg, EXYNOS_CISCCTRL);
+		fimc_write(ctx, cfg, EXYNOS_CISCCTRL);
 		return 0;
 	case DRM_FORMAT_RGB888:
 	case DRM_FORMAT_XRGB8888:
 		cfg |= EXYNOS_CISCCTRL_INRGB_FMT_RGB888;
-		fimc_write(cfg, EXYNOS_CISCCTRL);
+		fimc_write(ctx, cfg, EXYNOS_CISCCTRL);
 		return 0;
 	default:
 		/* bypass */
@@ -432,7 +434,7 @@ static int fimc_src_set_fmt_order(struct fimc_context *ctx, u32 fmt)
 	}
 
 	/* YUV */
-	cfg = fimc_read(EXYNOS_MSCTRL);
+	cfg = fimc_read(ctx, EXYNOS_MSCTRL);
 	cfg &= ~(EXYNOS_MSCTRL_ORDER2P_SHIFT_MASK |
 		EXYNOS_MSCTRL_C_INT_IN_2PLANE |
 		EXYNOS_MSCTRL_ORDER422_YCBYCR);
@@ -472,7 +474,7 @@ static int fimc_src_set_fmt_order(struct fimc_context *ctx, u32 fmt)
 		return -EINVAL;
 	}
 
-	fimc_write(cfg, EXYNOS_MSCTRL);
+	fimc_write(ctx, cfg, EXYNOS_MSCTRL);
 
 	return 0;
 }
@@ -485,7 +487,7 @@ static int fimc_src_set_fmt(struct device *dev, u32 fmt)
 
 	DRM_DEBUG_KMS("fmt[0x%x]\n", fmt);
 
-	cfg = fimc_read(EXYNOS_MSCTRL);
+	cfg = fimc_read(ctx, EXYNOS_MSCTRL);
 	cfg &= ~EXYNOS_MSCTRL_INFORMAT_RGB;
 
 	switch (fmt) {
@@ -520,9 +522,9 @@ static int fimc_src_set_fmt(struct device *dev, u32 fmt)
 		return -EINVAL;
 	}
 
-	fimc_write(cfg, EXYNOS_MSCTRL);
+	fimc_write(ctx, cfg, EXYNOS_MSCTRL);
 
-	cfg = fimc_read(EXYNOS_CIDMAPARAM);
+	cfg = fimc_read(ctx, EXYNOS_CIDMAPARAM);
 	cfg &= ~EXYNOS_CIDMAPARAM_R_MODE_MASK;
 
 	if (fmt == DRM_FORMAT_NV12MT)
@@ -530,7 +532,7 @@ static int fimc_src_set_fmt(struct device *dev, u32 fmt)
 	else
 		cfg |= EXYNOS_CIDMAPARAM_R_MODE_LINEAR;
 
-	fimc_write(cfg, EXYNOS_CIDMAPARAM);
+	fimc_write(ctx, cfg, EXYNOS_CIDMAPARAM);
 
 	return fimc_src_set_fmt_order(ctx, fmt);
 }
@@ -545,11 +547,11 @@ static int fimc_src_set_transf(struct device *dev,
 
 	DRM_DEBUG_KMS("degree[%d]flip[0x%x]\n", degree, flip);
 
-	cfg1 = fimc_read(EXYNOS_MSCTRL);
+	cfg1 = fimc_read(ctx, EXYNOS_MSCTRL);
 	cfg1 &= ~(EXYNOS_MSCTRL_FLIP_X_MIRROR |
 		EXYNOS_MSCTRL_FLIP_Y_MIRROR);
 
-	cfg2 = fimc_read(EXYNOS_CITRGFMT);
+	cfg2 = fimc_read(ctx, EXYNOS_CITRGFMT);
 	cfg2 &= ~EXYNOS_CITRGFMT_INROT90_CLOCKWISE;
 
 	switch (degree) {
@@ -588,8 +590,8 @@ static int fimc_src_set_transf(struct device *dev,
 		return -EINVAL;
 	}
 
-	fimc_write(cfg1, EXYNOS_MSCTRL);
-	fimc_write(cfg2, EXYNOS_CITRGFMT);
+	fimc_write(ctx, cfg1, EXYNOS_MSCTRL);
+	fimc_write(ctx, cfg2, EXYNOS_CITRGFMT);
 	*swap = (cfg2 & EXYNOS_CITRGFMT_INROT90_CLOCKWISE) ? 1 : 0;
 
 	return 0;
@@ -614,17 +616,17 @@ static int fimc_set_window(struct fimc_context *ctx,
 	 * set window offset 1, 2 size
 	 * check figure 43-21 in user manual
 	 */
-	cfg = fimc_read(EXYNOS_CIWDOFST);
+	cfg = fimc_read(ctx, EXYNOS_CIWDOFST);
 	cfg &= ~(EXYNOS_CIWDOFST_WINHOROFST_MASK |
 		EXYNOS_CIWDOFST_WINVEROFST_MASK);
 	cfg |= (EXYNOS_CIWDOFST_WINHOROFST(h1) |
 		EXYNOS_CIWDOFST_WINVEROFST(v1));
 	cfg |= EXYNOS_CIWDOFST_WINOFSEN;
-	fimc_write(cfg, EXYNOS_CIWDOFST);
+	fimc_write(ctx, cfg, EXYNOS_CIWDOFST);
 
 	cfg = (EXYNOS_CIWDOFST2_WINHOROFST2(h2) |
 		EXYNOS_CIWDOFST2_WINVEROFST2(v2));
-	fimc_write(cfg, EXYNOS_CIWDOFST2);
+	fimc_write(ctx, cfg, EXYNOS_CIWDOFST2);
 
 	return 0;
 }
@@ -644,7 +646,7 @@ static int fimc_src_set_size(struct device *dev, int swap,
 	cfg = (EXYNOS_ORGISIZE_HORIZONTAL(img_sz.hsize) |
 		EXYNOS_ORGISIZE_VERTICAL(img_sz.vsize));
 
-	fimc_write(cfg, EXYNOS_ORGISIZE);
+	fimc_write(ctx, cfg, EXYNOS_ORGISIZE);
 
 	DRM_DEBUG_KMS("x[%d]y[%d]w[%d]h[%d]\n", pos->x, pos->y, pos->w, pos->h);
 
@@ -656,12 +658,12 @@ static int fimc_src_set_size(struct device *dev, int swap,
 	}
 
 	/* set input DMA image size */
-	cfg = fimc_read(EXYNOS_CIREAL_ISIZE);
+	cfg = fimc_read(ctx, EXYNOS_CIREAL_ISIZE);
 	cfg &= ~(EXYNOS_CIREAL_ISIZE_HEIGHT_MASK |
 		EXYNOS_CIREAL_ISIZE_WIDTH_MASK);
 	cfg |= (EXYNOS_CIREAL_ISIZE_WIDTH(img_pos.w) |
 		EXYNOS_CIREAL_ISIZE_HEIGHT(img_pos.h));
-	fimc_write(cfg, EXYNOS_CIREAL_ISIZE);
+	fimc_write(ctx, cfg, EXYNOS_CIREAL_ISIZE);
 
 	/*
 	 * set input FIFO image size
@@ -670,18 +672,18 @@ static int fimc_src_set_size(struct device *dev, int swap,
 	cfg = (EXYNOS_CISRCFMT_ITU601_8BIT |
 		EXYNOS_CISRCFMT_SOURCEHSIZE(img_sz.hsize) |
 		EXYNOS_CISRCFMT_SOURCEVSIZE(img_sz.vsize));
-	fimc_write(cfg, EXYNOS_CISRCFMT);
+	fimc_write(ctx, cfg, EXYNOS_CISRCFMT);
 
 	/* offset Y(RGB), Cb, Cr */
 	cfg = (EXYNOS_CIIYOFF_HORIZONTAL(img_pos.x) |
 		EXYNOS_CIIYOFF_VERTICAL(img_pos.y));
-	fimc_write(cfg, EXYNOS_CIIYOFF);
+	fimc_write(ctx, cfg, EXYNOS_CIIYOFF);
 	cfg = (EXYNOS_CIICBOFF_HORIZONTAL(img_pos.x) |
 		EXYNOS_CIICBOFF_VERTICAL(img_pos.y));
-	fimc_write(cfg, EXYNOS_CIICBOFF);
+	fimc_write(ctx, cfg, EXYNOS_CIICBOFF);
 	cfg = (EXYNOS_CIICROFF_HORIZONTAL(img_pos.x) |
 		EXYNOS_CIICROFF_VERTICAL(img_pos.y));
-	fimc_write(cfg, EXYNOS_CIICROFF);
+	fimc_write(ctx, cfg, EXYNOS_CIICROFF);
 
 	return fimc_set_window(ctx, &img_pos, &img_sz);
 }
@@ -715,25 +717,25 @@ static int fimc_src_set_addr(struct device *dev,
 	switch (buf_type) {
 	case IPP_BUF_ENQUEUE:
 		config = &property->config[EXYNOS_DRM_OPS_SRC];
-		fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_Y],
+		fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_Y],
 			EXYNOS_CIIYSA(buf_id));
 
 		if (config->fmt == DRM_FORMAT_YVU420) {
-			fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_CR],
+			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
 				EXYNOS_CIICBSA(buf_id));
-			fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_CB],
+			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
 				EXYNOS_CIICRSA(buf_id));
 		} else {
-			fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_CB],
+			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
 				EXYNOS_CIICBSA(buf_id));
-			fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_CR],
+			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
 				EXYNOS_CIICRSA(buf_id));
 		}
 		break;
 	case IPP_BUF_DEQUEUE:
-		fimc_write(0x0, EXYNOS_CIIYSA(buf_id));
-		fimc_write(0x0, EXYNOS_CIICBSA(buf_id));
-		fimc_write(0x0, EXYNOS_CIICRSA(buf_id));
+		fimc_write(ctx, 0x0, EXYNOS_CIIYSA(buf_id));
+		fimc_write(ctx, 0x0, EXYNOS_CIICBSA(buf_id));
+		fimc_write(ctx, 0x0, EXYNOS_CIICRSA(buf_id));
 		break;
 	default:
 		/* bypass */
@@ -758,22 +760,22 @@ static int fimc_dst_set_fmt_order(struct fimc_context *ctx, u32 fmt)
 	DRM_DEBUG_KMS("fmt[0x%x]\n", fmt);
 
 	/* RGB */
-	cfg = fimc_read(EXYNOS_CISCCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CISCCTRL);
 	cfg &= ~EXYNOS_CISCCTRL_OUTRGB_FMT_RGB_MASK;
 
 	switch (fmt) {
 	case DRM_FORMAT_RGB565:
 		cfg |= EXYNOS_CISCCTRL_OUTRGB_FMT_RGB565;
-		fimc_write(cfg, EXYNOS_CISCCTRL);
+		fimc_write(ctx, cfg, EXYNOS_CISCCTRL);
 		return 0;
 	case DRM_FORMAT_RGB888:
 		cfg |= EXYNOS_CISCCTRL_OUTRGB_FMT_RGB888;
-		fimc_write(cfg, EXYNOS_CISCCTRL);
+		fimc_write(ctx, cfg, EXYNOS_CISCCTRL);
 		return 0;
 	case DRM_FORMAT_XRGB8888:
 		cfg |= (EXYNOS_CISCCTRL_OUTRGB_FMT_RGB888 |
 			EXYNOS_CISCCTRL_EXTRGB_EXTENSION);
-		fimc_write(cfg, EXYNOS_CISCCTRL);
+		fimc_write(ctx, cfg, EXYNOS_CISCCTRL);
 		break;
 	default:
 		/* bypass */
@@ -781,7 +783,7 @@ static int fimc_dst_set_fmt_order(struct fimc_context *ctx, u32 fmt)
 	}
 
 	/* YUV */
-	cfg = fimc_read(EXYNOS_CIOCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CIOCTRL);
 	cfg &= ~(EXYNOS_CIOCTRL_ORDER2P_MASK |
 		EXYNOS_CIOCTRL_ORDER422_MASK |
 		EXYNOS_CIOCTRL_YCBCR_PLANE_MASK);
@@ -823,7 +825,7 @@ static int fimc_dst_set_fmt_order(struct fimc_context *ctx, u32 fmt)
 		return -EINVAL;
 	}
 
-	fimc_write(cfg, EXYNOS_CIOCTRL);
+	fimc_write(ctx, cfg, EXYNOS_CIOCTRL);
 
 	return 0;
 }
@@ -836,16 +838,16 @@ static int fimc_dst_set_fmt(struct device *dev, u32 fmt)
 
 	DRM_DEBUG_KMS("fmt[0x%x]\n", fmt);
 
-	cfg = fimc_read(EXYNOS_CIEXTEN);
+	cfg = fimc_read(ctx, EXYNOS_CIEXTEN);
 
 	if (fmt == DRM_FORMAT_AYUV) {
 		cfg |= EXYNOS_CIEXTEN_YUV444_OUT;
-		fimc_write(cfg, EXYNOS_CIEXTEN);
+		fimc_write(ctx, cfg, EXYNOS_CIEXTEN);
 	} else {
 		cfg &= ~EXYNOS_CIEXTEN_YUV444_OUT;
-		fimc_write(cfg, EXYNOS_CIEXTEN);
+		fimc_write(ctx, cfg, EXYNOS_CIEXTEN);
 
-		cfg = fimc_read(EXYNOS_CITRGFMT);
+		cfg = fimc_read(ctx, EXYNOS_CITRGFMT);
 		cfg &= ~EXYNOS_CITRGFMT_OUTFORMAT_MASK;
 
 		switch (fmt) {
@@ -878,10 +880,10 @@ static int fimc_dst_set_fmt(struct device *dev, u32 fmt)
 			return -EINVAL;
 		}
 
-		fimc_write(cfg, EXYNOS_CITRGFMT);
+		fimc_write(ctx, cfg, EXYNOS_CITRGFMT);
 	}
 
-	cfg = fimc_read(EXYNOS_CIDMAPARAM);
+	cfg = fimc_read(ctx, EXYNOS_CIDMAPARAM);
 	cfg &= ~EXYNOS_CIDMAPARAM_W_MODE_MASK;
 
 	if (fmt == DRM_FORMAT_NV12MT)
@@ -889,7 +891,7 @@ static int fimc_dst_set_fmt(struct device *dev, u32 fmt)
 	else
 		cfg |= EXYNOS_CIDMAPARAM_W_MODE_LINEAR;
 
-	fimc_write(cfg, EXYNOS_CIDMAPARAM);
+	fimc_write(ctx, cfg, EXYNOS_CIDMAPARAM);
 
 	return fimc_dst_set_fmt_order(ctx, fmt);
 }
@@ -904,7 +906,7 @@ static int fimc_dst_set_transf(struct device *dev,
 
 	DRM_DEBUG_KMS("degree[%d]flip[0x%x]\n", degree, flip);
 
-	cfg = fimc_read(EXYNOS_CITRGFMT);
+	cfg = fimc_read(ctx, EXYNOS_CITRGFMT);
 	cfg &= ~EXYNOS_CITRGFMT_FLIP_MASK;
 	cfg &= ~EXYNOS_CITRGFMT_OUTROT90_CLOCKWISE;
 
@@ -944,7 +946,7 @@ static int fimc_dst_set_transf(struct device *dev,
 		return -EINVAL;
 	}
 
-	fimc_write(cfg, EXYNOS_CITRGFMT);
+	fimc_write(ctx, cfg, EXYNOS_CITRGFMT);
 	*swap = (cfg & EXYNOS_CITRGFMT_OUTROT90_CLOCKWISE) ? 1 : 0;
 
 	return 0;
@@ -960,7 +962,7 @@ static int fimc_set_prescaler(struct fimc_context *ctx, struct fimc_scaler *sc,
 	int ret = 0;
 	u32 src_w, src_h, dst_w, dst_h;
 
-	cfg_ext = fimc_read(EXYNOS_CITRGFMT);
+	cfg_ext = fimc_read(ctx, EXYNOS_CITRGFMT);
 	if (cfg_ext & EXYNOS_CITRGFMT_INROT90_CLOCKWISE) {
 		src_w = src->h;
 		src_h = src->w;
@@ -1009,11 +1011,11 @@ static int fimc_set_prescaler(struct fimc_context *ctx, struct fimc_scaler *sc,
 	cfg = (EXYNOS_CISCPRERATIO_SHFACTOR(shfactor) |
 		EXYNOS_CISCPRERATIO_PREHORRATIO(1 << hfactor) |
 		EXYNOS_CISCPRERATIO_PREVERRATIO(1 << vfactor));
-	fimc_write(cfg, EXYNOS_CISCPRERATIO);
+	fimc_write(ctx, cfg, EXYNOS_CISCPRERATIO);
 
 	cfg = (EXYNOS_CISCPREDST_PREDSTWIDTH(pre_dst_width) |
 		EXYNOS_CISCPREDST_PREDSTHEIGHT(pre_dst_height));
-	fimc_write(cfg, EXYNOS_CISCPREDST);
+	fimc_write(ctx, cfg, EXYNOS_CISCPREDST);
 
 	return ret;
 }
@@ -1027,7 +1029,7 @@ static void fimc_set_scaler(struct fimc_context *ctx, struct fimc_scaler *sc)
 	DRM_DEBUG_KMS("hratio[%d]vratio[%d]\n",
 		sc->hratio, sc->vratio);
 
-	cfg = fimc_read(EXYNOS_CISCCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CISCCTRL);
 	cfg &= ~(EXYNOS_CISCCTRL_SCALERBYPASS |
 		EXYNOS_CISCCTRL_SCALEUP_H | EXYNOS_CISCCTRL_SCALEUP_V |
 		EXYNOS_CISCCTRL_MAIN_V_RATIO_MASK |
@@ -1047,14 +1049,14 @@ static void fimc_set_scaler(struct fimc_context *ctx, struct fimc_scaler *sc)
 
 	cfg |= (EXYNOS_CISCCTRL_MAINHORRATIO((sc->hratio >> 6)) |
 		EXYNOS_CISCCTRL_MAINVERRATIO((sc->vratio >> 6)));
-	fimc_write(cfg, EXYNOS_CISCCTRL);
+	fimc_write(ctx, cfg, EXYNOS_CISCCTRL);
 
-	cfg_ext = fimc_read(EXYNOS_CIEXTEN);
+	cfg_ext = fimc_read(ctx, EXYNOS_CIEXTEN);
 	cfg_ext &= ~EXYNOS_CIEXTEN_MAINHORRATIO_EXT_MASK;
 	cfg_ext &= ~EXYNOS_CIEXTEN_MAINVERRATIO_EXT_MASK;
 	cfg_ext |= (EXYNOS_CIEXTEN_MAINHORRATIO_EXT(sc->hratio) |
 		EXYNOS_CIEXTEN_MAINVERRATIO_EXT(sc->vratio));
-	fimc_write(cfg_ext, EXYNOS_CIEXTEN);
+	fimc_write(ctx, cfg_ext, EXYNOS_CIEXTEN);
 }
 
 static int fimc_dst_set_size(struct device *dev, int swap,
@@ -1072,12 +1074,12 @@ static int fimc_dst_set_size(struct device *dev, int swap,
 	cfg = (EXYNOS_ORGOSIZE_HORIZONTAL(img_sz.hsize) |
 		EXYNOS_ORGOSIZE_VERTICAL(img_sz.vsize));
 
-	fimc_write(cfg, EXYNOS_ORGOSIZE);
+	fimc_write(ctx, cfg, EXYNOS_ORGOSIZE);
 
 	DRM_DEBUG_KMS("x[%d]y[%d]w[%d]h[%d]\n", pos->x, pos->y, pos->w, pos->h);
 
 	/* CSC ITU */
-	cfg = fimc_read(EXYNOS_CIGCTRL);
+	cfg = fimc_read(ctx, EXYNOS_CIGCTRL);
 	cfg &= ~EXYNOS_CIGCTRL_CSC_MASK;
 
 	if (sz->hsize >= FIMC_WIDTH_ITU_709)
@@ -1085,7 +1087,7 @@ static int fimc_dst_set_size(struct device *dev, int swap,
 	else
 		cfg |= EXYNOS_CIGCTRL_CSC_ITU601;
 
-	fimc_write(cfg, EXYNOS_CIGCTRL);
+	fimc_write(ctx, cfg, EXYNOS_CIGCTRL);
 
 	if (swap) {
 		img_pos.w = pos->h;
@@ -1095,27 +1097,27 @@ static int fimc_dst_set_size(struct device *dev, int swap,
 	}
 
 	/* target image size */
-	cfg = fimc_read(EXYNOS_CITRGFMT);
+	cfg = fimc_read(ctx, EXYNOS_CITRGFMT);
 	cfg &= ~(EXYNOS_CITRGFMT_TARGETH_MASK |
 		EXYNOS_CITRGFMT_TARGETV_MASK);
 	cfg |= (EXYNOS_CITRGFMT_TARGETHSIZE(img_pos.w) |
 		EXYNOS_CITRGFMT_TARGETVSIZE(img_pos.h));
-	fimc_write(cfg, EXYNOS_CITRGFMT);
+	fimc_write(ctx, cfg, EXYNOS_CITRGFMT);
 
 	/* target area */
 	cfg = EXYNOS_CITAREA_TARGET_AREA(img_pos.w * img_pos.h);
-	fimc_write(cfg, EXYNOS_CITAREA);
+	fimc_write(ctx, cfg, EXYNOS_CITAREA);
 
 	/* offset Y(RGB), Cb, Cr */
 	cfg = (EXYNOS_CIOYOFF_HORIZONTAL(img_pos.x) |
 		EXYNOS_CIOYOFF_VERTICAL(img_pos.y));
-	fimc_write(cfg, EXYNOS_CIOYOFF);
+	fimc_write(ctx, cfg, EXYNOS_CIOYOFF);
 	cfg = (EXYNOS_CIOCBOFF_HORIZONTAL(img_pos.x) |
 		EXYNOS_CIOCBOFF_VERTICAL(img_pos.y));
-	fimc_write(cfg, EXYNOS_CIOCBOFF);
+	fimc_write(ctx, cfg, EXYNOS_CIOCBOFF);
 	cfg = (EXYNOS_CIOCROFF_HORIZONTAL(img_pos.x) |
 		EXYNOS_CIOCROFF_VERTICAL(img_pos.y));
-	fimc_write(cfg, EXYNOS_CIOCROFF);
+	fimc_write(ctx, cfg, EXYNOS_CIOCROFF);
 
 	return 0;
 }
@@ -1125,7 +1127,7 @@ static int fimc_dst_get_buf_seq(struct fimc_context *ctx)
 	u32 cfg, i, buf_num = 0;
 	u32 mask = 0x00000001;
 
-	cfg = fimc_read(EXYNOS_CIFCNTSEQ);
+	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
 
 	for (i = 0; i < FIMC_REG_SZ; i++)
 		if (cfg & (mask << i))
@@ -1150,7 +1152,7 @@ static int fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
 	mutex_lock(&ctx->lock);
 
 	/* mask register set */
-	cfg = fimc_read(EXYNOS_CIFCNTSEQ);
+	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
 
 	switch (buf_type) {
 	case IPP_BUF_ENQUEUE:
@@ -1168,7 +1170,7 @@ static int fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
 	/* sequence id */
 	cfg &= ~mask;
 	cfg |= (enable << buf_id);
-	fimc_write(cfg, EXYNOS_CIFCNTSEQ);
+	fimc_write(ctx, cfg, EXYNOS_CIFCNTSEQ);
 
 	/* interrupt enable */
 	if (buf_type == IPP_BUF_ENQUEUE &&
@@ -1215,25 +1217,25 @@ static int fimc_dst_set_addr(struct device *dev,
 	case IPP_BUF_ENQUEUE:
 		config = &property->config[EXYNOS_DRM_OPS_DST];
 
-		fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_Y],
+		fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_Y],
 			EXYNOS_CIOYSA(buf_id));
 
 		if (config->fmt == DRM_FORMAT_YVU420) {
-			fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_CR],
+			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
 				EXYNOS_CIOCBSA(buf_id));
-			fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_CB],
+			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
 				EXYNOS_CIOCRSA(buf_id));
 		} else {
-			fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_CB],
+			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
 				EXYNOS_CIOCBSA(buf_id));
-			fimc_write(buf_info->base[EXYNOS_DRM_PLANAR_CR],
+			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
 				EXYNOS_CIOCRSA(buf_id));
 		}
 		break;
 	case IPP_BUF_DEQUEUE:
-		fimc_write(0x0, EXYNOS_CIOYSA(buf_id));
-		fimc_write(0x0, EXYNOS_CIOCBSA(buf_id));
-		fimc_write(0x0, EXYNOS_CIOCRSA(buf_id));
+		fimc_write(ctx, 0x0, EXYNOS_CIOYSA(buf_id));
+		fimc_write(ctx, 0x0, EXYNOS_CIOCBSA(buf_id));
+		fimc_write(ctx, 0x0, EXYNOS_CIOCRSA(buf_id));
 		break;
 	default:
 		/* bypass */
@@ -1465,15 +1467,15 @@ static void fimc_clear_addr(struct fimc_context *ctx)
 	int i;
 
 	for (i = 0; i < FIMC_MAX_SRC; i++) {
-		fimc_write(0, EXYNOS_CIIYSA(i));
-		fimc_write(0, EXYNOS_CIICBSA(i));
-		fimc_write(0, EXYNOS_CIICRSA(i));
+		fimc_write(ctx, 0, EXYNOS_CIIYSA(i));
+		fimc_write(ctx, 0, EXYNOS_CIICBSA(i));
+		fimc_write(ctx, 0, EXYNOS_CIICRSA(i));
 	}
 
 	for (i = 0; i < FIMC_MAX_DST; i++) {
-		fimc_write(0, EXYNOS_CIOYSA(i));
-		fimc_write(0, EXYNOS_CIOCBSA(i));
-		fimc_write(0, EXYNOS_CIOCRSA(i));
+		fimc_write(ctx, 0, EXYNOS_CIOYSA(i));
+		fimc_write(ctx, 0, EXYNOS_CIOCBSA(i));
+		fimc_write(ctx, 0, EXYNOS_CIOCRSA(i));
 	}
 }
 
@@ -1539,10 +1541,10 @@ static int fimc_ippdrv_start(struct device *dev, enum drm_exynos_ipp_cmd cmd)
 		fimc_handle_lastend(ctx, false);
 
 		/* setup dma */
-		cfg0 = fimc_read(EXYNOS_MSCTRL);
+		cfg0 = fimc_read(ctx, EXYNOS_MSCTRL);
 		cfg0 &= ~EXYNOS_MSCTRL_INPUT_MASK;
 		cfg0 |= EXYNOS_MSCTRL_INPUT_MEMORY;
-		fimc_write(cfg0, EXYNOS_MSCTRL);
+		fimc_write(ctx, cfg0, EXYNOS_MSCTRL);
 		break;
 	case IPP_CMD_WB:
 		fimc_set_type_ctrl(ctx, FIMC_WB_A);
@@ -1567,41 +1569,33 @@ static int fimc_ippdrv_start(struct device *dev, enum drm_exynos_ipp_cmd cmd)
 	}
 
 	/* Reset status */
-	fimc_write(0x0, EXYNOS_CISTATUS);
+	fimc_write(ctx, 0x0, EXYNOS_CISTATUS);
 
-	cfg0 = fimc_read(EXYNOS_CIIMGCPT);
+	cfg0 = fimc_read(ctx, EXYNOS_CIIMGCPT);
 	cfg0 &= ~EXYNOS_CIIMGCPT_IMGCPTEN_SC;
 	cfg0 |= EXYNOS_CIIMGCPT_IMGCPTEN_SC;
 
 	/* Scaler */
-	cfg1 = fimc_read(EXYNOS_CISCCTRL);
+	cfg1 = fimc_read(ctx, EXYNOS_CISCCTRL);
 	cfg1 &= ~EXYNOS_CISCCTRL_SCAN_MASK;
 	cfg1 |= (EXYNOS_CISCCTRL_PROGRESSIVE |
 		EXYNOS_CISCCTRL_SCALERSTART);
 
-	fimc_write(cfg1, EXYNOS_CISCCTRL);
+	fimc_write(ctx, cfg1, EXYNOS_CISCCTRL);
 
 	/* Enable image capture*/
 	cfg0 |= EXYNOS_CIIMGCPT_IMGCPTEN;
-	fimc_write(cfg0, EXYNOS_CIIMGCPT);
+	fimc_write(ctx, cfg0, EXYNOS_CIIMGCPT);
 
 	/* Disable frame end irq */
-	cfg0 = fimc_read(EXYNOS_CIGCTRL);
-	cfg0 &= ~EXYNOS_CIGCTRL_IRQ_END_DISABLE;
-	fimc_write(cfg0, EXYNOS_CIGCTRL);
+	fimc_clear_bits(ctx, EXYNOS_CIGCTRL, EXYNOS_CIGCTRL_IRQ_END_DISABLE);
 
-	cfg0 = fimc_read(EXYNOS_CIOCTRL);
-	cfg0 &= ~EXYNOS_CIOCTRL_WEAVE_MASK;
-	fimc_write(cfg0, EXYNOS_CIOCTRL);
+	fimc_clear_bits(ctx, EXYNOS_CIOCTRL, EXYNOS_CIOCTRL_WEAVE_MASK);
 
 	if (cmd == IPP_CMD_M2M) {
-		cfg0 = fimc_read(EXYNOS_MSCTRL);
-		cfg0 |= EXYNOS_MSCTRL_ENVID;
-		fimc_write(cfg0, EXYNOS_MSCTRL);
+		fimc_set_bits(ctx, EXYNOS_MSCTRL, EXYNOS_MSCTRL_ENVID);
 
-		cfg0 = fimc_read(EXYNOS_MSCTRL);
-		cfg0 |= EXYNOS_MSCTRL_ENVID;
-		fimc_write(cfg0, EXYNOS_MSCTRL);
+		fimc_set_bits(ctx, EXYNOS_MSCTRL, EXYNOS_MSCTRL_ENVID);
 	}
 
 	return 0;
@@ -1618,10 +1612,10 @@ static void fimc_ippdrv_stop(struct device *dev, enum drm_exynos_ipp_cmd cmd)
 	switch (cmd) {
 	case IPP_CMD_M2M:
 		/* Source clear */
-		cfg = fimc_read(EXYNOS_MSCTRL);
+		cfg = fimc_read(ctx, EXYNOS_MSCTRL);
 		cfg &= ~EXYNOS_MSCTRL_INPUT_MASK;
 		cfg &= ~EXYNOS_MSCTRL_ENVID;
-		fimc_write(cfg, EXYNOS_MSCTRL);
+		fimc_write(ctx, cfg, EXYNOS_MSCTRL);
 		break;
 	case IPP_CMD_WB:
 		exynos_drm_ippnb_send_event(IPP_SET_WRITEBACK, (void *)&set_wb);
@@ -1635,22 +1629,17 @@ static void fimc_ippdrv_stop(struct device *dev, enum drm_exynos_ipp_cmd cmd)
 	fimc_mask_irq(ctx, false);
 
 	/* reset sequence */
-	fimc_write(0x0, EXYNOS_CIFCNTSEQ);
+	fimc_write(ctx, 0x0, EXYNOS_CIFCNTSEQ);
 
 	/* Scaler disable */
-	cfg = fimc_read(EXYNOS_CISCCTRL);
-	cfg &= ~EXYNOS_CISCCTRL_SCALERSTART;
-	fimc_write(cfg, EXYNOS_CISCCTRL);
+	fimc_clear_bits(ctx, EXYNOS_CISCCTRL, EXYNOS_CISCCTRL_SCALERSTART);
 
 	/* Disable image capture */
-	cfg = fimc_read(EXYNOS_CIIMGCPT);
-	cfg &= ~(EXYNOS_CIIMGCPT_IMGCPTEN_SC | EXYNOS_CIIMGCPT_IMGCPTEN);
-	fimc_write(cfg, EXYNOS_CIIMGCPT);
+	fimc_clear_bits(ctx, EXYNOS_CIIMGCPT,
+		EXYNOS_CIIMGCPT_IMGCPTEN_SC | EXYNOS_CIIMGCPT_IMGCPTEN);
 
 	/* Enable frame end irq */
-	cfg = fimc_read(EXYNOS_CIGCTRL);
-	cfg |= EXYNOS_CIGCTRL_IRQ_END_DISABLE;
-	fimc_write(cfg, EXYNOS_CIGCTRL);
+	fimc_set_bits(ctx, EXYNOS_CIGCTRL, EXYNOS_CIGCTRL_IRQ_END_DISABLE);
 }
 
 static void fimc_put_clocks(struct fimc_context *ctx)
-- 
1.9.1

