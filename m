Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaKZPDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:03:31 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48278 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaKZPD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:03:28 -0500
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: axboe@fb.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH] null_blk: boundary check queue_mode and irqmode
Date: Wed, 26 Nov 2014 16:02:58 +0100
Message-Id: <1417014178-13007-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When either queue_mode or irq_mode parameter is set outside its boundaries, the
driver will not complete requests. This stalls driver initialization when
partitions are probed. Fix by setting out of bound values to the parameters
default.

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 drivers/block/null_blk.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index caa6121..efe9f76 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -506,7 +506,7 @@ static int null_add_dev(void)
 		rv = init_driver_queues(nullb);
 		if (rv)
 			goto out_cleanup_blk_queue;
-	} else {
+	} else if (queue_mode == NULL_Q_RQ) {
 		nullb->q = blk_init_queue_node(null_request_fn, &nullb->lock, home_node);
 		if (!nullb->q) {
 			rv = -ENOMEM;
@@ -574,6 +574,18 @@ static int __init null_init(void)
 		bs = PAGE_SIZE;
 	}
 
+	if (queue_mode < 0 || queue_mode > NULL_Q_MQ) {
+		pr_warn("null_blk: invalid queue mode\n");
+		pr_warn("null_blk: defaults queue mode to multiqueue\n");
+		queue_mode = NULL_Q_MQ;
+	}
+
+	if (irqmode < 0 || irqmode > NULL_IRQ_TIMER) {
+		pr_warn("null_blk: invalid irq mode\n");
+		pr_warn("null_blk: defauls irq mode to softirq\n");
+		irqmode = NULL_IRQ_SOFTIRQ;
+	}
+
 	if (queue_mode == NULL_Q_MQ && use_per_node_hctx) {
 		if (submit_queues < nr_online_nodes) {
 			pr_warn("null_blk: submit_queues param is set to %u.",
-- 
1.9.1

