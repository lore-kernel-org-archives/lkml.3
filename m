Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3JDNub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:50:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3JDNuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:50:22 -0400
Message-Id: <20131004135014.713912371@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 04 Oct 2013 06:49:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] [PATCH 3/5] block: remove request ref_count
References: <20131004134908.231874670@bombadil.infradead.org>
Content-Disposition: inline; filename=0003-block-remove-request-ref_count.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reference count has been around since before git history, but the only
place where it's used is in blk_execute_rq, and ther it is entirely useless
as it is incremented before submitting the request and decremented in the
end_io handler before waking up the submitter thread.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       |    3 ---
 block/blk-exec.c       |    7 -------
 include/linux/blkdev.h |    2 --
 3 files changed, 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f80df88..5620e58 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -110,7 +110,6 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->cmd = rq->__cmd;
 	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
-	rq->ref_count = 1;
 	rq->start_time = jiffies;
 	set_start_time_ns(rq);
 	rq->part = NULL;
@@ -1249,8 +1248,6 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 {
 	if (unlikely(!q))
 		return;
-	if (unlikely(--req->ref_count))
-		return;
 
 	blk_pm_put_request(req);
 
diff --git a/block/blk-exec.c b/block/blk-exec.c
index e706213..7972da7 100644
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
index 06df51d..8771c0b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -168,8 +168,6 @@ struct request {
 
 	unsigned short ioprio;
 
-	int ref_count;
-
 	void *special;		/* opaque pointer available for LLD use */
 	char *buffer;		/* kaddr of the current segment if available */
 
-- 
1.7.10.4


