Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097AbaA3GhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:37:09 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:7998 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaA3GhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:37:07 -0500
Message-ID: <1391063823.2931.3.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] mm, hugetlb: gimme back my page
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jonathan Gonzalez <jgonzalez@linets.cl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 22:37:03 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

While testing some changes, I noticed an issue triggered by the libhugetlbfs
test-suite. This is caused by commit 309381fe (mm: dump page when hitting a
VM_BUG_ON using VM_BUG_ON_PAGE), where an application can unexpectedly OOM due
to another program that using, or reserving, pool_size-1 pages later triggers
a VM_BUG_ON_PAGE and thus greedly leaves no memory to the rest of the hugetlb
aware tasks. For example, in libhugetlbfs 2.14:

mmap-gettest 10 32783 (2M: 64): <---- hit VM_BUG_ON_PAGE
mmap-cow 32782 32783 (2M: 32):  FAIL    Failed to create shared mapping: Cannot allocate memory
mmap-cow 32782 32783 (2M: 64):  FAIL    Failed to create shared mapping: Cannot allocate memory

While I have not looked into why 'mmap-gettest' keeps failing, it is of no
importance to this particular issue. This problem is similar to why we have
the hugetlb_instantiation_mutex, hugepages are quite finite.

Revert the use of VM_BUG_ON_PAGE back to just VM_BUG_ON.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/linux/hugetlb.h        |  3 +--
 include/linux/hugetlb_cgroup.h |  5 ++---
 mm/hugetlb.c                   | 10 +++++-----
 mm/hugetlb_cgroup.c            |  2 +-
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 8c43cc4..d01cc97 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -2,7 +2,6 @@
 #define _LINUX_HUGETLB_H
 
 #include <linux/mm_types.h>
-#include <linux/mmdebug.h>
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
@@ -355,7 +354,7 @@ static inline pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
 
 static inline struct hstate *page_hstate(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
+	VM_BUG_ON(!PageHuge(page));
 	return size_to_hstate(PAGE_SIZE << compound_order(page));
 }
 
diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 787bba3..ce8217f 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -15,7 +15,6 @@
 #ifndef _LINUX_HUGETLB_CGROUP_H
 #define _LINUX_HUGETLB_CGROUP_H
 
-#include <linux/mmdebug.h>
 #include <linux/res_counter.h>
 
 struct hugetlb_cgroup;
@@ -29,7 +28,7 @@ struct hugetlb_cgroup;
 
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
+	VM_BUG_ON(!PageHuge(page));
 
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return NULL;
@@ -39,7 +38,7 @@ static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
 static inline
 int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
+	VM_BUG_ON(!PageHuge(page));
 
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return -1;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c01cb9f..04306b9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -584,7 +584,7 @@ static void update_and_free_page(struct hstate *h, struct page *page)
 				1 << PG_active | 1 << PG_reserved |
 				1 << PG_private | 1 << PG_writeback);
 	}
-	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
+	VM_BUG_ON(hugetlb_cgroup_from_page(page));
 	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
 	arch_release_hugepage(page);
@@ -1089,7 +1089,7 @@ retry:
 		 * no users -- drop the buddy allocator's reference.
 		 */
 		put_page_testzero(page);
-		VM_BUG_ON_PAGE(page_count(page), page);
+		VM_BUG_ON(page_count(page));
 		enqueue_huge_page(h, page);
 	}
 free:
@@ -3503,7 +3503,7 @@ int dequeue_hwpoisoned_huge_page(struct page *hpage)
 
 bool isolate_huge_page(struct page *page, struct list_head *list)
 {
-	VM_BUG_ON_PAGE(!PageHead(page), page);
+	VM_BUG_ON(!PageHead(page));
 	if (!get_page_unless_zero(page))
 		return false;
 	spin_lock(&hugetlb_lock);
@@ -3514,7 +3514,7 @@ bool isolate_huge_page(struct page *page, struct list_head *list)
 
 void putback_active_hugepage(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHead(page), page);
+	VM_BUG_ON(!PageHead(page));
 	spin_lock(&hugetlb_lock);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
@@ -3523,7 +3523,7 @@ void putback_active_hugepage(struct page *page)
 
 bool is_hugepage_active(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
+	VM_BUG_ON(!PageHuge(page));
 	/*
 	 * This function can be called for a tail page because the caller,
 	 * scan_movable_pages, scans through a given pfn-range which typically
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index cb00829..d747a84 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -390,7 +390,7 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 	if (hugetlb_cgroup_disabled())
 		return;
 
-	VM_BUG_ON_PAGE(!PageHuge(oldhpage), oldhpage);
+	VM_BUG_ON(!PageHuge(oldhpage));
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
-- 
1.8.1.4



