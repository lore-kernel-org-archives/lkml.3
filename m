Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab3JOPlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759381Ab3JOPl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:41:29 -0400
Date: Tue, 15 Oct 2013 11:41:04 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: x86, perf: throttling issues with long nmi latencies
Message-ID: <20131015154104.GA227855@redhat.com>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143227.GY26785@twins.programming.kicks-ass.net>
 <20131015150736.GZ26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015150736.GZ26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 05:07:36PM +0200, Peter Zijlstra wrote:
> On Tue, Oct 15, 2013 at 04:32:27PM +0200, Peter Zijlstra wrote:
> > 
> > This one seems to actually work and is somewhat simpler.

Hey Peter,

Your previous patch made a huge difference in improvement.  The
copy_from_user_nmi() no longer hits the million of cycles.  I still have a
batch of 100,000-300,000 cycles.  My longest NMI paths used to be
dominated by copy_from_user_nmi, now it is not (I have to dig up the new
hot path).

I'll try your patch below to see if it removes the last of the
copy_from_user_nmi issues.

As expected the perf throttling takes longer for it to throttle down to
1000 samples per second (60 seconds vs 10 seconds). :-)

I have to give up the machine for the afternoon, but I will respond with
how the latest patch works and hopefully figure out the new hottest path
(somewhere above the for-loop in handle_irq).

Thanks!

Cheers,
Don

> 
> And here's some hackery to avoid that atomic page inc frobbery.
> 
> ---
>  lib/usercopy.c |   12 ++++++++--
>  mm/gup.c       |   63 ++++++++++++++++++++++++++++++++++++---------------------
>  2 files changed, 49 insertions(+), 26 deletions(-)
> 
> --- a/arch/x86/lib/usercopy.c
> +++ b/arch/x86/lib/usercopy.c
> @@ -10,6 +10,8 @@
>  #include <asm/word-at-a-time.h>
>  #include <linux/sched.h>
>  
> +extern int ___get_user_pages_fast(unsigned long start, int nr_pages, int flags,
> +			  struct page **pages);
>  /*
>   * best effort, GUP based copy_from_user() that is NMI-safe
>   */
> @@ -18,6 +20,7 @@ copy_from_user_nmi(void *to, const void
>  {
>  	unsigned long offset, addr = (unsigned long)from;
>  	unsigned long size, len = 0;
> +	unsigned long flags;
>  	struct page *page;
>  	void *map;
>  	int ret;
> @@ -26,9 +29,12 @@ copy_from_user_nmi(void *to, const void
>  		return len;
>  
>  	do {
> -		ret = __get_user_pages_fast(addr, 1, 0, &page);
> -		if (!ret)
> +		local_irq_save(flags);
> +		ret = ___get_user_pages_fast(addr, 1, 0, &page);
> +		if (!ret) {
> +			local_irq_restore(flags);
>  			break;
> +		}
>  
>  		offset = addr & (PAGE_SIZE - 1);
>  		size = min(PAGE_SIZE - offset, n - len);
> @@ -36,7 +42,7 @@ copy_from_user_nmi(void *to, const void
>  		map = kmap_atomic(page);
>  		memcpy(to, map+offset, size);
>  		kunmap_atomic(map);
> -		put_page(page);
> +		local_irq_restore(flags);
>  
>  		len  += size;
>  		to   += size;
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -63,19 +63,22 @@ static inline pte_t gup_get_pte(pte_t *p
>  #endif
>  }
>  
> +#define GUPF_GET	0x01
> +#define GUPF_WRITE	0x02
> +
>  /*
>   * The performance critical leaf functions are made noinline otherwise gcc
>   * inlines everything into a single function which results in too much
>   * register pressure.
>   */
>  static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
> -		unsigned long end, int write, struct page **pages, int *nr)
> +		unsigned long end, int flags, struct page **pages, int *nr)
>  {
>  	unsigned long mask;
>  	pte_t *ptep;
>  
>  	mask = _PAGE_PRESENT|_PAGE_USER;
> -	if (write)
> +	if (flags & GUPF_WRITE)
>  		mask |= _PAGE_RW;
>  
>  	ptep = pte_offset_map(&pmd, addr);
> @@ -89,7 +92,8 @@ static noinline int gup_pte_range(pmd_t
>  		}
>  		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  		page = pte_page(pte);
> -		get_page(page);
> +		if (flags & GUPF_GET)
> +			get_page(page);
>  		SetPageReferenced(page);
>  		pages[*nr] = page;
>  		(*nr)++;
> @@ -109,7 +113,7 @@ static inline void get_head_page_multipl
>  }
>  
>  static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
> -		unsigned long end, int write, struct page **pages, int *nr)
> +		unsigned long end, int flags, struct page **pages, int *nr)
>  {
>  	unsigned long mask;
>  	pte_t pte = *(pte_t *)&pmd;
> @@ -117,7 +121,7 @@ static noinline int gup_huge_pmd(pmd_t p
>  	int refs;
>  
>  	mask = _PAGE_PRESENT|_PAGE_USER;
> -	if (write)
> +	if (flags & GUPF_WRITE)
>  		mask |= _PAGE_RW;
>  	if ((pte_flags(pte) & mask) != mask)
>  		return 0;
> @@ -131,19 +135,20 @@ static noinline int gup_huge_pmd(pmd_t p
>  	do {
>  		VM_BUG_ON(compound_head(page) != head);
>  		pages[*nr] = page;
> -		if (PageTail(page))
> +		if ((flags & GUPF_GET) && PageTail(page))
>  			get_huge_page_tail(page);
>  		(*nr)++;
>  		page++;
>  		refs++;
>  	} while (addr += PAGE_SIZE, addr != end);
> -	get_head_page_multiple(head, refs);
> +	if (flags & GUPF_GET)
> +		get_head_page_multiple(head, refs);
>  
>  	return 1;
>  }
>  
>  static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
> -		int write, struct page **pages, int *nr)
> +		int flags, struct page **pages, int *nr)
>  {
>  	unsigned long next;
>  	pmd_t *pmdp;
> @@ -167,10 +172,10 @@ static int gup_pmd_range(pud_t pud, unsi
>  		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
>  			return 0;
>  		if (unlikely(pmd_large(pmd))) {
> -			if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
> +			if (!gup_huge_pmd(pmd, addr, next, flags, pages, nr))
>  				return 0;
>  		} else {
> -			if (!gup_pte_range(pmd, addr, next, write, pages, nr))
> +			if (!gup_pte_range(pmd, addr, next, flags, pages, nr))
>  				return 0;
>  		}
>  	} while (pmdp++, addr = next, addr != end);
> @@ -179,7 +184,7 @@ static int gup_pmd_range(pud_t pud, unsi
>  }
>  
>  static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
> -		unsigned long end, int write, struct page **pages, int *nr)
> +		unsigned long end, int flags, struct page **pages, int *nr)
>  {
>  	unsigned long mask;
>  	pte_t pte = *(pte_t *)&pud;
> @@ -187,7 +192,7 @@ static noinline int gup_huge_pud(pud_t p
>  	int refs;
>  
>  	mask = _PAGE_PRESENT|_PAGE_USER;
> -	if (write)
> +	if (flags & GUPF_WRITE)
>  		mask |= _PAGE_RW;
>  	if ((pte_flags(pte) & mask) != mask)
>  		return 0;
> @@ -201,19 +206,20 @@ static noinline int gup_huge_pud(pud_t p
>  	do {
>  		VM_BUG_ON(compound_head(page) != head);
>  		pages[*nr] = page;
> -		if (PageTail(page))
> +		if ((flags & GUPF_GET) && PageTail(page))
>  			get_huge_page_tail(page);
>  		(*nr)++;
>  		page++;
>  		refs++;
>  	} while (addr += PAGE_SIZE, addr != end);
> -	get_head_page_multiple(head, refs);
> +	if (flags & GUPF_GET)
> +		get_head_page_multiple(head, refs);
>  
>  	return 1;
>  }
>  
>  static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
> -			int write, struct page **pages, int *nr)
> +			int flags, struct page **pages, int *nr)
>  {
>  	unsigned long next;
>  	pud_t *pudp;
> @@ -226,10 +232,10 @@ static int gup_pud_range(pgd_t pgd, unsi
>  		if (pud_none(pud))
>  			return 0;
>  		if (unlikely(pud_large(pud))) {
> -			if (!gup_huge_pud(pud, addr, next, write, pages, nr))
> +			if (!gup_huge_pud(pud, addr, next, flags, pages, nr))
>  				return 0;
>  		} else {
> -			if (!gup_pmd_range(pud, addr, next, write, pages, nr))
> +			if (!gup_pmd_range(pud, addr, next, flags, pages, nr))
>  				return 0;
>  		}
>  	} while (pudp++, addr = next, addr != end);
> @@ -241,13 +247,12 @@ static int gup_pud_range(pgd_t pgd, unsi
>   * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
>   * back to the regular GUP.
>   */
> -int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
> +int ___get_user_pages_fast(unsigned long start, int nr_pages, int flags,
>  			  struct page **pages)
>  {
>  	struct mm_struct *mm = current->mm;
>  	unsigned long addr, len, end;
>  	unsigned long next;
> -	unsigned long flags;
>  	pgd_t *pgdp;
>  	int nr = 0;
>  
> @@ -255,7 +260,7 @@ int __get_user_pages_fast(unsigned long
>  	addr = start;
>  	len = (unsigned long) nr_pages << PAGE_SHIFT;
>  	end = start + len;
> -	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
> +	if (unlikely(!access_ok((flags & GUPF_WRITE) ? VERIFY_WRITE : VERIFY_READ,
>  					(void __user *)start, len)))
>  		return 0;
>  
> @@ -277,7 +282,6 @@ int __get_user_pages_fast(unsigned long
>  	 * (which we do on x86, with the above PAE exception), we can follow the
>  	 * address down to the the page and take a ref on it.
>  	 */
> -	local_irq_save(flags);
>  	pgdp = pgd_offset(mm, addr);
>  	do {
>  		pgd_t pgd = *pgdp;
> @@ -285,14 +289,27 @@ int __get_user_pages_fast(unsigned long
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_none(pgd))
>  			break;
> -		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
> +		if (!gup_pud_range(pgd, addr, next, flags, pages, &nr))
>  			break;
>  	} while (pgdp++, addr = next, addr != end);
> -	local_irq_restore(flags);
>  
>  	return nr;
>  }
>  
> +int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
> +			  struct page **pages)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	local_irq_save(flags);
> +	ret = ___get_user_pages_fast(start, nr_pages,
> +			GUPF_GET | (write ? GUPF_WRITE : 0), pages);
> +	local_irq_restore(flags);
> +
> +	return ret;
> +}
> +
>  /**
>   * get_user_pages_fast() - pin user pages in memory
>   * @start:	starting user address
