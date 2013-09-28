Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3I1Thp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:37:45 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36823 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3I1Thn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:37:43 -0400
Date: Sat, 28 Sep 2013 21:37:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH] anon_vmas: Convert the rwsem to an rwlock_t
Message-ID: <20130928193739.GA8642@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928192123.GA8228@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> If we do that then I suspect the next step will be queued rwlocks :-/ 
> The current rwlock_t implementation is rather primitive by modern 
> standards. (We'd probably have killed rwlock_t long ago if not for the 
> tasklist_lock.)
> 
> But yeah, it would work and conceptually a hard spinlock fits something 
> as lowlevel as the anon-vma lock.
> 
> I did a quick review pass and it appears nothing obvious is scheduling 
> with the anon-vma lock held. If it did in a non-obvious way it's likely 
> a bug anyway. The hugepage code grew a lot of logic running under the 
> anon-vma lock, but it all seems atomic.
> 
> So a conversion to rwlock_t could be attempted. (It should be relatively 
> easy patch as well, because the locking operation is now nicely 
> abstracted out.)

Here's a totally untested patch to convert the anon vma lock to an 
rwlock_t.

I think its lack of modern queueing will hurt on big systems big time - it 
might even regress. But ... it's hard to tell such things in advance.

[ That might as well be for the better as it will eventually be fixed, 
  which in turn will improve tasklist_lock workloads ;-) ]

Thanks,

	Ingo

------------->
Subject: anon_vmas: Convert the rwsem to an rwlock_t
From: Ingo Molnar <mingo@kernel.org>

--
 include/linux/mmu_notifier.h |  2 +-
 include/linux/rmap.h         | 19 +++++++++----------
 mm/huge_memory.c             |  4 ++--
 mm/mmap.c                    | 10 +++++-----
 mm/rmap.c                    | 24 ++++++++++++------------
 5 files changed, 29 insertions(+), 30 deletions(-)

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
index 6dacb93..f4ab929 100644
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
-		down_write(&anon_vma->root->rwsem);
+		write_lock(&anon_vma->root->rwlock);
 }
 
 static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		up_write(&anon_vma->root->rwsem);
+		write_unlock(&anon_vma->root->rwlock);
 }
 
 static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
 {
-	down_write(&anon_vma->root->rwsem);
+	write_lock(&anon_vma->root->rwlock);
 }
 
 static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
 {
-	up_write(&anon_vma->root->rwsem);
+	write_unlock(&anon_vma->root->rwlock);
 }
 
 static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
 {
-	down_read(&anon_vma->root->rwsem);
+	read_unlock(&anon_vma->root->rwlock);
 }
 
 static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 {
-	up_read(&anon_vma->root->rwsem);
+	read_unlock(&anon_vma->root->rwlock);
 }
 
-
 /*
  * anon_vma helper functions.
  */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7489884..78f6c08 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1542,7 +1542,7 @@ static int __split_huge_page_splitting(struct page *page,
 		 * We can't temporarily set the pmd to null in order
 		 * to split it, the pmd must remain marked huge at all
 		 * times or the VM won't take the pmd_trans_huge paths
-		 * and it won't wait on the anon_vma->root->rwsem to
+		 * and it won't wait on the anon_vma->root->rwlock to
 		 * serialize against split_huge_page*.
 		 */
 		pmdp_splitting_flush(vma, address, pmd);
@@ -1747,7 +1747,7 @@ static int __split_huge_page_map(struct page *page,
 	return ret;
 }
 
-/* must be called with anon_vma->root->rwsem held */
+/* must be called with anon_vma->root->rwlock held */
 static void __split_huge_page(struct page *page,
 			      struct anon_vma *anon_vma,
 			      struct list_head *list)
diff --git a/mm/mmap.c b/mm/mmap.c
index 9d54851..25ce233 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2955,15 +2955,15 @@ static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_sem);
+		down_write_nest_lock(&anon_vma->root->rwlock, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
-		 * anon_vma->root->rwsem. If some other vma in this mm shares
+		 * anon_vma->root->rwlock. If some other vma in this mm shares
 		 * the same anon_vma we won't take it again.
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us thanks to the
-		 * anon_vma->root->rwsem.
+		 * anon_vma->root->rwlock.
 		 */
 		if (__test_and_set_bit(0, (unsigned long *)
 				       &anon_vma->root->rb_root.rb_node))
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
-		 * anon_vma->root->rwsem.
+		 * anon_vma->root->rwlock.
 		 */
 		if (!__test_and_clear_bit(0, (unsigned long *)
 					  &anon_vma->root->rb_root.rb_node))
diff --git a/mm/rmap.c b/mm/rmap.c
index fd3ee7a..d101133 100644
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
-	if (rwsem_is_locked(&anon_vma->root->rwsem)) {
+	if (write_can_lock(&anon_vma->root->rwlock)) {
 		anon_vma_lock_write(anon_vma);
 		anon_vma_unlock_write(anon_vma);
 	}
@@ -219,9 +219,9 @@ static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct
 	struct anon_vma *new_root = anon_vma->root;
 	if (new_root != root) {
 		if (WARN_ON_ONCE(root))
-			up_write(&root->rwsem);
+			write_unlock(&root->rwlock);
 		root = new_root;
-		down_write(&root->rwsem);
+		write_lock(&root->rwlock);
 	}
 	return root;
 }
@@ -229,7 +229,7 @@ static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct
 static inline void unlock_anon_vma_root(struct anon_vma *root)
 {
 	if (root)
-		up_write(&root->rwsem);
+		write_unlock(&root->rwlock);
 }
 
 /*
@@ -349,7 +349,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	/*
 	 * Iterate the list once more, it now only contains empty and unlinked
 	 * anon_vmas, destroy them. Could not do before due to __put_anon_vma()
-	 * needing to write-acquire the anon_vma->root->rwsem.
+	 * needing to write-acquire the anon_vma->root->rwlock.
 	 */
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
@@ -365,7 +365,7 @@ static void anon_vma_ctor(void *data)
 {
 	struct anon_vma *anon_vma = data;
 
-	init_rwsem(&anon_vma->rwsem);
+	rwlock_init(&anon_vma->rwlock);
 	atomic_set(&anon_vma->refcount, 0);
 	anon_vma->rb_root = RB_ROOT;
 }
@@ -457,14 +457,14 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
 	root_anon_vma = ACCESS_ONCE(anon_vma->root);
-	if (down_read_trylock(&root_anon_vma->rwsem)) {
+	if (read_trylock(&root_anon_vma->rwlock)) {
 		/*
 		 * If the page is still mapped, then this anon_vma is still
 		 * its anon_vma, and holding the mutex ensures that it will
 		 * not go away, see anon_vma_free().
 		 */
 		if (!page_mapped(page)) {
-			up_read(&root_anon_vma->rwsem);
+			read_unlock(&root_anon_vma->rwlock);
 			anon_vma = NULL;
 		}
 		goto out;
@@ -1293,7 +1293,7 @@ out_mlock:
 	/*
 	 * We need mmap_sem locking, Otherwise VM_LOCKED check makes
 	 * unstable result and race. Plus, We can't wait here because
-	 * we now hold anon_vma->rwsem or mapping->i_mmap_mutex.
+	 * we now hold anon_vma->rwlock or mapping->i_mmap_mutex.
 	 * if trylock failed, the page remain in evictable lru and later
 	 * vmscan could retry to move the page to unevictable lru if the
 	 * page is actually mlocked.
