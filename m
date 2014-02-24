Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaBXPkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:40:16 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57379 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaBXPkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:13 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jens Axboe <axboe@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/11] block: Stop abusing rq->csd.list in blk-softirq
Date: Mon, 24 Feb 2014 16:39:54 +0100
Message-Id: <1393256402-16907-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Abusing rq->csd.list for a list of requests to complete is rather ugly.
We use rq->queuelist instead which is much cleaner. It is safe because
queuelist is used by the block layer only for requests waiting to be
submitted to a device. Thus it is unused when irq reports the request IO
is finished.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 block/blk-softirq.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 57790c1..b5c37d9 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -30,8 +30,8 @@ static void blk_done_softirq(struct softirq_action *h)
 	while (!list_empty(&local_list)) {
 		struct request *rq;
 
-		rq = list_entry(local_list.next, struct request, csd.list);
-		list_del_init(&rq->csd.list);
+		rq = list_entry(local_list.next, struct request, queuelist);
+		list_del_init(&rq->queuelist);
 		rq->q->softirq_done_fn(rq);
 	}
 }
@@ -45,9 +45,14 @@ static void trigger_softirq(void *data)
 
 	local_irq_save(flags);
 	list = this_cpu_ptr(&blk_cpu_done);
-	list_add_tail(&rq->csd.list, list);
+	/*
+	 * We reuse queuelist for a list of requests to process. Since the
+	 * queuelist is used by the block layer only for requests waiting to be
+	 * submitted to the device it is unused now.
+	 */
+	list_add_tail(&rq->queuelist, list);
 
-	if (list->next == &rq->csd.list)
+	if (list->next == &rq->queuelist)
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 
 	local_irq_restore(flags);
@@ -136,7 +141,7 @@ void __blk_complete_request(struct request *req)
 		struct list_head *list;
 do_local:
 		list = this_cpu_ptr(&blk_cpu_done);
-		list_add_tail(&req->csd.list, list);
+		list_add_tail(&req->queuelist, list);
 
 		/*
 		 * if the list only contains our just added request,
@@ -144,7 +149,7 @@ do_local:
 		 * entries there, someone already raised the irq but it
 		 * hasn't run yet.
 		 */
-		if (list->next == &req->csd.list)
+		if (list->next == &req->queuelist)
 			raise_softirq_irqoff(BLOCK_SOFTIRQ);
 	} else if (raise_blk_irq(ccpu, req))
 		goto do_local;
-- 
1.8.3.1

