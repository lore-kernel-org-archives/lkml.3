Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab3EFWq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:46:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52315 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3EFWqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:46:54 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/33] blk-throttle: dispatch to throtl_data->service_queue.bio_lists[]
Date: Mon,  6 May 2013 15:45:57 -0700
Message-Id: <1367880372-28312-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

throtl_service_queues will eventually form a tree which is anchored at
throtl_data->service_queue and queue bios will climb the tree to the
top service_queue to be executed.

This patch makes the dispatch paths in blk_throtl_dispatch_work_fn()
and blk_throtl_drain() to dispatch bios to
throtl_data->service_queue.bio_lists[] instead of the on-stack
bio_lists.  This will keep the final dispatch to the top level
service_queue share the same mechanism as dispatches through the rest
of the hierarchy.

As bio's should be issued in a sleepable context,
blk_throtl_dispatch_work_fn() transfers all dispatched bio's from the
service_queue bio_lists[] into an onstack one before dropping
queue_lock and issuing the bio's.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6f57f94..154bd63 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -743,7 +743,7 @@ static void tg_update_disptime(struct throtl_grp *tg,
 }
 
 static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw,
-				struct bio_list *bl)
+				struct throtl_service_queue *parent_sq)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
 	struct bio *bio;
@@ -757,13 +757,14 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw,
 	tg->td->nr_queued[rw]--;
 
 	throtl_charge_bio(tg, bio);
-	bio_list_add(bl, bio);
+	bio_list_add(&parent_sq->bio_lists[rw], bio);
 	bio->bi_rw |= REQ_THROTTLED;
 
 	throtl_trim_slice(tg, rw);
 }
 
-static int throtl_dispatch_tg(struct throtl_grp *tg, struct bio_list *bl)
+static int throtl_dispatch_tg(struct throtl_grp *tg,
+			      struct throtl_service_queue *parent_sq)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
 	unsigned int nr_reads = 0, nr_writes = 0;
@@ -776,7 +777,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg, struct bio_list *bl)
 	while ((bio = bio_list_peek(&sq->bio_lists[READ])) &&
 	       tg_may_dispatch(tg, bio, NULL)) {
 
-		tg_dispatch_one_bio(tg, bio_data_dir(bio), bl);
+		tg_dispatch_one_bio(tg, bio_data_dir(bio), parent_sq);
 		nr_reads++;
 
 		if (nr_reads >= max_nr_reads)
@@ -786,7 +787,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg, struct bio_list *bl)
 	while ((bio = bio_list_peek(&sq->bio_lists[WRITE])) &&
 	       tg_may_dispatch(tg, bio, NULL)) {
 
-		tg_dispatch_one_bio(tg, bio_data_dir(bio), bl);
+		tg_dispatch_one_bio(tg, bio_data_dir(bio), parent_sq);
 		nr_writes++;
 
 		if (nr_writes >= max_nr_writes)
@@ -796,8 +797,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg, struct bio_list *bl)
 	return nr_reads + nr_writes;
 }
 
-static int throtl_select_dispatch(struct throtl_service_queue *parent_sq,
-				  struct bio_list *bl)
+static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 {
 	unsigned int nr_disp = 0;
 
@@ -813,7 +813,7 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq,
 
 		throtl_dequeue_tg(tg, parent_sq);
 
-		nr_disp += throtl_dispatch_tg(tg, bl);
+		nr_disp += throtl_dispatch_tg(tg, parent_sq);
 
 		if (sq->nr_queued[0] || sq->nr_queued[1])
 			tg_update_disptime(tg, parent_sq);
@@ -830,11 +830,13 @@ void blk_throtl_dispatch_work_fn(struct work_struct *work)
 {
 	struct throtl_data *td = container_of(to_delayed_work(work),
 					      struct throtl_data, dispatch_work);
+	struct throtl_service_queue *sq = &td->service_queue;
 	struct request_queue *q = td->queue;
 	unsigned int nr_disp = 0;
 	struct bio_list bio_list_on_stack;
 	struct bio *bio;
 	struct blk_plug plug;
+	int rw;
 
 	spin_lock_irq(q->queue_lock);
 
@@ -844,10 +846,15 @@ void blk_throtl_dispatch_work_fn(struct work_struct *work)
 		   td->nr_queued[READ] + td->nr_queued[WRITE],
 		   td->nr_queued[READ], td->nr_queued[WRITE]);
 
-	nr_disp = throtl_select_dispatch(&td->service_queue, &bio_list_on_stack);
+	nr_disp = throtl_select_dispatch(sq);
 
-	if (nr_disp)
+	if (nr_disp) {
+		for (rw = READ; rw <= WRITE; rw++) {
+			bio_list_merge(&bio_list_on_stack, &sq->bio_lists[rw]);
+			bio_list_init(&sq->bio_lists[rw]);
+		}
 		throtl_log(td, "bios disp=%u", nr_disp);
+	}
 
 	throtl_schedule_next_dispatch(td);
 
@@ -1156,27 +1163,26 @@ void blk_throtl_drain(struct request_queue *q)
 	struct throtl_data *td = q->td;
 	struct throtl_service_queue *parent_sq = &td->service_queue;
 	struct throtl_grp *tg;
-	struct bio_list bl;
 	struct bio *bio;
+	int rw;
 
 	queue_lockdep_assert_held(q);
 
-	bio_list_init(&bl);
-
 	while ((tg = throtl_rb_first(parent_sq))) {
 		struct throtl_service_queue *sq = &tg->service_queue;
 
 		throtl_dequeue_tg(tg, parent_sq);
 
 		while ((bio = bio_list_peek(&sq->bio_lists[READ])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio), &bl);
+			tg_dispatch_one_bio(tg, bio_data_dir(bio), parent_sq);
 		while ((bio = bio_list_peek(&sq->bio_lists[WRITE])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio), &bl);
+			tg_dispatch_one_bio(tg, bio_data_dir(bio), parent_sq);
 	}
 	spin_unlock_irq(q->queue_lock);
 
-	while ((bio = bio_list_pop(&bl)))
-		generic_make_request(bio);
+	for (rw = READ; rw <= WRITE; rw++)
+		while ((bio = bio_list_pop(&parent_sq->bio_lists[rw])))
+			generic_make_request(bio);
 
 	spin_lock_irq(q->queue_lock);
 }
-- 
1.8.1.4

