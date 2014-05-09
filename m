Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaEIGZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:25:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47697 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaEIGZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:25:57 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Fri, 9 May 2014 15:28:03 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>
Subject: Re: [PATCH v5] mm: support madvise(MADV_FREE)
Message-ID: <20140509062803.GG25951@bbox>
References: <1398045368-2586-1-git-send-email-minchan@kernel.org>
 <536BE351.1050005@redhat.com>
 <20140509061714.GF25951@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509061714.GF25951@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 03:17:14PM +0900, Minchan Kim wrote:
> Hello Rik,
> 
> On Thu, May 08, 2014 at 04:04:33PM -0400, Rik van Riel wrote:
> > On 04/20/2014 09:56 PM, Minchan Kim wrote:
> > 
> > >In summary, MADV_FREE is about 2 time faster than MADV_DONTNEED.
> > 
> > This is awesome.
> 
> Thanks!
> 
> > 
> > I have a few nitpicks with the patch, though :)
> > 
> > >+static long madvise_lazyfree(struct vm_area_struct *vma,
> > >+			     struct vm_area_struct **prev,
> > >+			     unsigned long start, unsigned long end)
> > >+{
> > >+	*prev = vma;
> > >+	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
> > >+		return -EINVAL;
> > >+
> > >+	/* MADV_FREE works for only anon vma at the moment */
> > >+	if (vma->vm_file)
> > >+		return -EINVAL;
> > >+
> > >+	lazyfree_range(vma, start, end - start);
> > >+	return 0;
> > >+}
> > 
> > This code checks whether lazyfree_range would work on
> > the VMA...
> > 
> > >diff --git a/mm/memory.c b/mm/memory.c
> > >index c4b5bc250820..ca427f258204 100644
> > >--- a/mm/memory.c
> > >+++ b/mm/memory.c
> > >@@ -1270,6 +1270,104 @@ static inline unsigned long zap_pud_range(struct mmu_gather *tlb,
> > >  	return addr;
> > >  }
> > >
> > >+static unsigned long lazyfree_pte_range(struct mmu_gather *tlb,
> > >+				struct vm_area_struct *vma, pmd_t *pmd,
> > >+				unsigned long addr, unsigned long end)
> > >+{
> > >+	struct mm_struct *mm = tlb->mm;
> > >+	spinlock_t *ptl;
> > >+	pte_t *start_pte;
> > >+	pte_t *pte;
> > >+
> > >+	start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> > >+	pte = start_pte;
> > >+	arch_enter_lazy_mmu_mode();
> > >+	do {
> > >+		pte_t ptent = *pte;
> > >+
> > >+		if (pte_none(ptent))
> > >+			continue;
> > >+
> > >+		if (!pte_present(ptent))
> > >+			continue;
> > >+
> > >+		ptent = pte_mkold(ptent);
> > >+		ptent = pte_mkclean(ptent);
> > >+		set_pte_at(mm, addr, pte, ptent);
> > >+		tlb_remove_tlb_entry(tlb, pte, addr);
> > 
> > This may not work on PPC, which has a weird hash table for
> > its TLB. You will find that tlb_remove_tlb_entry does
> > nothing for PPC64, and set_pte_at does not remove the hash
> > table entry either.
> 
> Hmm, I didn't notice that. Thanks Rik.
> 
> Maybe I need this in asm-generic.
> 
> static inline void ptep_set_lazyfree(struct mm_struct *mm, unsigned addr, pte_t *ptep)
> {
>         pte_t ptent = *ptep;
>         ptent = pte_mkold(ptent);
>         ptent = pte_mkclean(ptent);
>         set_pte_at(mm, addr, ptep, ptent);
> }
> 
> For arch/powerpc/include/asm/pgtable.h
> 
> static inline void ptep_set_lazyfree(struct mm_struct *mm, unsigned long addr,
>                         pte_t *ptep)
> {
>         pte_update(mm, addr, ptep, _PAGE_DIRTY|_PAGE_ACCESSED, 0, 0);
> }
> 
> > 
> > >@@ -1370,6 +1485,31 @@ void unmap_vmas(struct mmu_gather *tlb,
> > >  }
> > >
> > >  /**
> > >+ * lazyfree_range - clear dirty bit of pte in a given range
> > >+ * @vma: vm_area_struct holding the applicable pages
> > >+ * @start: starting address of pages
> > >+ * @size: number of bytes to do lazyfree
> > >+ *
> > >+ * Caller must protect the VMA list
> > >+ */
> > >+void lazyfree_range(struct vm_area_struct *vma, unsigned long start,
> > >+		unsigned long size)
> > >+{
> > >+	struct mm_struct *mm = vma->vm_mm;
> > >+	struct mmu_gather tlb;
> > >+	unsigned long end = start + size;
> > >+
> > >+	lru_add_drain();
> > >+	tlb_gather_mmu(&tlb, mm, start, end);
> > >+	update_hiwater_rss(mm);
> > >+	mmu_notifier_invalidate_range_start(mm, start, end);
> > >+	for ( ; vma && vma->vm_start < end; vma = vma->vm_next)
> > >+		lazyfree_single_vma(&tlb, vma, start, end);
> > >+	mmu_notifier_invalidate_range_end(mm, start, end);
> > >+	tlb_finish_mmu(&tlb, start, end);
> > >+}
> > 
> > This function, called by madvise_lazyfree, can iterate
> > over multiple VMAs.
> > 
> > However, madvise_lazyfree only checked one of them.
> 
> Oops, the check should have been lazyfree_range.
> Will fix.

Now that I see the code, madvise_vma always pass *a* vma so madvise_lazyfree
doesn't cover multiple vma all at once so the current sematic is same with
dontneed. So, I don't see any problem. If I miss something, let me know it.

-- 
Kind regards,
Minchan Kim
