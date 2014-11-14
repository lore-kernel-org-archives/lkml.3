Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161675AbaKNScJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:32:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37854 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965742AbaKNSag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:30:36 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Rob Clark <robdclark@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 RESEND 2/2] drm: flip-work: change drm_flip_work_init prototype
Date: Fri, 14 Nov 2014 19:30:30 +0100
Message-Id: <1415989830-17691-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415989830-17691-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415989830-17691-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we're using lists instead of kfifo to store drm flip-work tasks
we do not need the size parameter passed to drm_flip_work_init function
anymore.
Moreover this function cannot fail anymore, we can thus remove the return
code.

Modify drm_flip_work_init users to take account of these changes.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 drivers/gpu/drm/drm_flip_work.c          |  8 +-------
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c | 19 ++++---------------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c | 16 +++-------------
 drivers/gpu/drm/omapdrm/omap_plane.c     | 14 ++------------
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c     |  6 +-----
 include/drm/drm_flip_work.h              |  2 +-
 6 files changed, 12 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/drm_flip_work.c b/drivers/gpu/drm/drm_flip_work.c
index 6f4ae5b..43d9b95 100644
--- a/drivers/gpu/drm/drm_flip_work.c
+++ b/drivers/gpu/drm/drm_flip_work.c
@@ -136,16 +136,12 @@ static void flip_worker(struct work_struct *w)
 /**
  * drm_flip_work_init - initialize flip-work
  * @work: the flip-work to initialize
- * @size: the max queue depth
  * @name: debug name
  * @func: the callback work function
  *
  * Initializes/allocates resources for the flip-work
- *
- * RETURNS:
- * Zero on success, error code on failure.
  */
-int drm_flip_work_init(struct drm_flip_work *work, int size,
+void drm_flip_work_init(struct drm_flip_work *work,
 		const char *name, drm_flip_func_t func)
 {
 	work->name = name;
@@ -155,8 +151,6 @@ int drm_flip_work_init(struct drm_flip_work *work, int size,
 	work->func = func;
 
 	INIT_WORK(&work->worker, flip_worker);
-
-	return 0;
 }
 EXPORT_SYMBOL(drm_flip_work_init);
 
diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c
index 7d00f7f..7e4ef4c 100644
--- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c
+++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c
@@ -760,10 +760,8 @@ struct drm_crtc *mdp4_crtc_init(struct drm_device *dev,
 	int ret;
 
 	mdp4_crtc = kzalloc(sizeof(*mdp4_crtc), GFP_KERNEL);
-	if (!mdp4_crtc) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	if (!mdp4_crtc)
+		return ERR_PTR(-ENOMEM);
 
 	crtc = &mdp4_crtc->base;
 
@@ -784,12 +782,9 @@ struct drm_crtc *mdp4_crtc_init(struct drm_device *dev,
 
 	spin_lock_init(&mdp4_crtc->cursor.lock);
 
-	ret = drm_flip_work_init(&mdp4_crtc->unref_fb_work, 16,
+	drm_flip_work_init(&mdp4_crtc->unref_fb_work,
 			"unref fb", unref_fb_worker);
-	if (ret)
-		goto fail;
-
-	ret = drm_flip_work_init(&mdp4_crtc->unref_cursor_work, 64,
+	drm_flip_work_init(&mdp4_crtc->unref_cursor_work,
 			"unref cursor", unref_cursor_worker);
 
 	INIT_FENCE_CB(&mdp4_crtc->pageflip_cb, pageflip_cb);
@@ -800,10 +795,4 @@ struct drm_crtc *mdp4_crtc_init(struct drm_device *dev,
 	mdp4_plane_install_properties(mdp4_crtc->plane, &crtc->base);
 
 	return crtc;
-
-fail:
-	if (crtc)
-		mdp4_crtc_destroy(crtc);
-
-	return ERR_PTR(ret);
 }
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
index ebe2e60..a0cb374 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
@@ -537,10 +537,8 @@ struct drm_crtc *mdp5_crtc_init(struct drm_device *dev,
 	int ret;
 
 	mdp5_crtc = kzalloc(sizeof(*mdp5_crtc), GFP_KERNEL);
-	if (!mdp5_crtc) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	if (!mdp5_crtc)
+		return ERR_PTR(-ENOMEM);
 
 	crtc = &mdp5_crtc->base;
 
@@ -553,10 +551,8 @@ struct drm_crtc *mdp5_crtc_init(struct drm_device *dev,
 	snprintf(mdp5_crtc->name, sizeof(mdp5_crtc->name), "%s:%d",
 			pipe2name(mdp5_plane_pipe(plane)), id);
 
-	ret = drm_flip_work_init(&mdp5_crtc->unref_fb_work, 16,
+	drm_flip_work_init(&mdp5_crtc->unref_fb_work,
 			"unref fb", unref_fb_worker);
-	if (ret)
-		goto fail;
 
 	INIT_FENCE_CB(&mdp5_crtc->pageflip_cb, pageflip_cb);
 
@@ -566,10 +562,4 @@ struct drm_crtc *mdp5_crtc_init(struct drm_device *dev,
 	mdp5_plane_install_properties(mdp5_crtc->plane, &crtc->base);
 
 	return crtc;
-
-fail:
-	if (crtc)
-		mdp5_crtc_destroy(crtc);
-
-	return ERR_PTR(ret);
 }
diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
index 891a4dc..0ad7401 100644
--- a/drivers/gpu/drm/omapdrm/omap_plane.c
+++ b/drivers/gpu/drm/omapdrm/omap_plane.c
@@ -394,14 +394,10 @@ struct drm_plane *omap_plane_init(struct drm_device *dev,
 
 	omap_plane = kzalloc(sizeof(*omap_plane), GFP_KERNEL);
 	if (!omap_plane)
-		goto fail;
+		return NULL;
 
-	ret = drm_flip_work_init(&omap_plane->unpin_work, 16,
+	drm_flip_work_init(&omap_plane->unpin_work,
 			"unpin", unpin_worker);
-	if (ret) {
-		dev_err(dev->dev, "could not allocate unpin FIFO\n");
-		goto fail;
-	}
 
 	omap_plane->nformats = omap_framebuffer_get_formats(
 			omap_plane->formats, ARRAY_SIZE(omap_plane->formats),
@@ -443,10 +439,4 @@ struct drm_plane *omap_plane_init(struct drm_device *dev,
 		omap_plane->info.zorder = id;
 
 	return plane;
-
-fail:
-	if (plane)
-		omap_plane_destroy(plane);
-
-	return NULL;
 }
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
index d642d4a0..7d782ce 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
@@ -664,12 +664,8 @@ struct drm_crtc *tilcdc_crtc_create(struct drm_device *dev)
 	tilcdc_crtc->dpms = DRM_MODE_DPMS_OFF;
 	init_waitqueue_head(&tilcdc_crtc->frame_done_wq);
 
-	ret = drm_flip_work_init(&tilcdc_crtc->unref_work, 16,
+	drm_flip_work_init(&tilcdc_crtc->unref_work,
 			"unref", unref_worker);
-	if (ret) {
-		dev_err(dev->dev, "could not allocate unref FIFO\n");
-		goto fail;
-	}
 
 	ret = drm_crtc_init(dev, crtc, &tilcdc_crtc_funcs);
 	if (ret < 0)
diff --git a/include/drm/drm_flip_work.h b/include/drm/drm_flip_work.h
index 3fcb4c4..d387cf0 100644
--- a/include/drm/drm_flip_work.h
+++ b/include/drm/drm_flip_work.h
@@ -85,7 +85,7 @@ void drm_flip_work_queue_task(struct drm_flip_work *work,
 void drm_flip_work_queue(struct drm_flip_work *work, void *val);
 void drm_flip_work_commit(struct drm_flip_work *work,
 		struct workqueue_struct *wq);
-int drm_flip_work_init(struct drm_flip_work *work, int size,
+void drm_flip_work_init(struct drm_flip_work *work,
 		const char *name, drm_flip_func_t func);
 void drm_flip_work_cleanup(struct drm_flip_work *work);
 
-- 
1.9.1

