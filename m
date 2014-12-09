Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbaLIP7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:59:50 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:36196 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaLIP7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:59:49 -0500
Message-ID: <54871C74.4080609@acm.org>
Date: Tue, 09 Dec 2014 16:59:48 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] blk-mq: Micro-optimize bt_get()
References: <54871BD0.8020305@acm.org>
In-Reply-To: <54871BD0.8020305@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a superfluous finish_wait() call. Convert the two bt_wait_ptr()
calls into a single call.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robert Elliott <elliott@hp.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 795996e..2373724 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -248,8 +248,8 @@ static int bt_get(struct blk_mq_alloc_data *data,
 	if (!(data->gfp & __GFP_WAIT))
 		return -1;
 
-	bs = bt_wait_ptr(bt, hctx);
 	do {
+		bs = bt_wait_ptr(bt, hctx);
 		prepare_to_wait(&bs->wait, &wait, TASK_UNINTERRUPTIBLE);
 
 		tag = __bt_get(hctx, bt, last_tag);
@@ -276,8 +276,6 @@ static int bt_get(struct blk_mq_alloc_data *data,
 			hctx = data->hctx;
 			bt = &hctx->tags->bitmap_tags;
 		}
-		finish_wait(&bs->wait, &wait);
-		bs = bt_wait_ptr(bt, hctx);
 	} while (1);
 
 	finish_wait(&bs->wait, &wait);
-- 
2.1.2

