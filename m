Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3JXJ2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:28:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36723 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3JXJ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:17 -0400
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/11] block: remove request ref_count
Date: Thu, 24 Oct 2013 10:25:57 +0100
Message-Id: <1382606764-8309-5-git-send-email-axboe@kernel.dk>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

This reference count has been around since before git history, but the only
place where it's used is in blk_execute_rq, and ther it is entirely useless
as it is incremented before submitting the request and decremented in the
end_io handler before waking up the submitter thread.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c       | 3 ---
 block/blk-exec.c       | 7 -------
 include/linux/blkdev.h | 2 --
 3 files changed, 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 213e9f0..18faa7e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -145,7 +145,6 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->cmd = rq->__cmd;
 	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
-	rq->ref_count = 1;
 	rq->start_time = jiffies;
 	set_start_time_ns(rq);
 	rq->part = NULL;
@@ -1272,8 +1271,6 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 {
 	if (unlikely(!q))
 		return;
-	if (unlikely(--req->ref_count))
-		return;
 
 	blk_pm_put_request(req);
 
diff --git a/block/blk-exec.c b/block/blk-exec.c
index ae4f27d..6b18d82 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -24,7 +24,6 @@ static void blk_end_sync_rq(struct request *rq, int error)
 	struct completion *waiting = rq->end_io_data;
 
 	rq->end_io_data = NULL;
-	__blk_put_request(rq->q, rq);
 
 	/*
 	 * complete last, if this is a stack request the process (and thus
@@ -103,12 +102,6 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
 	int err = 0;
 	unsigned long hang_check;
 
-	/*
-	 * we need an extra reference to the request, so we can look at
-	 * it after io completion
-	 */
-	rq->ref_count++;
-
 	if (!rq->sense) {
 		memset(sense, 0, sizeof(sense));
 		rq->sense = sense;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f5c7596..0a8da96 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -160,8 +160,6 @@ struct request {
 
 	unsigned short ioprio;
 
-	int ref_count;
-
 	void *special;		/* opaque pointer available for LLD use */
 	char *buffer;		/* kaddr of the current segment if available */
 
-- 
1.8.1.2

