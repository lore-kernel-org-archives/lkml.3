Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3LZNcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 08:32:21 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34693 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3LZNcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 08:32:19 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 4/5] block: null_blk: fix queue leak inside removing device
Date: Thu, 26 Dec 2013 21:31:37 +0800
Message-Id: <1388064698-27344-5-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
References: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
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

