Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaBSDTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:19:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbaBSDTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:19:08 -0500
Date: Tue, 18 Feb 2014 22:18:37 -0500
From: Rik van Riel <riel@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        peterz@infradead.org, chegu_vinod@hp.com, aarcange@redhat.com,
        akpm@linux-foundation.org
Subject: [PATCH -mm v2 3/3] move mmu notifier call from change_protection to
 change_pmd_range
Message-ID: <20140218221837.6126ae74@annuminas.surriel.com>
In-Reply-To: <alpine.DEB.2.02.1402181823420.20791@chino.kir.corp.google.com>
References: <1392761566-24834-1-git-send-email-riel@redhat.com>
	<1392761566-24834-4-git-send-email-riel@redhat.com>
	<alpine.DEB.2.02.1402181823420.20791@chino.kir.corp.google.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014 18:24:36 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> Acked-by: David Rientjes <rientjes@google.com>
> 
> Might have been cleaner to move the 
> mmu_notifier_invalidate_range_{start,end}() to hugetlb_change_protection() 
> as well, though.

Way cleaner!  Second version attached :)

Thanks, David.

---8<---

Subject: move mmu notifier call from change_protection to change_pmd_range

The NUMA scanning code can end up iterating over many gigabytes
of unpopulated memory, especially in the case of a freshly started
KVM guest with lots of memory.

This results in the mmu notifier code being called even when
there are no mapped pages in a virtual address range. The amount
of time wasted can be enough to trigger soft lockup warnings
with very large KVM guests.

This patch moves the mmu notifier call to the pmd level, which
represents 1GB areas of memory on x86-64. Furthermore, the mmu
notifier code is only called from the address in the PMD where
present mappings are first encountered.

The hugetlbfs code is left alone for now; hugetlb mappings are
not relocatable, and as such are left alone by the NUMA code,
and should never trigger this problem to begin with.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 mm/hugetlb.c  |  2 ++
 mm/mprotect.c | 15 ++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c0d930f..f0c5dfb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3065,6 +3065,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	BUG_ON(address >= end);
 	flush_cache_range(vma, address, end);
 
+	mmu_notifier_invalidate_range_start(mm, start, end);
 	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
 	for (; address < end; address += huge_page_size(h)) {
 		spinlock_t *ptl;
@@ -3094,6 +3095,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	 */
 	flush_tlb_range(vma, start, end);
 	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+	mmu_notifier_invalidate_range_end(mm, start, end);
 
 	return pages << h->order;
 }
diff --git a/mm/mprotect.c b/mm/mprotect.c
index d790166..76146fa 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -115,9 +115,11 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		pgprot_t newprot, int dirty_accountable, int prot_numa)
 {
 	pmd_t *pmd;
+	struct mm_struct *mm = vma->vm_mm;
 	unsigned long next;
 	unsigned long pages = 0;
 	unsigned long nr_huge_updates = 0;
+	unsigned long mni_start = 0;
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -126,6 +128,13 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		next = pmd_addr_end(addr, end);
 		if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
 				continue;
+
+		/* invoke the mmu notifier if the pmd is populated */
+		if (!mni_start) {
+			mni_start = addr;
+			mmu_notifier_invalidate_range_start(mm, mni_start, end);
+		}
+
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
@@ -149,6 +158,9 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		pages += this_pages;
 	} while (pmd++, addr = next, addr != end);
 
+	if (mni_start)
+		mmu_notifier_invalidate_range_end(mm, mni_start, end);
+
 	if (nr_huge_updates)
 		count_vm_numa_events(NUMA_HUGE_PTE_UPDATES, nr_huge_updates);
 	return pages;
@@ -208,15 +220,12 @@ unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
 		       unsigned long end, pgprot_t newprot,
 		       int dirty_accountable, int prot_numa)
 {
-	struct mm_struct *mm = vma->vm_mm;
 	unsigned long pages;
 
-	mmu_notifier_invalidate_range_start(mm, start, end);
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot);
 	else
 		pages = change_protection_range(vma, start, end, newprot, dirty_accountable, prot_numa);
-	mmu_notifier_invalidate_range_end(mm, start, end);
 
 	return pages;
 }
