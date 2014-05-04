Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaEDP0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:26:48 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41965 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaEDP0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:26:45 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@chromium.org, marcheu@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 3/4] drm/exynos/mixer: planes are not disabled by setting dma_addr to zero
Date: Sun,  4 May 2014 23:26:20 +0800
Message-Id: <1399217181-26442-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
References: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Planes are disabled by calling the win_mode_disable() callback, not by
calling win_mode_commit()[->vp_video_buffer] with dma_addr set to zero.

Thus, the comment in the pixel_format switch default clause is obsolete,
we should always check if the pixel_format is supported, and therefore,
since the driver does not actually supported single-buffer formats,
buf_num will always be 2, and we drop the broken 1-buffer case.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/exynos/exynos_mixer.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index 40cf39b..b252ec7 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -382,7 +382,6 @@ static void vp_video_buffer(struct mixer_context *ctx, int win)
 	unsigned long flags;
 	struct hdmi_win_data *win_data;
 	unsigned int x_ratio, y_ratio;
-	unsigned int buf_num = 1;
 	dma_addr_t luma_addr[2], chroma_addr[2];
 	bool tiled_mode = false;
 	bool crcb_mode = false;
@@ -393,16 +392,12 @@ static void vp_video_buffer(struct mixer_context *ctx, int win)
 	switch (win_data->pixel_format) {
 	case DRM_FORMAT_NV12MT:
 		tiled_mode = true;
+		/* fall through */
 	case DRM_FORMAT_NV12:
 		crcb_mode = false;
-		buf_num = 2;
 		break;
 	/* TODO: single buffer format NV12, NV21 */
 	default:
-		/* ignore pixel format at disable time */
-		if (!win_data->dma_addr)
-			break;
-
 		DRM_ERROR("pixel format for vp is wrong [%d].\n",
 				win_data->pixel_format);
 		return;
@@ -412,14 +407,8 @@ static void vp_video_buffer(struct mixer_context *ctx, int win)
 	x_ratio = (win_data->src_width << 16) / win_data->crtc_width;
 	y_ratio = (win_data->src_height << 16) / win_data->crtc_height;
 
-	if (buf_num == 2) {
-		luma_addr[0] = win_data->dma_addr;
-		chroma_addr[0] = win_data->chroma_dma_addr;
-	} else {
-		luma_addr[0] = win_data->dma_addr;
-		chroma_addr[0] = win_data->dma_addr
-			+ (win_data->fb_width * win_data->fb_height);
-	}
+	luma_addr[0] = win_data->dma_addr;
+	chroma_addr[0] = win_data->chroma_dma_addr;
 
 	if (win_data->scan_flags & DRM_MODE_FLAG_INTERLACE) {
 		ctx->interlace = true;
-- 
1.9.1.423.g4596e3a

