Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3JEHN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 03:13:56 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57288 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3JEHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 03:13:54 -0400
Message-ID: <524FBA3F.3050409@gmail.com>
Date: Sat, 05 Oct 2013 16:05:35 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: mpatocka@redhat.com
CC: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org, tj@kernel.org,
        agk@redhat.com, joe@perches.com, akpm@linux-foundation.org,
        ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com,
        ruby.wktk@gmail.com
Subject: Re: [dm-devel] dm-writeboost testing
References: <alpine.LRH.2.02.1310021125150.19199@file01.intranet.prod.int.rdu2.redhat.com> <524E27DD.2050809@gmail.com> <alpine.LRH.2.02.1310040923320.8473@file01.intranet.prod.int.rdu2.redhat.com> <524ECFC9.3000603@gmail.com> <alpine.LRH.2.02.1310041113230.22029@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1310041113230.22029@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas,

> nvidia binary driver, but it may happen in other parts of the kernel too. 
> The fact that it works in your setup doesn't mean that it is correct.
You are right. I am convinced.

As far as I looked around the kernel code,
it seems to be choosing kthread when one needs looping in background.
There are other examples such as loop_thread in drivers/block/loop.c .

And done. Please git pull.
commit b6d2d3892e09145cd0b9c5ad69ea2d8c410fdeab is tested in my environment.
All the looping daemons are running on kthread now.

The diff between the older version (with wq) and the new version (with kthread)
is shown below. I defined fancy CREATE_DAEMON macro.

Another by-product is that
you are no longer in need to wait for long time in dmsetup remove
since kthread_stop() forcefully wakes the thread up.

diff --git a/Driver/dm-writeboost-daemon.c b/Driver/dm-writeboost-daemon.c
index 6090661..65974e2 100644
--- a/Driver/dm-writeboost-daemon.c
+++ b/Driver/dm-writeboost-daemon.c
@@ -10,12 +10,11 @@
 
 /*----------------------------------------------------------------*/
 
-void flush_proc(struct work_struct *work)
+int flush_proc(void *data)
 {
 	unsigned long flags;
 
-	struct wb_cache *cache =
-		container_of(work, struct wb_cache, flush_work);
+	struct wb_cache *cache = data;
 
 	while (true) {
 		struct flush_job *job;
@@ -32,8 +31,12 @@ void flush_proc(struct work_struct *work)
 				msecs_to_jiffies(100));
 			spin_lock_irqsave(&cache->flush_queue_lock, flags);
 
-			if (cache->on_terminate)
-				return;
+			/*
+			 * flush daemon can exit
+			 * only if no flush job is queued.
+			 */
+			if (kthread_should_stop())
+				return 0;
 		}
 
 		/*
@@ -84,6 +87,7 @@ void flush_proc(struct work_struct *work)
 
 		kfree(job);
 	}
+	return 0;
 }
 
 /*----------------------------------------------------------------*/
@@ -353,19 +357,15 @@ migrate_write:
 	}
 }
 
-void migrate_proc(struct work_struct *work)
+int migrate_proc(void *data)
 {
-	struct wb_cache *cache =
-		container_of(work, struct wb_cache, migrate_work);
+	struct wb_cache *cache = data;
 
-	while (true) {
+	while (!kthread_should_stop()) {
 		bool allow_migrate;
 		size_t i, nr_mig_candidates, nr_mig, nr_max_batch;
 		struct segment_header *seg, *tmp;
 
-		if (cache->on_terminate)
-			return;
-
 		/*
 		 * If reserving_id > 0
 		 * Migration should be immediate.
@@ -430,6 +430,7 @@ void migrate_proc(struct work_struct *work)
 			list_del(&seg->migrate_list);
 		}
 	}
+	return 0;
 }
 
 /*
@@ -453,19 +454,16 @@ void wait_for_migration(struct wb_cache *cache, u64 id)
 
 /*----------------------------------------------------------------*/
 
-void modulator_proc(struct work_struct *work)
+int modulator_proc(void *data)
 {
-	struct wb_cache *cache =
-		container_of(work, struct wb_cache, modulator_work);
+	struct wb_cache *cache = data;
 	struct wb_device *wb = cache->wb;
 
 	struct hd_struct *hd = wb->device->bdev->bd_part;
 	unsigned long old = 0, new, util;
 	unsigned long intvl = 1000;
 
-	while (true) {
-		if (cache->on_terminate)
-			return;
+	while (!kthread_should_stop()) {
 
 		new = jiffies_to_msecs(part_stat_read(hd, io_ticks));
 
@@ -484,6 +482,7 @@ modulator_update:
 
 		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
 	}
+	return 0;
 }
 
 /*----------------------------------------------------------------*/
@@ -517,16 +516,12 @@ static void update_superblock_record(struct wb_cache *cache)
 	kfree(buf);
 }
 
-void recorder_proc(struct work_struct *work)
+int recorder_proc(void *data)
 {
-	struct wb_cache *cache =
-		container_of(work, struct wb_cache, recorder_work);
+	struct wb_cache *cache = data;
 	unsigned long intvl;
 
-	while (true) {
-		if (cache->on_terminate)
-			return;
-
+	while (!kthread_should_stop()) {
 		/* sec -> ms */
 		intvl = cache->update_record_interval * 1000;
 
@@ -539,20 +534,17 @@ void recorder_proc(struct work_struct *work)
 
 		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
 	}
+	return 0;
 }
 
 /*----------------------------------------------------------------*/
 
-void sync_proc(struct work_struct *work)
+int sync_proc(void *data)
 {
-	struct wb_cache *cache =
-		container_of(work, struct wb_cache, sync_work);
+	struct wb_cache *cache = data;
 	unsigned long intvl;
 
-	while (true) {
-		if (cache->on_terminate)
-			return;
-
+	while (!kthread_should_stop()) {
 		/* sec -> ms */
 		intvl = cache->sync_interval * 1000;
 
@@ -566,4 +558,5 @@ void sync_proc(struct work_struct *work)
 
 		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
 	}
+	return 0;
 }
diff --git a/Driver/dm-writeboost-daemon.h b/Driver/dm-writeboost-daemon.h
index 3bdd862..d21d66c 100644
--- a/Driver/dm-writeboost-daemon.h
+++ b/Driver/dm-writeboost-daemon.h
@@ -9,7 +9,7 @@
 
 /*----------------------------------------------------------------*/
 
-void flush_proc(struct work_struct *);
+int flush_proc(void *);
 
 /*----------------------------------------------------------------*/
 
@@ -19,20 +19,20 @@ void flush_barrier_ios(struct work_struct *);
 
 /*----------------------------------------------------------------*/
 
-void migrate_proc(struct work_struct *);
+int migrate_proc(void *);
 void wait_for_migration(struct wb_cache *, u64 id);
 
 /*----------------------------------------------------------------*/
 
-void modulator_proc(struct work_struct *);
+int modulator_proc(void *);
 
 /*----------------------------------------------------------------*/
 
-void sync_proc(struct work_struct *);
+int sync_proc(void *);
 
 /*----------------------------------------------------------------*/
 
-void recorder_proc(struct work_struct *);
+int recorder_proc(void *);
 
 /*----------------------------------------------------------------*/
 
diff --git a/Driver/dm-writeboost-metadata.c b/Driver/dm-writeboost-metadata.c
index 1cd9e0c..4f5fa5e 100644
--- a/Driver/dm-writeboost-metadata.c
+++ b/Driver/dm-writeboost-metadata.c
@@ -994,6 +994,17 @@ void free_migration_buffer(struct wb_cache *cache)
 
 /*----------------------------------------------------------------*/
 
+#define CREATE_DAEMON(name)\
+	cache->name##_daemon = kthread_create(name##_proc, cache,\
+					      #name "_daemon");\
+	if (IS_ERR(cache->name##_daemon)) {\
+		r = PTR_ERR(cache->name##_daemon);\
+		cache->name##_daemon = NULL;\
+		WBERR("couldn't spawn" #name "daemon");\
+		goto bad_##name##_daemon;\
+	}\
+	wake_up_process(cache->name##_daemon);
+
 int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev)
 {
 	int r = 0;
@@ -1010,8 +1021,6 @@ int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev)
 
 	mutex_init(&cache->io_lock);
 
-	cache->on_terminate = false;
-
 	/*
 	 * (i) Harmless Initializations
 	 */
@@ -1042,12 +1051,6 @@ int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev)
 	 * Recovering the cache metadata
 	 * prerequires the migration daemon working.
 	 */
-	cache->migrate_wq = create_singlethread_workqueue("migratewq");
-	if (!cache->migrate_wq) {
-		r = -ENOMEM;
-		WBERR();
-		goto bad_migratewq;
-	}
 
 	/* Migration Daemon */
 	atomic_set(&cache->migrate_fail_count, 0);
@@ -1070,9 +1073,7 @@ int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev)
 
 	cache->allow_migrate = true;
 	cache->reserving_segment_id = 0;
-	INIT_WORK(&cache->migrate_work, migrate_proc);
-	queue_work(cache->migrate_wq, &cache->migrate_work);
-
+	CREATE_DAEMON(migrate);
 
 	r = recover_cache(cache);
 	if (r) {
@@ -1086,19 +1087,12 @@ int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev)
 	 * These are only working
 	 * after the logical device created.
 	 */
-	cache->flush_wq = create_singlethread_workqueue("flushwq");
-	if (!cache->flush_wq) {
-		r = -ENOMEM;
-		WBERR();
-		goto bad_flushwq;
-	}
 
 	/* Flush Daemon */
-	INIT_WORK(&cache->flush_work, flush_proc);
 	spin_lock_init(&cache->flush_queue_lock);
 	INIT_LIST_HEAD(&cache->flush_queue);
 	init_waitqueue_head(&cache->flush_wait_queue);
-	queue_work(cache->flush_wq, &cache->flush_work);
+	CREATE_DAEMON(flush);
 
 	/* Deferred ACK for barrier writes */
 
@@ -1118,29 +1112,30 @@ int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev)
 
 	/* Migartion Modulator */
 	cache->enable_migration_modulator = true;
-	INIT_WORK(&cache->modulator_work, modulator_proc);
-	schedule_work(&cache->modulator_work);
+	CREATE_DAEMON(modulator);
 
 	/* Superblock Recorder */
 	cache->update_record_interval = 60;
-	INIT_WORK(&cache->recorder_work, recorder_proc);
-	schedule_work(&cache->recorder_work);
+	CREATE_DAEMON(recorder);
 
 	/* Dirty Synchronizer */
 	cache->sync_interval = 60;
-	INIT_WORK(&cache->sync_work, sync_proc);
-	schedule_work(&cache->sync_work);
+	CREATE_DAEMON(sync);
 
 	return 0;
 
-bad_flushwq:
+bad_sync_daemon:
+	kthread_stop(cache->recorder_daemon);
+bad_recorder_daemon:
+	kthread_stop(cache->modulator_daemon);
+bad_modulator_daemon:
+	kthread_stop(cache->flush_daemon);
+bad_flush_daemon:
 bad_recover:
-	cache->on_terminate = true;
-	cancel_work_sync(&cache->migrate_work);
+	kthread_stop(cache->migrate_daemon);
+bad_migrate_daemon:
 	free_migration_buffer(cache);
 bad_alloc_migrate_buffer:
-	destroy_workqueue(cache->migrate_wq);
-bad_migratewq:
 	free_ht(cache);
 bad_alloc_ht:
 	free_segment_header_array(cache);
@@ -1153,20 +1148,21 @@ bad_init_rambuf_pool:
 
 void free_cache(struct wb_cache *cache)
 {
-	cache->on_terminate = true;
+	/*
+	 * Must clean up all the volatile data
+	 * before termination.
+	 */
+	flush_current_buffer(cache);
 
-	/* Kill in-kernel daemons */
-	cancel_work_sync(&cache->sync_work);
-	cancel_work_sync(&cache->recorder_work);
-	cancel_work_sync(&cache->modulator_work);
+	kthread_stop(cache->sync_daemon);
+	kthread_stop(cache->recorder_daemon);
+	kthread_stop(cache->modulator_daemon);
 
-	cancel_work_sync(&cache->flush_work);
-	destroy_workqueue(cache->flush_wq);
+	kthread_stop(cache->flush_daemon);
 
 	cancel_work_sync(&cache->barrier_deadline_work);
 
-	cancel_work_sync(&cache->migrate_work);
-	destroy_workqueue(cache->migrate_wq);
+	kthread_stop(cache->migrate_daemon);
 	free_migration_buffer(cache);
 
 	/* Destroy in-core structures */
diff --git a/Driver/dm-writeboost-target.c b/Driver/dm-writeboost-target.c
index 6aa4c7c..4b5b7aa 100644
--- a/Driver/dm-writeboost-target.c
+++ b/Driver/dm-writeboost-target.c
@@ -973,12 +973,6 @@ static void writeboost_dtr(struct dm_target *ti)
 	struct wb_device *wb = ti->private;
 	struct wb_cache *cache = wb->cache;
 
-	/*
-	 * Synchronize all the dirty writes
-	 * before termination.
-	 */
-	cache->sync_interval = 1;
-
 	free_cache(cache);
 	kfree(cache);
 
diff --git a/Driver/dm-writeboost.h b/Driver/dm-writeboost.h
index 74ff194..092c100 100644
--- a/Driver/dm-writeboost.h
+++ b/Driver/dm-writeboost.h
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
+#include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/device-mapper.h>
@@ -265,8 +266,7 @@ struct wb_cache {
 	 * and flush daemon asynchronously
 	 * flush them to the cache device.
 	 */
-	struct work_struct flush_work;
-	struct workqueue_struct *flush_wq;
+	struct task_struct *flush_daemon;
 	spinlock_t flush_queue_lock;
 	struct list_head flush_queue;
 	wait_queue_head_t flush_wait_queue;
@@ -288,8 +288,7 @@ struct wb_cache {
 	 * migrate daemon goes into migration
 	 * if they are segments to migrate.
 	 */
-	struct work_struct migrate_work;
-	struct workqueue_struct *migrate_wq;
+	struct task_struct *migrate_daemon;
 	bool allow_migrate; /* param */
 
 	/*
@@ -314,7 +313,7 @@ struct wb_cache {
 	 * the migration
 	 * according to the load of backing store.
 	 */
-	struct work_struct modulator_work;
+	struct task_struct *modulator_daemon;
 	bool enable_migration_modulator; /* param */
 
 	/*
@@ -323,7 +322,7 @@ struct wb_cache {
 	 * Update the superblock record
 	 * periodically.
 	 */
-	struct work_struct recorder_work;
+	struct task_struct *recorder_daemon;
 	unsigned long update_record_interval; /* param */
 
 	/*
@@ -332,16 +331,9 @@ struct wb_cache {
 	 * Sync the dirty writes
 	 * periodically.
 	 */
-	struct work_struct sync_work;
+	struct task_struct *sync_daemon;
 	unsigned long sync_interval; /* param */
 
-	/*
-	 * on_terminate is true
-	 * to notify all the background daemons to
-	 * stop their operations.
-	 */
-	bool on_terminate;
-
 	atomic64_t stat[STATLEN];
 };

Akira
