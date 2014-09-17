Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaIQJsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:48:16 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:52176 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaIQJsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:48:13 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 1/2] blk-mq: fix race between timeout and queue_rq
Date: Wed, 17 Sep 2014 17:47:57 +0800
Message-Id: <1410947278-15733-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410947278-15733-1-git-send-email-ming.lei@canonical.com>
References: <1410947278-15733-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Either the request is from requeue or just being allocated from
tag pool, its REQ_ATOM_STARTED flag has been cleared already, so
don't test it in blk_mq_start_request().

One memory barrier is needed between writing rq->deadline and
setting REQ_ATOM_STARTED so that timeout can't happen too early
if timeout handler reads obsolete rq->deadline caused by out
of order of the two writes.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 47f3938..957815e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -377,13 +377,20 @@ static void blk_mq_start_request(struct request *rq, bool last)
 	blk_add_timer(rq);
 
 	/*
+	 * Order writing rq->deadline and setting the rq's
+	 * REQ_ATOM_STARTED flag so that timeout handler can see
+	 * correct rq->deadline once the rq's REQ_ATOM_STARTED flag
+	 * is observed.
+	 */
+	smp_mb__before_atomic();
+
+	/*
 	 * Mark us as started and clear complete. Complete might have been
 	 * set if requeue raced with timeout, which then marked it as
 	 * complete. So be sure to clear complete again when we start
 	 * the request, otherwise we'll ignore the completion event.
 	 */
-	if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
-		set_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
+	set_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
 	if (test_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags))
 		clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 
-- 
1.7.9.5

