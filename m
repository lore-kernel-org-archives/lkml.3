Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3JRNOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:14:47 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44099 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3JRNOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:14:45 -0400
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk, willy@linux.intel.com, keith.busch@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        Matias Bjorling <m@bjorling.me>
Subject: [PATCH 1/3] blk-mq: call exit_hctx on hw queue teardown
Date: Fri, 18 Oct 2013 15:14:20 +0200
Message-Id: <1382102062-22270-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382102062-22270-1-git-send-email-m@bjorling.me>
References: <1382102062-22270-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver initializes itself using init_hctx and reverts using exit_hctx if
unsucessful. exit_hctx is missing on normal hw queue teardown.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 block/blk-mq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 923e9e1..5b054b7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1390,6 +1390,8 @@ void blk_mq_free_queue(struct request_queue *q)
 		kfree(hctx->ctxs);
 		blk_mq_free_rq_map(hctx);
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
+		if (q->mq_ops->exit_hctx)
+			q->mq_ops->exit_hctx(hctx, i);
 		q->mq_ops->free_hctx(hctx, i);
 	}
 
-- 
1.8.1.2

