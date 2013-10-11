Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab3JKHYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:24:24 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34940 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab3JKHYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:24:22 -0400
Message-Id: <20131011072404.749268620@kernel.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Oct 2013 15:18:06 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: kmo@daterainc.com
Subject: [patch 4/4] blk-mq: switch to percpu-ida for tag menagement
References: <20131011071802.148101321@kernel.org>
Content-Disposition: inline; filename=0004-blk-mq-switch-to-percpu-ida-for-tag-menagement.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using percpu-ida to manage blk-mq tags. the percpu-ida has similar algorithm
like the blk-mq-tag. The difference is when a cpu can't allocate tags
blk-mq-tag uses ipi to purge remote cpu cache and percpu-ida directly purges
remote cpu cache. In practice (testing null_blk), the percpu-ida approach is
much faster when total tags aren't enough.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-mq-tag.c |  470 +++++++----------------------------------------------
 1 file changed, 68 insertions(+), 402 deletions(-)

Index: master/block/blk-mq-tag.c
===================================================================
--- master.orig/block/blk-mq-tag.c	2013-10-11 12:15:17.200288445 +0800
+++ master/block/blk-mq-tag.c	2013-10-11 12:15:17.196288502 +0800
@@ -1,9 +1,6 @@
 #include <linux/kernel.h>
-#include <linux/threads.h>
 #include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/cpu.h>
+#include <linux/percpu_ida.h>
 
 #include <linux/blk-mq.h>
 #include "blk.h"
@@ -11,291 +8,53 @@
 #include "blk-mq-tag.h"
 
 /*
- * Per-cpu cache entries
- */
-struct blk_mq_tag_map {
-	unsigned int nr_free;
-	unsigned int freelist[];
-};
-
-/*
  * Per tagged queue (tag address space) map
  */
 struct blk_mq_tags {
 	unsigned int nr_tags;
-	unsigned int reserved_tags;
-	unsigned int batch_move;
-	unsigned int max_cache;
-
-	struct {
-		spinlock_t lock;
-		unsigned int nr_free;
-		unsigned int *freelist;
-		unsigned int nr_reserved;
-		unsigned int *reservelist;
-		struct list_head wait;
-	} ____cacheline_aligned_in_smp;
-
-	struct blk_mq_tag_map __percpu *free_maps;
-
-	struct blk_mq_cpu_notifier cpu_notifier;
-};
+	unsigned int nr_reserved_tags;
+	unsigned int nr_batch_move;
+	unsigned int nr_max_cache;
 
-struct blk_mq_tag_wait {
-	struct list_head list;
-	struct task_struct *task;
+	struct percpu_ida free_tags;
+	struct percpu_ida reserved_tags;
 };
 
-#define DEFINE_TAG_WAIT(name)						\
-	struct blk_mq_tag_wait name = {					\
-		.list		= LIST_HEAD_INIT((name).list),		\
-		.task		= current,				\
-	}
-
-static unsigned int move_tags(unsigned int *dst, unsigned int *dst_nr,
-			      unsigned int *src, unsigned int *src_nr,
-			      unsigned int nr_to_move)
-{
-	nr_to_move = min(nr_to_move, *src_nr);
-	*src_nr -= nr_to_move;
-	memcpy(dst + *dst_nr, src + *src_nr, sizeof(int) * nr_to_move);
-	*dst_nr += nr_to_move;
-
-	return nr_to_move;
-}
-
-static void __wake_waiters(struct blk_mq_tags *tags, unsigned int nr)
-{
-	while (nr && !list_empty(&tags->wait)) {
-		struct blk_mq_tag_wait *waiter;
-
-		waiter = list_entry(tags->wait.next, struct blk_mq_tag_wait,
-					list);
-		list_del_init(&waiter->list);
-		wake_up_process(waiter->task);
-		nr--;
-	}
-}
-
-static void __blk_mq_tag_return(struct blk_mq_tags *tags,
-				struct blk_mq_tag_map *map, unsigned int nr)
-{
-	unsigned int waiters;
-
-	lockdep_assert_held(&tags->lock);
-
-	waiters = move_tags(tags->freelist, &tags->nr_free, map->freelist,
-				&map->nr_free, nr);
-	if (!list_empty(&tags->wait))
-		__wake_waiters(tags, waiters);
-}
-
-static void blk_mq_tag_return(struct blk_mq_tags *tags,
-			      struct blk_mq_tag_map *map, unsigned int nr)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&tags->lock, flags);
-	__blk_mq_tag_return(tags, map, nr);
-	spin_unlock_irqrestore(&tags->lock, flags);
-}
-
-#if NR_CPUS != 1
-static void prune_cache(void *data)
-{
-	struct blk_mq_tags *tags = data;
-	struct blk_mq_tag_map *map;
-
-	map = per_cpu_ptr(tags->free_maps, smp_processor_id());
-
-	spin_lock(&tags->lock);
-	__blk_mq_tag_return(tags, map, tags->batch_move);
-	spin_unlock(&tags->lock);
-}
-#endif
-
-static void ipi_local_caches(struct blk_mq_tags *tags, unsigned int this_cpu)
-{
-#if NR_CPUS != 1
-	cpumask_var_t ipi_mask;
-	unsigned int i, total;
-
-	/*
-	 * We could per-cpu cache this things, but overhead is probably not
-	 * large enough to care about it. If we fail, just punt to doing a
-	 * prune on all CPUs.
-	 */
-	if (!alloc_cpumask_var(&ipi_mask, GFP_ATOMIC)) {
-		smp_call_function(prune_cache, tags, 0);
-		return;
-	}
-
-	cpumask_clear(ipi_mask);
-
-	total = 0;
-	for_each_online_cpu(i) {
-		struct blk_mq_tag_map *map = per_cpu_ptr(tags->free_maps, i);
-
-		if (!map->nr_free)
-			continue;
-
-		total += map->nr_free;
-		cpumask_set_cpu(i, ipi_mask);
-
-		if (total > tags->batch_move)
-			break;
-	}
-
-	if (total) {
-		preempt_disable();
-		smp_call_function_many(ipi_mask, prune_cache, tags, 0);
-		preempt_enable();
-	}
-
-	free_cpumask_var(ipi_mask);
-#endif
-}
-
-/*
- * Wait on a free tag, move batch to map when we have it. Returns with
- * local CPU irq flags saved in 'flags'.
- */
-static void wait_on_tags(struct blk_mq_tags *tags, struct blk_mq_tag_map **map,
-			 unsigned long *flags)
-{
-	DEFINE_TAG_WAIT(wait);
-
-	do {
-		spin_lock_irqsave(&tags->lock, *flags);
-
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-
-		if (list_empty(&wait.list))
-			list_add_tail(&wait.list, &tags->wait);
-
-		*map = this_cpu_ptr(tags->free_maps);
-		if ((*map)->nr_free || tags->nr_free) {
-			if (!(*map)->nr_free) {
-				move_tags((*map)->freelist, &(*map)->nr_free,
-						tags->freelist, &tags->nr_free,
-						tags->batch_move);
-			}
-
-			if (!list_empty(&wait.list))
-				list_del(&wait.list);
-
-			spin_unlock(&tags->lock);
-			break;
-		}
-
-		spin_unlock_irqrestore(&tags->lock, *flags);
-		ipi_local_caches(tags, raw_smp_processor_id());
-		io_schedule();
-	} while (1);
-
-	__set_current_state(TASK_RUNNING);
-}
-
 void blk_mq_wait_for_tags(struct blk_mq_tags *tags)
 {
-	struct blk_mq_tag_map *map;
-	unsigned long flags;
-
-	ipi_local_caches(tags, raw_smp_processor_id());
-	wait_on_tags(tags, &map, &flags);
-	local_irq_restore(flags);
+	int tag = blk_mq_get_tag(tags, __GFP_WAIT, false);
+	blk_mq_put_tag(tags, tag);
 }
 
 bool blk_mq_has_free_tags(struct blk_mq_tags *tags)
 {
-	return !tags || tags->nr_free != 0;
+	return !tags ||
+		percpu_ida_free_tags(&tags->free_tags, nr_cpu_ids) != 0;
 }
 
 static unsigned int __blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp)
 {
-	struct blk_mq_tag_map *map;
-	unsigned int this_cpu;
-	unsigned long flags;
-	unsigned int tag;
-
-	local_irq_save(flags);
-	this_cpu = smp_processor_id();
-	map = per_cpu_ptr(tags->free_maps, this_cpu);
-
-	/*
-	 * Grab from local per-cpu cache, if we can
-	 */
-	do {
-		if (map->nr_free) {
-			map->nr_free--;
-			tag = map->freelist[map->nr_free];
-			local_irq_restore(flags);
-			return tag;
-		}
-
-		/*
-		 * Grab from device map, if we can
-		 */
-		if (tags->nr_free) {
-			spin_lock(&tags->lock);
-			move_tags(map->freelist, &map->nr_free, tags->freelist,
-					&tags->nr_free, tags->batch_move);
-			spin_unlock(&tags->lock);
-			continue;
-		}
-
-		local_irq_restore(flags);
-
-		if (!(gfp & __GFP_WAIT))
-			break;
-
-		ipi_local_caches(tags, this_cpu);
-
-		/*
-		 * All are busy, wait. Returns with irqs disabled again
-		 * and potentially new 'map' pointer.
-		 */
-		wait_on_tags(tags, &map, &flags);
-	} while (1);
+	int tag;
 
-	return BLK_MQ_TAG_FAIL;
+	tag = percpu_ida_alloc(&tags->free_tags, gfp);
+	if (tag < 0)
+		return BLK_MQ_TAG_FAIL;
+	return tag + tags->nr_reserved_tags;
 }
 
 static unsigned int __blk_mq_get_reserved_tag(struct blk_mq_tags *tags,
 					      gfp_t gfp)
 {
-	unsigned int tag = BLK_MQ_TAG_FAIL;
-	DEFINE_TAG_WAIT(wait);
+	int tag;
 
-	if (unlikely(!tags->reserved_tags)) {
+	if (unlikely(!tags->nr_reserved_tags)) {
 		WARN_ON_ONCE(1);
 		return BLK_MQ_TAG_FAIL;
 	}
 
-	do {
-		spin_lock_irq(&tags->lock);
-		if (tags->nr_reserved) {
-			tags->nr_reserved--;
-			tag = tags->reservelist[tags->nr_reserved];
-			break;
-		}
-
-		if (!(gfp & __GFP_WAIT))
-			break;
-
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-
-		if (list_empty(&wait.list))
-			list_add_tail(&wait.list, &tags->wait);
-
-		spin_unlock_irq(&tags->lock);
-		io_schedule();
-	} while (1);
-
-	if (!list_empty(&wait.list))
-		list_del(&wait.list);
-
-	spin_unlock_irq(&tags->lock);
+	tag = percpu_ida_alloc(&tags->reserved_tags, gfp);
+	if (tag < 0)
+		return BLK_MQ_TAG_FAIL;
 	return tag;
 }
 
@@ -309,57 +68,38 @@ unsigned int blk_mq_get_tag(struct blk_m
 
 static void __blk_mq_put_tag(struct blk_mq_tags *tags, unsigned int tag)
 {
-	struct blk_mq_tag_map *map;
-	unsigned long flags;
-
 	BUG_ON(tag >= tags->nr_tags);
 
-	local_irq_save(flags);
-	map = this_cpu_ptr(tags->free_maps);
-
-	map->freelist[map->nr_free] = tag;
-	map->nr_free++;
-
-	if (map->nr_free >= tags->max_cache ||
-	    !list_empty_careful(&tags->wait)) {
-		spin_lock(&tags->lock);
-		__blk_mq_tag_return(tags, map, tags->batch_move);
-		spin_unlock(&tags->lock);
-	}
-
-	local_irq_restore(flags);
+	percpu_ida_free(&tags->free_tags, tag - tags->nr_reserved_tags);
 }
 
 static void __blk_mq_put_reserved_tag(struct blk_mq_tags *tags,
 				      unsigned int tag)
 {
-	unsigned long flags;
-
-	BUG_ON(tag >= tags->reserved_tags);
-
-	spin_lock_irqsave(&tags->lock, flags);
-	tags->reservelist[tags->nr_reserved] = tag;
-	tags->nr_reserved++;
+	BUG_ON(tag >= tags->nr_reserved_tags);
 
-	if (!list_empty(&tags->wait))
-		__wake_waiters(tags, 1);
-
-	spin_unlock_irqrestore(&tags->lock, flags);
+	percpu_ida_free(&tags->reserved_tags, tag);
 }
 
 void blk_mq_put_tag(struct blk_mq_tags *tags, unsigned int tag)
 {
-	if (tag >= tags->reserved_tags)
+	if (tag >= tags->nr_reserved_tags)
 		__blk_mq_put_tag(tags, tag);
 	else
 		__blk_mq_put_reserved_tag(tags, tag);
 }
 
+static int __blk_mq_tag_iter(int id, void *data)
+{
+	unsigned long *tag_map = data;
+	__set_bit(id, tag_map);
+	return 0;
+}
+
 void blk_mq_tag_busy_iter(struct blk_mq_tags *tags,
 			  void (*fn)(void *, unsigned long *), void *data)
 {
-	unsigned long flags, *tag_map;
-	unsigned int i, j;
+	unsigned long *tag_map;
 	size_t map_size;
 
 	map_size = ALIGN(tags->nr_tags, BITS_PER_LONG) / BITS_PER_LONG;
@@ -367,56 +107,21 @@ void blk_mq_tag_busy_iter(struct blk_mq_
 	if (!tag_map)
 		return;
 
-	local_irq_save(flags);
-
-	for_each_online_cpu(i) {
-		struct blk_mq_tag_map *map = per_cpu_ptr(tags->free_maps, i);
-
-		for (j = 0; j < map->nr_free; j++)
-			__set_bit(map->freelist[j], tag_map);
-	}
-
-	if (tags->nr_free || tags->nr_reserved) {
-		spin_lock(&tags->lock);
-
-		if (tags->nr_reserved)
-			for (j = 0; j < tags->nr_reserved; j++)
-				__set_bit(tags->reservelist[j], tag_map);
-
-		if (tags->nr_free)
-			for (j = 0; j < tags->nr_free; j++)
-				__set_bit(tags->freelist[j], tag_map);
-
-		spin_unlock(&tags->lock);
-	}
-
-	local_irq_restore(flags);
+	percpu_ida_for_each_free(&tags->free_tags, __blk_mq_tag_iter, tag_map);
+	if (tags->nr_reserved_tags)
+		percpu_ida_for_each_free(&tags->reserved_tags, __blk_mq_tag_iter,
+			tag_map);
 
 	fn(data, tag_map);
 	kfree(tag_map);
 }
 
-static void blk_mq_tag_notify(void *data, unsigned long action,
-			      unsigned int cpu)
-{
-	/*
-	 * Move entries from this CPU to global pool
-	 */
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		struct blk_mq_tags *tags = data;
-		struct blk_mq_tag_map *map = per_cpu_ptr(tags->free_maps, cpu);
-
-		if (map->nr_free)
-			blk_mq_tag_return(tags, map, map->nr_free);
-	}
-}
-
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 				     unsigned int reserved_tags, int node)
 {
 	unsigned int nr_tags, nr_cache;
 	struct blk_mq_tags *tags;
-	size_t map_size;
+	int ret;
 
 	if (total_tags > BLK_MQ_TAG_MAX) {
 		pr_err("blk-mq: tag depth too large\n");
@@ -435,104 +140,65 @@ struct blk_mq_tags *blk_mq_init_tags(uns
 	else if (nr_cache > BLK_MQ_TAG_CACHE_MAX)
 		nr_cache = BLK_MQ_TAG_CACHE_MAX;
 
-	map_size = sizeof(struct blk_mq_tag_map) + nr_cache * sizeof(int);
-	tags->free_maps = __alloc_percpu(map_size, sizeof(void *));
-	if (!tags->free_maps)
-		goto err_free_maps;
-
-	tags->freelist = kmalloc_node(sizeof(int) * nr_tags, GFP_KERNEL, node);
-	if (!tags->freelist)
-		goto err_freelist;
-
-	if (reserved_tags) {
-		tags->reservelist = kmalloc_node(sizeof(int) * reserved_tags,
-							GFP_KERNEL, node);
-		if (!tags->reservelist)
-			goto err_reservelist;
-	}
-
-	spin_lock_init(&tags->lock);
-	INIT_LIST_HEAD(&tags->wait);
 	tags->nr_tags = total_tags;
-	tags->reserved_tags = reserved_tags;
-	tags->max_cache = nr_cache;
-	tags->batch_move = max(1u, nr_cache / 2);
-
-	/*
-	 * Reserved tags are first
-	 */
-	if (reserved_tags) {
-		tags->nr_reserved = 0;
-		while (reserved_tags--) {
-			tags->reservelist[tags->nr_reserved] =
-							tags->nr_reserved;
-			tags->nr_reserved++;
-		}
-	}
+	tags->nr_reserved_tags = reserved_tags;
+	tags->nr_max_cache = nr_cache;
+	tags->nr_batch_move = max(1u, nr_cache / 2);
+
+	ret = __percpu_ida_init(&tags->free_tags, tags->nr_tags -
+				tags->nr_reserved_tags,
+				tags->nr_max_cache,
+				tags->nr_batch_move);
+	if (ret)
+		goto err_free_tags;
 
-	/*
-	 * Rest of the tags start at the queue list
-	 */
-	tags->nr_free = 0;
-	while (nr_tags--) {
-		tags->freelist[tags->nr_free] = tags->nr_free +
-							tags->nr_reserved;
-		tags->nr_free++;
+	if (reserved_tags) {
+		/*
+		 * With max_cahe and batch set to 1, the allocator fallbacks to
+		 * no cached. It's fine reserved tags allocation is slow.
+		 */
+		ret = __percpu_ida_init(&tags->reserved_tags, reserved_tags,
+				1, 1);
+		if (ret)
+			goto err_reserved_tags;
 	}
 
-	blk_mq_init_cpu_notifier(&tags->cpu_notifier, blk_mq_tag_notify, tags);
-	blk_mq_register_cpu_notifier(&tags->cpu_notifier);
 	return tags;
 
-err_reservelist:
-	kfree(tags->freelist);
-err_freelist:
-	free_percpu(tags->free_maps);
-err_free_maps:
+err_reserved_tags:
+	percpu_ida_destroy(&tags->free_tags);
+err_free_tags:
 	kfree(tags);
 	return NULL;
 }
 
 void blk_mq_free_tags(struct blk_mq_tags *tags)
 {
-	blk_mq_unregister_cpu_notifier(&tags->cpu_notifier);
-	free_percpu(tags->free_maps);
-	kfree(tags->freelist);
-	kfree(tags->reservelist);
+	percpu_ida_destroy(&tags->free_tags);
+	percpu_ida_destroy(&tags->reserved_tags);
 	kfree(tags);
 }
 
 ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page)
 {
 	char *orig_page = page;
-	unsigned long flags;
-	struct list_head *tmp;
-	int waiters;
 	int cpu;
 
 	if (!tags)
 		return 0;
 
-	spin_lock_irqsave(&tags->lock, flags);
-
 	page += sprintf(page, "nr_tags=%u, reserved_tags=%u, batch_move=%u,"
-			" max_cache=%u\n", tags->nr_tags, tags->reserved_tags,
-			tags->batch_move, tags->max_cache);
-
-	waiters = 0;
-	list_for_each(tmp, &tags->wait)
-		waiters++;
-
-	page += sprintf(page, "nr_free=%u, nr_reserved=%u, waiters=%u\n",
-			tags->nr_free, tags->nr_reserved, waiters);
+			" max_cache=%u\n", tags->nr_tags, tags->nr_reserved_tags,
+			tags->nr_batch_move, tags->nr_max_cache);
 
-	for_each_online_cpu(cpu) {
-		struct blk_mq_tag_map *map = per_cpu_ptr(tags->free_maps, cpu);
+	page += sprintf(page, "nr_free=%u, nr_reserved=%u\n",
+			percpu_ida_free_tags(&tags->free_tags, nr_cpu_ids),
+			percpu_ida_free_tags(&tags->reserved_tags, nr_cpu_ids));
 
+	for_each_possible_cpu(cpu) {
 		page += sprintf(page, "  cpu%02u: nr_free=%u\n", cpu,
-					map->nr_free);
+				percpu_ida_free_tags(&tags->free_tags, cpu));
 	}
 
-	spin_unlock_irqrestore(&tags->lock, flags);
 	return page - orig_page;
 }

