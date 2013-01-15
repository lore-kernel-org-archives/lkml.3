Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab3AOXbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:31:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:46728 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933621Ab3AOWwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 119/171] drm/i915: Wait for all pending operations to the fb before disabling the pipe
Date: Tue, 15 Jan 2013 14:44:44 -0800
Message-Id: <20130115224321.935069611@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 0f91128d88bbb8b0a8e7bb93df2c40680871d45a upstream.

During modeset we have to disable the pipe to reconfigure its timings
and maybe its size. Userspace may have queued up command buffers that
depend upon the pipe running in a certain configuration and so the
commands may become confused across the modeset. At the moment, we use a
less than satisfactory kick-scanline-waits should the GPU hang during
the modeset. It should be more reliable to wait for the pending
operations to complete first, even though we still have a window for
userspace to submit a broken command buffer during the modeset.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_display.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2897,16 +2897,14 @@ static void intel_clear_scanline_wait(st
 
 static void intel_crtc_wait_for_pending_flips(struct drm_crtc *crtc)
 {
-	struct drm_i915_gem_object *obj;
-	struct drm_i915_private *dev_priv;
+	struct drm_device *dev = crtc->dev;
 
 	if (crtc->fb == NULL)
 		return;
 
-	obj = to_intel_framebuffer(crtc->fb)->obj;
-	dev_priv = crtc->dev->dev_private;
-	wait_event(dev_priv->pending_flip_queue,
-		   atomic_read(&obj->pending_flip) == 0);
+	mutex_lock(&dev->struct_mutex);
+	intel_finish_fb(crtc->fb);
+	mutex_unlock(&dev->struct_mutex);
 }
 
 static bool intel_crtc_driving_pch(struct drm_crtc *crtc)
@@ -3372,23 +3370,6 @@ static void intel_crtc_disable(struct dr
 	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
 	struct drm_device *dev = crtc->dev;
 
-	/* Flush any pending WAITs before we disable the pipe. Note that
-	 * we need to drop the struct_mutex in order to acquire it again
-	 * during the lowlevel dpms routines around a couple of the
-	 * operations. It does not look trivial nor desirable to move
-	 * that locking higher. So instead we leave a window for the
-	 * submission of further commands on the fb before we can actually
-	 * disable it. This race with userspace exists anyway, and we can
-	 * only rely on the pipe being disabled by userspace after it
-	 * receives the hotplug notification and has flushed any pending
-	 * batches.
-	 */
-	if (crtc->fb) {
-		mutex_lock(&dev->struct_mutex);
-		intel_finish_fb(crtc->fb);
-		mutex_unlock(&dev->struct_mutex);
-	}
-
 	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
 	assert_plane_disabled(dev->dev_private, to_intel_crtc(crtc)->plane);
 	assert_pipe_disabled(dev->dev_private, to_intel_crtc(crtc)->pipe);


