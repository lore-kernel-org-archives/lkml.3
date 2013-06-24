Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3FXRJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:09:18 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:35706 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3FXRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:09:16 -0400
Date: Mon, 24 Jun 2013 19:09:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: dri-devel@lists.freedesktop.org, chris@chris-wilson.co.uk,
        imre.deak@intel.com, daniel.vetter@ffwll.ch, airlied@linux.ie,
        airlied@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: make compact dma scatter lists creation work
 with SWIOTLB backend.
Message-ID: <20130624170912.GH5823@phenom.ffwll.local>
Mail-Followup-To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	dri-devel@lists.freedesktop.org, chris@chris-wilson.co.uk,
	imre.deak@intel.com, airlied@linux.ie, airlied@gmail.com,
	linux-kernel@vger.kernel.org
References: <1372088868-23477-1-git-send-email-konrad.wilk@oracle.com>
 <1372088868-23477-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372088868-23477-2-git-send-email-konrad.wilk@oracle.com>
X-Operating-System: Linux phenom 3.10.0-rc5+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 11:47:48AM -0400, Konrad Rzeszutek Wilk wrote:
> Git commit 90797e6d1ec0dfde6ba62a48b9ee3803887d6ed4
> ("drm/i915: create compact dma scatter lists for gem objects") makes
> certain assumptions about the under laying DMA API that are not always
> correct.
> 
> On a ThinkPad X230 with an Intel HD 4000 with Xen during the bootup
> I see:
> 
> [drm:intel_pipe_set_base] *ERROR* pin & fence failed
> [drm:intel_crtc_set_config] *ERROR* failed to set mode on [CRTC:3], err = -28
> 
> Bit of debugging traced it down to dma_map_sg failing (in
> i915_gem_gtt_prepare_object) as some of the SG entries were huge (3MB).
> 
> That unfortunately are sizes that the SWIOTLB is incapable of handling -
> the maximum it can handle is a an entry of 512KB of virtual contiguous
> memory for its bounce buffer. (See IO_TLB_SEGSIZE).
> 
> Previous to the above mention git commit the SG entries were of 4KB, and
> the code introduced by above git commit squashed the CPU contiguous PFNs
> in one big virtual address provided to DMA API.
> 
> This patch is a simple semi-revert - were we emulate the old behavior
> if we detect that SWIOTLB is online. If it is not online then we continue
> on with the new compact scatter gather mechanism.
> 
> An alternative solution would be for the the '.get_pages' and the
> i915_gem_gtt_prepare_object to retry with smaller max gap of the
> amount of PFNs that can be combined together - but with this issue
> discovered during rc7 that might be too risky.
> 
> Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CC: Chris Wilson <chris@chris-wilson.co.uk>
> CC: Imre Deak <imre.deak@intel.com>
> CC: Daniel Vetter <daniel.vetter@ffwll.ch>
> CC: David Airlie <airlied@linux.ie>
> CC: <dri-devel@lists.freedesktop.org>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Two things:

- SWIOTLB usage should seriously blow up all over the place in drm/i915.
  We really rely on the everywhere else true fact that the pages and their
  dma mapping point at the same backing storage.

- How is this solved elsewhere when constructing sg tables? Or are we
  really the only guys who try to construct such big sg entries? I
  expected somewhat that the dma mapping backed would fill in the segment
  limits accordingly, but I haven't found anything really on a quick
  search.


Cheers, Daniel

> ---
>  drivers/gpu/drm/i915/i915_gem.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 970ad17..7045f45 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -1801,7 +1801,14 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
>  			gfp |= __GFP_NORETRY | __GFP_NOWARN | __GFP_NO_KSWAPD;
>  			gfp &= ~(__GFP_IO | __GFP_WAIT);
>  		}
> -
> +#ifdef CONFIG_SWIOTLB
> +		if (swiotlb_nr_tbl()) {
> +			st->nents++;
> +			sg_set_page(sg, page, PAGE_SIZE, 0);
> +			sg = sg_next(sg);
> +			continue;
> +		}
> +#endif
>  		if (!i || page_to_pfn(page) != last_pfn + 1) {
>  			if (i)
>  				sg = sg_next(sg);
> @@ -1812,8 +1819,10 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
>  		}
>  		last_pfn = page_to_pfn(page);
>  	}
> -
> -	sg_mark_end(sg);
> +#ifdef CONFIG_SWIOTLB
> +	if (!swiotlb_nr_tbl())
> +#endif
> +		sg_mark_end(sg);
>  	obj->pages = st;
>  
>  	if (i915_gem_object_needs_bit17_swizzle(obj))
> -- 
> 1.8.1.4
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
