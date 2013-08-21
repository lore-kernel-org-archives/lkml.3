Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3HUPZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:25:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab3HUPZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:25:44 -0400
Date: Wed, 21 Aug 2013 17:27:07 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Shaohua Li <shli@fusionio.com>
Subject: [PATCH 4/5] blk-mq: Do not fail blk_mq_reg::queue_depth value of zero
Message-ID: <20130821152706.GB27943@dhcp-26-207.brq.redhat.com>
References: <cover.1375451955.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1375451955.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zero value of blk_mq_reg::queue_depth defaults to
BLK_MQ_MAX_DEPTH. Commit 1ffd49b ("blk-mq: Check queue
depth is valid") broke this default. This fix restores
the previous behaviour.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a8b4c79..6c2533a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1308,8 +1308,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 
 	if (!reg->nr_hw_queues ||
 	    !reg->ops->queue_rq || !reg->ops->map_queue ||
-	    !reg->ops->alloc_hctx || !reg->ops->free_hctx ||
-	    (reg->queue_depth < (reg->reserved_tags + BLK_MQ_TAG_MIN)))
+	    !reg->ops->alloc_hctx || !reg->ops->free_hctx)
 		return ERR_PTR(-EINVAL);
 
 	if (!reg->queue_depth)
@@ -1319,6 +1318,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 		reg->queue_depth = BLK_MQ_MAX_DEPTH;
 	}
 
+	if (reg->queue_depth < (reg->reserved_tags + BLK_MQ_TAG_MIN))
+		return ERR_PTR(-EINVAL);
+
 	ctx = alloc_percpu(struct blk_mq_ctx);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
