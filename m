Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3LQAaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:30:14 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61322 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3LQAaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:30:12 -0500
Date: Mon, 16 Dec 2013 16:29:48 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mm: ptl is not bloated if it fits in pointer
In-Reply-To: <20131216135005.AC5FDE0090@blue.fi.intel.com>
Message-ID: <alpine.LNX.2.00.1312161624440.1658@eggly.anvils>
References: <alpine.LNX.2.00.1312160053530.3066@eggly.anvils> <20131216100446.GT21999@twins.programming.kicks-ass.net> <20131216135005.AC5FDE0090@blue.fi.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013, Kirill A. Shutemov wrote:
> Peter Zijlstra wrote:
> > On Mon, Dec 16, 2013 at 01:04:13AM -0800, Hugh Dickins wrote:
> > > It's silly to force the 64-bit CONFIG_GENERIC_LOCKBREAK architectures
> > > to kmalloc eight bytes for an indirect page table lock: the lock needs
> > > to fit in the space that a pointer to it would occupy, not into an int.
> > 
> > Ah, no. A spinlock is very much assumed to be 32bit, any spinlock that's
> > bigger than that is bloated.
> > 
> > For the page-frame case we do indeed not care about the strict 32bit but
> > more about not being larger than a pointer, however there are already
> > other users.
> > 
> > See for instance include/linux/lockref.h and lib/lockref.c, they very
> > much require the spinlock to be 32bit and the below would break that.

Whoops, yes indeed, I completely missed that BLOATED_SPINLOCKS is being
used for two different purposes, which have two different constraints.

> 
> What about this instead? Smoke-tested.

Excellent: I haven't tested it at all, but this patch looks to me
exactly how it should be done - thanks.

> 
> From d0243ba6bf462a7c0ae4290e1c0dbdae22eaa2a6 Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Mon, 16 Dec 2013 15:36:31 +0200
> Subject: [PATCH] mm: do not allocate page->ptl dynamically, if spinlock_t fits
>  to long
> 
> In struct page we have enough space to fit long-size page->ptl
> there, but we use dynamically-allocated page->ptl if
> size(spinlock_t) > sizeof(int). It hurts 64-bit architectures with
> CONFIG_GENERIC_LOCKBREAK, where sizeof(spinlock_t) == 8, but it
> easily fits into struct page.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  include/linux/lockref.h  | 2 +-
>  include/linux/mm.h       | 6 +++---
>  include/linux/mm_types.h | 3 ++-
>  kernel/bounds.c          | 2 +-
>  mm/memory.c              | 2 +-
>  5 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/lockref.h b/include/linux/lockref.h
> index c8929c3832db..4bfde0e99ed5 100644
> --- a/include/linux/lockref.h
> +++ b/include/linux/lockref.h
> @@ -19,7 +19,7 @@
>  
>  #define USE_CMPXCHG_LOCKREF \
>  	(IS_ENABLED(CONFIG_ARCH_USE_CMPXCHG_LOCKREF) && \
> -	 IS_ENABLED(CONFIG_SMP) && !BLOATED_SPINLOCKS)
> +	 IS_ENABLED(CONFIG_SMP) && SPINLOCK_SIZE <= 4)
>  
>  struct lockref {
>  	union {
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1cedd000cf29..35527173cf50 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1317,7 +1317,7 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
>  #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
>  
>  #if USE_SPLIT_PTE_PTLOCKS
> -#if BLOATED_SPINLOCKS
> +#if ALLOC_SPLIT_PTLOCKS
>  extern bool ptlock_alloc(struct page *page);
>  extern void ptlock_free(struct page *page);
>  
> @@ -1325,7 +1325,7 @@ static inline spinlock_t *ptlock_ptr(struct page *page)
>  {
>  	return page->ptl;
>  }
> -#else /* BLOATED_SPINLOCKS */
> +#else /* ALLOC_SPLIT_PTLOCKS */
>  static inline bool ptlock_alloc(struct page *page)
>  {
>  	return true;
> @@ -1339,7 +1339,7 @@ static inline spinlock_t *ptlock_ptr(struct page *page)
>  {
>  	return &page->ptl;
>  }
> -#endif /* BLOATED_SPINLOCKS */
> +#endif /* ALLOC_SPLIT_PTLOCKS */
>  
>  static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
>  {
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index bd299418a934..494b328c2a61 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -26,6 +26,7 @@ struct address_space;
>  #define USE_SPLIT_PTE_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
>  #define USE_SPLIT_PMD_PTLOCKS	(USE_SPLIT_PTE_PTLOCKS && \
>  		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
> +#define ALLOC_SPLIT_PTLOCKS	(SPINLOCK_SIZE > BITS_PER_LONG/8)
>  
>  /*
>   * Each physical page in the system has a struct page associated with
> @@ -155,7 +156,7 @@ struct page {
>  						 * system if PG_buddy is set.
>  						 */
>  #if USE_SPLIT_PTE_PTLOCKS
> -#if BLOATED_SPINLOCKS
> +#if ALLOC_SPLIT_PTLOCKS
>  		spinlock_t *ptl;
>  #else
>  		spinlock_t ptl;
> diff --git a/kernel/bounds.c b/kernel/bounds.c
> index 5253204afdca..9fd4246b04b8 100644
> --- a/kernel/bounds.c
> +++ b/kernel/bounds.c
> @@ -22,6 +22,6 @@ void foo(void)
>  #ifdef CONFIG_SMP
>  	DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
>  #endif
> -	DEFINE(BLOATED_SPINLOCKS, sizeof(spinlock_t) > sizeof(int));
> +	DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
>  	/* End of constants */
>  }
> diff --git a/mm/memory.c b/mm/memory.c
> index 5d9025f3b3e1..b6e211b779d0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4271,7 +4271,7 @@ void copy_user_huge_page(struct page *dst, struct page *src,
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
>  
> -#if USE_SPLIT_PTE_PTLOCKS && BLOATED_SPINLOCKS
> +#if ALLOC_SPLIT_PTLOCKS
>  bool ptlock_alloc(struct page *page)
>  {
>  	spinlock_t *ptl;
> -- 
>  Kirill A. Shutemov
