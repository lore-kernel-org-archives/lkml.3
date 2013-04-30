Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab3D3SwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:52:06 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49904 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933077Ab3D3SwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:52:03 -0400
Date: Tue, 30 Apr 2013 13:52:02 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/proc: smaps should avoid VM_PFNMAP areas
Message-ID: <20130430185202.GA8249@sgi.com>
References: <E1UXF1l-00025N-UJ@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1UXF1l-00025N-UJ@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 30, 2013 at 01:11:45PM -0500, Naoya Horiguchi wrote:
> > 
> > /proc/<pid>/smaps should not be looking at VM_PFNMAP areas.
> > 
> > Certain tests in show_smap() (especially for huge pages) assume that the
> > mapped PFN's are backed with page structures.  And this is not usually true
> > for VM_PFNMAP areas.  This can result in panics on kernel page faults when
> > attempting to address those page structures.
> 
> I think it's strange that you mention to hugepages, because in my understanding
> VM_PFNMAP and hugepage related vma (VM_HUGEPAGE or VM_HUGETLB) should not set
> at the same time. In what testcase are these flags both set?

I don't think VM_PFNMAP and VM_HUGE... set at the same time.
The problem is that a VM_PFNMAP'd area might have 2MB mappings in its
page table, but they may point to pfn's that are not backed by page
structures.

Then a sequence like:
show_smap
  show_map_vma
    walk_page_range
      walk_pud_range
        walk_pmd_range
          split_huge_page_pmd(walk->mm, pmd)
            __split_huge_page_pmd
              page = pmd_page(*pmd)
can address   (vmemmap + (pfn)) and panic

Or a sequence like this:
        walk_pmd_range
          walk->pmd_entry(pmd, addr, next, walk)
          smaps_pte_range
            smaps_pte_entry(*pte, addr, PAGE_SIZE, walk)
              page = vm_normal_page(vma, addr, ptent)
                return pfn_to_page(pfn)
> 
> And I guess this race can also happen on reading pagemap or numa_maps because
> walk_page_range() is called in those code paths. Are you sure the race doesn't
> happen on these paths? If not, please add a few more flag checks for them.

Okay.  I'll check and submit a version 2 of this patch.

-Cliff Wickman
 
> Thanks,
> Naoya Horiguchi
> 
>  
> > VM_PFNMAP areas are used by
> > - graphics memory manager   gpu/drm/drm_gem.c
> > - global reference unit     sgi-gru/grufile.c
> > - sgi special memory        char/mspec.c
> > - probably several out-of-tree modules
> > 
> > I'm copying everyone who has changed fs/proc/task_mmu.c recently, in case
> > of some reason to provide /proc/<pid>/smaps for these areas that I am not
> > aware of.
> > 
> > Signed-off-by: Cliff Wickman <cpw@sgi.com>
> > ---
> >  fs/proc/task_mmu.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: linux/fs/proc/task_mmu.c
> > ===================================================================
> > --- linux.orig/fs/proc/task_mmu.c
> > +++ linux/fs/proc/task_mmu.c
> > @@ -589,6 +589,9 @@ static int show_smap(struct seq_file *m,
> >  		.private = &mss,
> >  	};
> >  
> > +	if (vma->vm_flags & VM_PFNMAP)
> > +		return 0;
> > +
> >  	memset(&mss, 0, sizeof mss);
> >  	mss.vma = vma;
> >  	/* mmap_sem is held in m_start */

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
