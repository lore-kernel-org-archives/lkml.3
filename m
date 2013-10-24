Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3JXJ0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:26:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36747 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JXJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:23 -0400
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/11] blk-mq: new multi-queue block IO queueing mechanism
Date: Thu, 24 Oct 2013 10:26:03 +0100
Message-Id: <1382606764-8309-11-git-send-email-axboe@kernel.dk>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux currently has two models for block devices:

- The classic request_fn based approach, where drivers use struct
  request units for IO. The block layer provides various helper
  functionalities to let drivers share code, things like tag
  management, timeout handling, queueing, etc.

- The "stacked" approach, where a driver squeezes in between the
  block layer and IO submitter. Since this bypasses the IO stack,
  driver generally have to manage everything themselves.

With drivers being written for new high IOPS devices, the classic
request_fn based driver doesn't work well enough. The design dates
back to when both SMP and high IOPS was rare. It has problems with
scaling to bigger machines, and runs into scaling issues even on
smaller machines when you have IOPS in the hundreds of thousands
per device.

The stacked approach is then most often selected as the model
for the driver. But this means that everybody has to re-invent
everything, and along with that we get all the problems again
that the shared approach solved.

This commit introduces blk-mq, block multi queue support. The
design is centered around per-cpu queues for queueing IO, which
then funnel down into x number of hardware submission queues.
We might have a 1:1 mapping between the two, or it might be
an N:M mapping. That all depends on what the hardware supports.

blk-mq provides various helper functions, which include:

- Scalable support for request tagging. Most devices need to
  be able to uniquely identify a request both in the driver and
  to the hardware. The tagging uses per-cpu caches for freed
  tags, to enable cache hot reuse.

- Timeout handling without tracking request on a per-device
  basis. Basically the driver should be able to get a notification,
  if a request happens to fail.

- Optional support for non 1:1 mappings between issue and
  submission queues. blk-mq can redirect IO completions to the
  desired location.

- Support for per-request payloads. Drivers almost always need
  to associate a request structure with some driver private
  command structure. Drivers can tell blk-mq this at init time,
  and then any request handed to the driver will have the
  required size of memory associated with it.

- Support for merging of IO, and plugging. The stacked model
  gets neither of these. Even for high IOPS devices, merging
  sequential IO reduces per-command overhead and thus
  increases bandwidth.

For now, this is provided as a potential 3rd queueing model, with
the hope being that, as it matures, it can replace both the classic
and stacked model. That would get us back to having just 1 real
model for block devices, leaving the stacked approach to dm/md
devices (as it was originally intended).

Contributions in this patch from the following people:

Shaohua Li <shli@fusionio.com>
Alexander Gordeev <agordeev@redhat.com>
Christoph Hellwig <hch@infradead.org>
Mike Christie <michaelc@cs.wisc.edu>
Matias Bjorling <m@bjorling.me>
Jeff Moyer <jmoyer@redhat.com>

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/Makefile            |    5 +-
 block/blk-core.c          |  142 +++--
 block/blk-exec.c          |    7 +
 block/blk-flush.c         |  154 ++++-
 block/blk-mq-cpu.c        |   93 +++
 block/blk-mq-cpumap.c     |  108 ++++
 block/blk-mq-sysfs.c      |  384 ++++++++++++
 block/blk-mq-tag.c        |  204 +++++++
 block/blk-mq-tag.h        |   27 +
 block/blk-mq.c            | 1480 +++++++++++++++++++++++++++++++++++++++++++++
 block/blk-mq.h            |   52 ++
 block/blk-sysfs.c         |   13 +
 block/blk-timeout.c       |   73 ++-
 block/blk.h               |   17 +
 include/linux/bio.h       |    2 +
 include/linux/blk-mq.h    |  182 ++++++
 include/linux/blk_types.h |    2 +
 include/linux/blkdev.h    |   54 +-
 18 files changed, 2890 insertions(+), 109 deletions(-)
 create mode 100644 block/blk-mq-cpu.c
 create mode 100644 block/blk-mq-cpumap.c
 create mode 100644 block/blk-mq-sysfs.c
 create mode 100644 block/blk-mq-tag.c
 create mode 100644 block/blk-mq-tag.h
 create mode 100644 block/blk-mq.c
 create mode 100644 block/blk-mq.h
 create mode 100644 include/linux/blk-mq.h

diff --git a/block/Makefile b/block/Makefile
index 671a83d..20645e8 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -5,8 +5,9 @@
 obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-flush.o blk-settings.o blk-ioc.o blk-map.o \
 			blk-exec.o blk-merge.o blk-softirq.o blk-timeout.o \
-			blk-iopoll.o blk-lib.o ioctl.o genhd.o scsi_ioctl.o \
-			partition-generic.o partitions/
+			blk-iopoll.o blk-lib.o blk-mq.o blk-mq-tag.o \
+			blk-mq-sysfs.o blk-mq-cpu.o blk-mq-cpumap.o ioctl.o \
+			genhd.o scsi_ioctl.o partition-generic.o partitions/
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_BLK_DEV_BSGLIB)	+= bsg-lib.o
diff --git a/block/blk-core.c b/block/blk-core.c
index 18faa7e..3bb9e9f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -16,6 +16,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
 #include <linux/kernel_stat.h>
@@ -48,7 +49,7 @@ DEFINE_IDA(blk_queue_ida);
 /*
  * For the allocated request tables
  */
-static struct kmem_cache *request_cachep;
+struct kmem_cache *request_cachep = NULL;
 
 /*
  * For queue allocation
@@ -60,42 +61,6 @@ struct kmem_cache *blk_requestq_cachep;
  */
 static struct workqueue_struct *kblockd_workqueue;
 
-static void drive_stat_acct(struct request *rq, int new_io)
-{
-	struct hd_struct *part;
-	int rw = rq_data_dir(rq);
-	int cpu;
-
-	if (!blk_do_io_stat(rq))
-		return;
-
-	cpu = part_stat_lock();
-
-	if (!new_io) {
-		part = rq->part;
-		part_stat_inc(cpu, part, merges[rw]);
-	} else {
-		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
-		if (!hd_struct_try_get(part)) {
-			/*
-			 * The partition is already being removed,
-			 * the request will be accounted on the disk only
-			 *
-			 * We take a reference on disk->part0 although that
-			 * partition will never be deleted, so we can treat
-			 * it as any other partition.
-			 */
-			part = &rq->rq_disk->part0;
-			hd_struct_get(part);
-		}
-		part_round_stats(cpu, part);
-		part_inc_in_flight(part, rw);
-		rq->part = part;
-	}
-
-	part_stat_unlock();
-}
-
 void blk_queue_congestion_threshold(struct request_queue *q)
 {
 	int nr;
@@ -594,9 +559,12 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (!q)
 		return NULL;
 
+	if (percpu_counter_init(&q->mq_usage_counter, 0))
+		goto fail_q;
+
 	q->id = ida_simple_get(&blk_queue_ida, 0, 0, gfp_mask);
 	if (q->id < 0)
-		goto fail_q;
+		goto fail_c;
 
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
@@ -643,6 +611,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	q->bypass_depth = 1;
 	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
 
+	init_waitqueue_head(&q->mq_freeze_wq);
+
 	if (blkcg_init_queue(q))
 		goto fail_id;
 
@@ -650,6 +620,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
+fail_c:
+	percpu_counter_destroy(&q->mq_usage_counter);
 fail_q:
 	kmem_cache_free(blk_requestq_cachep, q);
 	return NULL;
@@ -1108,7 +1080,8 @@ retry:
 	goto retry;
 }
 
-struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
+static struct request *blk_old_get_request(struct request_queue *q, int rw,
+		gfp_t gfp_mask)
 {
 	struct request *rq;
 
@@ -1125,6 +1098,14 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 
 	return rq;
 }
+
+struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
+{
+	if (q->mq_ops)
+		return blk_mq_alloc_request(q, rw, gfp_mask);
+	else
+		return blk_old_get_request(q, rw, gfp_mask);
+}
 EXPORT_SYMBOL(blk_get_request);
 
 /**
@@ -1210,7 +1191,7 @@ EXPORT_SYMBOL(blk_requeue_request);
 static void add_acct_request(struct request_queue *q, struct request *rq,
 			     int where)
 {
-	drive_stat_acct(rq, 1);
+	blk_account_io_start(rq, true);
 	__elv_add_request(q, rq, where);
 }
 
@@ -1299,12 +1280,17 @@ EXPORT_SYMBOL_GPL(__blk_put_request);
 
 void blk_put_request(struct request *req)
 {
-	unsigned long flags;
 	struct request_queue *q = req->q;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	__blk_put_request(q, req);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	if (q->mq_ops)
+		blk_mq_free_request(req);
+	else {
+		unsigned long flags;
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		__blk_put_request(q, req);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
 }
 EXPORT_SYMBOL(blk_put_request);
 
@@ -1340,8 +1326,8 @@ void blk_add_request_payload(struct request *rq, struct page *page,
 }
 EXPORT_SYMBOL_GPL(blk_add_request_payload);
 
-static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
-				   struct bio *bio)
+bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
+			    struct bio *bio)
 {
 	const int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 
@@ -1358,12 +1344,12 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
 	req->__data_len += bio->bi_size;
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
-	drive_stat_acct(req, 0);
+	blk_account_io_start(req, false);
 	return true;
 }
 
-static bool bio_attempt_front_merge(struct request_queue *q,
-				    struct request *req, struct bio *bio)
+bool bio_attempt_front_merge(struct request_queue *q, struct request *req,
+			     struct bio *bio)
 {
 	const int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 
@@ -1388,12 +1374,12 @@ static bool bio_attempt_front_merge(struct request_queue *q,
 	req->__data_len += bio->bi_size;
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
-	drive_stat_acct(req, 0);
+	blk_account_io_start(req, false);
 	return true;
 }
 
 /**
- * attempt_plug_merge - try to merge with %current's plugged list
+ * blk_attempt_plug_merge - try to merge with %current's plugged list
  * @q: request_queue new bio is being queued at
  * @bio: new bio being queued
  * @request_count: out parameter for number of traversed plugged requests
@@ -1409,8 +1395,8 @@ static bool bio_attempt_front_merge(struct request_queue *q,
  * reliable access to the elevator outside queue lock.  Only check basic
  * merging parameters without querying the elevator.
  */
-static bool attempt_plug_merge(struct request_queue *q, struct bio *bio,
-			       unsigned int *request_count)
+bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
+			    unsigned int *request_count)
 {
 	struct blk_plug *plug;
 	struct request *rq;
@@ -1489,7 +1475,7 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
 	 * Check if we can merge with the plugged list before grabbing
 	 * any locks.
 	 */
-	if (attempt_plug_merge(q, bio, &request_count))
+	if (blk_attempt_plug_merge(q, bio, &request_count))
 		return;
 
 	spin_lock_irq(q->queue_lock);
@@ -1557,7 +1543,7 @@ get_rq:
 			}
 		}
 		list_add_tail(&req->queuelist, &plug->list);
-		drive_stat_acct(req, 1);
+		blk_account_io_start(req, true);
 	} else {
 		spin_lock_irq(q->queue_lock);
 		add_acct_request(q, req, where);
@@ -2011,7 +1997,7 @@ unsigned int blk_rq_err_bytes(const struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_rq_err_bytes);
 
-static void blk_account_io_completion(struct request *req, unsigned int bytes)
+void blk_account_io_completion(struct request *req, unsigned int bytes)
 {
 	if (blk_do_io_stat(req)) {
 		const int rw = rq_data_dir(req);
@@ -2025,7 +2011,7 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
 	}
 }
 
-static void blk_account_io_done(struct request *req)
+void blk_account_io_done(struct request *req)
 {
 	/*
 	 * Account IO completion.  flush_rq isn't accounted as a
@@ -2073,6 +2059,42 @@ static inline struct request *blk_pm_peek_request(struct request_queue *q,
 }
 #endif
 
+void blk_account_io_start(struct request *rq, bool new_io)
+{
+	struct hd_struct *part;
+	int rw = rq_data_dir(rq);
+	int cpu;
+
+	if (!blk_do_io_stat(rq))
+		return;
+
+	cpu = part_stat_lock();
+
+	if (!new_io) {
+		part = rq->part;
+		part_stat_inc(cpu, part, merges[rw]);
+	} else {
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
+		if (!hd_struct_try_get(part)) {
+			/*
+			 * The partition is already being removed,
+			 * the request will be accounted on the disk only
+			 *
+			 * We take a reference on disk->part0 although that
+			 * partition will never be deleted, so we can treat
+			 * it as any other partition.
+			 */
+			part = &rq->rq_disk->part0;
+			hd_struct_get(part);
+		}
+		part_round_stats(cpu, part);
+		part_inc_in_flight(part, rw);
+		rq->part = part;
+	}
+
+	part_stat_unlock();
+}
+
 /**
  * blk_peek_request - peek at the top of a request queue
  * @q: request queue to peek at
@@ -2448,7 +2470,6 @@ static void blk_finish_request(struct request *req, int error)
 	if (req->cmd_flags & REQ_DONTPREP)
 		blk_unprep_request(req);
 
-
 	blk_account_io_done(req);
 
 	if (req->end_io)
@@ -2870,6 +2891,7 @@ void blk_start_plug(struct blk_plug *plug)
 
 	plug->magic = PLUG_MAGIC;
 	INIT_LIST_HEAD(&plug->list);
+	INIT_LIST_HEAD(&plug->mq_list);
 	INIT_LIST_HEAD(&plug->cb_list);
 
 	/*
@@ -2967,6 +2989,10 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 	BUG_ON(plug->magic != PLUG_MAGIC);
 
 	flush_plug_callbacks(plug, from_schedule);
+
+	if (!list_empty(&plug->mq_list))
+		blk_mq_flush_plug_list(plug, from_schedule);
+
 	if (list_empty(&plug->list))
 		return;
 
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 6b18d82..c3edf9d 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/sched/sysctl.h>
 
 #include "blk.h"
@@ -58,6 +59,12 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
+
+	if (q->mq_ops) {
+		blk_mq_insert_request(q, rq, true);
+		return;
+	}
+
 	/*
 	 * need to check this before __blk_run_queue(), because rq can
 	 * be freed before that returns.
diff --git a/block/blk-flush.c b/block/blk-flush.c
index cc2b827..3e4cc9c 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -69,8 +69,10 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/gfp.h>
+#include <linux/blk-mq.h>
 
 #include "blk.h"
+#include "blk-mq.h"
 
 /* FLUSH/FUA sequences */
 enum {
@@ -124,6 +126,24 @@ static void blk_flush_restore_request(struct request *rq)
 	/* make @rq a normal request */
 	rq->cmd_flags &= ~REQ_FLUSH_SEQ;
 	rq->end_io = rq->flush.saved_end_io;
+
+	blk_clear_rq_complete(rq);
+}
+
+static void mq_flush_data_run(struct work_struct *work)
+{
+	struct request *rq;
+
+	rq = container_of(work, struct request, mq_flush_data);
+
+	memset(&rq->csd, 0, sizeof(rq->csd));
+	blk_mq_run_request(rq, true, false);
+}
+
+static void blk_mq_flush_data_insert(struct request *rq)
+{
+	INIT_WORK(&rq->mq_flush_data, mq_flush_data_run);
+	kblockd_schedule_work(rq->q, &rq->mq_flush_data);
 }
 
 /**
@@ -136,7 +156,7 @@ static void blk_flush_restore_request(struct request *rq)
  * completion and trigger the next step.
  *
  * CONTEXT:
- * spin_lock_irq(q->queue_lock)
+ * spin_lock_irq(q->queue_lock or q->mq_flush_lock)
  *
  * RETURNS:
  * %true if requests were added to the dispatch queue, %false otherwise.
@@ -146,7 +166,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 {
 	struct request_queue *q = rq->q;
 	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
-	bool queued = false;
+	bool queued = false, kicked;
 
 	BUG_ON(rq->flush.seq & seq);
 	rq->flush.seq |= seq;
@@ -167,8 +187,12 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 
 	case REQ_FSEQ_DATA:
 		list_move_tail(&rq->flush.list, &q->flush_data_in_flight);
-		list_add(&rq->queuelist, &q->queue_head);
-		queued = true;
+		if (q->mq_ops)
+			blk_mq_flush_data_insert(rq);
+		else {
+			list_add(&rq->queuelist, &q->queue_head);
+			queued = true;
+		}
 		break;
 
 	case REQ_FSEQ_DONE:
@@ -181,28 +205,43 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 		BUG_ON(!list_empty(&rq->queuelist));
 		list_del_init(&rq->flush.list);
 		blk_flush_restore_request(rq);
-		__blk_end_request_all(rq, error);
+		if (q->mq_ops)
+			blk_mq_end_io(rq, error);
+		else
+			__blk_end_request_all(rq, error);
 		break;
 
 	default:
 		BUG();
 	}
 
-	return blk_kick_flush(q) | queued;
+	kicked = blk_kick_flush(q);
+	/* blk_mq_run_flush will run queue */
+	if (q->mq_ops)
+		return queued;
+	return kicked | queued;
 }
 
 static void flush_end_io(struct request *flush_rq, int error)
 {
 	struct request_queue *q = flush_rq->q;
-	struct list_head *running = &q->flush_queue[q->flush_running_idx];
+	struct list_head *running;
 	bool queued = false;
 	struct request *rq, *n;
+	unsigned long flags = 0;
 
+	if (q->mq_ops) {
+		blk_mq_free_request(flush_rq);
+		spin_lock_irqsave(&q->mq_flush_lock, flags);
+	}
+	running = &q->flush_queue[q->flush_running_idx];
 	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
 
 	/* account completion of the flush request */
 	q->flush_running_idx ^= 1;
-	elv_completed_request(q, flush_rq);
+
+	if (!q->mq_ops)
+		elv_completed_request(q, flush_rq);
 
 	/* and push the waiting requests to the next stage */
 	list_for_each_entry_safe(rq, n, running, flush.list) {
@@ -223,9 +262,48 @@ static void flush_end_io(struct request *flush_rq, int error)
 	 * directly into request_fn may confuse the driver.  Always use
 	 * kblockd.
 	 */
-	if (queued || q->flush_queue_delayed)
-		blk_run_queue_async(q);
+	if (queued || q->flush_queue_delayed) {
+		if (!q->mq_ops)
+			blk_run_queue_async(q);
+		else
+		/*
+		 * This can be optimized to only run queues with requests
+		 * queued if necessary.
+		 */
+			blk_mq_run_queues(q, true);
+	}
 	q->flush_queue_delayed = 0;
+	if (q->mq_ops)
+		spin_unlock_irqrestore(&q->mq_flush_lock, flags);
+}
+
+static void mq_flush_work(struct work_struct *work)
+{
+	struct request_queue *q;
+	struct request *rq;
+
+	q = container_of(work, struct request_queue, mq_flush_work);
+
+	/* We don't need set REQ_FLUSH_SEQ, it's for consistency */
+	rq = blk_mq_alloc_request(q, WRITE_FLUSH|REQ_FLUSH_SEQ,
+		__GFP_WAIT|GFP_ATOMIC);
+	rq->cmd_type = REQ_TYPE_FS;
+	rq->end_io = flush_end_io;
+
+	blk_mq_run_request(rq, true, false);
+}
+
+/*
+ * We can't directly use q->flush_rq, because it doesn't have tag and is not in
+ * hctx->rqs[]. so we must allocate a new request, since we can't sleep here,
+ * so offload the work to workqueue.
+ *
+ * Note: we assume a flush request finished in any hardware queue will flush
+ * the whole disk cache.
+ */
+static void mq_run_flush(struct request_queue *q)
+{
+	kblockd_schedule_work(q, &q->mq_flush_work);
 }
 
 /**
@@ -236,7 +314,7 @@ static void flush_end_io(struct request *flush_rq, int error)
  * Please read the comment at the top of this file for more info.
  *
  * CONTEXT:
- * spin_lock_irq(q->queue_lock)
+ * spin_lock_irq(q->queue_lock or q->mq_flush_lock)
  *
  * RETURNS:
  * %true if flush was issued, %false otherwise.
@@ -261,13 +339,18 @@ static bool blk_kick_flush(struct request_queue *q)
 	 * Issue flush and toggle pending_idx.  This makes pending_idx
 	 * different from running_idx, which means flush is in flight.
 	 */
+	q->flush_pending_idx ^= 1;
+	if (q->mq_ops) {
+		mq_run_flush(q);
+		return true;
+	}
+
 	blk_rq_init(q, &q->flush_rq);
 	q->flush_rq.cmd_type = REQ_TYPE_FS;
 	q->flush_rq.cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
 	q->flush_rq.rq_disk = first_rq->rq_disk;
 	q->flush_rq.end_io = flush_end_io;
 
-	q->flush_pending_idx ^= 1;
 	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
 	return true;
 }
@@ -284,16 +367,37 @@ static void flush_data_end_io(struct request *rq, int error)
 		blk_run_queue_async(q);
 }
 
+static void mq_flush_data_end_io(struct request *rq, int error)
+{
+	struct request_queue *q = rq->q;
+	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_ctx *ctx;
+	unsigned long flags;
+
+	ctx = rq->mq_ctx;
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+	/*
+	 * After populating an empty queue, kick it to avoid stall.  Read
+	 * the comment in flush_end_io().
+	 */
+	spin_lock_irqsave(&q->mq_flush_lock, flags);
+	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
+		blk_mq_run_hw_queue(hctx, true);
+	spin_unlock_irqrestore(&q->mq_flush_lock, flags);
+}
+
 /**
  * blk_insert_flush - insert a new FLUSH/FUA request
  * @rq: request to insert
  *
  * To be called from __elv_add_request() for %ELEVATOR_INSERT_FLUSH insertions.
+ * or __blk_mq_run_hw_queue() to dispatch request.
  * @rq is being submitted.  Analyze what needs to be done and put it on the
  * right queue.
  *
  * CONTEXT:
- * spin_lock_irq(q->queue_lock)
+ * spin_lock_irq(q->queue_lock) in !mq case
  */
 void blk_insert_flush(struct request *rq)
 {
@@ -316,7 +420,10 @@ void blk_insert_flush(struct request *rq)
 	 * complete the request.
 	 */
 	if (!policy) {
-		__blk_end_bidi_request(rq, 0, 0, 0);
+		if (q->mq_ops)
+			blk_mq_end_io(rq, 0);
+		else
+			__blk_end_bidi_request(rq, 0, 0, 0);
 		return;
 	}
 
@@ -329,7 +436,10 @@ void blk_insert_flush(struct request *rq)
 	 */
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
-		list_add_tail(&rq->queuelist, &q->queue_head);
+		if (q->mq_ops) {
+			blk_mq_run_request(rq, false, true);
+		} else
+			list_add_tail(&rq->queuelist, &q->queue_head);
 		return;
 	}
 
@@ -341,6 +451,14 @@ void blk_insert_flush(struct request *rq)
 	INIT_LIST_HEAD(&rq->flush.list);
 	rq->cmd_flags |= REQ_FLUSH_SEQ;
 	rq->flush.saved_end_io = rq->end_io; /* Usually NULL */
+	if (q->mq_ops) {
+		rq->end_io = mq_flush_data_end_io;
+
+		spin_lock_irq(&q->mq_flush_lock);
+		blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
+		spin_unlock_irq(&q->mq_flush_lock);
+		return;
+	}
 	rq->end_io = flush_data_end_io;
 
 	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
@@ -453,3 +571,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
+
+void blk_mq_init_flush(struct request_queue *q)
+{
+	spin_lock_init(&q->mq_flush_lock);
+	INIT_WORK(&q->mq_flush_work, mq_flush_work);
+}
diff --git a/block/blk-mq-cpu.c b/block/blk-mq-cpu.c
new file mode 100644
index 0000000..f8ea39d
--- /dev/null
+++ b/block/blk-mq-cpu.c
@@ -0,0 +1,93 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/list.h>
+#include <linux/llist.h>
+#include <linux/smp.h>
+#include <linux/cpu.h>
+
+#include <linux/blk-mq.h>
+#include "blk-mq.h"
+
+static LIST_HEAD(blk_mq_cpu_notify_list);
+static DEFINE_SPINLOCK(blk_mq_cpu_notify_lock);
+
+static int __cpuinit blk_mq_main_cpu_notify(struct notifier_block *self,
+					    unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long) hcpu;
+	struct blk_mq_cpu_notifier *notify;
+
+	spin_lock(&blk_mq_cpu_notify_lock);
+
+	list_for_each_entry(notify, &blk_mq_cpu_notify_list, list)
+		notify->notify(notify->data, action, cpu);
+
+	spin_unlock(&blk_mq_cpu_notify_lock);
+	return NOTIFY_OK;
+}
+
+static void __cpuinit blk_mq_cpu_notify(void *data, unsigned long action,
+					unsigned int cpu)
+{
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		/*
+		 * If the CPU goes away, ensure that we run any pending
+		 * completions.
+		 */
+		struct llist_node *node;
+		struct request *rq;
+
+		local_irq_disable();
+
+		node = llist_del_all(&per_cpu(ipi_lists, cpu));
+		while (node) {
+			struct llist_node *next = node->next;
+
+			rq = llist_entry(node, struct request, ll_list);
+			__blk_mq_end_io(rq, rq->errors);
+			node = next;
+		}
+
+		local_irq_enable();
+	}
+}
+
+static struct notifier_block __cpuinitdata blk_mq_main_cpu_notifier = {
+	.notifier_call	= blk_mq_main_cpu_notify,
+};
+
+void blk_mq_register_cpu_notifier(struct blk_mq_cpu_notifier *notifier)
+{
+	BUG_ON(!notifier->notify);
+
+	spin_lock(&blk_mq_cpu_notify_lock);
+	list_add_tail(&notifier->list, &blk_mq_cpu_notify_list);
+	spin_unlock(&blk_mq_cpu_notify_lock);
+}
+
+void blk_mq_unregister_cpu_notifier(struct blk_mq_cpu_notifier *notifier)
+{
+	spin_lock(&blk_mq_cpu_notify_lock);
+	list_del(&notifier->list);
+	spin_unlock(&blk_mq_cpu_notify_lock);
+}
+
+void blk_mq_init_cpu_notifier(struct blk_mq_cpu_notifier *notifier,
+			      void (*fn)(void *, unsigned long, unsigned int),
+			      void *data)
+{
+	notifier->notify = fn;
+	notifier->data = data;
+}
+
+static struct blk_mq_cpu_notifier __cpuinitdata cpu_notifier = {
+	.notify = blk_mq_cpu_notify,
+};
+
+void __init blk_mq_cpu_init(void)
+{
+	register_hotcpu_notifier(&blk_mq_main_cpu_notifier);
+	blk_mq_register_cpu_notifier(&cpu_notifier);
+}
diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
new file mode 100644
index 0000000..f872127
--- /dev/null
+++ b/block/blk-mq-cpumap.c
@@ -0,0 +1,108 @@
+#include <linux/kernel.h>
+#include <linux/threads.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/cpu.h>
+
+#include <linux/blk-mq.h>
+#include "blk.h"
+#include "blk-mq.h"
+
+static void show_map(unsigned int *map, unsigned int nr)
+{
+	int i;
+
+	pr_info("blk-mq: CPU -> queue map\n");
+	for_each_online_cpu(i)
+		pr_info("  CPU%2u -> Queue %u\n", i, map[i]);
+}
+
+static int cpu_to_queue_index(unsigned int nr_cpus, unsigned int nr_queues,
+			      const int cpu)
+{
+	return cpu / ((nr_cpus + nr_queues - 1) / nr_queues);
+}
+
+static int get_first_sibling(unsigned int cpu)
+{
+	unsigned int ret;
+
+	ret = cpumask_first(topology_thread_cpumask(cpu));
+	if (ret < nr_cpu_ids)
+		return ret;
+
+	return cpu;
+}
+
+int blk_mq_update_queue_map(unsigned int *map, unsigned int nr_queues)
+{
+	unsigned int i, nr_cpus, nr_uniq_cpus, queue, first_sibling;
+	cpumask_var_t cpus;
+
+	if (!alloc_cpumask_var(&cpus, GFP_ATOMIC))
+		return 1;
+
+	cpumask_clear(cpus);
+	nr_cpus = nr_uniq_cpus = 0;
+	for_each_online_cpu(i) {
+		nr_cpus++;
+		first_sibling = get_first_sibling(i);
+		if (!cpumask_test_cpu(first_sibling, cpus))
+			nr_uniq_cpus++;
+		cpumask_set_cpu(i, cpus);
+	}
+
+	queue = 0;
+	for_each_possible_cpu(i) {
+		if (!cpu_online(i)) {
+			map[i] = 0;
+			continue;
+		}
+
+		/*
+		 * Easy case - we have equal or more hardware queues. Or
+		 * there are no thread siblings to take into account. Do
+		 * 1:1 if enough, or sequential mapping if less.
+		 */
+		if (nr_queues >= nr_cpus || nr_cpus == nr_uniq_cpus) {
+			map[i] = cpu_to_queue_index(nr_cpus, nr_queues, queue);
+			queue++;
+			continue;
+		}
+
+		/*
+		 * Less then nr_cpus queues, and we have some number of
+		 * threads per cores. Map sibling threads to the same
+		 * queue.
+		 */
+		first_sibling = get_first_sibling(i);
+		if (first_sibling == i) {
+			map[i] = cpu_to_queue_index(nr_uniq_cpus, nr_queues,
+							queue);
+			queue++;
+		} else
+			map[i] = map[first_sibling];
+	}
+
+	show_map(map, nr_cpus);
+	free_cpumask_var(cpus);
+	return 0;
+}
+
+unsigned int *blk_mq_make_queue_map(struct blk_mq_reg *reg)
+{
+	unsigned int *map;
+
+	/* If cpus are offline, map them to first hctx */
+	map = kzalloc_node(sizeof(*map) * num_possible_cpus(), GFP_KERNEL,
+				reg->numa_node);
+	if (!map)
+		return NULL;
+
+	if (!blk_mq_update_queue_map(map, reg->nr_hw_queues))
+		return map;
+
+	kfree(map);
+	return NULL;
+}
diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
new file mode 100644
index 0000000..165dcf0
--- /dev/null
+++ b/block/blk-mq-sysfs.c
@@ -0,0 +1,384 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/backing-dev.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/smp.h>
+
+#include <linux/blk-mq.h>
+#include "blk-mq.h"
+#include "blk-mq-tag.h"
+
+static void blk_mq_sysfs_release(struct kobject *kobj)
+{
+}
+
+struct blk_mq_ctx_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct blk_mq_ctx *, char *);
+	ssize_t (*store)(struct blk_mq_ctx *, const char *, size_t);
+};
+
+struct blk_mq_hw_ctx_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct blk_mq_hw_ctx *, char *);
+	ssize_t (*store)(struct blk_mq_hw_ctx *, const char *, size_t);
+};
+
+static ssize_t blk_mq_sysfs_show(struct kobject *kobj, struct attribute *attr,
+				 char *page)
+{
+	struct blk_mq_ctx_sysfs_entry *entry;
+	struct blk_mq_ctx *ctx;
+	struct request_queue *q;
+	ssize_t res;
+
+	entry = container_of(attr, struct blk_mq_ctx_sysfs_entry, attr);
+	ctx = container_of(kobj, struct blk_mq_ctx, kobj);
+	q = ctx->queue;
+
+	if (!entry->show)
+		return -EIO;
+
+	res = -ENOENT;
+	mutex_lock(&q->sysfs_lock);
+	if (!blk_queue_dying(q))
+		res = entry->show(ctx, page);
+	mutex_unlock(&q->sysfs_lock);
+	return res;
+}
+
+static ssize_t blk_mq_sysfs_store(struct kobject *kobj, struct attribute *attr,
+				  const char *page, size_t length)
+{
+	struct blk_mq_ctx_sysfs_entry *entry;
+	struct blk_mq_ctx *ctx;
+	struct request_queue *q;
+	ssize_t res;
+
+	entry = container_of(attr, struct blk_mq_ctx_sysfs_entry, attr);
+	ctx = container_of(kobj, struct blk_mq_ctx, kobj);
+	q = ctx->queue;
+
+	if (!entry->store)
+		return -EIO;
+
+	res = -ENOENT;
+	mutex_lock(&q->sysfs_lock);
+	if (!blk_queue_dying(q))
+		res = entry->store(ctx, page, length);
+	mutex_unlock(&q->sysfs_lock);
+	return res;
+}
+
+static ssize_t blk_mq_hw_sysfs_show(struct kobject *kobj,
+				    struct attribute *attr, char *page)
+{
+	struct blk_mq_hw_ctx_sysfs_entry *entry;
+	struct blk_mq_hw_ctx *hctx;
+	struct request_queue *q;
+	ssize_t res;
+
+	entry = container_of(attr, struct blk_mq_hw_ctx_sysfs_entry, attr);
+	hctx = container_of(kobj, struct blk_mq_hw_ctx, kobj);
+	q = hctx->queue;
+
+	if (!entry->show)
+		return -EIO;
+
+	res = -ENOENT;
+	mutex_lock(&q->sysfs_lock);
+	if (!blk_queue_dying(q))
+		res = entry->show(hctx, page);
+	mutex_unlock(&q->sysfs_lock);
+	return res;
+}
+
+static ssize_t blk_mq_hw_sysfs_store(struct kobject *kobj,
+				     struct attribute *attr, const char *page,
+				     size_t length)
+{
+	struct blk_mq_hw_ctx_sysfs_entry *entry;
+	struct blk_mq_hw_ctx *hctx;
+	struct request_queue *q;
+	ssize_t res;
+
+	entry = container_of(attr, struct blk_mq_hw_ctx_sysfs_entry, attr);
+	hctx = container_of(kobj, struct blk_mq_hw_ctx, kobj);
+	q = hctx->queue;
+
+	if (!entry->store)
+		return -EIO;
+
+	res = -ENOENT;
+	mutex_lock(&q->sysfs_lock);
+	if (!blk_queue_dying(q))
+		res = entry->store(hctx, page, length);
+	mutex_unlock(&q->sysfs_lock);
+	return res;
+}
+
+static ssize_t blk_mq_sysfs_dispatched_show(struct blk_mq_ctx *ctx, char *page)
+{
+	return sprintf(page, "%lu %lu\n", ctx->rq_dispatched[1],
+				ctx->rq_dispatched[0]);
+}
+
+static ssize_t blk_mq_sysfs_merged_show(struct blk_mq_ctx *ctx, char *page)
+{
+	return sprintf(page, "%lu\n", ctx->rq_merged);
+}
+
+static ssize_t blk_mq_sysfs_completed_show(struct blk_mq_ctx *ctx, char *page)
+{
+	return sprintf(page, "%lu %lu\n", ctx->rq_completed[1],
+				ctx->rq_completed[0]);
+}
+
+static ssize_t sysfs_list_show(char *page, struct list_head *list, char *msg)
+{
+	char *start_page = page;
+	struct request *rq;
+
+	page += sprintf(page, "%s:\n", msg);
+
+	list_for_each_entry(rq, list, queuelist)
+		page += sprintf(page, "\t%p\n", rq);
+
+	return page - start_page;
+}
+
+static ssize_t blk_mq_sysfs_rq_list_show(struct blk_mq_ctx *ctx, char *page)
+{
+	ssize_t ret;
+
+	spin_lock(&ctx->lock);
+	ret = sysfs_list_show(page, &ctx->rq_list, "CTX pending");
+	spin_unlock(&ctx->lock);
+
+	return ret;
+}
+
+static ssize_t blk_mq_hw_sysfs_queued_show(struct blk_mq_hw_ctx *hctx,
+					   char *page)
+{
+	return sprintf(page, "%lu\n", hctx->queued);
+}
+
+static ssize_t blk_mq_hw_sysfs_run_show(struct blk_mq_hw_ctx *hctx, char *page)
+{
+	return sprintf(page, "%lu\n", hctx->run);
+}
+
+static ssize_t blk_mq_hw_sysfs_dispatched_show(struct blk_mq_hw_ctx *hctx,
+					       char *page)
+{
+	char *start_page = page;
+	int i;
+
+	page += sprintf(page, "%8u\t%lu\n", 0U, hctx->dispatched[0]);
+
+	for (i = 1; i < BLK_MQ_MAX_DISPATCH_ORDER; i++) {
+		unsigned long d = 1U << (i - 1);
+
+		page += sprintf(page, "%8lu\t%lu\n", d, hctx->dispatched[i]);
+	}
+
+	return page - start_page;
+}
+
+static ssize_t blk_mq_hw_sysfs_rq_list_show(struct blk_mq_hw_ctx *hctx,
+					    char *page)
+{
+	ssize_t ret;
+
+	spin_lock(&hctx->lock);
+	ret = sysfs_list_show(page, &hctx->dispatch, "HCTX pending");
+	spin_unlock(&hctx->lock);
+
+	return ret;
+}
+
+static ssize_t blk_mq_hw_sysfs_ipi_show(struct blk_mq_hw_ctx *hctx, char *page)
+{
+	ssize_t ret;
+
+	spin_lock(&hctx->lock);
+	ret = sprintf(page, "%u\n", !!(hctx->flags & BLK_MQ_F_SHOULD_IPI));
+	spin_unlock(&hctx->lock);
+
+	return ret;
+}
+
+static ssize_t blk_mq_hw_sysfs_ipi_store(struct blk_mq_hw_ctx *hctx,
+					 const char *page, size_t len)
+{
+	struct blk_mq_ctx *ctx;
+	unsigned long ret;
+	unsigned int i;
+
+	if (kstrtoul(page, 10, &ret)) {
+		pr_err("blk-mq-sysfs: invalid input '%s'\n", page);
+		return -EINVAL;
+	}
+
+	spin_lock(&hctx->lock);
+	if (ret)
+		hctx->flags |= BLK_MQ_F_SHOULD_IPI;
+	else
+		hctx->flags &= ~BLK_MQ_F_SHOULD_IPI;
+	spin_unlock(&hctx->lock);
+
+	hctx_for_each_ctx(hctx, ctx, i)
+		ctx->ipi_redirect = !!ret;
+
+	return len;
+}
+
+static ssize_t blk_mq_hw_sysfs_tags_show(struct blk_mq_hw_ctx *hctx, char *page)
+{
+	return blk_mq_tag_sysfs_show(hctx->tags, page);
+}
+
+static struct blk_mq_ctx_sysfs_entry blk_mq_sysfs_dispatched = {
+	.attr = {.name = "dispatched", .mode = S_IRUGO },
+	.show = blk_mq_sysfs_dispatched_show,
+};
+static struct blk_mq_ctx_sysfs_entry blk_mq_sysfs_merged = {
+	.attr = {.name = "merged", .mode = S_IRUGO },
+	.show = blk_mq_sysfs_merged_show,
+};
+static struct blk_mq_ctx_sysfs_entry blk_mq_sysfs_completed = {
+	.attr = {.name = "completed", .mode = S_IRUGO },
+	.show = blk_mq_sysfs_completed_show,
+};
+static struct blk_mq_ctx_sysfs_entry blk_mq_sysfs_rq_list = {
+	.attr = {.name = "rq_list", .mode = S_IRUGO },
+	.show = blk_mq_sysfs_rq_list_show,
+};
+
+static struct attribute *default_ctx_attrs[] = {
+	&blk_mq_sysfs_dispatched.attr,
+	&blk_mq_sysfs_merged.attr,
+	&blk_mq_sysfs_completed.attr,
+	&blk_mq_sysfs_rq_list.attr,
+	NULL,
+};
+
+static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_queued = {
+	.attr = {.name = "queued", .mode = S_IRUGO },
+	.show = blk_mq_hw_sysfs_queued_show,
+};
+static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_run = {
+	.attr = {.name = "run", .mode = S_IRUGO },
+	.show = blk_mq_hw_sysfs_run_show,
+};
+static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_dispatched = {
+	.attr = {.name = "dispatched", .mode = S_IRUGO },
+	.show = blk_mq_hw_sysfs_dispatched_show,
+};
+static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_pending = {
+	.attr = {.name = "pending", .mode = S_IRUGO },
+	.show = blk_mq_hw_sysfs_rq_list_show,
+};
+static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_ipi = {
+	.attr = {.name = "ipi_redirect", .mode = S_IRUGO | S_IWUGO},
+	.show = blk_mq_hw_sysfs_ipi_show,
+	.store = blk_mq_hw_sysfs_ipi_store,
+};
+static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_tags = {
+	.attr = {.name = "tags", .mode = S_IRUGO },
+	.show = blk_mq_hw_sysfs_tags_show,
+};
+
+static struct attribute *default_hw_ctx_attrs[] = {
+	&blk_mq_hw_sysfs_queued.attr,
+	&blk_mq_hw_sysfs_run.attr,
+	&blk_mq_hw_sysfs_dispatched.attr,
+	&blk_mq_hw_sysfs_pending.attr,
+	&blk_mq_hw_sysfs_ipi.attr,
+	&blk_mq_hw_sysfs_tags.attr,
+	NULL,
+};
+
+static const struct sysfs_ops blk_mq_sysfs_ops = {
+	.show	= blk_mq_sysfs_show,
+	.store	= blk_mq_sysfs_store,
+};
+
+static const struct sysfs_ops blk_mq_hw_sysfs_ops = {
+	.show	= blk_mq_hw_sysfs_show,
+	.store	= blk_mq_hw_sysfs_store,
+};
+
+static struct kobj_type blk_mq_ktype = {
+	.sysfs_ops	= &blk_mq_sysfs_ops,
+	.release	= blk_mq_sysfs_release,
+};
+
+static struct kobj_type blk_mq_ctx_ktype = {
+	.sysfs_ops	= &blk_mq_sysfs_ops,
+	.default_attrs	= default_ctx_attrs,
+	.release	= blk_mq_sysfs_release,
+};
+
+static struct kobj_type blk_mq_hw_ktype = {
+	.sysfs_ops	= &blk_mq_hw_sysfs_ops,
+	.default_attrs	= default_hw_ctx_attrs,
+	.release	= blk_mq_sysfs_release,
+};
+
+void blk_mq_unregister_disk(struct gendisk *disk)
+{
+	struct request_queue *q = disk->queue;
+
+	kobject_uevent(&q->mq_kobj, KOBJ_REMOVE);
+	kobject_del(&q->mq_kobj);
+
+	kobject_put(&disk_to_dev(disk)->kobj);
+}
+
+int blk_mq_register_disk(struct gendisk *disk)
+{
+	struct device *dev = disk_to_dev(disk);
+	struct request_queue *q = disk->queue;
+	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_ctx *ctx;
+	int ret, i, j;
+
+	kobject_init(&q->mq_kobj, &blk_mq_ktype);
+
+	ret = kobject_add(&q->mq_kobj, kobject_get(&dev->kobj), "%s", "mq");
+	if (ret < 0)
+		return ret;
+
+	kobject_uevent(&q->mq_kobj, KOBJ_ADD);
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		kobject_init(&hctx->kobj, &blk_mq_hw_ktype);
+		ret = kobject_add(&hctx->kobj, &q->mq_kobj, "%u", i);
+		if (ret)
+			break;
+
+		if (!hctx->nr_ctx)
+			continue;
+
+		hctx_for_each_ctx(hctx, ctx, j) {
+			kobject_init(&ctx->kobj, &blk_mq_ctx_ktype);
+			ret = kobject_add(&ctx->kobj, &hctx->kobj, "cpu%u", ctx->cpu);
+			if (ret)
+				break;
+		}
+	}
+
+	if (ret) {
+		blk_mq_unregister_disk(disk);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
new file mode 100644
index 0000000..d64a02f
--- /dev/null
+++ b/block/blk-mq-tag.c
@@ -0,0 +1,204 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/percpu_ida.h>
+
+#include <linux/blk-mq.h>
+#include "blk.h"
+#include "blk-mq.h"
+#include "blk-mq-tag.h"
+
+/*
+ * Per tagged queue (tag address space) map
+ */
+struct blk_mq_tags {
+	unsigned int nr_tags;
+	unsigned int nr_reserved_tags;
+	unsigned int nr_batch_move;
+	unsigned int nr_max_cache;
+
+	struct percpu_ida free_tags;
+	struct percpu_ida reserved_tags;
+};
+
+void blk_mq_wait_for_tags(struct blk_mq_tags *tags)
+{
+	int tag = blk_mq_get_tag(tags, __GFP_WAIT, false);
+	blk_mq_put_tag(tags, tag);
+}
+
+bool blk_mq_has_free_tags(struct blk_mq_tags *tags)
+{
+	return !tags ||
+		percpu_ida_free_tags(&tags->free_tags, nr_cpu_ids) != 0;
+}
+
+static unsigned int __blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp)
+{
+	int tag;
+
+	tag = percpu_ida_alloc(&tags->free_tags, gfp);
+	if (tag < 0)
+		return BLK_MQ_TAG_FAIL;
+	return tag + tags->nr_reserved_tags;
+}
+
+static unsigned int __blk_mq_get_reserved_tag(struct blk_mq_tags *tags,
+					      gfp_t gfp)
+{
+	int tag;
+
+	if (unlikely(!tags->nr_reserved_tags)) {
+		WARN_ON_ONCE(1);
+		return BLK_MQ_TAG_FAIL;
+	}
+
+	tag = percpu_ida_alloc(&tags->reserved_tags, gfp);
+	if (tag < 0)
+		return BLK_MQ_TAG_FAIL;
+	return tag;
+}
+
+unsigned int blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp, bool reserved)
+{
+	if (!reserved)
+		return __blk_mq_get_tag(tags, gfp);
+
+	return __blk_mq_get_reserved_tag(tags, gfp);
+}
+
+static void __blk_mq_put_tag(struct blk_mq_tags *tags, unsigned int tag)
+{
+	BUG_ON(tag >= tags->nr_tags);
+
+	percpu_ida_free(&tags->free_tags, tag - tags->nr_reserved_tags);
+}
+
+static void __blk_mq_put_reserved_tag(struct blk_mq_tags *tags,
+				      unsigned int tag)
+{
+	BUG_ON(tag >= tags->nr_reserved_tags);
+
+	percpu_ida_free(&tags->reserved_tags, tag);
+}
+
+void blk_mq_put_tag(struct blk_mq_tags *tags, unsigned int tag)
+{
+	if (tag >= tags->nr_reserved_tags)
+		__blk_mq_put_tag(tags, tag);
+	else
+		__blk_mq_put_reserved_tag(tags, tag);
+}
+
+static int __blk_mq_tag_iter(unsigned id, void *data)
+{
+	unsigned long *tag_map = data;
+	__set_bit(id, tag_map);
+	return 0;
+}
+
+void blk_mq_tag_busy_iter(struct blk_mq_tags *tags,
+			  void (*fn)(void *, unsigned long *), void *data)
+{
+	unsigned long *tag_map;
+	size_t map_size;
+
+	map_size = ALIGN(tags->nr_tags, BITS_PER_LONG) / BITS_PER_LONG;
+	tag_map = kzalloc(map_size * sizeof(unsigned long), GFP_ATOMIC);
+	if (!tag_map)
+		return;
+
+	percpu_ida_for_each_free(&tags->free_tags, __blk_mq_tag_iter, tag_map);
+	if (tags->nr_reserved_tags)
+		percpu_ida_for_each_free(&tags->reserved_tags, __blk_mq_tag_iter,
+			tag_map);
+
+	fn(data, tag_map);
+	kfree(tag_map);
+}
+
+struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
+				     unsigned int reserved_tags, int node)
+{
+	unsigned int nr_tags, nr_cache;
+	struct blk_mq_tags *tags;
+	int ret;
+
+	if (total_tags > BLK_MQ_TAG_MAX) {
+		pr_err("blk-mq: tag depth too large\n");
+		return NULL;
+	}
+
+	tags = kzalloc_node(sizeof(*tags), GFP_KERNEL, node);
+	if (!tags)
+		return NULL;
+
+	nr_tags = total_tags - reserved_tags;
+	nr_cache = nr_tags / num_possible_cpus();
+
+	if (nr_cache < BLK_MQ_TAG_CACHE_MIN)
+		nr_cache = BLK_MQ_TAG_CACHE_MIN;
+	else if (nr_cache > BLK_MQ_TAG_CACHE_MAX)
+		nr_cache = BLK_MQ_TAG_CACHE_MAX;
+
+	tags->nr_tags = total_tags;
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
+
+	if (reserved_tags) {
+		/*
+		 * With max_cahe and batch set to 1, the allocator fallbacks to
+		 * no cached. It's fine reserved tags allocation is slow.
+		 */
+		ret = __percpu_ida_init(&tags->reserved_tags, reserved_tags,
+				1, 1);
+		if (ret)
+			goto err_reserved_tags;
+	}
+
+	return tags;
+
+err_reserved_tags:
+	percpu_ida_destroy(&tags->free_tags);
+err_free_tags:
+	kfree(tags);
+	return NULL;
+}
+
+void blk_mq_free_tags(struct blk_mq_tags *tags)
+{
+	percpu_ida_destroy(&tags->free_tags);
+	percpu_ida_destroy(&tags->reserved_tags);
+	kfree(tags);
+}
+
+ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page)
+{
+	char *orig_page = page;
+	int cpu;
+
+	if (!tags)
+		return 0;
+
+	page += sprintf(page, "nr_tags=%u, reserved_tags=%u, batch_move=%u,"
+			" max_cache=%u\n", tags->nr_tags, tags->nr_reserved_tags,
+			tags->nr_batch_move, tags->nr_max_cache);
+
+	page += sprintf(page, "nr_free=%u, nr_reserved=%u\n",
+			percpu_ida_free_tags(&tags->free_tags, nr_cpu_ids),
+			percpu_ida_free_tags(&tags->reserved_tags, nr_cpu_ids));
+
+	for_each_possible_cpu(cpu) {
+		page += sprintf(page, "  cpu%02u: nr_free=%u\n", cpu,
+				percpu_ida_free_tags(&tags->free_tags, cpu));
+	}
+
+	return page - orig_page;
+}
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
new file mode 100644
index 0000000..947ba2c
--- /dev/null
+++ b/block/blk-mq-tag.h
@@ -0,0 +1,27 @@
+#ifndef INT_BLK_MQ_TAG_H
+#define INT_BLK_MQ_TAG_H
+
+struct blk_mq_tags;
+
+extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int reserved_tags, int node);
+extern void blk_mq_free_tags(struct blk_mq_tags *tags);
+
+extern unsigned int blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp, bool reserved);
+extern void blk_mq_wait_for_tags(struct blk_mq_tags *tags);
+extern void blk_mq_put_tag(struct blk_mq_tags *tags, unsigned int tag);
+extern void blk_mq_tag_busy_iter(struct blk_mq_tags *tags, void (*fn)(void *data, unsigned long *), void *data);
+extern bool blk_mq_has_free_tags(struct blk_mq_tags *tags);
+extern ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page);
+
+enum {
+	BLK_MQ_TAG_CACHE_MIN	= 1,
+	BLK_MQ_TAG_CACHE_MAX	= 64,
+};
+
+enum {
+	BLK_MQ_TAG_FAIL		= -1U,
+	BLK_MQ_TAG_MIN		= BLK_MQ_TAG_CACHE_MIN,
+	BLK_MQ_TAG_MAX		= BLK_MQ_TAG_FAIL - 1,
+};
+
+#endif
diff --git a/block/blk-mq.c b/block/blk-mq.c
new file mode 100644
index 0000000..f21ec96
--- /dev/null
+++ b/block/blk-mq.c
@@ -0,0 +1,1480 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/backing-dev.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/smp.h>
+#include <linux/llist.h>
+#include <linux/list_sort.h>
+#include <linux/cpu.h>
+#include <linux/cache.h>
+#include <linux/sched/sysctl.h>
+#include <linux/delay.h>
+
+#include <trace/events/block.h>
+
+#include <linux/blk-mq.h>
+#include "blk.h"
+#include "blk-mq.h"
+#include "blk-mq-tag.h"
+
+static DEFINE_MUTEX(all_q_mutex);
+static LIST_HEAD(all_q_list);
+
+static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx);
+
+DEFINE_PER_CPU(struct llist_head, ipi_lists);
+
+static struct blk_mq_ctx *__blk_mq_get_ctx(struct request_queue *q,
+					   unsigned int cpu)
+{
+	return per_cpu_ptr(q->queue_ctx, cpu);
+}
+
+/*
+ * This assumes per-cpu software queueing queues. They could be per-node
+ * as well, for instance. For now this is hardcoded as-is. Note that we don't
+ * care about preemption, since we know the ctx's are persistent. This does
+ * mean that we can't rely on ctx always matching the currently running CPU.
+ */
+static struct blk_mq_ctx *blk_mq_get_ctx(struct request_queue *q)
+{
+	return __blk_mq_get_ctx(q, get_cpu());
+}
+
+static void blk_mq_put_ctx(struct blk_mq_ctx *ctx)
+{
+	put_cpu();
+}
+
+/*
+ * Check if any of the ctx's have pending work in this hardware queue
+ */
+static bool blk_mq_hctx_has_pending(struct blk_mq_hw_ctx *hctx)
+{
+	unsigned int i;
+
+	for (i = 0; i < hctx->nr_ctx_map; i++)
+		if (hctx->ctx_map[i])
+			return true;
+
+	return false;
+}
+
+/*
+ * Mark this ctx as having pending work in this hardware queue
+ */
+static void blk_mq_hctx_mark_pending(struct blk_mq_hw_ctx *hctx,
+				     struct blk_mq_ctx *ctx)
+{
+	if (!test_bit(ctx->index_hw, hctx->ctx_map))
+		set_bit(ctx->index_hw, hctx->ctx_map);
+}
+
+static struct request *blk_mq_alloc_rq(struct blk_mq_hw_ctx *hctx, gfp_t gfp,
+				       bool reserved)
+{
+	struct request *rq;
+	unsigned int tag;
+
+	tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
+	if (tag != BLK_MQ_TAG_FAIL) {
+		rq = hctx->rqs[tag];
+		rq->tag = tag;
+
+		return rq;
+	}
+
+	return NULL;
+}
+
+static int blk_mq_queue_enter(struct request_queue *q)
+{
+	int ret;
+
+	__percpu_counter_add(&q->mq_usage_counter, 1, 1000000);
+	smp_wmb();
+	/* we have problems to freeze the queue if it's initializing */
+	if (!blk_queue_bypass(q) || !blk_queue_init_done(q))
+		return 0;
+
+	__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
+
+	spin_lock_irq(q->queue_lock);
+	ret = wait_event_interruptible_lock_irq(q->mq_freeze_wq,
+		!blk_queue_bypass(q), *q->queue_lock);
+	/* inc usage with lock hold to avoid freeze_queue runs here */
+	if (!ret)
+		__percpu_counter_add(&q->mq_usage_counter, 1, 1000000);
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
+
+static void blk_mq_queue_exit(struct request_queue *q)
+{
+	__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
+}
+
+/*
+ * Guarantee no request is in use, so we can change any data structure of
+ * the queue afterward.
+ */
+static void blk_mq_freeze_queue(struct request_queue *q)
+{
+	bool drain;
+
+	spin_lock_irq(q->queue_lock);
+	drain = !q->bypass_depth++;
+	queue_flag_set(QUEUE_FLAG_BYPASS, q);
+	spin_unlock_irq(q->queue_lock);
+
+	if (!drain)
+		return;
+
+	while (true) {
+		s64 count;
+
+		spin_lock_irq(q->queue_lock);
+		count = percpu_counter_sum(&q->mq_usage_counter);
+		spin_unlock_irq(q->queue_lock);
+
+		if (count == 0)
+			break;
+		blk_mq_run_queues(q, false);
+		msleep(10);
+	}
+}
+
+static void blk_mq_unfreeze_queue(struct request_queue *q)
+{
+	bool wake = false;
+
+	spin_lock_irq(q->queue_lock);
+	if (!--q->bypass_depth) {
+		queue_flag_clear(QUEUE_FLAG_BYPASS, q);
+		wake = true;
+	}
+	WARN_ON_ONCE(q->bypass_depth < 0);
+	spin_unlock_irq(q->queue_lock);
+	if (wake)
+		wake_up_all(&q->mq_freeze_wq);
+}
+
+bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
+{
+	return blk_mq_has_free_tags(hctx->tags);
+}
+EXPORT_SYMBOL(blk_mq_can_queue);
+
+static void blk_mq_rq_ctx_init(struct blk_mq_ctx *ctx, struct request *rq,
+			       unsigned int rw_flags)
+{
+	rq->mq_ctx = ctx;
+	rq->cmd_flags = rw_flags;
+	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
+}
+
+static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
+					      gfp_t gfp, bool reserved)
+{
+	return blk_mq_alloc_rq(hctx, gfp, reserved);
+}
+
+static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
+						   int rw, gfp_t gfp,
+						   bool reserved)
+{
+	struct request *rq;
+
+	do {
+		struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
+		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved);
+		if (rq) {
+			blk_mq_rq_ctx_init(ctx, rq, rw);
+			break;
+		} else if (!(gfp & __GFP_WAIT))
+			break;
+
+		blk_mq_put_ctx(ctx);
+		__blk_mq_run_hw_queue(hctx);
+		blk_mq_wait_for_tags(hctx->tags);
+	} while (1);
+
+	return rq;
+}
+
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp)
+{
+	struct request *rq;
+
+	if (blk_mq_queue_enter(q))
+		return NULL;
+
+	rq = blk_mq_alloc_request_pinned(q, rw, gfp, false);
+	blk_mq_put_ctx(rq->mq_ctx);
+	return rq;
+}
+
+struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw,
+					      gfp_t gfp)
+{
+	struct request *rq;
+
+	if (blk_mq_queue_enter(q))
+		return NULL;
+
+	rq = blk_mq_alloc_request_pinned(q, rw, gfp, true);
+	blk_mq_put_ctx(rq->mq_ctx);
+	return rq;
+}
+EXPORT_SYMBOL(blk_mq_alloc_reserved_request);
+
+/*
+ * Re-init and set pdu, if we have it
+ */
+static void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq)
+{
+	blk_rq_init(hctx->queue, rq);
+
+	if (hctx->cmd_size)
+		rq->special = blk_mq_rq_to_pdu(rq);
+}
+
+static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
+				  struct blk_mq_ctx *ctx, struct request *rq)
+{
+	const int tag = rq->tag;
+	struct request_queue *q = rq->q;
+
+	blk_mq_rq_init(hctx, rq);
+	blk_mq_put_tag(hctx->tags, tag);
+
+	blk_mq_queue_exit(q);
+}
+
+void blk_mq_free_request(struct request *rq)
+{
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
+	struct blk_mq_hw_ctx *hctx;
+	struct request_queue *q = rq->q;
+
+	ctx->rq_completed[rq_is_sync(rq)]++;
+
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+	__blk_mq_free_request(hctx, ctx, rq);
+}
+
+static void blk_mq_bio_endio(struct request *rq, struct bio *bio, int error)
+{
+	if (error)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		error = -EIO;
+
+	if (unlikely(rq->cmd_flags & REQ_QUIET))
+		set_bit(BIO_QUIET, &bio->bi_flags);
+
+	/* don't actually finish bio if it's part of flush sequence */
+	if (!(rq->cmd_flags & REQ_FLUSH_SEQ))
+		bio_endio(bio, error);
+}
+
+void blk_mq_complete_request(struct request *rq, int error)
+{
+	struct bio *bio = rq->bio;
+	unsigned int bytes = 0;
+
+	trace_block_rq_complete(rq->q, rq);
+
+	while (bio) {
+		struct bio *next = bio->bi_next;
+
+		bio->bi_next = NULL;
+		bytes += bio->bi_size;
+		blk_mq_bio_endio(rq, bio, error);
+		bio = next;
+	}
+
+	blk_account_io_completion(rq, bytes);
+
+	if (rq->end_io)
+		rq->end_io(rq, error);
+	else
+		blk_mq_free_request(rq);
+
+	blk_account_io_done(rq);
+}
+
+void __blk_mq_end_io(struct request *rq, int error)
+{
+	if (!blk_mark_rq_complete(rq))
+		blk_mq_complete_request(rq, error);
+}
+
+#if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+
+/*
+ * Called with interrupts disabled.
+ */
+static void ipi_end_io(void *data)
+{
+	struct llist_head *list = &per_cpu(ipi_lists, smp_processor_id());
+	struct llist_node *entry, *next;
+	struct request *rq;
+
+	entry = llist_del_all(list);
+
+	while (entry) {
+		next = entry->next;
+		rq = llist_entry(entry, struct request, ll_list);
+		__blk_mq_end_io(rq, rq->errors);
+		entry = next;
+	}
+}
+
+static int ipi_remote_cpu(struct blk_mq_ctx *ctx, const int cpu,
+			  struct request *rq, const int error)
+{
+	struct call_single_data *data = &rq->csd;
+
+	rq->errors = error;
+	rq->ll_list.next = NULL;
+
+	/*
+	 * If the list is non-empty, an existing IPI must already
+	 * be "in flight". If that is the case, we need not schedule
+	 * a new one.
+	 */
+	if (llist_add(&rq->ll_list, &per_cpu(ipi_lists, ctx->cpu))) {
+		data->func = ipi_end_io;
+		data->flags = 0;
+		__smp_call_function_single(ctx->cpu, data, 0);
+	}
+
+	return true;
+}
+#else /* CONFIG_SMP && CONFIG_USE_GENERIC_SMP_HELPERS */
+static int ipi_remote_cpu(struct blk_mq_ctx *ctx, const int cpu,
+			  struct request *rq, const int error)
+{
+	return false;
+}
+#endif
+
+/*
+ * End IO on this request on a multiqueue enabled driver. We'll either do
+ * it directly inline, or punt to a local IPI handler on the matching
+ * remote CPU.
+ */
+void blk_mq_end_io(struct request *rq, int error)
+{
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
+	int cpu;
+
+	if (!ctx->ipi_redirect)
+		return __blk_mq_end_io(rq, error);
+
+	cpu = get_cpu();
+
+	if (cpu == ctx->cpu || !cpu_online(ctx->cpu) ||
+	    !ipi_remote_cpu(ctx, cpu, rq, error))
+		__blk_mq_end_io(rq, error);
+
+	put_cpu();
+}
+EXPORT_SYMBOL(blk_mq_end_io);
+
+static void blk_mq_start_request(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+
+	trace_block_rq_issue(q, rq);
+
+	/*
+	 * Just mark start time and set the started bit. Due to memory
+	 * ordering, we know we'll see the correct deadline as long as
+	 * REQ_ATOMIC_STARTED is seen.
+	 */
+	rq->deadline = jiffies + q->rq_timeout;
+	set_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
+}
+
+static void blk_mq_requeue_request(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+
+	trace_block_rq_requeue(q, rq);
+	clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
+}
+
+struct blk_mq_timeout_data {
+	struct blk_mq_hw_ctx *hctx;
+	unsigned long *next;
+	unsigned int *next_set;
+};
+
+static void blk_mq_timeout_check(void *__data, unsigned long *free_tags)
+{
+	struct blk_mq_timeout_data *data = __data;
+	struct blk_mq_hw_ctx *hctx = data->hctx;
+	unsigned int tag;
+
+	 /* It may not be in flight yet (this is where
+	 * the REQ_ATOMIC_STARTED flag comes in). The requests are
+	 * statically allocated, so we know it's always safe to access the
+	 * memory associated with a bit offset into ->rqs[].
+	 */
+	tag = 0;
+	do {
+		struct request *rq;
+
+		tag = find_next_zero_bit(free_tags, hctx->queue_depth, tag);
+		if (tag >= hctx->queue_depth)
+			break;
+
+		rq = hctx->rqs[tag++];
+
+		if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
+			continue;
+
+		blk_rq_check_expired(rq, data->next, data->next_set);
+	} while (1);
+}
+
+static void blk_mq_hw_ctx_check_timeout(struct blk_mq_hw_ctx *hctx,
+					unsigned long *next,
+					unsigned int *next_set)
+{
+	struct blk_mq_timeout_data data = {
+		.hctx		= hctx,
+		.next		= next,
+		.next_set	= next_set,
+	};
+
+	/*
+	 * Ask the tagging code to iterate busy requests, so we can
+	 * check them for timeout.
+	 */
+	blk_mq_tag_busy_iter(hctx->tags, blk_mq_timeout_check, &data);
+}
+
+static void blk_mq_rq_timer(unsigned long data)
+{
+	struct request_queue *q = (struct request_queue *) data;
+	struct blk_mq_hw_ctx *hctx;
+	unsigned long next = 0;
+	int i, next_set = 0;
+
+	queue_for_each_hw_ctx(q, hctx, i)
+		blk_mq_hw_ctx_check_timeout(hctx, &next, &next_set);
+
+	if (next_set)
+		mod_timer(&q->timeout, round_jiffies_up(next));
+}
+
+/*
+ * Reverse check our software queue for entries that we could potentially
+ * merge with. Currently includes a hand-wavy stop count of 8, to not spend
+ * too much time checking for merges.
+ */
+static bool blk_mq_attempt_merge(struct request_queue *q,
+				 struct blk_mq_ctx *ctx, struct bio *bio)
+{
+	struct request *rq;
+	int checked = 8;
+
+	list_for_each_entry_reverse(rq, &ctx->rq_list, queuelist) {
+		int el_ret;
+
+		if (!checked--)
+			break;
+
+		if (!blk_rq_merge_ok(rq, bio))
+			continue;
+
+		el_ret = blk_try_merge(rq, bio);
+		if (el_ret == ELEVATOR_BACK_MERGE) {
+			if (bio_attempt_back_merge(q, rq, bio)) {
+				ctx->rq_merged++;
+				return true;
+			}
+			break;
+		} else if (el_ret == ELEVATOR_FRONT_MERGE) {
+			if (bio_attempt_front_merge(q, rq, bio)) {
+				ctx->rq_merged++;
+				return true;
+			}
+			break;
+		}
+	}
+
+	return false;
+}
+
+void blk_mq_add_timer(struct request *rq)
+{
+	__blk_add_timer(rq, NULL);
+}
+
+/*
+ * Run this hardware queue, pulling any software queues mapped to it in.
+ * Note that this function currently has various problems around ordering
+ * of IO. In particular, we'd like FIFO behaviour on handling existing
+ * items on the hctx->dispatch list. Ignore that for now.
+ */
+static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
+{
+	struct request_queue *q = hctx->queue;
+	struct blk_mq_ctx *ctx;
+	struct request *rq;
+	LIST_HEAD(rq_list);
+	int bit, queued;
+
+	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->flags)))
+		return;
+
+	hctx->run++;
+
+	/*
+	 * Touch any software queue that has pending entries.
+	 */
+	for_each_set_bit(bit, hctx->ctx_map, hctx->nr_ctx) {
+		clear_bit(bit, hctx->ctx_map);
+		ctx = hctx->ctxs[bit];
+		BUG_ON(bit != ctx->index_hw);
+
+		spin_lock(&ctx->lock);
+		list_splice_tail_init(&ctx->rq_list, &rq_list);
+		spin_unlock(&ctx->lock);
+	}
+
+	/*
+	 * If we have previous entries on our dispatch list, grab them
+	 * and stuff them at the front for more fair dispatch.
+	 */
+	if (!list_empty_careful(&hctx->dispatch)) {
+		spin_lock(&hctx->lock);
+		if (!list_empty(&hctx->dispatch))
+			list_splice_init(&hctx->dispatch, &rq_list);
+		spin_unlock(&hctx->lock);
+	}
+
+	/*
+	 * Delete and return all entries from our dispatch list
+	 */
+	queued = 0;
+
+	/*
+	 * Now process all the entries, sending them to the driver.
+	 */
+	while (!list_empty(&rq_list)) {
+		int ret;
+
+		rq = list_first_entry(&rq_list, struct request, queuelist);
+		list_del_init(&rq->queuelist);
+		blk_mq_start_request(rq);
+
+		/*
+		 * Last request in the series. Flag it as such, this
+		 * enables drivers to know when IO should be kicked off,
+		 * if they don't do it on a per-request basis.
+		 *
+		 * Note: the flag isn't the only condition drivers
+		 * should do kick off. If drive is busy, the last
+		 * request might not have the bit set.
+		 */
+		if (list_empty(&rq_list))
+			rq->cmd_flags |= REQ_END;
+
+		ret = q->mq_ops->queue_rq(hctx, rq);
+		switch (ret) {
+		case BLK_MQ_RQ_QUEUE_OK:
+			queued++;
+			continue;
+		case BLK_MQ_RQ_QUEUE_BUSY:
+			/*
+			 * FIXME: we should have a mechanism to stop the queue
+			 * like blk_stop_queue, otherwise we will waste cpu
+			 * time
+			 */
+			list_add(&rq->queuelist, &rq_list);
+			blk_mq_requeue_request(rq);
+			break;
+		default:
+			pr_err("blk-mq: bad return on queue: %d\n", ret);
+			rq->errors = -EIO;
+		case BLK_MQ_RQ_QUEUE_ERROR:
+			blk_mq_end_io(rq, rq->errors);
+			break;
+		}
+
+		if (ret == BLK_MQ_RQ_QUEUE_BUSY)
+			break;
+	}
+
+	if (!queued)
+		hctx->dispatched[0]++;
+	else if (queued < (1 << (BLK_MQ_MAX_DISPATCH_ORDER - 1)))
+		hctx->dispatched[ilog2(queued) + 1]++;
+
+	/*
+	 * Any items that need requeuing? Stuff them into hctx->dispatch,
+	 * that is where we will continue on next queue run.
+	 */
+	if (!list_empty(&rq_list)) {
+		spin_lock(&hctx->lock);
+		list_splice(&rq_list, &hctx->dispatch);
+		spin_unlock(&hctx->lock);
+	}
+}
+
+void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
+{
+	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->flags)))
+		return;
+
+	if (!async)
+		__blk_mq_run_hw_queue(hctx);
+	else {
+		struct request_queue *q = hctx->queue;
+
+		kblockd_schedule_delayed_work(q, &hctx->delayed_work, 0);
+	}
+}
+
+void blk_mq_run_queues(struct request_queue *q, bool async)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if ((!blk_mq_hctx_has_pending(hctx) &&
+		    list_empty_careful(&hctx->dispatch)) ||
+		    test_bit(BLK_MQ_S_STOPPED, &hctx->flags))
+			continue;
+
+		blk_mq_run_hw_queue(hctx, async);
+	}
+}
+EXPORT_SYMBOL(blk_mq_run_queues);
+
+void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx)
+{
+	cancel_delayed_work(&hctx->delayed_work);
+	set_bit(BLK_MQ_S_STOPPED, &hctx->state);
+}
+EXPORT_SYMBOL(blk_mq_stop_hw_queue);
+
+void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
+{
+	clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+	__blk_mq_run_hw_queue(hctx);
+}
+EXPORT_SYMBOL(blk_mq_start_hw_queue);
+
+void blk_mq_start_stopped_hw_queues(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if (!test_bit(BLK_MQ_S_STOPPED, &hctx->state))
+			continue;
+
+		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+		blk_mq_run_hw_queue(hctx, true);
+	}
+}
+EXPORT_SYMBOL(blk_mq_start_stopped_hw_queues);
+
+static void blk_mq_work_fn(struct work_struct *work)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	hctx = container_of(work, struct blk_mq_hw_ctx, delayed_work.work);
+	__blk_mq_run_hw_queue(hctx);
+}
+
+static void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx,
+				    struct request *rq)
+{
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
+
+	list_add_tail(&rq->queuelist, &ctx->rq_list);
+	blk_mq_hctx_mark_pending(hctx, ctx);
+
+	/*
+	 * We do this early, to ensure we are on the right CPU.
+	 */
+	blk_mq_add_timer(rq);
+}
+
+void blk_mq_insert_request(struct request_queue *q, struct request *rq,
+			   bool run_queue)
+{
+	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_ctx *ctx, *current_ctx;
+
+	ctx = rq->mq_ctx;
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+	if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
+		blk_insert_flush(rq);
+	} else {
+		current_ctx = blk_mq_get_ctx(q);
+
+		if (!cpu_online(ctx->cpu)) {
+			ctx = current_ctx;
+			hctx = q->mq_ops->map_queue(q, ctx->cpu);
+			rq->mq_ctx = ctx;
+		}
+		spin_lock(&ctx->lock);
+		__blk_mq_insert_request(hctx, rq);
+		spin_unlock(&ctx->lock);
+
+		blk_mq_put_ctx(current_ctx);
+	}
+
+	if (run_queue)
+		__blk_mq_run_hw_queue(hctx);
+}
+EXPORT_SYMBOL(blk_mq_insert_request);
+
+/*
+ * This is a special version of blk_mq_insert_request to bypass FLUSH request
+ * check. Should only be used internally.
+ */
+void blk_mq_run_request(struct request *rq, bool run_queue, bool async)
+{
+	struct request_queue *q = rq->q;
+	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_ctx *ctx, *current_ctx;
+
+	current_ctx = blk_mq_get_ctx(q);
+
+	ctx = rq->mq_ctx;
+	if (!cpu_online(ctx->cpu)) {
+		ctx = current_ctx;
+		rq->mq_ctx = ctx;
+	}
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+	/* ctx->cpu might be offline */
+	spin_lock(&ctx->lock);
+	__blk_mq_insert_request(hctx, rq);
+	spin_unlock(&ctx->lock);
+
+	blk_mq_put_ctx(current_ctx);
+
+	if (run_queue)
+		blk_mq_run_hw_queue(hctx, async);
+}
+
+static void blk_mq_insert_requests(struct request_queue *q,
+				     struct blk_mq_ctx *ctx,
+				     struct list_head *list,
+				     int depth,
+				     bool from_schedule)
+
+{
+	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_ctx *current_ctx;
+
+	trace_block_unplug(q, depth, !from_schedule);
+
+	current_ctx = blk_mq_get_ctx(q);
+
+	if (!cpu_online(ctx->cpu))
+		ctx = current_ctx;
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+	/*
+	 * preemption doesn't flush plug list, so it's possible ctx->cpu is
+	 * offline now
+	 */
+	spin_lock(&ctx->lock);
+	while (!list_empty(list)) {
+		struct request *rq;
+
+		rq = list_first_entry(list, struct request, queuelist);
+		list_del_init(&rq->queuelist);
+		rq->mq_ctx = ctx;
+		__blk_mq_insert_request(hctx, rq);
+	}
+	spin_unlock(&ctx->lock);
+
+	blk_mq_put_ctx(current_ctx);
+
+	blk_mq_run_hw_queue(hctx, from_schedule);
+}
+
+static int plug_ctx_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct request *rqa = container_of(a, struct request, queuelist);
+	struct request *rqb = container_of(b, struct request, queuelist);
+
+	return !(rqa->mq_ctx < rqb->mq_ctx ||
+		 (rqa->mq_ctx == rqb->mq_ctx &&
+		  blk_rq_pos(rqa) < blk_rq_pos(rqb)));
+}
+
+void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
+{
+	struct blk_mq_ctx *this_ctx;
+	struct request_queue *this_q;
+	struct request *rq;
+	LIST_HEAD(list);
+	LIST_HEAD(ctx_list);
+	unsigned int depth;
+
+	list_splice_init(&plug->mq_list, &list);
+
+	list_sort(NULL, &list, plug_ctx_cmp);
+
+	this_q = NULL;
+	this_ctx = NULL;
+	depth = 0;
+
+	while (!list_empty(&list)) {
+		rq = list_entry_rq(list.next);
+		list_del_init(&rq->queuelist);
+		BUG_ON(!rq->q);
+		if (rq->mq_ctx != this_ctx) {
+			if (this_ctx) {
+				blk_mq_insert_requests(this_q, this_ctx,
+							&ctx_list, depth,
+							from_schedule);
+			}
+
+			this_ctx = rq->mq_ctx;
+			this_q = rq->q;
+			depth = 0;
+		}
+
+		depth++;
+		list_add_tail(&rq->queuelist, &ctx_list);
+	}
+
+	/*
+	 * If 'this_ctx' is set, we know we have entries to complete
+	 * on 'ctx_list'. Do those.
+	 */
+	if (this_ctx) {
+		blk_mq_insert_requests(this_q, this_ctx, &ctx_list, depth,
+				       from_schedule);
+	}
+}
+
+static void blk_mq_bio_to_request(struct request *rq, struct bio *bio)
+{
+	init_request_from_bio(rq, bio);
+	blk_account_io_start(rq, 1);
+}
+
+static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_ctx *ctx;
+	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
+	int rw = bio_data_dir(bio);
+	struct request *rq;
+	unsigned int use_plug, request_count = 0;
+
+	/*
+	 * If we have multiple hardware queues, just go directly to
+	 * one of those for sync IO.
+	 */
+	use_plug = !is_flush_fua && ((q->nr_hw_queues == 1) || !is_sync);
+
+	blk_queue_bounce(q, &bio);
+
+	if (use_plug && blk_attempt_plug_merge(q, bio, &request_count))
+		return;
+
+	if (blk_mq_queue_enter(q)) {
+		bio_endio(bio, -EIO);
+		return;
+	}
+
+	ctx = blk_mq_get_ctx(q);
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+	trace_block_getrq(q, bio, rw);
+	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false);
+	if (likely(rq))
+		blk_mq_rq_ctx_init(ctx, rq, rw);
+	else {
+		blk_mq_put_ctx(ctx);
+		trace_block_sleeprq(q, bio, rw);
+		rq = blk_mq_alloc_request_pinned(q, rw, __GFP_WAIT|GFP_ATOMIC,
+							false);
+		ctx = rq->mq_ctx;
+		hctx = q->mq_ops->map_queue(q, ctx->cpu);
+	}
+
+	hctx->queued++;
+
+	if (unlikely(is_flush_fua)) {
+		blk_mq_bio_to_request(rq, bio);
+		blk_mq_put_ctx(ctx);
+		blk_insert_flush(rq);
+		goto run_queue;
+	}
+
+	/*
+	 * A task plug currently exists. Since this is completely lockless,
+	 * utilize that to temporarily store requests until the task is
+	 * either done or scheduled away.
+	 */
+	if (use_plug) {
+		struct blk_plug *plug = current->plug;
+
+		if (plug) {
+			blk_mq_bio_to_request(rq, bio);
+			if (list_empty(&plug->list))
+				trace_block_plug(q);
+			else if (request_count >= BLK_MAX_REQUEST_COUNT) {
+				blk_flush_plug_list(plug, false);
+				trace_block_plug(q);
+			}
+			list_add_tail(&rq->queuelist, &plug->mq_list);
+			blk_mq_put_ctx(ctx);
+			return;
+		}
+	}
+
+	spin_lock(&ctx->lock);
+
+	if ((hctx->flags & BLK_MQ_F_SHOULD_MERGE) &&
+	    blk_mq_attempt_merge(q, ctx, bio))
+		__blk_mq_free_request(hctx, ctx, rq);
+	else {
+		blk_mq_bio_to_request(rq, bio);
+		__blk_mq_insert_request(hctx, rq);
+	}
+
+	spin_unlock(&ctx->lock);
+	blk_mq_put_ctx(ctx);
+
+	/*
+	 * For a SYNC request, send it to the hardware immediately. For an
+	 * ASYNC request, just ensure that we run it later on. The latter
+	 * allows for merging opportunities and more efficient dispatching.
+	 */
+run_queue:
+	blk_mq_run_hw_queue(hctx, !is_sync || is_flush_fua);
+}
+
+/*
+ * Default mapping to a software queue, since we use one per CPU.
+ */
+struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q, const int cpu)
+{
+	return q->queue_hw_ctx[q->mq_map[cpu]];
+}
+EXPORT_SYMBOL(blk_mq_map_queue);
+
+struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_reg *reg,
+						   unsigned int hctx_index)
+{
+	return kmalloc_node(sizeof(struct blk_mq_hw_ctx),
+				GFP_KERNEL | __GFP_ZERO, reg->numa_node);
+}
+EXPORT_SYMBOL(blk_mq_alloc_single_hw_queue);
+
+void blk_mq_free_single_hw_queue(struct blk_mq_hw_ctx *hctx,
+				 unsigned int hctx_index)
+{
+	kfree(hctx);
+}
+EXPORT_SYMBOL(blk_mq_free_single_hw_queue);
+
+static void blk_mq_hctx_notify(void *data, unsigned long action,
+			       unsigned int cpu)
+{
+	struct blk_mq_hw_ctx *hctx = data;
+	struct blk_mq_ctx *ctx;
+	LIST_HEAD(tmp);
+
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
+		return;
+
+	/*
+	 * Move ctx entries to new CPU, if this one is going away.
+	 */
+	ctx = __blk_mq_get_ctx(hctx->queue, cpu);
+
+	spin_lock(&ctx->lock);
+	if (!list_empty(&ctx->rq_list)) {
+		list_splice_init(&ctx->rq_list, &tmp);
+		clear_bit(ctx->index_hw, hctx->ctx_map);
+	}
+	spin_unlock(&ctx->lock);
+
+	if (list_empty(&tmp))
+		return;
+
+	ctx = blk_mq_get_ctx(hctx->queue);
+	spin_lock(&ctx->lock);
+
+	while (!list_empty(&tmp)) {
+		struct request *rq;
+
+		rq = list_first_entry(&tmp, struct request, queuelist);
+		rq->mq_ctx = ctx;
+		list_move_tail(&rq->queuelist, &ctx->rq_list);
+	}
+
+	blk_mq_hctx_mark_pending(hctx, ctx);
+
+	spin_unlock(&ctx->lock);
+	blk_mq_put_ctx(ctx);
+}
+
+static void blk_mq_init_hw_commands(struct blk_mq_hw_ctx *hctx,
+				    void (*init)(void *, struct blk_mq_hw_ctx *,
+					struct request *, unsigned int),
+				    void *data)
+{
+	unsigned int i;
+
+	for (i = 0; i < hctx->queue_depth; i++) {
+		struct request *rq = hctx->rqs[i];
+
+		init(data, hctx, rq, i);
+	}
+}
+
+void blk_mq_init_commands(struct request_queue *q,
+			  void (*init)(void *, struct blk_mq_hw_ctx *,
+					struct request *, unsigned int),
+			  void *data)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
+
+	queue_for_each_hw_ctx(q, hctx, i)
+		blk_mq_init_hw_commands(hctx, init, data);
+}
+EXPORT_SYMBOL(blk_mq_init_commands);
+
+static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx)
+{
+	struct page *page;
+
+	while (!list_empty(&hctx->page_list)) {
+		page = list_first_entry(&hctx->page_list, struct page, list);
+		list_del_init(&page->list);
+		__free_pages(page, page->private);
+	}
+
+	kfree(hctx->rqs);
+
+	if (hctx->tags)
+		blk_mq_free_tags(hctx->tags);
+}
+
+static size_t order_to_size(unsigned int order)
+{
+	size_t ret = PAGE_SIZE;
+
+	while (order--)
+		ret *= 2;
+
+	return ret;
+}
+
+static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
+			      unsigned int reserved_tags, int node)
+{
+	unsigned int i, j, entries_per_page, max_order = 4;
+	size_t rq_size, left;
+
+	INIT_LIST_HEAD(&hctx->page_list);
+
+	hctx->rqs = kmalloc_node(hctx->queue_depth * sizeof(struct request *),
+					GFP_KERNEL, node);
+	if (!hctx->rqs)
+		return -ENOMEM;
+
+	/*
+	 * rq_size is the size of the request plus driver payload, rounded
+	 * to the cacheline size
+	 */
+	rq_size = round_up(sizeof(struct request) + hctx->cmd_size,
+				cache_line_size());
+	left = rq_size * hctx->queue_depth;
+
+	for (i = 0; i < hctx->queue_depth;) {
+		int this_order = max_order;
+		struct page *page;
+		int to_do;
+		void *p;
+
+		while (left < order_to_size(this_order - 1) && this_order)
+			this_order--;
+
+		do {
+			page = alloc_pages_node(node, GFP_KERNEL, this_order);
+			if (page)
+				break;
+			if (!this_order--)
+				break;
+			if (order_to_size(this_order) < rq_size)
+				break;
+		} while (1);
+
+		if (!page)
+			break;
+
+		page->private = this_order;
+		list_add_tail(&page->list, &hctx->page_list);
+
+		p = page_address(page);
+		entries_per_page = order_to_size(this_order) / rq_size;
+		to_do = min(entries_per_page, hctx->queue_depth - i);
+		left -= to_do * rq_size;
+		for (j = 0; j < to_do; j++) {
+			hctx->rqs[i] = p;
+			blk_mq_rq_init(hctx, hctx->rqs[i]);
+			p += rq_size;
+			i++;
+		}
+	}
+
+	if (i < (reserved_tags + BLK_MQ_TAG_MIN))
+		goto err_rq_map;
+	else if (i != hctx->queue_depth) {
+		hctx->queue_depth = i;
+		pr_warn("%s: queue depth set to %u because of low memory\n",
+					__func__, i);
+	}
+
+	hctx->tags = blk_mq_init_tags(hctx->queue_depth, reserved_tags, node);
+	if (!hctx->tags) {
+err_rq_map:
+		blk_mq_free_rq_map(hctx);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int blk_mq_init_hw_queues(struct request_queue *q,
+				 struct blk_mq_reg *reg, void *driver_data)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i, j;
+
+	/*
+	 * Initialize hardware queues
+	 */
+	queue_for_each_hw_ctx(q, hctx, i) {
+		unsigned int num_maps;
+		int node;
+
+		node = hctx->numa_node;
+		if (node == NUMA_NO_NODE)
+			node = hctx->numa_node = reg->numa_node;
+
+		INIT_DELAYED_WORK(&hctx->delayed_work, blk_mq_work_fn);
+		spin_lock_init(&hctx->lock);
+		INIT_LIST_HEAD(&hctx->dispatch);
+		hctx->queue = q;
+		hctx->queue_num = i;
+		hctx->flags = reg->flags;
+		hctx->queue_depth = reg->queue_depth;
+		hctx->cmd_size = reg->cmd_size;
+
+		blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
+						blk_mq_hctx_notify, hctx);
+		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
+
+		if (blk_mq_init_rq_map(hctx, reg->reserved_tags, node))
+			break;
+
+		/*
+		 * Allocate space for all possible cpus to avoid allocation in
+		 * runtime
+		 */
+		hctx->ctxs = kmalloc_node(nr_cpu_ids * sizeof(void *),
+						GFP_KERNEL, node);
+		if (!hctx->ctxs)
+			break;
+
+		num_maps = ALIGN(nr_cpu_ids, BITS_PER_LONG) / BITS_PER_LONG;
+		hctx->ctx_map = kzalloc_node(num_maps * sizeof(unsigned long),
+						GFP_KERNEL, node);
+		if (!hctx->ctx_map)
+			break;
+
+		hctx->nr_ctx_map = num_maps;
+		hctx->nr_ctx = 0;
+
+		if (reg->ops->init_hctx &&
+		    reg->ops->init_hctx(hctx, driver_data, i))
+			break;
+	}
+
+	if (i == q->nr_hw_queues)
+		return 0;
+
+	/*
+	 * Init failed
+	 */
+	queue_for_each_hw_ctx(q, hctx, j) {
+		if (i == j)
+			break;
+
+		if (reg->ops->exit_hctx)
+			reg->ops->exit_hctx(hctx, j);
+
+		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
+		blk_mq_free_rq_map(hctx);
+		kfree(hctx->ctxs);
+	}
+
+	return 1;
+}
+
+static void blk_mq_init_cpu_queues(struct request_queue *q,
+				   unsigned int nr_hw_queues)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i) {
+		struct blk_mq_ctx *__ctx = per_cpu_ptr(q->queue_ctx, i);
+		struct blk_mq_hw_ctx *hctx;
+
+		memset(__ctx, 0, sizeof(*__ctx));
+		__ctx->cpu = i;
+		spin_lock_init(&__ctx->lock);
+		INIT_LIST_HEAD(&__ctx->rq_list);
+		__ctx->queue = q;
+
+		/* If the cpu isn't online, the cpu is mapped to first hctx */
+		hctx = q->mq_ops->map_queue(q, i);
+		hctx->nr_ctx++;
+
+		if (!cpu_online(i))
+			continue;
+
+		/*
+		 * Set local node, IFF we have more than one hw queue. If
+		 * not, we remain on the home node of the device
+		 */
+		if (nr_hw_queues > 1 && hctx->numa_node == NUMA_NO_NODE)
+			hctx->numa_node = cpu_to_node(i);
+	}
+}
+
+static void blk_mq_map_swqueue(struct request_queue *q)
+{
+	unsigned int i;
+	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_ctx *ctx;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		hctx->nr_ctx = 0;
+	}
+
+	/*
+	 * Map software to hardware queues
+	 */
+	queue_for_each_ctx(q, ctx, i) {
+		/* If the cpu isn't online, the cpu is mapped to first hctx */
+		hctx = q->mq_ops->map_queue(q, i);
+		ctx->index_hw = hctx->nr_ctx;
+		hctx->ctxs[hctx->nr_ctx++] = ctx;
+	}
+}
+
+struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
+					void *driver_data)
+{
+	struct blk_mq_hw_ctx **hctxs;
+	struct blk_mq_ctx *ctx;
+	struct request_queue *q;
+	int i;
+
+	if (!reg->nr_hw_queues ||
+	    !reg->ops->queue_rq || !reg->ops->map_queue ||
+	    !reg->ops->alloc_hctx || !reg->ops->free_hctx)
+		return ERR_PTR(-EINVAL);
+
+	if (!reg->queue_depth)
+		reg->queue_depth = BLK_MQ_MAX_DEPTH;
+	else if (reg->queue_depth > BLK_MQ_MAX_DEPTH) {
+		pr_err("blk-mq: queuedepth too large (%u)\n", reg->queue_depth);
+		reg->queue_depth = BLK_MQ_MAX_DEPTH;
+	}
+
+	if (reg->queue_depth < (reg->reserved_tags + BLK_MQ_TAG_MIN))
+		return ERR_PTR(-EINVAL);
+
+	ctx = alloc_percpu(struct blk_mq_ctx);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	hctxs = kmalloc_node(reg->nr_hw_queues * sizeof(*hctxs), GFP_KERNEL,
+			reg->numa_node);
+
+	if (!hctxs)
+		goto err_percpu;
+
+	for (i = 0; i < reg->nr_hw_queues; i++) {
+		hctxs[i] = reg->ops->alloc_hctx(reg, i);
+		if (!hctxs[i])
+			goto err_hctxs;
+
+		hctxs[i]->numa_node = NUMA_NO_NODE;
+		hctxs[i]->queue_num = i;
+	}
+
+	q = blk_alloc_queue_node(GFP_KERNEL, reg->numa_node);
+	if (!q)
+		goto err_hctxs;
+
+	q->mq_map = blk_mq_make_queue_map(reg);
+	if (!q->mq_map)
+		goto err_map;
+
+	setup_timer(&q->timeout, blk_mq_rq_timer, (unsigned long) q);
+	blk_queue_rq_timeout(q, 30000);
+
+	q->nr_queues = nr_cpu_ids;
+	q->nr_hw_queues = reg->nr_hw_queues;
+
+	q->queue_ctx = ctx;
+	q->queue_hw_ctx = hctxs;
+
+	q->mq_ops = reg->ops;
+
+	blk_queue_make_request(q, blk_mq_make_request);
+	blk_queue_rq_timed_out(q, reg->ops->timeout);
+	if (reg->timeout)
+		blk_queue_rq_timeout(q, reg->timeout);
+
+	blk_mq_init_flush(q);
+	blk_mq_init_cpu_queues(q, reg->nr_hw_queues);
+
+	if (blk_mq_init_hw_queues(q, reg, driver_data))
+		goto err_hw;
+
+	blk_mq_map_swqueue(q);
+
+	mutex_lock(&all_q_mutex);
+	list_add_tail(&q->all_q_node, &all_q_list);
+	mutex_unlock(&all_q_mutex);
+
+	return q;
+err_hw:
+	kfree(q->mq_map);
+err_map:
+	blk_cleanup_queue(q);
+err_hctxs:
+	for (i = 0; i < reg->nr_hw_queues; i++) {
+		if (!hctxs[i])
+			break;
+		reg->ops->free_hctx(hctxs[i], i);
+	}
+	kfree(hctxs);
+err_percpu:
+	free_percpu(ctx);
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL(blk_mq_init_queue);
+
+void blk_mq_free_queue(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		cancel_delayed_work_sync(&hctx->delayed_work);
+		kfree(hctx->ctx_map);
+		kfree(hctx->ctxs);
+		blk_mq_free_rq_map(hctx);
+		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
+		if (q->mq_ops->exit_hctx)
+			q->mq_ops->exit_hctx(hctx, i);
+		q->mq_ops->free_hctx(hctx, i);
+	}
+
+	free_percpu(q->queue_ctx);
+	kfree(q->queue_hw_ctx);
+	kfree(q->mq_map);
+
+	q->queue_ctx = NULL;
+	q->queue_hw_ctx = NULL;
+	q->mq_map = NULL;
+
+	mutex_lock(&all_q_mutex);
+	list_del_init(&q->all_q_node);
+	mutex_unlock(&all_q_mutex);
+}
+EXPORT_SYMBOL(blk_mq_free_queue);
+
+/* Basically redo blk_mq_init_queue with queue frozen */
+static void __cpuinit blk_mq_queue_reinit(struct request_queue *q)
+{
+	blk_mq_freeze_queue(q);
+
+	blk_mq_update_queue_map(q->mq_map, q->nr_hw_queues);
+
+	/*
+	 * redo blk_mq_init_cpu_queues and blk_mq_init_hw_queues. FIXME: maybe
+	 * we should change hctx numa_node according to new topology (this
+	 * involves free and re-allocate memory, worthy doing?)
+	 */
+
+	blk_mq_map_swqueue(q);
+
+	blk_mq_unfreeze_queue(q);
+}
+
+static int __cpuinit blk_mq_queue_reinit_notify(struct notifier_block *nb,
+		unsigned long action, void *hcpu)
+{
+	struct request_queue *q;
+
+	/*
+	 * Before new mapping is established, hotadded cpu might already start
+	 * handling requests. This doesn't break anything as we map offline
+	 * CPUs to first hardware queue. We will re-init queue below to get
+	 * optimal settings.
+	 */
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN &&
+	    action != CPU_ONLINE && action != CPU_ONLINE_FROZEN)
+		return NOTIFY_OK;
+
+	mutex_lock(&all_q_mutex);
+	list_for_each_entry(q, &all_q_list, all_q_node)
+		blk_mq_queue_reinit(q);
+	mutex_unlock(&all_q_mutex);
+	return NOTIFY_OK;
+}
+
+static int __init blk_mq_init(void)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i)
+		init_llist_head(&per_cpu(ipi_lists, i));
+
+	blk_mq_cpu_init();
+
+	/* Must be called after percpu_counter_hotcpu_callback() */
+	hotcpu_notifier(blk_mq_queue_reinit_notify, -10);
+
+	return 0;
+}
+subsys_initcall(blk_mq_init);
diff --git a/block/blk-mq.h b/block/blk-mq.h
new file mode 100644
index 0000000..52bf1f9
--- /dev/null
+++ b/block/blk-mq.h
@@ -0,0 +1,52 @@
+#ifndef INT_BLK_MQ_H
+#define INT_BLK_MQ_H
+
+struct blk_mq_ctx {
+	struct {
+		spinlock_t		lock;
+		struct list_head	rq_list;
+	}  ____cacheline_aligned_in_smp;
+
+	unsigned int		cpu;
+	unsigned int		index_hw;
+	unsigned int		ipi_redirect;
+
+	/* incremented at dispatch time */
+	unsigned long		rq_dispatched[2];
+	unsigned long		rq_merged;
+
+	/* incremented at completion time */
+	unsigned long		____cacheline_aligned_in_smp rq_completed[2];
+
+	struct request_queue	*queue;
+	struct kobject		kobj;
+};
+
+void __blk_mq_end_io(struct request *rq, int error);
+void blk_mq_complete_request(struct request *rq, int error);
+void blk_mq_run_request(struct request *rq, bool run_queue, bool async);
+void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
+void blk_mq_init_flush(struct request_queue *q);
+
+/*
+ * CPU hotplug helpers
+ */
+struct blk_mq_cpu_notifier;
+void blk_mq_init_cpu_notifier(struct blk_mq_cpu_notifier *notifier,
+			      void (*fn)(void *, unsigned long, unsigned int),
+			      void *data);
+void blk_mq_register_cpu_notifier(struct blk_mq_cpu_notifier *notifier);
+void blk_mq_unregister_cpu_notifier(struct blk_mq_cpu_notifier *notifier);
+void blk_mq_cpu_init(void);
+DECLARE_PER_CPU(struct llist_head, ipi_lists);
+
+/*
+ * CPU -> queue mappings
+ */
+struct blk_mq_reg;
+extern unsigned int *blk_mq_make_queue_map(struct blk_mq_reg *reg);
+extern int blk_mq_update_queue_map(unsigned int *map, unsigned int nr_queues);
+
+void blk_mq_add_timer(struct request *rq);
+
+#endif
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 3aa5b19..4f8c4d9 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -7,6 +7,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
+#include <linux/blk-mq.h>
 
 #include "blk.h"
 #include "blk-cgroup.h"
@@ -542,6 +543,11 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
+	percpu_counter_destroy(&q->mq_usage_counter);
+
+	if (q->mq_ops)
+		blk_mq_free_queue(q);
+
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
@@ -575,6 +581,7 @@ int blk_register_queue(struct gendisk *disk)
 	 * bypass from queue allocation.
 	 */
 	blk_queue_bypass_end(q);
+	queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
 
 	ret = blk_trace_init_sysfs(dev);
 	if (ret)
@@ -588,6 +595,9 @@ int blk_register_queue(struct gendisk *disk)
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 
+	if (q->mq_ops)
+		blk_mq_register_disk(disk);
+
 	if (!q->request_fn)
 		return 0;
 
@@ -610,6 +620,9 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return;
 
+	if (q->mq_ops)
+		blk_mq_unregister_disk(disk);
+
 	if (q->request_fn)
 		elv_unregister_queue(q);
 
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 65f1035..22846cf 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -7,6 +7,7 @@
 #include <linux/fault-inject.h>
 
 #include "blk.h"
+#include "blk-mq.h"
 
 #ifdef CONFIG_FAIL_IO_TIMEOUT
 
@@ -88,11 +89,18 @@ static void blk_rq_timed_out(struct request *req)
 		ret = q->rq_timed_out_fn(req);
 	switch (ret) {
 	case BLK_EH_HANDLED:
-		__blk_complete_request(req);
+		/* Can we use req->errors here? */
+		if (q->mq_ops)
+			blk_mq_complete_request(req, req->errors);
+		else
+			__blk_complete_request(req);
 		break;
 	case BLK_EH_RESET_TIMER:
 		blk_clear_rq_complete(req);
-		blk_add_timer(req);
+		if (q->mq_ops)
+			blk_mq_add_timer(req);
+		else
+			blk_add_timer(req);
 		break;
 	case BLK_EH_NOT_HANDLED:
 		/*
@@ -108,6 +116,23 @@ static void blk_rq_timed_out(struct request *req)
 	}
 }
 
+void blk_rq_check_expired(struct request *rq, unsigned long *next_timeout,
+			  unsigned int *next_set)
+{
+	if (time_after_eq(jiffies, rq->deadline)) {
+		list_del_init(&rq->timeout_list);
+
+		/*
+		 * Check if we raced with end io completion
+		 */
+		if (!blk_mark_rq_complete(rq))
+			blk_rq_timed_out(rq);
+	} else if (!*next_set || time_after(*next_timeout, rq->deadline)) {
+		*next_timeout = rq->deadline;
+		*next_set = 1;
+	}
+}
+
 void blk_rq_timed_out_timer(unsigned long data)
 {
 	struct request_queue *q = (struct request_queue *) data;
@@ -117,21 +142,8 @@ void blk_rq_timed_out_timer(unsigned long data)
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
-	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list) {
-		if (time_after_eq(jiffies, rq->deadline)) {
-			list_del_init(&rq->timeout_list);
-
-			/*
-			 * Check if we raced with end io completion
-			 */
-			if (blk_mark_rq_complete(rq))
-				continue;
-			blk_rq_timed_out(rq);
-		} else if (!next_set || time_after(next, rq->deadline)) {
-			next = rq->deadline;
-			next_set = 1;
-		}
-	}
+	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list)
+		blk_rq_check_expired(rq, &next, &next_set);
 
 	if (next_set)
 		mod_timer(&q->timeout, round_jiffies_up(next));
@@ -157,15 +169,7 @@ void blk_abort_request(struct request *req)
 }
 EXPORT_SYMBOL_GPL(blk_abort_request);
 
-/**
- * blk_add_timer - Start timeout timer for a single request
- * @req:	request that is about to start running.
- *
- * Notes:
- *    Each request has its own timer, and as it is added to the queue, we
- *    set up the timer. When the request completes, we cancel the timer.
- */
-void blk_add_timer(struct request *req)
+void __blk_add_timer(struct request *req, struct list_head *timeout_list)
 {
 	struct request_queue *q = req->q;
 	unsigned long expiry;
@@ -184,7 +188,8 @@ void blk_add_timer(struct request *req)
 		req->timeout = q->rq_timeout;
 
 	req->deadline = jiffies + req->timeout;
-	list_add_tail(&req->timeout_list, &q->timeout_list);
+	if (timeout_list)
+		list_add_tail(&req->timeout_list, timeout_list);
 
 	/*
 	 * If the timer isn't already pending or this timeout is earlier
@@ -196,5 +201,19 @@ void blk_add_timer(struct request *req)
 	if (!timer_pending(&q->timeout) ||
 	    time_before(expiry, q->timeout.expires))
 		mod_timer(&q->timeout, expiry);
+
+}
+
+/**
+ * blk_add_timer - Start timeout timer for a single request
+ * @req:	request that is about to start running.
+ *
+ * Notes:
+ *    Each request has its own timer, and as it is added to the queue, we
+ *    set up the timer. When the request completes, we cancel the timer.
+ */
+void blk_add_timer(struct request *req)
+{
+	__blk_add_timer(req, &req->q->timeout_list);
 }
 
diff --git a/block/blk.h b/block/blk.h
index e837b8f..c90e1d8 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -10,6 +10,7 @@
 #define BLK_BATCH_REQ	32
 
 extern struct kmem_cache *blk_requestq_cachep;
+extern struct kmem_cache *request_cachep;
 extern struct kobj_type blk_queue_ktype;
 extern struct ida blk_queue_ida;
 
@@ -34,14 +35,30 @@ bool __blk_end_bidi_request(struct request *rq, int error,
 			    unsigned int nr_bytes, unsigned int bidi_bytes);
 
 void blk_rq_timed_out_timer(unsigned long data);
+void blk_rq_check_expired(struct request *rq, unsigned long *next_timeout,
+			  unsigned int *next_set);
+void __blk_add_timer(struct request *req, struct list_head *timeout_list);
 void blk_delete_timer(struct request *);
 void blk_add_timer(struct request *);
 
+
+bool bio_attempt_front_merge(struct request_queue *q, struct request *req,
+			     struct bio *bio);
+bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
+			    struct bio *bio);
+bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
+			    unsigned int *request_count);
+
+void blk_account_io_start(struct request *req, bool new_io);
+void blk_account_io_completion(struct request *req, unsigned int bytes);
+void blk_account_io_done(struct request *req);
+
 /*
  * Internal atomic flags for request handling
  */
 enum rq_atomic_flags {
 	REQ_ATOM_COMPLETE = 0,
+	REQ_ATOM_STARTED,
 };
 
 /*
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ec48bac..4c27754 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -419,6 +419,8 @@ static inline void bio_list_init(struct bio_list *bl)
 	bl->head = bl->tail = NULL;
 }
 
+#define BIO_EMPTY_LIST	{ NULL, NULL }
+
 #define bio_list_for_each(bio, bl) \
 	for (bio = (bl)->head; bio; bio = bio->bi_next)
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
new file mode 100644
index 0000000..746042ff
--- /dev/null
+++ b/include/linux/blk-mq.h
@@ -0,0 +1,182 @@
+#ifndef BLK_MQ_H
+#define BLK_MQ_H
+
+#include <linux/blkdev.h>
+
+struct blk_mq_tags;
+
+struct blk_mq_cpu_notifier {
+	struct list_head list;
+	void *data;
+	void (*notify)(void *data, unsigned long action, unsigned int cpu);
+};
+
+struct blk_mq_hw_ctx {
+	struct {
+		spinlock_t		lock;
+		struct list_head	dispatch;
+	} ____cacheline_aligned_in_smp;
+
+	unsigned long		state;		/* BLK_MQ_S_* flags */
+	struct delayed_work	delayed_work;
+
+	unsigned long		flags;		/* BLK_MQ_F_* flags */
+
+	struct request_queue	*queue;
+	unsigned int		queue_num;
+
+	void			*driver_data;
+
+	unsigned int		nr_ctx;
+	struct blk_mq_ctx	**ctxs;
+	unsigned int 		nr_ctx_map;
+	unsigned long		*ctx_map;
+
+	struct request		**rqs;
+	struct list_head	page_list;
+	struct blk_mq_tags	*tags;
+
+	unsigned long		queued;
+	unsigned long		run;
+#define BLK_MQ_MAX_DISPATCH_ORDER	10
+	unsigned long		dispatched[BLK_MQ_MAX_DISPATCH_ORDER];
+
+	unsigned int		queue_depth;
+	unsigned int		numa_node;
+	unsigned int		cmd_size;	/* per-request extra data */
+
+	struct blk_mq_cpu_notifier	cpu_notifier;
+	struct kobject		kobj;
+};
+
+struct blk_mq_reg {
+	struct blk_mq_ops	*ops;
+	unsigned int		nr_hw_queues;
+	unsigned int		queue_depth;
+	unsigned int		reserved_tags;
+	unsigned int		cmd_size;	/* per-request extra data */
+	int			numa_node;
+	unsigned int		timeout;
+	unsigned int		flags;		/* BLK_MQ_F_* */
+};
+
+typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *);
+typedef struct blk_mq_hw_ctx *(map_queue_fn)(struct request_queue *, const int);
+typedef struct blk_mq_hw_ctx *(alloc_hctx_fn)(struct blk_mq_reg *,unsigned int);
+typedef void (free_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
+typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
+typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
+
+struct blk_mq_ops {
+	/*
+	 * Queue request
+	 */
+	queue_rq_fn		*queue_rq;
+
+	/*
+	 * Map to specific hardware queue
+	 */
+	map_queue_fn		*map_queue;
+
+	/*
+	 * Called on request timeout
+	 */
+	rq_timed_out_fn		*timeout;
+
+	/*
+	 * Override for hctx allocations (should probably go)
+	 */
+	alloc_hctx_fn		*alloc_hctx;
+	free_hctx_fn		*free_hctx;
+
+	/*
+	 * Called when the block layer side of a hardware queue has been
+	 * set up, allowing the driver to allocate/init matching structures.
+	 * Ditto for exit/teardown.
+	 */
+	init_hctx_fn		*init_hctx;
+	exit_hctx_fn		*exit_hctx;
+};
+
+enum {
+	BLK_MQ_RQ_QUEUE_OK	= 0,	/* queued fine */
+	BLK_MQ_RQ_QUEUE_BUSY	= 1,	/* requeue IO for later */
+	BLK_MQ_RQ_QUEUE_ERROR	= 2,	/* end IO with error */
+
+	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
+	BLK_MQ_F_SHOULD_SORT	= 1 << 1,
+	BLK_MQ_F_SHOULD_IPI	= 1 << 2,
+
+	BLK_MQ_S_STOPPED	= 1 << 0,
+
+	BLK_MQ_MAX_DEPTH	= 2048,
+};
+
+struct request_queue *blk_mq_init_queue(struct blk_mq_reg *, void *);
+void blk_mq_free_queue(struct request_queue *);
+int blk_mq_register_disk(struct gendisk *);
+void blk_mq_unregister_disk(struct gendisk *);
+void blk_mq_init_commands(struct request_queue *, void (*init)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
+
+void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
+
+void blk_mq_insert_request(struct request_queue *, struct request *, bool);
+void blk_mq_run_queues(struct request_queue *q, bool async);
+void blk_mq_free_request(struct request *rq);
+bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp);
+struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw, gfp_t gfp);
+struct request *blk_mq_rq_from_tag(struct request_queue *q, unsigned int tag);
+
+struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
+struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_reg *, unsigned int);
+void blk_mq_free_single_hw_queue(struct blk_mq_hw_ctx *, unsigned int);
+
+void blk_mq_end_io(struct request *rq, int error);
+
+void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
+void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
+void blk_mq_start_stopped_hw_queues(struct request_queue *q);
+
+/*
+ * Driver command data is immediately after the request. So subtract request
+ * size to get back to the original request.
+ */
+static inline struct request *blk_mq_rq_from_pdu(void *pdu)
+{
+	return pdu - sizeof(struct request);
+}
+static inline void *blk_mq_rq_to_pdu(struct request *rq)
+{
+	return (void *) rq + sizeof(*rq);
+}
+
+static inline struct request *blk_mq_tag_to_rq(struct blk_mq_hw_ctx *hctx,
+					       unsigned int tag)
+{
+	return hctx->rqs[tag];
+}
+
+#define queue_for_each_hw_ctx(q, hctx, i)				\
+	for ((i) = 0, hctx = (q)->queue_hw_ctx[0];			\
+	     (i) < (q)->nr_hw_queues; (i)++, hctx = (q)->queue_hw_ctx[i])
+
+#define queue_for_each_ctx(q, ctx, i)					\
+	for ((i) = 0, ctx = per_cpu_ptr((q)->queue_ctx, 0);		\
+	     (i) < (q)->nr_queues; (i)++, ctx = per_cpu_ptr(q->queue_ctx, (i)))
+
+#define hctx_for_each_ctx(hctx, ctx, i)					\
+	for ((i) = 0, ctx = (hctx)->ctxs[0];				\
+	     (i) < (hctx)->nr_ctx; (i)++, ctx = (hctx)->ctxs[(i)])
+
+#define blk_ctx_sum(q, sum)						\
+({									\
+	struct blk_mq_ctx *__x;						\
+	unsigned int __ret = 0, __i;					\
+									\
+	queue_for_each_ctx((q), __x, __i)				\
+		__ret += sum;						\
+	__ret;								\
+})
+
+#endif
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c26801e..238ef0e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -178,6 +178,7 @@ enum rq_flag_bits {
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_KERNEL, 		/* direct IO to kernel pages */
 	__REQ_PM,		/* runtime pm request */
+	__REQ_END,		/* last of chain of requests */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -229,5 +230,6 @@ enum rq_flag_bits {
 #define REQ_SECURE		(1ULL << __REQ_SECURE)
 #define REQ_KERNEL		(1ULL << __REQ_KERNEL)
 #define REQ_PM			(1ULL << __REQ_PM)
+#define REQ_END			(1ULL << __REQ_END)
 
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0a8da96..f26ec20f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -8,6 +8,7 @@
 #include <linux/major.h>
 #include <linux/genhd.h>
 #include <linux/list.h>
+#include <linux/llist.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/pagemap.h>
@@ -94,10 +95,17 @@ enum rq_cmd_type_bits {
  * as well!
  */
 struct request {
-	struct list_head queuelist;
-	struct call_single_data csd;
+	union {
+		struct list_head queuelist;
+		struct llist_node ll_list;
+	};
+	union {
+		struct call_single_data csd;
+		struct work_struct mq_flush_data;
+	};
 
 	struct request_queue *q;
+	struct blk_mq_ctx *mq_ctx;
 
 	u64 cmd_flags;
 	enum rq_cmd_type_bits cmd_type;
@@ -213,6 +221,8 @@ struct request_pm_state
 
 #include <linux/elevator.h>
 
+struct blk_queue_ctx;
+
 typedef void (request_fn_proc) (struct request_queue *q);
 typedef void (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
@@ -311,6 +321,18 @@ struct request_queue {
 	dma_drain_needed_fn	*dma_drain_needed;
 	lld_busy_fn		*lld_busy_fn;
 
+	struct blk_mq_ops	*mq_ops;
+
+	unsigned int		*mq_map;
+
+	/* sw queues */
+	struct blk_mq_ctx	*queue_ctx;
+	unsigned int		nr_queues;
+
+	/* hw dispatch queues */
+	struct blk_mq_hw_ctx	**queue_hw_ctx;
+	unsigned int		nr_hw_queues;
+
 	/*
 	 * Dispatch queue sorting
 	 */
@@ -359,6 +381,11 @@ struct request_queue {
 	 */
 	struct kobject kobj;
 
+	/*
+	 * mq queue kobject
+	 */
+	struct kobject mq_kobj;
+
 #ifdef CONFIG_PM_RUNTIME
 	struct device		*dev;
 	int			rpm_status;
@@ -423,7 +450,13 @@ struct request_queue {
 	unsigned long		flush_pending_since;
 	struct list_head	flush_queue[2];
 	struct list_head	flush_data_in_flight;
-	struct request		flush_rq;
+	union {
+		struct request	flush_rq;
+		struct {
+			spinlock_t mq_flush_lock;
+			struct work_struct mq_flush_work;
+		};
+	};
 
 	struct mutex		sysfs_lock;
 
@@ -435,14 +468,14 @@ struct request_queue {
 	struct bsg_class_device bsg_dev;
 #endif
 
-#ifdef CONFIG_BLK_CGROUP
-	struct list_head	all_q_node;
-#endif
 #ifdef CONFIG_BLK_DEV_THROTTLING
 	/* Throttle data */
 	struct throtl_data *td;
 #endif
 	struct rcu_head		rcu_head;
+	wait_queue_head_t	mq_freeze_wq;
+	struct percpu_counter	mq_usage_counter;
+	struct list_head	all_q_node;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
@@ -465,6 +498,7 @@ struct request_queue {
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
 #define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
+#define QUEUE_FLAG_INIT_DONE   20	/* queue is initialized */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -537,6 +571,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
 #define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
 #define blk_queue_bypass(q)	test_bit(QUEUE_FLAG_BYPASS, &(q)->queue_flags)
+#define blk_queue_init_done(q)	test_bit(QUEUE_FLAG_INIT_DONE, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
@@ -1011,6 +1046,7 @@ static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
 struct blk_plug {
 	unsigned long magic; /* detect uninitialized use-cases */
 	struct list_head list; /* requests */
+	struct list_head mq_list; /* blk-mq requests */
 	struct list_head cb_list; /* md requires an unplug callback */
 };
 #define BLK_MAX_REQUEST_COUNT 16
@@ -1048,7 +1084,10 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 {
 	struct blk_plug *plug = tsk->plug;
 
-	return plug && (!list_empty(&plug->list) || !list_empty(&plug->cb_list));
+	return plug &&
+		(!list_empty(&plug->list) ||
+		 !list_empty(&plug->mq_list) ||
+		 !list_empty(&plug->cb_list));
 }
 
 /*
@@ -1323,6 +1362,7 @@ static inline void put_dev_sector(Sector p)
 
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
+int kblockd_schedule_delayed_work(struct request_queue *q, struct delayed_work *dwork, unsigned long delay);
 
 #ifdef CONFIG_BLK_CGROUP
 /*
-- 
1.8.1.2

