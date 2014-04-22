Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbaDVVXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:23:07 -0400
Received: from hostedrelay.fireflyinternet.com ([109.228.30.76]:50907 "EHLO
	relay.fireflyinternet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaDVVWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:22:52 -0400
X-Greylist: delayed 970 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2014 17:22:52 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Knut Petersen <Knut_Petersen@t-online.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] drm/i915: Discard BIOS framebuffers too small to accommodate chosen mode
Date: Tue, 22 Apr 2014 22:05:58 +0100
Message-Id: <1398200758-26107-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <535696DB.2080104@t-online.de>
References: <535696DB.2080104@t-online.de>
X-Authenticated-User: chris.alporthouse@surfanytime.net 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the inherited BIOS framebuffer is smaller than the mode selected for
fbdev, then if we continue to use it then we cause display corruption as
we do not setup the panel fitter to upscale.

Regression from commit d978ef14456a38034f6c0e94a794129501f89200
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Mar 7 08:57:51 2014 -0800

    drm/i915: Wrap the preallocated BIOS framebuffer and preserve for KMS fbcon v12

Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=77767
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/intel_fbdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
index b16116db6c37..28220ca838df 100644
--- a/drivers/gpu/drm/i915/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/intel_fbdev.c
@@ -133,6 +133,12 @@ static int intelfb_create(struct drm_fb_helper *helper,
 
 	mutex_lock(&dev->struct_mutex);
 
+	if (intel_fb &&
+	    (sizes->fb_width > intel_fb->base.width ||
+	     sizes->fb_height > intel_fb->base.height)) {
+		drm_framebuffer_reference(&ifbdev->fb->base);
+		intel_fb = ifbdev->fb = NULL;
+	}
 	if (!intel_fb || WARN_ON(!intel_fb->obj)) {
 		DRM_DEBUG_KMS("no BIOS fb, allocating a new one\n");
 		ret = intelfb_alloc(helper, sizes);
-- 
1.9.2

