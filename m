Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaJVNeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:34:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbaJVNea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:34:30 -0400
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: hch@lst.de, LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] null_blk: Cleanup error recovery in null_add_dev()
Date: Wed, 22 Oct 2014 15:34:21 +0200
Message-Id: <1413984861-8260-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creation of queues fails in init_driver_queues(), we free the
queues. But null_add_dev() doesn't test for this failure and continues
with the setup leading to strange consequences, likely oops. Fix the
problem by testing whether init_driver_queues() failed and do proper
error cleanup.

Coverity-id: 1148005
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/block/null_blk.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 2671a3f02f0c..8001e812018b 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -450,14 +450,10 @@ static int init_driver_queues(struct nullb *nullb)
 
 		ret = setup_commands(nq);
 		if (ret)
-			goto err_queue;
+			return ret;
 		nullb->nr_queues++;
 	}
-
 	return 0;
-err_queue:
-	cleanup_queues(nullb);
-	return ret;
 }
 
 static int null_add_dev(void)
@@ -507,7 +503,9 @@ static int null_add_dev(void)
 			goto out_cleanup_queues;
 		}
 		blk_queue_make_request(nullb->q, null_queue_bio);
-		init_driver_queues(nullb);
+		rv = init_driver_queues(nullb);
+		if (rv)
+			goto out_cleanup_blk_queue;
 	} else {
 		nullb->q = blk_init_queue_node(null_request_fn, &nullb->lock, home_node);
 		if (!nullb->q) {
@@ -516,7 +514,9 @@ static int null_add_dev(void)
 		}
 		blk_queue_prep_rq(nullb->q, null_rq_prep_fn);
 		blk_queue_softirq_done(nullb->q, null_softirq_done_fn);
-		init_driver_queues(nullb);
+		rv = init_driver_queues(nullb);
+		if (rv)
+			goto out_cleanup_blk_queue;
 	}
 
 	nullb->q->queuedata = nullb;
-- 
1.8.1.4

