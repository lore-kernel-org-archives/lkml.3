Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3G3Qmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:42:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:54511 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab3G3QmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:42:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,778,1367996400"; 
   d="scan'208";a="378459366"
Date: Tue, 30 Jul 2013 19:42:19 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm/i915: Add async page flip support for IVB
Message-ID: <20130730164218.GU5004@intel.com>
References: <CAKMK7uFiL+p48Phwc=jmWtsOgjNOYJzTCWmHe3Bp7-jWMpTtTA@mail.gmail.com>
 <1374790515-29657-1-git-send-email-keithp@keithp.com>
 <1374790515-29657-2-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374790515-29657-2-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 03:15:14PM -0700, Keith Packard wrote:
> This adds the necesary register defines for async page flipping
> through the command ring, and then hooks those up for Ivybridge (gen7)
> page flipping.

Maybe mention hsw in the patch subject/description too.

> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/i915_reg.h      |  6 ++++++
>  drivers/gpu/drm/i915/intel_display.c | 37 ++++++++++++++++++++++++++++++++----
>  2 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index dc3d6a7..029cfb0 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -209,6 +209,7 @@
>  #define MI_LOAD_SCAN_LINES_INCL MI_INSTR(0x12, 0)
>  #define MI_DISPLAY_FLIP		MI_INSTR(0x14, 2)
>  #define MI_DISPLAY_FLIP_I915	MI_INSTR(0x14, 1)
> +#define   MI_DISPLAY_FLIP_ASYNC_INDICATOR	(1 << 22)
>  #define   MI_DISPLAY_FLIP_PLANE(n) ((n) << 20)
>  /* IVB has funny definitions for which plane to flip. */
>  #define   MI_DISPLAY_FLIP_IVB_PLANE_A  (0 << 19)
> @@ -217,6 +218,11 @@
>  #define   MI_DISPLAY_FLIP_IVB_SPRITE_B (3 << 19)
>  #define   MI_DISPLAY_FLIP_IVB_PLANE_C  (4 << 19)
>  #define   MI_DISPLAY_FLIP_IVB_SPRITE_C (5 << 19)
> +/* These go in the bottom of the base address value */
> +#define   MI_DISPLAY_FLIP_TYPE_SYNC    (0 << 0)
> +#define   MI_DISPLAY_FLIP_TYPE_ASYNC   (1 << 0)
> +#define   MI_DISPLAY_FLIP_TYPE_STEREO  (2 << 0)
> +#define   MI_DISPLAY_FLIP_TYPE_SYNCHRONOUS	(0 << 0)

Duplicated bit.

>  #define MI_ARB_ON_OFF		MI_INSTR(0x08, 0)
>  #define   MI_ARB_ENABLE			(1<<0)
>  #define   MI_ARB_DISABLE		(0<<0)
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index bdb8854..166aa2c 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1833,8 +1833,10 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev,
>  			alignment = 64 * 1024;
>  		break;
>  	case I915_TILING_X:
> -		/* pin() will align the object as required by fence */
> -		alignment = 0;
> +		/* Async page flipping requires X tiling and 32kB alignment, so just
> +		 * make all X tiled frame buffers aligned for that
> +		 */
> +		alignment = 32 * 1024;

You could limit this to gens for which you implemented async flips.

gen2/3 seem to require a 256KB alignment for async flips.

>  		break;
>  	case I915_TILING_Y:
>  		/* Despite that we check this in framebuffer_init userspace can
> @@ -7514,6 +7516,8 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
>  	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
>  	struct intel_ring_buffer *ring = &dev_priv->ring[BCS];
>  	uint32_t plane_bit = 0;
> +	uint32_t cmd;
> +	uint32_t base;
>  	int ret;
>  
>  	ret = intel_pin_and_fence_fb_obj(dev, obj, ring);
> @@ -7536,13 +7540,21 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
>  		goto err_unpin;
>  	}
>  
> +	cmd = MI_DISPLAY_FLIP_I915 | plane_bit;
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
> -	intel_ring_emit(ring, MI_DISPLAY_FLIP_I915 | plane_bit);
> +	intel_ring_emit(ring, cmd);
>  	intel_ring_emit(ring, (fb->pitches[0] | obj->tiling_mode));
> -	intel_ring_emit(ring, i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspaddr_offset);
> +	intel_ring_emit(ring, base);
>  	intel_ring_emit(ring, (MI_NOOP));
>  
>  	intel_mark_page_flip_active(intel_crtc);
> @@ -7591,6 +7603,19 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc,
>  	     fb->pitches[0] != crtc->fb->pitches[0]))
>  		return -EINVAL;
>  
> +	/* Check tiling restrictions specific to asynchronous flips
> +	 */
> +	if (page_flip_flags & DRM_MODE_PAGE_FLIP_ASYNC) {
> +
> +		/* New FB must be X tiled */
> +		if (obj->tiling_mode != I915_TILING_X)
> +			return -EINVAL;
> +
> +		/* Current FB must be X tiled */
> +		if (to_intel_framebuffer(old_fb)->obj->tiling_mode != I915_TILING_X)
> +			return -EINVAL;
> +	}
> +
>  	work = kzalloc(sizeof *work, GFP_KERNEL);
>  	if (work == NULL)
>  		return -ENOMEM;
> @@ -9705,6 +9730,10 @@ void intel_modeset_init(struct drm_device *dev)
>  		dev->mode_config.max_width = 8192;
>  		dev->mode_config.max_height = 8192;
>  	}
> +
> +	if (IS_GEN7(dev))
> +		dev->mode_config.async_page_flip = true;
> +
>  	dev->mode_config.fb_base = dev_priv->gtt.mappable_base;
>  
>  	DRM_DEBUG_KMS("%d display pipe%s available.\n",
> -- 
> 1.8.3.2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Ville Syrjälä
Intel OTC
