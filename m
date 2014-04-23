Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbaDWHuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:50:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:19624 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbaDWHux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:50:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="525937170"
Date: Wed, 23 Apr 2014 10:50:48 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Discard BIOS framebuffers too
 small to accommodate chosen mode
Message-ID: <20140423075048.GX18465@intel.com>
References: <535696DB.2080104@t-online.de>
 <1398200758-26107-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398200758-26107-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:05:58PM +0100, Chris Wilson wrote:
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
> Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=77767
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/gpu/drm/i915/intel_fbdev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
> index b16116db6c37..28220ca838df 100644
> --- a/drivers/gpu/drm/i915/intel_fbdev.c
> +++ b/drivers/gpu/drm/i915/intel_fbdev.c
> @@ -133,6 +133,12 @@ static int intelfb_create(struct drm_fb_helper *helper,
>  
>  	mutex_lock(&dev->struct_mutex);
>  
> +	if (intel_fb &&
> +	    (sizes->fb_width > intel_fb->base.width ||
> +	     sizes->fb_height > intel_fb->base.height)) {
> +		drm_framebuffer_reference(&ifbdev->fb->base);

unreference

I know intel_fb == ifbdev->fb, but still I think it would look a bit
less confusing if you passed &intel_fb->base to
drm_framebuffer_unreference() instead of &ifbdev->fb->base. Simply
because you use intel_fb->base in the size checks just before.

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
