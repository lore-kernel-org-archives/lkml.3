Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765547Ab3DJScr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:32:47 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:62297 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3DJScp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130410172717.GA2480@netboy>
References: <20130409172820.GC27612@phenom.ffwll.local>
	<1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
	<20130410115901.GA4502@netboy>
	<20130410120724.GJ27612@phenom.ffwll.local>
	<20130410172717.GA2480@netboy>
Date: Wed, 10 Apr 2013 21:32:43 +0300
X-Google-Sender-Auth: 3m49YwCenBKZ-XVLUncIcrkhuws
Message-ID: <CACraW2pORbuy-OfZq=NANBLzKhPYWXBzFJfzZa+k2SHyuCdqZQ@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: don't check inconsistent modeset state when force-restoring
From: Tomas Melin <tomas.melin@iki.fi>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 10:51 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> v2: Try harder not to create a big patch (Chris).
>
Tested the patch applied to 3.9-rc6. Atleast on my machine that
helped, although once I managed to get the error (but not warning and
call trace as before):
[drm:i9xx_crtc_mode_set] *ERROR* Couldn't find PLL settings for mode!


On Wed, Apr 10, 2013 at 8:27 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> I couldn't see right away how to fix it up, so I just compiled your
> drm-intel-next-queued plus this patch. If I close the netbook's lid
> and open it again, the screen is blank, no backlight, and the machine
> seems to be frozen.

The patch doesn't apply at all to 3.8 since function crtc_restore_mode
is missing and also 3.9-rc6 was quite different.
This version of the patch applies atleast to 3.9-rc6 if you want to test it:

>From 9f498da114cea3d82c291b7090d4441664d7870c Mon Sep 17 00:00:00 2001
From: Tomas Melin <tomas.melin@iki.fi>
Date: Wed, 10 Apr 2013 18:53:42 +0300
Subject: [PATCH] applied patch

---
 drivers/gpu/drm/i915/intel_display.c |   36 +++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c
b/drivers/gpu/drm/i915/intel_display.c
index b20d501..83b11c5 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7771,9 +7771,9 @@ intel_modeset_check_state(struct drm_device *dev)
     }
 }

-int intel_set_mode(struct drm_crtc *crtc,
-           struct drm_display_mode *mode,
-           int x, int y, struct drm_framebuffer *fb)
+static int __intel_set_mode(struct drm_crtc *crtc,
+                struct drm_display_mode *mode,
+                int x, int y, struct drm_framebuffer *fb)
 {
     struct drm_device *dev = crtc->dev;
     drm_i915_private_t *dev_priv = dev->dev_private;
@@ -7863,18 +7863,33 @@ done:
     if (ret && crtc->enabled) {
         crtc->hwmode = *saved_hwmode;
         crtc->mode = *saved_mode;
-    } else {
-        intel_modeset_check_state(dev);
     }

 out:
     kfree(saved_mode);
     return ret;
 }
+int intel_set_mode(struct drm_crtc *crtc,
+             struct drm_display_mode *mode,
+             int x, int y, struct drm_framebuffer *fb)
+{
+    int ret;
+
+    ret = __intel_set_mode(crtc, mode, x, y, fb);
+
+    if (ret == 0)
+        intel_modeset_check_state(crtc->dev);
+
+    return ret;
+}
+
+

 void intel_crtc_restore_mode(struct drm_crtc *crtc)
 {
-    intel_set_mode(crtc, &crtc->mode, crtc->x, crtc->y, crtc->fb);
+    __intel_set_mode(crtc, &crtc->mode, crtc->x, crtc->y, crtc->fb);
+
+    intel_modeset_check_state(crtc->dev);
 }

 #undef for_each_intel_crtc_masked
@@ -9172,8 +9187,15 @@ void intel_modeset_setup_hw_state(struct drm_device *dev,
     }

     if (force_restore) {
+        /*
+         * We need to use raw interfaces for restoring state to avoid
+         * checking (bogus) intermediate states.
+         */
         for_each_pipe(pipe) {
-            intel_crtc_restore_mode(dev_priv->pipe_to_crtc_mapping[pipe]);
+             struct drm_crtc *crtc =
+                 dev_priv->pipe_to_crtc_mapping[pipe];
+            __intel_set_mode(crtc, &crtc->mode, crtc->x, crtc->y,
+                     crtc->fb);
         }

         i915_redisable_vga(dev);
--
1.7.9.5
