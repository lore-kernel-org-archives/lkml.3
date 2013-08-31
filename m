Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3HaDIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 23:08:55 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:52774 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab3HaDIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 23:08:49 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Asias He <asias@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v5 1/6] idr: Percpu ida
Date: Sat, 31 Aug 2013 02:52:31 +0000
Message-Id: <1377917556-11955-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1377917556-11955-1-git-send-email-nab@linux-iscsi.org>
References: <1377917556-11955-1-git-send-email-nab@linux-iscsi.org>
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

v5 changes:
  - Change percpu_ida->cpus_have_tags to cpumask_t (kmo + akpm)
  - Add comment for percpu_ida_cpu->lock + ->nr_free (kmo + akpm)
  - Convert steal_tags() to use cpumask_weight() + cpumask_next() +
    cpumask_first() + cpumask_clear_cpu() (kmo + akpm)
  - Add comment for alloc_global_tags() (kmo + akpm)
  - Convert percpu_ida_alloc() to use cpumask_set_cpu() (kmo + akpm)
  - Convert percpu_ida_free() to use cpumask_set_cpu() (kmo + akpm)
  - Drop percpu_ida->cpus_have_tags allocation in percpu_ida_init()
    (kmo + akpm)
  - Drop percpu_ida->cpus_have_tags kfree in percpu_ida_destroy()
    (kmo + akpm)
  - Add comment for percpu_ida_alloc @ gfp (kmo + akpm)
  - Move to percpu_ida.c + percpu_ida.h (kmo + akpm + nab)

v4 changes:

  - Fix tags.c reference in percpu_ida_init (akpm)

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/percpu_ida.h |   59 ++++++++
 lib/Makefile               |    5 +-
 lib/percpu_ida.c           |  335 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 397 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/percpu_ida.h
 create mode 100644 lib/percpu_ida.c

diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
new file mode 100644
index 0000000..8a39cdc
--- /dev/null
+++ b/include/linux/percpu_ida.h
@@ -0,0 +1,59 @@
+#ifndef __PERCPU_IDA_H__
+#define __PERCPU_IDA_H__
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+#include <linux/init.h>
+#include <linux/spinlock_types.h>
+#include <linux/wait.h>
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
+	cpumask_t			cpus_have_tags;
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
+#endif /* __PERCPU_IDA_H__ */
diff --git a/lib/Makefile b/lib/Makefile
index 7baccfd..1cb8356 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o percpu-refcount.o
+	 earlycpio.o percpu-refcount.o percpu_ida.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
@@ -24,7 +24,8 @@ lib-y	+= kobject.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
-	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
+	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
+	 percpu_ida.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
new file mode 100644
index 0000000..3ef70e8
--- /dev/null
+++ b/lib/percpu_ida.c
@@ -0,0 +1,335 @@
+/*
+ * Percpu IDA library
+ *
+ * Copyright (C) 2013 Datera, Inc. Kent Overstreet
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/bug.h>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/hardirq.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/spinlock.h>
+#include <linux/percpu_ida.h>
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
+	/*
+	 * Even though this is percpu, we need a lock for tag stealing by remote
+	 * CPUs:
+	 */
+	spinlock_t			lock;
+
+	/* nr_free/freelist form a stack of free IDs */
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
+	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
+	     cpus_have_tags * IDA_PCPU_SIZE > pool->nr_tags / 2;
+	     cpus_have_tags--) {
+		cpu = cpumask_next(cpu, &pool->cpus_have_tags);
+
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_first(&pool->cpus_have_tags);
+
+		if (cpu >= nr_cpu_ids)
+			BUG();
+
+		pool->cpu_last_stolen = cpu;
+		remote = per_cpu_ptr(pool->tag_cpu, cpu);
+
+		cpumask_clear_cpu(cpu, &pool->cpus_have_tags);
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
+/*
+ * Pop up to IDA_PCPU_BATCH_MOVE IDs off the global freelist, and push them onto
+ * our percpu freelist:
+ */
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
+ * @gfp indicates whether or not to wait until a free id is available (it's not
+ * used for internal memory allocations); thus if passed __GFP_WAIT we may sleep
+ * however long it takes until another thread frees an id (same semantics as a
+ * mempool).
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
+				cpumask_set_cpu(smp_processor_id(),
+						&pool->cpus_have_tags);
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
+		cpumask_set_cpu(smp_processor_id(),
+				&pool->cpus_have_tags);
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
+		pr_err("percpu_ida_init(): nr_tags too large\n");
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
1.7.2.5

