Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3KAHzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:55:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:28038 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab3KAHzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:55:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,615,1378882800"; 
   d="scan'208";a="420728635"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 1/4] mm/rmap: per anon_vma lock
Date: Fri,  1 Nov 2013 15:54:24 +0800
Message-Id: <1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It used to be per anon_vma lock. At then, it was a spinlock. It was
changed to mutex and an regression was reported. Commit bb4aa396("mm:
avoid repeated anon_vma lock/unlock sequences in anon_vma_clone")
turned locking a anon_vma to locking its root.

Change it back to per anon_vma lock for:
- next patch will turn the rwsem lock to rwlock
  so above regression should be avoided.

- we don't need do avc allocation inside lock, which is somehow
  necessary for turning rwsem to rwlock

- cleaner code: don't need iterate twice at unlink_anon_vmas()

- And it boosts performance in some case as it make the lock range
  smaller, which in turn reduce contention.

  The performance boost will be more obvious with next patch applied.

  aim7.2000.jobs-per-min
  ------------------------      ------
  brickland1/aim7/fork_test     +35.0%
  lkp-ib03/aim7/fork_test       +28.4%
  lkp-ib03/aim7/shared           +2.0%
  lkp-sb03/aim7/dbase            -0.4%
  lkp-sb03/aim7/fork_test       +16.4%
  lkp-sb03/aim7/shared           +0.1%

  time.voluntary_context_switches
  -----------------------------  -----
  brickland1/aim7/fork_test      -6.0%
  brickland1/aim7/shared        -21.0%
  brickland1/pigz/100%           -1.0%
  lkp-ib03/aim7/fork_test       -24.3%
  lkp-ib03/aim7/shared          -23.3%
  lkp-ib03/dbench/100%           +1.4%
  lkp-nex04/aim7/shared         -19.0%
  lkp-sb03/aim7/fork_test       -31.0%
  lkp-sb03/aim7/shared           -8.4%

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 include/linux/rmap.h |   12 ++++----
 mm/huge_memory.c     |    4 +-
 mm/mmap.c            |   46 +++++++++++++++---------------
 mm/rmap.c            |   76 ++++++++------------------------------------------
 4 files changed, 43 insertions(+), 95 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 6dacb93..f450f84 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -108,34 +108,34 @@ static inline void vma_lock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		down_write(&anon_vma->root->rwsem);
+		down_write(&anon_vma->rwsem);
 }
 
 static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		up_write(&anon_vma->root->rwsem);
+		up_write(&anon_vma->rwsem);
 }
 
 static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
 {
-	down_write(&anon_vma->root->rwsem);
+	down_write(&anon_vma->rwsem);
 }
 
 static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
 {
-	up_write(&anon_vma->root->rwsem);
+	up_write(&anon_vma->rwsem);
 }
 
 static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
 {
-	down_read(&anon_vma->root->rwsem);
+	down_read(&anon_vma->rwsem);
 }
 
 static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 {
-	up_read(&anon_vma->root->rwsem);
+	up_read(&anon_vma->rwsem);
 }
 
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 610e3df..73cc8ef 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1542,7 +1542,7 @@ static int __split_huge_page_splitting(struct page *page,
 		 * We can't temporarily set the pmd to null in order
 		 * to split it, the pmd must remain marked huge at all
 		 * times or the VM won't take the pmd_trans_huge paths
-		 * and it won't wait on the anon_vma->root->rwsem to
+		 * and it won't wait on the anon_vma->rwsem to
 		 * serialize against split_huge_page*.
 		 */
 		pmdp_splitting_flush(vma, address, pmd);
@@ -1747,7 +1747,7 @@ static int __split_huge_page_map(struct page *page,
 	return ret;
 }
 
-/* must be called with anon_vma->root->rwsem held */
+/* must be called with anon_vma->rwsem held */
 static void __split_huge_page(struct page *page,
 			      struct anon_vma *anon_vma,
 			      struct list_head *list)
diff --git a/mm/mmap.c b/mm/mmap.c
index 9d54851..b81d3a3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -414,10 +414,8 @@ void validate_mm(struct mm_struct *mm)
 	struct vm_area_struct *vma = mm->mmap;
 	while (vma) {
 		struct anon_vma_chain *avc;
-		vma_lock_anon_vma(vma);
 		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 			anon_vma_interval_tree_verify(avc);
-		vma_unlock_anon_vma(vma);
 		highest_address = vma->vm_end;
 		vma = vma->vm_next;
 		i++;
@@ -497,15 +495,20 @@ static void vma_rb_erase(struct vm_area_struct *vma, struct rb_root *root)
  * anon_vma_interval_tree_post_update_vma().
  *
  * The entire update must be protected by exclusive mmap_sem and by
- * the root anon_vma's mutex.
+ * the anon_vma's mutex.
  */
 static inline void
 anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc;
 
-	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		anon_vma_lock_write(anon_vma);
+		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		anon_vma_unlock_write(anon_vma);
+	}
 }
 
 static inline void
@@ -513,8 +516,13 @@ anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc;
 
-	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		anon_vma_lock_write(anon_vma);
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+		anon_vma_unlock_write(anon_vma);
+	}
 }
 
 static int find_vma_links(struct mm_struct *mm, unsigned long addr,
@@ -781,7 +789,6 @@ again:			remove_next = 1 + (end > next->vm_end);
 	if (anon_vma) {
 		VM_BUG_ON(adjust_next && next->anon_vma &&
 			  anon_vma != next->anon_vma);
-		anon_vma_lock_write(anon_vma);
 		anon_vma_interval_tree_pre_update_vma(vma);
 		if (adjust_next)
 			anon_vma_interval_tree_pre_update_vma(next);
@@ -845,7 +852,6 @@ again:			remove_next = 1 + (end > next->vm_end);
 		anon_vma_interval_tree_post_update_vma(vma);
 		if (adjust_next)
 			anon_vma_interval_tree_post_update_vma(next);
-		anon_vma_unlock_write(anon_vma);
 	}
 	if (mapping)
 		mutex_unlock(&mapping->i_mmap_mutex);
@@ -2096,7 +2102,6 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	 */
 	if (unlikely(anon_vma_prepare(vma)))
 		return -ENOMEM;
-	vma_lock_anon_vma(vma);
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
@@ -2107,7 +2112,6 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	if (address < PAGE_ALIGN(address+4))
 		address = PAGE_ALIGN(address+4);
 	else {
-		vma_unlock_anon_vma(vma);
 		return -ENOMEM;
 	}
 	error = 0;
@@ -2148,7 +2152,6 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 			}
 		}
 	}
-	vma_unlock_anon_vma(vma);
 	khugepaged_enter_vma_merge(vma);
 	validate_mm(vma->vm_mm);
 	return error;
@@ -2175,8 +2178,6 @@ int expand_downwards(struct vm_area_struct *vma,
 	if (error)
 		return error;
 
-	vma_lock_anon_vma(vma);
-
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_sem in read mode.  We need the
@@ -2217,7 +2218,6 @@ int expand_downwards(struct vm_area_struct *vma,
 			}
 		}
 	}
-	vma_unlock_anon_vma(vma);
 	khugepaged_enter_vma_merge(vma);
 	validate_mm(vma->vm_mm);
 	return error;
@@ -2950,23 +2950,23 @@ static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
-	if (!test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_node)) {
+	if (!test_bit(0, (unsigned long *) &anon_vma->rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_sem);
+		down_write_nest_lock(&anon_vma->rwsem, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
-		 * anon_vma->root->rwsem. If some other vma in this mm shares
+		 * anon_vma->rwsem. If some other vma in this mm shares
 		 * the same anon_vma we won't take it again.
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us thanks to the
-		 * anon_vma->root->rwsem.
+		 * anon_vma->rwsem.
 		 */
 		if (__test_and_set_bit(0, (unsigned long *)
-				       &anon_vma->root->rb_root.rb_node))
+				       &anon_vma->rb_root.rb_node))
 			BUG();
 	}
 }
@@ -3054,7 +3054,7 @@ out_unlock:
 
 static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 {
-	if (test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_node)) {
+	if (test_bit(0, (unsigned long *) &anon_vma->rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change to 0 from under
 		 * us because we hold the mm_all_locks_mutex.
@@ -3065,10 +3065,10 @@ static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us until we release the
-		 * anon_vma->root->rwsem.
+		 * anon_vma->rwsem.
 		 */
 		if (!__test_and_clear_bit(0, (unsigned long *)
-					  &anon_vma->root->rb_root.rb_node))
+					  &anon_vma->rb_root.rb_node))
 			BUG();
 		anon_vma_unlock_write(anon_vma);
 	}
diff --git a/mm/rmap.c b/mm/rmap.c
index fd3ee7a..73377b4 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -103,7 +103,7 @@ static inline void anon_vma_free(struct anon_vma *anon_vma)
 	 * LOCK should suffice since the actual taking of the lock must
 	 * happen _before_ what follows.
 	 */
-	if (rwsem_is_locked(&anon_vma->root->rwsem)) {
+	if (rwsem_is_locked(&anon_vma->rwsem)) {
 		anon_vma_lock_write(anon_vma);
 		anon_vma_unlock_write(anon_vma);
 	}
@@ -207,56 +207,25 @@ int anon_vma_prepare(struct vm_area_struct *vma)
 }
 
 /*
- * This is a useful helper function for locking the anon_vma root as
- * we traverse the vma->anon_vma_chain, looping over anon_vma's that
- * have the same vma.
- *
- * Such anon_vma's should have the same root, so you'd expect to see
- * just a single mutex_lock for the whole traversal.
- */
-static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct anon_vma *anon_vma)
-{
-	struct anon_vma *new_root = anon_vma->root;
-	if (new_root != root) {
-		if (WARN_ON_ONCE(root))
-			up_write(&root->rwsem);
-		root = new_root;
-		down_write(&root->rwsem);
-	}
-	return root;
-}
-
-static inline void unlock_anon_vma_root(struct anon_vma *root)
-{
-	if (root)
-		up_write(&root->rwsem);
-}
-
-/*
  * Attach the anon_vmas from src to dst.
  * Returns 0 on success, -ENOMEM on failure.
  */
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
-	struct anon_vma *root = NULL;
 
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
-		avc = anon_vma_chain_alloc(GFP_NOWAIT | __GFP_NOWARN);
-		if (unlikely(!avc)) {
-			unlock_anon_vma_root(root);
-			root = NULL;
-			avc = anon_vma_chain_alloc(GFP_KERNEL);
-			if (!avc)
-				goto enomem_failure;
-		}
+		avc = anon_vma_chain_alloc(GFP_KERNEL);
+		if (!avc)
+			goto enomem_failure;
+
 		anon_vma = pavc->anon_vma;
-		root = lock_anon_vma_root(root, anon_vma);
+		anon_vma_lock_write(anon_vma);
 		anon_vma_chain_link(dst, avc, anon_vma);
+		anon_vma_unlock_write(anon_vma);
 	}
-	unlock_anon_vma_root(root);
 	return 0;
 
  enomem_failure:
@@ -322,7 +291,6 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	struct anon_vma *root = NULL;
 
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
@@ -331,30 +299,12 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		root = lock_anon_vma_root(root, anon_vma);
+		anon_vma_lock_write(anon_vma);
 		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		anon_vma_unlock_write(anon_vma);
 
-		/*
-		 * Leave empty anon_vmas on the list - we'll need
-		 * to free them outside the lock.
-		 */
 		if (RB_EMPTY_ROOT(&anon_vma->rb_root))
-			continue;
-
-		list_del(&avc->same_vma);
-		anon_vma_chain_free(avc);
-	}
-	unlock_anon_vma_root(root);
-
-	/*
-	 * Iterate the list once more, it now only contains empty and unlinked
-	 * anon_vmas, destroy them. Could not do before due to __put_anon_vma()
-	 * needing to write-acquire the anon_vma->root->rwsem.
-	 */
-	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma = avc->anon_vma;
-
-		put_anon_vma(anon_vma);
+			put_anon_vma(anon_vma);
 
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
@@ -445,7 +395,6 @@ out:
 struct anon_vma *page_lock_anon_vma_read(struct page *page)
 {
 	struct anon_vma *anon_vma = NULL;
-	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
@@ -456,15 +405,14 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	root_anon_vma = ACCESS_ONCE(anon_vma->root);
-	if (down_read_trylock(&root_anon_vma->rwsem)) {
+	if (down_read_trylock(&anon_vma->rwsem)) {
 		/*
 		 * If the page is still mapped, then this anon_vma is still
 		 * its anon_vma, and holding the mutex ensures that it will
 		 * not go away, see anon_vma_free().
 		 */
 		if (!page_mapped(page)) {
-			up_read(&root_anon_vma->rwsem);
+			up_read(&anon_vma->rwsem);
 			anon_vma = NULL;
 		}
 		goto out;
-- 
1.7.7.6

