Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3GAILP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:11:15 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34844 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3GAILL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:11:11 -0400
Date: Mon, 1 Jul 2013 10:11:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v3.11
Message-ID: <20130701081107.GA13736@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

   HEAD: 88c8004fd3a5fdd2378069de86b90b21110d33a4 futex: Use freezable blocking call

Four miscellanous standalone fixes for futexes, rtmutexes and 
Kconfig.locks.

 Thanks,

	Ingo

------------------>
Colin Cross (1):
      futex: Use freezable blocking call

Juri Lelli (1):
      rtmutex: Document rt_mutex_adjust_prio_chain()

Paul Bolle (1):
      locking: Fix copy/paste errors of "ARCH_INLINE_*_UNLOCK_BH"

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key


 include/linux/hugetlb.h | 16 ++++++++++++++++
 kernel/Kconfig.locks    |  6 +++---
 kernel/futex.c          |  6 ++++--
 kernel/rtmutex.c        | 13 +++++++++++++
 mm/hugetlb.c            | 17 +++++++++++++++++
 5 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 6b4890f..feaf0c7 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -358,6 +358,17 @@ static inline int hstate_index(struct hstate *h)
 	return h - hstates;
 }
 
+pgoff_t __basepage_index(struct page *page);
+
+/* Return page->index in PAGE_SIZE units */
+static inline pgoff_t basepage_index(struct page *page)
+{
+	if (!PageCompound(page))
+		return page->index;
+
+	return __basepage_index(page);
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
@@ -378,6 +389,11 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
 }
 #define hstate_index_to_shift(index) 0
 #define hstate_index(h) 0
+
+static inline pgoff_t basepage_index(struct page *page)
+{
+	return page->index;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 #endif /* _LINUX_HUGETLB_H */
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 44511d1..d2b32ac 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -138,7 +138,7 @@ config INLINE_SPIN_UNLOCK_BH
 
 config INLINE_SPIN_UNLOCK_IRQ
 	def_bool y
-	depends on !PREEMPT || ARCH_INLINE_SPIN_UNLOCK_BH
+	depends on !PREEMPT || ARCH_INLINE_SPIN_UNLOCK_IRQ
 
 config INLINE_SPIN_UNLOCK_IRQRESTORE
 	def_bool y
@@ -175,7 +175,7 @@ config INLINE_READ_UNLOCK_BH
 
 config INLINE_READ_UNLOCK_IRQ
 	def_bool y
-	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_BH
+	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_IRQ
 
 config INLINE_READ_UNLOCK_IRQRESTORE
 	def_bool y
@@ -212,7 +212,7 @@ config INLINE_WRITE_UNLOCK_BH
 
 config INLINE_WRITE_UNLOCK_IRQ
 	def_bool y
-	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK_BH
+	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK_IRQ
 
 config INLINE_WRITE_UNLOCK_IRQRESTORE
 	def_bool y
diff --git a/kernel/futex.c b/kernel/futex.c
index b26dcfc..c3a1a55 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -61,6 +61,8 @@
 #include <linux/nsproxy.h>
 #include <linux/ptrace.h>
 #include <linux/sched/rt.h>
+#include <linux/hugetlb.h>
+#include <linux/freezer.h>
 
 #include <asm/futex.h>
 
@@ -365,7 +367,7 @@ again:
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.inode = page_head->mapping->host;
-		key->shared.pgoff = page_head->index;
+		key->shared.pgoff = basepage_index(page);
 	}
 
 	get_futex_key_refs(key);
@@ -1807,7 +1809,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 		 * is no timeout, or if it has yet to expire.
 		 */
 		if (!timeout || timeout->task)
-			schedule();
+			freezable_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
 }
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 1e09308..0dd6aec 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -145,6 +145,19 @@ int max_lock_depth = 1024;
 /*
  * Adjust the priority chain. Also used for deadlock detection.
  * Decreases task's usage by one - may thus free the task.
+ *
+ * @task: the task owning the mutex (owner) for which a chain walk is probably
+ *	  needed
+ * @deadlock_detect: do we have to carry out deadlock detection?
+ * @orig_lock: the mutex (can be NULL if we are walking the chain to recheck
+ * 	       things for a task that has just got its priority adjusted, and
+ *	       is waiting on a mutex)
+ * @orig_waiter: rt_mutex_waiter struct for the task that has just donated
+ *		 its priority to the mutex owner (can be NULL in the case
+ *		 depicted above or if the top waiter is gone away and we are
+ *		 actually deboosting the owner)
+ * @top_task: the current top waiter
+ *
  * Returns 0 or -EDEADLK.
  */
 static int rt_mutex_adjust_prio_chain(struct task_struct *task,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f8feeec..aea87ce 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -690,6 +690,23 @@ int PageHuge(struct page *page)
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
+pgoff_t __basepage_index(struct page *page)
+{
+	struct page *page_head = compound_head(page);
+	pgoff_t index = page_index(page_head);
+	unsigned long compound_idx;
+
+	if (!PageHuge(page_head))
+		return page_index(page);
+
+	if (compound_order(page_head) >= MAX_ORDER)
+		compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
+	else
+		compound_idx = page - page_head;
+
+	return (index << compound_order(page_head)) + compound_idx;
+}
+
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
