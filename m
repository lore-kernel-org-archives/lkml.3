Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaESKys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:54:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25825 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbaESKyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:43 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-7a-5379e2ef3f81
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
Subject: [PATCH 7/8] drm/exynos/fimc: replace mutex by spinlock
Date: Mon, 19 May 2014 12:54:09 +0200
Message-id: <1400496850-23860-8-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
References: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xy7rvH1UGG9z6pGZxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXRuW8za8F1gYqbv1wbGP/wdjFyckgImEiceHOEDcIWk7hwbz2Y
	LSSwlFFi09RMCLuPSWL2KQMQm01AU+Lv5ptgNSICOhLXe7qZuxi5OJgFnjFJ3Lm7jh0kISxg
	L3Hr3n6wIhYBVYnHdx+ygNi8As4SHzumMkMsk5M4eWwyK4jNKeAiceLYclaIZc4Sj3cdZZ/A
	yLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkhIfdnBuPiY1SFGAQ5GJR7eDwmVwUKs
	iWXFlbmHGCU4mJVEeLfdAArxpiRWVqUW5ccXleakFh9iZOLglGpgrLrQH7j/OnOQl1AVm55+
	FfeTC79CODZvalx7hXl3pdQOnTf2freP/tym6vnC7w4nb1T/u7N1WhvOFVg+b7d8tWpV67bZ
	L6dfn6Prc+1VwOtrsivT+orPTJ0g6Hhqmf+F7q3vLqkpVSpu2hIo9G7bnH/zb4Y9ri10mHZr
	4uQrF+9JCl9u32B6qkeJpTgj0VCLuag4EQBXxmaeBwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function fimc_dst_set_buf_seq is called by irq handler
so it should not use mutexes. This patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 7a66f18..9860d38 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -18,6 +18,7 @@
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
+#include <linux/spinlock.h>
 
 #include <drm/drmP.h>
 #include <drm/exynos_drm.h>
@@ -158,7 +159,7 @@ struct fimc_context {
 	struct exynos_drm_ippdrv	ippdrv;
 	struct resource	*regs_res;
 	void __iomem	*regs;
-	struct mutex	lock;
+	spinlock_t	lock;
 	struct clk	*clocks[FIMC_CLKS_MAX];
 	u32		clk_frequency;
 	struct regmap	*sysreg;
@@ -1146,10 +1147,11 @@ static int fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
 	u32 cfg;
 	u32 mask = 0x00000001 << buf_id;
 	int ret = 0;
+	unsigned long flags;
 
 	DRM_DEBUG_KMS("buf_id[%d]buf_type[%d]\n", buf_id, buf_type);
 
-	mutex_lock(&ctx->lock);
+	spin_lock_irqsave(&ctx->lock, flags);
 
 	/* mask register set */
 	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
@@ -1183,7 +1185,7 @@ static int fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
 		fimc_mask_irq(ctx, false);
 
 err_unlock:
-	mutex_unlock(&ctx->lock);
+	spin_unlock_irqrestore(&ctx->lock, flags);
 	return ret;
 }
 
@@ -1794,7 +1796,7 @@ static int fimc_probe(struct platform_device *pdev)
 
 	DRM_DEBUG_KMS("id[%d]ippdrv[0x%x]\n", ctx->id, (int)ippdrv);
 
-	mutex_init(&ctx->lock);
+	spin_lock_init(&ctx->lock);
 	platform_set_drvdata(pdev, ctx);
 
 	pm_runtime_set_active(dev);
@@ -1825,7 +1827,6 @@ static int fimc_remove(struct platform_device *pdev)
 	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
 
 	exynos_drm_ippdrv_unregister(ippdrv);
-	mutex_destroy(&ctx->lock);
 
 	fimc_put_clocks(ctx);
 	pm_runtime_set_suspended(dev);
-- 
1.9.1

