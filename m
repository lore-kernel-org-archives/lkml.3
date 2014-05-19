Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbaESUYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:24:08 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57068 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbaESUYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:24:06 -0400
Message-ID: <537A6811.50808@linux.vnet.ibm.com>
Date: Tue, 20 May 2014 01:52:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@kernel.org, rusty@rustcorp.com.au, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 UPDATEDv3 3/3] CPU hotplug, smp: Flush any pending IPI
 callbacks before CPU offline
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com> <20140515191358.19811.70381.stgit@srivatsabhat.in.ibm.com> <20140515191938.GB21306@htj.dyndns.org> <537514D3.4060308@linux.vnet.ibm.com> <20140515193656.GM4570@linux.vnet.ibm.com> <537518D6.6030006@linux.vnet.ibm.com> <5379F6BD.1090809@linux.vnet.ibm.com> <20140519161836.GA30387@redhat.com> <537A6060.7070406@linux.vnet.ibm.com>
In-Reply-To: <537A6060.7070406@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051920-6102-0000-0000-0000059C9316
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 01:19 AM, Srivatsa S. Bhat wrote:
> On 05/19/2014 09:48 PM, Oleg Nesterov wrote:
>> On 05/19, Srivatsa S. Bhat wrote:
>>>
>>> However, an IPI sent much earlier might arrive late on the target CPU
>>> (possibly _after_ the CPU has gone offline) due to hardware latencies,
>>> and due to this, the smp-call-function callbacks queued on the outgoing
>>> CPU might not get noticed (and hence not executed) at all.
>>
[...]
>> why do we need it? Can't multi_cpu_stop() just call
>> generic_smp_call_function_single_interrupt() ? This cpu is still online,
>> we should not worry about WARN_ON(!cpu_online()) ?
>>
> 
> Ah, cool idea! :-) I'll use this method and post an updated patch.
> 

--------------------------------------------------------------------

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[PATCH v5 UPDATEDv3 3/3] CPU hotplug, smp: Flush any pending IPI callbacks before CPU offline

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
active CPU. This can be trivially achieved by invoking the
generic_smp_call_function_single_interrupt() function itself (and since the
outgoing CPU is still online at this point, we won't trigger the "IPI to offline
CPU" warning in this function; so we are safe to call it here).

This way, we would have handled all the queued callbacks before going offline,
and also, no new IPIs can be sent by the other CPUs to the outgoing CPU at that
point, because they will all be executing the stop-machine code with interrupts
disabled.

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/smp.h   |    2 ++
 kernel/smp.c          |   17 ++++++++++++++---
 kernel/stop_machine.c |   11 +++++++++++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 633f5ed..e6b090d 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -151,6 +151,8 @@ smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
 
 static inline void kick_all_cpus_sync(void) {  }
 
+static inline void generic_smp_call_function_single_interrupt(void) { }
+
 #endif /* !SMP */
 
 /*
diff --git a/kernel/smp.c b/kernel/smp.c
index 306f818..b765167 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -177,9 +177,18 @@ static int generic_exec_single(int cpu, struct call_single_data *csd,
 	return 0;
 }
 
-/*
- * Invoked by arch to handle an IPI for call function single. Must be
- * called from the arch with interrupts disabled.
+/**
+ * generic_smp_call_function_single_interrupt - Execute SMP IPI callbacks
+ *
+ * Invoked by arch to handle an IPI for call function single.
+ *
+ * This is also invoked by a CPU about to go offline, to flush any pending
+ * smp-call-function callbacks queued on this CPU (including those for which
+ * the source CPU's IPIs might not have been received on this CPU yet).
+ * This ensures that all pending IPI callbacks are run before the CPU goes
+ * completely offline.
+ *
+ * Must be called with interrupts disabled.
  */
 void generic_smp_call_function_single_interrupt(void)
 {
@@ -187,6 +196,8 @@ void generic_smp_call_function_single_interrupt(void)
 	struct call_single_data *csd, *csd_next;
 	static bool warned;
 
+	WARN_ON(!irqs_disabled());
+
 	entry = llist_del_all(&__get_cpu_var(call_single_queue));
 	entry = llist_reverse_order(entry);
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 288f7fe..4069c13 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -21,6 +21,7 @@
 #include <linux/smpboot.h>
 #include <linux/atomic.h>
 #include <linux/lglock.h>
+#include <linux/smp.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -223,6 +224,16 @@ static int multi_cpu_stop(void *data)
 				if (is_active) {
 					local_irq_disable();
 					hard_irq_disable();
+
+					/*
+					 * IPIs (from the inactive CPUs) might
+					 * arrive late due to hardware latencies.
+					 * So flush out any pending IPI callbacks
+					 * explicitly, to ensure that the outgoing
+					 * CPU doesn't go offline with work still
+					 * pending (during CPU hotplug).
+					 */
+					generic_smp_call_function_single_interrupt();
 				}
 				break;
 			case MULTI_STOP_RUN:


