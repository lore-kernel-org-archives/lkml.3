Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaKGWlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:41:40 -0500
Received: from mail.ispras.ru ([83.149.199.45]:49018 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbaKGWlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:41:39 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] drm/i915: avoid deadlock on failure paths in __intel_framebuffer_create()
Date: Sat,  8 Nov 2014 01:41:23 +0300
Message-Id: <1415400083-7766-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since a8bb6818270c __intel_framebuffer_create() is called
with struct_mutex held, so it should use drm_gem_object_unreference()
instead of drm_gem_object_unreference_unlocked().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/gpu/drm/i915/intel_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index f0a1a56406eb..80f3e5a03059 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8561,7 +8561,7 @@ __intel_framebuffer_create(struct drm_device *dev,
 
 	intel_fb = kzalloc(sizeof(*intel_fb), GFP_KERNEL);
 	if (!intel_fb) {
-		drm_gem_object_unreference_unlocked(&obj->base);
+		drm_gem_object_unreference(&obj->base);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -8571,7 +8571,7 @@ __intel_framebuffer_create(struct drm_device *dev,
 
 	return &intel_fb->base;
 err:
-	drm_gem_object_unreference_unlocked(&obj->base);
+	drm_gem_object_unreference(&obj->base);
 	kfree(intel_fb);
 
 	return ERR_PTR(ret);
-- 
1.9.1

