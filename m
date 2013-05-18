Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab3ERDM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:12:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710Ab3ERDAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:18 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=m4UGv-vMl0kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=2tkOJcSkPyQA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=oH0tNwsDB6TlXkgAi-IA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=IFPWNCrZdV1wzP8p:21 a=BeVgOB_Qm2AvYEKf:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021658.553076097@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>
Subject: [ 105/136 ] drm/cirrus: deal with bo reserve fail in dirty update path
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0105-drm-cirrus-deal-with-bo-reserve-fail-in-dirty-update.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit f3b2bbdc8a87a080ccd23d27fca4b87d61340dd4 ]

Port over the mgag200 fix to cirrus as it suffers the same issue.

    On F19 testing, it was noticed we get a lot of errors in dmesg
    about being unable to reserve the buffer when plymouth starts,
    this is due to the buffer being in the process of migrating,
    so it makes sense we can't reserve it.

    In order to deal with it, this adds delayed updates for the dirty
    updates, when the bo is unreservable, in the normal console case
    this shouldn't ever happen, its just when plymouth or X is
    pushing the console bo to system memory.

Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/cirrus/cirrus_drv.h   |    2 ++
 drivers/gpu/drm/cirrus/cirrus_fbdev.c |   38 ++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/cirrus/cirrus_ttm.c   |    2 +-
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
1.7.10.4


