Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3AYQWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:22:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab3AYQV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:21:57 -0500
From: Takashi Iwai <tiwai@suse.de>
To: David Airlie <airlied@linux.ie>
Cc: Stefan Dirsch <sndirsch@suse.de>, Bernhard Wiedemann <bwiedemann@suse.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drm/cirrus: Use 16bpp as default
Date: Fri, 25 Jan 2013 17:21:55 +0100
Message-Id: <1359130915-30082-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359130915-30082-1-git-send-email-tiwai@suse.de>
References: <1359130915-30082-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've got a bug report that GNOME on QEMU shows wrong colors.
It turned out that it's because Cairo doesn't support 24bpp well.
This hasn't been an issue until now because we (at least SUSE and
Fedora) have a patch to use 16bpp for QEMU in Xorg cirrus UMS driver.

Since cirrus KMS driver is mainly targeted for the use on QEMU/KVM, we
should choose 16bpp as default, too.

Also, it's not convenient to set the default bpp in multiple places.
cirrus_fbdev_init() should check the original preferred depth set in
cirrus_modeset_init().

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=799216

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 2 +-
 drivers/gpu/drm/cirrus/cirrus_mode.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 6c6b4c8..bc081ea 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -273,7 +273,7 @@ int cirrus_fbdev_init(struct cirrus_device *cdev)
 {
 	struct cirrus_fbdev *gfbdev;
 	int ret;
-	int bpp_sel = 24;
+	int bpp_sel = cdev->dev->mode_config.preferred_depth;
 
 	/*bpp_sel = 8;*/
 	gfbdev = kzalloc(sizeof(struct cirrus_fbdev), GFP_KERNEL);
diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
index 379a47e..e259f07 100644
--- a/drivers/gpu/drm/cirrus/cirrus_mode.c
+++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
@@ -588,7 +588,7 @@ int cirrus_modeset_init(struct cirrus_device *cdev)
 	cdev->dev->mode_config.max_height = CIRRUS_MAX_FB_HEIGHT;
 
 	cdev->dev->mode_config.fb_base = cdev->mc.vram_base;
-	cdev->dev->mode_config.preferred_depth = 24;
+	cdev->dev->mode_config.preferred_depth = 16;
 	/* don't prefer a shadow on virt GPU */
 	cdev->dev->mode_config.prefer_shadow = 0;
 
-- 
1.8.1.1

