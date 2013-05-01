Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3EASjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:39:20 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45351 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755685Ab3EASjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:39:10 -0400
Date: Wed, 1 May 2013 13:39:08 -0500
From: Cliff Wickman <cpw@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        aarcange@redhat.com, dave.hansen@intel.com, dsterba@suse.cz,
        hannes@cmpxchg.org, kosaki.motohiro@gmail.com,
        kirill.shutemov@linux.intel.com, mpm@selenic.com,
        n-horiguchi@ah.jp.nec.com, rdunlap@infradead.org
Subject: Re: [PATCH] mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP
	areas
Message-ID: <20130501183908.GA27910@sgi.com>
References: <E1UXWpF-0006Ya-Br@eag09.americas.sgi.com> <alpine.DEB.2.02.1305010843180.4547@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305010843180.4547@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 08:47:02AM -0700, David Rientjes wrote:
> On Wed, 1 May 2013, Cliff Wickman wrote:
> 
> > Index: linux/mm/pagewalk.c
> > ===================================================================
> > --- linux.orig/mm/pagewalk.c
> > +++ linux/mm/pagewalk.c
> > @@ -127,22 +127,6 @@ static int walk_hugetlb_range(struct vm_
> >  	return 0;
> >  }
> >  
> > -static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
> > -{
> > -	struct vm_area_struct *vma;
> > -
> > -	/* We don't need vma lookup at all. */
> > -	if (!walk->hugetlb_entry)
> > -		return NULL;
> > -
> > -	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
> > -	vma = find_vma(walk->mm, addr);
> > -	if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma))
> > -		return vma;
> > -
> > -	return NULL;
> > -}
> > -
> >  #else /* CONFIG_HUGETLB_PAGE */
> >  static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
> >  {
> > @@ -200,28 +184,46 @@ int walk_page_range(unsigned long addr,
> >  
> >  	pgd = pgd_offset(walk->mm, addr);
> >  	do {
> > -		struct vm_area_struct *vma;
> > +		struct vm_area_struct *vma = NULL;
> >  
> >  		next = pgd_addr_end(addr, end);
> >  
> >  		/*
> > -		 * handle hugetlb vma individually because pagetable walk for
> > -		 * the hugetlb page is dependent on the architecture and
> > -		 * we can't handled it in the same manner as non-huge pages.
> > +		 * Check any special vma's within this range.
> >  		 */
> > -		vma = hugetlb_vma(addr, walk);
> > +		VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
> 
> I think this should be moved out of the iteration.  It's currently inside 
> it even before your patch, but I think it's pointless.

I don't follow.  We are iterating through a range of addresses.  When
we come to a range that is VM_PFNMAP we skip it.  How can we take that
out of the iteration?
 
> > +		vma = find_vma(walk->mm, addr);
> >  		if (vma) {
> > -			if (vma->vm_end < next)
> > +			/*
> > +			 * There are no page structures backing a VM_PFNMAP
> > +			 * range, so allow no split_huge_page_pmd().
> > +			 */
> > +			if (vma->vm_flags & VM_PFNMAP) {
> >  				next = vma->vm_end;
> > +				pgd = pgd_offset(walk->mm, next);
> > +				continue;
> > +			}
> 
> What if end < vma->vm_end?

Yes, a bad omission.  Thanks for pointing that out.
It should be if ((vma->vm_start <= addr) && (vma->vm_flags & VM_PFNMAP))
as find_vma can return a vma above the addr.

-Cliff
> >  			/*
> > -			 * Hugepage is very tightly coupled with vma, so
> > -			 * walk through hugetlb entries within a given vma.
> > +			 * Handle hugetlb vma individually because pagetable
> > +			 * walk for the hugetlb page is dependent on the
> > +			 * architecture and we can't handled it in the same
> > +			 * manner as non-huge pages.
> >  			 */
> > -			err = walk_hugetlb_range(vma, addr, next, walk);
> > -			if (err)
> > -				break;
> > -			pgd = pgd_offset(walk->mm, next);
> > -			continue;
> > +			if (walk->hugetlb_entry && (vma->vm_start <= addr) &&
> > +			    is_vm_hugetlb_page(vma)) {
> > +				if (vma->vm_end < next)
> > +					next = vma->vm_end;
> > +				/*
> > +				 * Hugepage is very tightly coupled with vma,
> > +				 * so walk through hugetlb entries within a
> > +				 * given vma.
> > +				 */
> > +				err = walk_hugetlb_range(vma, addr, next, walk);
> > +				if (err)
> > +					break;
> > +				pgd = pgd_offset(walk->mm, next);
> > +				continue;
> > +			}
> >  		}
> >  
> >  		if (pgd_none_or_clear_bad(pgd)) {

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
