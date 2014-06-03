Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaFCOlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:41:13 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35888 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbaFCOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:40:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/5] irq_work: Implement remote queueing
Date: Tue,  3 Jun 2014 16:40:18 +0200
Message-Id: <1401806420-31018-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq work currently only supports local callbacks. However its code
is mostly ready to run remote callbacks and we have some potential user.

The full nohz subsystem currently open codes its own remote irq work
on top of the scheduler ipi when it wants a CPU to reevaluate its next
tick. However this ad hoc solution bloats the scheduler IPI.

Lets just extend the irq work subsystem to support remote queuing on top
of the generic SMP IPI to handle this kind of user. This shouldn't add
noticeable overhead.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/irq_work.h |  2 ++
 kernel/irq_work.c        | 22 +++++++++++++++++++++-
 kernel/smp.c             |  4 ++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 19ae05d..ae44aa2 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -33,6 +33,8 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 #define DEFINE_IRQ_WORK(name, _f) struct irq_work name = { .func = (_f), }
 
 bool irq_work_queue(struct irq_work *work);
+bool irq_work_queue_on(struct irq_work *work, int cpu);
+
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index a4350d0..42b87cb 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -56,11 +56,31 @@ void __weak arch_irq_work_raise(void)
 }
 
 /*
- * Enqueue the irq_work @entry unless it's already pending
+ * Enqueue the irq_work @work on @cpu unless it's already pending
  * somewhere.
  *
  * Can be re-enqueued while the callback is still in progress.
  */
+bool irq_work_queue_on(struct irq_work *work, int cpu)
+{
+	/* All work should have been flushed before going offline */
+	WARN_ON_ONCE(cpu_is_offline(cpu));
+
+	/* Arch remote IPI send/receive backend aren't NMI safe */
+	WARN_ON_ONCE(in_nmi());
+
+	/* Only queue if not already pending */
+	if (!irq_work_claim(work))
+		return false;
+
+	if (llist_add(&work->llnode, &per_cpu(raised_list, cpu)))
+		native_send_call_func_single_ipi(cpu);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(irq_work_queue_on);
+
+/* Enqueue the irq work @work on the current CPU */
 bool irq_work_queue(struct irq_work *work)
 {
 	/* Only queue if not already pending */
diff --git a/kernel/smp.c b/kernel/smp.c
index 06d574e..ba0d8fd 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -3,6 +3,7 @@
  *
  * (C) Jens Axboe <jens.axboe@oracle.com> 2008
  */
+#include <linux/irq_work.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/kernel.h>
@@ -198,6 +199,9 @@ void generic_smp_call_function_single_interrupt(void)
 		csd->func(csd->info);
 		csd_unlock(csd);
 	}
+
+	/* Handle irq works queued remotely by irq_work_queue_on() */
+	irq_work_run();
 }
 
 /*
-- 
1.8.3.1

