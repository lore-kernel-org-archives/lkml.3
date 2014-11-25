Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaKYLzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:55:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58199 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaKYKkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 047/254] drm/nouveau/kms: take more care when pulling down accelerated fbcon
Date: Tue, 25 Nov 2014 10:36:37 +0000
Message-Id: <1416912004-5928-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 4b5098f3597195e9faf17e5a0cfca905d9a04d9f upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/dispnv04/crtc.c |  4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 92 ++++++++++++++++++++-------------
 drivers/gpu/drm/nouveau/nouveau_fbcon.h |  4 +-
 3 files changed, 61 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv04/crtc.c b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
index 41be3424c906..8b17d7d49e26 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/crtc.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
@@ -915,9 +915,9 @@ nv04_crtc_mode_set_base_atomic(struct drm_crtc *crtc,
 	struct drm_device *dev = drm->dev;
 
 	if (state == ENTER_ATOMIC_MODE_SET)
-		nouveau_fbcon_save_disable_accel(dev);
+		nouveau_fbcon_accel_save_disable(dev);
 	else
-		nouveau_fbcon_restore_accel(dev);
+		nouveau_fbcon_accel_restore(dev);
 
 	return nv04_crtc_do_mode_set_base(crtc, fb, x, y, true);
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 191665ee7f52..02dc2a1e1d28 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -212,6 +212,58 @@ static struct fb_ops nouveau_fbcon_sw_ops = {
 	.fb_debug_leave = drm_fb_helper_debug_leave,
 };
 
+void
+nouveau_fbcon_accel_save_disable(struct drm_device *dev)
+{
+	struct nouveau_drm *drm = nouveau_drm(dev);
+	if (drm->fbcon) {
+		drm->fbcon->saved_flags = drm->fbcon->helper.fbdev->flags;
+		drm->fbcon->helper.fbdev->flags |= FBINFO_HWACCEL_DISABLED;
+	}
+}
+
+void
+nouveau_fbcon_accel_restore(struct drm_device *dev)
+{
+	struct nouveau_drm *drm = nouveau_drm(dev);
+	if (drm->fbcon) {
+		drm->fbcon->helper.fbdev->flags = drm->fbcon->saved_flags;
+	}
+}
+
+void
+nouveau_fbcon_accel_fini(struct drm_device *dev)
+{
+	struct nouveau_drm *drm = nouveau_drm(dev);
+	struct nouveau_fbdev *fbcon = drm->fbcon;
+	if (fbcon && drm->channel) {
+		console_lock();
+		fbcon->helper.fbdev->flags |= FBINFO_HWACCEL_DISABLED;
+		console_unlock();
+		nouveau_channel_idle(drm->channel);
+	}
+}
+
+void
+nouveau_fbcon_accel_init(struct drm_device *dev)
+{
+	struct nouveau_drm *drm = nouveau_drm(dev);
+	struct nouveau_fbdev *fbcon = drm->fbcon;
+	struct fb_info *info = fbcon->helper.fbdev;
+	int ret;
+
+	if (nv_device(drm->device)->card_type < NV_50)
+		ret = nv04_fbcon_accel_init(info);
+	else
+	if (nv_device(drm->device)->card_type < NV_C0)
+		ret = nv50_fbcon_accel_init(info);
+	else
+		ret = nvc0_fbcon_accel_init(info);
+
+	if (ret == 0)
+		info->fbops = &nouveau_fbcon_ops;
+}
+
 static void nouveau_fbcon_gamma_set(struct drm_crtc *crtc, u16 red, u16 green,
 				    u16 blue, int regno)
 {
@@ -357,20 +409,8 @@ nouveau_fbcon_create(struct drm_fb_helper *helper,
 
 	mutex_unlock(&dev->struct_mutex);
 
-	if (chan) {
-		ret = -ENODEV;
-		if (device->card_type < NV_50)
-			ret = nv04_fbcon_accel_init(info);
-		else
-		if (device->card_type < NV_C0)
-			ret = nv50_fbcon_accel_init(info);
-		else
-			ret = nvc0_fbcon_accel_init(info);
-
-		if (ret == 0)
-			info->fbops = &nouveau_fbcon_ops;
-	}
-
+	if (chan)
+		nouveau_fbcon_accel_init(dev);
 	nouveau_fbcon_zfill(dev, fbcon);
 
 	/* To allow resizeing without swapping buffers */
@@ -498,41 +538,23 @@ nouveau_fbcon_fini(struct drm_device *dev)
 	if (!drm->fbcon)
 		return;
 
+	nouveau_fbcon_accel_fini(dev);
 	nouveau_fbcon_destroy(dev, drm->fbcon);
 	kfree(drm->fbcon);
 	drm->fbcon = NULL;
 }
 
 void
-nouveau_fbcon_save_disable_accel(struct drm_device *dev)
-{
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	if (drm->fbcon) {
-		drm->fbcon->saved_flags = drm->fbcon->helper.fbdev->flags;
-		drm->fbcon->helper.fbdev->flags |= FBINFO_HWACCEL_DISABLED;
-	}
-}
-
-void
-nouveau_fbcon_restore_accel(struct drm_device *dev)
-{
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	if (drm->fbcon) {
-		drm->fbcon->helper.fbdev->flags = drm->fbcon->saved_flags;
-	}
-}
-
-void
 nouveau_fbcon_set_suspend(struct drm_device *dev, int state)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	if (drm->fbcon) {
 		console_lock();
 		if (state == 1)
-			nouveau_fbcon_save_disable_accel(dev);
+			nouveau_fbcon_accel_save_disable(dev);
 		fb_set_suspend(drm->fbcon->helper.fbdev, state);
 		if (state == 0) {
-			nouveau_fbcon_restore_accel(dev);
+			nouveau_fbcon_accel_restore(dev);
 			nouveau_fbcon_zfill(dev, drm->fbcon);
 		}
 		console_unlock();
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.h b/drivers/gpu/drm/nouveau/nouveau_fbcon.h
index fcff797d2084..6d857e2869c9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.h
@@ -61,8 +61,8 @@ void nouveau_fbcon_gpu_lockup(struct fb_info *info);
 int nouveau_fbcon_init(struct drm_device *dev);
 void nouveau_fbcon_fini(struct drm_device *dev);
 void nouveau_fbcon_set_suspend(struct drm_device *dev, int state);
-void nouveau_fbcon_save_disable_accel(struct drm_device *dev);
-void nouveau_fbcon_restore_accel(struct drm_device *dev);
+void nouveau_fbcon_accel_save_disable(struct drm_device *dev);
+void nouveau_fbcon_accel_restore(struct drm_device *dev);
 
 void nouveau_fbcon_output_poll_changed(struct drm_device *dev);
 #endif /* __NV50_FBCON_H__ */
-- 
2.1.0

