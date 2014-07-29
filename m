Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaG2Mci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:32:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaG2Mch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:32:37 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v4 2/3] trace: process entire stop_critical_timing() on the same CPU
Date: Tue, 29 Jul 2014 14:31:42 +0200
Message-Id: <1406637103-15435-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1406637103-15435-1-git-send-email-pmladek@suse.cz>
References: <1406637103-15435-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupts off latency tracing heavily depends on disabled interrupts.
This is also the case of stop_critical_timings(). There is the following
nested call:

  + stop_critical_timing()
    + check_critical_timing()
      + update_max_tr_single()
	+ ring_buffer_swap_cpu()

, where ring_buffer_swap_cpu() works with disabled interrupts only when
the swap is done for this cpu.

This patch solves the problem by disabling preemption early in
stop_critical_timings() and doing the whole job on the same CPU.

Note that big part was done with disabled preemption even before.
See raw_spin_lock_irqsave() in check_critical_timing(). The extended
scope affects only few fast operations and should not cause any harm
to the system.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/trace/trace_irqsoff.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 9bb104f748d0..1d4eeb304583 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -405,21 +405,26 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	struct trace_array_cpu *data;
 	unsigned long flags;
 
-	cpu = raw_smp_processor_id();
+	/*
+	 * We need to call ring_buffer_swap_cpu() with disabled interrupts.
+	 * Let's make sure that it works with this CPU buffer.
+	 */
+	cpu = get_cpu();
+
 	/* Always clear the tracing cpu on stopping the trace */
 	if (unlikely(per_cpu(tracing_cpu, cpu)))
 		per_cpu(tracing_cpu, cpu) = 0;
 	else
-		return;
+		goto out;
 
 	if (!tracer_enabled || !tracing_is_enabled())
-		return;
+		goto out;
 
 	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 
 	if (unlikely(!data) ||
 	    !data->critical_start || atomic_read(&data->disabled))
-		return;
+		goto out;
 
 	atomic_inc(&data->disabled);
 
@@ -428,6 +433,8 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
 	atomic_dec(&data->disabled);
+out:
+	put_cpu();
 }
 
 /* start and stop critical timings used to for stoppage (in idle) */
-- 
1.8.4

