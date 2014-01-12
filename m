Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaALQK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 11:10:58 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61985 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaALQK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 11:10:56 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>,
        Fan Du <fan.du@windriver.com>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] lib/percpu_counter.c: fix __percpu_counter_add
Date: Mon, 13 Jan 2014 00:10:45 +0800
Message-Id: <1389543045-10563-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

__percpu_counter_add() may be called in softirq/hardirq handler
(such as, blk_mq_queue_exit() is typically called in hardirq/softirq
handler), so we need to call this_cpu_add()(irq safe helper) to
update percpu counter, otherwise counts may be lost.

The patch fixes problem that 'rmmod null_blk' hangs in
blk_cleanup_queue() because of miscounting of
request_queue->mq_usage_counter.

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Fan Du <fan.du@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
This patch is the v1 of previous one of "lib/percpu_counter.c:
disable local irq when updating percpu couter", and takes Andrew's
approach which may be more efficient for ARCHs(x86, s390) that
have optimized this_cpu_add().

 lib/percpu_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 7473ee3..1da85bb 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -82,10 +82,10 @@ void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 		unsigned long flags;
 		raw_spin_lock_irqsave(&fbc->lock, flags);
 		fbc->count += count;
+		 __this_cpu_sub(*fbc->counters, count);
 		raw_spin_unlock_irqrestore(&fbc->lock, flags);
-		__this_cpu_write(*fbc->counters, 0);
 	} else {
-		__this_cpu_write(*fbc->counters, count);
+		this_cpu_add(*fbc->counters, amount);
 	}
 	preempt_enable();
 }
-- 
1.7.9.5

