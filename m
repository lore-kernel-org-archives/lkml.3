Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3ETLT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:19:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56053 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab3ETKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 031/115] drm/mgag200: deal with bo reserve fail in dirty update path
Date: Mon, 20 May 2013 11:50:31 +0100
Message-Id: <1369047116-9378-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 641719599528d806e00de8ae8c8453361266a312 upstream.

On F19 testing, it was noticed we get a lot of errors in dmesg
about being unable to reserve the buffer when plymouth starts,
this is due to the buffer being in the process of migrating,
so it makes sense we can't reserve it.

In order to deal with it, this adds delayed updates for the dirty
updates, when the bo is unreservable, in the normal console case
this shouldn't ever happen, its just when plymouth or X is
pushing the console bo to system memory.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_drv.h |  2 ++
 drivers/gpu/drm/mgag200/mgag200_fb.c  | 43 ++++++++++++++++++++++++++++++++---
 drivers/gpu/drm/mgag200/mgag200_ttm.c |  4 ++--
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index 6f13b35..aa2fa4d 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -116,6 +116,8 @@ struct mga_fbdev {
 	void *sysram;
 	int size;
 	struct ttm_bo_kmap_obj mapping;
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 struct mga_crtc {
diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
index 880d336..f5f0366 100644
--- a/drivers/gpu/drm/mgag200/mgag200_fb.c
+++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
@@ -29,16 +29,52 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
 	int bpp = (mfbdev->mfb.base.bits_per_pixel + 7)/8;
 	int ret;
 	bool unmap = false;
+	bool store_for_later = false;
+	int x2, y2;
+	unsigned long flags;
 
 	obj = mfbdev->mfb.obj;
 	bo = gem_to_mga_bo(obj);
 
+	/*
+	 * try and reserve the BO, if we fail with busy
+	 * then the BO is being moved and we should
+	 * store up the damage until later.
+	 */
 	ret = mgag200_bo_reserve(bo, true);
 	if (ret) {
-		DRM_ERROR("failed to reserve fb bo\n");
+		if (ret != -EBUSY)
+			return;
+
+		store_for_later = true;
+	}
+
+	x2 = x + width - 1;
+	y2 = y + height - 1;
+	spin_lock_irqsave(&mfbdev->dirty_lock, flags);
+
+	if (mfbdev->y1 < y)
+		y = mfbdev->y1;
+	if (mfbdev->y2 > y2)
+		y2 = mfbdev->y2;
+	if (mfbdev->x1 < x)
+		x = mfbdev->x1;
+	if (mfbdev->x2 > x2)
+		x2 = mfbdev->x2;
+
+	if (store_for_later) {
+		mfbdev->x1 = x;
+		mfbdev->x2 = x2;
+		mfbdev->y1 = y;
+		mfbdev->y2 = y2;
+		spin_unlock_irqrestore(&mfbdev->dirty_lock, flags);
 		return;
 	}
 
+	mfbdev->x1 = mfbdev->y1 = INT_MAX;
+	mfbdev->x2 = mfbdev->y2 = 0;
+	spin_unlock_irqrestore(&mfbdev->dirty_lock, flags);
+
 	if (!bo->kmap.virtual) {
 		ret = ttm_bo_kmap(&bo->bo, 0, bo->bo.num_pages, &bo->kmap);
 		if (ret) {
@@ -48,10 +84,10 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
 		}
 		unmap = true;
 	}
-	for (i = y; i < y + height; i++) {
+	for (i = y; i <= y2; i++) {
 		/* assume equal stride for now */
 		src_offset = dst_offset = i * mfbdev->mfb.base.pitches[0] + (x * bpp);
-		memcpy_toio(bo->kmap.virtual + src_offset, mfbdev->sysram + src_offset, width * bpp);
+		memcpy_toio(bo->kmap.virtual + src_offset, mfbdev->sysram + src_offset, (x2 - x + 1) * bpp);
 
 	}
 	if (unmap)
@@ -270,6 +306,7 @@ int mgag200_fbdev_init(struct mga_device *mdev)
 
 	mdev->mfbdev = mfbdev;
 	mfbdev->helper.funcs = &mga_fb_helper_funcs;
+	spin_lock_init(&mfbdev->dirty_lock);
 
 	ret = drm_fb_helper_init(mdev->dev, &mfbdev->helper,
 				 mdev->num_crtc, MGAG200FB_CONN_LIMIT);
diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index b223dcb..a707394 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -315,8 +315,8 @@ int mgag200_bo_reserve(struct mgag200_bo *bo, bool no_wait)
 
 	ret = ttm_bo_reserve(&bo->bo, true, no_wait, false, 0);
 	if (ret) {
-		if (ret != -ERESTARTSYS)
-			DRM_ERROR("reserve failed %p\n", bo);
+		if (ret != -ERESTARTSYS && ret != -EBUSY)
+			DRM_ERROR("reserve failed %p %d\n", bo, ret);
 		return ret;
 	}
 	return 0;
-- 
1.8.1.2

