Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbbALSLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:11:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbbALSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 099/216] drm/fb_helper: move deferred fb checking into restore mode (v2)
Date: Mon, 12 Jan 2015 18:03:36 +0000
Message-Id: <1421085933-32536-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit e2809c7db818df6bbd0edf843e1beb2fbc9d8541 upstream.

On MST systems the monitors don't appear when we set the fb up,
but plymouth opens the drm device and holds it open while they
come up, when plymouth finishes and lastclose gets called we
don't do the delayed fb probe, so the monitor never appears on the
console.

Fix this by moving the delayed checking into the mode restore.

v2: Daniel suggested that ->delayed_hotplug is set under
the mode_config mutex, so we should check it under that as
well, while we are in the area.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_fb_helper.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index d5d8cea1a679..20e820c3abbb 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -331,9 +331,18 @@ bool drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper)
 {
 	struct drm_device *dev = fb_helper->dev;
 	bool ret;
+	bool do_delayed = false;
+
 	drm_modeset_lock_all(dev);
 	ret = restore_fbdev_mode(fb_helper);
+
+	do_delayed = fb_helper->delayed_hotplug;
+	if (do_delayed)
+		fb_helper->delayed_hotplug = false;
 	drm_modeset_unlock_all(dev);
+
+	if (do_delayed)
+		drm_fb_helper_hotplug_event(fb_helper);
 	return ret;
 }
 EXPORT_SYMBOL(drm_fb_helper_restore_fbdev_mode_unlocked);
@@ -858,10 +867,6 @@ int drm_fb_helper_set_par(struct fb_info *info)
 
 	drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper);
 
-	if (fb_helper->delayed_hotplug) {
-		fb_helper->delayed_hotplug = false;
-		drm_fb_helper_hotplug_event(fb_helper);
-	}
 	return 0;
 }
 EXPORT_SYMBOL(drm_fb_helper_set_par);
-- 
2.1.4

