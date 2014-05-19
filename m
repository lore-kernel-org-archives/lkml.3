Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaESKyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:54:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26086 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaESKyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:33 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-50-5379e2e63e28
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
Subject: [PATCH 2/8] drm/exynos/ipp: correct ipp_id field initialization
Date: Mon, 19 May 2014 12:54:04 +0200
Message-id: <1400496850-23860-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
References: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7rPHlUGG0z+pG1xa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWxbcFkloJ/fBU9H2+yNTBu4eli5OSQEDCR2LP0JyOELSZx4d56
	ti5GLg4hgaWMEi/PPGKCcPqYJLbd2MQOUsUmoCnxd/NNNhBbREBH4npPNzNIEbPAMyaJO3fX
	gRUJC3hIHNg6gRXEZhFQlbixeANYnFfAWeJQ9zlmiHVyEiePTQar4RRwkThxbDmYLQRU83jX
	UfYJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoQE1pcdjIuPWR1iFOBgVOLh/ZBQ
	GSzEmlhWXJl7iFGCg1lJhHfbDaAQb0piZVVqUX58UWlOavEhRiYOTqkGxkzT53eqjN8fC2Lh
	iZm50vpZ36HlLrJ5jW9/zO/03FvN67Jzmyn3/ZaHZfqXHRlkFp/YsTMmspjjyI6ortxF3+Y0
	irs8536emb/6wY7+5Tb6U/5bOqq+Fvz/PNn5fnF9AWfWnqe/hP9Znbc/9D1rrm+M8prg60sD
	sxbujhbK3HnXXC0gvE4wTImlOCPRUIu5qDgRAOY+wUYKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prop_list.ipp_id field is not initialized properly.
The patch fixes it, additionally it removes redundant field from ippdrv.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 14 ++++++--------
 drivers/gpu/drm/exynos/exynos_drm_ipp.h |  1 -
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 5aaf21f..e6ef415 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1699,23 +1699,21 @@ static int ipp_subdrv_probe(struct drm_device *drm_dev, struct device *dev)
 
 	/* get ipp driver entry */
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
+		u32 ipp_id;
+
 		ippdrv->drm_dev = drm_dev;
 
 		ret = ipp_create_id(&ctx->ipp_idr, &ctx->ipp_lock, ippdrv,
-			&ippdrv->ipp_id);
-		if (ret) {
+				    &ipp_id);
+		if (ret || ipp_id == 0) {
 			DRM_ERROR("failed to create id.\n");
 			goto err_idr;
 		}
 
 		DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]ipp_id[%d]\n",
-			count++, (int)ippdrv, ippdrv->ipp_id);
+			count++, (int)ippdrv, ipp_id);
 
-		if (ippdrv->ipp_id == 0) {
-			DRM_ERROR("failed to get ipp_id[%d]\n",
-				ippdrv->ipp_id);
-			goto err_idr;
-		}
+		ippdrv->prop_list->ipp_id = ipp_id;
 
 		/* store parent device for node */
 		ippdrv->parent_dev = dev;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index ab1634b..4aa71b2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -160,7 +160,6 @@ struct exynos_drm_ippdrv {
 	struct device	*parent_dev;
 	struct device	*dev;
 	struct drm_device	*drm_dev;
-	u32	ipp_id;
 	bool	dedicated;
 	struct exynos_drm_ipp_ops	*ops[EXYNOS_DRM_OPS_MAX];
 	struct workqueue_struct	*event_workq;
-- 
1.9.1

