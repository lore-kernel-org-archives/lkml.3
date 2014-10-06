Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaJFUxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:53:51 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:43740 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaJFUxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:53:48 -0400
Date: Mon, 6 Oct 2014 13:53:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suleiman Souhlal <suleiman@google.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch for-3.17] mm, thp: fix collapsing of hugepages on
 madvise
In-Reply-To: <20141006150351.GA23754@node.dhcp.inet.fi>
Message-ID: <alpine.DEB.2.02.1410061337020.17045@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1410041947080.7055@chino.kir.corp.google.com> <20141006150351.GA23754@node.dhcp.inet.fi>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014, Kirill A. Shutemov wrote:

> Okay, I've looked once again and it seems your approach is better.
> Although, I don't like that we need to pass down vma->vm_flags to every
> khugepaged_enter() and khugepaged_enter_vma_merge().
> 
> My proposal is below. Build-tested only.
> 
> And I don't think this is subject for stable@: no crash or serious
> misbehaviour. Registering to khugepaged is postponed until first page
> fault. Not a big deal.
> 

The simple testcase that first discovered this issue does an 
MADV_NOHUGEPAGE over a large length of memory prior to fault.  There are 
users that do this same thing, do mprotect(PROT_NONE) on areas (spurious 
or otherwise) for guard regions, and then do madvise(MADV_HUGEPAGE) over 
the non-guard regions.  The motivation is to prevent faulting memory due 
to thp that will later have its permissions changed to PROT_NONE.  Indeed, 
glibc's stack allocator faults the thread descriptor prior to setting 
premissions for the guard itself.  The motivation for MADV_NOHUGEPAGE is 
to specify that the range really doesn't want thp and the usecase is 
perfectly valid.  Never backing that memory with thp again upon 
MADV_HUGEPAGE seems like something that should be fixed in stable kernels 
since relying on refaulting the memory later is never guaranteed to 
happen.  Andrea's comment itself in the code is right on: the page fault 
may not happen anytime soon, which is the reason for calling into 
khugepaged_enter_vma_merge() in the first place; that comment could be 
extended to also say "the page fault may not happen anytime soon (or 
ever)".

I'd prefer that this is backported to stable unless Andrew objects or 
there's a compelling reason it doesn't meet the stable criteria (I 
couldn't find one).

> From 6434d87a313317bcbc98313794840c366ba39ba1 Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Mon, 6 Oct 2014 17:52:17 +0300
> Subject: [PATCH] thp: fix registering VMA into khugepaged on 
>  madvise(MADV_HUGEPAGE)
> 
> hugepage_madvise() tries to register VMA into khugepaged with
> khugepaged_enter_vma_merge() on madvise(MADV_HUGEPAGE). Unfortunately
> it's effectevely nop, since khugepaged_enter_vma_merge() rely on
> vma->vm_flags which has not yet updated by the time of
> hugepage_madvise().
> 
> Let's create a variant of khugepaged_enter_vma_merge() which takes
> external vm_flags to consider. At the moment there's only two users for
> such function: hugepage_madvise() and vma_merge().
> 
> Reported-by: Suleiman Souhlal <suleiman@google.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/khugepaged.h |  9 +++++++++
>  mm/huge_memory.c           | 27 ++++++++++++++++++++-------
>  mm/mmap.c                  |  6 +++---
>  3 files changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index 6b394f0b5148..bb25e323ee2d 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -7,6 +7,8 @@
>  extern int __khugepaged_enter(struct mm_struct *mm);
>  extern void __khugepaged_exit(struct mm_struct *mm);
>  extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma);
> +extern int __khugepaged_enter_vma_merge(struct vm_area_struct *vma,
> +		vm_flags_t vm_flags);
>  
>  #define khugepaged_enabled()					       \
>  	(transparent_hugepage_flags &				       \
> @@ -62,6 +64,13 @@ static inline int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
>  {
>  	return 0;
>  }
> +
> +static inline int __khugepaged_enter_vma_merge(struct vm_area_struct *vma,
> +		vm_flags_t vm_flags)
> +{
> +	return 0;
> +}
> +
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
>  #endif /* _LINUX_KHUGEPAGED_H */
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 017aff657ef5..4b0afc076827 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1944,7 +1944,7 @@ out:
>  #define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
>  
>  int hugepage_madvise(struct vm_area_struct *vma,
> -		     unsigned long *vm_flags, int advice)
> +		     vm_flags_t *vm_flags, int advice)
>  {
>  	switch (advice) {
>  	case MADV_HUGEPAGE:
> @@ -1969,8 +1969,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  		 * register it here without waiting a page fault that
>  		 * may not happen any time soon.
>  		 */
> -		if (unlikely(khugepaged_enter_vma_merge(vma)))
> -			return -ENOMEM;
> +		return __khugepaged_enter_vma_merge(vma, *vm_flags);
>  		break;
>  	case MADV_NOHUGEPAGE:
>  		/*
> @@ -2070,7 +2069,8 @@ int __khugepaged_enter(struct mm_struct *mm)
>  	return 0;
>  }
>  
> -int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
> +int __khugepaged_enter_vma_merge(struct vm_area_struct *vma,
> +		vm_flags_t vm_flags)
>  {
>  	unsigned long hstart, hend;
>  	if (!vma->anon_vma)
> @@ -2082,14 +2082,27 @@ int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
>  	if (vma->vm_ops)
>  		/* khugepaged not yet working on file or special mappings */
>  		return 0;
> -	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
> +	VM_BUG_ON(vm_flags & VM_NO_THP);
>  	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>  	hend = vma->vm_end & HPAGE_PMD_MASK;
> -	if (hstart < hend)
> -		return khugepaged_enter(vma);
> +	if (hstart >= hend)
> +		return 0;
> +	if (test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
> +		return 0;
> +	if (vm_flags & VM_NOHUGEPAGE)
> +		return 0;
> +	if (khugepaged_always())
> +		return __khugepaged_enter(vma->vm_mm);
> +	if (khugepaged_req_madv() && vm_flags & VM_HUGEPAGE)
> +		return __khugepaged_enter(vma->vm_mm);

I don't believe Linus would consider your patch to be "much nicer" than 
mine anymore with such checks added to khugepaged_enter_vma_merge().

I also don't understand your objection to passing in the effective 
vma->vm_flags to a function that relies upon vm_flags to decide whether it 
is eligible for thp or not.  If you'd prefer a comment in the code 
(incremental on my patch) then I'm sure the maintainer can judge if it's 
necessary.  But I don't think my solution, which ended up adding four 
lines of code, is more "complex" as you said in comparison to yours that 
adds 22 lines and obviously does checks in khugepaged_enter_vma_merge() 
that are completely unnecessary with my patch.

Anyway, I believe all has been said on this matter and the bike-shedding 
can come later if necessary.  I'd prefer my patch is merged with the 
s/hugepage_advise/hugepage_madvise/ fix for the changelog.

>  	return 0;
>  }
>  
> +int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
> +{
> +	return __khugepaged_enter_vma_merge(vma, vma->vm_flags);
> +}
> +
>  void __khugepaged_exit(struct mm_struct *mm)
>  {
>  	struct mm_slot *mm_slot;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index c0a3637cdb64..19fee85f0b12 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1009,8 +1009,8 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
>   */
>  struct vm_area_struct *vma_merge(struct mm_struct *mm,
>  			struct vm_area_struct *prev, unsigned long addr,
> -			unsigned long end, unsigned long vm_flags,
> -		     	struct anon_vma *anon_vma, struct file *file,
> +			unsigned long end, vm_flags_t vm_flags,
> +			struct anon_vma *anon_vma, struct file *file,
>  			pgoff_t pgoff, struct mempolicy *policy)
>  {
>  	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
> @@ -1056,7 +1056,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>  				end, prev->vm_pgoff, NULL);
>  		if (err)
>  			return NULL;
> -		khugepaged_enter_vma_merge(prev);
> +		__khugepaged_enter_vma_merge(prev, vm_flags);
>  		return prev;
>  	}
>  
