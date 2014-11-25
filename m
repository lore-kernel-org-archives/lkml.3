Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaKYLv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:51:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaKYKky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 050/254] drm/nouveau: make sure display hardware is reinitialised on runtime resume
Date: Tue, 25 Nov 2014 10:36:40 +0000
Message-Id: <1416912004-5928-51-git-send-email-luis.henriques@canonical.com>
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

commit 6fbb702e27d78ad2458df048b58cca3454bc0965 upstream.

Linus commit 05c63c2ff23a80b654d6c088ac3ba21628db0173 modified the
runtime suspend/resume paths to skip over display-related tasks to
avoid locking issues on resume.

Unfortunately, this resulted in the display hardware being left in
a partially initialised state, preventing subsequent modesets from
completing.

This commit unifies the (many) suspend/resume paths, bringing back
display (and fbcon) handling in the runtime paths.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_display.c | 23 +++++++-------
 drivers/gpu/drm/nouveau/nouveau_display.h |  5 ++-
 drivers/gpu/drm/nouveau/nouveau_drm.c     | 51 ++++++++-----------------------
 3 files changed, 26 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index dd469dbeaae1..9d44068e7061 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -565,14 +565,12 @@ nouveau_display_destroy(struct drm_device *dev)
 }
 
 int
-nouveau_display_suspend(struct drm_device *dev)
+nouveau_display_suspend(struct drm_device *dev, bool runtime)
 {
-	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct drm_crtc *crtc;
 
 	nouveau_display_fini(dev);
 
-	NV_INFO(drm, "unpinning framebuffer(s)...\n");
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct nouveau_framebuffer *nouveau_fb;
 
@@ -594,12 +592,13 @@ nouveau_display_suspend(struct drm_device *dev)
 }
 
 void
-nouveau_display_repin(struct drm_device *dev)
+nouveau_display_resume(struct drm_device *dev, bool runtime)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct drm_crtc *crtc;
-	int ret;
+	int ret, head;
 
+	/* re-pin fb/cursors */
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct nouveau_framebuffer *nouveau_fb;
 
@@ -619,13 +618,6 @@ nouveau_display_repin(struct drm_device *dev)
 		if (ret)
 			NV_ERROR(drm, "Could not pin/map cursor.\n");
 	}
-}
-
-void
-nouveau_display_resume(struct drm_device *dev)
-{
-	struct drm_crtc *crtc;
-	int head;
 
 	nouveau_display_init(dev);
 
@@ -640,6 +632,13 @@ nouveau_display_resume(struct drm_device *dev)
 	for (head = 0; head < dev->mode_config.num_crtc; head++)
 		drm_vblank_on(dev, head);
 
+	/* This should ensure we don't hit a locking problem when someone
+	 * wakes us up via a connector.  We should never go into suspend
+	 * while the display is on anyways.
+	 */
+	if (runtime)
+		return;
+
 	drm_helper_resume_force_mode(dev);
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.h b/drivers/gpu/drm/nouveau/nouveau_display.h
index a71cf77e55b2..a5195a668f1d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.h
+++ b/drivers/gpu/drm/nouveau/nouveau_display.h
@@ -59,9 +59,8 @@ int  nouveau_display_create(struct drm_device *dev);
 void nouveau_display_destroy(struct drm_device *dev);
 int  nouveau_display_init(struct drm_device *dev);
 void nouveau_display_fini(struct drm_device *dev);
-int  nouveau_display_suspend(struct drm_device *dev);
-void nouveau_display_repin(struct drm_device *dev);
-void nouveau_display_resume(struct drm_device *dev);
+int  nouveau_display_suspend(struct drm_device *dev, bool runtime);
+void nouveau_display_resume(struct drm_device *dev, bool runtime);
 int  nouveau_display_vblank_enable(struct drm_device *, int);
 void nouveau_display_vblank_disable(struct drm_device *, int);
 int  nouveau_display_scanoutpos(struct drm_device *, int, unsigned int,
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 594c3f54102e..0f7addae60d7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -516,9 +516,11 @@ nouveau_do_suspend(struct drm_device *dev, bool runtime)
 	struct nouveau_cli *cli;
 	int ret;
 
-	if (dev->mode_config.num_crtc && !runtime) {
+	if (dev->mode_config.num_crtc) {
+		NV_INFO(drm, "suspending console...\n");
+		nouveau_fbcon_set_suspend(dev, 1);
 		NV_INFO(drm, "suspending display...\n");
-		ret = nouveau_display_suspend(dev);
+		ret = nouveau_display_suspend(dev, runtime);
 		if (ret)
 			return ret;
 	}
@@ -572,7 +574,7 @@ fail_client:
 fail_display:
 	if (dev->mode_config.num_crtc) {
 		NV_INFO(drm, "resuming display...\n");
-		nouveau_display_resume(dev);
+		nouveau_display_resume(dev, runtime);
 	}
 	return ret;
 }
@@ -587,9 +589,6 @@ int nouveau_pmops_suspend(struct device *dev)
 	    drm_dev->switch_power_state == DRM_SWITCH_POWER_DYNAMIC_OFF)
 		return 0;
 
-	if (drm_dev->mode_config.num_crtc)
-		nouveau_fbcon_set_suspend(drm_dev, 1);
-
 	ret = nouveau_do_suspend(drm_dev, false);
 	if (ret)
 		return ret;
@@ -602,7 +601,7 @@ int nouveau_pmops_suspend(struct device *dev)
 }
 
 static int
-nouveau_do_resume(struct drm_device *dev)
+nouveau_do_resume(struct drm_device *dev, bool runtime)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_cli *cli;
@@ -627,7 +626,9 @@ nouveau_do_resume(struct drm_device *dev)
 
 	if (dev->mode_config.num_crtc) {
 		NV_INFO(drm, "resuming display...\n");
-		nouveau_display_repin(dev);
+		nouveau_display_resume(dev, runtime);
+		NV_INFO(drm, "resuming console...\n");
+		nouveau_fbcon_set_suspend(dev, 0);
 	}
 
 	return 0;
@@ -650,47 +651,21 @@ int nouveau_pmops_resume(struct device *dev)
 		return ret;
 	pci_set_master(pdev);
 
-	ret = nouveau_do_resume(drm_dev);
-	if (ret)
-		return ret;
-
-	if (drm_dev->mode_config.num_crtc) {
-		nouveau_display_resume(drm_dev);
-		nouveau_fbcon_set_suspend(drm_dev, 0);
-	}
-
-	return 0;
+	return nouveau_do_resume(drm_dev, false);
 }
 
 static int nouveau_pmops_freeze(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct drm_device *drm_dev = pci_get_drvdata(pdev);
-	int ret;
-
-	if (drm_dev->mode_config.num_crtc)
-		nouveau_fbcon_set_suspend(drm_dev, 1);
-
-	ret = nouveau_do_suspend(drm_dev, false);
-	return ret;
+	return nouveau_do_suspend(drm_dev, false);
 }
 
 static int nouveau_pmops_thaw(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct drm_device *drm_dev = pci_get_drvdata(pdev);
-	int ret;
-
-	ret = nouveau_do_resume(drm_dev);
-	if (ret)
-		return ret;
-
-	if (drm_dev->mode_config.num_crtc) {
-		nouveau_display_resume(drm_dev);
-		nouveau_fbcon_set_suspend(drm_dev, 0);
-	}
-
-	return 0;
+	return nouveau_do_resume(drm_dev, false);
 }
 
 
@@ -934,7 +909,7 @@ static int nouveau_pmops_runtime_resume(struct device *dev)
 		return ret;
 	pci_set_master(pdev);
 
-	ret = nouveau_do_resume(drm_dev);
+	ret = nouveau_do_resume(drm_dev, true);
 	drm_kms_helper_poll_enable(drm_dev);
 	/* do magic */
 	nv_mask(device, 0x88488, (1 << 25), (1 << 25));
-- 
2.1.0

