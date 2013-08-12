Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3HLCUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:20:41 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:42254 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab3HLCUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:20:03 -0400
Message-Id: <20130812021951.024101316@kernel.org>
User-Agent: quilt/0.50-1
Date: Mon, 12 Aug 2013 10:18:04 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, djbw@fb.com, tj@kernel.org
Subject: [patch 1/3 v2] raid5: offload stripe handle to workqueue
References: <20130812021803.325887805@kernel.org>
Content-Disposition: inline; filename=raid5-wq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another attempt to create multiple threads to handle raid5 stripes.
This time I use workqueue.

raid5 handles request (especially write) in stripe unit. A stripe is page size
aligned/long and acrosses all disks. Writing to any disk sector, raid5 runs a
state machine for the corresponding stripe, which includes reading some disks
of the stripe, calculating parity, and writing some disks of the stripe. The
state machine is running in raid5d thread currently. Since there is only one
thread, it doesn't scale well for high speed storage. An obvious solution is
multi-threading.

To get better performance, we have some requirements:
a. locality. stripe corresponding to request submitted from one cpu is better
handled in thread in local cpu or local node. local cpu is preferred but some
times could be a bottleneck, for example, parity calculation is too heavy.
local node running has wide adaptability.
b. configurablity. Different setup of raid5 array might need diffent
configuration. Especially the thread number. More threads don't always mean
better performance because of lock contentions.

My original implementation is creating some kernel threads. There are
interfaces to control which cpu's stripe each thread should handle. And
userspace can set affinity of the threads. This provides biggest flexibility
and configurability. But it's hard to use and apparently a new thread pool
implementation is disfavor.

Recent workqueue improvement is quite promising. unbound workqueue will be
bound to numa node. If WQ_SYSFS is set in workqueue, there are sysfs option to
do affinity setting. For example, we can only include one HT sibling in
affinity. Since work is non-reentrant by default, and we can control running
thread number by limiting dispatched work_struct number.

In this patch, I created several stripe worker group. A group is a numa node.
stripes from cpus of one node will be added to a group list. Workqueue thread
of one node will only handle stripes of worker group of the node. In this way,
stripe handling has numa node locality. And as I said, we can control thread
number by limiting dispatched work_struct number.

The work_struct callback function handles several stripes in one run. A typical
work queue usage is to run one unit in each work_struct. In raid5 case, the
unit is a stripe. But we can't do that:
a. Though handling a stripe doesn't need lock because of reference accounting
and stripe isn't in any list, queuing a work_struct for each stripe will make
workqueue lock contended very heavily.
b. blk_start_plug()/blk_finish_plug() should surround stripe handle, as we
might dispatch request. If each work_struct only handles one stripe, such block
plug is meaningless.

This implementation can't do very fine grained configuration. But the numa
binding is most popular usage model, should be enough for most workloads. 

Note: since we have only one stripe queue, switching to multi-thread might
decrease request size dispatching down to low level layer. The impact depends
on thread number, raid configuration and workload. So multi-thread raid5 might
not be proper for all setups.

Changes V1 -> V2:
1. remove WQ_NON_REENTRANT
2. disabling multi-threading by default
3. Add more descriptions in changelog

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |  196 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.h |   15 ++++
 2 files changed, 196 insertions(+), 15 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-08-12 09:13:46.548632681 +0800
+++ linux/drivers/md/raid5.c	2013-08-12 09:14:06.628380246 +0800
@@ -53,6 +53,7 @@
 #include <linux/cpu.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/nodemask.h>
 #include <trace/events/block.h>
 
 #include "md.h"
@@ -60,6 +61,10 @@
 #include "raid0.h"
 #include "bitmap.h"
 
+#define cpu_to_group(cpu) cpu_to_node(cpu)
+#define ANY_GROUP NUMA_NO_NODE
+
+static struct workqueue_struct *raid5_wq;
 /*
  * Stripe cache
  */
@@ -200,6 +205,23 @@ static int stripe_operations_active(stru
 	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
 }
 
+static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+	struct r5worker_group *group;
+	int i;
+
+	if (conf->worker_cnt_per_group == 0) {
+		md_wakeup_thread(conf->mddev->thread);
+		return;
+	}
+
+	group = conf->worker_groups + cpu_to_group(sh->cpu);
+
+	for (i = 0; i < conf->worker_cnt_per_group; i++)
+		queue_work_on(sh->cpu, raid5_wq, &group->workers[i].work);
+}
+
 static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
 {
 	BUG_ON(!list_empty(&sh->lru));
@@ -212,9 +234,23 @@ static void do_release_stripe(struct r5c
 			   sh->bm_seq - conf->seq_write > 0)
 			list_add_tail(&sh->lru, &conf->bitmap_list);
 		else {
+			int cpu = sh->cpu;
+			if (!cpu_online(cpu)) {
+				cpu = cpumask_any(cpu_online_mask);
+				sh->cpu = cpu;
+			}
+
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			clear_bit(STRIPE_BIT_DELAY, &sh->state);
-			list_add_tail(&sh->lru, &conf->handle_list);
+			if (conf->worker_cnt_per_group == 0) {
+				list_add_tail(&sh->lru, &conf->handle_list);
+			} else {
+				struct r5worker_group *group;
+				group = conf->worker_groups + cpu_to_group(cpu);
+				list_add_tail(&sh->lru, &group->handle_list);
+			}
+			raid5_wakeup_stripe_thread(sh);
+			return;
 		}
 		md_wakeup_thread(conf->mddev->thread);
 	} else {
@@ -395,6 +431,7 @@ static void init_stripe(struct stripe_he
 		raid5_build_block(sh, i, previous);
 	}
 	insert_hash(conf, sh);
+	sh->cpu = smp_processor_id();
 }
 
 static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
@@ -3810,12 +3847,19 @@ static void raid5_activate_delayed(struc
 		while (!list_empty(&conf->delayed_list)) {
 			struct list_head *l = conf->delayed_list.next;
 			struct stripe_head *sh;
+			int cpu;
 			sh = list_entry(l, struct stripe_head, lru);
 			list_del_init(l);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			list_add_tail(&sh->lru, &conf->hold_list);
+			cpu = sh->cpu;
+			if (!cpu_online(cpu)) {
+				cpu = cpumask_any(cpu_online_mask);
+				sh->cpu = cpu;
+			}
+			raid5_wakeup_stripe_thread(sh);
 		}
 	}
 }
@@ -4095,18 +4139,38 @@ static int chunk_aligned_read(struct mdd
  * head of the hold_list has changed, i.e. the head was promoted to the
  * handle_list.
  */
-static struct stripe_head *__get_priority_stripe(struct r5conf *conf)
+static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
 {
-	struct stripe_head *sh;
+	struct stripe_head *sh = NULL, *tmp;
+	struct list_head *handle_list = NULL;
+
+	if (conf->worker_cnt_per_group == 0) {
+		handle_list = &conf->handle_list;
+		if (list_empty(handle_list))
+			handle_list = NULL;
+	} else if (group != ANY_GROUP) {
+		handle_list = &conf->worker_groups[group].handle_list;
+		if (list_empty(handle_list))
+			handle_list = NULL;
+	} else {
+		int i;
+		for (i = 0; i < conf->group_cnt; i++) {
+			handle_list = &conf->worker_groups[i].handle_list;
+			if (!list_empty(handle_list))
+				break;
+		}
+		if (i == conf->group_cnt)
+			handle_list = NULL;
+	}
 
 	pr_debug("%s: handle: %s hold: %s full_writes: %d bypass_count: %d\n",
 		  __func__,
-		  list_empty(&conf->handle_list) ? "empty" : "busy",
+		  list_empty(handle_list) ? "empty" : "busy",
 		  list_empty(&conf->hold_list) ? "empty" : "busy",
 		  atomic_read(&conf->pending_full_writes), conf->bypass_count);
 
-	if (!list_empty(&conf->handle_list)) {
-		sh = list_entry(conf->handle_list.next, typeof(*sh), lru);
+	if (handle_list) {
+		sh = list_entry(handle_list->next, typeof(*sh), lru);
 
 		if (list_empty(&conf->hold_list))
 			conf->bypass_count = 0;
@@ -4124,12 +4188,25 @@ static struct stripe_head *__get_priorit
 		   ((conf->bypass_threshold &&
 		     conf->bypass_count > conf->bypass_threshold) ||
 		    atomic_read(&conf->pending_full_writes) == 0)) {
-		sh = list_entry(conf->hold_list.next,
-				typeof(*sh), lru);
-		conf->bypass_count -= conf->bypass_threshold;
-		if (conf->bypass_count < 0)
-			conf->bypass_count = 0;
-	} else
+
+		list_for_each_entry(tmp, &conf->hold_list,  lru) {
+			if (conf->worker_cnt_per_group == 0 ||
+			    group == ANY_GROUP ||
+			    !cpu_online(tmp->cpu) ||
+			    cpu_to_group(tmp->cpu) == group) {
+				sh = tmp;
+				break;
+			}
+		}
+
+		if (sh) {
+			conf->bypass_count -= conf->bypass_threshold;
+			if (conf->bypass_count < 0)
+				conf->bypass_count = 0;
+		}
+	}
+
+	if (!sh)
 		return NULL;
 
 	list_del_init(&sh->lru);
@@ -4830,13 +4907,13 @@ static int  retry_aligned_read(struct r5
 }
 
 #define MAX_STRIPE_BATCH 8
-static int handle_active_stripes(struct r5conf *conf)
+static int handle_active_stripes(struct r5conf *conf, int group)
 {
 	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
 	int i, batch_size = 0;
 
 	while (batch_size < MAX_STRIPE_BATCH &&
-			(sh = __get_priority_stripe(conf)) != NULL)
+			(sh = __get_priority_stripe(conf, group)) != NULL)
 		batch[batch_size++] = sh;
 
 	if (batch_size == 0)
@@ -4854,6 +4931,38 @@ static int handle_active_stripes(struct
 	return batch_size;
 }
 
+static void raid5_do_work(struct work_struct *work)
+{
+	struct r5worker *worker = container_of(work, struct r5worker, work);
+	struct r5worker_group *group = worker->group;
+	struct r5conf *conf = group->conf;
+	int group_id = group - conf->worker_groups;
+	int handled;
+	struct blk_plug plug;
+
+	pr_debug("+++ raid5worker active\n");
+
+	blk_start_plug(&plug);
+	handled = 0;
+	spin_lock_irq(&conf->device_lock);
+	while (1) {
+		int batch_size, released;
+
+		released = release_stripe_list(conf);
+
+		batch_size = handle_active_stripes(conf, group_id);
+		if (!batch_size && !released)
+			break;
+		handled += batch_size;
+	}
+	pr_debug("%d stripes handled\n", handled);
+
+	spin_unlock_irq(&conf->device_lock);
+	blk_finish_plug(&plug);
+
+	pr_debug("--- raid5worker inactive\n");
+}
+
 /*
  * This is our raid5 kernel thread.
  *
@@ -4903,7 +5012,7 @@ static void raid5d(struct md_thread *thr
 			handled++;
 		}
 
-		batch_size = handle_active_stripes(conf);
+		batch_size = handle_active_stripes(conf, ANY_GROUP);
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
@@ -5043,6 +5152,54 @@ static struct attribute_group raid5_attr
 	.attrs = raid5_attrs,
 };
 
+static int alloc_thread_groups(struct r5conf *conf, int cnt)
+{
+	int i, j;
+	ssize_t size;
+	struct r5worker *workers;
+
+	conf->worker_cnt_per_group = cnt;
+	if (cnt == 0) {
+		conf->worker_groups = NULL;
+		return 0;
+	}
+	conf->group_cnt = num_possible_nodes();
+	size = sizeof(struct r5worker) * cnt;
+	workers = kzalloc(size * conf->group_cnt, GFP_KERNEL);
+	conf->worker_groups = kzalloc(sizeof(struct r5worker_group) *
+				conf->group_cnt, GFP_KERNEL);
+	if (!conf->worker_groups || !workers) {
+		kfree(workers);
+		kfree(conf->worker_groups);
+		conf->worker_groups = NULL;
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < conf->group_cnt; i++) {
+		struct r5worker_group *group;
+
+		group = &conf->worker_groups[i];
+		INIT_LIST_HEAD(&group->handle_list);
+		group->conf = conf;
+		group->workers = workers + i * cnt;
+
+		for (j = 0; j < cnt; j++) {
+			group->workers[j].group = group;
+			INIT_WORK(&group->workers[j].work, raid5_do_work);
+		}
+	}
+
+	return 0;
+}
+
+static void free_thread_groups(struct r5conf *conf)
+{
+	if (conf->worker_groups)
+		kfree(conf->worker_groups[0].workers);
+	kfree(conf->worker_groups);
+	conf->worker_groups = NULL;
+}
+
 static sector_t
 raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 {
@@ -5083,6 +5240,7 @@ static void raid5_free_percpu(struct r5c
 
 static void free_conf(struct r5conf *conf)
 {
+	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
 	kfree(conf->disks);
@@ -5211,6 +5369,9 @@ static struct r5conf *setup_conf(struct
 	conf = kzalloc(sizeof(struct r5conf), GFP_KERNEL);
 	if (conf == NULL)
 		goto abort;
+	/* Don't enable multi-threading by default*/
+	if (alloc_thread_groups(conf, 0))
+		goto abort;
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
@@ -6516,6 +6677,10 @@ static struct md_personality raid4_perso
 
 static int __init raid5_init(void)
 {
+	raid5_wq = alloc_workqueue("raid5wq",
+		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE|WQ_SYSFS, 0);
+	if (!raid5_wq)
+		return -ENOMEM;
 	register_md_personality(&raid6_personality);
 	register_md_personality(&raid5_personality);
 	register_md_personality(&raid4_personality);
@@ -6527,6 +6692,7 @@ static void raid5_exit(void)
 	unregister_md_personality(&raid6_personality);
 	unregister_md_personality(&raid5_personality);
 	unregister_md_personality(&raid4_personality);
+	destroy_workqueue(raid5_wq);
 }
 
 module_init(raid5_init);
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2013-08-12 09:13:45.292648512 +0800
+++ linux/drivers/md/raid5.h	2013-08-12 09:14:06.628380246 +0800
@@ -212,6 +212,7 @@ struct stripe_head {
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
 	spinlock_t		stripe_lock;
+	int			cpu;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -365,6 +366,17 @@ struct disk_info {
 	struct md_rdev	*rdev, *replacement;
 };
 
+struct r5worker {
+	struct work_struct work;
+	struct r5worker_group *group;
+};
+
+struct r5worker_group {
+	struct list_head handle_list;
+	struct r5conf *conf;
+	struct r5worker *workers;
+};
+
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
 	struct mddev		*mddev;
@@ -461,6 +473,9 @@ struct r5conf {
 	 * the new thread here until we fully activate the array.
 	 */
 	struct md_thread	*thread;
+	struct r5worker_group	*worker_groups;
+	int			group_cnt;
+	int			worker_cnt_per_group;
 };
 
 /*

