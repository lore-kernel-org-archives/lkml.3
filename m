Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3EQWRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:17:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab3EQVh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 053/102] drm/i915: clear the stolen fb before resuming
Date: Fri, 17 May 2013 14:36:08 -0700
Message-Id: <20130517213249.942458747@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 1ffc5289bfcf7f4c4e4213240bb4be68c48ce603 upstream.

Similar to
commit 88afe715dd5469bc24ca7a19ac62dd3c241cab48
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sun Dec 16 12:15:41 2012 +0000

    drm/i915: Clear the stolen fb before enabling

but on the resume path.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=57191
Reported-and-tested-by: Nikolay Amiantov <nikoamia@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_fb.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -261,10 +261,22 @@ void intel_fbdev_fini(struct drm_device
 void intel_fbdev_set_suspend(struct drm_device *dev, int state)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	if (!dev_priv->fbdev)
+	struct intel_fbdev *ifbdev = dev_priv->fbdev;
+	struct fb_info *info;
+
+	if (!ifbdev)
 		return;
 
-	fb_set_suspend(dev_priv->fbdev->helper.fbdev, state);
+	info = ifbdev->helper.fbdev;
+
+	/* On resume from hibernation: If the object is shmemfs backed, it has
+	 * been restored from swap. If the object is stolen however, it will be
+	 * full of whatever garbage was left in there.
+	 */
+	if (!state && ifbdev->ifb.obj->stolen)
+		memset_io(info->screen_base, 0, info->screen_size);
+
+	fb_set_suspend(info, state);
 }
 
 MODULE_LICENSE("GPL and additional rights");


