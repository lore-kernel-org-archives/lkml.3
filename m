Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab3FYSXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:23:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:4032 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3FYSXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:23:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="359424343"
Message-ID: <1372184610.7914.96.camel@envy.home>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
From: Darren Hart <dvhart@linux.intel.com>
To: Zhang Yi <wetpzy@gmail.com>
Cc: linux-kernel@vger.kernel.org, "'Mel Gorman'" <mgorman@suse.de>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, zhang.yi20@zte.com.cn
Date: Tue, 25 Jun 2013 11:23:30 -0700
In-Reply-To: <000101ce71a6$a83c5880$f8b50980$@com>
References: <000101ce5174$1962bac0$4c283040$@com>
		 <20130515142035.GD11497@suse.de>
		 <OF1450163D.E6FBE6A2-ON48257B6D.00048ADD-48257B6D.00070A58@zte.com.cn>
		 <519436B7.2050101@linux.intel.com>
		 <OF7A810108.AA9BB6C1-ON48257B6D.000A1424-48257B6D.000B1EC6@zte.com.cn>
	 <1372107737.7914.27.camel@envy.home> <000101ce71a6$a83c5880$f8b50980$@com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhang Yi,

Thanks for turning around an update so quickly. The code itself looks
ready to me. We try to maintain a high level of quality in the commit
message as well to help with understanding complex systems such as
futexes.

On Tue, 2013-06-25 at 21:19 +0800, Zhang Yi wrote:
> The futex-keys of processes share futex determined by page-offset,

"share futex" is rather confusing to me. Maybe:

The futex-key is determined by page-offset, ...

> mapping-host, and mapping-index of the user space address. User
> appications using hugepage for futex may lead to futex-key conflict.

Please take care with spelling. Grammar issues aren't as critical, but
please enable spell checking in your editor.

applications
hugepages for futexes
conflicts

> 
> Assume there are two or more futexes in diffrent normal pages of the

different

> hugepage, and each futex has the same offset in its normal page,
> causing all the futexes have the same futex-key.

then all the futexes will have the same futex-key.

> 
> This patch adds the normal page index in the compound page into
> the pgoff of futex-key.


of the futex_key.

> 
> Steps to reproduce the bug:
> 1. The 1st thread map a file of hugetlbfs, and use the return address

maps
uses

> as the 1st mutex's address, and use the return address with PAGE_SIZE

uses

> added as the 2nd mutex's address.
> 2. The 1st thread initialize the two mutexes with pshared attribute,

initializes
the pshared attribute,

> and lock the two mutexes.

locks

> 3. The 1st thread create the 2nd thread, and the 2nd thread block on

creates
blocks

> the 1st mutex.
> 4. The 1st thread create the 3rd thread, and the 3rd thread block on

creates
blocks

> the 2nd mutex.
> 5. The 1st thread unlock the 2nd mutex, the 3rd thread cannot take

unlocks

> the 2nd mutex, and may block forever.
> 
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
> Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
> 

Otherwise this looks ready to me. Thomas, do you want a resend with
commit message corrections or do you prefer to integrate those 
yourself?

With the above fixes:

Acked-by: Darren Hart <dvhart@linux.intel.com>


> diff -uprN linux-3.10-rc7.org/include/linux/hugetlb.h linux-3.10-rc7/include/linux/hugetlb.h
> --- linux-3.10-rc7.org/include/linux/hugetlb.h	2013-06-22 19:47:31.000000000 +0000
> +++ linux-3.10-rc7/include/linux/hugetlb.h	2013-06-25 09:40:06.256556000 +0000
> @@ -358,6 +358,17 @@ static inline int hstate_index(struct hs
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
>  #else	/* CONFIG_HUGETLB_PAGE */
>  struct hstate {};
>  #define alloc_huge_page_node(h, nid) NULL
> @@ -378,6 +389,11 @@ static inline unsigned int pages_per_hug
>  }
>  #define hstate_index_to_shift(index) 0
>  #define hstate_index(h) 0
> +
> +static inline pgoff_t basepage_index(struct page *page)
> +{
> +	return page->index;
> +}
>  #endif	/* CONFIG_HUGETLB_PAGE */
> 
>  #endif /* _LINUX_HUGETLB_H */
> diff -uprN linux-3.10-rc7.org/kernel/futex.c linux-3.10-rc7/kernel/futex.c
> --- linux-3.10-rc7.org/kernel/futex.c	2013-06-22 19:47:31.000000000 +0000
> +++ linux-3.10-rc7/kernel/futex.c	2013-06-25 09:35:59.615425000 +0000
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
> +		key->shared.pgoff = basepage_index(page);
>  	}
> 
>  	get_futex_key_refs(key);
> diff -uprN linux-3.10-rc7.org/mm/hugetlb.c linux-3.10-rc7/mm/hugetlb.c
> --- linux-3.10-rc7.org/mm/hugetlb.c	2013-06-25 09:38:53.435151000 +0000
> +++ linux-3.10-rc7/mm/hugetlb.c	2013-06-25 09:39:30.375701000 +0000
> @@ -690,6 +690,23 @@ int PageHuge(struct page *page)
>  }
>  EXPORT_SYMBOL_GPL(PageHuge);
> 
> +pgoff_t __basepage_index(struct page *page)
> +{
> +	struct page *page_head = compound_head(page);
> +	pgoff_t index = page_index(page_head);
> +	unsigned long compound_idx;
> +
> +	if (!PageHuge(page_head))
> +		return page_index(page);
> +
> +	if (compound_order(page_head) >= MAX_ORDER)
> +		compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
> +	else
> +		compound_idx = page - page_head;
> +
> +	return (index << compound_order(page_head)) + compound_idx;
> +}
> +
>  static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
>  {
>  	struct page *page;
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

