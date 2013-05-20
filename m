Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3ETLTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:19:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3ETKwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 032/115] drm/ast: deal with bo reserve fail in dirty update path
Date: Mon, 20 May 2013 11:50:32 +0100
Message-Id: <1369047116-9378-33-git-send-email-luis.henriques@canonical.com>
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

commit 306373b645d80625335b8e684fa09b14ba460cec upstream.

Port over the mgag200 fix to ast as it suffers the same issue.

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
 drivers/gpu/drm/ast/ast_drv.h |  2 ++
 drivers/gpu/drm/ast/ast_fb.c  | 43 ++++++++++++++++++++++++++++++++++++++++---
 drivers/gpu/drm/ast/ast_ttm.c |  2 +-
 3 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index d4af9ed..85a6eeb 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -240,6 +240,8 @@ struct ast_fbdev {
 	void *sysram;
 	int size;
 	struct ttm_bo_kmap_obj mapping;
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 #define to_ast_crtc(x) container_of(x, struct ast_crtc, base)
diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index 2fc8e9e..853f831 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -53,16 +53,52 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 	int bpp = (afbdev->afb.base.bits_per_pixel + 7)/8;
 	int ret;
 	bool unmap = false;
+	bool store_for_later = false;
+	int x2, y2;
+	unsigned long flags;
 
 	obj = afbdev->afb.obj;
 	bo = gem_to_ast_bo(obj);
 
+	/*
+	 * try and reserve the BO, if we fail with busy
+	 * then the BO is being moved and we should
+	 * store up the damage until later.
+	 */
 	ret = ast_bo_reserve(bo, true);
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
+	spin_lock_irqsave(&afbdev->dirty_lock, flags);
+
+	if (afbdev->y1 < y)
+		y = afbdev->y1;
+	if (afbdev->y2 > y2)
+		y2 = afbdev->y2;
+	if (afbdev->x1 < x)
+		x = afbdev->x1;
+	if (afbdev->x2 > x2)
+		x2 = afbdev->x2;
+
+	if (store_for_later) {
+		afbdev->x1 = x;
+		afbdev->x2 = x2;
+		afbdev->y1 = y;
+		afbdev->y2 = y2;
+		spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
 		return;
 	}
 
+	afbdev->x1 = afbdev->y1 = INT_MAX;
+	afbdev->x2 = afbdev->y2 = 0;
+	spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
+
 	if (!bo->kmap.virtual) {
 		ret = ttm_bo_kmap(&bo->bo, 0, bo->bo.num_pages, &bo->kmap);
 		if (ret) {
@@ -72,10 +108,10 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 		}
 		unmap = true;
 	}
-	for (i = y; i < y + height; i++) {
+	for (i = y; i <= y2; i++) {
 		/* assume equal stride for now */
 		src_offset = dst_offset = i * afbdev->afb.base.pitches[0] + (x * bpp);
-		memcpy_toio(bo->kmap.virtual + src_offset, afbdev->sysram + src_offset, width * bpp);
+		memcpy_toio(bo->kmap.virtual + src_offset, afbdev->sysram + src_offset, (x2 - x + 1) * bpp);
 
 	}
 	if (unmap)
@@ -306,6 +342,7 @@ int ast_fbdev_init(struct drm_device *dev)
 
 	ast->fbdev = afbdev;
 	afbdev->helper.funcs = &ast_fb_helper_funcs;
+	spin_lock_init(&afbdev->dirty_lock);
 	ret = drm_fb_helper_init(dev, &afbdev->helper,
 				 1, 1);
 	if (ret) {
diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 6cf2ade..2a6027c 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -316,7 +316,7 @@ int ast_bo_reserve(struct ast_bo *bo, bool no_wait)
 
 	ret = ttm_bo_reserve(&bo->bo, true, no_wait, false, 0);
 	if (ret) {
-		if (ret != -ERESTARTSYS)
+		if (ret != -ERESTARTSYS && ret != -EBUSY)
 			DRM_ERROR("reserve failed %p\n", bo);
 		return ret;
 	}
-- 
1.8.1.2

