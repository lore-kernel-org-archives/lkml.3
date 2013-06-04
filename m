Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3FDWlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:08 -0400
Received: from 1wt.eu ([62.212.114.60]:35138 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab3FDWkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:42 -0400
Message-Id: <20130604172130.389042968@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Thomas Bork <tom@eisfair.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 002/184] Revert "block: improve queue_should_plug() by
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 looking at IO depths"

From: Jens Axboe <jens.axboe@oracle.com>

This reverts commit fb1e75389bd06fd5987e9cda1b4e0305c782f854.

"Benjamin S." <sbenni@gmx.de> reports that the patch in question
causes a big drop in sequential throughput for him, dropping from
200MB/sec down to only 70MB/sec.

Needs to be investigated more fully, for now lets just revert the
offending commit.

Conflicts:

	include/linux/blkdev.h

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
(cherry picked from commit 79da0644a8e0838522828f106e4049639eea6baf)
Cc: Thomas Bork <tom@eisfair.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 block/blk-core.c       | 11 ++---------
 include/linux/blkdev.h |  4 +---
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cffd737..00ac586 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1149,7 +1149,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
  */
 static inline bool queue_should_plug(struct request_queue *q)
 {
-	return !(blk_queue_nonrot(q) && blk_queue_queuing(q));
+	return !(blk_queue_nonrot(q) && blk_queue_tagged(q));
 }
 
 static int __make_request(struct request_queue *q, struct bio *bio)
@@ -1861,15 +1861,8 @@ void blk_dequeue_request(struct request *rq)
 	 * and to it is freed is accounted as io that is in progress at
 	 * the driver side.
 	 */
-	if (blk_account_rq(rq)) {
+	if (blk_account_rq(rq))
 		q->in_flight[rq_is_sync(rq)]++;
-		/*
-		 * Mark this device as supporting hardware queuing, if
-		 * we have more IOs in flight than 4.
-		 */
-		if (!blk_queue_queuing(q) && queue_in_flight(q) > 4)
-			set_bit(QUEUE_FLAG_CQ, &q->queue_flags);
-	}
 }
 
 /**
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5eb6cb0..ec9c10b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -456,8 +456,7 @@ struct request_queue
 #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
-#define QUEUE_FLAG_CQ	       16	/* hardware does queuing */
-#define QUEUE_FLAG_DISCARD     17	/* supports DISCARD */
+#define QUEUE_FLAG_DISCARD     16	/* supports DISCARD */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -580,7 +579,6 @@ enum {
 
 #define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
-#define blk_queue_queuing(q)	test_bit(QUEUE_FLAG_CQ, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
-- 
1.7.12.2.21.g234cd45.dirty



