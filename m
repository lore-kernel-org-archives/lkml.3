Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaBXPkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:40:13 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36899 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaBXPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:10 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jens Axboe <axboe@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/11] block: Stop abusing csd.list for fifo_time
Date: Mon, 24 Feb 2014 16:39:52 +0100
Message-Id: <1393256402-16907-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Block layer currently abuses rq->csd.list.next for storing fifo_time.
That is a terrible hack and completely unnecessary as well. Union
achieves the same space saving in a cleaner way.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 block/cfq-iosched.c      | 8 ++++----
 block/deadline-iosched.c | 8 ++++----
 include/linux/blkdev.h   | 1 +
 include/linux/elevator.h | 6 ------
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 744833b..5873e4a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2367,10 +2367,10 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	 * reposition in fifo if next is older than rq
 	 */
 	if (!list_empty(&rq->queuelist) && !list_empty(&next->queuelist) &&
-	    time_before(rq_fifo_time(next), rq_fifo_time(rq)) &&
+	    time_before(next->fifo_time, rq->fifo_time) &&
 	    cfqq == RQ_CFQQ(next)) {
 		list_move(&rq->queuelist, &next->queuelist);
-		rq_set_fifo_time(rq, rq_fifo_time(next));
+		rq->fifo_time = next->fifo_time;
 	}
 
 	if (cfqq->next_rq == next)
@@ -2814,7 +2814,7 @@ static struct request *cfq_check_fifo(struct cfq_queue *cfqq)
 		return NULL;
 
 	rq = rq_entry_fifo(cfqq->fifo.next);
-	if (time_before(jiffies, rq_fifo_time(rq)))
+	if (time_before(jiffies, rq->fifo_time))
 		rq = NULL;
 
 	cfq_log_cfqq(cfqq->cfqd, cfqq, "fifo=%p", rq);
@@ -3927,7 +3927,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	cfq_log_cfqq(cfqd, cfqq, "insert_request");
 	cfq_init_prio_data(cfqq, RQ_CIC(rq));
 
-	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
+	rq->fifo_time = jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)];
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
 	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group,
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 9ef6640..a753df2 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -106,7 +106,7 @@ deadline_add_request(struct request_queue *q, struct request *rq)
 	/*
 	 * set expire time and add to fifo list
 	 */
-	rq_set_fifo_time(rq, jiffies + dd->fifo_expire[data_dir]);
+	rq->fifo_time = jiffies + dd->fifo_expire[data_dir];
 	list_add_tail(&rq->queuelist, &dd->fifo_list[data_dir]);
 }
 
@@ -174,9 +174,9 @@ deadline_merged_requests(struct request_queue *q, struct request *req,
 	 * and move into next position (next will be deleted) in fifo
 	 */
 	if (!list_empty(&req->queuelist) && !list_empty(&next->queuelist)) {
-		if (time_before(rq_fifo_time(next), rq_fifo_time(req))) {
+		if (time_before(next->fifo_time, req->fifo_time)) {
 			list_move(&req->queuelist, &next->queuelist);
-			rq_set_fifo_time(req, rq_fifo_time(next));
+			req->fifo_time = next->fifo_time;
 		}
 	}
 
@@ -230,7 +230,7 @@ static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
 	/*
 	 * rq is expired!
 	 */
-	if (time_after_eq(jiffies, rq_fifo_time(rq)))
+	if (time_after_eq(jiffies, rq->fifo_time))
 		return 1;
 
 	return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4afa4f8..1e1fa3f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -99,6 +99,7 @@ struct request {
 	union {
 		struct call_single_data csd;
 		struct work_struct mq_flush_work;
+		unsigned long fifo_time;
 	};
 
 	struct request_queue *q;
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 306dd8c..0bdfd46 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -202,12 +202,6 @@ enum {
 #define rq_end_sector(rq)	(blk_rq_pos(rq) + blk_rq_sectors(rq))
 #define rb_entry_rq(node)	rb_entry((node), struct request, rb_node)
 
-/*
- * Hack to reuse the csd.list list_head as the fifo time holder while
- * the request is in the io scheduler. Saves an unsigned long in rq.
- */
-#define rq_fifo_time(rq)	((unsigned long) (rq)->csd.list.next)
-#define rq_set_fifo_time(rq,exp)	((rq)->csd.list.next = (void *) (exp))
 #define rq_entry_fifo(ptr)	list_entry((ptr), struct request, queuelist)
 #define rq_fifo_clear(rq)	do {		\
 	list_del_init(&(rq)->queuelist);	\
-- 
1.8.3.1

