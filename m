Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965700AbaH1JI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:08:28 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54124 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965642AbaH1JIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:19 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ab-53fef18194db
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
Subject: [PATCH v2 04/17] drm/exynos/ipp: remove only related commands on file
 close
Date: Thu, 28 Aug 2014 11:07:28 +0200
Message-id: <1409216861-12452-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7qNH/8FG+x6wWpxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXRP6GHpaCVp6Jx+xWWBsY+ri5GTg4JAROJo6t+skHYYhIX7q0H
	srk4hASWMkpceLKIHcLpY5I4e3QXK0gVm4CmxN/NN8E6RASUJVbtawcrYhb4yCRxZekbZpCE
	sECYRO+fU0A2BweLgKrEt2diIGFeAWeJyU++MEFsk5M4eWwy2ExOAReJjcffsIPYQkA1u89/
	ZprAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhYfd3BuPSY1SFGAQ5GJR5ehdN/
	goVYE8uKK3MPMUpwMCuJ8B49/i9YiDclsbIqtSg/vqg0J7X4ECMTB6dUA6NA7C6zB9vkMqK+
	f8qq2dmWGJMf6HJa1EF+T4psWJehYInB/vOpW2Y8yu25Y3Sc5UBHiU4gX03T9bcvXgmGpu0z
	SXrxdaVE3va/cxYrn1ySm/Fkx/X/AXc/3H5RctY79MR3+RpeB7u5O2Y8efDWn2Upfwy79d/c
	yLQfJxmFJ3y6+rzlo0zGsXwlluKMREMt5qLiRAC+vXf7CQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On file close driver should remove only command nodes created
via this file.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index bbe9968..81f780e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1681,14 +1681,11 @@ static int ipp_subdrv_open(struct drm_device *drm_dev, struct device *dev,
 static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 		struct drm_file *file)
 {
-	struct drm_exynos_file_private *file_priv = file->driver_priv;
 	struct exynos_drm_ippdrv *ippdrv = NULL;
 	struct ipp_context *ctx = get_ipp_context(dev);
 	struct drm_exynos_ipp_cmd_node *c_node, *tc_node;
 	int count = 0;
 
-	DRM_DEBUG_KMS("for priv[0x%x]\n", (int)file_priv->ipp_dev);
-
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
 		mutex_lock(&ippdrv->cmd_lock);
 		list_for_each_entry_safe(c_node, tc_node,
@@ -1696,7 +1693,7 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 			DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]\n",
 				count++, (int)ippdrv);
 
-			if (c_node->dev == file_priv->ipp_dev) {
+			if (c_node->filp == file) {
 				/*
 				 * userland goto unnormal state. process killed.
 				 * and close the file.
-- 
1.9.1

