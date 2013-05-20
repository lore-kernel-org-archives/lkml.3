Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3ETKxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3ETKwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 033/115] drm/cirrus: deal with bo reserve fail in dirty update path
Date: Mon, 20 May 2013 11:50:33 +0100
Message-Id: <1369047116-9378-34-git-send-email-luis.henriques@canonical.com>
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

commit f3b2bbdc8a87a080ccd23d27fca4b87d61340dd4 upstream.

Port over the mgag200 fix to cirrus as it suffers the same issue.

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
 drivers/gpu/drm/cirrus/cirrus_drv.h   |  2 ++
 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 38 ++++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/cirrus/cirrus_ttm.c   |  2 +-
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.h b/drivers/gpu/drm/cirrus/cirrus_drv.h
index 64ea597..9f29a90 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.h
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.h
@@ -155,6 +155,8 @@ struct cirrus_fbdev {
 	struct list_head fbdev_list;
 	void *sysram;
 	int size;
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 struct cirrus_bo {
diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 9a276a5..774bade 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -27,16 +27,51 @@ static void cirrus_dirty_update(struct cirrus_fbdev *afbdev,
 	int bpp = (afbdev->gfb.base.bits_per_pixel + 7)/8;
 	int ret;
 	bool unmap = false;
+	bool store_for_later = false;
+	int x2, y2;
+	unsigned long flags;
 
 	obj = afbdev->gfb.obj;
 	bo = gem_to_cirrus_bo(obj);
 
+	/*
+	 * try and reserve the BO, if we fail with busy
+	 * then the BO is being moved and we should
+	 * store up the damage until later.
+	 */
 	ret = cirrus_bo_reserve(bo, true);
 	if (ret) {
-		DRM_ERROR("failed to reserve fb bo\n");
+		if (ret != -EBUSY)
+			return;
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
@@ -283,6 +318,7 @@ int cirrus_fbdev_init(struct cirrus_device *cdev)
 
 	cdev->mode_info.gfbdev = gfbdev;
 	gfbdev->helper.funcs = &cirrus_fb_helper_funcs;
+	spin_lock_init(&gfbdev->dirty_lock);
 
 	ret = drm_fb_helper_init(cdev->dev, &gfbdev->helper,
 				 cdev->num_crtc, CIRRUSFB_CONN_LIMIT);
diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index 50e170f..d4b1b1d 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -321,7 +321,7 @@ int cirrus_bo_reserve(struct cirrus_bo *bo, bool no_wait)
 
 	ret = ttm_bo_reserve(&bo->bo, true, no_wait, false, 0);
 	if (ret) {
-		if (ret != -ERESTARTSYS)
+		if (ret != -ERESTARTSYS && ret != -EBUSY)
 			DRM_ERROR("reserve failed %p\n", bo);
 		return ret;
 	}
-- 
1.8.1.2

