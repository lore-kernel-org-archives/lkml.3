Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaBXPku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:40:50 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34093 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaBXPkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:25 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 11/11] smp: Rename __smp_call_function_single() to smp_call_function_single_async()
Date: Mon, 24 Feb 2014 16:40:02 +0100
Message-Id: <1393256402-16907-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name __smp_call_function_single() doesn't tell much about the
properties of this function, especially when compared to
smp_call_function_single().

The comments above the implementation are also misleading. The main
point of this function is actually not to be able to embed the csd
in an object. This is actually a requirement that result from the
purpose of this function which is to raise an IPI asynchronously.

As such it can be called with interrupts disabled. And this feature
comes at the cost of the caller who then needs to serialize the
IPIs on this csd.

Lets rename the function and enhance the comments so that they reflect
these properties.

Suggested-by: Christoph Hellwig <hch@infradead.org>
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
 kernel/smp.c              | 19 +++++++++++++------
 kernel/up.c               |  4 ++--
 net/core/dev.c            |  2 +-
 8 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 62154ed..6468a71 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -353,7 +353,7 @@ void __blk_mq_complete_request(struct request *rq)
 		rq->csd.func = __blk_mq_complete_request_remote;
 		rq->csd.info = rq;
 		rq->csd.flags = 0;
-		__smp_call_function_single(ctx->cpu, &rq->csd);
+		smp_call_function_single_async(ctx->cpu, &rq->csd);
 	} else {
 		rq->q->softirq_done_fn(rq);
 	}
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 6345b7e..ebd6b6f 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -70,7 +70,7 @@ static int raise_blk_irq(int cpu, struct request *rq)
 		data->info = rq;
 		data->flags = 0;
 
-		__smp_call_function_single(cpu, data);
+		smp_call_function_single_async(cpu, data);
 		return 0;
 	}
 
diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 0411594..cb6654b 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -323,7 +323,7 @@ static void cpuidle_coupled_poke(int cpu)
 	struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb, cpu);
 
 	if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poke_pending))
-		__smp_call_function_single(cpu, csd);
+		smp_call_function_single_async(cpu, csd);
 }
 
 /**
diff --git a/include/linux/smp.h b/include/linux/smp.h
index b410a1f..633f5ed 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -50,7 +50,7 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 		smp_call_func_t func, void *info, bool wait,
 		gfp_t gfp_flags);
 
-int __smp_call_function_single(int cpu, struct call_single_data *csd);
+int smp_call_function_single_async(int cpu, struct call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 94e51f7..3fbaeba 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -432,7 +432,7 @@ void hrtick_start(struct rq *rq, u64 delay)
 	if (rq == this_rq()) {
 		__hrtick_restart(rq);
 	} else if (!rq->hrtick_csd_pending) {
-		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd);
+		smp_call_function_single_async(cpu_of(rq), &rq->hrtick_csd);
 		rq->hrtick_csd_pending = 1;
 	}
 }
diff --git a/kernel/smp.c b/kernel/smp.c
index b767631..06d574e 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -238,15 +238,22 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 EXPORT_SYMBOL(smp_call_function_single);
 
 /**
- * __smp_call_function_single(): Run a function on a specific CPU
+ * smp_call_function_single_async(): Run an asynchronous function on a
+ * 			         specific CPU.
  * @cpu: The CPU to run on.
  * @csd: Pre-allocated and setup data structure
  *
- * Like smp_call_function_single(), but allow caller to pass in a
- * pre-allocated data structure. Useful for embedding @data inside
- * other structures, for instance.
+ * Like smp_call_function_single(), but the call is asynchonous and
+ * can thus be done from contexts with disabled interrupts.
+ *
+ * The caller passes his own pre-allocated data structure
+ * (ie: embedded in an object) and is responsible for synchronizing it
+ * such that the IPIs performed on the @csd are strictly serialized.
+ *
+ * NOTE: Be careful, there is unfortunately no current debugging facility to
+ * validate the correctness of this serialization.
  */
-int __smp_call_function_single(int cpu, struct call_single_data *csd)
+int smp_call_function_single_async(int cpu, struct call_single_data *csd)
 {
 	int err = 0;
 
@@ -256,7 +263,7 @@ int __smp_call_function_single(int cpu, struct call_single_data *csd)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(__smp_call_function_single);
+EXPORT_SYMBOL_GPL(smp_call_function_single_async);
 
 /*
  * smp_call_function_any - Run a function on any of the given cpus
diff --git a/kernel/up.c b/kernel/up.c
index 4e199d4..1760bf3 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -22,7 +22,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int __smp_call_function_single(int cpu, struct call_single_data *csd)
+int smp_call_function_single_async(int cpu, struct call_single_data *csd)
 {
 	unsigned long flags;
 
@@ -31,7 +31,7 @@ int __smp_call_function_single(int cpu, struct call_single_data *csd)
 	local_irq_restore(flags);
 	return 0;
 }
-EXPORT_SYMBOL(__smp_call_function_single);
+EXPORT_SYMBOL(smp_call_function_single_async);
 
 int on_each_cpu(smp_call_func_t func, void *info, int wait)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index d648116..1ab5bd8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4130,7 +4130,7 @@ static void net_rps_action_and_irq_enable(struct softnet_data *sd)
 			struct softnet_data *next = remsd->rps_ipi_next;
 
 			if (cpu_online(remsd->cpu))
-				__smp_call_function_single(remsd->cpu,
+				smp_call_function_single_async(remsd->cpu,
 							   &remsd->csd);
 			remsd = next;
 		}
-- 
1.8.3.1

