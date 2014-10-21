Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaJUIjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:39:02 -0400
Received: from mta-out1.inet.fi ([62.71.2.197]:42984 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaJUIi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:38:57 -0400
Date: Tue, 21 Oct 2014 11:35:48 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 5/6] mm: Provide speculative fault infrastructure
Message-ID: <20141021083548.GA22200@node.dhcp.inet.fi>
References: <20141020215633.717315139@infradead.org>
 <20141020222841.490529442@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020222841.490529442@infradead.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:56:38PM +0200, Peter Zijlstra wrote:
> Provide infrastructure to do a speculative fault (not holding
> mmap_sem).
> 
> The not holding of mmap_sem means we can race against VMA
> change/removal and page-table destruction. We use the SRCU VMA freeing
> to keep the VMA around. We use the VMA seqcount to detect change
> (including umapping / page-table deletion) and we use gup_fast() style
> page-table walking to deal with page-table races.
> 
> Once we've obtained the page and are ready to update the PTE, we
> validate if the state we started the fault with is still valid, if
> not, we'll fail the fault with VM_FAULT_RETRY, otherwise we update the
> PTE and we're done.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  include/linux/mm.h |    2 
>  mm/memory.c        |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 119 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1162,6 +1162,8 @@ int generic_error_remove_page(struct add
>  int invalidate_inode_page(struct page *page);
>  
>  #ifdef CONFIG_MMU
> +extern int handle_speculative_fault(struct mm_struct *mm,
> +			unsigned long address, unsigned int flags);
>  extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  			unsigned long address, unsigned int flags);
>  extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2004,12 +2004,40 @@ struct fault_env {
>  	pte_t entry;
>  	spinlock_t *ptl;
>  	unsigned int flags;
> +	unsigned int sequence;
>  };
>  
>  static bool pte_map_lock(struct fault_env *fe)
>  {
> +	bool ret = false;
> +
> +	if (!(fe->flags & FAULT_FLAG_SPECULATIVE)) {
> +		fe->pte = pte_offset_map_lock(fe->mm, fe->pmd, fe->address, &fe->ptl);
> +		return true;
> +	}
> +
> +	/*
> +	 * The first vma_is_dead() guarantees the page-tables are still valid,
> +	 * having IRQs disabled ensures they stay around, hence the second
> +	 * vma_is_dead() to make sure they are still valid once we've got the
> +	 * lock. After that a concurrent zap_pte_range() will block on the PTL
> +	 * and thus we're safe.
> +	 */
> +	local_irq_disable();
> +	if (vma_is_dead(fe->vma, fe->sequence))
> +		goto out;
> +
>  	fe->pte = pte_offset_map_lock(fe->mm, fe->pmd, fe->address, &fe->ptl);
> -	return true;
> +
> +	if (vma_is_dead(fe->vma, fe->sequence)) {
> +		pte_unmap_unlock(fe->pte, fe->ptl);
> +		goto out;
> +	}
> +
> +	ret = true;
> +out:
> +	local_irq_enable();
> +	return ret;
>  }
>  
>  /*
> @@ -2432,6 +2460,7 @@ static int do_swap_page(struct fault_env
>  	entry = pte_to_swp_entry(fe->entry);
>  	if (unlikely(non_swap_entry(entry))) {
>  		if (is_migration_entry(entry)) {
> +			/* XXX fe->pmd might be dead */
>  			migration_entry_wait(fe->mm, fe->pmd, fe->address);
>  		} else if (is_hwpoison_entry(entry)) {
>  			ret = VM_FAULT_HWPOISON;
> @@ -3357,6 +3386,93 @@ static int __handle_mm_fault(struct mm_s
>  	return handle_pte_fault(&fe);
>  }
>  
> +int handle_speculative_fault(struct mm_struct *mm, unsigned long address, unsigned int flags)
> +{
> +	struct fault_env fe = {
> +		.mm = mm,
> +		.address = address,
> +		.flags = flags | FAULT_FLAG_SPECULATIVE,
> +	};
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +	int dead, seq, idx, ret = VM_FAULT_RETRY;
> +	struct vm_area_struct *vma;
> +
> +	idx = srcu_read_lock(&vma_srcu);
> +	vma = find_vma_srcu(mm, address);
> +	if (!vma)
> +		goto unlock;
> +
> +	/*
> +	 * Validate the VMA found by the lockless lookup.
> +	 */
> +	dead = RB_EMPTY_NODE(&vma->vm_rb);
> +	seq = raw_read_seqcount(&vma->vm_sequence); /* rmb <-> seqlock,vma_rb_erase() */
> +	if ((seq & 1) || dead) /* XXX wait for !&1 instead? */
> +		goto unlock;
> +
> +	if (address < vma->vm_start || vma->vm_end <= address)
> +		goto unlock;
> +
> +	/*
> +	 * We need to re-validate the VMA after checking the bounds, otherwise
> +	 * we might have a false positive on the bounds.
> +	 */
> +	if (read_seqcount_retry(&vma->vm_sequence, seq))
> +		goto unlock;
> +
> +	/*
> +	 * Do a speculative lookup of the PTE entry.
> +	 */
> +	local_irq_disable();
> +	pgd = pgd_offset(mm, address);
> +	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
> +		goto out_walk;
> +
> +	pud = pud_offset(pgd, address);
> +	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
> +		goto out_walk;

pud_huge() too. Or filter out VM_HUGETLB altogether.

BTW, what keeps mm_struct around? It seems we don't take reference during
page fault.

-- 
 Kirill A. Shutemov
