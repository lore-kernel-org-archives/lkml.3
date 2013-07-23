Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3GWF3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:29:04 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48520 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3GWF3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:29:01 -0400
Date: Tue, 23 Jul 2013 07:28:57 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/5] drm/i915: Add async page flip support for IVB
Message-ID: <20130723052856.GD5939@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
References: <1374544202-15496-1-git-send-email-keithp@keithp.com>
 <1374544202-15496-5-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374544202-15496-5-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 06:50:01PM -0700, Keith Packard wrote:
> This adds the necesary register defines for async page flipping
> through the command ring, and then hooks those up for Ivybridge (gen7)
> page flipping.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/i915_reg.h      |  6 ++++++
>  drivers/gpu/drm/i915/intel_display.c | 40 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 44 insertions(+), 2 deletions(-)
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
>  #define MI_ARB_ON_OFF		MI_INSTR(0x08, 0)
>  #define   MI_ARB_ENABLE			(1<<0)
>  #define   MI_ARB_DISABLE		(0<<0)
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index bdb8854..1bcc6b4 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7514,6 +7514,8 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
>  	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
>  	struct intel_ring_buffer *ring = &dev_priv->ring[BCS];
>  	uint32_t plane_bit = 0;
> +	uint32_t cmd;
> +	uint32_t base;
>  	int ret;
>  
>  	ret = intel_pin_and_fence_fb_obj(dev, obj, ring);
> @@ -7536,13 +7538,43 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
>  		goto err_unpin;
>  	}
>  
> +	cmd = MI_DISPLAY_FLIP_I915 | plane_bit;
> +	base = i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspaddr_offset;
> +
> +	if (flags & DRM_MODE_PAGE_FLIP_ASYNC) {
> +
> +		/* XXX check limitations for async flip here */
> +
> +		if (fb->pitches[0] != I915_READ(DSPSTRIDE(intel_crtc->plane))) {
> +			WARN_ONCE(1, "mismatching stride in async plane flip (%d != %d)\n",
> +				  fb->pitches[0], I915_READ(DSPSTRIDE(intel_crtc->plane)));
> +			ret = -EINVAL;
> +			goto err_unpin;
> +		}
> +
> +		if (obj->tiling_mode != I915_TILING_X) {
> +			WARN_ONCE(1, "async plane flip requires X tiling\n");
> +			ret = -EINVAL;
> +			goto err_unpin;
> +		}

Matching tiling modes is actually already a requirement on gen4+ (since
the tiling bit and the linear/tiled offset registers can't be changed with
a MI_DISPLAY_FLIP command). But atm we fail to check that in the common
code, so imo better to move that to there.

We already check for matching strides in common code, so with the tile
check added we could drop this all here.
-Daniel

> +
> +		if ((I915_READ(DSPCNTR(intel_crtc->plane)) & DISPPLANE_TILED) == 0) {
> +			WARN_ONCE(1, "display not currently tiled in async plane flip\n");
> +			ret = -EINVAL;
> +			goto err_unpin;
> +		}
> +		
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
> @@ -9705,6 +9737,10 @@ void intel_modeset_init(struct drm_device *dev)
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
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
