Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaENO55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:57:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42639 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaENO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:57:54 -0400
Subject: [RFC PATCH v1 05/16] drm/ttm: call ttm_bo_wait while inside a
 reservation
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Wed, 14 May 2014 16:57:52 +0200
Message-ID: <20140514145752.21163.58484.stgit@patser>
In-Reply-To: <20140514145134.21163.32350.stgit@patser>
References: <20140514145134.21163.32350.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last remaining function that doesn't use the reservation
lock completely to fence off access to a buffer.
---
 drivers/gpu/drm/ttm/ttm_bo.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 4ab9f7171c4f..d7d34336f108 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -502,17 +502,6 @@ static int ttm_bo_cleanup_refs_and_unlock(struct ttm_buffer_object *bo,
 		if (ret)
 			return ret;
 
-		/*
-		 * remove sync_obj with ttm_bo_wait, the wait should be
-		 * finished, and no new wait object should have been added.
-		 */
-		spin_lock(&bdev->fence_lock);
-		ret = ttm_bo_wait(bo, false, false, true);
-		WARN_ON(ret);
-		spin_unlock(&bdev->fence_lock);
-		if (ret)
-			return ret;
-
 		spin_lock(&glob->lru_lock);
 		ret = __ttm_bo_reserve(bo, false, true, false, 0);
 
@@ -528,8 +517,16 @@ static int ttm_bo_cleanup_refs_and_unlock(struct ttm_buffer_object *bo,
 			spin_unlock(&glob->lru_lock);
 			return 0;
 		}
-	} else
-		spin_unlock(&bdev->fence_lock);
+
+		/*
+		 * remove sync_obj with ttm_bo_wait, the wait should be
+		 * finished, and no new wait object should have been added.
+		 */
+		spin_lock(&bdev->fence_lock);
+		ret = ttm_bo_wait(bo, false, false, true);
+		WARN_ON(ret);
+	}
+	spin_unlock(&bdev->fence_lock);
 
 	if (ret || unlikely(list_empty(&bo->ddestroy))) {
 		__ttm_bo_unreserve(bo);
@@ -1539,6 +1536,8 @@ int ttm_bo_wait(struct ttm_buffer_object *bo,
 	void *sync_obj;
 	int ret = 0;
 
+	lockdep_assert_held(&bo->resv->lock.base);
+
 	if (likely(bo->sync_obj == NULL))
 		return 0;
 

