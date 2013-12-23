Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab3LWQTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:19:45 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49101 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab3LWQTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:19:42 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 3/4] block: null_blk: fix queue leak inside removing device
Date: Tue, 24 Dec 2013 00:18:58 +0800
Message-Id: <1387815539-12257-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When queue_mode is NULL_Q_MQ and null_blk is being removed,
blk_cleanup_queue() isn't called to cleanup queue, so the
queue allocated won't be freed.

This patch calls blk_cleanup_queue() for MQ to drain all
pending requests first and release the reference counter
of queue kobject, then blk_mq_free_queue() will be called
in queue kobject's release handler when queue kobject's
reference counter drops to zero.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/block/null_blk.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index a2e69d2..83a598e 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -425,10 +425,7 @@ static void null_del_dev(struct nullb *nullb)
 	list_del_init(&nullb->list);
 
 	del_gendisk(nullb->disk);
-	if (queue_mode == NULL_Q_MQ)
-		blk_mq_free_queue(nullb->q);
-	else
-		blk_cleanup_queue(nullb->q);
+	blk_cleanup_queue(nullb->q);
 	put_disk(nullb->disk);
 	kfree(nullb);
 }
@@ -578,10 +575,7 @@ static int null_add_dev(void)
 	disk = nullb->disk = alloc_disk_node(1, home_node);
 	if (!disk) {
 queue_fail:
-		if (queue_mode == NULL_Q_MQ)
-			blk_mq_free_queue(nullb->q);
-		else
-			blk_cleanup_queue(nullb->q);
+		blk_cleanup_queue(nullb->q);
 		cleanup_queues(nullb);
 err:
 		kfree(nullb);
-- 
1.7.9.5

