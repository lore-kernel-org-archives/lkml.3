Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaKSL2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:28:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbaKSL2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:28:22 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, Gerd Hoffmann <kraxel@redhat.com>,
        David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] bochs: fix bochsdrmfb mmap
Date: Wed, 19 Nov 2014 12:28:11 +0100
Message-Id: <1416396492-23214-4-git-send-email-kraxel@redhat.com>
In-Reply-To: <1416396492-23214-1-git-send-email-kraxel@redhat.com>
References: <1416396492-23214-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the mapping offset from the bo backing the fbdev framebuffer.
Wire up fbdev mmap function to map the backing bo using ttm_fbdev_mmap.
With that patch in place mmap(/dev/fb0) works as expected.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/bochs/bochs_fbdev.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bochs/bochs_fbdev.c b/drivers/gpu/drm/bochs/bochs_fbdev.c
index fe95d31..61dbf09 100644
--- a/drivers/gpu/drm/bochs/bochs_fbdev.c
+++ b/drivers/gpu/drm/bochs/bochs_fbdev.c
@@ -9,6 +9,17 @@
 
 /* ---------------------------------------------------------------------- */
 
+static int bochsfb_mmap(struct fb_info *info,
+			struct vm_area_struct *vma)
+{
+	struct drm_fb_helper *fb_helper = info->par;
+	struct bochs_device *bochs =
+		container_of(fb_helper, struct bochs_device, fb.helper);
+	struct bochs_bo *bo = gem_to_bochs_bo(bochs->fb.gfb.obj);
+
+	return ttm_fbdev_mmap(vma, &bo->bo);
+}
+
 static struct fb_ops bochsfb_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = drm_fb_helper_check_var,
@@ -19,6 +30,7 @@ static struct fb_ops bochsfb_ops = {
 	.fb_pan_display = drm_fb_helper_pan_display,
 	.fb_blank = drm_fb_helper_blank,
 	.fb_setcmap = drm_fb_helper_setcmap,
+	.fb_mmap = bochsfb_mmap,
 };
 
 static int bochsfb_create_object(struct bochs_device *bochs,
@@ -123,11 +135,9 @@ static int bochsfb_create(struct drm_fb_helper *helper,
 	info->screen_base = bo->kmap.virtual;
 	info->screen_size = size;
 
-#if 0
-	/* FIXME: get this right for mmap(/dev/fb0) */
-	info->fix.smem_start = bochs_bo_mmap_offset(bo);
+	drm_vma_offset_remove(&bo->bo.bdev->vma_manager, &bo->bo.vma_node);
+	info->fix.smem_start = 0;
 	info->fix.smem_len = size;
-#endif
 
 	ret = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (ret) {
-- 
1.8.3.1

