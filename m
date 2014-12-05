Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaLENVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:21:23 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39152 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaLENVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:21:21 -0500
Date: Fri, 5 Dec 2014 14:21:50 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: weiyj_lk@163.com
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH -next] drm/i915: Fix missing unlock on error
 in i915_gem_init_hw()
Message-ID: <20141205132150.GK20350@phenom.ffwll.local>
Mail-Followup-To: weiyj_lk@163.com, Daniel Vetter <daniel.vetter@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1417740959-342-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417740959-342-1-git-send-email-weiyj_lk@163.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 08:55:59AM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function i915_gem_init_hw()
> in the error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks for the patch. Two minor comments:
- Please mention the commit that introduced the issue next time around.
  I've added that while applying.

- The usual patter is

	if (ret)
		goto out;


	/* more code */

out:
	mutex_unlock();
	return ret;

This would work really well in i915_gem_init_hw and besides the
code-cleanup also prevents such a fumble in the future. If you feel like
please submit that patch to convert init_hw to this shared unlock code
pattern, too.

Thanks, Daniel
> ---
>  drivers/gpu/drm/i915/i915_gem.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index d2ba315..3eeb2d0 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -4879,8 +4879,10 @@ i915_gem_init_hw(struct drm_device *dev)
>  	i915_gem_init_swizzling(dev);
>  
>  	ret = dev_priv->gt.init_rings(dev);
> -	if (ret)
> +	if (ret) {
> +		mutex_unlock(&dev->struct_mutex);
>  		return ret;
> +	}
>  
>  	for (i = 0; i < NUM_L3_SLICES(dev); i++)
>  		i915_gem_l3_remap(&dev_priv->ring[RCS], i);
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx


-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
