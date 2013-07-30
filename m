Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3G3F6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:58:39 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:38770 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3G3F6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:58:37 -0400
Message-Id: <20130730055425.056034691@kernel.org>
User-Agent: quilt/0.50-1
Date: Tue, 30 Jul 2013 13:52:10 +0800
From: shli@kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, tj@kernel.org, djbw@fb.com
Subject: [patch 3/3] raid5: only wakeup necessary threads
References: <20130730055207.698660010@kernel.org>
Content-Disposition: inline; filename=raid5-intelligent-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are no enough stripes to handle, we'd better now always queue all
available work_structs. If one worker can only handle small or even none
stripes, it will impact request merge and create lock contention.

With this patch, the number of work_struct running will depend on pending
stripes number. Not some statistics info used in the patch are accessed without
locking protection. Yhis should doesn't matter, we just try best to avoid queue
unnecessary work_struct.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid5.h |    4 ++++
 2 files changed, 48 insertions(+), 6 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-07-30 09:44:18.000000000 +0800
+++ linux/drivers/md/raid5.c	2013-07-30 13:03:28.738736366 +0800
@@ -77,6 +77,7 @@ static struct workqueue_struct *raid5_wq
 #define BYPASS_THRESHOLD	1
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
+#define MAX_STRIPE_BATCH	8
 
 static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
 {
@@ -209,6 +210,7 @@ static void raid5_wakeup_stripe_thread(s
 {
 	struct r5conf *conf = sh->raid_conf;
 	struct r5worker_group *group;
+	int thread_cnt;
 	int i;
 
 	if (conf->worker_cnt_per_group == 0) {
@@ -218,8 +220,26 @@ static void raid5_wakeup_stripe_thread(s
 
 	group = conf->worker_groups + cpu_to_group(sh->cpu);
 
-	for (i = 0; i < conf->worker_cnt_per_group; i++)
-		queue_work_on(sh->cpu, raid5_wq, &group->workers[i].work);
+	group->workers[0].working = 1;
+	/* at least one worker should run to avoid race */
+	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
+
+	thread_cnt = group->stripes_cnt / MAX_STRIPE_BATCH - 1;
+	/* wakeup more worker */
+	for (i = 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {
+		if (group->workers[i].working == 0) {
+			group->workers[i].working = 1;
+			queue_work_on(sh->cpu, raid5_wq,
+				      &group->workers[i].work);
+			thread_cnt--;
+		} else if (group->workers[i].working_cnt <=
+			   MAX_STRIPE_BATCH / 2)
+			/*
+			 * If a worker has no enough stripes handling, assume
+			 * it will fetch more stripes soon
+			 */
+			thread_cnt--;
+	}
 }
 
 static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
@@ -248,6 +268,8 @@ static void do_release_stripe(struct r5c
 				struct r5worker_group *group;
 				group = conf->worker_groups + cpu_to_group(cpu);
 				list_add_tail(&sh->lru, &group->handle_list);
+				group->stripes_cnt++;
+				sh->group = group;
 			}
 			raid5_wakeup_stripe_thread(sh);
 			return;
@@ -573,6 +595,10 @@ get_active_stripe(struct r5conf *conf, s
 				    !test_bit(STRIPE_EXPANDING, &sh->state))
 					BUG();
 				list_del_init(&sh->lru);
+				if (sh->group) {
+					sh->group->stripes_cnt--;
+					sh->group = NULL;
+				}
 			}
 		}
 	} while (sh == NULL);
@@ -4143,6 +4169,7 @@ static struct stripe_head *__get_priorit
 {
 	struct stripe_head *sh = NULL, *tmp;
 	struct list_head *handle_list = NULL;
+	struct r5worker_group *wg = NULL;
 
 	if (conf->worker_cnt_per_group == 0) {
 		handle_list = &conf->handle_list;
@@ -4150,6 +4177,7 @@ static struct stripe_head *__get_priorit
 			handle_list = NULL;
 	} else if (group != ANY_GROUP) {
 		handle_list = &conf->worker_groups[group].handle_list;
+		wg = &conf->worker_groups[group];
 		if (list_empty(handle_list))
 			handle_list = NULL;
 	} else {
@@ -4157,6 +4185,7 @@ static struct stripe_head *__get_priorit
 		/* Should we take action to avoid starvation of latter groups ? */
 		for (i = 0; i < conf->group_cnt; i++) {
 			handle_list = &conf->worker_groups[i].handle_list;
+			wg = &conf->worker_groups[i];
 			if (!list_empty(handle_list))
 				break;
 		}
@@ -4205,11 +4234,16 @@ static struct stripe_head *__get_priorit
 			if (conf->bypass_count < 0)
 				conf->bypass_count = 0;
 		}
+		wg = NULL;
 	}
 
 	if (!sh)
 		return NULL;
 
+	if (wg) {
+		wg->stripes_cnt--;
+		sh->group = NULL;
+	}
 	list_del_init(&sh->lru);
 	atomic_inc(&sh->count);
 	BUG_ON(atomic_read(&sh->count) != 1);
@@ -4907,8 +4941,8 @@ static int  retry_aligned_read(struct r5
 	return handled;
 }
 
-#define MAX_STRIPE_BATCH 8
-static int handle_active_stripes(struct r5conf *conf, int group)
+static int handle_active_stripes(struct r5conf *conf, int group,
+		struct r5worker *worker)
 {
 	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
 	int i, batch_size = 0;
@@ -4917,6 +4951,9 @@ static int handle_active_stripes(struct
 			(sh = __get_priority_stripe(conf, group)) != NULL)
 		batch[batch_size++] = sh;
 
+	if (worker)
+		worker->working_cnt = batch_size;
+
 	if (batch_size == 0)
 		return batch_size;
 	spin_unlock_irq(&conf->device_lock);
@@ -4951,11 +4988,12 @@ static void raid5_do_work(struct work_st
 
 		released = release_stripe_list(conf);
 
-		batch_size = handle_active_stripes(conf, group_id);
+		batch_size = handle_active_stripes(conf, group_id, worker);
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
 	}
+	worker->working = 0;
 	pr_debug("%d stripes handled\n", handled);
 
 	spin_unlock_irq(&conf->device_lock);
@@ -5013,7 +5051,7 @@ static void raid5d(struct md_thread *thr
 			handled++;
 		}
 
-		batch_size = handle_active_stripes(conf, ANY_GROUP);
+		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL);
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2013-07-30 09:14:22.000000000 +0800
+++ linux/drivers/md/raid5.h	2013-07-30 09:46:22.777233803 +0800
@@ -213,6 +213,7 @@ struct stripe_head {
 	enum reconstruct_states reconstruct_state;
 	spinlock_t		stripe_lock;
 	int			cpu;
+	struct r5worker_group	*group;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -369,12 +370,15 @@ struct disk_info {
 struct r5worker {
 	struct work_struct work;
 	struct r5worker_group *group;
+	int working:1;
+	int working_cnt:8;
 };
 
 struct r5worker_group {
 	struct list_head handle_list;
 	struct r5conf *conf;
 	struct r5worker *workers;
+	int stripes_cnt;
 };
 
 struct r5conf {

