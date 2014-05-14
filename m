Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaENENt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 00:13:49 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61769 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaENENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 00:13:48 -0400
Date: Tue, 13 May 2014 21:12:28 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jianyu Zhan <nasa4836@gmail.com>
cc: akpm@linux-foundation.org, mgorman@suse.de, sasha.levin@oracle.com,
        zhangyanfei@cn.fujitsu.com, oleg@redhat.com, fabf@skynet.be,
        cldu@marvell.com, iamjoonsoo.kim@lge.com, n-horiguchi@ah.jp.nec.com,
        kirill.shutemov@linux.intel.com, schwidefsky@de.ibm.com,
        gorcunov@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: use a light-weight __mod_zone_page_state in
 mlocked_vma_newpage()
In-Reply-To: <1399917481-28917-1-git-send-email-nasa4836@gmail.com>
Message-ID: <alpine.LSU.2.11.1405132100260.4154@eggly.anvils>
References: <1399917481-28917-1-git-send-email-nasa4836@gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Jianyu Zhan wrote:

> Andrew, since the previous patch
> 
>  [PATCH 1/3] mm: add comment for __mod_zone_page_stat
> 
> is updated, update this one accordingly.
> 
> -----<8-----
> From 9701fbdb3f9e7730b89780a5bf22effd1580cf35 Mon Sep 17 00:00:00 2001
> From: Jianyu Zhan <nasa4836@gmail.com>
> Date: Tue, 13 May 2014 01:48:01 +0800
> Subject: [PATCH] mm: fold mlocked_vma_newpage() into its only call site
> 
> In previous commit(mm: use the light version __mod_zone_page_state in
> mlocked_vma_newpage()) a irq-unsafe __mod_zone_page_state is used.
> And as suggested by Andrew, to reduce the risks that new call sites
> incorrectly using mlocked_vma_newpage() without knowing they are adding
> racing, this patch folds mlocked_vma_newpage() into its only call site,
> page_add_new_anon_rmap, to make it open-cocded for people to know what
> is going on.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Suggested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Acked-by: Hugh Dickins <hughd@google.com>

Yes, much better, thanks: you made and commented the __ change in the
previous patch, and now you just do the move.  I'd have probably moved
the VM_BUG_ON_PAGE(PageLRU,) up to the top of page_add_new_anon_rmap(),
where we already document some expectations on entry (or else removed it
completely, given that lru_cache_add() does the same); but that's a nit,
no need to make further change now.

> ---
>  mm/internal.h | 29 -----------------------------
>  mm/rmap.c     | 20 +++++++++++++++++---
>  2 files changed, 17 insertions(+), 32 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index d6a4868..29f3dc8 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -184,31 +184,6 @@ static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
>  }
>  
>  /*
> - * Called only in fault path, to determine if a new page is being
> - * mapped into a LOCKED vma.  If it is, mark page as mlocked.
> - */
> -static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
> -				    struct page *page)
> -{
> -	VM_BUG_ON_PAGE(PageLRU(page), page);
> -
> -	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
> -		return 0;
> -
> -	if (!TestSetPageMlocked(page)) {
> -		/*
> -		 * We use the irq-unsafe __mod_zone_page_stat because
> -		 * this counter is not modified from interrupt context, and the
> -		 * pte lock is held(spinlock), which implies preemption disabled.
> -		 */
> -		__mod_zone_page_state(page_zone(page), NR_MLOCK,
> -				    hpage_nr_pages(page));
> -		count_vm_event(UNEVICTABLE_PGMLOCKED);
> -	}
> -	return 1;
> -}
> -
> -/*
>   * must be called with vma's mmap_sem held for read or write, and page locked.
>   */
>  extern void mlock_vma_page(struct page *page);
> @@ -250,10 +225,6 @@ extern unsigned long vma_address(struct page *page,
>  				 struct vm_area_struct *vma);
>  #endif
>  #else /* !CONFIG_MMU */
> -static inline int mlocked_vma_newpage(struct vm_area_struct *v, struct page *p)
> -{
> -	return 0;
> -}
>  static inline void clear_page_mlock(struct page *page) { }
>  static inline void mlock_vma_page(struct page *page) { }
>  static inline void mlock_migrate_page(struct page *new, struct page *old) { }
> diff --git a/mm/rmap.c b/mm/rmap.c
> index fa73194..386b78f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1029,11 +1029,25 @@ void page_add_new_anon_rmap(struct page *page,
>  	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
>  			hpage_nr_pages(page));
>  	__page_set_anon_rmap(page, vma, address, 1);
> -	if (!mlocked_vma_newpage(vma, page)) {
> +
> +	VM_BUG_ON_PAGE(PageLRU(page), page);
> +	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED)) {
>  		SetPageActive(page);
>  		lru_cache_add(page);
> -	} else
> -		add_page_to_unevictable_list(page);
> +		return;
> +	}
> +
> +	if (!TestSetPageMlocked(page)) {
> +		/*
> +		 * We use the irq-unsafe __mod_zone_page_stat because
> +		 * this counter is not modified from interrupt context, and the
> +		 * pte lock is held(spinlock), which implies preemption disabled.
> +		 */
> +		__mod_zone_page_state(page_zone(page), NR_MLOCK,
> +				    hpage_nr_pages(page));
> +		count_vm_event(UNEVICTABLE_PGMLOCKED);
> +	}
> +	add_page_to_unevictable_list(page);
>  }
>  
>  /**
> -- 
> 2.0.0-rc1
