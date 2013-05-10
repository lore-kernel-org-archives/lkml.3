Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3EJJJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:09:29 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:49684 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751718Ab3EJJJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:09:26 -0400
In-Reply-To: <20130507152007.GA3405@suse.de>
References: <000101ce4277$69df5af0$3d9e10d0$@com> <alpine.LFD.2.02.1304261951300.21884@ionos> <000101ce4b1d$bddec0b0$399c4210$@com> <20130507152007.GA3405@suse.de>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
X-KeepSent: 48CE8C5D:403E463A-48257B67:0031867F;
 type=4; name=$KeepSent
To: Mel Gorman <mgorman@suse.de>
Cc: "'Dave Hansen'" <dave.hansen@linux.intel.com>,
        "'Darren Hart'" <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, wetpzy@163.com,
        Zhang Yi <wetpzy@gmail.com>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF48CE8C5D.403E463A-ON48257B67.0031867F-48257B67.00324443@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Fri, 10 May 2013 17:08:30 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-05-10 17:08:38
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-MAIL: mse01.zte.com.cn r4A98juT095099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mel Gorman <mgorman@suse.de> wrote on 2013/05/07 23:20:07:

>
> Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
>
> On Tue, May 07, 2013 at 08:23:48PM +0800, Zhang Yi wrote:
> > diff -uprN linux3.9-orig/kernel/futex.c linux3.9/kernel/futex.c
> > --- linux3.9-orig/kernel/futex.c   2013-04-15 00:45:16.000000000 +0000
> > +++ linux3.9/kernel/futex.c   2013-05-06 16:24:40.403525000 +0000
> > @@ -215,6 +215,22 @@ static void drop_futex_key_refs(union fu
> >     }
> >  }
> >
> > +/*
> > +* Get subpage index in compound page, and add it into futex_key.
> > +*/
> > +static void key_add_compound_idx(union futex_key *key,
> > +             struct page *head_page, struct page *page)
> > +{
> > +   int compound_idx;
> > +
> > +   if (compound_order(head_page) >= MAX_ORDER)
> > +      compound_idx = page_to_pfn(page) - page_to_pfn(head_page);
> > +   else
> > +      compound_idx = page - head_page;
> > +
> > +   key->both.offset |= compound_idx << PAGE_SHIFT;
> > +}
> > +
>
> This implicitely assumies it is dealing with a hugetlbfs page. Today, it
> is the case that an inode-based futex with PageCompound is a hugetlbfs
> page but that could change in the future if THP ever backs files. This
> would then break again except it would be harder to fix because THP pages
> can be collapsed underneath you after the futex key has been generated.
>
> As this problem is hugetlbfs-specific should the fix be firmly in
hugetlbfs

I think we should do.
Eg, user applications want high performance, they may use DPDK  which using
hugetlbfs.


Should I rework the patch like the following code, and test it?

> land? Something like the following untested and only partial diff? Is the
> use of PageCompound in the futex path like this going to be problematic?
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 16e4e9a..f9c33d3 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -348,6 +348,17 @@ static inline int hstate_index(struct hstate *h)
>     return h - hstates;
>  }
>
> +pgoff_t __basepage_index(struct page *page);
> +
> +/* Return page->index in PAGE_SIZE units */
> +static inline pgoff_t basepage_index(struct page *page)
> +{
> +   if (!PageCompound(page))
> +      return page->index;
> +
> +   return __basepage_index(page);
> +}
> +
>  #else
>  struct hstate {};
>  #define alloc_huge_page_node(h, nid) NULL
> @@ -365,6 +376,10 @@ static inline unsigned int pages_per_huge_page
> (struct hstate *h)
>  {
>     return 1;
>  }
> +static inline pgoff_t basepage_index(struct page *page)
> +{
> +   return page->index;
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
>     } else {
>        key->both.offset |= FUT_OFF_INODE; /* inode-based key */
>        key->shared.inode = page_head->mapping->host;
> -      key->shared.pgoff = page_head->index;
> +      key->shared.pgoff = basepage_index(page_head);
>     }
>
>     get_futex_key_refs(key);
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
> +   struct page *page_head = compound_head(page);
> +   pgoff_t index = page_index(page_head);
> +   int compound_idx;
> +
> +   if (!PageHuge(page_head))
> +      return page_index(page);
> +
> +   if (compound_order(page_head) >= MAX_ORDER)
> +      compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
> +   else
> +      compound_idx = page - head_page;
> +
> +   return (index << page_hstate(page_head)->order) + compound_idx;
> +}
> +
>  static struct page *alloc_fresh_huge_page_node(struct hstate *h, int
nid)
>  {
>     struct page *page;

