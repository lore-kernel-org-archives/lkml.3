Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaCGPJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:09:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaCGPJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:09:29 -0500
Date: Fri, 7 Mar 2014 15:09:23 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, hhuang@redhat.com,
        knoel@redhat.com, aarcange@redhat.com
Subject: Re: [PATCH -mm] mm,numa,mprotect: always continue after finding a
 stable thp page
Message-ID: <20140307150923.GB1931@suse.de>
References: <5318E4BC.50301@oracle.com>
 <20140306173137.6a23a0b2@cuia.bos.redhat.com>
 <5318FC3F.4080204@redhat.com>
 <20140307140650.GA1931@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140307140650.GA1931@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 02:06:50PM +0000, Mel Gorman wrote:
> On Thu, Mar 06, 2014 at 05:52:47PM -0500, Rik van Riel wrote:
> > On 03/06/2014 05:31 PM, Rik van Riel wrote:
> > >On Thu, 06 Mar 2014 16:12:28 -0500
> > >Sasha Levin <sasha.levin@oracle.com> wrote:
> > >
> > >>While fuzzing with trinity inside a KVM tools guest running latest -next kernel I've hit the
> > >>following spew. This seems to be introduced by your patch "mm,numa: reorganize change_pmd_range()".
> > >
> > >That patch should not introduce any functional changes, except for
> > >the VM_BUG_ON that catches the fact that we fell through to the 4kB
> > >pte handling code, despite having just handled a THP pmd...
> > >
> > >Does this patch fix the issue?
> > >
> > >Mel, am I overlooking anything obvious? :)
> > >
> > >---8<---
> > >
> > >Subject: mm,numa,mprotect: always continue after finding a stable thp page
> > >
> > >When turning a thp pmds into a NUMA one, change_huge_pmd will
> > >return 0 when the pmd already is a NUMA pmd.
> > 
> > I did miss something obvious.  In this case, the code returns 1.
> > 
> > >However, change_pmd_range would fall through to the code that
> > >handles 4kB pages, instead of continuing on to the next pmd.
> > 
> > Maybe the case that I missed is when khugepaged is in the
> > process of collapsing pages into a transparent huge page?
> > 
> > If the virtual CPU gets de-scheduled by the host for long
> > enough, it would be possible for khugepaged to run on
> > another virtual CPU, and turn the pmd into a THP pmd,
> > before that VM_BUG_ON test.
> > 
> > I see that khugepaged takes the mmap_sem for writing in the
> > collapse code, and it looks like task_numa_work takes the
> > mmap_sem for reading, so I guess that may not be possible?
> > 
> 
> mmap_sem will prevent a parallel collapse but what prevents something
> like the following?
> 
> 							do_huge_pmd_wp_page
> change_pmd_range
> if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
> 	continue;
> 							pmdp_clear_flush(vma, haddr, pmd);
> if (pmd_trans_huge(*pmd)) {
> 	.... path not taken ....
> }
> 							page_add_new_anon_rmap(new_page, vma, haddr);
> 							set_pmd_at(mm, haddr, pmd, entry);
> VM_BUG_ON(pmd_trans_huge(*pmd));
> 
> We do not hold the page table lock during the pmd_trans_huge check and we
> do not recheck it under PTF lock in change_pte_range()
> 

This is a completely untested prototype. It rechecks pmd_trans_huge
under the lock and falls through if it hit a parallel split. It's not
perfect because it could decide to fall through just because there was
no prot_numa work to do but it's for illustration purposes. Secondly,
I noted that you are calling invalidate for every pmd range. Is that not
a lot of invalidations? We could do the same by just tracking the address
of the first invalidation.

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2afc40e..a0050fc 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -46,6 +46,20 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 	unsigned long pages = 0;
 
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+
+	/* transhuge page could have faulted in parallel */
+	if (unlikely(pmd_trans_huge(*pmd))) {
+		int nr_ptes;
+
+		pte_unmap_unlock(pte, ptl);
+		nr_ptes = change_huge_pmd(vma, pmd, addr, newprot, prot_numa);
+		if (nr_ptes)
+			return nr_ptes;
+
+		/* Page was split so retake the ptl and handle ptes */
+		pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	}
+
 	arch_enter_lazy_mmu_mode();
 	do {
 		oldpte = *pte;
@@ -106,14 +120,14 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		pud_t *pud, unsigned long addr, unsigned long end,
-		pgprot_t newprot, int dirty_accountable, int prot_numa)
+		pgprot_t newprot, int dirty_accountable, int prot_numa,
+		unsigned long mni_start, unsigned long mni_end)
 {
 	pmd_t *pmd;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long next;
 	unsigned long pages = 0;
 	unsigned long nr_huge_updates = 0;
-	unsigned long mni_start = 0;
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -124,10 +138,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 			continue;
 
 		/* invoke the mmu notifier if the pmd is populated */
-		if (!mni_start) {
-			mni_start = addr;
-			mmu_notifier_invalidate_range_start(mm, mni_start, end);
-		}
+		if (!mni_start)
+			mmu_notifier_invalidate_range_start(mm, addr, mni_end);
 
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
@@ -141,8 +153,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 						pages += HPAGE_PMD_NR;
 						nr_huge_updates++;
 					}
-					continue;
 				}
+				continue;
 			}
 			/* fall through, the trans huge pmd just split */
 		}
@@ -152,9 +164,6 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		pages += this_pages;
 	} while (pmd++, addr = next, addr != end);
 
-	if (mni_start)
-		mmu_notifier_invalidate_range_end(mm, mni_start, end);
-
 	if (nr_huge_updates)
 		count_vm_numa_events(NUMA_HUGE_PTE_UPDATES, nr_huge_updates);
 	return pages;
@@ -167,16 +176,25 @@ static inline unsigned long change_pud_range(struct vm_area_struct *vma,
 	pud_t *pud;
 	unsigned long next;
 	unsigned long pages = 0;
+	unsigned long mni_start = 0;
 
 	pud = pud_offset(pgd, addr);
 	do {
+		unsigned long this_pages;
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		pages += change_pmd_range(vma, pud, addr, next, newprot,
-				 dirty_accountable, prot_numa);
+		this_pages = change_pmd_range(vma, pud, addr, next, newprot,
+				 dirty_accountable, prot_numa, mni_start,
+				 end);
+		if (this_pages)
+			mni_start = addr;
+		pages += this_pages;
 	} while (pud++, addr = next, addr != end);
 
+	if (mni_start)
+		mmu_notifier_invalidate_range_end(vma->vm_mm, mni_start, end);
+
 	return pages;
 }
 

-- 
Mel Gorman
SUSE Labs
