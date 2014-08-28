Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965811AbaH1JJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:09:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11839 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965642AbaH1JIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:30 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e8-53fef18c3001
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
Subject: [PATCH v2 14/17] drm/exynos/fimc: simplify buffer queuing
Date: Thu, 28 Aug 2014 11:07:38 +0200
Message-id: <1409216861-12452-15-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7o9H/8FG2yZK2dxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXR13aXveCqZMW6HSeYGxgbRLsYOTkkBEwkeh6dZIGwxSQu3FvP
	1sXIxSEksJRR4u7J96wQTh+TxLt9M9lAqtgENCX+br4JZosIKEus2tfODlLELPCRSeLK0jfM
	IAlhASeJrQ872UFsFgFViZ3X/4A18Aq4SDz9u44ZYp2cxMljk1lBbE6g+Mbjb8DqhQScJXaf
	/8w0gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQwPq6g3HpMatDjAIcjEo8vAqn
	/wQLsSaWFVfmHmKU4GBWEuE9evxfsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGK2ct67aWNxoc
	PaB96Z8326xlq/jk3rYsYu1ltZYTm3dDOzjr3fUpb1lim1dwR68722xvyLL9YDzbmrtuk37K
	vZilsnPrxCMcG054HvAr23I1f+na7JDpPupBZ3s2CX1m/8Eaa7Yw6+ay4lsnN+eKv93Xvlrp
	3g0DVs3YJn+Dmf4+a/siK3nmKLEUZyQaajEXFScCAJxyNxAKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes redundant checks, redundant HW reads
and simplifies code.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
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

