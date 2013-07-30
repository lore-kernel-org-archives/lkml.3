Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab3G3Q2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:28:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:64749 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3G3Q2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:28:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,778,1367996400"; 
   d="scan'208";a="373538109"
Date: Tue, 30 Jul 2013 19:28:44 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915: Add async page flip support
 for SNB
Message-ID: <20130730162844.GT5004@intel.com>
References: <CAKMK7uFiL+p48Phwc=jmWtsOgjNOYJzTCWmHe3Bp7-jWMpTtTA@mail.gmail.com>
 <1374790515-29657-1-git-send-email-keithp@keithp.com>
 <1374790515-29657-3-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374790515-29657-3-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 03:15:15PM -0700, Keith Packard wrote:
> Just copies the IVB code
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 166aa2c..4a118c3 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7465,20 +7465,29 @@ static int intel_gen6_queue_flip(struct drm_device *dev,
>  	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
>  	struct intel_ring_buffer *ring = &dev_priv->ring[RCS];
>  	uint32_t pf, pipesrc;
> +	uint32_t cmd;
> +	uint32_t base;
>  	int ret;
>  
>  	ret = intel_pin_and_fence_fb_obj(dev, obj, ring);
>  	if (ret)
>  		goto err;
>  
> +	cmd = MI_DISPLAY_FLIP | MI_DISPLAY_FLIP_PLANE(intel_crtc->plane);
> +	base = i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspaddr_offset;
> +
> +	if (flags & DRM_MODE_PAGE_FLIP_ASYNC) {
> +		cmd |= MI_DISPLAY_FLIP_ASYNC_INDICATOR;
> +		base |= MI_DISPLAY_FLIP_TYPE_ASYNC;
> +	}
> +
>  	ret = intel_ring_begin(ring, 4);
>  	if (ret)
>  		goto err_unpin;
>  
> -	intel_ring_emit(ring, MI_DISPLAY_FLIP |
> -			MI_DISPLAY_FLIP_PLANE(intel_crtc->plane));
> +	intel_ring_emit(ring, cmd);
>  	intel_ring_emit(ring, fb->pitches[0] | obj->tiling_mode);
> -	intel_ring_emit(ring, i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspaddr_offset);
> +	intel_ring_emit(ring, base);
>  
>  	/* Contrary to the suggestions in the documentation,
>  	 * "Enable Panel Fitter" does not seem to be required when page

This PF flip stuff is a bit of a mystery. I'm not sure it exists on SNB
anymore. Some of the docs say that it's MBZ for SNB/IVB. Gen4/5 docs
say that DW3 must not be sent w/ async flips, and some SNB+ docs say
that it must not be sent with either sync or async flips.

Did you test this patch on actual hardware, and if so did it work as
expected? :)

I guess one would need to perform some empirical testing to figure out
what DW3 actually does.

> @@ -9731,7 +9740,7 @@ void intel_modeset_init(struct drm_device *dev)
>  		dev->mode_config.max_height = 8192;
>  	}
>  
> -	if (IS_GEN7(dev))
> +	if (IS_GEN6(dev) || IS_GEN7(dev))
>  		dev->mode_config.async_page_flip = true;
>  
>  	dev->mode_config.fb_base = dev_priv->gtt.mappable_base;
> -- 
> 1.8.3.2
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel OTC
