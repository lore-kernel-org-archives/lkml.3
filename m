Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab3ENPvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:51:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab3ENPvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:51:21 -0400
Date: Tue, 14 May 2013 16:51:17 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tim.c.chen@linux.intel.com
Subject: Re: [RFC][PATCH 5/7] create __remove_mapping_batch()
Message-ID: <20130514155117.GW11497@suse.de>
References: <20130507211954.9815F9D1@viggo.jf.intel.com>
 <20130507212001.49F5E197@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130507212001.49F5E197@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 02:20:01PM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> __remove_mapping_batch() does logically the same thing as
> __remove_mapping().
> 
> We batch like this so that several pages can be freed with a
> single mapping->tree_lock acquisition/release pair.  This reduces
> the number of atomic operations and ensures that we do not bounce
> cachelines around.
> 
> It has shown some substantial performance benefits on
> microbenchmarks.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
> 
>  linux.git-davehans/mm/vmscan.c |   50 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff -puN mm/vmscan.c~create-remove_mapping_batch mm/vmscan.c
> --- linux.git/mm/vmscan.c~create-remove_mapping_batch	2013-05-07 14:00:01.432361260 -0700
> +++ linux.git-davehans/mm/vmscan.c	2013-05-07 14:19:32.341148892 -0700
> @@ -555,6 +555,56 @@ int remove_mapping(struct address_space
>  	return 0;
>  }
>  
> +/*
> + * pages come in here (via remove_list) locked and leave unlocked
> + * (on either ret_pages or free_pages)
> + *
> + * We do this batching so that we free batches of pages with a
> + * single mapping->tree_lock acquisition/release.  This optimization
> + * only makes sense when the pages on remove_list all share a
> + * page->mapping.  If this is violated you will BUG_ON().
> + */
> +static int __remove_mapping_batch(struct list_head *remove_list,
> +				  struct list_head *ret_pages,
> +				  struct list_head *free_pages)
> +{
> +	int nr_reclaimed = 0;
> +	struct address_space *mapping;
> +	struct page *page;
> +	LIST_HEAD(need_free_mapping);
> +
> +	if (list_empty(remove_list))
> +		return 0;
> +
> +	mapping = lru_to_page(remove_list)->mapping;
> +	spin_lock_irq(&mapping->tree_lock);
> +	while (!list_empty(remove_list)) {
> +		int freed;
> +		page = lru_to_page(remove_list);
> +		BUG_ON(!PageLocked(page));
> +		BUG_ON(page->mapping != mapping);
> +		list_del(&page->lru);
> +
> +		freed = __remove_mapping_nolock(mapping, page);

Nit, it's not freed, it's detached but rather than complaining the
ambiguity can be removed with

if (!__remove_mapping_nolock(mapping, page)) {
	unlock_page(page);
	list_add(&page->lru, ret_pages);
	continue;
}

list_add(&page->lru, &need_free_mapping);

The same comments I had before about potentially long page lock hold
times still apply at this point. Andrew's concerns about the worst-case
scenario where no adjacent page on the LRU has the same mapping also
still applies. Is there any noticable overhead with his suggested
workload of a single threaded process that opens files touching one page
in each file until reclaim starts?

This would be easier to review it it was merged with the next patch that
actually uses this function.

-- 
Mel Gorman
SUSE Labs
