Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaAJIhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:37:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaAJIg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:36:59 -0500
Date: Fri, 10 Jan 2014 09:36:56 +0100
From: Jan Kara <jack@suse.cz>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, jack@suse.cz,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V4] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
Message-ID: <20140110083656.GC26378@quack.suse.cz>
References: <1389295490-28707-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389295490-28707-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 10-01-14 00:54:50, Raghavendra K T wrote:
> We limit the number of readahead pages to 4k.
> 
> max_sane_readahead returns zero on the cpu having no local memory
> node. Fix that by returning a sanitized number of pages viz.,
> minimum of (requested pages, 4k, number of local free pages)
> 
> Result:
> fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB testfile
> 32GB* 4G RAM  numa machine ( 12 iterations) yielded
> 
> kernel       Avg        Stddev
> base         7.264      0.56%
> patched      7.285      1.14%
  OK, looks good to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  mm/readahead.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> V4:  incorporated 16MB limit suggested by Linus for readahead and
> fixed transitioning to large readahead anomaly pointed by Andrew Morton with
> Honza's suggestion.
> 
> Test results shows no significant overhead with the current changes.
> 
> (Do I have to break patches into two??)
> 
> Suggestions/Comments please let me know.
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 7cdbb44..2f561a0 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -237,14 +237,30 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
>  	return ret;
>  }
>  
> +#define MAX_REMOTE_READAHEAD   4096UL
>  /*
>   * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
>   * sensible upper limit.
>   */
>  unsigned long max_sane_readahead(unsigned long nr)
>  {
> -	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
> -		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
> +	unsigned long local_free_page;
> +	unsigned long sane_nr;
> +	int nid;
> +
> +	nid = numa_node_id();
> +	sane_nr = min(nr, MAX_REMOTE_READAHEAD);
> +
> +	local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
> +			  + node_page_state(nid, NR_FREE_PAGES);
> +
> +	/*
> +	 * Readahead onto remote memory is better than no readahead when local
> +	 * numa node does not have memory. We sanitize readahead size depending
> +	 * on free memory in the local node but limiting to 4k pages.
> +	 */
> +	return node_present_pages(nid) ?
> +				min(sane_nr, local_free_page / 2) : sane_nr;
>  }
>  
>  /*
> -- 
> 1.7.11.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
