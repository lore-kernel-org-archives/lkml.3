Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbaDWIYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:24:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:22533 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbaDWIYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:24:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="497915926"
Date: Wed, 23 Apr 2014 11:24:21 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Discard BIOS framebuffers too
 small to accommodate chosen mode
Message-ID: <20140423082421.GE18465@intel.com>
References: <20140423071125.GS10722@phenom.ffwll.local>
 <1398239671-4135-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398239671-4135-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 08:54:31AM +0100, Chris Wilson wrote:
> If the inherited BIOS framebuffer is smaller than the mode selected for
> fbdev, then if we continue to use it then we cause display corruption as
> we do not setup the panel fitter to upscale.
> 
> Regression from commit d978ef14456a38034f6c0e94a794129501f89200
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Fri Mar 7 08:57:51 2014 -0800
> 
>     drm/i915: Wrap the preallocated BIOS framebuffer and preserve for KMS fbcon v12
> 
> v2: Add a debug message to track the discard of the BIOS fb.
> v3: Ville pointed out the difference between ref/unref
> 
> Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=77767
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/intel_fbdev.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
> index b16116db6c37..fbe7941f88c8 100644
> --- a/drivers/gpu/drm/i915/intel_fbdev.c
> +++ b/drivers/gpu/drm/i915/intel_fbdev.c
> @@ -133,6 +133,16 @@ static int intelfb_create(struct drm_fb_helper *helper,
>  
>  	mutex_lock(&dev->struct_mutex);
>  
> +	if (intel_fb &&
> +	    (sizes->fb_width > intel_fb->base.width ||
> +	     sizes->fb_height > intel_fb->base.height)) {
> +		DRM_DEBUG_KMS("BIOS fb too small (%dx%d), we require (%dx%d),"
> +			      " releasing it\n",
> +			      intel_fb->base.width, intel_fb->base.height,
> +			      sizes->fb_width, sizes->fb_height);
> +		drm_framebuffer_unreference(&intel_fb->base);
> +		intel_fb = ifbdev->fb = NULL;
> +	}
>  	if (!intel_fb || WARN_ON(!intel_fb->obj)) {
>  		DRM_DEBUG_KMS("no BIOS fb, allocating a new one\n");
>  		ret = intelfb_alloc(helper, sizes);
> -- 
> 1.9.2
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel OTC
