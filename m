Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab3HQAT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:19:28 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:47968 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab3HQATP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:19:15 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v3 1/4] idr: Percpu ida
Date: Fri, 16 Aug 2013 23:09:06 +0000
Message-Id: <1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

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
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/idr.h |   53 +++++++++
 lib/idr.c           |  316 +++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 361 insertions(+), 8 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 871a213..f0db12b 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -16,6 +16,8 @@
 #include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock_types.h>
+#include <linux/wait.h>
 
 /*
  * We want shallower trees and thus more bits covered at each layer.  8
@@ -243,4 +245,55 @@ static inline int ida_get_new(struct ida *ida, int *p_id)
 
 void __init idr_init_cache(void);
 
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
+		spinlock_t		lock;
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
+		/*
+		 * Global freelist - it's a stack where nr_free points to the
+		 * top
+		 */
+		unsigned		nr_free;
+		unsigned		*freelist;
+	} ____cacheline_aligned_in_smp;
+};
+
+int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp);
+void percpu_ida_free(struct percpu_ida *pool, unsigned tag);
+
+void percpu_ida_destroy(struct percpu_ida *pool);
+int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags);
+
 #endif /* __IDR_H__ */
diff --git a/lib/idr.c b/lib/idr.c
index bfe4db4..57bfabe 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -26,17 +26,20 @@
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
 
 #define MAX_IDR_SHIFT		(sizeof(int) * 8 - 1)
 #define MAX_IDR_BIT		(1U << MAX_IDR_SHIFT)
@@ -1159,3 +1162,300 @@ void ida_init(struct ida *ida)
 
 }
 EXPORT_SYMBOL(ida_init);
+
+/* Percpu IDA */
+
+/*
+ * Number of tags we move between the percpu freelist and the global freelist at
+ * a time
+ */
+#define IDA_PCPU_BATCH_MOVE	32U
+
+/* Max size of percpu freelist, */
+#define IDA_PCPU_SIZE		((IDA_PCPU_BATCH_MOVE * 3) / 2)
+
+struct percpu_ida_cpu {
+	spinlock_t			lock;
+	unsigned			nr_free;
+	unsigned			freelist[];
+};
+
+static inline void move_tags(unsigned *dst, unsigned *dst_nr,
+			     unsigned *src, unsigned *src_nr,
+			     unsigned nr)
+{
+	*src_nr -= nr;
+	memcpy(dst + *dst_nr, src + *src_nr, sizeof(unsigned) * nr);
+	*dst_nr += nr;
+}
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
+ */
+static inline void steal_tags(struct percpu_ida *pool,
+			      struct percpu_ida_cpu *tags)
+{
+	unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
+	struct percpu_ida_cpu *remote;
+
+	for (cpus_have_tags = bitmap_weight(pool->cpus_have_tags, nr_cpu_ids);
+	     cpus_have_tags * IDA_PCPU_SIZE > pool->nr_tags / 2;
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
+			break;
+	}
+}
+
+static inline void alloc_global_tags(struct percpu_ida *pool,
+				     struct percpu_ida_cpu *tags)
+{
+	move_tags(tags->freelist, &tags->nr_free,
+		  pool->freelist, &pool->nr_free,
+		  min(pool->nr_free, IDA_PCPU_BATCH_MOVE));
+}
+
+static inline unsigned alloc_local_tag(struct percpu_ida *pool,
+				       struct percpu_ida_cpu *tags)
+{
+	int tag = -ENOSPC;
+
+	spin_lock(&tags->lock);
+	if (tags->nr_free)
+		tag = tags->freelist[--tags->nr_free];
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
+	int tag;
+
+	local_irq_save(flags);
+	tags = this_cpu_ptr(pool->tag_cpu);
+
+	/* Fastpath */
+	tag = alloc_local_tag(pool, tags);
+	if (likely(tag >= 0)) {
+		local_irq_restore(flags);
+		return tag;
+	}
+
+	while (1) {
+		spin_lock(&pool->lock);
+
+		/*
+		 * prepare_to_wait() must come before steal_tags(), in case
+		 * percpu_ida_free() on another cpu flips a bit in
+		 * cpus_have_tags
+		 *
+		 * global lock held and irqs disabled, don't need percpu lock
+		 */
+		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
+
+		if (!tags->nr_free)
+			alloc_global_tags(pool, tags);
+		if (!tags->nr_free)
+			steal_tags(pool, tags);
+
+		if (tags->nr_free) {
+			tag = tags->freelist[--tags->nr_free];
+			if (tags->nr_free)
+				set_bit(smp_processor_id(),
+					pool->cpus_have_tags);
+		}
+
+		spin_unlock(&pool->lock);
+		local_irq_restore(flags);
+
+		if (tag >= 0 || !(gfp & __GFP_WAIT))
+			break;
+
+		schedule();
+
+		local_irq_save(flags);
+		tags = this_cpu_ptr(pool->tag_cpu);
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
+	unsigned nr_free;
+
+	BUG_ON(tag >= pool->nr_tags);
+
+	local_irq_save(flags);
+	tags = this_cpu_ptr(pool->tag_cpu);
+
+	spin_lock(&tags->lock);
+	tags->freelist[tags->nr_free++] = tag;
+
+	nr_free = tags->nr_free;
+	spin_unlock(&tags->lock);
+
+	if (nr_free == 1) {
+		set_bit(smp_processor_id(),
+			pool->cpus_have_tags);
+		wake_up(&pool->wait);
+	}
+
+	if (nr_free == IDA_PCPU_SIZE) {
+		spin_lock(&pool->lock);
+
+		/*
+		 * Global lock held and irqs disabled, don't need percpu
+		 * lock
+		 */
+		if (tags->nr_free == IDA_PCPU_SIZE) {
+			move_tags(pool->freelist, &pool->nr_free,
+				  tags->freelist, &tags->nr_free,
+				  IDA_PCPU_BATCH_MOVE);
+
+			wake_up(&pool->wait);
+		}
+		spin_unlock(&pool->lock);
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
+	free_pages((unsigned long) pool->freelist,
+		   get_order(pool->nr_tags * sizeof(unsigned)));
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
+	unsigned i, cpu, order;
+
+	memset(pool, 0, sizeof(*pool));
+
+	init_waitqueue_head(&pool->wait);
+	spin_lock_init(&pool->lock);
+	pool->nr_tags = nr_tags;
+
+	/* Guard against overflow */
+	if (nr_tags > (unsigned) INT_MAX + 1) {
+		pr_err("tags.c: nr_tags too large\n");
+		return -EINVAL;
+	}
+
+	order = get_order(nr_tags * sizeof(unsigned));
+	pool->freelist = (void *) __get_free_pages(GFP_KERNEL, order);
+	if (!pool->freelist)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_tags; i++)
+		pool->freelist[i] = i;
+
+	pool->nr_free = nr_tags;
+
+	pool->cpus_have_tags = kzalloc(BITS_TO_LONGS(nr_cpu_ids) *
+				       sizeof(unsigned long), GFP_KERNEL);
+	if (!pool->cpus_have_tags)
+		goto err;
+
+	pool->tag_cpu = __alloc_percpu(sizeof(struct percpu_ida_cpu) +
+				       IDA_PCPU_SIZE * sizeof(unsigned),
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
-- 
1.7.10.4

