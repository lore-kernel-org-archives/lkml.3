Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaBXQGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:06:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:11465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaBXQGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:06:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,535,1389772800"; 
   d="scan'208";a="488864111"
Date: Mon, 24 Feb 2014 18:06:28 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: sagar.a.kamble@intel.com
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "G, Pallavi" <pallavi.g@intel.com>
Subject: Re: [PATCH v2 1/1] drm/i915: Enabling 128x128 and 256x256 ARGB
 Cursor Support
Message-ID: <20140224160628.GU3852@intel.com>
References: <20140218131333.GR3852@intel.com>
 <1393256503-32274-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393256503-32274-1-git-send-email-sagar.a.kamble@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 09:11:43PM +0530, sagar.a.kamble@intel.com wrote:
> From: Sagar Kamble <sagar.a.kamble@intel.com>
> 
> With this patch we allow larger cursor planes of sizes 128x128
> and 256x256.
> 
> v2: Added more precise check on size while setting cursor plane.
> 
> Testcase: igt/kms_cursor_crc
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: G, Pallavi <pallavi.g@intel.com>
> Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_reg.h      |  4 ++++
>  drivers/gpu/drm/i915/intel_display.c | 28 +++++++++++++++++++++++-----
>  2 files changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index 2f564ce..2fee3a2 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -3522,7 +3522,11 @@
>  /* New style CUR*CNTR flags */
>  #define   CURSOR_MODE		0x27
>  #define   CURSOR_MODE_DISABLE   0x00
> +#define   CURSOR_MODE_128_32B_AX 0x02
> +#define   CURSOR_MODE_256_32B_AX 0x03
>  #define   CURSOR_MODE_64_32B_AX 0x07
> +#define   CURSOR_MODE_128_ARGB_AX ((1 << 5) | CURSOR_MODE_128_32B_AX)
> +#define   CURSOR_MODE_256_ARGB_AX ((1 << 5) | CURSOR_MODE_256_32B_AX)
>  #define   CURSOR_MODE_64_ARGB_AX ((1 << 5) | CURSOR_MODE_64_32B_AX)
>  #define   MCURSOR_PIPE_SELECT	(1 << 28)
>  #define   MCURSOR_PIPE_A	0x00
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index f19e6ea..d036b41 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7411,10 +7411,18 @@ static void i9xx_update_cursor(struct drm_crtc *crtc, u32 base)
>  	bool visible = base != 0;
>  
>  	if (intel_crtc->cursor_visible != visible) {
> +		int16_t width = intel_crtc->cursor_width;
>  		uint32_t cntl = I915_READ(CURCNTR(pipe));
>  		if (base) {
>  			cntl &= ~(CURSOR_MODE | MCURSOR_PIPE_SELECT);
> -			cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +
> +			if (width == 64)
> +				cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +			else if (width == 128)
> +				cntl |= CURSOR_MODE_128_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +			else if (width == 256)
> +				cntl |= CURSOR_MODE_256_ARGB_AX | MCURSOR_GAMMA_ENABLE;

A switch statement might be a bit clearer.

> +
>  			cntl |= pipe << 28; /* Connect to correct pipe */
>  		} else {
>  			cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
> @@ -7439,10 +7447,17 @@ static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
>  	bool visible = base != 0;
>  
>  	if (intel_crtc->cursor_visible != visible) {
> +		int16_t width = intel_crtc->cursor_width;
>  		uint32_t cntl = I915_READ(CURCNTR_IVB(pipe));
>  		if (base) {
>  			cntl &= ~CURSOR_MODE;
> -			cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +
> +			if (width == 64)
> +				cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +			else if (width == 128)
> +				cntl |= CURSOR_MODE_128_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +			else if (width == 256)
> +				cntl |= CURSOR_MODE_256_ARGB_AX | MCURSOR_GAMMA_ENABLE;

ditto.

>  		} else {
>  			cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
>  			cntl |= CURSOR_MODE_DISABLE;
> @@ -7538,9 +7553,12 @@ static int intel_crtc_cursor_set(struct drm_crtc *crtc,
>  		goto finish;
>  	}
>  
> -	/* Currently we only support 64x64 cursors */
> -	if (width != 64 || height != 64) {
> -		DRM_ERROR("we currently only support 64x64 cursors\n");
> +	/* Check for which cursor types we support */
> +	if ((!(width == 64 && height == 64) && IS_GEN2(dev)) ||
> +	    (!(width == 64 && height == 64)
> +	     && !(width == 128 && height == 128)
> +	     && !(width == 256 && height == 256))) {

I'd make this something like:

if (!((width == 64 && height == 64) ||
      (width == 128 && height == 128 && !IS_GEN2(dev)) ||
      (width == 256 && height == 256 && !IS_GEN2(dev))))

> +		DRM_ERROR("Cursor dimension is not supported\n");

Should be DRM_DEBUG() or something. Otherwise the user can spam dmesg
by just issuing invalid cursor ioctls.

I see we have a bunch of other DRM_ERROR()s for similar stuff in the
cursor code. Those should be converted to debugs as well. Maybe you
can whip together another patch for that?

>  		return -EINVAL;
>  	}
>  
> -- 
> 1.8.5
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Ville Syrjälä
Intel OTC
