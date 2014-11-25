Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaKYLzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:55:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58209 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaKYKkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 049/254] drm/nouveau: punt fbcon resume out to a workqueue
Date: Tue, 25 Nov 2014 10:36:39 +0000
Message-Id: <1416912004-5928-50-git-send-email-luis.henriques@canonical.com>
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

commit 634ffcccfbe59d77652804e1beb415d3329b1bc6 upstream.

Preparation for some runtime pm fixes.  Currently we skip over fbcon
suspend/resume in the runtime path, which causes issues on resume if
fbcon tries to write to the framebuffer before the BAR subdev has
been resumed to restore the BAR1 VM setup.

As we might be woken up via a sysfs connector, we are unable to call
fb_set_suspend() in the resume path as it could make its way down to
a modeset and cause all sorts of locking hilarity.

To solve this, we'll just delay the fbcon resume to a workqueue.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 23 +++++++++++++++++------
 drivers/gpu/drm/nouveau/nouveau_fbcon.h |  1 +
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 2ef2842aacbf..f6361391286c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -484,6 +484,16 @@ static struct drm_fb_helper_funcs nouveau_fbcon_helper_funcs = {
 	.fb_probe = nouveau_fbcon_create,
 };
 
+static void
+nouveau_fbcon_set_suspend_work(struct work_struct *work)
+{
+	struct nouveau_fbdev *fbcon = container_of(work, typeof(*fbcon), work);
+	console_lock();
+	nouveau_fbcon_accel_restore(fbcon->dev);
+	nouveau_fbcon_zfill(fbcon->dev, fbcon);
+	fb_set_suspend(fbcon->helper.fbdev, FBINFO_STATE_RUNNING);
+	console_unlock();
+}
 
 int
 nouveau_fbcon_init(struct drm_device *dev)
@@ -502,6 +512,7 @@ nouveau_fbcon_init(struct drm_device *dev)
 	if (!fbcon)
 		return -ENOMEM;
 
+	INIT_WORK(&fbcon->work, nouveau_fbcon_set_suspend_work);
 	fbcon->dev = dev;
 	drm->fbcon = fbcon;
 	fbcon->helper.funcs = &nouveau_fbcon_helper_funcs;
@@ -549,14 +560,14 @@ nouveau_fbcon_set_suspend(struct drm_device *dev, int state)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	if (drm->fbcon) {
-		console_lock();
-		if (state == 0) {
-			nouveau_fbcon_accel_restore(dev);
-			nouveau_fbcon_zfill(dev, drm->fbcon);
+		if (state == FBINFO_STATE_RUNNING) {
+			schedule_work(&drm->fbcon->work);
+			return;
 		}
+		flush_work(&drm->fbcon->work);
+		console_lock();
 		fb_set_suspend(drm->fbcon->helper.fbdev, state);
-		if (state == 1)
-			nouveau_fbcon_accel_save_disable(dev);
+		nouveau_fbcon_accel_save_disable(dev);
 		console_unlock();
 	}
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.h b/drivers/gpu/drm/nouveau/nouveau_fbcon.h
index 6d857e2869c9..2c8e84672b3b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.h
@@ -36,6 +36,7 @@ struct nouveau_fbdev {
 	struct nouveau_framebuffer nouveau_fb;
 	struct list_head fbdev_list;
 	struct drm_device *dev;
+	struct work_struct work;
 	unsigned int saved_flags;
 };
 
-- 
2.1.0

