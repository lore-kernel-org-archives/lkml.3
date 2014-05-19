Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaESKyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:54:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37987 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaESKyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:35 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-85-5379e2e81c80
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
Subject: [PATCH 3/8] drm/exynos/ipp: simplify property list allocation
Date: Mon, 19 May 2014 12:54:05 +0200
Message-id: <1400496850-23860-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
References: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7ovHlUGG+xpNrK4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mr4dO4ya8FprYq7R6exNzCuU+li5OCQEDCRONNQ2sXICWSKSVy4
	t56ti5GLQ0hgKaNE/75rjBBOH5PElBd7WECq2AQ0Jf5uvskGYosI6Ehc7+lmBiliFnjGJHHn
	7jp2kISwgJtES0sbM4jNIqAq0dA/FayZV8BZ4v/NdSwQ6+QkTh6bzApicwq4SJw4thzMFgKq
	ebzrKPsERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MULC6usOxqXHrA4xCnAwKvHw
	/kivDBZiTSwrrsw9xCjBwawkwrvtBlCINyWxsiq1KD++qDQntfgQIxMHp1QDo+ytJ49yf93k
	tFoplT3x5z6p/wLbotYvWD5nnsfp0P+n5gmJH+ZNUVY+uSs3XvXUpdzbeYwaEqtvzuX4GS2+
	aMbzR5l+JwIDClQXz50nkWHJcZ77GivTR6Hj17l/3Cub+YGVN/Mqg0xjTrL0/Q2fytc9tjb7
	EN4zsfbljUXf9bKfKN9danAj8osSS3FGoqEWc1FxIgCZmqJXCQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prop_list is always allocated, so instead of allocating it dynamically
the pointer can be replaced by the structure itself.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 10 ++--------
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     | 10 ++--------
 drivers/gpu/drm/exynos/exynos_drm_ipp.c     |  4 ++--
 drivers/gpu/drm/exynos/exynos_drm_ipp.h     |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c |  8 +-------
 5 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 30d76b2..5060f8a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1342,11 +1342,7 @@ static irqreturn_t fimc_irq_handler(int irq, void *dev_id)
 
 static int fimc_init_prop_list(struct exynos_drm_ippdrv *ippdrv)
 {
-	struct drm_exynos_ipp_prop_list *prop_list;
-
-	prop_list = devm_kzalloc(ippdrv->dev, sizeof(*prop_list), GFP_KERNEL);
-	if (!prop_list)
-		return -ENOMEM;
+	struct drm_exynos_ipp_prop_list *prop_list = &ippdrv->prop_list;
 
 	prop_list->version = 1;
 	prop_list->writeback = 1;
@@ -1371,8 +1367,6 @@ static int fimc_init_prop_list(struct exynos_drm_ippdrv *ippdrv)
 	prop_list->scale_min.hsize = FIMC_SCALE_MIN;
 	prop_list->scale_min.vsize = FIMC_SCALE_MIN;
 
-	ippdrv->prop_list = prop_list;
-
 	return 0;
 }
 
@@ -1395,7 +1389,7 @@ static int fimc_ippdrv_check_property(struct device *dev,
 {
 	struct fimc_context *ctx = get_fimc_context(dev);
 	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
-	struct drm_exynos_ipp_prop_list *pp = ippdrv->prop_list;
+	struct drm_exynos_ipp_prop_list *pp = &ippdrv->prop_list;
 	struct drm_exynos_ipp_config *config;
 	struct drm_exynos_pos *pos;
 	struct drm_exynos_sz *sz;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index fa75059..9e3ff16 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1335,11 +1335,7 @@ static irqreturn_t gsc_irq_handler(int irq, void *dev_id)
 
 static int gsc_init_prop_list(struct exynos_drm_ippdrv *ippdrv)
 {
-	struct drm_exynos_ipp_prop_list *prop_list;
-
-	prop_list = devm_kzalloc(ippdrv->dev, sizeof(*prop_list), GFP_KERNEL);
-	if (!prop_list)
-		return -ENOMEM;
+	struct drm_exynos_ipp_prop_list *prop_list = &ippdrv->prop_list;
 
 	prop_list->version = 1;
 	prop_list->writeback = 1;
@@ -1363,8 +1359,6 @@ static int gsc_init_prop_list(struct exynos_drm_ippdrv *ippdrv)
 	prop_list->scale_min.hsize = GSC_SCALE_MIN;
 	prop_list->scale_min.vsize = GSC_SCALE_MIN;
 
-	ippdrv->prop_list = prop_list;
-
 	return 0;
 }
 
@@ -1387,7 +1381,7 @@ static int gsc_ippdrv_check_property(struct device *dev,
 {
 	struct gsc_context *ctx = get_gsc_context(dev);
 	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
-	struct drm_exynos_ipp_prop_list *pp = ippdrv->prop_list;
+	struct drm_exynos_ipp_prop_list *pp = &ippdrv->prop_list;
 	struct drm_exynos_ipp_config *config;
 	struct drm_exynos_pos *pos;
 	struct drm_exynos_sz *sz;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index e6ef415..bf71d97 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -346,7 +346,7 @@ int exynos_drm_ipp_get_property(struct drm_device *drm_dev, void *data,
 			return PTR_ERR(ippdrv);
 		}
 
-		*prop_list = *ippdrv->prop_list;
+		*prop_list = ippdrv->prop_list;
 	}
 
 	return 0;
@@ -1713,7 +1713,7 @@ static int ipp_subdrv_probe(struct drm_device *drm_dev, struct device *dev)
 		DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]ipp_id[%d]\n",
 			count++, (int)ippdrv, ipp_id);
 
-		ippdrv->prop_list->ipp_id = ipp_id;
+		ippdrv->prop_list.ipp_id = ipp_id;
 
 		/* store parent device for node */
 		ippdrv->parent_dev = dev;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index 4aa71b2..eea4db3 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -165,7 +165,7 @@ struct exynos_drm_ippdrv {
 	struct workqueue_struct	*event_workq;
 	struct drm_exynos_ipp_cmd_node *c_node;
 	struct list_head	cmd_list;
-	struct drm_exynos_ipp_prop_list *prop_list;
+	struct drm_exynos_ipp_prop_list prop_list;
 
 	int (*check_property)(struct device *dev,
 		struct drm_exynos_ipp_property *property);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_rotator.c b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
index c675427..f01fbb6 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_rotator.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
@@ -470,11 +470,7 @@ static struct exynos_drm_ipp_ops rot_dst_ops = {
 
 static int rotator_init_prop_list(struct exynos_drm_ippdrv *ippdrv)
 {
-	struct drm_exynos_ipp_prop_list *prop_list;
-
-	prop_list = devm_kzalloc(ippdrv->dev, sizeof(*prop_list), GFP_KERNEL);
-	if (!prop_list)
-		return -ENOMEM;
+	struct drm_exynos_ipp_prop_list *prop_list = &ippdrv->prop_list;
 
 	prop_list->version = 1;
 	prop_list->flip = (1 << EXYNOS_DRM_FLIP_VERTICAL) |
@@ -487,8 +483,6 @@ static int rotator_init_prop_list(struct exynos_drm_ippdrv *ippdrv)
 	prop_list->crop = 0;
 	prop_list->scale = 0;
 
-	ippdrv->prop_list = prop_list;
-
 	return 0;
 }
 
-- 
1.9.1

