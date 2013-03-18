Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3CRKXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:23:17 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42166 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3CRKXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:23:15 -0400
Date: Mon, 18 Mar 2013 11:26:00 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Vetter <daniel@ffwll.ch>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915: Use the fixed pixel clock for eDP in
 intel_dp_set_m_n()
Message-ID: <20130318102600.GR9021@phenom.ffwll.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1363102348-16337-1-git-send-email-tiwai@suse.de>
 <1363102348-16337-3-git-send-email-tiwai@suse.de>
 <20130317221203.GI9021@phenom.ffwll.local>
 <s5h8v5lukcz.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8v5lukcz.wl%tiwai@suse.de>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:29:16AM +0100, Takashi Iwai wrote:
> At Sun, 17 Mar 2013 23:12:03 +0100,
> Daniel Vetter wrote:
> > 
> > On Tue, Mar 12, 2013 at 04:32:28PM +0100, Takashi Iwai wrote:
> > > The eDP output on HP Z1 is still broken when X is started even after
> > > fixing the infinite link-train loop.  The regression was introduced in
> > > 3.6 kernel for cleaning up the mode clock handling code in intel_dp.c.
> > > 
> > > In the past, the clock of the reference mode was modified in
> > > intel_dp_mode_fixup() in the case of eDP fixed clock, and this clock was
> > > used for calculating in intel_dp_set_m_n().  This override was removed,
> > > thus the wrong mode clock is used for the calculation, resulting in a
> > > psychedelic smoking output in the end.
> > > 
> > > This patch corrects the clock to be used in the place.
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > 
> > I truly hate this mess of dotclock vs portclock vs. whatever. Can you pls
> > apply a little bikeshed and use the existing intel_edp_target_clock like
> > in ironlake_set_m_n? And if you have the regressing commit a little
> > citation to assign the blame (it's probably me) would be good.
> 
> OK, the revised patch is below.

Picked up for -fixes, thanks for the patch.
-Daniel

> 
> 
> thanks,
> 
> Takashi
> 
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH v2] drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()
> 
> The eDP output on HP Z1 is still broken when X is started even after
> fixing the infinite link-train loop.  The regression was introduced in
> 3.6 kernel for cleaning up the mode clock handling code in intel_dp.c
> by the commit [71244653: drm/i915: adjusted_mode->clock in the dp
> mode_fix].
> 
> In the past, the clock of the reference mode was modified in
> intel_dp_mode_fixup() in the case of eDP fixed clock, and this clock was
> used for calculating in intel_dp_set_m_n().  This override was removed,
> thus the wrong mode clock is used for the calculation, resulting in a
> psychedelic smoking output in the end.
> 
> This patch corrects the clock to be used in the place.
> 
> v1->v2: Use intel_edp_target_clock() for checking eDP fixed clock
> instead of open code as in ironlake_set_m_n().
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/gpu/drm/i915/intel_dp.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 6f728e5..2606811 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -820,6 +820,7 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
>  	struct intel_link_m_n m_n;
>  	int pipe = intel_crtc->pipe;
>  	enum transcoder cpu_transcoder = intel_crtc->cpu_transcoder;
> +	int target_clock;
>  
>  	/*
>  	 * Find the lane count in the intel_encoder private
> @@ -835,13 +836,22 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
>  		}
>  	}
>  
> +	target_clock = mode->clock;
> +	for_each_encoder_on_crtc(dev, crtc, intel_encoder) {
> +		if (intel_encoder->type == INTEL_OUTPUT_EDP) {
> +			target_clock = intel_edp_target_clock(intel_encoder,
> +							      mode);
> +			break;
> +		}
> +	}
> +
>  	/*
>  	 * Compute the GMCH and Link ratios. The '3' here is
>  	 * the number of bytes_per_pixel post-LUT, which we always
>  	 * set up for 8-bits of R/G/B, or 3 bytes total.
>  	 */
>  	intel_link_compute_m_n(intel_crtc->bpp, lane_count,
> -			       mode->clock, adjusted_mode->clock, &m_n);
> +			       target_clock, adjusted_mode->clock, &m_n);
>  
>  	if (IS_HASWELL(dev)) {
>  		I915_WRITE(PIPE_DATA_M1(cpu_transcoder),
> -- 
> 1.8.2
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
