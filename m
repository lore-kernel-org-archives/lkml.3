Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaE0Pfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:35:41 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47733 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaE0Pfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:35:36 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 1/3] blk-mq: fix leak of hctx->ctx_map
Date: Tue, 27 May 2014 23:35:12 +0800
Message-Id: <1401204914-3340-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401204914-3340-1-git-send-email-tom.leiming@gmail.com>
References: <1401204914-3340-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hctx->ctx_map should have been freed inside blk_mq_free_queue().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 62082c5..dad22a9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1846,6 +1846,7 @@ void blk_mq_free_queue(struct request_queue *q)
 	queue_for_each_hw_ctx(q, hctx, i) {
 		blk_mq_tag_idle(hctx);
 		kfree(hctx->ctxs);
+		blk_mq_free_bitmap(&hctx->ctx_map);
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 		if (q->mq_ops->exit_hctx)
 			q->mq_ops->exit_hctx(hctx, i);
-- 
1.7.9.5

