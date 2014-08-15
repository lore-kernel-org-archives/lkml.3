Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaHOPRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:17:33 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49541 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaHOPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:17:31 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] blk-mq: fix WARNING "percpu_ref_kill() called more than once!"
Date: Fri, 15 Aug 2014 23:16:32 +0800
Message-Id: <1408115792-3311-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before doing queue release, the queue has been freezed already
by blk_cleanup_queue(), so needn't to freeze queue for deleting
tag set.

This patch fixes the WARNING of "percpu_ref_kill() called more than once!"
which is triggered during unloading block driver.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5189cb1..ac8a041 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1713,14 +1713,10 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 
-	blk_mq_freeze_queue(q);
-
 	mutex_lock(&set->tag_list_lock);
 	list_del_init(&q->tag_set_list);
 	blk_mq_update_tag_set_depth(set);
 	mutex_unlock(&set->tag_list_lock);
-
-	blk_mq_unfreeze_queue(q);
 }
 
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
-- 
1.7.9.5

