Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbaISNyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:54:24 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51728 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaISNyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:54:22 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] blk-timeout: fix blk_add_timer
Date: Fri, 19 Sep 2014 21:53:46 +0800
Message-Id: <1411134826-6772-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8cb34819cdd5d(blk-mq: unshared timeout handler) introduces
blk-mq's own timeout handler, and removes following line

	blk_queue_rq_timed_out(q, blk_mq_rq_timed_out);

then cause blk_add_timer() to do nop in case of blk-mq.

This patch fixes the problem by bypassing the check for blk-mq.

Signe-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-timeout.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 4d44825..0c2375c 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -186,7 +186,8 @@ void blk_add_timer(struct request *req)
 	struct request_queue *q = req->q;
 	unsigned long expiry;
 
-	if (!q->rq_timed_out_fn)
+	/* mq needn't the handler */
+	if (!q->mq_ops && !q->rq_timed_out_fn)
 		return;
 
 	BUG_ON(!list_empty(&req->timeout_list));
-- 
1.7.9.5

