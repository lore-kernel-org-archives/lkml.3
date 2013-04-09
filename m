Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763105Ab3DIRZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:25:25 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36742 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3DIRZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:25:23 -0400
Date: Tue, 9 Apr 2013 19:28:20 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Tomas Melin <tomas.melin@iki.fi>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: Re: drm/i915: new warning (regression) in 3.7.10 and 3.8.3
Message-ID: <20130409172820.GC27612@phenom.ffwll.local>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	Tomas Melin <tomas.melin@iki.fi>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
References: <CACraW2rBMfXL_M13DD-qLvmZj55XPykEW-5qcVwViWg9XM00fA@mail.gmail.com>
 <20130409125003.GW2228@phenom.ffwll.local>
 <20130409132135.GC5132@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409132135.GC5132@netboy>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 03:21:35PM +0200, Richard Cochran wrote:
> On Tue, Apr 09, 2013 at 02:50:03PM +0200, Daniel Vetter wrote:
> > 
> > This should be fixed with the above mentioned patch. The issue is that the
> > bios fumbles around with the output configuration behind our backs, so the
> > new paranoid modeset code in 3.7+ freaks out about the state mismatch
> > between sw and hw.
> > 
> > The patch above should detect this situation and undo any bios-induced
> > damage.
> 
> Even with the patch, I still am seeing the issue (in 3.8).

Indeed, there's still a bug there with the state checking. Can you please
test the below patch?

Thanks, Daniel

commit d206df2685801a832a728c7dca13428a6f5bf3ef
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Apr 9 19:25:12 2013 +0200

    drm/i915: don't check inconstent modeset state when force-restoring
    
    It will be only consistent once we've restored all the crtcs. Since a
    bunch of other callers also want to just restore a single crtc, add a
    boolean to disable checking only where it doesn't make sense.
    
    Note that intel_modeset_setup_hw_state already has a call to
    intel_modeset_check_state at the end, so we don't reduce the amount of
    checking.
    
    References: https://lkml.org/lkml/2013/3/16/60
    Cc: Tomas Melin <tomas.melin@iki.fi>
    Cc: Richard Cochran <richardcochran@gmail.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 8809813..1e29201 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7916,9 +7916,9 @@ intel_modeset_check_state(struct drm_device *dev)
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
@@ -8012,8 +8012,6 @@ done:
 	if (ret && crtc->enabled) {
 		crtc->hwmode = *saved_hwmode;
 		crtc->mode = *saved_mode;
-	} else {
-		intel_modeset_check_state(dev);
 	}
 
 out:
@@ -8022,9 +8020,27 @@ out:
 	return ret;
 }
 
-void intel_crtc_restore_mode(struct drm_crtc *crtc)
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
+void intel_crtc_restore_mode(struct drm_crtc *crtc,
+			     bool check)
 {
-	intel_set_mode(crtc, &crtc->mode, crtc->x, crtc->y, crtc->fb);
+	__intel_set_mode(crtc, &crtc->mode, crtc->x, crtc->y, crtc->fb);
+
+	if (check)
+		intel_modeset_check_state(crtc->dev);
 }
 
 #undef for_each_intel_crtc_masked
@@ -9336,7 +9352,7 @@ setup_pipes:
 		for_each_pipe(pipe) {
 			struct drm_crtc *crtc =
 				dev_priv->pipe_to_crtc_mapping[pipe];
-			intel_crtc_restore_mode(crtc);
+			intel_crtc_restore_mode(crtc, false);
 		}
 		list_for_each_entry(plane, &dev->mode_config.plane_list, head)
 			intel_plane_restore(plane);
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 173add1..99b9f09 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2466,7 +2466,7 @@ intel_dp_set_property(struct drm_connector *connector,
 
 done:
 	if (intel_encoder->base.crtc)
-		intel_crtc_restore_mode(intel_encoder->base.crtc);
+		intel_crtc_restore_mode(intel_encoder->base.crtc, true);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index d7bd031..d7b1094 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -540,7 +540,7 @@ struct intel_set_config {
 extern int intel_set_mode(struct drm_crtc *crtc, struct drm_display_mode *mode,
 			  int x, int y, struct drm_framebuffer *old_fb);
 extern void intel_modeset_disable(struct drm_device *dev);
-extern void intel_crtc_restore_mode(struct drm_crtc *crtc);
+extern void intel_crtc_restore_mode(struct drm_crtc *crtc, bool check);
 extern void intel_crtc_load_lut(struct drm_crtc *crtc);
 extern void intel_crtc_update_dpms(struct drm_crtc *crtc);
 extern void intel_encoder_destroy(struct drm_encoder *encoder);
diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index ee4a8da..de07bd4 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -942,7 +942,7 @@ intel_hdmi_set_property(struct drm_connector *connector,
 
 done:
 	if (intel_dig_port->base.base.crtc)
-		intel_crtc_restore_mode(intel_dig_port->base.base.crtc);
+		intel_crtc_restore_mode(intel_dig_port->base.base.crtc, true);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index ca2d903..4e80e76 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -666,7 +666,7 @@ static int intel_lvds_set_property(struct drm_connector *connector,
 			 * If the CRTC is enabled, the display will be changed
 			 * according to the new panel fitting mode.
 			 */
-			intel_crtc_restore_mode(crtc);
+			intel_crtc_restore_mode(crtc, true);
 		}
 	}
 
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index f6a9f4a..777d0d4 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2044,7 +2044,7 @@ set_value:
 
 done:
 	if (intel_sdvo->base.base.crtc)
-		intel_crtc_restore_mode(intel_sdvo->base.base.crtc);
+		intel_crtc_restore_mode(intel_sdvo->base.base.crtc, true);
 
 	return 0;
 #undef CHECK_PROPERTY
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 6673726..bbe2925 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1481,7 +1481,7 @@ intel_tv_set_property(struct drm_connector *connector, struct drm_property *prop
 	}
 
 	if (changed && crtc)
-		intel_crtc_restore_mode(crtc);
+		intel_crtc_restore_mode(crtc, true);
 out:
 	return ret;
 }
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
