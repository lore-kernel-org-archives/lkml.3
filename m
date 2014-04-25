Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaDYMOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:14:52 -0400
Received: from verein.lst.de ([213.95.11.211]:44948 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaDYMOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:14:50 -0400
Date: Fri, 25 Apr 2014 14:14:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: fold __blk_add_timer into blk_add_timer
Message-ID: <20140425121448.GA16576@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 49988a3..4487456 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -166,8 +166,15 @@ void blk_abort_request(struct request *req)
 }
 EXPORT_SYMBOL_GPL(blk_abort_request);
 
-static void __blk_add_timer(struct request *req,
-			    struct list_head *timeout_list)
+/**
+ * blk_add_timer - Start timeout timer for a single request
+ * @req:	request that is about to start running.
+ *
+ * Notes:
+ *    Each request has its own timer, and as it is added to the queue, we
+ *    set up the timer. When the request completes, we cancel the timer.
+ */
+void blk_add_timer(struct request *req)
 {
 	struct request_queue *q = req->q;
 	unsigned long expiry;
@@ -185,8 +192,8 @@ static void __blk_add_timer(struct request *req,
 		req->timeout = q->rq_timeout;
 
 	req->deadline = jiffies + req->timeout;
-	if (timeout_list)
-		list_add_tail(&req->timeout_list, timeout_list);
+	if (!q->mq_ops)
+		list_add_tail(&req->timeout_list, &req->q->timeout_list);
 
 	/*
 	 * If the timer isn't already pending or this timeout is earlier
@@ -211,22 +218,3 @@ static void __blk_add_timer(struct request *req,
 	}
 
 }
-
-/**
- * blk_add_timer - Start timeout timer for a single request
- * @req:	request that is about to start running.
- *
- * Notes:
- *    Each request has its own timer, and as it is added to the queue, we
- *    set up the timer. When the request completes, we cancel the timer.
- */
-void blk_add_timer(struct request *req)
-{
-	struct request_queue *q = req->q;
-
-	if (q->mq_ops)
-		__blk_add_timer(req, NULL);
-	else
-		__blk_add_timer(req, &req->q->timeout_list);
-}
-
