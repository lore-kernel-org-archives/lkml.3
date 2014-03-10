Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaCJKF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:05:29 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56853 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaCJKF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:05:27 -0400
Date: Mon, 10 Mar 2014 11:03:21 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: sagar.a.kamble@intel.com
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, "G, Pallavi" <pallavi.g@intel.com>
Subject: Re: [PATCH v3 1/1] drm/i915: Enabling 128x128 and 256x256 ARGB
 Cursor Support
Message-ID: <20140310100321.GA30571@phenom.ffwll.local>
Mail-Followup-To: sagar.a.kamble@intel.com, intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, "G, Pallavi" <pallavi.g@intel.com>
References: <20140224160628.GU3852@intel.com>
 <1394304546-19433-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394304546-19433-1-git-send-email-sagar.a.kamble@intel.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 12:19:06AM +0530, sagar.a.kamble@intel.com wrote:
> From: Sagar Kamble <sagar.a.kamble@intel.com>
> 
> With this patch we allow larger cursor planes of sizes 128x128
> and 256x256.
> 
> v2: Added more precise check on size while setting cursor plane.
> 
> v3: Changes related to restructuring cursor size restrictions
> and DRM_DEBUG usage.
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
>  drivers/gpu/drm/i915/intel_display.c | 36 +++++++++++++++++++++++++++++++-----
>  2 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index 146609a..aee8258 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -3551,7 +3551,11 @@ enum punit_power_well {
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
> index 0868afb..e59e8fd 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7440,10 +7440,22 @@ static void i9xx_update_cursor(struct drm_crtc *crtc, u32 base)
>  	bool visible = base != 0;
>  
>  	if (intel_crtc->cursor_visible != visible) {
> +		int16_t width = intel_crtc->cursor_width;
>  		uint32_t cntl = I915_READ(CURCNTR(pipe));
>  		if (base) {
>  			cntl &= ~(CURSOR_MODE | MCURSOR_PIPE_SELECT);
> -			cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +
> +			switch (width) {
> +				case 64:
> +					cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +					break;

We don't needlessly indent case 64: and the following code. Even with that
this indents a bit too far, so I suggest you extract the width->flags
computation into a little helper and use it in both places. Also please
extract the GAMMA flag, it's something else. Finally please add a default:
case and put a WARN_ON(1) in there, to make sure our code doesn't let
invalid cases slip through.
-Daniel

> +				case 128:
> +					cntl |= CURSOR_MODE_128_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +					break;
> +				case 256:
> +					cntl |= CURSOR_MODE_256_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +					break;
> +			}
>  			cntl |= pipe << 28; /* Connect to correct pipe */
>  		} else {
>  			cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
> @@ -7468,10 +7480,22 @@ static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
>  	bool visible = base != 0;
>  
>  	if (intel_crtc->cursor_visible != visible) {
> +		int16_t width = intel_crtc->cursor_width;
>  		uint32_t cntl = I915_READ(CURCNTR_IVB(pipe));
>  		if (base) {
>  			cntl &= ~CURSOR_MODE;
> -			cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +
> +			switch (width) {
> +				case 64:
> +					cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +					break;
> +				case 128:
> +					cntl |= CURSOR_MODE_128_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +					break;
> +				case 256:
> +					cntl |= CURSOR_MODE_256_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +					break;
> +			}
>  		} else {
>  			cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
>  			cntl |= CURSOR_MODE_DISABLE;
> @@ -7567,9 +7591,11 @@ static int intel_crtc_cursor_set(struct drm_crtc *crtc,
>  		goto finish;
>  	}
>  
> -	/* Currently we only support 64x64 cursors */
> -	if (width != 64 || height != 64) {
> -		DRM_ERROR("we currently only support 64x64 cursors\n");
> +	/* Check for which cursor types we support */
> +	if (!((width == 64 && height == 64) ||
> +			(width == 128 && height == 128 && !IS_GEN2(dev)) ||
> +			(width == 256 && height == 256 && !IS_GEN2(dev)))) {
> +		DRM_DEBUG("Cursor dimension not supported\n");
>  		return -EINVAL;
>  	}
>  
> -- 
> 1.8.5
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
