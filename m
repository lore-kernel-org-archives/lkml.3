Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaESKyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:54:46 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31656 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbaESKyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:43 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-94-5379e2ec5420
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
Subject: [PATCH 5/8] drm/exynos/fimc: simplify irq masking function
Date: Mon, 19 May 2014 12:54:07 +0200
Message-id: <1400496850-23860-6-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
References: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7pvHlUGG0yZLGVxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXx+Mdc1oJ7IhXrXl9kb2CcL9jFyMkhIWAisfX1OVYIW0ziwr31
	bF2MXBxCAksZJW5872aBcPqYJK6t7WUDqWIT0JT4u/kmmC0ioCNxvaebGaSIWeAZk8Sdu+vY
	QRLCAs4Sy1d8Byri4GARUJXY8dMEJMwLFG6ffZ0ZYpucxMljk8E2cwq4SJw4thzMFgKqebzr
	KPsERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MULC6usOxqXHrA4xCnAwKvHw/kiv
	DBZiTSwrrsw9xCjBwawkwrvtBlCINyWxsiq1KD++qDQntfgQIxMHp1QDo0XpX4Z5WVGVm+X6
	d+xszv5r2+UTweHCkRZ05Mzm3SG7D374v6LnDOPCLb/XJ5t5s/qm/jp+/7Yl45PLLKVcn5aq
	KNjNSt30OfT5jj8CDFGCYYsqf2Rsk7iV19Z8rc5E6Of2x+nze6qfWf5cud+6QUdj2gvmLu3p
	eZfUz56dN8uiY6qaws+fv5VYijMSDbWYi4oTATLmBPgJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name fimc_handle_irq suggests it is irq handler, but the function
is for irq mask configuration. The patch renames the function to
fimc_mask_irq and removes unused arguments.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index d40b7fb..409775f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -290,25 +290,18 @@ static void fimc_handle_jpeg(struct fimc_context *ctx, bool enable)
 	fimc_write(cfg, EXYNOS_CIGCTRL);
 }
 
-static void fimc_handle_irq(struct fimc_context *ctx, bool enable,
-		bool overflow, bool level)
+static void fimc_mask_irq(struct fimc_context *ctx, bool enable)
 {
 	u32 cfg;
 
-	DRM_DEBUG_KMS("enable[%d]overflow[%d]level[%d]\n",
-			enable, overflow, level);
+	DRM_DEBUG_KMS("enable[%d]\n", enable);
 
 	cfg = fimc_read(EXYNOS_CIGCTRL);
 	if (enable) {
-		cfg &= ~(EXYNOS_CIGCTRL_IRQ_OVFEN | EXYNOS_CIGCTRL_IRQ_LEVEL);
-		cfg |= EXYNOS_CIGCTRL_IRQ_ENABLE;
-		if (overflow)
-			cfg |= EXYNOS_CIGCTRL_IRQ_OVFEN;
-		if (level)
-			cfg |= EXYNOS_CIGCTRL_IRQ_LEVEL;
+		cfg &= ~EXYNOS_CIGCTRL_IRQ_OVFEN;
+		cfg |= EXYNOS_CIGCTRL_IRQ_ENABLE | EXYNOS_CIGCTRL_IRQ_LEVEL;
 	} else
-		cfg &= ~(EXYNOS_CIGCTRL_IRQ_OVFEN | EXYNOS_CIGCTRL_IRQ_ENABLE);
-
+		cfg &= ~EXYNOS_CIGCTRL_IRQ_ENABLE;
 	fimc_write(cfg, EXYNOS_CIGCTRL);
 }
 
@@ -1180,12 +1173,12 @@ static int fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
 	/* interrupt enable */
 	if (buf_type == IPP_BUF_ENQUEUE &&
 	    fimc_dst_get_buf_seq(ctx) >= FIMC_BUF_START)
-		fimc_handle_irq(ctx, true, false, true);
+		fimc_mask_irq(ctx, true);
 
 	/* interrupt disable */
 	if (buf_type == IPP_BUF_DEQUEUE &&
 	    fimc_dst_get_buf_seq(ctx) <= FIMC_BUF_STOP)
-		fimc_handle_irq(ctx, false, false, true);
+		fimc_mask_irq(ctx, false);
 
 err_unlock:
 	mutex_unlock(&ctx->lock);
@@ -1520,7 +1513,7 @@ static int fimc_ippdrv_start(struct device *dev, enum drm_exynos_ipp_cmd cmd)
 
 	property = &c_node->property;
 
-	fimc_handle_irq(ctx, true, false, true);
+	fimc_mask_irq(ctx, true);
 
 	for_each_ipp_ops(i) {
 		config = &property->config[i];
@@ -1639,7 +1632,7 @@ static void fimc_ippdrv_stop(struct device *dev, enum drm_exynos_ipp_cmd cmd)
 		break;
 	}
 
-	fimc_handle_irq(ctx, false, false, true);
+	fimc_mask_irq(ctx, false);
 
 	/* reset sequence */
 	fimc_write(0x0, EXYNOS_CIFCNTSEQ);
-- 
1.9.1

