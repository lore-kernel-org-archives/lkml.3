Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab3FSAEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:04:11 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62376 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSACx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:02:53 -0400
From: Kent Overstreet <koverstreet@google.com>
To: akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        nab@linux-iscsi.org, bcrl@kvack.org, linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 04/10] idr: Percpu ida
Date: Tue, 18 Jun 2013 17:02:24 -0700
Message-Id: <1371600150-23557-5-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1371600150-23557-1-git-send-email-koverstreet@google.com>
References: <1371600150-23557-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Percpu frontend for allocating ids. With percpu allocation (that works),
it's impossible to guarantee it will always be possible to allocate all
nr_tags - typically, some will be stuck on a remote percpu freelist
where the current job can't get to them.

We do guarantee that it will always be possible to allocate at least
(nr_tags / 2) tags - this is done by keeping track of which and how many
cpus have tags on their percpu freelists. On allocation failure if
enough cpus have tags that there could potentially be (nr_tags / 2) tags
stuck on remote percpu freelists, we then pick a remote cpu at random to
steal from.

Note that the synchronization is _definitely_ tricky - we're using
xchg()/cmpxchg() on the percpu lists, to synchronize between
steal_tags().

The alternative would've been adding a spinlock to protect the percpu
freelists, but that would've required some different tricky code to
avoid deadlock because of the lock ordering.

Note that there's no cpu hotplug notifier - we don't care, because
steal_tags() will eventually get the down cpu's tags. We _could_ satisfy
more allocations if we had a notifier - but we'll still meet our
guarantees and it's absolutely not a correctness issue, so I don't think
it's worth the extra code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
---
 include/linux/idr.h |  48 ++++++++
 lib/idr.c           | 312 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 352 insertions(+), 8 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index a78cf99..3ba796b 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -16,6 +16,8 @@
 #include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock_types.h>
+#include <linux/wait.h>
 
 /* IDA */
 
@@ -97,6 +99,52 @@ static inline void ida_init(struct ida *ida)
 	ida_init_prealloc(ida, 0);
 }
 
+/* Percpu IDA/tag allocator */
+
+struct percpu_ida_cpu;
+
+struct percpu_ida {
+	/*
+	 * number of tags available to be allocated, as passed to
+	 * percpu_ida_init()
+	 */
+	unsigned			nr_tags;
+
+	struct percpu_ida_cpu __percpu	*tag_cpu;
+
+	/*
+	 * Bitmap of cpus that (may) have tags on their percpu freelists:
+	 * steal_tags() uses this to decide when to steal tags, and which cpus
+	 * to try stealing from.
+	 *
+	 * It's ok for a freelist to be empty when its bit is set - steal_tags()
+	 * will just keep looking - but the bitmap _must_ be set whenever a
+	 * percpu freelist does have tags.
+	 */
+	unsigned long			*cpus_have_tags;
+
+	struct {
+		/*
+		 * When we go to steal tags from another cpu (see steal_tags()),
+		 * we want to pick a cpu at random. Cycling through them every
+		 * time we steal is a bit easier and more or less equivalent:
+		 */
+		unsigned		cpu_last_stolen;
+
+		/* For sleeping on allocation failure */
+		wait_queue_head_t	wait;
+
+		/* Global freelist */
+		struct ida		ida;
+	} ____cacheline_aligned_in_smp;
+};
+
+int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp);
+void percpu_ida_free(struct percpu_ida *pool, unsigned tag);
+
+void percpu_ida_destroy(struct percpu_ida *pool);
+int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags);
+
 /* IDR */
 
 /*
diff --git a/lib/idr.c b/lib/idr.c
index e6b837a..4962e5d 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -28,17 +28,20 @@
  * with the slab allocator.
  */
 
-#ifndef TEST                        // to test in user space...
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/export.h>
-#endif
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/bug.h>
 #include <linux/err.h>
-#include <linux/string.h>
+#include <linux/export.h>
+#include <linux/hardirq.h>
 #include <linux/idr.h>
-#include <linux/spinlock.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/spinlock.h>
 
 #define IDA_TREE_ARY		BITS_PER_LONG
 
@@ -527,6 +530,299 @@ int ida_init_prealloc(struct ida *ida, unsigned prealloc)
 }
 EXPORT_SYMBOL(ida_init_prealloc);
 
+/* Percpu IDA */
+
+/*
+ * Number of tags we move between the percpu freelist and the global freelist at
+ * a time
+ */
+#define TAG_CPU_BATCH_MOVE	32U
+
+/* Max size of percpu freelist, */
+#define TAG_CPU_SIZE		(TAG_CPU_BATCH_MOVE + TAG_CPU_BATCH_MOVE / 2)
+
+struct percpu_ida_cpu {
+	spinlock_t			lock;
+	unsigned			nr_free;
+	unsigned			freelist[];
+};
+
+/*
+ * Try to steal tags from a remote cpu's percpu freelist.
+ *
+ * We first check how many percpu freelists have tags - we don't steal tags
+ * unless enough percpu freelists have tags on them that it's possible more than
+ * half the total tags could be stuck on remote percpu freelists.
+ *
+ * Then we iterate through the cpus until we find some tags - we don't attempt
+ * to find the "best" cpu to steal from, to keep cacheline bouncing to a
+ * minimum.
+ *
+ * Returns true on success (our percpu freelist is no longer empty), false on
+ * failure.
+ */
+static inline bool steal_tags(struct percpu_ida *pool,
+			      struct percpu_ida_cpu *tags)
+{
+	unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
+	struct percpu_ida_cpu *remote;
+
+	for (cpus_have_tags = bitmap_weight(pool->cpus_have_tags, nr_cpu_ids);
+	     cpus_have_tags * TAG_CPU_SIZE > pool->nr_tags / 2;
+	     cpus_have_tags--) {
+		cpu = find_next_bit(pool->cpus_have_tags, nr_cpu_ids, cpu);
+
+		if (cpu == nr_cpu_ids)
+			cpu = find_first_bit(pool->cpus_have_tags, nr_cpu_ids);
+
+		if (cpu == nr_cpu_ids)
+			BUG();
+
+		pool->cpu_last_stolen = cpu;
+		remote = per_cpu_ptr(pool->tag_cpu, cpu);
+
+		clear_bit(cpu, pool->cpus_have_tags);
+
+		if (remote == tags)
+			continue;
+
+		spin_lock(&remote->lock);
+
+		if (remote->nr_free) {
+			memcpy(tags->freelist,
+			       remote->freelist,
+			       sizeof(unsigned) * remote->nr_free);
+
+			tags->nr_free = remote->nr_free;
+			remote->nr_free = 0;
+		}
+
+		spin_unlock(&remote->lock);
+
+		if (tags->nr_free)
+			return true;
+	}
+
+	return false;
+}
+
+static inline bool alloc_global_tags(struct percpu_ida *pool,
+				     struct percpu_ida_cpu *tags)
+{
+	int nr_free = __ida_alloc_range_multiple(&pool->ida, tags->freelist,
+						 TAG_CPU_BATCH_MOVE, 0,
+						 pool->nr_tags, GFP_NOWAIT,
+						 NULL);
+
+	if (nr_free <= 0)
+		return false;
+
+	tags->nr_free = nr_free;
+	return true;
+}
+
+static inline unsigned alloc_local_tag(struct percpu_ida *pool,
+				       struct percpu_ida_cpu *tags)
+{
+	int tag = -ENOSPC;
+
+	spin_lock(&tags->lock);
+	if (tags->nr_free)
+			tag = tags->freelist[--tags->nr_free];
+	spin_unlock(&tags->lock);
+
+	return tag;
+}
+
+/**
+ * percpu_ida_alloc - allocate a tag
+ * @pool: pool to allocate from
+ * @gfp: gfp flags
+ *
+ * Returns a tag - an integer in the range [0..nr_tags) (passed to
+ * tag_pool_init()), or otherwise -ENOSPC on allocation failure.
+ *
+ * Safe to be called from interrupt context (assuming it isn't passed
+ * __GFP_WAIT, of course).
+ *
+ * Will not fail if passed __GFP_WAIT.
+ */
+int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
+{
+	DEFINE_WAIT(wait);
+	struct percpu_ida_cpu *tags;
+	unsigned long flags;
+	unsigned this_cpu;
+	int tag;
+
+	local_irq_save(flags);
+	this_cpu = smp_processor_id();
+	tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
+
+	/* Fastpath */
+	tag = alloc_local_tag(pool, tags);
+	if (likely(tag >= 0)) {
+		local_irq_restore(flags);
+		return tag;
+	}
+
+	while (1) {
+		spin_lock(&pool->ida.lock);
+
+		/*
+		 * prepare_to_wait() must come before steal_tags(), in case
+		 * percpu_ida_free() on another cpu flips a bit in
+		 * cpus_have_tags
+		 */
+		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
+
+		/*
+		 * alloc_global_tags(), steal_tags() return true iff we now have
+		 * tags on our percpu freelist
+		 */
+		if (tags->nr_free ||
+		    alloc_global_tags(pool, tags) ||
+		    steal_tags(pool, tags)) {
+			/*
+			 * Global lock held and irqs disabled, don't need percpu
+			 * lock
+			 */
+			tag = tags->freelist[--tags->nr_free];
+			if (tags->nr_free)
+				set_bit(this_cpu, pool->cpus_have_tags);
+		}
+
+		spin_unlock(&pool->ida.lock);
+		local_irq_restore(flags);
+
+		if (tag >= 0 || !(gfp & __GFP_WAIT))
+			break;
+
+		schedule();
+
+		local_irq_save(flags);
+		this_cpu = smp_processor_id();
+		tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
+	}
+
+	finish_wait(&pool->wait, &wait);
+	return tag;
+}
+EXPORT_SYMBOL_GPL(percpu_ida_alloc);
+
+/**
+ * percpu_ida_free - free a tag
+ * @pool: pool @tag was allocated from
+ * @tag: a tag previously allocated with percpu_ida_alloc()
+ *
+ * Safe to be called from interrupt context.
+ */
+void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
+{
+	struct percpu_ida_cpu *tags;
+	unsigned long flags;
+	unsigned nr_free, this_cpu;
+
+	BUG_ON(tag >= pool->nr_tags);
+
+	local_irq_save(flags);
+	this_cpu = smp_processor_id();
+	tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
+
+	spin_lock(&tags->lock);
+	nr_free = tags->nr_free;
+	tags->freelist[tags->nr_free++] = tag;
+	spin_unlock(&tags->lock);
+
+	if (!nr_free) {
+		set_bit(this_cpu, pool->cpus_have_tags);
+		wake_up(&pool->wait);
+	}
+
+	if (nr_free + 1 == TAG_CPU_SIZE) {
+		spin_lock(&pool->ida.lock);
+
+		/*
+		 * Global lock held and irqs disabled, don't need percpu
+		 * lock
+		 */
+		while (tags->nr_free > TAG_CPU_SIZE - TAG_CPU_BATCH_MOVE)
+			__ida_remove(&pool->ida,
+				     tags->freelist[--tags->nr_free]);
+
+		wake_up(&pool->wait);
+		spin_unlock(&pool->ida.lock);
+	}
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(percpu_ida_free);
+
+/**
+ * percpu_ida_destroy - release a tag pool's resources
+ * @pool: pool to free
+ *
+ * Frees the resources allocated by percpu_ida_init().
+ */
+void percpu_ida_destroy(struct percpu_ida *pool)
+{
+	free_percpu(pool->tag_cpu);
+	kfree(pool->cpus_have_tags);
+	ida_destroy(&pool->ida);
+}
+EXPORT_SYMBOL_GPL(percpu_ida_destroy);
+
+/**
+ * percpu_ida_init - initialize a percpu tag pool
+ * @pool: pool to initialize
+ * @nr_tags: number of tags that will be available for allocation
+ *
+ * Initializes @pool so that it can be used to allocate tags - integers in the
+ * range [0, nr_tags). Typically, they'll be used by driver code to refer to a
+ * preallocated array of tag structures.
+ *
+ * Allocation is percpu, but sharding is limited by nr_tags - for best
+ * performance, the workload should not span more cpus than nr_tags / 128.
+ */
+int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags)
+{
+	unsigned cpu;
+
+	memset(pool, 0, sizeof(*pool));
+
+	init_waitqueue_head(&pool->wait);
+	pool->nr_tags = nr_tags;
+
+	/* Guard against overflow */
+	if (nr_tags > (unsigned) INT_MAX + 1) {
+		pr_err("tags.c: nr_tags too large\n");
+		return -EINVAL;
+	}
+
+	if (ida_init_prealloc(&pool->ida, nr_tags))
+		return -ENOMEM;
+
+	pool->cpus_have_tags = kzalloc(BITS_TO_LONGS(nr_cpu_ids) *
+				       sizeof(unsigned long), GFP_KERNEL);
+	if (!pool->cpus_have_tags)
+		goto err;
+
+	pool->tag_cpu = __alloc_percpu(sizeof(struct percpu_ida_cpu) +
+				       TAG_CPU_SIZE * sizeof(unsigned),
+				       sizeof(unsigned));
+	if (!pool->tag_cpu)
+		goto err;
+
+	for_each_possible_cpu(cpu)
+		spin_lock_init(&per_cpu_ptr(pool->tag_cpu, cpu)->lock);
+
+	return 0;
+err:
+	percpu_ida_destroy(pool);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(percpu_ida_init);
+
 /* IDR */
 
 #define MAX_IDR_SHIFT		(sizeof(int) * 8 - 1)
-- 
1.8.3.1

