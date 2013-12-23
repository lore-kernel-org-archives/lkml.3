Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3LWQTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:19:35 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33922 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3LWQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:19:32 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/4] block: blk-mq: make blk_sync_queue support mq
Date: Tue, 24 Dec 2013 00:18:57 +0800
Message-Id: <1387815539-12257-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves synchronization on mq->delay_work
from blk_mq_free_queue() to blk_sync_queue(), so that
blk_sync_queue can work on mq.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-core.c |   11 ++++++++++-
 block/blk-mq.c   |    1 -
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index eb13db0..74ebde3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -246,7 +246,16 @@ EXPORT_SYMBOL(blk_stop_queue);
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->timeout);
-	cancel_delayed_work_sync(&q->delay_work);
+
+	if (q->mq_ops) {
+		struct blk_mq_hw_ctx *hctx;
+		int i;
+
+		queue_for_each_hw_ctx(q, hctx, i)
+			cancel_delayed_work_sync(&hctx->delayed_work);
+	} else {
+		cancel_delayed_work_sync(&q->delay_work);
+	}
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index fcfdf35..16c046f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1406,7 +1406,6 @@ void blk_mq_free_queue(struct request_queue *q)
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
-		cancel_delayed_work_sync(&hctx->delayed_work);
 		kfree(hctx->ctx_map);
 		kfree(hctx->ctxs);
 		blk_mq_free_rq_map(hctx);
-- 
1.7.9.5

