Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3EASpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:45:10 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51428 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab3EASo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:44:59 -0400
Date: Wed, 1 May 2013 11:44:56 -0700 (PDT)
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
In-Reply-To: <20130501183908.GA27910@sgi.com>
Message-ID: <alpine.DEB.2.02.1305011144270.19598@chino.kir.corp.google.com>
References: <E1UXWpF-0006Ya-Br@eag09.americas.sgi.com> <alpine.DEB.2.02.1305010843180.4547@chino.kir.corp.google.com> <20130501183908.GA27910@sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Cliff Wickman wrote:

> > > @@ -200,28 +184,46 @@ int walk_page_range(unsigned long addr,
> > >  
> > >  	pgd = pgd_offset(walk->mm, addr);
> > >  	do {
> > > -		struct vm_area_struct *vma;
> > > +		struct vm_area_struct *vma = NULL;
> > >  
> > >  		next = pgd_addr_end(addr, end);
> > >  
> > >  		/*
> > > -		 * handle hugetlb vma individually because pagetable walk for
> > > -		 * the hugetlb page is dependent on the architecture and
> > > -		 * we can't handled it in the same manner as non-huge pages.
> > > +		 * Check any special vma's within this range.
> > >  		 */
> > > -		vma = hugetlb_vma(addr, walk);
> > > +		VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
> > 
> > I think this should be moved out of the iteration.  It's currently inside 
> > it even before your patch, but I think it's pointless.
> 
> I don't follow.  We are iterating through a range of addresses.  When
> we come to a range that is VM_PFNMAP we skip it.  How can we take that
> out of the iteration?
>  

I'm referring only to the VM_BUG_ON().
