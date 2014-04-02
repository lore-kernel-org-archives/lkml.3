Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaDBQ0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:26:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48988 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776AbaDBQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:26:16 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] smp: Non busy-waiting IPI queue
Date: Wed,  2 Apr 2014 18:26:05 +0200
Message-Id: <1396455966-21128-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396455966-21128-1-git-send-email-fweisbec@gmail.com>
References: <1396455966-21128-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IPI users, such as the nohz subsystem, need to be able to send
an async IPI (async = non waiting for any other IPI completion) on
contexts with disabled interrupts. And we want the IPI subsystem to handle
concurrent calls by itself.

Currently the nohz machinery uses the scheduler IPI for this purpose
because it can be triggered from any context and doesn't need any
serialization from the caller. But this is an abuse of a scheduler
fast path. We are bloating it with a job that should use its own IPI.

The current set of IPI functions can't be called when interrupts are
disabled otherwise we risk a deadlock when two CPUs wait for each
other's IPI completion.

OTOH smp_call_function_single_async() can be called when interrupts
are disabled. But then it's up to the caller to serialize the given
IPI. This can't be called concurrently without special care.

So we need a version of the async IPI that takes care of concurrent
calls.

The proposed solution is to synchronize the IPI with a specific flag
that prevents the IPI from being sent if it is already pending but not
yet executed. Ordering is maintained such that, if the IPI is not sent
because it's already pending, we guarantee it will see the new state of
the data we expect it to when it will execute.

This model is close to the irq_work design. It's also partly inspired by
suggestions from Peter Zijlstra.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/smp.h | 12 ++++++++++++
 kernel/smp.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 633f5ed..155dc86 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -29,6 +29,18 @@ extern unsigned int total_cpus;
 int smp_call_function_single(int cpuid, smp_call_func_t func, void *info,
 			     int wait);
 
+struct queue_single_data;
+typedef void (*smp_queue_func_t)(struct queue_single_data *qsd);
+
+struct queue_single_data {
+	struct call_single_data data;
+	smp_queue_func_t func;
+	int pending;
+};
+
+int smp_queue_function_single(int cpuid, smp_queue_func_t func,
+			      struct queue_single_data *qsd);
+
 /*
  * Call a function on all processors
  */
diff --git a/kernel/smp.c b/kernel/smp.c
index 06d574e..bfe7b36 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -265,6 +265,50 @@ int smp_call_function_single_async(int cpu, struct call_single_data *csd)
 }
 EXPORT_SYMBOL_GPL(smp_call_function_single_async);
 
+void generic_smp_queue_function_single_interrupt(void *info)
+{
+	struct queue_single_data *qsd = info;
+
+	WARN_ON_ONCE(xchg(&qsd->pending, 0) != 1);
+	qsd->func(qsd);
+}
+
+/**
+ * smp_queue_function_single - Queue an asynchronous function to run on a
+ * 				specific CPU unless it's already pending.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @qsd: The data contained in the interested object if any
+ *
+ * Like smp_call_function_single_async() but the call to @func is serialized
+ * and won't be queued if it is already pending. In the latter case, ordering
+ * is still guaranteed such that the pending call will sees the new data we
+ * expect it to.
+ *
+ * This must not be called on offline CPUs.
+ *
+ * Returns 0 when @func is successfully queued or already pending, else a negative
+ * status code.
+ */
+int smp_queue_function_single(int cpu, smp_queue_func_t func, struct queue_single_data *qsd)
+{
+	int err;
+
+	if (cmpxchg(&qsd->pending, 0, 1))
+		return 0;
+
+	qsd->func = func;
+
+	preempt_disable();
+	err = generic_exec_single(cpu, &qsd->data, generic_smp_queue_function_single_interrupt, qsd, 0);
+	preempt_enable();
+
+	/* Reset is case of error. This must not be called on offline CPUs */
+	if (err)
+		qsd->pending = 0;
+
+	return err;
+}
+
 /*
  * smp_call_function_any - Run a function on any of the given cpus
  * @mask: The mask of cpus it can run on.
-- 
1.8.3.1

