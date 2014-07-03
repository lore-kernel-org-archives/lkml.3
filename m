Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbaGCNMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:12:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32955 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbaGCNLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:11:10 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-84-53b5566cd7cc
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
Subject: [PATCH 09/12] drm/exynos/ipp: simplify ipp_find_obj
Date: Thu, 03 Jul 2014 15:10:34 +0200
Message-id: <1404393037-17299-10-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7o5YVuDDTYvULK4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mq4c/4ca8EToYqVCw+wNTBO4+9i5OSQEDCR+DXnCTuELSZx4d56
	ti5GLg4hgaWMEotuXmWHcPqYJJ4fec4GUsUmoCnxd/NNMFtEQFli1b52sCJmgY9MEleWvmHu
	YuTgEBawkfi1MwikhkVAVWJu9zOwDbwCLhITPr9lgdgmJ3Hy2GRWEJsTKH5o5lJGEFtIwFli
	7ZK5bBMYeRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAmrrzsYlx6zOsQowMGoxMP7
	Qn9TsBBrYllxZe4hRgkOZiUR3orgrcFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGPdb7yj2EP09
	fbPk8lO5SmUzTpTXlsb4Pe+d+mNOxFFu6fCzMZ45u1aK1KQlsfZt1pEy4y6afSm83+XstFjl
	jccum5xV8TH582nv2sYvc2u0Ft29pLCO3+2T93KjROn7t6S2HS3wmBBw5PNqfh95n3/btMqc
	Z+gvutbIuqWJ/9Lve59V3typPqnEUpyRaKjFXFScCAAAjwOWCQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch simplifies ipp_find_obj and removes debug messages.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 26c8a2c..c7ea047 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -172,18 +172,8 @@ static void *ipp_find_obj(struct idr *id_idr, struct mutex *lock, u32 id)
 {
 	void *obj;
 
-	DRM_DEBUG_KMS("id[%d]\n", id);
-
 	mutex_lock(lock);
-
-	/* find object using handle */
 	obj = idr_find(id_idr, id);
-	if (!obj) {
-		DRM_ERROR("failed to find object.\n");
-		mutex_unlock(lock);
-		return ERR_PTR(-ENODEV);
-	}
-
 	mutex_unlock(lock);
 
 	return obj;
@@ -215,9 +205,9 @@ static struct exynos_drm_ippdrv *ipp_find_driver(struct ipp_context *ctx,
 		/* find ipp driver using idr */
 		ippdrv = ipp_find_obj(&ctx->ipp_idr, &ctx->ipp_lock,
 			ipp_id);
-		if (IS_ERR(ippdrv)) {
+		if (!ippdrv) {
 			DRM_ERROR("not found ipp%d driver.\n", ipp_id);
-			return ippdrv;
+			return ERR_PTR(-ENODEV);
 		}
 
 		/*
@@ -339,10 +329,10 @@ int exynos_drm_ipp_get_property(struct drm_device *drm_dev, void *data,
 		 */
 		ippdrv = ipp_find_obj(&ctx->ipp_idr, &ctx->ipp_lock,
 						prop_list->ipp_id);
-		if (IS_ERR(ippdrv)) {
+		if (!ippdrv) {
 			DRM_ERROR("not found ipp%d driver.\n",
 					prop_list->ipp_id);
-			return PTR_ERR(ippdrv);
+			return -ENODEV;
 		}
 
 		*prop_list = ippdrv->prop_list;
@@ -920,9 +910,9 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
 	/* find command node */
 	c_node = ipp_find_obj(&ctx->prop_idr, &ctx->prop_lock,
 		qbuf->prop_id);
-	if (IS_ERR(c_node)) {
+	if (!c_node) {
 		DRM_ERROR("failed to get command node.\n");
-		return PTR_ERR(c_node);
+		return -ENODEV;
 	}
 
 	/* buffer control */
@@ -1055,9 +1045,9 @@ int exynos_drm_ipp_cmd_ctrl(struct drm_device *drm_dev, void *data,
 
 	c_node = ipp_find_obj(&ctx->prop_idr, &ctx->prop_lock,
 		cmd_ctrl->prop_id);
-	if (IS_ERR(c_node)) {
+	if (!c_node) {
 		DRM_ERROR("invalid command node list.\n");
-		return PTR_ERR(c_node);
+		return -ENODEV;
 	}
 
 	if (!exynos_drm_ipp_check_valid(ippdrv->dev, cmd_ctrl->ctrl,
-- 
1.9.1

