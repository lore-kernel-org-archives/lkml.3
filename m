Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaEZLKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:10:23 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:50540 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaEZLKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:10:20 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v7 2/2] CPU hotplug,
 smp: Flush any pending IPI callbacks before CPU offline
To: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org
Cc: mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 26 May 2014 16:38:38 +0530
Message-ID: <20140526110831.16203.25130.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140526110743.16203.18186.stgit@srivatsabhat.in.ibm.com>
References: <20140526110743.16203.18186.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052611-1396-0000-0000-000004E8D3F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During CPU offline, in stop-machine, we don't enforce any rule in the
_DISABLE_IRQ stage, regarding the order in which the outgoing CPU and the other
CPUs disable their local interrupts. Hence, we can encounter a scenario as
depicted below, in which IPIs are sent by the other CPUs to the CPU going
offline (while it is *still* online), but the outgoing CPU notices them only
*after* it has gone offline.


              CPU 1                                         CPU 2
          (Online CPU)                               (CPU going offline)

       Enter _PREPARE stage                          Enter _PREPARE stage

                                                     Enter _DISABLE_IRQ stage


                                                   =
       Got a device interrupt,                     | Didn't notice the IPI
       and the interrupt handler                   | since interrupts were
       called smp_call_function()                  | disabled on this CPU.
       and sent an IPI to CPU 2.                   |
                                                   =


       Enter _DISABLE_IRQ stage


       Enter _RUN stage                              Enter _RUN stage

                                  =
       Busy loop with interrupts  |                  Invoke take_cpu_down()
       disabled.                  |                  and take CPU 2 offline
                                  =


       Enter _EXIT stage                             Enter _EXIT stage

       Re-enable interrupts                          Re-enable interrupts

                                                     The pending IPI is noted
                                                     immediately, but alas,
                                                     the CPU is offline at
                                                     this point.



This of course, makes the smp-call-function IPI handler code unhappy and it
complains about "receiving an IPI on an offline CPU".

However, if we look closely, we observe that the IPI was sent when CPU 2 was
still online, and hence it was perfectly legal for CPU 1 to send the IPI at
that point. Furthermore, receiving an IPI on an offline CPU is terrible only
if there were pending callbacks yet to be executed by that CPU (in other words,
its a bug if the CPU went offline with work still pending).

So, fix this by flushing all the queued smp-call-function callbacks on the
outgoing CPU in the CPU_DYING stage[1], including those callbacks for which the
source CPU's IPIs might not have been received on the outgoing CPU yet. This
ensures that all pending IPI callbacks are run before the CPU goes completely
offline. But note that the outgoing CPU can still get IPIs from the other CPUs
just after it exits stop-machine, due to the scenario mentioned above. But
because we flush the callbacks before going offline, this will be completely
harmless.

Further, this solution also guarantees that there will be pending callbacks
on an offline CPU *only if* the source CPU initiated the IPI-send-procedure
*after* the target CPU went offline, which clearly indicates a bug in the
sender code.

So, considering all this, teach the smp-call-function IPI handler code to
complain only if an offline CPU received an IPI *and* it still had pending
callbacks to execute, since that is the only buggy scenario.

There is another case (somewhat theoretical though) where IPIs might arrive
late on the target CPU (possibly _after_ the CPU has gone offline): due to IPI
latencies in the hardware. But with this patch, even this scenario turns out
to be harmless, since we explicitly loop through the call_single_queue and
flush out any pending callbacks without waiting for the corresponding IPIs
to arrive.


[1]. The CPU_DYING part needs a little more explanation: by the time we
execute the CPU_DYING notifier callbacks, the CPU would have already been
marked offline. But we want to flush out the pending callbacks at this stage,
ignoring the fact that the CPU is offline. So restructure the IPI handler
code so that we can by-pass the "is-cpu-offline?" check in this particular
case. (Of course, the right solution here is to fix CPU hotplug to mark the
CPU offline _after_ invoking the CPU_DYING notifiers, but this requires a
lot of audit to ensure that this change doesn't break any existing code;
hence lets go with the solution proposed above until that is done).

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/smp.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 306f818..5295388 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -29,6 +29,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct llist_head, call_single_queue);
 
+static void flush_smp_call_function_queue(bool warn_cpu_offline);
+
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
@@ -52,6 +54,20 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		/*
+		 * The IPIs for the smp-call-function callbacks queued by other
+		 * CPUs might arrive late, either due to hardware latencies or
+		 * because this CPU disabled interrupts (inside stop-machine)
+		 * before the IPIs were sent. So flush out any pending callbacks
+		 * explicitly (without waiting for the IPIs to arrive), to
+		 * ensure that the outgoing CPU doesn't go offline with work
+		 * still pending.
+		 */
+		flush_smp_call_function_queue(false);
+		break;
+
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
@@ -177,23 +193,47 @@ static int generic_exec_single(int cpu, struct call_single_data *csd,
 	return 0;
 }
 
-/*
- * Invoked by arch to handle an IPI for call function single. Must be
- * called from the arch with interrupts disabled.
+/**
+ * generic_smp_call_function_single_interrupt - Execute SMP IPI callbacks
+ *
+ * Invoked by arch to handle an IPI for call function single.
+ * Must be called with interrupts disabled.
  */
 void generic_smp_call_function_single_interrupt(void)
 {
+	flush_smp_call_function_queue(true);
+}
+
+/**
+ * flush_smp_call_function_queue - Flush pending smp-call-function callbacks
+ *
+ * @warn_cpu_offline: If set to 'true', warn if callbacks were queued on an
+ * 		      offline CPU. Skip this check if set to 'false'.
+ *
+ * Flush any pending smp-call-function callbacks queued on this CPU. This is
+ * invoked by the generic IPI handler, as well as by a CPU about to go offline,
+ * to ensure that all pending IPI functions are run before it goes completely
+ * offline.
+ *
+ * Loop through the call_single_queue and run all the queued functions.
+ * Must be called with interrupts disabled.
+ */
+static void flush_smp_call_function_queue(bool warn_cpu_offline)
+{
+	struct llist_head *head;
 	struct llist_node *entry;
 	struct call_single_data *csd, *csd_next;
 	static bool warned;
 
-	entry = llist_del_all(&__get_cpu_var(call_single_queue));
+	WARN_ON(!irqs_disabled());
+
+	head = &__get_cpu_var(call_single_queue);
+	entry = llist_del_all(head);
 	entry = llist_reverse_order(entry);
 
-	/*
-	 * Shouldn't receive this interrupt on a cpu that is not yet online.
-	 */
-	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
+	/* There shouldn't be any pending callbacks on an offline CPU. */
+	if (unlikely(warn_cpu_offline && !cpu_online(smp_processor_id()) &&
+		     !warned && !llist_empty(head))) {
 		warned = true;
 		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
 

