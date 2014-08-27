Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaH0LHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:07:21 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11183 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbaH0LHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:07:19 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-4d-53fdbbe3616f
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
Subject: [PATCH v2 14/15] drm/exynos/fimc: simplify buffer queuing
Date: Wed, 27 Aug 2014 13:07:03 +0200
Message-id: <1409137623-20936-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-15-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-15-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xK7qPd/8NNri2zsri1rpzrBZXvr5n
	s5h0fwKLxYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHTo/73ceZPPq2rGL0+LxJ
	LoA5issmJTUnsyy1SN8ugSujq62bvWCeZMXpXy9ZGhjPiXQxcnBICJhI3JjD38XICWSKSVy4
	t54NxBYSWMoo8fJfVRcjF5DdxyTxurOLHSTBJqAp8XfzTbAiEQFliVX72tlBipgFPjJJXFn6
	hhkkISzgJDF9wVmwBhYBVYmp99eygti8As4SP6dPYoHYJidx8thksDingKvEsT/H2SE2u0g8
	XLSMeQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIUH1ZQfj4mNWhxgFOBiVeHgZ
	1v8JFmJNLCuuzD3EKMHBrCTCy779b7AQb0piZVVqUX58UWlOavEhRiYOTqkGRrsdrr5i1SE1
	rfx3a1yWMTvoZubcMDtlqbhLf1aBxk6GWE6HRc7ustLfT77o387KIR4Vu3S29eUYpbBHOc8q
	c3/vcVy7KvS36oz+wFvns4/ekfii6H8paP4UucbsfZmnmR5FbUs4I7dom8gz+RT3NcV2dV+e
	Ze9izjj/p9yk8v1242fXdmaVK7EUZyQaajEXFScCABVIiREIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes redundant checks, redundant HW reads
and simplifies code.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
v2:
- fixed bit cleaning operation
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 64 ++++++++------------------------
 1 file changed, 15 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 62ba033..59ba8bb 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1126,67 +1126,34 @@ static int fimc_dst_set_size(struct device *dev, int swap,
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
+		cfg &= ~(1 << buf_id);
 
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
@@ -1244,7 +1211,9 @@ static int fimc_dst_set_addr(struct device *dev,
 		break;
 	}
 
-	return fimc_dst_set_buf_seq(ctx, buf_id, buf_type);
+	fimc_dst_set_buf_seq(ctx, buf_id, buf_type);
+
+	return 0;
 }
 
 static struct exynos_drm_ipp_ops fimc_dst_ops = {
@@ -1299,10 +1268,7 @@ static irqreturn_t fimc_irq_handler(int irq, void *dev_id)
 
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

