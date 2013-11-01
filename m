Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3KAHzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:55:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:23700 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296Ab3KAHzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:55:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,615,1378882800"; 
   d="scan'208";a="420728639"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 2/4] mm/rmap: convert anon_vma rwsem to rwlock_t
Date: Fri,  1 Nov 2013 15:54:25 +0800
Message-Id: <1383292467-28922-3-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

This lock basically covers the insertion of avc into rb tree; turn rwsem
to rwlock_t.

With the former per anon_vma lock applied, the performance is nearly
doubled in some heavy fork workload of aim7 on some platforms.

aim7.2000.jobs-per-min
---------------------          ------
lkp-ib03/aim7/shared            +2.7%
brickland1/aim7/fork_test      +89.9%
lkp-ib03/aim7/fork_test        +49.3%
lkp-sb03/aim7/fork_test        +59.0%
lkp-sb03/aim7/shared            +0.3%

time.voluntary_context_switches
-----------------------------  ------
brickland1/aim7/shared         -60.8%
brickland1/aim7/fork_test      -75.8%
brickland1/pigz/100%            +0.4%
lkp-ib03/aim7/fork_test        -81.4%
lkp-ib03/aim7/shared           -46.8%
lkp-ib03/dbench/100%            -0.6%
lkp-nex04/aim7/shared          -54.2%
lkp-sb03/aim7/fork_test        -80.2%
lkp-sb03/aim7/shared           -26.7%

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 include/linux/mmu_notifier.h |    2 +-
 include/linux/rmap.h         |   19 +++++++++----------
 mm/huge_memory.c             |    4 ++--
 mm/mmap.c                    |   10 +++++-----
 mm/rmap.c                    |   16 ++++++++--------
 5 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index deca874..628e807 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -151,7 +151,7 @@ struct mmu_notifier_ops {
  * Therefore notifier chains can only be traversed when either
  *
  * 1. mmap_sem is held.
- * 2. One of the reverse map locks is held (i_mmap_mutex or anon_vma->rwsem).
+ * 2. One of the reverse map locks is held (i_mmap_mutex or anon_vma->rwlock).
  * 3. No other concurrent thread can access the list (release)
  */
 struct mmu_notifier {
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index f450f84..2bb0a1f 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -7,7 +7,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/rwsem.h>
+#include <linux/rwlock.h>
 #include <linux/memcontrol.h>
 
 /*
@@ -26,7 +26,7 @@
  */
 struct anon_vma {
 	struct anon_vma *root;		/* Root of this anon_vma tree */
-	struct rw_semaphore rwsem;	/* W: modification, R: walking the list */
+	rwlock_t rwlock;		/* W: modification, R: walking the list */
 	/*
 	 * The refcount is taken on an anon_vma when there is no
 	 * guarantee that the vma of page tables will exist for
@@ -64,7 +64,7 @@ struct anon_vma_chain {
 	struct vm_area_struct *vma;
 	struct anon_vma *anon_vma;
 	struct list_head same_vma;   /* locked by mmap_sem & page_table_lock */
-	struct rb_node rb;			/* locked by anon_vma->rwsem */
+	struct rb_node rb;			/* locked by anon_vma->rwlock */
 	unsigned long rb_subtree_last;
 #ifdef CONFIG_DEBUG_VM_RB
 	unsigned long cached_vma_start, cached_vma_last;
@@ -108,37 +108,36 @@ static inline void vma_lock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		down_write(&anon_vma->rwsem);
+		write_lock(&anon_vma->rwlock);
 }
 
 static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		up_write(&anon_vma->rwsem);
+		write_unlock(&anon_vma->rwlock);
 }
 
 static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
 {
-	down_write(&anon_vma->rwsem);
+	write_lock(&anon_vma->rwlock);
 }
 
 static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
 {
-	up_write(&anon_vma->rwsem);
+	write_unlock(&anon_vma->rwlock);
 }
 
 static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
 {
-	down_read(&anon_vma->rwsem);
+	read_lock(&anon_vma->rwlock);
 }
 
 static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 {
-	up_read(&anon_vma->rwsem);
+	read_unlock(&anon_vma->rwlock);
 }
 
-
 /*
  * anon_vma helper functions.
  */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 73cc8ef..a1e6cb2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1542,7 +1542,7 @@ static int __split_huge_page_splitting(struct page *page,
 		 * We can't temporarily set the pmd to null in order
 		 * to split it, the pmd must remain marked huge at all
 		 * times or the VM won't take the pmd_trans_huge paths
-		 * and it won't wait on the anon_vma->rwsem to
+		 * and it won't wait on the anon_vma->rwlock to
 		 * serialize against split_huge_page*.
 		 */
 		pmdp_splitting_flush(vma, address, pmd);
@@ -1747,7 +1747,7 @@ static int __split_huge_page_map(struct page *page,
 	return ret;
 }
 
-/* must be called with anon_vma->rwsem held */
+/* must be called with anon_vma->rwlock held */
 static void __split_huge_page(struct page *page,
 			      struct anon_vma *anon_vma,
 			      struct list_head *list)
diff --git a/mm/mmap.c b/mm/mmap.c
index b81d3a3..0c0f5ee 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2955,15 +2955,15 @@ static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		down_write_nest_lock(&anon_vma->rwsem, &mm->mmap_sem);
+		write_lock(&anon_vma->rwlock);
 		/*
 		 * We can safely modify head.next after taking the
-		 * anon_vma->rwsem. If some other vma in this mm shares
+		 * anon_vma->rwlock. If some other vma in this mm shares
 		 * the same anon_vma we won't take it again.
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us thanks to the
-		 * anon_vma->rwsem.
+		 * anon_vma->rwlock.
 		 */
 		if (__test_and_set_bit(0, (unsigned long *)
 				       &anon_vma->rb_root.rb_node))
@@ -3012,7 +3012,7 @@ static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
  * vma in this mm is backed by the same anon_vma or address_space.
  *
  * We can take all the locks in random order because the VM code
- * taking i_mmap_mutex or anon_vma->rwsem outside the mmap_sem never
+ * taking i_mmap_mutex or anon_vma->rwslockoutside the mmap_sem never
  * takes more than one of them in a row. Secondly we're protected
  * against a concurrent mm_take_all_locks() by the mm_all_locks_mutex.
  *
@@ -3065,7 +3065,7 @@ static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us until we release the
-		 * anon_vma->rwsem.
+		 * anon_vma->rwlock.
 		 */
 		if (!__test_and_clear_bit(0, (unsigned long *)
 					  &anon_vma->rb_root.rb_node))
diff --git a/mm/rmap.c b/mm/rmap.c
index 73377b4..22e8172 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -24,7 +24,7 @@
  *   mm->mmap_sem
  *     page->flags PG_locked (lock_page)
  *       mapping->i_mmap_mutex
- *         anon_vma->rwsem
+ *         anon_vma->rwlock
  *           mm->page_table_lock or pte_lock
  *             zone->lru_lock (in mark_page_accessed, isolate_lru_page)
  *             swap_lock (in swap_duplicate, swap_info_get)
@@ -37,7 +37,7 @@
  *                           in arch-dependent flush_dcache_mmap_lock,
  *                           within bdi.wb->list_lock in __sync_single_inode)
  *
- * anon_vma->rwsem,mapping->i_mutex      (memory_failure, collect_procs_anon)
+ * anon_vma->rwlock,mapping->i_mutex      (memory_failure, collect_procs_anon)
  *   ->tasklist_lock
  *     pte map lock
  */
@@ -98,12 +98,12 @@ static inline void anon_vma_free(struct anon_vma *anon_vma)
 	 * page_lock_anon_vma_read()	VS	put_anon_vma()
 	 *   down_read_trylock()		  atomic_dec_and_test()
 	 *   LOCK				  MB
-	 *   atomic_read()			  rwsem_is_locked()
+	 *   atomic_read()			  rwlock_is_locked()
 	 *
 	 * LOCK should suffice since the actual taking of the lock must
 	 * happen _before_ what follows.
 	 */
-	if (rwsem_is_locked(&anon_vma->rwsem)) {
+	if (!write_can_lock(&anon_vma->rwlock)) {
 		anon_vma_lock_write(anon_vma);
 		anon_vma_unlock_write(anon_vma);
 	}
@@ -315,7 +315,7 @@ static void anon_vma_ctor(void *data)
 {
 	struct anon_vma *anon_vma = data;
 
-	init_rwsem(&anon_vma->rwsem);
+	rwlock_init(&anon_vma->rwlock);
 	atomic_set(&anon_vma->refcount, 0);
 	anon_vma->rb_root = RB_ROOT;
 }
@@ -405,14 +405,14 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	if (down_read_trylock(&anon_vma->rwsem)) {
+	if (read_trylock(&anon_vma->rwlock)) {
 		/*
 		 * If the page is still mapped, then this anon_vma is still
 		 * its anon_vma, and holding the mutex ensures that it will
 		 * not go away, see anon_vma_free().
 		 */
 		if (!page_mapped(page)) {
-			up_read(&anon_vma->rwsem);
+			read_unlock(&anon_vma->rwlock);
 			anon_vma = NULL;
 		}
 		goto out;
@@ -1241,7 +1241,7 @@ out_mlock:
 	/*
 	 * We need mmap_sem locking, Otherwise VM_LOCKED check makes
 	 * unstable result and race. Plus, We can't wait here because
-	 * we now hold anon_vma->rwsem or mapping->i_mmap_mutex.
+	 * we now hold anon_vma->rwlock or mapping->i_mmap_mutex.
 	 * if trylock failed, the page remain in evictable lru and later
 	 * vmscan could retry to move the page to unevictable lru if the
 	 * page is actually mlocked.
-- 
1.7.7.6

