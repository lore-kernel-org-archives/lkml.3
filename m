Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3EFT5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:57:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab3EFT5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:57:20 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
Cc: Isaku Yamahata <yamahata@valinux.co.jp>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 2/4] mm: rmap preparation for remap_anon_pages
Date: Mon,  6 May 2013 21:56:59 +0200
Message-Id: <1367870221-12676-3-git-send-email-aarcange@redhat.com>
In-Reply-To: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remap_anon_pages (unlike remap_file_pages) tries to be non intrusive
in the rmap code.

As far as the rmap code is concerned, rmap_anon_pages only alters the
page->mapping and page->index. It does it while holding the page
lock. However there are a few places that in presence of anon pages
are allowed to do rmap walks without the page lock (split_huge_page
and page_referenced_anon). Those places that are doing rmap walks
without taking the page lock first, must be updated to re-check that
the page->mapping didn't change after they obtained the anon_vma
lock. remap_anon_pages takes the anon_vma lock for writing before
altering the page->mapping, so if the page->mapping is still the same
after obtaining the anon_vma lock (without the page lock), the rmap
walks can go ahead safely (and remap_anon_pages will wait them to
complete before proceeding).

remap_anon_pages serializes against itself with the page lock.

All other places taking the anon_vma lock while holding the mmap_sem
for writing, don't need to check if the page->mapping has changed
after taking the anon_vma lock, regardless of the page lock, because
remap_anon_pages holds the mmap_sem for reading.

Overall this looks a fairly small change to the rmap code, notably
less intrusive than the nonlinear vmas created by remap_file_pages.

There's one constraint enforced to allow this simplification: the
source pages passed to remap_anon_pages must be mapped only in one
vma, but this is not a limitation when used to handle userland page
faults with MADV_USERFAULT. The source addresses passed to
remap_anon_pages should be set as VM_DONTCOPY with MADV_DONTFORK to
avoid any risk of the mapcount of the pages increasing, if fork runs
in parallel in another thread, before or while remap_anon_pages runs.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c | 24 ++++++++++++++++++++----
 mm/rmap.c        |  9 +++++++++
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f46aad1..9a2e235 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1824,6 +1824,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct anon_vma *anon_vma;
 	int ret = 1;
+	struct address_space *mapping;
 
 	BUG_ON(is_huge_zero_page(page));
 	BUG_ON(!PageAnon(page));
@@ -1835,10 +1836,24 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	 * page_lock_anon_vma_read except the write lock is taken to serialise
 	 * against parallel split or collapse operations.
 	 */
-	anon_vma = page_get_anon_vma(page);
-	if (!anon_vma)
-		goto out;
-	anon_vma_lock_write(anon_vma);
+	for (;;) {
+		mapping = ACCESS_ONCE(page->mapping);
+		anon_vma = page_get_anon_vma(page);
+		if (!anon_vma)
+			goto out;
+		anon_vma_lock_write(anon_vma);
+		/*
+		 * We don't hold the page lock here so
+		 * remap_anon_pages_huge_pmd can change the anon_vma
+		 * from under us until we obtain the anon_vma
+		 * lock. Verify that we obtained the anon_vma lock
+		 * before remap_anon_pages did.
+		 */
+		if (likely(mapping == ACCESS_ONCE(page->mapping)))
+			break;
+		anon_vma_unlock_write(anon_vma);
+		put_anon_vma(anon_vma);
+	}
 
 	ret = 0;
 	if (!PageCompound(page))
@@ -2294,6 +2309,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 * Prevent all access to pagetables with the exception of
 	 * gup_fast later hanlded by the ptep_clear_flush and the VM
 	 * handled by the anon_vma lock + PG_lock.
+	 * remap_anon_pages is prevented to race as well by the mmap_sem.
 	 */
 	down_write(&mm->mmap_sem);
 	if (unlikely(khugepaged_test_exit(mm)))
diff --git a/mm/rmap.c b/mm/rmap.c
index 6280da8..86d007d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -448,6 +448,7 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
+repeat:
 	rcu_read_lock();
 	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
@@ -486,6 +487,14 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 	rcu_read_unlock();
 	anon_vma_lock_read(anon_vma);
 
+	/* check if remap_anon_pages changed the anon_vma */
+	if (unlikely((unsigned long) ACCESS_ONCE(page->mapping) != anon_mapping)) {
+		anon_vma_unlock_read(anon_vma);
+		put_anon_vma(anon_vma);
+		anon_vma = NULL;
+		goto repeat;
+	}
+
 	if (atomic_dec_and_test(&anon_vma->refcount)) {
 		/*
 		 * Oops, we held the last refcount, release the lock
