Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3HEHYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:24:17 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54662 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3HEHYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:24:15 -0400
Date: Mon, 5 Aug 2013 09:24:21 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Furquan Shaikh <furquan@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Josh Triplett <josh.triplett@intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ronald Minnich <rminnich@google.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] drm/i915: add fast boot support for Haswell
Message-ID: <20130805072421.GV22035@phenom.ffwll.local>
Mail-Followup-To: Furquan Shaikh <furquan@google.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Josh Triplett <josh.triplett@intel.com>,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Ronald Minnich <rminnich@google.com>,
	Daniel Vetter <daniel.vetter@intel.com>
References: <1375391542-21936-1-git-send-email-furquan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375391542-21936-1-git-send-email-furquan@google.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 02:12:22PM -0700, Furquan Shaikh wrote:
> Enables getting correct mode clock when reading pipe config
> 
> Signed-off-by: Furquan Shaikh <furquan@google.com>
> ---
>  drivers/gpu/drm/i915/intel_ddi.c     | 8 ++++++++
>  drivers/gpu/drm/i915/intel_display.c | 9 ++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
> index 931b4bb..fa0af9b 100644
> --- a/drivers/gpu/drm/i915/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/intel_ddi.c
> @@ -1269,6 +1269,7 @@ static void intel_ddi_get_config(struct intel_encoder *encoder,
>  	struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
>  	struct intel_crtc *intel_crtc = to_intel_crtc(encoder->base.crtc);
>  	enum transcoder cpu_transcoder = intel_crtc->config.cpu_transcoder;
> +	int port = intel_ddi_get_encoder_port(encoder);
>  	u32 temp, flags = 0;
>  
>  	temp = I915_READ(TRANS_DDI_FUNC_CTL(cpu_transcoder));
> @@ -1282,6 +1283,13 @@ static void intel_ddi_get_config(struct intel_encoder *encoder,
>  		flags |= DRM_MODE_FLAG_NVSYNC;
>  
>  	pipe_config->adjusted_mode.flags |= flags;
> +
> +	if (port == PORT_A) {
> +		if ((I915_READ(DP_A) & DP_PLL_FREQ_MASK) == DP_PLL_FREQ_160MHZ)
> +			pipe_config->port_clock = 162000;
> +		else
> +			pipe_config->port_clock = 270000;
> +	}

I don't think this works correctly since for DP we have new clocks on
haswell, see intel_ddi_pll_mode_set. Also I think it'd be good to go right
ahead and implement clock readout support for all hsw clock sources, not
just DP.
-Daniel

>  }
>  
>  static void intel_ddi_destroy(struct drm_encoder *encoder)
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 3e66f05..681c99a 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7176,6 +7176,8 @@ static void i9xx_crtc_clock_get(struct intel_crtc *crtc,
>  		pipe_config->pixel_multiplier;
>  }
>  
> +#define div_ceil(A, B) ((A)/(B) + ((A)%(B) ? 1 : 0))
> +
>  static void ironlake_crtc_clock_get(struct intel_crtc *crtc,
>  				    struct intel_crtc_config *pipe_config)
>  {
> @@ -7218,7 +7220,11 @@ static void ironlake_crtc_clock_get(struct intel_crtc *crtc,
>  		return;
>  
>  	clock = ((u64)link_m * (u64)link_freq * (u64)repeat);
> -	do_div(clock, link_n);
> +	/* This is required because the value comes out to be in fraction
> +	   (eg. 70699.54). Need to round it up since values are compared in
> +	   drm_mode_equal
> +	*/
> +	clock = div_ceil(clock, link_n);
>  
>  	pipe_config->adjusted_mode.clock = clock;
>  }
> @@ -9588,6 +9594,7 @@ static void intel_init_display(struct drm_device *dev)
>  
>  	if (HAS_DDI(dev)) {
>  		dev_priv->display.get_pipe_config = haswell_get_pipe_config;
> +		dev_priv->display.get_clock = ironlake_crtc_clock_get;
>  		dev_priv->display.crtc_mode_set = haswell_crtc_mode_set;
>  		dev_priv->display.crtc_enable = haswell_crtc_enable;
>  		dev_priv->display.crtc_disable = haswell_crtc_disable;
> -- 
> 1.8.3
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
