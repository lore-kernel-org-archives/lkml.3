Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3LJPux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:50:53 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:33597 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3LJPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:50:49 -0500
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH] null_blk: mem garbage on NUMA systems during init
Date: Tue, 10 Dec 2013 16:50:38 +0100
Message-Id: <1386690638-8717-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For NUMA systems, initializing the blk-mq layer and using per node hctx. We
initialize submit queues to 1, while blk-mq nr_hw_queues is initialized to the
number of NUMA nodes.

This makes the null_init_hctx function overwrite memory outside of what it
allocated. In my case it lead to writing garbage into struct request_queue's
mq_map.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 drivers/block/null_blk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index ea192ec..f370fc1 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -495,23 +495,23 @@ static int null_add_dev(void)
 
 	spin_lock_init(&nullb->lock);
 
+	if (queue_mode == NULL_Q_MQ && use_per_node_hctx)
+		submit_queues = nr_online_nodes;
+
 	if (setup_queues(nullb))
 		goto err;
 
 	if (queue_mode == NULL_Q_MQ) {
 		null_mq_reg.numa_node = home_node;
 		null_mq_reg.queue_depth = hw_queue_depth;
+		null_mq_reg.nr_hw_queues = submit_queues;
 
 		if (use_per_node_hctx) {
 			null_mq_reg.ops->alloc_hctx = null_alloc_hctx;
 			null_mq_reg.ops->free_hctx = null_free_hctx;
-
-			null_mq_reg.nr_hw_queues = nr_online_nodes;
 		} else {
 			null_mq_reg.ops->alloc_hctx = blk_mq_alloc_single_hw_queue;
 			null_mq_reg.ops->free_hctx = blk_mq_free_single_hw_queue;
-
-			null_mq_reg.nr_hw_queues = submit_queues;
 		}
 
 		nullb->q = blk_mq_init_queue(&null_mq_reg, nullb);
-- 
1.8.3.2

