Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab3GZLVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:21:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32902 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206Ab3GZLVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:21:05 -0400
Date: Fri, 26 Jul 2013 13:20:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/18] sched: Set preferred NUMA node based on number of
 private faults
Message-ID: <20130726112050.GJ27075@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-16-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373901620-2021-16-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 04:20:17PM +0100, Mel Gorman wrote:
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index cacc64a..04c9469 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -37,14 +37,15 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
>  
>  static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
>  		unsigned long addr, unsigned long end, pgprot_t newprot,
> -		int dirty_accountable, int prot_numa, bool *ret_all_same_node)
> +		int dirty_accountable, int prot_numa, bool *ret_all_same_nidpid)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	pte_t *pte, oldpte;
>  	spinlock_t *ptl;
>  	unsigned long pages = 0;
> -	bool all_same_node = true;
> +	bool all_same_nidpid = true;
>  	int last_nid = -1;
> +	int last_pid = -1;
>  
>  	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
>  	arch_enter_lazy_mmu_mode();
> @@ -64,10 +65,17 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
>  				page = vm_normal_page(vma, addr, oldpte);
>  				if (page) {
>  					int this_nid = page_to_nid(page);
> +					int nidpid = page_nidpid_last(page);
> +					int this_pid = nidpid_to_pid(nidpid);
> +
>  					if (last_nid == -1)
>  						last_nid = this_nid;
> -					if (last_nid != this_nid)
> -						all_same_node = false;
> +					if (last_pid == -1)
> +						last_pid = this_pid;
> +					if (last_nid != this_nid ||
> +					    last_pid != this_pid) {
> +						all_same_nidpid = false;
> +					}

At this point I would've expected something like:

		int nidpid = page_nidpid_last(page);
		int thisnid = nidpid_to_nid(nidpid);
		int thispid = nidpit_to_pid(nidpit);

It seems 'weird' to mix the state like you did; is there a reason the
above is incorrect?

>  
>  					if (!pte_numa(oldpte)) {
>  						ptent = pte_mknuma(ptent);
> @@ -106,7 +114,7 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
>  	arch_leave_lazy_mmu_mode();
>  	pte_unmap_unlock(pte - 1, ptl);
>  
> -	*ret_all_same_node = all_same_node;
> +	*ret_all_same_nidpid = all_same_nidpid;
>  	return pages;
>  }
>  
> @@ -133,7 +141,7 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
>  	pmd_t *pmd;
>  	unsigned long next;
>  	unsigned long pages = 0;
> -	bool all_same_node;
> +	bool all_same_nidpid;
>  
>  	pmd = pmd_offset(pud, addr);
>  	do {
> @@ -151,7 +159,7 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
>  		if (pmd_none_or_clear_bad(pmd))
>  			continue;
>  		pages += change_pte_range(vma, pmd, addr, next, newprot,
> -				 dirty_accountable, prot_numa, &all_same_node);
> +				 dirty_accountable, prot_numa, &all_same_nidpid);
>  
>  		/*
>  		 * If we are changing protections for NUMA hinting faults then
> @@ -159,7 +167,7 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
>  		 * node. This allows a regular PMD to be handled as one fault
>  		 * and effectively batches the taking of the PTL
>  		 */
> -		if (prot_numa && all_same_node)
> +		if (prot_numa && all_same_nidpid)
>  			change_pmd_protnuma(vma->vm_mm, addr, pmd);
>  	} while (pmd++, addr = next, addr != end);
>  

Hurmph I just stumbled upon this PMD 'trick' and I'm not at all sure I
like it. If an application would pre-fault/initialize its memory with
the main thread we'll collapse it into a PMDs and forever thereafter (by
virtue of do_pmd_numa_page()) they'll all stay the same. Resulting in
PMD granularity.

It seems possible that concurrent faults can break it up, but the window
is tiny so I don't expect to actually see that happening.

In any case, this thing needs comments; both here in mprotect and near
do_pmu_numa_page().
