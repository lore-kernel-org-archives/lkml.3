Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbaLEBjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:39:16 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63820 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaLEBjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:39:15 -0500
Date: Thu, 4 Dec 2014 17:39:11 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: weiyj_lk@163.com
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] drm/i915: Fix missing unlock on error in
 i915_gem_init_hw()
Message-ID: <20141205013911.GA1510@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>, weiyj_lk@163.com,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1417740959-342-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417740959-342-1-git-send-email-weiyj_lk@163.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Yongjun,

On Fri, Dec 05, 2014 at 08:55:59AM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function i915_gem_init_hw()
> in the error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
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

There are other places in i915_gem_init_hw() where it returns without
unlocking the mutex.  Why is it only necessary here and not any of the
other places?

>  	for (i = 0; i < NUM_L3_SLICES(dev); i++)
>  		i915_gem_l3_remap(&dev_priv->ring[RCS], i);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
