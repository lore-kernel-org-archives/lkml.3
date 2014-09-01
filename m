Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaIAKCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:02:40 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:50760 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752300AbaIAKCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:02:39 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Mon, 1 Sep 2014 11:02:33 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        Tibor Billes <tbilles@gmx.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Fix lock dropping in
 intel_tv_detect()
Message-ID: <20140901100233.GC11648@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-kernel@vger.kernel.org, Tibor Billes <tbilles@gmx.com>
References: <877g1ndfh5.fsf@intel.com>
 <1409558986-5099-1-git-send-email-ville.syrjala@linux.intel.com>
 <20140901085022.GB11648@nuc-i3427.alporthouse.com>
 <20140901094556.GA4193@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140901094556.GA4193@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 12:45:56PM +0300, Ville Syrjälä wrote:
> On Mon, Sep 01, 2014 at 09:50:22AM +0100, Chris Wilson wrote:
> > diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
> > index 32186a6..a109b7b 100644
> > --- a/drivers/gpu/drm/i915/intel_tv.c
> > +++ b/drivers/gpu/drm/i915/intel_tv.c
> > @@ -1311,6 +1311,7 @@ intel_tv_detect(struct drm_connector *connector, bool force)
> >  {
> >         struct drm_display_mode mode;
> >         struct intel_tv *intel_tv = intel_attached_tv(connector);
> > +       enum drm_connector_status status = connector->status;
> >         int type;
> >  
> >         DRM_DEBUG_KMS("[CONNECTOR:%d:%s] force=%d\n",
> > @@ -1327,17 +1328,20 @@ intel_tv_detect(struct drm_connector *connector, bool force)
> >  
> >                 if (intel_get_load_detect_pipe(connector, &mode, &tmp, &ctx)) {
> >                         type = intel_tv_detect_type(intel_tv, connector);
> > +                       status = type < 0 ?
> > +                               connector_status_disconnected :
> > +                               connector_status_connected;
> > +
> >                         intel_release_load_detect_pipe(connector, &tmp);
> >                 } else
> > -                       return connector_status_unknown;
> > +                       status = connector_status_unknown;
> >  
> >                 drm_modeset_drop_locks(&ctx);
> >                 drm_modeset_acquire_fini(&ctx);
> > -       } else
> > -               return connector->status;
> > +       }
> >  
> > -       if (type < 0)
> > -               return connector_status_disconnected;
> > +       if (status != connector_status_connected)
> > +               return status;
> >  
> >         intel_tv->type = type;
> >         intel_tv_find_better_format(connector);
> 
> With this approach we're going to have to keep the !force else branch
> to avoid populating intel_tv->type with stack garbage. But I suppose
> the resulting code might still be a bit clearer.

Or just set intel_tv->type directly inside

status = intel_tv_detect_type() ?

Hmm. Indeed, we should not be touching them at all for !forced, as type
is only set for forced, and so we can similarly ignore hpd of better
formats.

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 32186a656816..e80eac5e5239 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1169,7 +1169,7 @@ static const struct drm_display_mode reported_modes[] = {
  * \return true if TV is connected.
  * \return false if TV is disconnected.
  */
-static int
+static enum drm_connector_status
 intel_tv_detect_type(struct intel_tv *intel_tv,
                      struct drm_connector *connector)
 {
@@ -1178,10 +1178,10 @@ intel_tv_detect_type(struct intel_tv *intel_tv,
        struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
        struct drm_device *dev = encoder->dev;
        struct drm_i915_private *dev_priv = dev->dev_private;
+       enum drm_connector_status status;
        unsigned long irqflags;
        u32 tv_ctl, save_tv_ctl;
        u32 tv_dac, save_tv_dac;
-       int type;
 
        /* Disable TV interrupts around load detect or we'll recurse */
        if (connector->polled & DRM_CONNECTOR_POLL_HPD) {
@@ -1229,7 +1229,6 @@ intel_tv_detect_type(struct intel_tv *intel_tv,
        intel_wait_for_vblank(intel_tv->base.base.dev,
                              to_intel_crtc(intel_tv->base.base.crtc)->pipe);
 
-       type = -1;
        tv_dac = I915_READ(TV_DAC);
        DRM_DEBUG_KMS("TV detected: %x, %x\n", tv_ctl, tv_dac);
        /*
@@ -1238,18 +1237,19 @@ intel_tv_detect_type(struct intel_tv *intel_tv,
         *  1 0 X svideo
         *  0 0 0 Component
         */
+       status = connector_status_connected;
        if ((tv_dac & TVDAC_SENSE_MASK) == (TVDAC_B_SENSE | TVDAC_C_SENSE)) {
                DRM_DEBUG_KMS("Detected Composite TV connection\n");
-               type = DRM_MODE_CONNECTOR_Composite;
+               intel_tv->type = DRM_MODE_CONNECTOR_Composite;
        } else if ((tv_dac & (TVDAC_A_SENSE|TVDAC_B_SENSE)) == TVDAC_A_SENSE) {
                DRM_DEBUG_KMS("Detected S-Video TV connection\n");
-               type = DRM_MODE_CONNECTOR_SVIDEO;
+               intel_tv->type = DRM_MODE_CONNECTOR_SVIDEO;
        } else if ((tv_dac & TVDAC_SENSE_MASK) == 0) {
                DRM_DEBUG_KMS("Detected Component TV connection\n");
-               type = DRM_MODE_CONNECTOR_Component;
+               intel_tv->type = DRM_MODE_CONNECTOR_Component;
        } else {
                DRM_DEBUG_KMS("Unrecognised TV connection\n");
-               type = -1;
+               status = connector_status_disconnected;
        }
 
        I915_WRITE(TV_DAC, save_tv_dac & ~TVDAC_STATE_CHG_EN);
@@ -1269,7 +1269,7 @@ intel_tv_detect_type(struct intel_tv *intel_tv,
                spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
        }
 
-       return type;
+       return status;
 }
 
 /*
@@ -1309,39 +1309,33 @@ static void intel_tv_find_better_format(struct drm_connector *connector)
 static enum drm_connector_status
 intel_tv_detect(struct drm_connector *connector, bool force)
 {
-       struct drm_display_mode mode;
        struct intel_tv *intel_tv = intel_attached_tv(connector);
-       int type;
+       struct drm_display_mode mode = reported_modes[0];
+       struct intel_load_detect_pipe tmp;
+       struct drm_modeset_acquire_ctx ctx;
+       enum drm_connector_status status;
 
        DRM_DEBUG_KMS("[CONNECTOR:%d:%s] force=%d\n",
                      connector->base.id, connector->name,
                      force);
+       if (!force)
+               return connector->status;
 
-       mode = reported_modes[0];
-
-       if (force) {
-               struct intel_load_detect_pipe tmp;
-               struct drm_modeset_acquire_ctx ctx;
-
-               drm_modeset_acquire_init(&ctx, 0);
-
-               if (intel_get_load_detect_pipe(connector, &mode, &tmp, &ctx)) {
-                       type = intel_tv_detect_type(intel_tv, connector);
-                       intel_release_load_detect_pipe(connector, &tmp);
-               } else
-                       return connector_status_unknown;
+       drm_modeset_acquire_init(&ctx, 0);
 
-               drm_modeset_drop_locks(&ctx);
-               drm_modeset_acquire_fini(&ctx);
+       if (intel_get_load_detect_pipe(connector, &mode, &tmp, &ctx)) {
+               status = intel_tv_detect_type(intel_tv, connector);
+               intel_release_load_detect_pipe(connector, &tmp);
        } else
-               return connector->status;
+               status = connector_status_unknown;
 
-       if (type < 0)
-               return connector_status_disconnected;
+       drm_modeset_drop_locks(&ctx);
+       drm_modeset_acquire_fini(&ctx);
 
-       intel_tv->type = type;
-       intel_tv_find_better_format(connector);
+       if (status != connector
+               return status;
 
+       intel_tv_find_better_format(connector);
        return connector_status_connected;
 }


-- 
Chris Wilson, Intel Open Source Technology Centre
