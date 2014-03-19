Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaCSS2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:28:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47688 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaCSS2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:28:30 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jens Axboe <axboe@fb.com>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] smp: Non busy-waiting IPI queue
Date: Wed, 19 Mar 2014 19:28:20 +0100
Message-Id: <1395253702-12489-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395253702-12489-1-git-send-email-fweisbec@gmail.com>
References: <1395253702-12489-1-git-send-email-fweisbec@gmail.com>
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
Cc: Jens Axboe <axboe@fb.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/smp.h | 12 ++++++++++++
 kernel/smp.c        | 24 ++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

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
index 06d574e..57529f9 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -265,6 +265,30 @@ int smp_call_function_single_async(int cpu, struct call_single_data *csd)
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
+	return err;
+}
+
 /*
  * smp_call_function_any - Run a function on any of the given cpus
  * @mask: The mask of cpus it can run on.
-- 
1.8.3.1

