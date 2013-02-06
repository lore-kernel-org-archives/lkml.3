Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3BFTu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:27 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:37750 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964809Ab3BFTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:16 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 32/77] drm/exynos: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:04 -0800
Message-Id: <1360179649-22465-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 90398df..1adce07 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -137,21 +137,15 @@ static int ipp_create_id(struct idr *id_idr, struct mutex *lock, void *obj,
 
 	DRM_DEBUG_KMS("%s\n", __func__);
 
-again:
-	/* ensure there is space available to allocate a handle */
-	if (idr_pre_get(id_idr, GFP_KERNEL) == 0) {
-		DRM_ERROR("failed to get idr.\n");
-		return -ENOMEM;
-	}
-
 	/* do the allocation under our mutexlock */
 	mutex_lock(lock);
-	ret = idr_get_new_above(id_idr, obj, 1, (int *)idp);
+	ret = idr_alloc(id_idr, obj, 1, 0, GFP_KERNEL);
 	mutex_unlock(lock);
-	if (ret == -EAGAIN)
-		goto again;
+	if (ret < 0)
+		return ret;
 
-	return ret;
+	*idp = ret;
+	return 0;
 }
 
 static void *ipp_find_obj(struct idr *id_idr, struct mutex *lock, u32 id)
-- 
1.8.1

