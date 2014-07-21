Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaGUIKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:10:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaGUIKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:10:09 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] blk-mq: bitmap tag: fix potential unwakeable sleep in bt_get()
Date: Mon, 21 Jul 2014 10:10:46 +0200
Message-Id: <1405930246-2051-1-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between __bt_get_word() and bt_clear_tag(). Since
access to the tags bitmap is not serialized __bt_get_word() might
miss a tag which is about to or being returned by bt_clear_tag().
As result, the process requesting the tag might end up schedulled
out forever.

To avoid this corner case call io_schedule_timeout() instead of
io_schedule(). The timeout should be long enough to not falsely
wake up waiters often, so take the requests queue's "rq_timeout"
for that.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq-tag.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c1b9242..1785f1f 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -256,7 +256,7 @@ static int bt_get(struct blk_mq_alloc_data *data,
 
 		blk_mq_put_ctx(data->ctx);
 
-		io_schedule();
+		WARN_ON(!io_schedule_timeout(hctx->queue->rq_timeout));
 
 		data->ctx = blk_mq_get_ctx(data->q);
 		data->hctx = data->q->mq_ops->map_queue(data->q,
-- 
1.7.7.6

