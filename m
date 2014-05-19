Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaESK4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:56:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25820 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbaESKyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:37 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-8a-5379e2eab929
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
Subject: [PATCH 4/8] drm/exynos/fimc: simplify pre-scaler ratio calculation
Date: Mon, 19 May 2014 12:54:06 +0200
Message-id: <1400496850-23860-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
References: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7qvHlUGG6z+omdxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWxsLOJpeC8VMWGLc0sDYynRbsYOTkkBEwkHl36yQhhi0lcuLee
	rYuRi0NIYCmjxI47v5kgnD4miQeLdjKBVLEJaEr83XyTDcQWEdCRuN7TzQxSxCzwjEnizt11
	7CAJYQFviVWnbrF0MXJwsAioSsz5mAgS5hVwlpiycjkLxDY5iZPHJrOC2JwCLhInji0Hs4WA
	ah7vOso+gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQsPq6g3HpMatDjAIcjEo8
	vD/SK4OFWBPLiitzDzFKcDArifBuuwEU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwFhwb9k52b73
	szgFt//nXt9yoXJuwLL+Mwkt3h/lXr8sWMGQFRZyfgHTq4NOQspZ7Svv+2g6PRF3iJ8zOzMl
	/JuI2W2pKdsj/c7tb5OeMdeKiU1Gt/mFlffynheSIkrn8lgm5a022XC83Ok9f0SVeBhTuJb+
	/FNCwh03vy+POB1RvF8vTG6LvxJLcUaioRZzUXEiAGLKyxYJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces dedicated function for scaling ratio
calculation by fls calls.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 56 ++++++++------------------------
 1 file changed, 13 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 5060f8a..d40b7fb 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -957,43 +957,13 @@ static int fimc_dst_set_transf(struct device *dev,
 	return 0;
 }
 
-static int fimc_get_ratio_shift(u32 src, u32 dst, u32 *ratio, u32 *shift)
-{
-	DRM_DEBUG_KMS("src[%d]dst[%d]\n", src, dst);
-
-	if (src >= dst * 64) {
-		DRM_ERROR("failed to make ratio and shift.\n");
-		return -EINVAL;
-	} else if (src >= dst * 32) {
-		*ratio = 32;
-		*shift = 5;
-	} else if (src >= dst * 16) {
-		*ratio = 16;
-		*shift = 4;
-	} else if (src >= dst * 8) {
-		*ratio = 8;
-		*shift = 3;
-	} else if (src >= dst * 4) {
-		*ratio = 4;
-		*shift = 2;
-	} else if (src >= dst * 2) {
-		*ratio = 2;
-		*shift = 1;
-	} else {
-		*ratio = 1;
-		*shift = 0;
-	}
-
-	return 0;
-}
-
 static int fimc_set_prescaler(struct fimc_context *ctx, struct fimc_scaler *sc,
 		struct drm_exynos_pos *src, struct drm_exynos_pos *dst)
 {
 	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
 	u32 cfg, cfg_ext, shfactor;
 	u32 pre_dst_width, pre_dst_height;
-	u32 pre_hratio, hfactor, pre_vratio, vfactor;
+	u32 hfactor, vfactor;
 	int ret = 0;
 	u32 src_w, src_h, dst_w, dst_h;
 
@@ -1014,24 +984,24 @@ static int fimc_set_prescaler(struct fimc_context *ctx, struct fimc_scaler *sc,
 		dst_h = dst->h;
 	}
 
-	ret = fimc_get_ratio_shift(src_w, dst_w, &pre_hratio, &hfactor);
-	if (ret) {
+	/* fimc_ippdrv_check_property assures that dividers are not null */
+	hfactor = fls(src_w / dst_w / 2);
+	if (hfactor > FIMC_SHFACTOR / 2) {
 		dev_err(ippdrv->dev, "failed to get ratio horizontal.\n");
-		return ret;
+		return -EINVAL;
 	}
 
-	ret = fimc_get_ratio_shift(src_h, dst_h, &pre_vratio, &vfactor);
-	if (ret) {
+	vfactor = fls(src_h / dst_h / 2);
+	if (vfactor > FIMC_SHFACTOR / 2) {
 		dev_err(ippdrv->dev, "failed to get ratio vertical.\n");
-		return ret;
+		return -EINVAL;
 	}
 
-	pre_dst_width = src_w / pre_hratio;
-	pre_dst_height = src_h / pre_vratio;
+	pre_dst_width = src_w >> hfactor;
+	pre_dst_height = src_h >> vfactor;
 	DRM_DEBUG_KMS("pre_dst_width[%d]pre_dst_height[%d]\n",
 		pre_dst_width, pre_dst_height);
-	DRM_DEBUG_KMS("pre_hratio[%d]hfactor[%d]pre_vratio[%d]vfactor[%d]\n",
-		pre_hratio, hfactor, pre_vratio, vfactor);
+	DRM_DEBUG_KMS("hfactor[%d]vfactor[%d]\n", hfactor, vfactor);
 
 	sc->hratio = (src_w << 14) / (dst_w << hfactor);
 	sc->vratio = (src_h << 14) / (dst_h << vfactor);
@@ -1044,8 +1014,8 @@ static int fimc_set_prescaler(struct fimc_context *ctx, struct fimc_scaler *sc,
 	DRM_DEBUG_KMS("shfactor[%d]\n", shfactor);
 
 	cfg = (EXYNOS_CISCPRERATIO_SHFACTOR(shfactor) |
-		EXYNOS_CISCPRERATIO_PREHORRATIO(pre_hratio) |
-		EXYNOS_CISCPRERATIO_PREVERRATIO(pre_vratio));
+		EXYNOS_CISCPRERATIO_PREHORRATIO(1 << hfactor) |
+		EXYNOS_CISCPRERATIO_PREVERRATIO(1 << vfactor));
 	fimc_write(cfg, EXYNOS_CISCPRERATIO);
 
 	cfg = (EXYNOS_CISCPREDST_PREDSTWIDTH(pre_dst_width) |
-- 
1.9.1

