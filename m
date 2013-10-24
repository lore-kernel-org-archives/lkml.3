Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3JXJ0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:26:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36733 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JXJ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:19 -0400
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Shaohua Li <shli@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/11] percpu_counter: make APIs irq safe
Date: Thu, 24 Oct 2013 10:25:59 +0100
Message-Id: <1382606764-8309-7-git-send-email-axboe@kernel.dk>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shli@fusionio.com>

In my usage, sometimes the percpu APIs are called with irq locked,
sometimes not. lockdep complains there is potential deadlock. Let's
always use percpucounter lock in irq safe way. There should be no
performance penality, as all those are slow code path.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 lib/percpu_counter.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 93c5d5e..7473ee3 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -60,14 +60,15 @@ static inline void debug_percpu_counter_deactivate(struct percpu_counter *fbc)
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
+	unsigned long flags;
 
-	raw_spin_lock(&fbc->lock);
+	raw_spin_lock_irqsave(&fbc->lock, flags);
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
-	raw_spin_unlock(&fbc->lock);
+	raw_spin_unlock_irqrestore(&fbc->lock, flags);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
@@ -78,9 +79,10 @@ void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		raw_spin_lock(&fbc->lock);
+		unsigned long flags;
+		raw_spin_lock_irqsave(&fbc->lock, flags);
 		fbc->count += count;
-		raw_spin_unlock(&fbc->lock);
+		raw_spin_unlock_irqrestore(&fbc->lock, flags);
 		__this_cpu_write(*fbc->counters, 0);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
@@ -97,14 +99,15 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
+	unsigned long flags;
 
-	raw_spin_lock(&fbc->lock);
+	raw_spin_lock_irqsave(&fbc->lock, flags);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
-	raw_spin_unlock(&fbc->lock);
+	raw_spin_unlock_irqrestore(&fbc->lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
-- 
1.8.1.2

