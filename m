Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaAFPBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:01:50 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54111 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaAFPBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:01:48 -0500
Date: Mon, 6 Jan 2014 20:31:42 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>, Michal Srb <msrb@suse.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 07/85] drivers: gpu: Mark functions as static and remove
 unused function in cirrus_ttm.c
Message-ID: <e3ac8aa0923dca46142c99edb3b661467be3d5f8.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions cirrus_ttm_global_release(), cirrus_ttm_bo_is_cirrus_bo()
and cirrus_ttm_tt_create() as static in drm/cirrus/cirrus_ttm.c because
they are not used outside this file. Remove unused function
cirrus_bo_unpin() from drm/cirrus/cirrus_ttm.c.

This eliminates the following warnings in drm/cirrus/cirrus_ttm.c:
drivers/gpu/drm/cirrus/cirrus_ttm.c:84:1: warning: no previous prototype for ‘cirrus_ttm_global_release’ [-Wmissing-prototypes]
drivers/gpu/drm/cirrus/cirrus_ttm.c:105:6: warning: no previous prototype for ‘cirrus_ttm_bo_is_cirrus_bo’ [-Wmissing-prototypes]
drivers/gpu/drm/cirrus/cirrus_ttm.c:211:16: warning: no previous prototype for ‘cirrus_ttm_tt_create’ [-Wmissing-prototypes]
drivers/gpu/drm/cirrus/cirrus_ttm.c:378:5: warning: no previous prototype for ‘cirrus_bo_unpin’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/cirrus/cirrus_ttm.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index 75becde..8b37c25 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -80,7 +80,7 @@ static int cirrus_ttm_global_init(struct cirrus_device *cirrus)
 	return 0;
 }
 
-void
+static void
 cirrus_ttm_global_release(struct cirrus_device *cirrus)
 {
 	if (cirrus->ttm.mem_global_ref.release == NULL)
@@ -102,7 +102,7 @@ static void cirrus_bo_ttm_destroy(struct ttm_buffer_object *tbo)
 	kfree(bo);
 }
 
-bool cirrus_ttm_bo_is_cirrus_bo(struct ttm_buffer_object *bo)
+static bool cirrus_ttm_bo_is_cirrus_bo(struct ttm_buffer_object *bo)
 {
 	if (bo->destroy == &cirrus_bo_ttm_destroy)
 		return true;
@@ -208,7 +208,7 @@ static struct ttm_backend_func cirrus_tt_backend_func = {
 };
 
 
-struct ttm_tt *cirrus_ttm_tt_create(struct ttm_bo_device *bdev,
+static struct ttm_tt *cirrus_ttm_tt_create(struct ttm_bo_device *bdev,
 				 unsigned long size, uint32_t page_flags,
 				 struct page *dummy_read_page)
 {
@@ -375,26 +375,6 @@ int cirrus_bo_pin(struct cirrus_bo *bo, u32 pl_flag, u64 *gpu_addr)
 	return 0;
 }
 
-int cirrus_bo_unpin(struct cirrus_bo *bo)
-{
-	int i, ret;
-	if (!bo->pin_count) {
-		DRM_ERROR("unpin bad %p\n", bo);
-		return 0;
-	}
-	bo->pin_count--;
-	if (bo->pin_count)
-		return 0;
-
-	for (i = 0; i < bo->placement.num_placement ; i++)
-		bo->placements[i] &= ~TTM_PL_FLAG_NO_EVICT;
-	ret = ttm_bo_validate(&bo->bo, &bo->placement, false, false);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
 int cirrus_bo_push_sysram(struct cirrus_bo *bo)
 {
 	int i, ret;
-- 
1.7.9.5

