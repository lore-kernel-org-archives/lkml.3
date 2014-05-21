Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaEUNRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:17:20 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57178 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaEUNRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:17:17 -0400
Date: Wed, 21 May 2014 15:17:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: dri-devel@lists.freedesktop.org, robdclark@gmail.com, airlied@gmail.com,
        daniel.vetter@ffwll.ch, hughd@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/gem: remove obsolete BUG_ON
Message-ID: <20140521131712.GG14357@phenom.ffwll.local>
Mail-Followup-To: David Herrmann <dh.herrmann@gmail.com>,
	dri-devel@lists.freedesktop.org, robdclark@gmail.com,
	airlied@gmail.com, hughd@google.com, linux-kernel@vger.kernel.org
References: <1400674586-17968-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400674586-17968-1-git-send-email-dh.herrmann@gmail.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 02:16:26PM +0200, David Herrmann wrote:
> The shmem subsystem supports relocating pages on swap-in in case it was
> loaded into the wrong zone. This was implemented 2 years ago in:
> 
>     commit bde05d1ccd512696b09db9dd2e5f33ad19152605
>     Author: Hugh Dickins <hughd@google.com>
>     Date:   Tue May 29 15:06:38 2012 -0700
> 
>         shmem: replace page if mapping excludes its zone
> 
> If a driver requires pages to be in a specific zone, they _must_ set the
> correct GFP flags (like __GFP_DMA32) in mapping_gfp_mask(mapping). shmem
> will make sure that any page leaving the swap-cache is located in a
> compatible zone.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Imo the BUG_ON is nice since we want to make sure this never blows up. We
have a similar one in i915_gem.c since we do have platforms with 32bit
limits that support more than 4G or ram.

Imo better to update the comment and state that this is fixed now, but
better be paranoid.
-Daniel
> ---
>  drivers/gpu/drm/drm_gem.c | 19 -------------------
>  1 file changed, 19 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 9909bef..a6146ab 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -473,25 +473,6 @@ struct page **drm_gem_get_pages(struct drm_gem_object *obj, gfp_t gfpmask)
>  		if (IS_ERR(p))
>  			goto fail;
>  		pages[i] = p;
> -
> -		/* There is a hypothetical issue w/ drivers that require
> -		 * buffer memory in the low 4GB.. if the pages are un-
> -		 * pinned, and swapped out, they can end up swapped back
> -		 * in above 4GB.  If pages are already in memory, then
> -		 * shmem_read_mapping_page_gfp will ignore the gfpmask,
> -		 * even if the already in-memory page disobeys the mask.
> -		 *
> -		 * It is only a theoretical issue today, because none of
> -		 * the devices with this limitation can be populated with
> -		 * enough memory to trigger the issue.  But this BUG_ON()
> -		 * is here as a reminder in case the problem with
> -		 * shmem_read_mapping_page_gfp() isn't solved by the time
> -		 * it does become a real issue.
> -		 *
> -		 * See this thread: http://lkml.org/lkml/2011/7/11/238
> -		 */
> -		BUG_ON((gfpmask & __GFP_DMA32) &&
> -				(page_to_pfn(p) >= 0x00100000UL));
>  	}
>  
>  	return pages;
> -- 
> 1.9.3
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
