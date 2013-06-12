Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3FLEDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 00:03:33 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49346 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3FLEDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 00:03:32 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] Percpu tag allocator
Date: Tue, 11 Jun 2013 21:03:24 -0700
Message-Id: <1371009804-11596-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocates integers out of a predefined range - for use by e.g. a driver
to allocate tags for communicating with the device.

v2: Tejun pointed out that the original strategy completely breaks if
nr_cpus is large enough. I think (hope) I realized that at one point,
but completely forgot in the months since I originally implemented it.

Came up with a new strategy where we keep track of the number of cpus
that have tags on their percpu freelists, then steal from a different
random cpu if too many cpus have tags on their freelists.

Note that the synchronization is _definitely_ tricky - we're using
xchg()/cmpxchg() on the percpu lists, to synchronize between
steal_tags().

The alternative would've been adding a spinlock to protect the percpu
freelists, but that would've required some different tricky code to
avoid deadlock because of the lock ordering.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
---
 include/linux/percpu-tags.h |  63 +++++++++
 lib/Makefile                |   2 +-
 lib/percpu-tags.c           | 313 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 377 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/percpu-tags.h
 create mode 100644 lib/percpu-tags.c

diff --git a/include/linux/percpu-tags.h b/include/linux/percpu-tags.h
new file mode 100644
index 0000000..c86b7af
--- /dev/null
+++ b/include/linux/percpu-tags.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright 2012 Google Inc. All Rights Reserved.
+ * Author: koverstreet@google.com (Kent Overstreet)
+ *
+ * Per cpu tag allocator. Allocates small integers - up to nr_tags passed to
+ * percpu_tag_pool_init() - for use with say driver tag structures for talking
+ * to a device.
+ *
+ * It works by caching tags on percpu freelists, and then tags are
+ * allocated/freed from the global freelist in batches.
+ *
+ * Note that it will in general be impossible to allocate all nr_tags tags,
+ * since some tags will be stranded on other cpu's freelists: but we guarantee
+ * that nr_tags / 2 can always be allocated.
+ *
+ * This is done by keeping track of which cpus have tags on their percpu
+ * freelists in a bitmap, and then on allocation failure if too many cpus have
+ * tags on their freelists - i.e. if cpus_have_tags * TAG_CPU_SIZE (64) >
+ * nr_tags / 2 - then we steal one remote cpu's freelist (effectively picked at
+ * random).
+ *
+ * This means that if a workload spans a huge number of cpus - in relation to
+ * the number of tags that can be allocated - performance will suffer somewhat;
+ * but as long as the workload is bounded to a reasonable number of cpus the
+ * percpu-ness of the allocator will not be affected.
+ */
+
+#ifndef _LINUX_TAGS_H
+#define _LINUX_TAGS_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+struct percpu_tag_cpu_freelist;
+
+struct percpu_tag_pool {
+	unsigned			nr_tags;
+
+	struct percpu_tag_cpu_freelist	*tag_cpu;
+	unsigned long			*cpus_have_tags;
+
+	struct {
+		spinlock_t		lock;
+		unsigned		cpu_last_stolen;
+		/* Global freelist */
+		unsigned		nr_free;
+		unsigned		*freelist;
+		wait_queue_head_t	wait;
+	} ____cacheline_aligned_in_smp;
+};
+
+unsigned percpu_tag_alloc(struct percpu_tag_pool *pool, gfp_t gfp);
+void percpu_tag_free(struct percpu_tag_pool *pool, unsigned tag);
+
+void percpu_tag_pool_free(struct percpu_tag_pool *pool);
+int percpu_tag_pool_init(struct percpu_tag_pool *pool, unsigned long nr_tags);
+
+enum {
+	TAG_FAIL	= -1U,
+	TAG_MAX		= TAG_FAIL - 1,
+};
+
+#endif
diff --git a/lib/Makefile b/lib/Makefile
index 386db4b..e29a354 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o percpu-refcount.o
+	 earlycpio.o percpu-refcount.o percpu-tags.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff --git a/lib/percpu-tags.c b/lib/percpu-tags.c
new file mode 100644
index 0000000..e43b428
--- /dev/null
+++ b/lib/percpu-tags.c
@@ -0,0 +1,313 @@
+/*
+ * Copyright 2012 Google Inc. All Rights Reserved.
+ * Author: koverstreet@google.com (Kent Overstreet)
+ *
+ * Per cpu tag allocator.
+ */
+
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/percpu-tags.h>
+
+#define TAG_CPU_WATERMARK	32U
+#define TAG_CPU_SIZE		TAG_CPU_WATERMARK * 2
+
+#define TAG_CPU_STEALING	UINT_MAX
+
+struct percpu_tag_cpu_freelist {
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
+static bool steal_tags(struct percpu_tag_pool *pool,
+		       struct percpu_tag_cpu_freelist *tags)
+{
+	unsigned i, nr_free, cpus_have_tags = 0, cpu = pool->cpu_last_stolen;
+	struct percpu_tag_cpu_freelist *remote;
+
+	for (i = 0; i < DIV_ROUND_UP(nr_cpu_ids, BITS_PER_LONG); i++)
+		cpus_have_tags += hweight_long(pool->cpus_have_tags[i]);
+
+	while (cpus_have_tags-- * TAG_CPU_SIZE > pool->nr_tags / 2) {
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
+		if (remote == tags)
+			continue;
+
+		clear_bit(cpu, pool->cpus_have_tags);
+
+		nr_free = xchg(&remote->nr_free, TAG_CPU_STEALING);
+
+		if (nr_free) {
+			memcpy(tags->freelist,
+			       remote->freelist,
+			       sizeof(unsigned) * nr_free);
+			smp_mb();
+			remote->nr_free = 0;
+			tags->nr_free = nr_free;
+			return true;
+		} else {
+			remote->nr_free = 0;
+		}
+	}
+
+	return false;
+}
+
+static bool alloc_global_tags(struct percpu_tag_pool *pool,
+			      struct percpu_tag_cpu_freelist *tags)
+{
+	if (pool->nr_free) {
+		move_tags(tags->freelist, &tags->nr_free,
+			  pool->freelist, &pool->nr_free,
+			  min(pool->nr_free, TAG_CPU_WATERMARK));
+		return true;
+	}
+
+	return false;
+}
+
+static unsigned alloc_local_tag(struct percpu_tag_pool *pool,
+				struct percpu_tag_cpu_freelist *tags)
+{
+	unsigned nr_free, old, new, tag;
+
+	/*
+	 * Try per cpu freelist
+	 * Since we don't have global lock held, need to use cmpxchg()
+	 * to guard against a different thread using steal_tags() on us:
+	 */
+	nr_free = tags->nr_free;
+
+	do {
+		if (!nr_free || nr_free == TAG_CPU_STEALING)
+			return TAG_FAIL;
+
+		old = nr_free;
+		new = old - 1;
+		tag = tags->freelist[new];
+
+		nr_free = cmpxchg(&tags->nr_free, old, new);
+	} while (nr_free != old);
+
+	return tag;
+}
+
+/**
+ * tag_alloc - allocate a tag
+ * @pool: pool to allocate from
+ * @gfp: gfp flags
+ *
+ * Returns a tag - an integer in the range [0..nr_tags) (passed to
+ * tag_pool_init()), or otherwise TAG_FAIL on allocation failure.
+ *
+ * Will not fail if passed __GFP_WAIT.
+ */
+unsigned percpu_tag_alloc(struct percpu_tag_pool *pool, gfp_t gfp)
+{
+	DEFINE_WAIT(wait);
+	struct percpu_tag_cpu_freelist *tags;
+	unsigned long flags;
+	unsigned tag, this_cpu;
+
+	while (1) {
+		local_irq_save(flags);
+		this_cpu = smp_processor_id();
+		tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
+
+		tag = alloc_local_tag(pool, tags);
+		if (tag != TAG_FAIL)
+			break;
+
+		spin_lock(&pool->lock);
+
+		/*
+		 * prepare_to_wait() must come before steal_tags(), in case
+		 * percpu_tag_free() on another cpu flips a bit in
+		 * cpus_have_tags
+		 */
+		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
+
+		/*
+		 * alloc_global_tags(), steal_tags() return true iff we now have
+		 * tags on our percpu freelist
+		 */
+		if (alloc_global_tags(pool, tags) ||
+		    steal_tags(pool, tags)) {
+			/* Global lock held, don't need cmpxchg */
+			tag = tags->freelist[--tags->nr_free];
+			if (tags->nr_free)
+				set_bit(this_cpu, pool->cpus_have_tags);
+
+			spin_unlock(&pool->lock);
+			break;
+		}
+
+		if (!(gfp & __GFP_WAIT)) {
+			spin_unlock(&pool->lock);
+			break;
+		}
+
+		spin_unlock(&pool->lock);
+		local_irq_restore(flags);
+
+		schedule();
+	}
+
+	local_irq_restore(flags);
+	finish_wait(&pool->wait, &wait);
+	return tag;
+}
+EXPORT_SYMBOL_GPL(percpu_tag_alloc);
+
+/**
+ * tag_free - free a tag
+ * @pool: pool @tag was allocated from
+ * @tag: a tag previously allocated with tag_alloc()
+ */
+void percpu_tag_free(struct percpu_tag_pool *pool, unsigned tag)
+{
+	struct percpu_tag_cpu_freelist *tags;
+	unsigned long flags;
+	unsigned nr_free, old, new, this_cpu;
+
+	BUG_ON(tag >= pool->nr_tags);
+
+	local_irq_save(flags);
+	this_cpu = smp_processor_id();
+	tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
+
+	/*
+	 * Need to guard against racing with steal_tags() on another cpu - we
+	 * can manage with just cmpxchg because we can only race with tags being
+	 * pulled off our freelist, not other threads pushing tags back onto our
+	 * freelist
+	 */
+	nr_free = tags->nr_free;
+
+	do {
+		if (nr_free == TAG_CPU_STEALING) {
+			cpu_relax();
+			nr_free = tags->nr_free;
+			continue;
+		}
+
+		old = nr_free;
+		new = old + 1;
+		tags->freelist[old] = tag;
+
+		nr_free = cmpxchg(&tags->nr_free, old, new);
+	} while (nr_free != old);
+
+	if (!nr_free) {
+		set_bit(this_cpu, pool->cpus_have_tags);
+		wake_up(&pool->wait);
+	}
+
+	if (new == TAG_CPU_SIZE) {
+		spin_lock(&pool->lock);
+		/* Might have had our tags stolen before we took global lock */
+		if (tags->nr_free == TAG_CPU_SIZE) {
+			move_tags(pool->freelist, &pool->nr_free,
+				  tags->freelist, &tags->nr_free,
+				  TAG_CPU_WATERMARK);
+
+			wake_up(&pool->wait);
+		}
+		spin_unlock(&pool->lock);
+	}
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(percpu_tag_free);
+
+/**
+ * tag_pool_free - release a tag pool's resources
+ * @pool: pool to free
+ *
+ * Frees the resources allocated by tag_pool_init().
+ */
+void percpu_tag_pool_free(struct percpu_tag_pool *pool)
+{
+	free_percpu(pool->tag_cpu);
+	kfree(pool->cpus_have_tags);
+	free_pages((unsigned long) pool->freelist,
+		   get_order(pool->nr_tags * sizeof(unsigned)));
+}
+EXPORT_SYMBOL_GPL(percpu_tag_pool_free);
+
+/**
+ * tag_pool_init - initialize a percpu tag pool
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
+int percpu_tag_pool_init(struct percpu_tag_pool *pool, unsigned long nr_tags)
+{
+	unsigned i, order;
+
+	memset(pool, 0, sizeof(*pool));
+
+	spin_lock_init(&pool->lock);
+	init_waitqueue_head(&pool->wait);
+	pool->nr_tags = nr_tags;
+
+	/* Guard against overflow */
+	if (nr_tags > TAG_MAX) {
+		pr_err("tags.c: nr_tags too large\n");
+		return -EINVAL;
+	}
+
+	order = get_order(nr_tags * sizeof(unsigned));
+	pool->freelist = (void *) __get_free_pages(GFP_KERNEL, order);
+	if (!pool->freelist)
+		goto err;
+
+	for (i = 0; i < nr_tags; i++)
+		pool->freelist[i] = i;
+
+	pool->nr_free = nr_tags;
+
+	pool->cpus_have_tags = kzalloc(DIV_ROUND_UP(nr_cpu_ids, BITS_PER_LONG) *
+				       sizeof(unsigned long), GFP_KERNEL);
+	if (!pool->cpus_have_tags)
+		goto err;
+
+	pool->tag_cpu = __alloc_percpu(sizeof(struct percpu_tag_cpu_freelist) +
+				       TAG_CPU_SIZE * sizeof(unsigned),
+				       sizeof(unsigned));
+	if (!pool->tag_cpu)
+		goto err;
+
+	return 0;
+err:
+	percpu_tag_pool_free(pool);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(percpu_tag_pool_init);
-- 
1.8.3.rc1

