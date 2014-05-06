Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaEFWC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:02:57 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40332 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaEFWCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:02:55 -0400
Message-ID: <53695BCF.5040504@linux.vnet.ibm.com>
Date: Wed, 07 May 2014 03:31:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        rusty@rustcorp.com.au, fweisbec@gmail.com, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] CPU hotplug, stop-machine: Plug race-window that leads
 to "IPI-to-offline-CPU"
References: <20140506180213.14375.5904.stgit@srivatsabhat.in.ibm.com> <20140506180258.14375.20181.stgit@srivatsabhat.in.ibm.com> <20140506134054.8cd531296c8aa5d9c3eff958@linux-foundation.org> <20140506204248.GH27738@htj.dyndns.org> <536953C4.8030201@linux.vnet.ibm.com>
In-Reply-To: <536953C4.8030201@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050622-1618-0000-0000-0000002EE16B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>>> The code comments are a bit lame.  Can we do a better job of explaining
>>> the overall dynamic behaviour?  Help readers to understand the problem
>>> which hold_active_cpus() is solving and how it solves it?
>>
>> Does it even need to be a separate function?  I kinda really dislike
>> trivial helpers which are used only once.  It obfuscates more than
>> helping anything.  I think proper comment where the actual
>> synchronization is happening along with open coded wait would be
>> easier to follow.
>>
> 
> Ok, I'll open code it and add an appropriate comment explaining the
> synchronization.
> 

How about this?

---------------------------------------------------------------------------

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[PATCH v2 2/2] CPU hotplug, stop-machine: Plug race-window that leads to "IPI-to-offline-CPU"

During CPU offline, stop-machine is used to take control over all the online
CPUs (via the per-cpu stopper thread) and then run take_cpu_down() on the CPU
that is to be taken offline.

But stop-machine itself has several stages: _PREPARE, _DISABLE_IRQ, _RUN etc.
The important thing to note here is that the _DISABLE_IRQ stage comes much
later after starting stop-machine, and hence there is a large window where
other CPUs can send IPIs to the CPU going offline. As a result, we can
encounter a scenario as depicted below, which causes IPIs to be sent to the
CPU going offline, and that CPU notices them *after* it has gone offline,
triggering the "IPI-to-offline-CPU" warning from the smp-call-function code.


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



So, as we can observe from this scenario, the IPI was sent when CPU 2 was
still online, and hence it was perfectly legal. But unfortunately it was
noted only after CPU 2 went offline, resulting in the warning from the
IPI handling code. In other words, the fault was not at the sender, but
at the receiver side - and if we look closely, the real bug is in the
stop-machine sequence itself.

The problem here is that the CPU going offline disabled its local interrupts
(by entering _DISABLE_IRQ phase) *before* the other CPUs. And that's the
reason why it was not able to respond to the IPI before going offline.

A simple solution to this problem is to ensure that the CPU going offline
*follows* all other CPUs while entering each subsequent phase within
stop-machine. In particular, all other CPUs will enter the _DISABLE_IRQ
phase and disable their local interrupts, and only *then*, the CPU going
offline will follow suit. Since the other CPUs are executing the stop-machine
code with interrupts disabled, they won't send any IPIs at all, at that
point. And by the time stop-machine ends, the CPU would have gone offline
and disappeared from the cpu_online_mask, and hence future invocations of
smp_call_function() and friends will automatically prune that CPU out.
Thus, we can guarantee that no CPU will end up *inadvertently* sending
IPIs to an offline CPU.

We can implement this by introducing a "holding area" for the CPUs marked
as 'active_cpus', and use this infrastructure to let the other CPUs
progress from one stage to the next, before allowing the active_cpus to
do the same thing.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/stop_machine.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 01fbae5..7abb361 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -165,12 +165,13 @@ static void ack_state(struct multi_stop_data *msdata)
 		set_state(msdata, msdata->state + 1);
 }
 
+
 /* This is the cpu_stop function which stops the CPU. */
 static int multi_cpu_stop(void *data)
 {
 	struct multi_stop_data *msdata = data;
 	enum multi_stop_state curstate = MULTI_STOP_NONE;
-	int cpu = smp_processor_id(), err = 0;
+	int cpu = smp_processor_id(), num_active_cpus, err = 0;
 	unsigned long flags;
 	bool is_active;
 
@@ -180,15 +181,38 @@ static int multi_cpu_stop(void *data)
 	 */
 	local_save_flags(flags);
 
-	if (!msdata->active_cpus)
+	if (!msdata->active_cpus) {
 		is_active = cpu == cpumask_first(cpu_online_mask);
-	else
+		num_active_cpus = 1;
+	} else {
 		is_active = cpumask_test_cpu(cpu, msdata->active_cpus);
+		num_active_cpus = cpumask_weight(msdata->active_cpus);
+	}
 
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read multi_stop_state. */
 		cpu_relax();
+
+		/*
+		 * In the case of CPU offline, we don't want the other CPUs to
+		 * send IPIs to the active_cpu (the one going offline) after it
+		 * has entered the _DISABLE_IRQ state (because, then it will
+		 * notice the IPIs only after it goes offline). So ensure that
+		 * the active_cpu always follows the others while entering
+		 * each subsequent state in this state-machine.
+		 *
+		 * msdata->thread_ack tracks the number of CPUs that are yet to
+		 * move to the next state, during each transition. So make the
+		 * active_cpu(s) wait until ->thread_ack indicates that the
+		 * active_cpus are the only ones left to complete the transition.
+		 */
+		if (is_active) {
+			/* Wait until all the non-active threads ack the state */
+			while (atomic_read(&msdata->thread_ack) > num_active_cpus)
+				cpu_relax();
+		}
+
 		if (msdata->state != curstate) {
 			curstate = msdata->state;
 			switch (curstate) {


