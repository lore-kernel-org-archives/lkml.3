Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3GPMGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:06:16 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:40260 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3GPMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:06:14 -0400
Date: Tue, 16 Jul 2013 14:06:14 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: fix long-standing SNB regression in power
 consumption after resume
Message-ID: <20130716120614.GR5784@phenom.ffwll.local>
Mail-Followup-To: Konstantin Khlebnikov <khlebnikov@openvz.org>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <20130714163009.22374.22100.stgit@zurg>
 <20130716063240.GL5784@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716063240.GL5784@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.10.0-rc7+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 08:32:40AM +0200, Daniel Vetter wrote:
> On Sun, Jul 14, 2013 at 08:30:09PM +0400, Konstantin Khlebnikov wrote:
> > This patch fixes regression in power consumtion of sandy bridge gpu, which
> > exists since v3.6 Sometimes after resuming from s2ram gpu starts thinking that
> > it's extremely busy. After that it never reaches rc6 state.
> > 
> > Bug was introduce by commit b4ae3f22d238617ca11610b29fde16cf8c0bc6e0
> > ("drm/i915: load boot context at driver init time"). Without documentation
> > it's not clear what is happening here, probably this breaks internal state of
> > hardware ring buffers and confuses RPS engine. Fortunately keeping forcewake
> > during whole initialization sequence in gen6_init_clock_gating() fixes this bug.
> > 
> > References: https://bugs.freedesktop.org/show_bug.cgi?id=54089
> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=58971
> Tested-by: Alexander Kaltsas <alexkaltsas@gmail.com>
> Tested-by: rocko <rockorequin@hotmail.com>
Tested-by: JohnMB <johnmbryant@sky.com>
> 
> > ---
> >  drivers/gpu/drm/i915/intel_pm.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> > index aa01128..839a43f 100644
> > --- a/drivers/gpu/drm/i915/intel_pm.c
> > +++ b/drivers/gpu/drm/i915/intel_pm.c
> > @@ -3640,6 +3640,8 @@ static void gen6_init_clock_gating(struct drm_device *dev)
> >  	int pipe;
> >  	uint32_t dspclk_gate = ILK_VRHUNIT_CLOCK_GATE_DISABLE;
> >  
> > +	gen6_gt_force_wake_get(dev_priv);
> > +
> >  	I915_WRITE(ILK_DSPCLK_GATE_D, dspclk_gate);
> >  
> >  	I915_WRITE(ILK_DISPLAY_CHICKEN2,
> > @@ -3728,6 +3730,8 @@ static void gen6_init_clock_gating(struct drm_device *dev)
> >  	cpt_init_clock_gating(dev);
> >  
> >  	gen6_check_mch_setup(dev);
> > +
> > +	gen6_gt_force_wake_put(dev_priv);
> >  }
> >  
> >  static void gen7_setup_fixed_func_scheduler(struct drm_i915_private *dev_priv)
> > 
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
