Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaENEA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 00:00:26 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52822 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaENEAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 00:00:24 -0400
Date: Tue, 13 May 2014 20:59:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jianyu Zhan <nasa4836@gmail.com>
cc: cl@linux.com, akpm@linux-foundation.org, riel@redhat.com,
        aarcange@redhat.com, oleg@redhat.com, cldu@marvell.com, fabf@skynet.be,
        sasha.levin@oracle.com, zhangyanfei@cn.fujitsu.com,
        iamjoonsoo.kim@lge.com, n-horiguchi@ah.jp.nec.com,
        kirill.shutemov@linux.intel.com, liwanp@linux.vnet.ibm.com,
        gorcunov@gmail.com, minchan@kernel.org, dave.hansen@linux.intel.com,
        toshi.kani@hp.com, paul.gortmaker@windriver.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/3] mm: add comment for __mod_zone_page_stat
In-Reply-To: <1399912423-25601-1-git-send-email-nasa4836@gmail.com>
Message-ID: <alpine.LSU.2.11.1405132042140.4154@eggly.anvils>
References: <1399912423-25601-1-git-send-email-nasa4836@gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Jianyu Zhan wrote:

> >> This means they guarantee that even they are preemted the vm
> >> counter won't be modified incorrectly.  Because the counter is page-related
> >> (e.g., a new anon page added), and they are exclusively hold the pte lock.
> >
> >But there are multiple pte locks for numerous page. Another process could
> >modify the counter because the pte lock for a different page was
> >available which would cause counter corruption.
> >
> >
> >> So, as you concludes in the other mail that __modd_zone_page_stat
> >> couldn't be used.
> >> in mlocked_vma_newpage, then what qualifies other call sites for using
> >> it, in the same situation?
> 
> Thanks, now everything is clear.
> 
> I've renewed the patch, would you please review it? Thanks!
> 
> ---<8---
> mm: use the light version __mod_zone_page_state in mlocked_vma_newpage()
> 
> mlocked_vma_newpage() is called with pte lock held(a spinlock), which
> implies preemtion disabled, and the vm stat counter is not modified from
> interrupt context, so we need not use an irq-safe mod_zone_page_state() here,
> using a light-weight version __mod_zone_page_state() would be OK.
> 
> This patch also documents __mod_zone_page_state() and some of its
> callsites. The comment above __mod_zone_page_state() is from Hugh
> Dickins, and acked by Christoph.
> 
> Most credits to Hugh and Christoph for the clarification on the usage of
> the __mod_zone_page_state().
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Hugh Dickins <hughd@google.com>

No, I didn't sign it off, just offered some text (which you already
acknowledged graciously).  Andrew, please delete that line, but...

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Acked-by: Hugh Dickins <hughd@google.com>

Yes, this is good - and even better is the version which Andrew
has slipped into mmotm, removing the duplicated comment line from
page_remove_rmap(), and reformatting the comments to fit better.

It is a little random, in that we can easily see other
__mod_zone_page_states to which the same comment could be applied;
but that's okay, please leave it as is, you've made the point enough
to help other people get it, and it would get boring to repeat it more.

Hugh

> ---
>  mm/internal.h |  7 ++++++-
>  mm/rmap.c     | 10 ++++++++++
>  mm/vmstat.c   |  4 +++-
>  3 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 07b6736..53d439e 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -196,7 +196,12 @@ static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
>  		return 0;
>  
>  	if (!TestSetPageMlocked(page)) {
> -		mod_zone_page_state(page_zone(page), NR_MLOCK,
> +		/*
> +		 * We use the irq-unsafe __mod_zone_page_stat because
> +		 * this counter is not modified from interrupt context, and the
> +		 * pte lock is held(spinlock), which implies preemtion disabled.
> +		 */
> +		__mod_zone_page_state(page_zone(page), NR_MLOCK,
>  				    hpage_nr_pages(page));
>  		count_vm_event(UNEVICTABLE_PGMLOCKED);
>  	}
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9c3e773..2fa4375 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -986,6 +986,11 @@ void do_page_add_anon_rmap(struct page *page,
>  {
>  	int first = atomic_inc_and_test(&page->_mapcount);
>  	if (first) {
> +		/*
> +		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
> +		 * these counters are not modified in interrupt context, and
> +		 * pte lock(a spinlock) is held, which implies preemtion disabled.
> +		 */
>  		if (PageTransHuge(page))
>  			__inc_zone_page_state(page,
>  					      NR_ANON_TRANSPARENT_HUGEPAGES);
> @@ -1077,6 +1082,11 @@ void page_remove_rmap(struct page *page)
>  	/*
>  	 * Hugepages are not counted in NR_ANON_PAGES nor NR_FILE_MAPPED
>  	 * and not charged by memcg for now.
> +	 *
> +	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
> +	 * these counters are not modified in interrupt context, and
> +	 * these counters are not modified in interrupt context, and
> +	 * pte lock(a spinlock) is held, which implies preemtion disabled.
>  	 */
>  	if (unlikely(PageHuge(page)))
>  		goto out;
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 302dd07..704928e 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -207,7 +207,9 @@ void set_pgdat_percpu_threshold(pg_data_t *pgdat,
>  }
>  
>  /*
> - * For use when we know that interrupts are disabled.
> + * For use when we know that interrupts are disabled,
> + * or when we know that preemption is disabled and that
> + * particular counter cannot be updated from interrupt context.
>   */
>  void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
>  				int delta)
> -- 
> 2.0.0-rc1
