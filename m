Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3EAPrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:47:17 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62011 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3EAPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:47:06 -0400
Date: Wed, 1 May 2013 08:47:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cliff Wickman <cpw@sgi.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        aarcange@redhat.com, dave.hansen@intel.com, dsterba@suse.cz,
        hannes@cmpxchg.org, kosaki.motohiro@gmail.com,
        kirill.shutemov@linux.intel.com, mpm@selenic.com,
        n-horiguchi@ah.jp.nec.com, rdunlap@infradead.org
Subject: Re: [PATCH] mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP
 areas
In-Reply-To: <E1UXWpF-0006Ya-Br@eag09.americas.sgi.com>
Message-ID: <alpine.DEB.2.02.1305010843180.4547@chino.kir.corp.google.com>
References: <E1UXWpF-0006Ya-Br@eag09.americas.sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Cliff Wickman wrote:

> Index: linux/mm/pagewalk.c
> ===================================================================
> --- linux.orig/mm/pagewalk.c
> +++ linux/mm/pagewalk.c
> @@ -127,22 +127,6 @@ static int walk_hugetlb_range(struct vm_
>  	return 0;
>  }
>  
> -static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
> -{
> -	struct vm_area_struct *vma;
> -
> -	/* We don't need vma lookup at all. */
> -	if (!walk->hugetlb_entry)
> -		return NULL;
> -
> -	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
> -	vma = find_vma(walk->mm, addr);
> -	if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma))
> -		return vma;
> -
> -	return NULL;
> -}
> -
>  #else /* CONFIG_HUGETLB_PAGE */
>  static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
>  {
> @@ -200,28 +184,46 @@ int walk_page_range(unsigned long addr,
>  
>  	pgd = pgd_offset(walk->mm, addr);
>  	do {
> -		struct vm_area_struct *vma;
> +		struct vm_area_struct *vma = NULL;
>  
>  		next = pgd_addr_end(addr, end);
>  
>  		/*
> -		 * handle hugetlb vma individually because pagetable walk for
> -		 * the hugetlb page is dependent on the architecture and
> -		 * we can't handled it in the same manner as non-huge pages.
> +		 * Check any special vma's within this range.
>  		 */
> -		vma = hugetlb_vma(addr, walk);
> +		VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));

I think this should be moved out of the iteration.  It's currently inside 
it even before your patch, but I think it's pointless.

> +		vma = find_vma(walk->mm, addr);
>  		if (vma) {
> -			if (vma->vm_end < next)
> +			/*
> +			 * There are no page structures backing a VM_PFNMAP
> +			 * range, so allow no split_huge_page_pmd().
> +			 */
> +			if (vma->vm_flags & VM_PFNMAP) {
>  				next = vma->vm_end;
> +				pgd = pgd_offset(walk->mm, next);
> +				continue;
> +			}

What if end < vma->vm_end?

>  			/*
> -			 * Hugepage is very tightly coupled with vma, so
> -			 * walk through hugetlb entries within a given vma.
> +			 * Handle hugetlb vma individually because pagetable
> +			 * walk for the hugetlb page is dependent on the
> +			 * architecture and we can't handled it in the same
> +			 * manner as non-huge pages.
>  			 */
> -			err = walk_hugetlb_range(vma, addr, next, walk);
> -			if (err)
> -				break;
> -			pgd = pgd_offset(walk->mm, next);
> -			continue;
> +			if (walk->hugetlb_entry && (vma->vm_start <= addr) &&
> +			    is_vm_hugetlb_page(vma)) {
> +				if (vma->vm_end < next)
> +					next = vma->vm_end;
> +				/*
> +				 * Hugepage is very tightly coupled with vma,
> +				 * so walk through hugetlb entries within a
> +				 * given vma.
> +				 */
> +				err = walk_hugetlb_range(vma, addr, next, walk);
> +				if (err)
> +					break;
> +				pgd = pgd_offset(walk->mm, next);
> +				continue;
> +			}
>  		}
>  
>  		if (pgd_none_or_clear_bad(pgd)) {
