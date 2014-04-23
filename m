Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbaDWHyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:54:53 -0400
Received: from hostedrelay.fireflyinternet.com ([109.228.30.76]:55405 "EHLO
	relay.fireflyinternet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaDWHyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:54:52 -0400
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
Date: Wed, 23 Apr 2014 08:54:31 +0100
Message-Id: <1398239671-4135-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <20140423071125.GS10722@phenom.ffwll.local>
References: <20140423071125.GS10722@phenom.ffwll.local>
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

v2: Add a debug message to track the discard of the BIOS fb.
v3: Ville pointed out the difference between ref/unref

Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=77767
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/intel_fbdev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
index b16116db6c37..fbe7941f88c8 100644
--- a/drivers/gpu/drm/i915/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/intel_fbdev.c
@@ -133,6 +133,16 @@ static int intelfb_create(struct drm_fb_helper *helper,
 
 	mutex_lock(&dev->struct_mutex);
 
+	if (intel_fb &&
+	    (sizes->fb_width > intel_fb->base.width ||
+	     sizes->fb_height > intel_fb->base.height)) {
+		DRM_DEBUG_KMS("BIOS fb too small (%dx%d), we require (%dx%d),"
+			      " releasing it\n",
+			      intel_fb->base.width, intel_fb->base.height,
+			      sizes->fb_width, sizes->fb_height);
+		drm_framebuffer_unreference(&intel_fb->base);
+		intel_fb = ifbdev->fb = NULL;
+	}
 	if (!intel_fb || WARN_ON(!intel_fb->obj)) {
 		DRM_DEBUG_KMS("no BIOS fb, allocating a new one\n");
 		ret = intelfb_alloc(helper, sizes);
-- 
1.9.2

