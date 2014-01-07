Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaAGKcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:32:12 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:51618 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaAGKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:32:10 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>,
        Fan Du <fan.du@windriver.com>
Subject: [PATCH] lib/percpu_counter.c: disable local irq when updating percpu couter
Date: Tue,  7 Jan 2014 18:29:27 +0800
Message-Id: <1389090568-29079-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__percpu_counter_add() may be called in softirq/hardirq handler
(such as, blk_mq_queue_exit() is typically called in hardirq/softirq
handler), so we need to disable local irq when updating the percpu
counter, otherwise counts may be lost.

The patch fixes problem that 'rmmod null_blk' may hang in blk_cleanup_queue()
because of miscounting of request_queue->mq_usage_counter.

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Fan Du <fan.du@windriver.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 lib/percpu_counter.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 7473ee3..2b87bc1 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -75,19 +75,19 @@ EXPORT_SYMBOL(percpu_counter_set);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
+	unsigned long flags;
 
-	preempt_disable();
+	raw_local_irq_save(flags);
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		unsigned long flags;
-		raw_spin_lock_irqsave(&fbc->lock, flags);
+		raw_spin_lock(&fbc->lock);
 		fbc->count += count;
-		raw_spin_unlock_irqrestore(&fbc->lock, flags);
+		raw_spin_unlock(&fbc->lock);
 		__this_cpu_write(*fbc->counters, 0);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
-	preempt_enable();
+	raw_local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__percpu_counter_add);
 
-- 
1.7.9.5

