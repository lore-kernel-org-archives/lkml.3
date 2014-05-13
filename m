Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaEMJDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:03:47 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57936 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759762AbaEMJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:03:41 -0400
Message-ID: <5371DF88.7020409@linux.vnet.ibm.com>
Date: Tue, 13 May 2014 14:32:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] CPU hotplug, stop-machine: Plug race-window that leads
 to "IPI-to-offline-CPU"
References: <20140511203617.17152.21133.stgit@srivatsabhat.in.ibm.com> <20140511203657.17152.79234.stgit@srivatsabhat.in.ibm.com> <20140512205757.GA18959@mtj.dyndns.org>
In-Reply-To: <20140512205757.GA18959@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051309-3864-0000-0000-00000E2BCFF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 02:27 AM, Tejun Heo wrote:
> Hello,
> 
> On Mon, May 12, 2014 at 02:07:04AM +0530, Srivatsa S. Bhat wrote:
>> @@ -189,10 +191,27 @@ static int multi_cpu_stop(void *data)
>>  	do {
>>  		/* Chill out and ensure we re-read multi_stop_state. */
>>  		cpu_relax();
>> +
>> +		/*
>> +		 * In the case of CPU offline, we don't want the other CPUs to
>> +		 * send IPIs to the active_cpu (the one going offline) after it
>> +		 * has disabled interrupts in the _DISABLE_IRQ state (because,
>> +		 * then it will notice the IPIs only after it goes offline). So
>> +		 * we split this state into _INACTIVE and _ACTIVE, and thereby
>> +		 * ensure that the active_cpu disables interrupts only after
>> +		 * the other CPUs do the same thing.
>> +		 */
> 
> It probably would be clearer to first describe what's going on and
> then provide rationale for that.  IOW, state that inactive cpus
> disable irqs first and then explain why that's done.  The above
> paragraph looks somewhat out of place as is.
> 

Ok..

>> +
>>  		if (msdata->state != curstate) {
>>  			curstate = msdata->state;
>>  			switch (curstate) {
>> -			case MULTI_STOP_DISABLE_IRQ:
>> +			case MULTI_STOP_DISABLE_IRQ_INACTIVE:
>> +				if (is_active)
>> +					break;
>> +
>> +				/* Else, fall-through */
>> +
>> +			case MULTI_STOP_DISABLE_IRQ_ACTIVE:
> 
> Wouldn't it be cleaner to do the following?
> 
> 	case MULTI_STOP_DISABLE_IRQ_INACTIVE:
> 		if (!is_active) {
> 			disable;
> 		}
> 		break;
> 	case MULTI_STOP_DISABLE_IRQ_ACTIVE:
> 		if (is_active) {
> 			disable;
> 		}
> 		break;
>

Well, I wrote it this way the first time and later thought of using
the switch fall-through mechanism to avoid the duplication :-)
 
> The duplicated amount is trivial and what's going on would be far
> clearer.
>

But yeah, I agree that the expanded form is less cryptic and hence
better for readability.

How about the updated version below?

Regards,
Srivatsa S. Bhat

-------------------------------------------------------------------

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[PATCH v4 2/2] CPU hotplug, stop-machine: Plug race-window that leads to "IPI-to-offline-CPU"

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
disables its interrupts only *after* the other CPUs do the same thing.
To achieve this, split the _DISABLE_IRQ state into 2 parts:

1st part: MULTI_STOP_DISABLE_IRQ_INACTIVE, where only the non-active CPUs
(i.e., the "other" CPUs) disable their interrupts.

2nd part: MULTI_STOP_DISABLE_IRQ_ACTIVE, where the active CPU (i.e., the
CPU going offline) disables its interrupts.

With this in place, the CPU going offline will always be the last one to
disable interrupts. After this step, no further IPIs can be sent to the
outgoing CPU, since all the other CPUs would be executing the stop-machine
code with interrupts disabled. And by the time stop-machine ends, the CPU
would have gone offline and disappeared from the cpu_online_mask, and hence
future invocations of smp_call_function() and friends will automatically
prune that CPU out. Thus, we can guarantee that no CPU will end up
*inadvertently* sending IPIs to an offline CPU.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/stop_machine.c |   39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 01fbae5..288f7fe 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -130,8 +130,10 @@ enum multi_stop_state {
 	MULTI_STOP_NONE,
 	/* Awaiting everyone to be scheduled. */
 	MULTI_STOP_PREPARE,
-	/* Disable interrupts. */
-	MULTI_STOP_DISABLE_IRQ,
+	/* Disable interrupts on CPUs not in ->active_cpus mask. */
+	MULTI_STOP_DISABLE_IRQ_INACTIVE,
+	/* Disable interrupts on CPUs in ->active_cpus mask. */
+	MULTI_STOP_DISABLE_IRQ_ACTIVE,
 	/* Run the function */
 	MULTI_STOP_RUN,
 	/* Exit */
@@ -189,12 +191,39 @@ static int multi_cpu_stop(void *data)
 	do {
 		/* Chill out and ensure we re-read multi_stop_state. */
 		cpu_relax();
+
+		/*
+		 * We use 2 separate stages to disable interrupts, namely
+		 * _INACTIVE and _ACTIVE, to ensure that the inactive CPUs
+		 * disable their interrupts first, followed by the active CPUs.
+		 *
+		 * This is done to avoid a race in the CPU offline path, which
+		 * can lead to receiving IPIs on the outgoing CPU *after* it
+		 * has gone offline.
+		 *
+		 * During CPU offline, we don't want the other CPUs to send
+		 * IPIs to the active_cpu (the outgoing CPU) *after* it has
+		 * disabled interrupts (because, then it will notice the IPIs
+		 * only after it has gone offline). We can prevent this by
+		 * making the other CPUs disable their interrupts first - that
+		 * way, they will run the stop-machine code with interrupts
+		 * disabled, and hence won't send IPIs after that point.
+		 */
+
 		if (msdata->state != curstate) {
 			curstate = msdata->state;
 			switch (curstate) {
-			case MULTI_STOP_DISABLE_IRQ:
-				local_irq_disable();
-				hard_irq_disable();
+			case MULTI_STOP_DISABLE_IRQ_INACTIVE:
+				if (!is_active) {
+					local_irq_disable();
+					hard_irq_disable();
+				}
+				break;
+			case MULTI_STOP_DISABLE_IRQ_ACTIVE:
+				if (is_active) {
+					local_irq_disable();
+					hard_irq_disable();
+				}
 				break;
 			case MULTI_STOP_RUN:
 				if (is_active)


