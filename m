Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaG1RiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:38:01 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34474 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaG1Rh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:37:57 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 05/10] smp: Fast path check on IPI list
Date: Mon, 28 Jul 2014 19:37:31 +0200
Message-Id: <1406569056-30217-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we enqueue a remote irq work, we trigger the same IPI as those
raised by smp_call_function_*() family.

So when we receive such IPI, we check both irq_work and smp_call_function
queues. Thus if we trigger a remote irq work, we'll likely find the
smp_call_function queue empty unless we collide with concurrent enqueuers
but the probability is low.

Meanwhile, checking the smp_call_function queue can be costly because
we use llist_del_all() which relies on cmpxchg().

We can reduce this overhead by doing a fast path check with llist_empty().
Given the implicit IPI ordering:

       Enqueuer                            Dequeuer
       ---------                           --------
       llist_add(csd, queue)               get_IPI() {
       send_IPI()                              if (llist_empty(queue)
                                                    ...
When the IPI is sent, we are guaranteed that the IPI receiver will
see the new csd.

So lets do the fast path check to optimize non smp_call_function() related
jobs.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/smp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 12c5bea..09ddc92 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -184,11 +184,19 @@ static int generic_exec_single(int cpu, struct call_single_data *csd,
  */
 void generic_smp_call_function_single_interrupt(void)
 {
+	struct llist_head *head = &__get_cpu_var(call_single_queue);
 	struct llist_node *entry;
 	struct call_single_data *csd, *csd_next;
 	static bool warned;
 
-	entry = llist_del_all(&__get_cpu_var(call_single_queue));
+	/*
+	 * Fast check: in case of irq work remote queue, the IPI list
+	 * is likely empty. We can spare the expensive llist_del_all().
+	 */
+	if (llist_empty(head))
+		goto irq_work;
+
+	entry = llist_del_all(head);
 	entry = llist_reverse_order(entry);
 
 	/*
@@ -212,6 +220,7 @@ void generic_smp_call_function_single_interrupt(void)
 		csd_unlock(csd);
 	}
 
+irq_work:
 	/*
 	 * Handle irq works queued remotely by irq_work_queue_on().
 	 * Smp functions above are typically synchronous so they
-- 
1.8.3.1

