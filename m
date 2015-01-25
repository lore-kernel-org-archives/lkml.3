Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbbAYS7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:59:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbbAYSJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.18 030/183] drm/fb_helper: move deferred fb checking into restore mode (v2)
Date: Sun, 25 Jan 2015 10:05:52 -0800
Message-Id: <20150125180811.473332029@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_fb_helper.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -347,9 +347,18 @@ bool drm_fb_helper_restore_fbdev_mode_un
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
@@ -888,10 +897,6 @@ int drm_fb_helper_set_par(struct fb_info
 
 	drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper);
 
-	if (fb_helper->delayed_hotplug) {
-		fb_helper->delayed_hotplug = false;
-		drm_fb_helper_hotplug_event(fb_helper);
-	}
 	return 0;
 }
 EXPORT_SYMBOL(drm_fb_helper_set_par);


