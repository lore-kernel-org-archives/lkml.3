Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaGDL0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:26:33 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:63035 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaGDL0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:26:32 -0400
Date: Fri, 4 Jul 2014 19:26:23 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@fb.com
Subject: [patch]blk-mq: suppress a warning
Message-ID: <20140704112623.GA17435@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The warning is hit when cpu hotplug is running. After scheduler puts a cpu
online and before blk-mq mapping reinit, a task can queue a request and run the
queue. At that time the cpu isn't in hctx->cpumask, but the cpu is mapped into
hctx 0. When the race happens, hctx->cpumask doesn't set the cpu and
ctx->index_hw/hctx->nr_ctx isn't correct, but it doesn't cause any problem. So
just suppress the warning here.

Signed-off-by: Shaohua Li <shli@fusionio.com>

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ad69ef6..22f314e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -724,7 +724,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	LIST_HEAD(rq_list);
 	int queued;
 
-	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask));
+	WARN_ON(q->mq_ops->map_queue(q, raw_smp_processor_id()) != hctx);
 
 	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
 		return;
