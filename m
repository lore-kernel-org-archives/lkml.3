Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936261Ab3DJUH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:07:27 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:38979 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3DJUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:07:25 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomas Melin <tomas.melin@iki.fi>,
        Richard Cochran <richardcochran@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: don't check inconsistent modeset state when force-restoring
Date: Wed, 10 Apr 2013 22:10:21 +0200
Message-Id: <1365624621-5683-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAKMK7uGTqSdq_V=Pu-BGNhhTqOn=fz5-LvUXBXpGQJqzL1QOUQ@mail.gmail.com>
References: <CAKMK7uGTqSdq_V=Pu-BGNhhTqOn=fz5-LvUXBXpGQJqzL1QOUQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be only consistent once we've restored all the crtcs. Since a
bunch of other callers also want to just restore a single crtc, add a
boolean to disable checking only where it doesn't make sense.

Note that intel_modeset_setup_hw_state already has a call to
intel_modeset_check_state at the end, so we don't reduce the amount of
checking.

v2: Try harder not to create a big patch (Chris).

v3: Even smaller (still Chris). Also fix a trailing space.

v4: Rebased on top of 3.9-rc6.

References: https://lkml.org/lkml/2013/3/16/60
Cc: Tomas Melin <tomas.melin@iki.fi>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/intel_display.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b20d501..5f1eb50 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7771,9 +7771,9 @@ intel_modeset_check_state(struct drm_device *dev)
 	}
 }
 
-int intel_set_mode(struct drm_crtc *crtc,
-		   struct drm_display_mode *mode,
-		   int x, int y, struct drm_framebuffer *fb)
+static int __intel_set_mode(struct drm_crtc *crtc,
+			    struct drm_display_mode *mode,
+			    int x, int y, struct drm_framebuffer *fb)
 {
 	struct drm_device *dev = crtc->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
@@ -7863,8 +7863,6 @@ done:
 	if (ret && crtc->enabled) {
 		crtc->hwmode = *saved_hwmode;
 		crtc->mode = *saved_mode;
-	} else {
-		intel_modeset_check_state(dev);
 	}
 
 out:
@@ -7872,6 +7870,20 @@ out:
 	return ret;
 }
 
+int intel_set_mode(struct drm_crtc *crtc,
+		     struct drm_display_mode *mode,
+		     int x, int y, struct drm_framebuffer *fb)
+{
+	int ret;
+
+	ret = __intel_set_mode(crtc, mode, x, y, fb);
+
+	if (ret == 0)
+		intel_modeset_check_state(crtc->dev);
+
+	return ret;
+}
+
 void intel_crtc_restore_mode(struct drm_crtc *crtc)
 {
 	intel_set_mode(crtc, &crtc->mode, crtc->x, crtc->y, crtc->fb);
@@ -9172,8 +9184,16 @@ void intel_modeset_setup_hw_state(struct drm_device *dev,
 	}
 
 	if (force_restore) {
+		/*
+		 * We need to use raw interfaces for restoring state to avoid
+		 * checking (bogus) intermediate states.
+		 */
 		for_each_pipe(pipe) {
-			intel_crtc_restore_mode(dev_priv->pipe_to_crtc_mapping[pipe]);
+			struct drm_crtc *crtc =
+				dev_priv->pipe_to_crtc_mapping[pipe];
+
+			__intel_set_mode(crtc, &crtc->mode, crtc->x, crtc->y,
+					 crtc->fb);
 		}
 
 		i915_redisable_vga(dev);
-- 
1.7.10.4

