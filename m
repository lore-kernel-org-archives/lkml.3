Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3HEUpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:45:53 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50945 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab3HEUpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:45:49 -0400
Date: Mon, 5 Aug 2013 22:45:54 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Furquan Shaikh <furquan@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Josh Triplett <josh.triplett@intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ronald Minnich <rminnich@google.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: add fast boot support for Haswell
Message-ID: <20130805204554.GR22035@phenom.ffwll.local>
Mail-Followup-To: Furquan Shaikh <furquan@google.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Josh Triplett <josh.triplett@intel.com>,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Ronald Minnich <rminnich@google.com>,
	Daniel Vetter <daniel.vetter@intel.com>
References: <1375391542-21936-1-git-send-email-furquan@google.com>
 <20130805072421.GV22035@phenom.ffwll.local>
 <CAEGmHFHW2RuUrU9kj_ds8iXNfVLe209qPNifNQ-0TzM0Xa+V+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEGmHFHW2RuUrU9kj_ds8iXNfVLe209qPNifNQ-0TzM0Xa+V+g@mail.gmail.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Now without the confidential header which shouldn't have spilled to
public lists, please reply to this one here.]

On Mon, Aug 05, 2013 at 01:24:15PM -0700, Furquan Shaikh wrote:
> We tested the submitted patch on several systems here and it seems to be
> working fine. So, I'm not sure I understand your comment. Can you please
> provide more details?

You check for the bit DP_PLL_FREQ_160MHZ in the register DP_A when
calculating the reference frequence for port A eDP panels (i.e. the
assignement of pipe_config->port_clock). This bit is valid on port A
for ivb, snb & ilk, but not on hsw. Haswell has a complete new way for
assigning the pll to the port. For solid fastboot support I think we
need to support them all (i.e. also the hdmi wrpll clocks and while at
it we might as well write the fdi dotclock readout code, it should be
almost the same as the DP dotclock computation).
-Daniel

> 
> Thanks,
> Furquan
> 
> 
> On Mon, Aug 5, 2013 at 12:24 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > On Thu, Aug 01, 2013 at 02:12:22PM -0700, Furquan Shaikh wrote:
> > > Enables getting correct mode clock when reading pipe config
> > >
> > > Signed-off-by: Furquan Shaikh <furquan@google.com>
> > > ---
> > >  drivers/gpu/drm/i915/intel_ddi.c     | 8 ++++++++
> > >  drivers/gpu/drm/i915/intel_display.c | 9 ++++++++-
> > >  2 files changed, 16 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/i915/intel_ddi.c
> > b/drivers/gpu/drm/i915/intel_ddi.c
> > > index 931b4bb..fa0af9b 100644
> > > --- a/drivers/gpu/drm/i915/intel_ddi.c
> > > +++ b/drivers/gpu/drm/i915/intel_ddi.c
> > > @@ -1269,6 +1269,7 @@ static void intel_ddi_get_config(struct
> > intel_encoder *encoder,
> > >       struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
> > >       struct intel_crtc *intel_crtc = to_intel_crtc(encoder->base.crtc);
> > >       enum transcoder cpu_transcoder = intel_crtc->config.cpu_transcoder;
> > > +     int port = intel_ddi_get_encoder_port(encoder);
> > >       u32 temp, flags = 0;
> > >
> > >       temp = I915_READ(TRANS_DDI_FUNC_CTL(cpu_transcoder));
> > > @@ -1282,6 +1283,13 @@ static void intel_ddi_get_config(struct
> > intel_encoder *encoder,
> > >               flags |= DRM_MODE_FLAG_NVSYNC;
> > >
> > >       pipe_config->adjusted_mode.flags |= flags;
> > > +
> > > +     if (port == PORT_A) {
> > > +             if ((I915_READ(DP_A) & DP_PLL_FREQ_MASK) ==
> > DP_PLL_FREQ_160MHZ)
> > > +                     pipe_config->port_clock = 162000;
> > > +             else
> > > +                     pipe_config->port_clock = 270000;
> > > +     }
> >
> > I don't think this works correctly since for DP we have new clocks on
> > haswell, see intel_ddi_pll_mode_set. Also I think it'd be good to go right
> > ahead and implement clock readout support for all hsw clock sources, not
> > just DP.
> > -Daniel
> >
> > >  }
> > >
> > >  static void intel_ddi_destroy(struct drm_encoder *encoder)
> > > diff --git a/drivers/gpu/drm/i915/intel_display.c
> > b/drivers/gpu/drm/i915/intel_display.c
> > > index 3e66f05..681c99a 100644
> > > --- a/drivers/gpu/drm/i915/intel_display.c
> > > +++ b/drivers/gpu/drm/i915/intel_display.c
> > > @@ -7176,6 +7176,8 @@ static void i9xx_crtc_clock_get(struct intel_crtc
> > *crtc,
> > >               pipe_config->pixel_multiplier;
> > >  }
> > >
> > > +#define div_ceil(A, B) ((A)/(B) + ((A)%(B) ? 1 : 0))
> > > +
> > >  static void ironlake_crtc_clock_get(struct intel_crtc *crtc,
> > >                                   struct intel_crtc_config *pipe_config)
> > >  {
> > > @@ -7218,7 +7220,11 @@ static void ironlake_crtc_clock_get(struct
> > intel_crtc *crtc,
> > >               return;
> > >
> > >       clock = ((u64)link_m * (u64)link_freq * (u64)repeat);
> > > -     do_div(clock, link_n);
> > > +     /* This is required because the value comes out to be in fraction
> > > +        (eg. 70699.54). Need to round it up since values are compared in
> > > +        drm_mode_equal
> > > +     */
> > > +     clock = div_ceil(clock, link_n);
> > >
> > >       pipe_config->adjusted_mode.clock = clock;
> > >  }
> > > @@ -9588,6 +9594,7 @@ static void intel_init_display(struct drm_device
> > *dev)
> > >
> > >       if (HAS_DDI(dev)) {
> > >               dev_priv->display.get_pipe_config =
> > haswell_get_pipe_config;
> > > +             dev_priv->display.get_clock = ironlake_crtc_clock_get;
> > >               dev_priv->display.crtc_mode_set = haswell_crtc_mode_set;
> > >               dev_priv->display.crtc_enable = haswell_crtc_enable;
> > >               dev_priv->display.crtc_disable = haswell_crtc_disable;
> > > --
> > > 1.8.3
> > >
> > > _______________________________________________
> > > dri-devel mailing list
> > > dri-devel@lists.freedesktop.org
> > > http://lists.freedesktop.org/mailman/listinfo/dri-devel
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> >

> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx


-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
