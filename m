Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaBKQ1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:27:44 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaBKQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:27:39 -0500
Message-Id: <20140211162739.554458485@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 11 Feb 2014 08:27:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] blk-mq: dont assume rq->errors is set when returning an error from
 ->queue_rq
References: <20140211162712.055066190@bombadil.infradead.org>
Content-Disposition: inline; filename=0001-blk-mq-don-t-assume-rq-errors-is-set-when-returning-.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq->errors never has been part of the communication protocol between drivers
and the block stack and most drivers will not have initialized it.

Return -EIO to upper layers when the driver returns BLK_MQ_RQ_QUEUE_ERROR
unconditionally.  If a driver want to return a different error it can easily
do so by returning success after calling blk_mq_end_io itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a59b056..0480710 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -605,8 +605,8 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 			break;
 		default:
 			pr_err("blk-mq: bad return on queue: %d\n", ret);
-			rq->errors = -EIO;
 		case BLK_MQ_RQ_QUEUE_ERROR:
+			rq->errors = -EIO;
 			blk_mq_end_io(rq, rq->errors);
 			break;
 		}
-- 
1.7.10.4


