Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaDAEJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:09:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaDAEJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:09:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Holger Kiehl <Holger.Kiehl@dwd.de>, Christoph Lameter <cl@linux.com>,
        Rafael Aquini <aquini@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 8/9] mm: close PageTail race
Date: Mon, 31 Mar 2014 21:08:22 -0700
Message-Id: <20140401040756.844867699@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040754.479538406@linuxfoundation.org>
References: <20140401040754.479538406@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 668f9abbd4334e6c29fa8acd71635c4f9101caa7 upstream.

Commit bf6bddf1924e ("mm: introduce compaction and migration for
ballooned pages") introduces page_count(page) into memory compaction
which dereferences page->first_page if PageTail(page).

This results in a very rare NULL pointer dereference on the
aforementioned page_count(page).  Indeed, anything that does
compound_head(), including page_count() is susceptible to racing with
prep_compound_page() and seeing a NULL or dangling page->first_page
pointer.

This patch uses Andrea's implementation of compound_trans_head() that
deals with such a race and makes it the default compound_head()
implementation.  This includes a read memory barrier that ensures that
if PageTail(head) is true that we return a head page that is neither
NULL nor dangling.  The patch then adds a store memory barrier to
prep_compound_page() to ensure page->first_page is set.

This is the safest way to ensure we see the head page that we are
expecting, PageTail(page) is already in the unlikely() path and the
memory barriers are unfortunately required.

Hugetlbfs is the exception, we don't enforce a store memory barrier
during init since no race is possible.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>



---
 drivers/block/aoe/aoecmd.c      |    2 +-
 drivers/vfio/vfio_iommu_type1.c |    4 ++--
 fs/proc/page.c                  |    2 +-
 include/linux/huge_mm.h         |   18 ------------------
 include/linux/mm.h              |   14 ++++++++++++--
 mm/ksm.c                        |    2 +-
 mm/memory-failure.c             |    2 +-
 mm/page_alloc.c                 |    4 +++-
 mm/swap.c                       |    4 ++--
 virt/kvm/kvm_main.c             |    4 ++--
 10 files changed, 25 insertions(+), 31 deletions(-)

--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -899,7 +899,7 @@ bio_pageinc(struct bio *bio)
 		 * but this has never been seen here.
 		 */
 		if (unlikely(PageCompound(page)))
-			if (compound_trans_head(page) != page) {
+			if (compound_head(page) != page) {
 				pr_crit("page tail used for block I/O\n");
 				BUG();
 			}
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -138,12 +138,12 @@ static bool is_invalid_reserved_pfn(unsi
 	if (pfn_valid(pfn)) {
 		bool reserved;
 		struct page *tail = pfn_to_page(pfn);
-		struct page *head = compound_trans_head(tail);
+		struct page *head = compound_head(tail);
 		reserved = !!(PageReserved(head));
 		if (head != tail) {
 			/*
 			 * "head" is not a dangling pointer
-			 * (compound_trans_head takes care of that)
+			 * (compound_head takes care of that)
 			 * but the hugepage may have been split
 			 * from under us (and we may not hold a
 			 * reference count on the head page so it can
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -121,7 +121,7 @@ u64 stable_page_flags(struct page *page)
 	 * just checks PG_head/PG_tail, so we need to check PageLRU to make
 	 * sure a given page is a thp, not a non-huge compound page.
 	 */
-	else if (PageTransCompound(page) && PageLRU(compound_trans_head(page)))
+	else if (PageTransCompound(page) && PageLRU(compound_head(page)))
 		u |= 1 << KPF_THP;
 
 	/*
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -159,23 +159,6 @@ static inline int hpage_nr_pages(struct
 		return HPAGE_PMD_NR;
 	return 1;
 }
-static inline struct page *compound_trans_head(struct page *page)
-{
-	if (PageTail(page)) {
-		struct page *head;
-		head = page->first_page;
-		smp_rmb();
-		/*
-		 * head may be a dangling pointer.
-		 * __split_huge_page_refcount clears PageTail before
-		 * overwriting first_page, so if PageTail is still
-		 * there it means the head pointer isn't dangling.
-		 */
-		if (PageTail(page))
-			return head;
-	}
-	return page;
-}
 
 extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
@@ -205,7 +188,6 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define split_huge_page_pmd_mm(__mm, __address, __pmd)	\
 	do { } while (0)
-#define compound_trans_head(page) compound_head(page)
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
 {
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -361,8 +361,18 @@ static inline void compound_unlock_irqre
 
 static inline struct page *compound_head(struct page *page)
 {
-	if (unlikely(PageTail(page)))
-		return page->first_page;
+	if (unlikely(PageTail(page))) {
+		struct page *head = page->first_page;
+
+		/*
+		 * page->first_page may be a dangling pointer to an old
+		 * compound page, so recheck that it is still a tail
+		 * page before returning.
+		 */
+		smp_rmb();
+		if (likely(PageTail(page)))
+			return head;
+	}
 	return page;
 }
 
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -444,7 +444,7 @@ static void break_cow(struct rmap_item *
 static struct page *page_trans_compound_anon(struct page *page)
 {
 	if (PageTransCompound(page)) {
-		struct page *head = compound_trans_head(page);
+		struct page *head = compound_head(page);
 		/*
 		 * head may actually be splitted and freed from under
 		 * us but it's ok here.
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1544,7 +1544,7 @@ int soft_offline_page(struct page *page,
 {
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
-	struct page *hpage = compound_trans_head(page);
+	struct page *hpage = compound_head(page);
 
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -360,9 +360,11 @@ void prep_compound_page(struct page *pag
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
-		__SetPageTail(p);
 		set_page_count(p, 0);
 		p->first_page = page;
+		/* Make sure p->first_page is always valid for PageTail() */
+		smp_wmb();
+		__SetPageTail(p);
 	}
 }
 
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -81,7 +81,7 @@ static void put_compound_page(struct pag
 {
 	if (unlikely(PageTail(page))) {
 		/* __split_huge_page_refcount can run under us */
-		struct page *page_head = compound_trans_head(page);
+		struct page *page_head = compound_head(page);
 
 		if (likely(page != page_head &&
 			   get_page_unless_zero(page_head))) {
@@ -219,7 +219,7 @@ bool __get_page_tail(struct page *page)
 	 */
 	unsigned long flags;
 	bool got = false;
-	struct page *page_head = compound_trans_head(page);
+	struct page *page_head = compound_head(page);
 
 	if (likely(page != page_head && get_page_unless_zero(page_head))) {
 		/* Ref to put_compound_page() comment. */
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -105,12 +105,12 @@ bool kvm_is_mmio_pfn(pfn_t pfn)
 	if (pfn_valid(pfn)) {
 		int reserved;
 		struct page *tail = pfn_to_page(pfn);
-		struct page *head = compound_trans_head(tail);
+		struct page *head = compound_head(tail);
 		reserved = PageReserved(head);
 		if (head != tail) {
 			/*
 			 * "head" is not a dangling pointer
-			 * (compound_trans_head takes care of that)
+			 * (compound_head takes care of that)
 			 * but the hugepage may have been splitted
 			 * from under us (and we may not hold a
 			 * reference count on the head page so it can


