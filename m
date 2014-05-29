Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaE2XwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaE2XwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:52:07 -0400
Date: Thu, 29 May 2014 19:52:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
In-Reply-To: <5384CE82.90601@kernel.dk>
Message-ID: <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com> <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com> <5384CE82.90601@kernel.dk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2014, Jens Axboe wrote:

> On 2014-05-27 10:26, Mikulas Patocka wrote:
> > On Tue, 27 May 2014, Jens Axboe wrote:
> > 
> > > On 2014-05-27 09:23, Mikulas Patocka wrote:
> > > 
> > > > The patch adds bio list flushing to the scheduler just besides plug
> > > > flushsing.
> > > 
> > > ... which is exactly why I'm commenting. It'd be great to avoid yet one
> > > more
> > > scheduler hook for this sort of thing.
> > > 
> > > --
> > > Jens Axboe
> > 
> > One could create something like schedule notifier chain, but I'm not sure
> > if it is worth the complexity because of just two users. If more users
> > come in the future, it could be generalized.
> 
> Except such a thing already exists, there are unplug callback chains. All I'm
> asking is that you look into how feasible it would be to use something like
> that, instead of reinventing the wheel.
> 
> -- 
> Jens Axboe


You can use this patch as an example that moves current->bio_list to 
struct plug, but I don't recommend to put it in the kernel - this patch 
still has some issues (some lvm raid tests fail) - and at -rc7 stage we 
should really be fixing bugs and not rearchitecting the code.


You should commit my original patch because it is small and it generated 
no regressions for me. Think about stable kernels and enterprise 
distributions - the smaller the patch is, the easier it is to backport.


Mikulas


---
 block/blk-core.c       |   19 ++++++++++++-------
 drivers/md/dm-bufio.c  |    2 +-
 drivers/md/raid1.c     |    6 +++---
 drivers/md/raid10.c    |    6 +++---
 fs/bio.c               |   21 +++++++++------------
 include/linux/blkdev.h |    7 +++++--
 include/linux/sched.h  |    4 ----
 kernel/sched/core.c    |    7 -------
 8 files changed, 33 insertions(+), 39 deletions(-)

Index: linux-3.15-rc5/block/blk-core.c
===================================================================
--- linux-3.15-rc5.orig/block/blk-core.c	2014-05-29 23:06:29.000000000 +0200
+++ linux-3.15-rc5/block/blk-core.c	2014-05-30 00:30:41.000000000 +0200
@@ -1828,7 +1828,7 @@ end_io:
  */
 void generic_make_request(struct bio *bio)
 {
-	struct bio_list bio_list_on_stack;
+	struct blk_plug plug;
 
 	if (!generic_make_request_checks(bio))
 		return;
@@ -1858,8 +1858,8 @@ void generic_make_request(struct bio *bi
 	 * it is non-NULL, then a make_request is active, and new requests
 	 * should be added at the tail
 	 */
-	if (current->bio_list) {
-		bio_list_add(current->bio_list, bio);
+	if (current->plug) {
+		bio_list_add(&current->plug->bio_list, bio);
 		return;
 	}
 
@@ -1877,17 +1877,18 @@ void generic_make_request(struct bio *bi
 	 * of the top of the list (no pretending) and so remove it from
 	 * bio_list, and call into ->make_request() again.
 	 */
+	blk_start_plug(&plug);
+	current->plug->in_generic_make_request = 1;
 	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_list_on_stack);
-	current->bio_list = &bio_list_on_stack;
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
 		q->make_request_fn(q, bio);
 
-		bio = bio_list_pop(current->bio_list);
+		bio = bio_list_pop(&current->plug->bio_list);
 	} while (bio);
-	current->bio_list = NULL; /* deactivate */
+	current->plug->in_generic_make_request = 0;
+	blk_finish_plug(&plug);
 }
 EXPORT_SYMBOL(generic_make_request);
 
@@ -2965,6 +2966,8 @@ void blk_start_plug(struct blk_plug *plu
 	INIT_LIST_HEAD(&plug->list);
 	INIT_LIST_HEAD(&plug->mq_list);
 	INIT_LIST_HEAD(&plug->cb_list);
+	bio_list_init(&plug->bio_list);
+	plug->in_generic_make_request = 0;
 
 	/*
 	 * If this is a nested plug, don't actually assign it. It will be
@@ -3060,6 +3063,8 @@ void blk_flush_plug_list(struct blk_plug
 
 	BUG_ON(plug->magic != PLUG_MAGIC);
 
+	blk_flush_bio_list(plug);
+
 	flush_plug_callbacks(plug, from_schedule);
 
 	if (!list_empty(&plug->mq_list))
Index: linux-3.15-rc5/include/linux/blkdev.h
===================================================================
--- linux-3.15-rc5.orig/include/linux/blkdev.h	2014-05-29 23:05:46.000000000 +0200
+++ linux-3.15-rc5/include/linux/blkdev.h	2014-05-30 00:30:54.000000000 +0200
@@ -1061,6 +1061,8 @@ struct blk_plug {
 	struct list_head list; /* requests */
 	struct list_head mq_list; /* blk-mq requests */
 	struct list_head cb_list; /* md requires an unplug callback */
+	struct bio_list bio_list; /* list of queued bios */
+	int in_generic_make_request;
 };
 #define BLK_MAX_REQUEST_COUNT 16
 
@@ -1100,10 +1102,11 @@ static inline bool blk_needs_flush_plug(
 	return plug &&
 		(!list_empty(&plug->list) ||
 		 !list_empty(&plug->mq_list) ||
-		 !list_empty(&plug->cb_list));
+		 !list_empty(&plug->cb_list) ||
+		 !bio_list_empty(&plug->bio_list));
 }
 
-extern void blk_flush_bio_list(void);
+extern void blk_flush_bio_list(struct blk_plug *plug);
 
 /*
  * tag stuff
Index: linux-3.15-rc5/include/linux/sched.h
===================================================================
--- linux-3.15-rc5.orig/include/linux/sched.h	2014-05-29 23:07:01.000000000 +0200
+++ linux-3.15-rc5/include/linux/sched.h	2014-05-29 23:07:08.000000000 +0200
@@ -126,7 +126,6 @@ struct sched_attr {
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
-struct bio_list;
 struct fs_struct;
 struct perf_event_context;
 struct blk_plug;
@@ -1427,9 +1426,6 @@ struct task_struct {
 /* journalling filesystem info */
 	void *journal_info;
 
-/* stacked block device info */
-	struct bio_list *bio_list;
-
 #ifdef CONFIG_BLOCK
 /* stack plugging */
 	struct blk_plug *plug;
Index: linux-3.15-rc5/fs/bio.c
===================================================================
--- linux-3.15-rc5.orig/fs/bio.c	2014-05-29 23:19:04.000000000 +0200
+++ linux-3.15-rc5/fs/bio.c	2014-05-29 23:36:40.000000000 +0200
@@ -352,23 +352,20 @@ static void bio_alloc_rescue(struct work
  * However, stacking drivers should use bio_set, so this shouldn't be
  * an issue.
  */
-void blk_flush_bio_list(void)
+void blk_flush_bio_list(struct blk_plug *plug)
 {
 	struct bio *bio;
-	struct bio_list list = *current->bio_list;
-	bio_list_init(current->bio_list);
 
-	while ((bio = bio_list_pop(&list))) {
+	while ((bio = bio_list_pop(&plug->bio_list))) {
 		struct bio_set *bs = bio->bi_pool;
-		if (unlikely(!bs)) {
-			bio_list_add(current->bio_list, bio);
-		} else {
-			spin_lock(&bs->rescue_lock);
-			bio_list_add(&bs->rescue_list, bio);
-			spin_unlock(&bs->rescue_lock);
+		if (!bs)
+			bs = fs_bio_set;
 
-			queue_work(bs->rescue_workqueue, &bs->rescue_work);
-		}
+		spin_lock(&bs->rescue_lock);
+		bio_list_add(&bs->rescue_list, bio);
+		spin_unlock(&bs->rescue_lock);
+
+		queue_work(bs->rescue_workqueue, &bs->rescue_work);
 	}
 }
 
Index: linux-3.15-rc5/kernel/sched/core.c
===================================================================
--- linux-3.15-rc5.orig/kernel/sched/core.c	2014-05-29 23:17:04.000000000 +0200
+++ linux-3.15-rc5/kernel/sched/core.c	2014-05-29 23:18:28.000000000 +0200
@@ -2734,13 +2734,6 @@ static inline void sched_submit_work(str
 	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
 	/*
-	 * If there are bios on the bio list, flush them to the appropriate
-	 * rescue threads.
-	 */
-	if (unlikely(current->bio_list != NULL) &&
-	    !bio_list_empty(current->bio_list))
-		blk_flush_bio_list();
-	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
 	 */
Index: linux-3.15-rc5/drivers/md/dm-bufio.c
===================================================================
--- linux-3.15-rc5.orig/drivers/md/dm-bufio.c	2014-05-30 00:25:55.000000000 +0200
+++ linux-3.15-rc5/drivers/md/dm-bufio.c	2014-05-30 00:31:28.000000000 +0200
@@ -169,7 +169,7 @@ static inline int dm_bufio_cache_index(s
 #define DM_BUFIO_CACHE(c)	(dm_bufio_caches[dm_bufio_cache_index(c)])
 #define DM_BUFIO_CACHE_NAME(c)	(dm_bufio_cache_names[dm_bufio_cache_index(c)])
 
-#define dm_bufio_in_request()	(!!current->bio_list)
+#define dm_bufio_in_request()	(current->plug && current->plug->in_generic_make_request)
 
 static void dm_bufio_lock(struct dm_bufio_client *c)
 {
Index: linux-3.15-rc5/drivers/md/raid1.c
===================================================================
--- linux-3.15-rc5.orig/drivers/md/raid1.c	2014-05-30 00:19:28.000000000 +0200
+++ linux-3.15-rc5/drivers/md/raid1.c	2014-05-30 00:33:11.000000000 +0200
@@ -912,8 +912,8 @@ static sector_t wait_barrier(struct r1co
 				    (!conf->barrier ||
 				    ((conf->start_next_window <
 				      conf->next_resync + RESYNC_SECTORS) &&
-				     current->bio_list &&
-				     !bio_list_empty(current->bio_list))),
+				     current->plug &&
+				     !bio_list_empty(&current->plug->bio_list))),
 				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
@@ -1052,7 +1052,7 @@ static void raid1_unplug(struct blk_plug
 	struct r1conf *conf = mddev->private;
 	struct bio *bio;
 
-	if (from_schedule || current->bio_list) {
+	if (from_schedule || (current->plug && current->plug->in_generic_make_request)) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count += plug->pending_cnt;
Index: linux-3.15-rc5/drivers/md/raid10.c
===================================================================
--- linux-3.15-rc5.orig/drivers/md/raid10.c	2014-05-30 00:23:51.000000000 +0200
+++ linux-3.15-rc5/drivers/md/raid10.c	2014-05-30 00:32:50.000000000 +0200
@@ -1045,8 +1045,8 @@ static void wait_barrier(struct r10conf 
 		wait_event_lock_irq(conf->wait_barrier,
 				    !conf->barrier ||
 				    (conf->nr_pending &&
-				     current->bio_list &&
-				     !bio_list_empty(current->bio_list)),
+				     current->plug &&
+				     !bio_list_empty(&current->plug->bio_list)),
 				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
@@ -1122,7 +1122,7 @@ static void raid10_unplug(struct blk_plu
 	struct r10conf *conf = mddev->private;
 	struct bio *bio;
 
-	if (from_schedule || current->bio_list) {
+	if (from_schedule || (current->plug && current->plug->in_generic_make_request)) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count += plug->pending_cnt;
