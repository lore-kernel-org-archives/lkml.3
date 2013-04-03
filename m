Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761768Ab3DCNfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:35:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:53618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761045Ab3DCNfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:35:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,401,1363158000"; 
   d="scan'208";a="222338084"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-s390@vger.kernel.org
Cc: koverstreet@google.com, bcrl@kvack.org, schwidefsky@de.ibm.com,
        kirill.shutemov@linux.intel.com,
        Octavian Purdila <octavian.purdila@intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v2] aio: convert the ioctx list to radix tree
Date: Wed,  3 Apr 2013 16:20:48 +0300
Message-Id: <1364995248-11028-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a large number of threads performing AIO operations the
IOCTX list may get a significant number of entries which will cause
significant overhead. For example, when running this fio script:

rw=randrw; size=256k ;directory=/mnt/fio; ioengine=libaio; iodepth=1
blocksize=1024; numjobs=512; thread; loops=100

on an EXT2 filesystem mounted on top of a ramdisk we can observe up to
30% CPU time spent by lookup_ioctx:

 32.51%  [guest.kernel]  [g] lookup_ioctx
  9.19%  [guest.kernel]  [g] __lock_acquire.isra.28
  4.40%  [guest.kernel]  [g] lock_release
  4.19%  [guest.kernel]  [g] sched_clock_local
  3.86%  [guest.kernel]  [g] local_clock
  3.68%  [guest.kernel]  [g] native_sched_clock
  3.08%  [guest.kernel]  [g] sched_clock_cpu
  2.64%  [guest.kernel]  [g] lock_release_holdtime.part.11
  2.60%  [guest.kernel]  [g] memcpy
  2.33%  [guest.kernel]  [g] lock_acquired
  2.25%  [guest.kernel]  [g] lock_acquire
  1.84%  [guest.kernel]  [g] do_io_submit

This patchs converts the ioctx list to a radix tree. For a performance
comparison the above FIO script was run on a 2 sockets 8 core
machine. This are the results for the original list based
implementation and for the radix tree based implementation:

cores         1         2         4         8         16        32
list        111025 ms  62219 ms  34193 ms  22998 ms  19335 ms  15956 ms
radix        75400 ms  42668 ms  23923 ms  17206 ms  15820 ms  13295 ms
% of radix
relative      68%       69%       70%       75%       82%       83%
to list

To consider the impact of the patch on the typical case of having
only one ctx per process the following FIO script was run:

rw=randrw; size=100m ;directory=/mnt/fio; ioengine=libaio; iodepth=1
blocksize=1024; numjobs=1; thread; loops=100

on the same system and the results are the following:

list        65241 ms
radix       65402 ms
% of radix
relative    100.25%
to list

Cc: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

---

Changes since V1:
 * add performance comparision for the typical case of having only one
   ctx per process
 * use ARRAY_SIZE and drop tracking idx as it is not needed

 arch/s390/mm/pgtable.c   |    4 +-
 fs/aio.c                 |   95 +++++++++++++++++++++++++++-------------------
 include/linux/aio.h      |    1 -
 include/linux/mm_types.h |    3 +-
 kernel/fork.c            |    2 +-
 5 files changed, 61 insertions(+), 44 deletions(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index ae44d2a..6fb6751 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -831,7 +831,7 @@ int s390_enable_sie(void)
 	task_lock(tsk);
 	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||
 #ifdef CONFIG_AIO
-	    !hlist_empty(&tsk->mm->ioctx_list) ||
+	    tsk->mm->ioctx_rtree.rnode ||
 #endif
 	    tsk->mm != tsk->active_mm) {
 		task_unlock(tsk);
@@ -858,7 +858,7 @@ int s390_enable_sie(void)
 	task_lock(tsk);
 	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||
 #ifdef CONFIG_AIO
-	    !hlist_empty(&tsk->mm->ioctx_list) ||
+	    tsk->mm->ioctx_rtree.rnode ||
 #endif
 	    tsk->mm != tsk->active_mm) {
 		mmput(mm);
diff --git a/fs/aio.c b/fs/aio.c
index 3f941f2..c70d4ac 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -35,6 +35,7 @@
 #include <linux/eventfd.h>
 #include <linux/blkdev.h>
 #include <linux/compat.h>
+#include <linux/radix-tree.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -281,10 +282,18 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	aio_nr += ctx->max_reqs;
 	spin_unlock(&aio_nr_lock);
 
-	/* now link into global list. */
+	/* now insert into the radix tree */
+	err = radix_tree_preload(GFP_KERNEL);
+	if (err)
+		goto out_cleanup;
 	spin_lock(&mm->ioctx_lock);
-	hlist_add_head_rcu(&ctx->list, &mm->ioctx_list);
+	err = radix_tree_insert(&mm->ioctx_rtree, ctx->user_id, ctx);
 	spin_unlock(&mm->ioctx_lock);
+	radix_tree_preload_end();
+	if (err) {
+		WARN_ONCE(1, "aio: insert into ioctx tree failed: %d", err);
+		goto out_cleanup;
+	}
 
 	dprintk("aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
 		ctx, ctx->user_id, current->mm, ctx->ring_info.nr);
@@ -362,6 +371,32 @@ ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
 }
 EXPORT_SYMBOL(wait_on_sync_kiocb);
 
+static inline void exit_aio_ctx(struct mm_struct *mm, struct kioctx *ctx)
+{
+	void *ret;
+
+	ret = radix_tree_delete(&mm->ioctx_rtree, ctx->user_id);
+	BUG_ON(!ret || ret != ctx);
+
+	kill_ctx(ctx);
+
+	if (1 != atomic_read(&ctx->users))
+		pr_debug("exit_aio:ioctx still alive: %d %d %d\n",
+			 atomic_read(&ctx->users), ctx->dead, ctx->reqs_active);
+	/*
+	 * We don't need to bother with munmap() here -
+	 * exit_mmap(mm) is coming and it'll unmap everything.
+	 * Since aio_free_ring() uses non-zero ->mmap_size
+	 * as indicator that it needs to unmap the area,
+	 * just set it to 0; aio_free_ring() is the only
+	 * place that uses ->mmap_size, so it's safe.
+	 * That way we get all munmap done to current->mm -
+	 * all other callers have ctx->mm == current->mm.
+	 */
+	ctx->ring_info.mmap_size = 0;
+	put_ioctx(ctx);
+}
+
 /* exit_aio: called when the last user of mm goes away.  At this point, 
  * there is no way for any new requests to be submited or any of the 
  * io_* syscalls to be called on the context.  However, there may be 
@@ -371,32 +406,17 @@ EXPORT_SYMBOL(wait_on_sync_kiocb);
  */
 void exit_aio(struct mm_struct *mm)
 {
-	struct kioctx *ctx;
+	struct kioctx *ctx[16];
+	int count;
 
-	while (!hlist_empty(&mm->ioctx_list)) {
-		ctx = hlist_entry(mm->ioctx_list.first, struct kioctx, list);
-		hlist_del_rcu(&ctx->list);
-
-		kill_ctx(ctx);
+	do {
+		int i;
 
-		if (1 != atomic_read(&ctx->users))
-			printk(KERN_DEBUG
-				"exit_aio:ioctx still alive: %d %d %d\n",
-				atomic_read(&ctx->users), ctx->dead,
-				ctx->reqs_active);
-		/*
-		 * We don't need to bother with munmap() here -
-		 * exit_mmap(mm) is coming and it'll unmap everything.
-		 * Since aio_free_ring() uses non-zero ->mmap_size
-		 * as indicator that it needs to unmap the area,
-		 * just set it to 0; aio_free_ring() is the only
-		 * place that uses ->mmap_size, so it's safe.
-		 * That way we get all munmap done to current->mm -
-		 * all other callers have ctx->mm == current->mm.
-		 */
-		ctx->ring_info.mmap_size = 0;
-		put_ioctx(ctx);
-	}
+		count = radix_tree_gang_lookup(&mm->ioctx_rtree, (void **)ctx,
+					       0, ARRAY_SIZE(ctx));
+		for (i = 0; i < count; i++)
+			exit_aio_ctx(mm, ctx[i]);
+	} while (count);
 }
 
 /* aio_get_req
@@ -594,18 +614,15 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 
 	rcu_read_lock();
 
-	hlist_for_each_entry_rcu(ctx, &mm->ioctx_list, list) {
-		/*
-		 * RCU protects us against accessing freed memory but
-		 * we have to be careful not to get a reference when the
-		 * reference count already dropped to 0 (ctx->dead test
-		 * is unreliable because of races).
-		 */
-		if (ctx->user_id == ctx_id && !ctx->dead && try_get_ioctx(ctx)){
-			ret = ctx;
-			break;
-		}
-	}
+	ctx = radix_tree_lookup(&mm->ioctx_rtree, ctx_id);
+	/*
+	 * RCU protects us against accessing freed memory but
+	 * we have to be careful not to get a reference when the
+	 * reference count already dropped to 0 (ctx->dead test
+	 * is unreliable because of races).
+	 */
+	if (ctx && !ctx->dead && try_get_ioctx(ctx))
+		ret = ctx;
 
 	rcu_read_unlock();
 	return ret;
@@ -1200,7 +1217,7 @@ static void io_destroy(struct kioctx *ioctx)
 	spin_lock(&mm->ioctx_lock);
 	was_dead = ioctx->dead;
 	ioctx->dead = 1;
-	hlist_del_rcu(&ioctx->list);
+	radix_tree_delete(&mm->ioctx_rtree, ioctx->user_id);
 	spin_unlock(&mm->ioctx_lock);
 
 	dprintk("aio_release(%p)\n", ioctx);
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 31ff6db..dd3fbdf 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -186,7 +186,6 @@ struct kioctx {
 
 	/* This needs improving */
 	unsigned long		user_id;
-	struct hlist_node	list;
 
 	wait_queue_head_t	wait;
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ace9a5f..758ad98 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/threads.h>
 #include <linux/list.h>
+#include <linux/radix-tree.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
@@ -386,7 +387,7 @@ struct mm_struct {
 	struct core_state *core_state; /* coredumping support */
 #ifdef CONFIG_AIO
 	spinlock_t		ioctx_lock;
-	struct hlist_head	ioctx_list;
+	struct radix_tree_root	ioctx_rtree;
 #endif
 #ifdef CONFIG_MM_OWNER
 	/*
diff --git a/kernel/fork.c b/kernel/fork.c
index 1766d32..66e37af 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -523,7 +523,7 @@ static void mm_init_aio(struct mm_struct *mm)
 {
 #ifdef CONFIG_AIO
 	spin_lock_init(&mm->ioctx_lock);
-	INIT_HLIST_HEAD(&mm->ioctx_list);
+	INIT_RADIX_TREE(&mm->ioctx_rtree, GFP_KERNEL);
 #endif
 }
 
-- 
1.7.10.4

