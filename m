Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaEOTP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:15:28 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:52153 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaEOTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:15:25 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v5 3/3] CPU hotplug,
 smp: Flush any pending IPI callbacks before CPU offline
To: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org
Cc: mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Fri, 16 May 2014 00:44:13 +0530
Message-ID: <20140515191358.19811.70381.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com>
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051519-8256-0000-0000-00000D229962
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During CPU offline, in the stop-machine loop, we use 2 separate stages to
disable interrupts, to ensure that the CPU going offline doesn't get any new
IPIs from the other CPUs after it has gone offline.

However, an IPI sent much earlier might arrive late on the target CPU
(possibly _after_ the CPU has gone offline) due to hardware latencies,
and due to this, the smp-call-function callbacks queued on the outgoing
CPU might not get noticed (and hence not executed) at all.

This is somewhat theoretical, but in any case, it makes sense to explicitly
loop through the call_single_queue and flush any pending callbacks before the
CPU goes completely offline. So, flush the queued smp-call-function callbacks
in the MULTI_STOP_DISABLE_IRQ_ACTIVE stage, after disabling interrupts on the
active CPU. That way, we would have handled all the queued callbacks before
going offline, and also, no new IPIs can be sent by the other CPUs to the
outgoing CPU at that point, because they will all be executing the stop-machine
code with interrupts disabled.

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/smp.h   |    2 ++
 kernel/smp.c          |   32 ++++++++++++++++++++++++++++++++
 kernel/stop_machine.c |   11 +++++++++++
 3 files changed, 45 insertions(+)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 633f5ed..7924191 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -52,6 +52,8 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 
 int smp_call_function_single_async(int cpu, struct call_single_data *csd);
 
+void flush_smp_call_function_queue(void);
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
diff --git a/kernel/smp.c b/kernel/smp.c
index ae45446..3722fd4 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -213,6 +213,38 @@ void generic_smp_call_function_single_interrupt(void)
 }
 
 /*
+ * flush_smp_call_function_queue - Flush any pending smp-call-function
+ * callbacks queued on this CPU (including those for which the source CPU's
+ * IPIs might not have been received on this CPU yet). This is invoked by a
+ * CPU about to go offline, to ensure that all pending IPI functions are run
+ * before it goes completely offline.
+ *
+ * Loop through the call_single_queue and run all the queued functions.
+ * Must be called with interrupts disabled.
+ */
+void flush_smp_call_function_queue(void)
+{
+	struct llist_head *head;
+	struct llist_node *entry;
+	struct call_single_data *csd, *csd_next;
+
+	WARN_ON(!irqs_disabled());
+
+	head = &__get_cpu_var(call_single_queue);
+
+	if (likely(llist_empty(head)))
+		return;
+
+	entry = llist_del_all(head);
+	entry = llist_reverse_order(entry);
+
+	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
+		csd->func(csd->info);
+		csd_unlock(csd);
+	}
+}
+
+/*
  * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 288f7fe..6b3a2f3 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -21,6 +21,7 @@
 #include <linux/smpboot.h>
 #include <linux/atomic.h>
 #include <linux/lglock.h>
+#include <linux/smp.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -224,6 +225,16 @@ static int multi_cpu_stop(void *data)
 					local_irq_disable();
 					hard_irq_disable();
 				}
+
+				/*
+				 * IPIs (from the inactive CPUs) might arrive
+				 * late due to hardware latencies. So flush
+				 * out any pending IPI callbacks explicitly,
+				 * to ensure that the outgoing CPU doesn't go
+				 * offline with work still pending (during
+				 * CPU hotplug).
+				 */
+				flush_smp_call_function_queue();
 				break;
 			case MULTI_STOP_RUN:
 				if (is_active)

