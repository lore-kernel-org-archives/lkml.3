Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3JHJf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:35:57 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:61614 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab3JHJfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:35:15 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: axboe@kernel.dk, willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH RFC 1/2] blk-mq: call exit_hctx on hw queue teardown
Date: Tue,  8 Oct 2013 11:34:21 +0200
Message-Id: <1381224862-5299-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381224862-5299-1-git-send-email-m@bjorling.me>
References: <1381224862-5299-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver initialize itself using init_hctx and reverts using exit_hctx if
unsucessful. exit_hctx is missing on normal hw queue teardown.

Signed-off-by: Matias Bjørling <m@bjorling.me>
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

