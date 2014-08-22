Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaHVHxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:54 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49676 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbaHVHxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:52 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-76-53f6f70e8c95
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH 14/15] drm/exynos/fimc: simplify buffer queuing
Date: Fri, 22 Aug 2014 09:52:25 +0200
Message-id: <1408693946-15456-15-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xq7p8378FG/y7p2pxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXRs+0zc8FniYqpb6YzNzCuFeli5OSQEDCR+Dy1iRHCFpO4cG89
	WxcjF4eQwFJGicl3nzFDOH1MElMuzGcBqWIT0JT4u/kmG4gtIqAssWpfOztIEbPARyaJK0vf
	MIMkhAXsJU6dvgvWwCKgKnH54GKgIg4OXgEXiWmdPhDb5CROHpvMCmJzAoUvHJwG1iok4CzR
	dXsa0wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQsLqyw7GxcesDjEKcDAq8fAm
	/v4aLMSaWFZcmXuIUYKDWUmEd9O8b8FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGHmc4qfcnVH8
	2mCLcWX7j7u8Jt5dX1fGfrh6WTG57xfLL0PxWz+ra1iffvgv7vFdWqKU484P5ZPZYtPXvumf
	WTHlyTKbiXeOZu9xCeFI5H3IoyCsUrta/or5ku078l6rNy2M9w+unO269ZXpz7Q9gZP2LXFf
	JsSzLGznoqscZ8qFEn7nqjtnbFBiKc5INNRiLipOBAD7/5iqCQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes redundant checks, redundant HW reads
and simplifies code.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 64 ++++++++------------------------
 1 file changed, 15 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index bd6628d..b20078e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1124,67 +1124,34 @@ static int fimc_dst_set_size(struct device *dev, int swap,
 	return 0;
 }
 
-static int fimc_dst_get_buf_count(struct fimc_context *ctx)
-{
-	u32 cfg, buf_num;
-
-	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
-
-	buf_num = hweight32(cfg);
-
-	DRM_DEBUG_KMS("buf_num[%d]\n", buf_num);
-
-	return buf_num;
-}
-
-static int fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
+static void fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
 		enum drm_exynos_ipp_buf_type buf_type)
 {
-	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
-	bool enable;
-	u32 cfg;
-	u32 mask = 0x00000001 << buf_id;
-	int ret = 0;
 	unsigned long flags;
+	u32 buf_num;
+	u32 cfg;
 
 	DRM_DEBUG_KMS("buf_id[%d]buf_type[%d]\n", buf_id, buf_type);
 
 	spin_lock_irqsave(&ctx->lock, flags);
 
-	/* mask register set */
 	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
 
-	switch (buf_type) {
-	case IPP_BUF_ENQUEUE:
-		enable = true;
-		break;
-	case IPP_BUF_DEQUEUE:
-		enable = false;
-		break;
-	default:
-		dev_err(ippdrv->dev, "invalid buf ctrl parameter.\n");
-		ret =  -EINVAL;
-		goto err_unlock;
-	}
+	if (buf_type == IPP_BUF_ENQUEUE)
+		cfg |= (1 << buf_id);
+	else
+		cfg &= (1 << buf_id);
 
-	/* sequence id */
-	cfg &= ~mask;
-	cfg |= (enable << buf_id);
 	fimc_write(ctx, cfg, EXYNOS_CIFCNTSEQ);
 
-	/* interrupt enable */
-	if (buf_type == IPP_BUF_ENQUEUE &&
-	    fimc_dst_get_buf_count(ctx) >= FIMC_BUF_START)
-		fimc_mask_irq(ctx, true);
+	buf_num = hweight32(cfg);
 
-	/* interrupt disable */
-	if (buf_type == IPP_BUF_DEQUEUE &&
-	    fimc_dst_get_buf_count(ctx) <= FIMC_BUF_STOP)
+	if (buf_type == IPP_BUF_ENQUEUE && buf_num >= FIMC_BUF_START)
+		fimc_mask_irq(ctx, true);
+	else if (buf_type == IPP_BUF_DEQUEUE && buf_num <= FIMC_BUF_STOP)
 		fimc_mask_irq(ctx, false);
 
-err_unlock:
 	spin_unlock_irqrestore(&ctx->lock, flags);
-	return ret;
 }
 
 static int fimc_dst_set_addr(struct device *dev,
@@ -1242,7 +1209,9 @@ static int fimc_dst_set_addr(struct device *dev,
 		break;
 	}
 
-	return fimc_dst_set_buf_seq(ctx, buf_id, buf_type);
+	fimc_dst_set_buf_seq(ctx, buf_id, buf_type);
+
+	return 0;
 }
 
 static struct exynos_drm_ipp_ops fimc_dst_ops = {
@@ -1297,10 +1266,7 @@ static irqreturn_t fimc_irq_handler(int irq, void *dev_id)
 
 	DRM_DEBUG_KMS("buf_id[%d]\n", buf_id);
 
-	if (fimc_dst_set_buf_seq(ctx, buf_id, IPP_BUF_DEQUEUE) < 0) {
-		DRM_ERROR("failed to dequeue.\n");
-		return IRQ_HANDLED;
-	}
+	fimc_dst_set_buf_seq(ctx, buf_id, IPP_BUF_DEQUEUE);
 
 	event_work->ippdrv = ippdrv;
 	event_work->buf_id[EXYNOS_DRM_OPS_DST] = buf_id;
-- 
1.9.1

