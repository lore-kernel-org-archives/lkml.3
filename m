Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3HLCUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:20:48 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35193 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab3HLCUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:20:30 -0400
Message-Id: <20130812022017.500088923@kernel.org>
User-Agent: quilt/0.50-1
Date: Mon, 12 Aug 2013 10:18:06 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, djbw@fb.com, tj@kernel.org
Subject: [patch 3/3 v2] raid5: only wakeup necessary threads
References: <20130812021803.325887805@kernel.org>
Content-Disposition: inline; filename=raid5-intelligent-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are no enough stripes to handle, we'd better not always queue all
available work_structs. If one worker can only handle small or even none
stripes, it will impact request merge and create lock contention.

With this patch, the number of work_struct running will depend on pending
stripes number. Note: some statistics info used in the patch are accessed without
locking protection. This should doesn't matter, we just try best to avoid queue
unnecessary work_struct.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid5.h |    4 ++++
 2 files changed, 48 insertions(+), 6 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-08-09 09:50:25.754255596 +0800
+++ linux/drivers/md/raid5.c	2013-08-09 10:03:45.016208049 +0800
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
+	group->workers[0].working = true;
+	/* at least one worker should run to avoid race */
+	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
+
+	thread_cnt = group->stripes_cnt / MAX_STRIPE_BATCH - 1;
+	/* wakeup more workers */
+	for (i = 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {
+		if (group->workers[i].working == false) {
+			group->workers[i].working = true;
+			queue_work_on(sh->cpu, raid5_wq,
+				      &group->workers[i].work);
+			thread_cnt--;
+		} else if (group->workers[i].working_cnt <=
+			   MAX_STRIPE_BATCH / 2)
+			/*
+			 * If a worker has no enough stripes handling, assume
+			 * it will fetch more stripes soon.
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
@@ -4150,12 +4177,14 @@ static struct stripe_head *__get_priorit
 			handle_list = NULL;
 	} else if (group != ANY_GROUP) {
 		handle_list = &conf->worker_groups[group].handle_list;
+		wg = &conf->worker_groups[group];
 		if (list_empty(handle_list))
 			handle_list = NULL;
 	} else {
 		int i;
 		for (i = 0; i < conf->group_cnt; i++) {
 			handle_list = &conf->worker_groups[i].handle_list;
+			wg = &conf->worker_groups[i];
 			if (!list_empty(handle_list))
 				break;
 		}
@@ -4204,11 +4233,16 @@ static struct stripe_head *__get_priorit
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
@@ -4906,8 +4940,8 @@ static int  retry_aligned_read(struct r5
 	return handled;
 }
 
-#define MAX_STRIPE_BATCH 8
-static int handle_active_stripes(struct r5conf *conf, int group)
+static int handle_active_stripes(struct r5conf *conf, int group,
+		struct r5worker *worker)
 {
 	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
 	int i, batch_size = 0;
@@ -4916,6 +4950,9 @@ static int handle_active_stripes(struct
 			(sh = __get_priority_stripe(conf, group)) != NULL)
 		batch[batch_size++] = sh;
 
+	if (worker)
+		worker->working_cnt = batch_size;
+
 	if (batch_size == 0)
 		return batch_size;
 	spin_unlock_irq(&conf->device_lock);
@@ -4950,11 +4987,12 @@ static void raid5_do_work(struct work_st
 
 		released = release_stripe_list(conf);
 
-		batch_size = handle_active_stripes(conf, group_id);
+		batch_size = handle_active_stripes(conf, group_id, worker);
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
 	}
+	worker->working = false;
 	pr_debug("%d stripes handled\n", handled);
 
 	spin_unlock_irq(&conf->device_lock);
@@ -5012,7 +5050,7 @@ static void raid5d(struct md_thread *thr
 			handled++;
 		}
 
-		batch_size = handle_active_stripes(conf, ANY_GROUP);
+		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL);
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2013-08-09 09:42:47.076021908 +0800
+++ linux/drivers/md/raid5.h	2013-08-09 09:54:27.927211264 +0800
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
+	int working_cnt:8;
+	bool working;
 };
 
 struct r5worker_group {
 	struct list_head handle_list;
 	struct r5conf *conf;
 	struct r5worker *workers;
+	int stripes_cnt;
 };
 
 struct r5conf {

