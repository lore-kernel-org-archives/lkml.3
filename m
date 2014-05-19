Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaESKyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:54:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25825 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbaESKyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:44 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-a8-5379e2f1e526
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
Subject: [PATCH 8/8] drm/exynos/fimc: simplify and rename fimc_dst_get_buf_seq
Date: Mon, 19 May 2014 12:54:10 +0200
Message-id: <1400496850-23860-9-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
References: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7ofH1UGG5w8KmBxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWx/PEc9oImvooZUycwNjAe5u5i5OSQEDCRONVwjwXCFpO4cG89
	WxcjF4eQwFJGiWs3VzNDOH1MEvsObWUCqWIT0JT4u/kmG4gtIqAjcb2nG6yIWeAZk8Sdu+vY
	QRLCAn4SG+8/Yuxi5OBgEVCVOLAsDSTMK+AssWn+AjaIbXISJ49NZgWxOQVcJE4cWw5mCwHV
	PN51lH0CI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFh9XUH49JjVocYBTgYlXh4
	f6RXBguxJpYVV+YeYpTgYFYS4d12AyjEm5JYWZValB9fVJqTWnyIkYmDU6qBcVrFl6rfNwTc
	9q4wdrpX8rLaUkJ9L+ODlgvdmr+YeliTjkStP7rx+j77suT+izlTnV8wnF/5d/J8+8zJJeVT
	2oM8XunyR+htb5wxWUs3c+a82eq3IhLnZjJ+aHty+vGC8GT7FjObS8G5Pas1676V95utiyq5
	ma/Je85+TdTciFOfziWLLGp3UGIpzkg01GIuKk4EAJiFEjgJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fimc_dst_get_buf_seq returns number of buffers
so the name should be fimc_dst_get_buf_count.
Function body has been simplified.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 9860d38..831dde9 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -58,7 +58,6 @@
 #define FIMC_SHFACTOR	10
 #define FIMC_BUF_STOP	1
 #define FIMC_BUF_START	2
-#define FIMC_REG_SZ		32
 #define FIMC_WIDTH_ITU_709	1280
 #define FIMC_REFRESH_MAX	60
 #define FIMC_REFRESH_MIN	12
@@ -1123,16 +1122,13 @@ static int fimc_dst_set_size(struct device *dev, int swap,
 	return 0;
 }
 
-static int fimc_dst_get_buf_seq(struct fimc_context *ctx)
+static int fimc_dst_get_buf_count(struct fimc_context *ctx)
 {
-	u32 cfg, i, buf_num = 0;
-	u32 mask = 0x00000001;
+	u32 cfg, buf_num;
 
 	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
 
-	for (i = 0; i < FIMC_REG_SZ; i++)
-		if (cfg & (mask << i))
-			buf_num++;
+	buf_num = hweight32(cfg);
 
 	DRM_DEBUG_KMS("buf_num[%d]\n", buf_num);
 
@@ -1176,12 +1172,12 @@ static int fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
 
 	/* interrupt enable */
 	if (buf_type == IPP_BUF_ENQUEUE &&
-	    fimc_dst_get_buf_seq(ctx) >= FIMC_BUF_START)
+	    fimc_dst_get_buf_count(ctx) >= FIMC_BUF_START)
 		fimc_mask_irq(ctx, true);
 
 	/* interrupt disable */
 	if (buf_type == IPP_BUF_DEQUEUE &&
-	    fimc_dst_get_buf_seq(ctx) <= FIMC_BUF_STOP)
+	    fimc_dst_get_buf_count(ctx) <= FIMC_BUF_STOP)
 		fimc_mask_irq(ctx, false);
 
 err_unlock:
-- 
1.9.1

