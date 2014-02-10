Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaBJNhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:37:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:1273 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbaBJNdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:33:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,818,1384329600"; 
   d="scan'208";a="472753279"
Date: Mon, 10 Feb 2014 15:32:57 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: sagar.a.kamble@intel.com
Cc: intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH v5 11/11] drm/i915: Calling rotate and
 inverse rotate transformations after clipping
Message-ID: <20140210133257.GK3891@intel.com>
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
 <1392017478-4945-12-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392017478-4945-12-git-send-email-sagar.a.kamble@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:01:18PM +0530, sagar.a.kamble@intel.com wrote:
> From: Sagar Kamble <sagar.a.kamble@intel.com>
> 
> With clipped sprites these transformations are not working. these
> functions transform complete sprite irrespective of clipping present.
> This leads to invisible portion of sprite show up when rotate 180 if
> it was out of visible area before.
> 
> v4: Moved rotate transform for source rectangle after clipping.
> Added rotate and inverse rotate transform for destination rect.

Still NAK.

I just pushed rotation support to my glplane test app [1], and with
with that my rotated clipping code works exactly as intended.

[1] git://gitorious.org/vsyrjala/glplane.git

> 
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Cc: vijay.a.purushothaman@intel.com
> Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
> ---
>  drivers/gpu/drm/i915/intel_sprite.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
> index 62b9f84..799f6a9 100644
> --- a/drivers/gpu/drm/i915/intel_sprite.c
> +++ b/drivers/gpu/drm/i915/intel_sprite.c
> @@ -769,9 +769,6 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
>  	max_scale = intel_plane->max_downscale << 16;
>  	min_scale = intel_plane->can_scale ? 1 : (1 << 16);
>  
> -	drm_rect_rotate(&src, fb->width << 16, fb->height << 16,
> -			intel_plane->rotation);
> -
>  	hscale = drm_rect_calc_hscale_relaxed(&src, &dst, min_scale, max_scale);
>  	BUG_ON(hscale < 0);
>  
> @@ -785,6 +782,13 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
>  	crtc_w = drm_rect_width(&dst);
>  	crtc_h = drm_rect_height(&dst);
>  
> +	drm_rect_rotate(&src, fb->width << 16, fb->height << 16,
> +				intel_plane->rotation);
> +
> +	drm_rect_rotate(&dst, intel_crtc->config.pipe_src_w,
> +				intel_crtc->config.pipe_src_h,
> +				intel_plane->rotation);
> +
>  	if (visible) {
>  		/* check again in case clipping clamped the results */
>  		hscale = drm_rect_calc_hscale(&src, &dst, min_scale, max_scale);
> @@ -811,7 +815,11 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
>  				     drm_rect_height(&dst) * vscale - drm_rect_height(&src));
>  
>  		drm_rect_rotate_inv(&src, fb->width << 16, fb->height << 16,
> -				    intel_plane->rotation);
> +					intel_plane->rotation);
> +
> +		drm_rect_rotate_inv(&dst, intel_crtc->config.pipe_src_w,
> +					intel_crtc->config.pipe_src_h,
> +					intel_plane->rotation);
>  
>  		/* sanity check to make sure the src viewport wasn't enlarged */
>  		WARN_ON(src.x1 < (int) src_x ||
> -- 
> 1.8.5
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel OTC
