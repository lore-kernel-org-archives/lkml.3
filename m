Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3C1MFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:05:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44126 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab3C1MFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:05:01 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, backports@vger.kernel.org,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, rodrigo.vivi@gmail.com, daniel.vetter@ffwll.ch,
        rafael.j.wysocki@intel.com,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 4/4] fb: add helpers to enable and test for the skip_vt_switch
Date: Thu, 28 Mar 2013 05:04:30 -0700
Message-Id: <1364472270-9297-5-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This adds helpers to enable and test for the skip_vt_switch.
This gets us two things:

1) It allows us to require less collateral evolutions
   should we need changes on the fb_info data structure
   later (perhaps a bitmap flag).

2) Allows this feature to be backported with 0 delta
   required on the upstream drivers, we'd just require
   the static inline to do a no-op.

1) may be worth while considering, 2) is a new consideration
I'm trying to get others to evaluate to help with automatically
backporting the Linux kernel. This is the first time I am
aware someone argues for it.

Cc: cocci@systeme.lip6.fr
Cc: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/gpu/drm/i915/intel_fb.c |    2 +-
 drivers/video/fbmem.c           |    2 +-
 include/linux/fb.h              |   10 ++++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 8d81c929..c0f306c 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -151,7 +151,7 @@ static int intelfb_create(struct drm_fb_helper *helper,
 	info->screen_size = size;
 
 	/* This driver doesn't need a VT switch to restore the mode on resume */
-	info->skip_vt_switch = true;
+	fb_enable_skip_vt_switch(info);
 
 	drm_fb_helper_fill_fix(info, fb->pitches[0], fb->depth);
 	drm_fb_helper_fill_var(info, &ifbdev->helper, sizes->fb_width, sizes->fb_height);
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index ccd44b0..daffadc 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1645,7 +1645,7 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 	if (!fb_info->modelist.prev || !fb_info->modelist.next)
 		INIT_LIST_HEAD(&fb_info->modelist);
 
-	if (fb_info->skip_vt_switch)
+	if (fb_skip_vt_switch_isset(fb_info))
 		pm_vt_switch_required(fb_info->dev, false);
 	else
 		pm_vt_switch_required(fb_info->dev, true);
diff --git a/include/linux/fb.h b/include/linux/fb.h
index d49c60f..d534966 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -505,6 +505,16 @@ struct fb_info {
 	bool skip_vt_switch; /* no VT switch on suspend/resume required */
 };
 
+static inline void fb_enable_skip_vt_switch(struct fb_info *info)
+{
+	info->skip_vt_switch = true;
+}
+
+static inline bool fb_skip_vt_switch_isset(struct fb_info *info)
+{
+	return info->skip_vt_switch;
+}
+
 static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {
 	struct apertures_struct *a = kzalloc(sizeof(struct apertures_struct)
 			+ max_num * sizeof(struct aperture), GFP_KERNEL);
-- 
1.7.10.4

