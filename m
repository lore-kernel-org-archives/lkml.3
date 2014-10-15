Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbaJOCeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:34:07 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63927 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681AbaJOCeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:34:03 -0400
Date: Wed, 15 Oct 2014 18:30:38 +0800
From: Fengwei Yin <yfw.kernel@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, fengguang.wu@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] smaps should deal with huge zero page exactly same as
 normal zero page
Message-ID: <20141015102959.GA14583@gmail.com>
References: <CADUXgx7QTWBMxesxgCet5rjpGu-V-xK_-5f2rX9R+v-ggi902A@mail.gmail.com>
 <5436B98E.1070407@intel.com>
 <20141010132027.GB25038@gmail.com>
 <20141014115730.GB6524@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <20141014115730.GB6524@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 14, 2014 at 02:57:30PM +0300, Kirill A. Shutemov wrote:
> On Fri, Oct 10, 2014 at 09:21:08PM +0800, Fengwei Yin wrote:
> > On Thu, Oct 09, 2014 at 09:36:30AM -0700, Dave Hansen wrote:
> > > On 10/09/2014 02:19 AM, Fengwei Yin wrote:
> > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > index 80ca4fb..8550b27 100644
> > > > --- a/fs/proc/task_mmu.c
> > > > +++ b/fs/proc/task_mmu.c
> > > > @@ -476,7 +476,7 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
> > > >  			mss->nonlinear += ptent_size;
> > > >  	}
> > > >  
> > > > -	if (!page)
> > > > +	if (!page || is_huge_zero_page(page))
> > > >  		return;
> > > 
> > > This really seems like a bit of a hack.  A normal (small) zero page
> > > won't make it to this point because of the vm_normal_page() check in
> > > smaps_pte_entry() which hits the _PAGE_SPECIAL bit in the pte.
> > > 
> > > Is there a reason we can't set _PAGE_SPECIAL on the huge_zero_page ptes?
> > >  If we did that, we wouldn't need a special case here.
> > > 
> > > If we can't do that for some reason, can we at least teach
> > > vm_normal_page() about the huge_zero_page in some other way?
> > I suppose _PAGE_SPECIAL can't work. Two reasons:
> > 1. Not all arch have HAVE_PTE_SPECIAL set. So always need another way to
> >    handle the arch which has no PTE_SPECIAL.
> > 2. _PAGE_SPECIAL is just for PTE now. If want to add it for huge page,
> >    we need to introduce pmd_mkspecial() thing which I don't think it's
> >    worth to do now (unless you want it. :)).
> > 
> > Yes. We could move the check to vm_normal_page(). But it still needs
> > export functions from huge_memory.c.
> > 
> > Please check the new patch.
> > 
> > > 
> > > >  	if (PageAnon(page))
> > > > @@ -516,7 +516,8 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > > >  	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
> > > >  		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
> > > >  		spin_unlock(ptl);
> > > > -		mss->anonymous_thp += HPAGE_PMD_SIZE;
> > > > +		if (!is_huge_zero_pmd(*pmd))
> > > > +			mss->anonymous_thp += HPAGE_PMD_SIZE;
> > > >  		return 0;
> > > >  	}
> > > 
> > > How about we just move this hunk in to smaps_pte_entry()?  Something
> > > along these lines:
> > > 
> > > ...
> > >         if (PageAnon(page)) {
> > >                 mss->anonymous += ptent_size;
> > > +		if (PageTransHuge(page))
> > > +			mss->anonymous_thp += ptent_size;
> > > 	}
> > Done.
> > > 
> > > If we do that, plus teaching vm_normal_page() about huge_zero_pages, it
> > > will help keep the hacks and the extra code due to huge pages to a miniumum.
> > > 
> > > > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > > > index 63579cb..758f569 100644
> > > > --- a/include/linux/huge_mm.h
> > > > +++ b/include/linux/huge_mm.h
> > > > @@ -34,6 +34,10 @@ extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> > > >  			unsigned long addr, pgprot_t newprot,
> > > >  			int prot_numa);
> > > >  
> > > > +extern bool is_huge_zero_page(struct page *page);
> > > > +
> > > > +extern bool is_huge_zero_pmd(pmd_t pmd);
> > > > +
> > > >  enum transparent_hugepage_flag {
> > > >  	TRANSPARENT_HUGEPAGE_FLAG,
> > > >  	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > > index d9a21d06..bedc3ae 100644
> > > > --- a/mm/huge_memory.c
> > > > +++ b/mm/huge_memory.c
> > > > @@ -173,12 +173,12 @@ static int start_khugepaged(void)
> > > >  static atomic_t huge_zero_refcount;
> > > >  static struct page *huge_zero_page __read_mostly;
> > > >  
> > > > -static inline bool is_huge_zero_page(struct page *page)
> > > > +bool is_huge_zero_page(struct page *page)
> > > >  {
> > > >  	return ACCESS_ONCE(huge_zero_page) == page;
> > > >  }
> > > >  
> > > > -static inline bool is_huge_zero_pmd(pmd_t pmd)
> > > > +bool is_huge_zero_pmd(pmd_t pmd)
> > > >  {
> > > >  	return is_huge_zero_page(pmd_page(pmd));
> > > >  }
> > > 
> > > ^^^ And all these exports.
> > 
> > A new function is_huge_zero_pfn() is added to mm/huge_memory.c
> > and exported.
> > 
> > Thanks.
> 
> > From 4e7bdd5bc22874175982ab50303eab32843c753c Mon Sep 17 00:00:00 2001
> > From: Fengwei Yin <yfw.kernel@gmail.com>
> > Date: Thu, 9 Oct 2014 22:20:58 +0800
> > Subject: [PATCH] smaps should deal with huge zero page exactly same as normal
> >  zero page.
> > 
> 
> Description?
> 
> > Signed-off-by: Fengwei Yin <yfw.kernel@gmail.com>
> > ---
> >  fs/proc/task_mmu.c      | 6 ++++--
> >  include/linux/huge_mm.h | 2 ++
> >  mm/huge_memory.c        | 5 +++++
> >  mm/memory.c             | 4 ++++
> >  4 files changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index c341568..fb19c0c 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -471,8 +471,11 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
> >  	if (!page)
> >  		return;
> >  
> > -	if (PageAnon(page))
> > +	if (PageAnon(page)) {
> >  		mss->anonymous += ptent_size;
> > +		if (PageTransHuge(page))
> > +			mss->anonymous_thp += HPAGE_PMD_SIZE;
> > +	}
> >  
> >  	if (page->index != pgoff)
> >  		mss->nonlinear += ptent_size;
> > @@ -508,7 +511,6 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >  	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
> >  		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
> >  		spin_unlock(ptl);
> > -		mss->anonymous_thp += HPAGE_PMD_SIZE;
> >  		return 0;
> >  	}
> >  
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 63579cb..9bf6263 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -34,6 +34,8 @@ extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> >  			unsigned long addr, pgprot_t newprot,
> >  			int prot_numa);
> >  
> > +extern bool is_huge_zero_pfn(unsigned long pfn);
> > +
> >  enum transparent_hugepage_flag {
> >  	TRANSPARENT_HUGEPAGE_FLAG,
> >  	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index f8ffd94..71ca4ed 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -183,6 +183,11 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
> >  	return is_huge_zero_page(pmd_page(pmd));
> >  }
> >  
> > +inline bool is_huge_zero_pfn(unsigned long pfn)
> 
> There's no way the function can be inlined.
> 
> Otherwise looks good to me.
> 
Thanks a lot for the comments. Updated patch attached.
> -- 
>  Kirill A. Shutemov

--jho1yZJdad60DJr+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-smaps-should-deal-with-huge-zero-page-exactly-same-a.patch"

>From 3c3553bba1b4f713f2bbfadc952964905527d677 Mon Sep 17 00:00:00 2001
From: Fengwei Yin <yfw.kernel@gmail.com>
Date: Thu, 9 Oct 2014 22:20:58 +0800
Subject: [PATCH] smaps should deal with huge zero page exactly same as normal
 zero page.

We could see following memory info in /proc/xxxx/smaps with THP enabled.
  7bea458b3000-7fea458b3000 r--p 00000000 00:13 39989  /dev/zero
  Size:           4294967296 kB
  Rss:            10612736 kB
  Pss:            10612736 kB
  Shared_Clean:          0 kB
  Shared_Dirty:          0 kB
  Private_Clean:  10612736 kB
  Private_Dirty:         0 kB
  Referenced:     10612736 kB
  Anonymous:             0 kB
  AnonHugePages:  10612736 kB
  Swap:                  0 kB
  KernelPageSize:        4 kB
  MMUPageSize:           4 kB
  Locked:                0 kB
  VmFlags: rd mr mw me
which is wrong becuase just huge_zero_page/normal_zero_page is used for
/dev/zero. Most of the value should be 0.

This patch detects huge_zero_page (original implementation just detect
normal_zero_page) and avoids to update the wrong value for huge_zero_page.

Signed-off-by: Fengwei Yin <yfw.kernel@gmail.com>
---
 fs/proc/task_mmu.c      | 6 ++++--
 include/linux/huge_mm.h | 2 ++
 mm/huge_memory.c        | 5 +++++
 mm/memory.c             | 4 ++++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4e0388c..735b389 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -474,8 +474,11 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
 	if (!page)
 		return;
 
-	if (PageAnon(page))
+	if (PageAnon(page)) {
 		mss->anonymous += ptent_size;
+		if (PageTransHuge(page))
+			mss->anonymous_thp += HPAGE_PMD_SIZE;
+	}
 
 	if (page->index != pgoff)
 		mss->nonlinear += ptent_size;
@@ -511,7 +514,6 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
 		spin_unlock(ptl);
-		mss->anonymous_thp += HPAGE_PMD_SIZE;
 		return 0;
 	}
 
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad9051b..7080aa1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -34,6 +34,8 @@ extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, pgprot_t newprot,
 			int prot_numa);
 
+extern bool is_huge_zero_pfn(unsigned long pfn);
+
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 74c78aa..7e7880c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -183,6 +183,11 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
 	return is_huge_zero_page(pmd_page(pmd));
 }
 
+bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return is_huge_zero_page(pfn_to_page(pfn));
+}
+
 static struct page *get_huge_zero_page(void)
 {
 	struct page *zero_page;
diff --git a/mm/memory.c b/mm/memory.c
index 1cc6bfb..eebb6c5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -41,6 +41,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
+#include <linux/huge_mm.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/highmem.h>
@@ -787,6 +788,9 @@ check_pfn:
 		return NULL;
 	}
 
+	if (is_huge_zero_pfn(pfn))
+		return NULL;
+
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
 	 * eg. VDSO mappings can cause them to exist.
-- 
2.0.1


--jho1yZJdad60DJr+--
