Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaBXPkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:40:49 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:51996 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaBXPk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:26 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 10/11] smp: Remove wait argument from __smp_call_function_single()
Date: Mon, 24 Feb 2014 16:40:01 +0100
Message-Id: <1393256402-16907-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main point of calling __smp_call_function_single() is to send
an IPI in a pure asynchronous way. By embedding a csd in an object,
a caller can send the IPI without waiting for a previous one to complete
as is required by smp_call_function_single() for example. As such,
sending this kind of IPI can be safe even when irqs are disabled.

This flexibility comes at the expense of the caller who then needs to
synchronize the csd lifecycle by himself and make sure that IPIs on a
single csd are serialized.

This is how __smp_call_function_single() works when wait = 0 and this
usecase is relevant.

Now there don't seem to be any usecase with wait = 1 that can't be
covered by smp_call_function_single() instead, which is safer. Lets look
at the two possible scenario:

1) The user calls __smp_call_function_single(wait = 1) on a csd embedded
   in an object. It looks like a nice and convenient pattern at the first
   sight because we can then retrieve the object from the IPI handler easily.

   But actually it is a waste of memory space in the object since the csd
   can be allocated from the stack by smp_call_function_single(wait = 1)
   and the object can be passed an the IPI argument.

   Besides that, embedding the csd in an object is more error prone
   because the caller must take care of the serialization of the IPIs
   for this csd.

2) The user calls __smp_call_function_single(wait = 1) on a csd that
   is allocated on the stack. It's ok but smp_call_function_single()
   can do it as well and it already takes care of the allocation on the
   stack. Again it's more simple and less error prone.

Therefore, using the underscore prepend API version with wait = 1
is a bad pattern and a sign that the caller can do safer and more
simple.

There was a single user of that which has just been converted.
So lets remove this option to discourage further users.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 block/blk-mq.c            |  2 +-
 block/blk-softirq.c       |  2 +-
 drivers/cpuidle/coupled.c |  2 +-
 include/linux/smp.h       |  2 +-
 kernel/sched/core.c       |  2 +-
 kernel/smp.c              | 19 ++++---------------
 kernel/up.c               |  3 +--
 net/core/dev.c            |  2 +-
 8 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1fa9dd1..62154ed 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -353,7 +353,7 @@ void __blk_mq_complete_request(struct request *rq)
 		rq->csd.func = __blk_mq_complete_request_remote;
 		rq->csd.info = rq;
 		rq->csd.flags = 0;
-		__smp_call_function_single(ctx->cpu, &rq->csd, 0);
+		__smp_call_function_single(ctx->cpu, &rq->csd);
 	} else {
 		rq->q->softirq_done_fn(rq);
 	}
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index b5c37d9..6345b7e 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -70,7 +70,7 @@ static int raise_blk_irq(int cpu, struct request *rq)
 		data->info = rq;
 		data->flags = 0;
 
-		__smp_call_function_single(cpu, data, 0);
+		__smp_call_function_single(cpu, data);
 		return 0;
 	}
 
diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index e952936..0411594 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -323,7 +323,7 @@ static void cpuidle_coupled_poke(int cpu)
 	struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb, cpu);
 
 	if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poke_pending))
-		__smp_call_function_single(cpu, csd, 0);
+		__smp_call_function_single(cpu, csd);
 }
 
 /**
diff --git a/include/linux/smp.h b/include/linux/smp.h
index c39074c..b410a1f 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -50,7 +50,7 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 		smp_call_func_t func, void *info, bool wait,
 		gfp_t gfp_flags);
 
-int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait);
+int __smp_call_function_single(int cpu, struct call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6edbef2..94e51f7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -432,7 +432,7 @@ void hrtick_start(struct rq *rq, u64 delay)
 	if (rq == this_rq()) {
 		__hrtick_restart(rq);
 	} else if (!rq->hrtick_csd_pending) {
-		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd, 0);
+		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd);
 		rq->hrtick_csd_pending = 1;
 	}
 }
diff --git a/kernel/smp.c b/kernel/smp.c
index fa04ab9..b767631 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -241,29 +241,18 @@ EXPORT_SYMBOL(smp_call_function_single);
  * __smp_call_function_single(): Run a function on a specific CPU
  * @cpu: The CPU to run on.
  * @csd: Pre-allocated and setup data structure
- * @wait: If true, wait until function has completed on specified CPU.
  *
  * Like smp_call_function_single(), but allow caller to pass in a
  * pre-allocated data structure. Useful for embedding @data inside
  * other structures, for instance.
  */
-int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait)
+int __smp_call_function_single(int cpu, struct call_single_data *csd)
 {
 	int err = 0;
-	int this_cpu;
 
-	this_cpu = get_cpu();
-	/*
-	 * Can deadlock when called with interrupts disabled.
-	 * We allow cpu's that are not yet online though, as no one else can
-	 * send smp call function interrupt to this cpu and as such deadlocks
-	 * can't happen.
-	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && wait && irqs_disabled()
-		     && !oops_in_progress);
-
-	err = generic_exec_single(cpu, csd, csd->func, csd->info, wait);
-	put_cpu();
+	preempt_disable();
+	err = generic_exec_single(cpu, csd, csd->func, csd->info, 0);
+	preempt_enable();
 
 	return err;
 }
diff --git a/kernel/up.c b/kernel/up.c
index cdf03d1..4e199d4 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -22,8 +22,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int __smp_call_function_single(int cpu, struct call_single_data *csd,
-			       int wait)
+int __smp_call_function_single(int cpu, struct call_single_data *csd)
 {
 	unsigned long flags;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index b1b0c8d..d648116 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4131,7 +4131,7 @@ static void net_rps_action_and_irq_enable(struct softnet_data *sd)
 
 			if (cpu_online(remsd->cpu))
 				__smp_call_function_single(remsd->cpu,
-							   &remsd->csd, 0);
+							   &remsd->csd);
 			remsd = next;
 		}
 	} else
-- 
1.8.3.1

