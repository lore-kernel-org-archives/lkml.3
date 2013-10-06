Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3JFRJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 13:09:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3JFRJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 13:09:56 -0400
Date: Sun, 6 Oct 2013 10:09:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] blk-mq: fix blk_mq_start_stopped_hw_queues from irq context
Message-ID: <20131006170956.GA30544@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only caller of blk_mq_start_stopped_hw_queues is in irq context,
leading to lockdep splat when it actually gets called.  Fix this by
deferring the hw queue run to workqueue context.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2b85029..923e9e1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -686,7 +686,8 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q)
 		if (!test_bit(BLK_MQ_S_STOPPED, &hctx->state))
 			continue;
 
-		blk_mq_start_hw_queue(hctx);
+		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+		blk_mq_run_hw_queue(hctx, true);
 	}
 }
 EXPORT_SYMBOL(blk_mq_start_stopped_hw_queues);
