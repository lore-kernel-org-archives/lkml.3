Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3LTXLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:11:31 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39693 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3LTXLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:11:15 -0500
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH 3/3] null_blk: support submit_queues on use_per_node_hctx
Date: Sat, 21 Dec 2013 00:11:01 +0100
Message-Id: <1387581061-25987-4-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387581061-25987-1-git-send-email-m@bjorling.me>
References: <1387581061-25987-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matias Bjørling <m@bjorling.me>

In the case of both the submit_queues param and use_per_node_hctx param
are used. We limit the number af submit_queues to the number of online
nodes.

If the submit_queues is a multiple of nr_online_nodes, its trivial. Simply map
them to the nodes. For example: 8 submit queues are mapped as node0[0,1],
node1[2,3], ...
If uneven, we are left with an uneven number of submit_queues that must be
mapped. These are mapped toward the first node and onward. E.g. 5
submit queues mapped onto 4 nodes are mapped as node0[0,1], node1[2], ...

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 drivers/block/null_blk.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 9b0311b..528f4e4 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -1,4 +1,5 @@
 #include <linux/module.h>
+
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
@@ -346,8 +347,37 @@ static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
 
 static struct blk_mq_hw_ctx *null_alloc_hctx(struct blk_mq_reg *reg, unsigned int hctx_index)
 {
-	return kzalloc_node(sizeof(struct blk_mq_hw_ctx), GFP_KERNEL,
-				hctx_index);
+	int b_size = DIV_ROUND_UP(reg->nr_hw_queues, nr_online_nodes);
+	int tip = (reg->nr_hw_queues % nr_online_nodes);
+	int node = 0, i, n;
+
+	/*
+	 * Split submit queues evenly wrt to the number of nodes. If uneven,
+	 * fill the first buckets with one extra, until the rest is filled with
+	 * no extra.
+	 */
+	for (i = 0, n = 1; i < hctx_index; i++, n++) {
+		if (n % b_size == 0) {
+			n = 0;
+			node++;
+
+			tip--;
+			if (!tip)
+				b_size = reg->nr_hw_queues / nr_online_nodes;
+		}
+	}
+
+	/*
+	 * A node might not be online, therefore map the relative node id to the
+	 * real node id.
+	 */
+	for_each_online_node(n) {
+		if (!node)
+			break;
+		node--;
+	}
+
+	return kzalloc_node(sizeof(struct blk_mq_hw_ctx), GFP_KERNEL, n);
 }
 
 static void null_free_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_index)
@@ -591,10 +621,11 @@ static int __init null_init(void)
 #endif
 
 	if (queue_mode == NULL_Q_MQ && use_per_node_hctx) {
-		if (submit_queues > 0)
+		if (submit_queues < nr_online_nodes) {
 			pr_warn("null_blk: submit_queues param is set to %u.",
 							nr_online_nodes);
-		submit_queues = nr_online_nodes;
+			submit_queues = nr_online_nodes;
+		}
 	} else if (submit_queues > nr_cpu_ids)
 		submit_queues = nr_cpu_ids;
 	else if (!submit_queues)
-- 
1.8.3.2

