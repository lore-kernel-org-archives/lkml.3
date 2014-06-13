Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaFMRnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:43:09 -0400
Received: from verein.lst.de ([213.95.11.211]:48276 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbaFMRnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:43:07 -0400
Date: Fri, 13 Jun 2014 19:43:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] blk-mq: properly drain stopped queues
Message-ID: <20140613174304.GA20317@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we need to drain a queue we need to run all queues, even if they
are marked stopped to make sure the driver has a chance to error out
on all queued requests.

This fixes surprise removal with scsi-mq.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3d868d3..15b3ccd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -120,7 +120,7 @@ static void __blk_mq_drain_queue(struct request_queue *q)
 
 		if (count == 0)
 			break;
-		blk_mq_run_queues(q, false);
+		blk_mq_start_hw_queues(q);
 		msleep(10);
 	}
 }
-- 
1.7.10.4

