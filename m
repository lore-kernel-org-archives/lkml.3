Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3JaOED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:04:03 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33813 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab3JaOEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:04:01 -0400
Date: Thu, 31 Oct 2013 10:01:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.8 79/81] fs: buffer: move allocation failure loop into
 the allocator
Message-ID: <20131031140116.GC14054@cmpxchg.org>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
 <1383069882-11437-80-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383069882-11437-80-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix was tagged as a reminder for a bigger series, please don't
apply for now.

On Tue, Oct 29, 2013 at 11:04:40AM -0700, Kamal Mostafa wrote:
> 3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> commit 84235de394d9775bfaa7fa9762a59d91fef0c1fc upstream.
> 
> Buffer allocation has a very crude indefinite loop around waking the
> flusher threads and performing global NOFS direct reclaim because it can
> not handle allocation failures.
> 
> The most immediate problem with this is that the allocation may fail due
> to a memory cgroup limit, where flushers + direct reclaim might not make
> any progress towards resolving the situation at all.  Because unlike the
> global case, a memory cgroup may not have any cache at all, only
> anonymous pages but no swap.  This situation will lead to a reclaim
> livelock with insane IO from waking the flushers and thrashing unrelated
> filesystem cache in a tight loop.
> 
> Use __GFP_NOFAIL allocations for buffers for now.  This makes sure that
> any looping happens in the page allocator, which knows how to
> orchestrate kswapd, direct reclaim, and the flushers sensibly.  It also
> allows memory cgroups to detect allocations that can't handle failure
> and will allow them to ultimately bypass the limit if reclaim can not
> make progress.
> 
> Reported-by: azurIt <azurit@pobox.sk>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  fs/buffer.c     | 14 ++++++++++++--
>  mm/memcontrol.c |  2 ++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 7a75c3e..be83882 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -965,9 +965,19 @@ grow_dev_page(struct block_device *bdev, sector_t block,
>  	struct buffer_head *bh;
>  	sector_t end_block;
>  	int ret = 0;		/* Will call free_more_memory() */
> +	gfp_t gfp_mask;
>  
> -	page = find_or_create_page(inode->i_mapping, index,
> -		(mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
> +	gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
> +	gfp_mask |= __GFP_MOVABLE;
> +	/*
> +	 * XXX: __getblk_slow() can not really deal with failure and
> +	 * will endlessly loop on improvised global reclaim.  Prefer
> +	 * looping in the allocator rather than here, at least that
> +	 * code knows what it's doing.
> +	 */
> +	gfp_mask |= __GFP_NOFAIL;
> +
> +	page = find_or_create_page(inode->i_mapping, index, gfp_mask);
>  	if (!page)
>  		return ret;
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6b7ff19..b150e66f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2614,6 +2614,8 @@ done:
>  	return 0;
>  nomem:
>  	*ptr = NULL;
> +	if (gfp_mask & __GFP_NOFAIL)
> +		return 0;
>  	return -ENOMEM;
>  bypass:
>  	*ptr = root_mem_cgroup;
> -- 
> 1.8.1.2
> 
