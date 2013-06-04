Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3FDM7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:59:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab3FDM7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:59:43 -0400
Date: Tue, 4 Jun 2013 08:59:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, stable@kernel.org,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [07/65] dm bufio: avoid a possible __vmalloc deadlock
In-Reply-To: <20130603221153.315507011@goodmis.org>
Message-ID: <Pine.LNX.4.64.1306040858060.22591@file.rdu.redhat.com>
References: <20130603221016.243553628@goodmis.org> <20130603221153.315507011@goodmis.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Jun 2013, Steven Rostedt wrote:

> 3.6.11.5 stable review patch.
> If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> [ Upstream commit 502624bdad3dba45dfaacaf36b7d83e39e74b2d2 ]
> 
> This patch uses memalloc_noio_save to avoid a possible deadlock in
> dm-bufio.  (it could happen only with large block size, at most
> PAGE_SIZE << MAX_ORDER (typically 8MiB).
> 
> __vmalloc doesn't fully respect gfp flags. The specified gfp flags are
> used for allocation of requested pages, structures vmap_area, vmap_block
> and vm_struct and the radix tree nodes.
> 
> However, the kernel pagetables are allocated always with GFP_KERNEL.
> Thus the allocation of pagetables can recurse back to the I/O layer and
> cause a deadlock.
> 
> This patch uses the function memalloc_noio_save to set per-process
> PF_MEMALLOC_NOIO flag and the function memalloc_noio_restore to restore
> it. When this flag is set, all allocations in the process are done with
> implied GFP_NOIO flag, thus the deadlock can't happen.
> 
> This should be backported to stable kernels, but they don't have the
> PF_MEMALLOC_NOIO flag and memalloc_noio_save/memalloc_noio_restore
> functions. So, PF_MEMALLOC should be set and restored instead.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@kernel.org
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> [ Set and clear PF_MEMALLOC manually - SR ]
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  drivers/md/dm-bufio.c |   26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index c0fc827..a1f2487 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -321,6 +321,9 @@ static void __cache_size_refresh(void)
>  static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
>  			       enum data_mode *data_mode)
>  {
> +	unsigned noio_flag;
> +	void *ptr;
> +
>  	if (c->block_size <= DM_BUFIO_BLOCK_SIZE_SLAB_LIMIT) {
>  		*data_mode = DATA_MODE_SLAB;
>  		return kmem_cache_alloc(DM_BUFIO_CACHE(c), gfp_mask);
> @@ -334,7 +337,28 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
>  	}
>  
>  	*data_mode = DATA_MODE_VMALLOC;
> -	return __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
> +
> +	/*
> +	 * __vmalloc allocates the data pages and auxiliary structures with
> +	 * gfp_flags that were specified, but pagetables are always allocated
> +	 * with GFP_KERNEL, no matter what was specified as gfp_mask.
> +	 *
> +	 * Consequently, we must set per-process flag PF_MEMALLOC_NOIO so that
> +	 * all allocations done by this process (including pagetables) are done
> +	 * as if GFP_NOIO was specified.
> +	 */
> +
> +	if (gfp_mask & __GFP_NORETRY) {
> +		noio_flag = current->flags;

There should be noio_flag = current->flags & PF_MEMALLOC; because we don't 
want to restore other flags.

> +		current->flags |= PF_MEMALLOC;
> +	}
> +
> +	ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
> +
> +	if (gfp_mask & __GFP_NORETRY)
> +		current->flags = (current->flags & ~PF_MEMALLOC) | noio_flag;
> +
> +	return ptr;
>  }
>  
>  /*
> -- 
> 1.7.10.4

Mikulas
