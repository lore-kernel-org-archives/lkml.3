Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3EGPZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:25:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:57573 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab3EGPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:25:03 -0400
Date: Tue, 7 May 2013 17:24:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mel Gorman <mgorman@suse.de>
cc: Zhang Yi <wetpzy@gmail.com>, linux-kernel@vger.kernel.org,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Darren Hart'" <dvhart@linux.intel.com>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Dave Hansen'" <dave.hansen@linux.intel.com>, zhang.yi20@zte.com.cn,
        wetpzy@163.com
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
In-Reply-To: <20130507152007.GA3405@suse.de>
Message-ID: <alpine.LFD.2.02.1305071724190.2863@ionos>
References: <000101ce4277$69df5af0$3d9e10d0$@com> <alpine.LFD.2.02.1304261951300.21884@ionos> <000101ce4b1d$bddec0b0$399c4210$@com> <20130507152007.GA3405@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 May 2013, Mel Gorman wrote:

> On Tue, May 07, 2013 at 08:23:48PM +0800, Zhang Yi wrote:
> > diff -uprN linux3.9-orig/kernel/futex.c linux3.9/kernel/futex.c
> > --- linux3.9-orig/kernel/futex.c	2013-04-15 00:45:16.000000000 +0000
> > +++ linux3.9/kernel/futex.c	2013-05-06 16:24:40.403525000 +0000
> > @@ -215,6 +215,22 @@ static void drop_futex_key_refs(union fu
> >  	}
> >  }
> > 
> > +/*
> > +* Get subpage index in compound page, and add it into futex_key.
> > +*/
> > +static void key_add_compound_idx(union futex_key *key,
> > +				 struct page *head_page, struct page *page)
> > +{
> > +	int compound_idx;
> > +
> > +	if (compound_order(head_page) >= MAX_ORDER)
> > +		compound_idx = page_to_pfn(page) - page_to_pfn(head_page);
> > +	else
> > +		compound_idx = page - head_page;
> > +
> > +	key->both.offset |= compound_idx << PAGE_SHIFT;
> > +}
> > +
> 
> This implicitely assumies it is dealing with a hugetlbfs page. Today, it
> is the case that an inode-based futex with PageCompound is a hugetlbfs
> page but that could change in the future if THP ever backs files. This
> would then break again except it would be harder to fix because THP pages
> can be collapsed underneath you after the futex key has been generated.
> 
> As this problem is hugetlbfs-specific should the fix be firmly in hugetlbfs
> land? Something like the following untested and only partial diff? Is the
> use of PageCompound in the futex path like this going to be problematic?

Why should it ?
 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 16e4e9a..f9c33d3 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -348,6 +348,17 @@ static inline int hstate_index(struct hstate *h)
>  	return h - hstates;
>  }
>  
> +pgoff_t __basepage_index(struct page *page);
> +
> +/* Return page->index in PAGE_SIZE units */
> +static inline pgoff_t basepage_index(struct page *page)
> +{
> +	if (!PageCompound(page))
> +		return page->index;
> +
> +	return __basepage_index(page);
> +}
> +
>  #else
>  struct hstate {};
>  #define alloc_huge_page_node(h, nid) NULL
> @@ -365,6 +376,10 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
>  {
>  	return 1;
>  }
> +static inline pgoff_t basepage_index(struct page *page)
> +{
> +	return page->index;
> +}
>  #define hstate_index_to_shift(index) 0
>  #define hstate_index(h) 0
>  #endif
> diff --git a/kernel/futex.c b/kernel/futex.c
> index b26dcfc..97beb5d 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -61,6 +61,7 @@
>  #include <linux/nsproxy.h>
>  #include <linux/ptrace.h>
>  #include <linux/sched/rt.h>
> +#include <linux/hugetlb.h>
>  
>  #include <asm/futex.h>
>  
> @@ -365,7 +366,7 @@ again:
>  	} else {
>  		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
>  		key->shared.inode = page_head->mapping->host;
> -		key->shared.pgoff = page_head->index;
> +		key->shared.pgoff = basepage_index(page_head);

  That want's to be  basepage_index(page), right ?

>  	}
>  
>  	get_futex_key_refs(key);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1a12f5b..ddbad35 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -690,6 +690,23 @@ int PageHuge(struct page *page)
>  }
>  EXPORT_SYMBOL_GPL(PageHuge);
>  
> +pgoff_t __basepage_index(struct page *page)
> +{
> +	struct page *page_head = compound_head(page);
> +	pgoff_t index = page_index(page_head);
> +	int compound_idx;
> +
> +	if (!PageHuge(page_head))
> +		return page_index(page);
> +
> +	if (compound_order(page_head) >= MAX_ORDER)
> +		compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
> +	else
> +		compound_idx = page - head_page;
> +
> +	return (index << page_hstate(page_head)->order) + compound_idx;
> +}
> +
>  static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
>  {
>  	struct page *page;
> 
