Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbaDWHLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:11:33 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:54921 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaDWHLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:11:31 -0400
Date: Wed, 23 Apr 2014 09:11:25 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm/i915: Discard BIOS framebuffers too small to
 accommodate chosen mode
Message-ID: <20140423071125.GS10722@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Knut Petersen <Knut_Petersen@t-online.de>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <535696DB.2080104@t-online.de>
 <1398200758-26107-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398200758-26107-1-git-send-email-chris@chris-wilson.co.uk>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
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
> +		intel_fb = ifbdev->fb = NULL;

Hm, maybe add a
		DRM_DEBUG_KMS("BIOS fb to small, releasing it\n");
here. With or without this is

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> +	}
>  	if (!intel_fb || WARN_ON(!intel_fb->obj)) {
>  		DRM_DEBUG_KMS("no BIOS fb, allocating a new one\n");
>  		ret = intelfb_alloc(helper, sizes);
> -- 
> 1.9.2
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
