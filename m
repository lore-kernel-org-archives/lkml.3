Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaIQJsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:48:21 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58686 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaIQJsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:48:17 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canoical.com>
Subject: [PATCH 2/2] blk-mq: remove unnecessary blk_clear_rq_complete()
Date: Wed, 17 Sep 2014 17:47:58 +0800
Message-Id: <1410947278-15733-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410947278-15733-1-git-send-email-ming.lei@canonical.com>
References: <1410947278-15733-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <ming.lei@canoical.com>

This patch removes two unnecessary blk_clear_rq_complete(),
the REQ_ATOM_COMPLETE flag is cleared inside blk_mq_start_request(),
so:

	- The blk_clear_rq_complete() in blk_flush_restore_request()
	needn't because the request will be freed later, and clearing
	it here may open a small race window with timeout.

	- The blk_clear_rq_complete() in blk_mq_requeue_request() isn't
	necessary too, even though REQ_ATOM_STARTED is cleared in
	__blk_mq_requeue_request(), in theory it still may cause a small
	race window with timeout since the two clear_bit() may be
	reordered.

Signed-off-by: Ming Lei <ming.lei@canoical.com>
---
 block/blk-flush.c |    2 --
 block/blk-mq.c    |    1 -
 2 files changed, 3 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index b439670..db6dfb4 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -127,8 +127,6 @@ static void blk_flush_restore_request(struct request *rq)
 	/* make @rq a normal request */
 	rq->cmd_flags &= ~REQ_FLUSH_SEQ;
 	rq->end_io = rq->flush.saved_end_io;
-
-	blk_clear_rq_complete(rq);
 }
 
 static bool blk_flush_queue_rq(struct request *rq, bool add_front)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 957815e..6e4942d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -430,7 +430,6 @@ static void __blk_mq_requeue_request(struct request *rq)
 void blk_mq_requeue_request(struct request *rq)
 {
 	__blk_mq_requeue_request(rq);
-	blk_clear_rq_complete(rq);
 
 	BUG_ON(blk_queued_rq(rq));
 	blk_mq_add_to_requeue_list(rq, true);
-- 
1.7.9.5

