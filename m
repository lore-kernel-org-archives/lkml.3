Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbaGCNLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:11:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40904 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbaGCNLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:11:14 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a6-53b55670d989
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
Subject: [PATCH 11/12] drm/exynos/ipp: simplify ipp_create_id
Date: Thu, 03 Jul 2014 15:10:36 +0200
Message-id: <1404393037-17299-12-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xK7oFYVuDDe5OlLG4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4MrYcWQHY8F/oYr27ttsDYwb+LsYOTkkBEwkFl9ZzQphi0lcuLee
	rYuRi0NIYCmjRNfqa8wQTh+TxPu/J8Cq2AQ0Jf5uvskGYosIKEus2tfODlLELPCRSeLK0jfM
	IAlhAVuJX6damUBsFgFViXfLJoE18wq4SDz6P48dYp2cxMljk8HinEDxQzOXMoLYQgLOEmuX
	zGWbwMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIYH3Zwbj4mNUhRgEORiUe3sYV
	G4KFWBPLiitzDzFKcDArifBWBG8NFuJNSaysSi3Kjy8qzUktPsTIxMEp1cAYqM/xoXxrjeOi
	swePGj+4cOReNMeKCv2oqRsYrS5a+LVUtf+d5nmwVnfdiW2pgYpcjN1Xrdv/6Fhe/tTb1eC4
	qGFzVcfhspAtB6aF7mwqsfXbdXvfih3ZQjNfWvxfy1A9yTjySF5Vzzx9602/Pij9s/xlFbT3
	gtDD6JoGu7qT59c/7fDa9rpdiaU4I9FQi7moOBEAIqLvvgoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no gain in passing id by pointer to be filled.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 0552f62..ae75a1d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -145,20 +145,15 @@ int exynos_drm_ippdrv_unregister(struct exynos_drm_ippdrv *ippdrv)
 	return 0;
 }
 
-static int ipp_create_id(struct idr *id_idr, struct mutex *lock, void *obj,
-		u32 *idp)
+static int ipp_create_id(struct idr *id_idr, struct mutex *lock, void *obj)
 {
 	int ret;
 
-	/* do the allocation under our mutexlock */
 	mutex_lock(lock);
 	ret = idr_alloc(id_idr, obj, 1, 0, GFP_KERNEL);
 	mutex_unlock(lock);
-	if (ret < 0)
-		return ret;
 
-	*idp = ret;
-	return 0;
+	return ret;
 }
 
 static void ipp_remove_id(struct idr *id_idr, struct mutex *lock, u32 id)
@@ -471,13 +466,12 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 	if (!c_node)
 		return -ENOMEM;
 
-	/* create property id */
-	ret = ipp_create_id(&ctx->prop_idr, &ctx->prop_lock, c_node,
-		&property->prop_id);
-	if (ret) {
+	ret = ipp_create_id(&ctx->prop_idr, &ctx->prop_lock, c_node);
+	if (ret < 0) {
 		DRM_ERROR("failed to create id.\n");
 		goto err_clear;
 	}
+	property->prop_id = ret;
 
 	DRM_DEBUG_KMS("created prop_id[%d]cmd[%d]ippdrv[0x%x]\n",
 		property->prop_id, property->cmd, (int)ippdrv);
@@ -1636,21 +1630,17 @@ static int ipp_subdrv_probe(struct drm_device *drm_dev, struct device *dev)
 
 	/* get ipp driver entry */
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
-		u32 ipp_id;
-
 		ippdrv->drm_dev = drm_dev;
 
-		ret = ipp_create_id(&ctx->ipp_idr, &ctx->ipp_lock, ippdrv,
-				    &ipp_id);
-		if (ret || ipp_id == 0) {
+		ret = ipp_create_id(&ctx->ipp_idr, &ctx->ipp_lock, ippdrv);
+		if (ret < 0) {
 			DRM_ERROR("failed to create id.\n");
 			goto err;
 		}
+		ippdrv->prop_list.ipp_id = ret;
 
 		DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]ipp_id[%d]\n",
-			count++, (int)ippdrv, ipp_id);
-
-		ippdrv->prop_list.ipp_id = ipp_id;
+			count++, (int)ippdrv, ret);
 
 		/* store parent device for node */
 		ippdrv->parent_dev = dev;
-- 
1.9.1

