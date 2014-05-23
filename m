Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaEWOqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:46:50 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:47348 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaEWOqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:46:48 -0400
Message-ID: <537F5F0F.5050802@linux.vnet.ibm.com>
Date: Fri, 23 May 2014 20:15:35 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com> <20140523101216.17924.62447.stgit@srivatsabhat.in.ibm.com> <20140523132250.GA1768@localhost.localdomain>
In-Reply-To: <20140523132250.GA1768@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052314-5816-0000-0000-00000E30B4DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 06:52 PM, Frederic Weisbecker wrote:
> On Fri, May 23, 2014 at 03:42:20PM +0530, Srivatsa S. Bhat wrote:
>> During CPU offline, stop-machine is used to take control over all the online
>> CPUs (via the per-cpu stopper thread) and then run take_cpu_down() on the CPU
>> that is to be taken offline.
>>
>> But stop-machine itself has several stages: _PREPARE, _DISABLE_IRQ, _RUN etc.
>> The important thing to note here is that the _DISABLE_IRQ stage comes much
>> later after starting stop-machine, and hence there is a large window where
>> other CPUs can send IPIs to the CPU going offline. As a result, we can
>> encounter a scenario as depicted below, which causes IPIs to be sent to the
>> CPU going offline, and that CPU notices them *after* it has gone offline,
>> triggering the "IPI-to-offline-CPU" warning from the smp-call-function code.
>>
>>
>>               CPU 1                                         CPU 2
>>           (Online CPU)                               (CPU going offline)
>>
>>        Enter _PREPARE stage                          Enter _PREPARE stage
>>
>>                                                      Enter _DISABLE_IRQ stage
>>
>>
>>                                                    =
>>        Got a device interrupt,                     | Didn't notice the IPI
>>        and the interrupt handler                   | since interrupts were
>>        called smp_call_function()                  | disabled on this CPU.
>>        and sent an IPI to CPU 2.                   |
>>                                                    =
>>
>>
>>        Enter _DISABLE_IRQ stage
>>
>>
>>        Enter _RUN stage                              Enter _RUN stage
>>
>>                                   =
>>        Busy loop with interrupts  |                  Invoke take_cpu_down()
>>        disabled.                  |                  and take CPU 2 offline
>>                                   =
>>
>>
>>        Enter _EXIT stage                             Enter _EXIT stage
>>
>>        Re-enable interrupts                          Re-enable interrupts
>>
>>                                                      The pending IPI is noted
>>                                                      immediately, but alas,
>>                                                      the CPU is offline at
>>                                                      this point.
>>
>>
>>
>> So, as we can observe from this scenario, the IPI was sent when CPU 2 was
>> still online, and hence it was perfectly legal. But unfortunately it was
>> noted only after CPU 2 went offline, resulting in the warning from the
>> IPI handling code. In other words, the fault was not at the sender, but
>> at the receiver side - and if we look closely, the real bug is in the
>> stop-machine sequence itself.
>>
>> The problem here is that the CPU going offline disabled its local interrupts
>> (by entering _DISABLE_IRQ phase) *before* the other CPUs. And that's the
>> reason why it was not able to respond to the IPI before going offline.
>>
>> A simple solution to this problem is to ensure that the CPU going offline
>> disables its interrupts only *after* the other CPUs do the same thing.
>> To achieve this, split the _DISABLE_IRQ state into 2 parts:
>>
>> 1st part: MULTI_STOP_DISABLE_IRQ_INACTIVE, where only the non-active CPUs
>> (i.e., the "other" CPUs) disable their interrupts.
>>
>> 2nd part: MULTI_STOP_DISABLE_IRQ_ACTIVE, where the active CPU (i.e., the
>> CPU going offline) disables its interrupts.
>>
>> With this in place, the CPU going offline will always be the last one to
>> disable interrupts. After this step, no further IPIs can be sent to the
>> outgoing CPU, since all the other CPUs would be executing the stop-machine
>> code with interrupts disabled. And by the time stop-machine ends, the CPU
>> would have gone offline and disappeared from the cpu_online_mask, and hence
>> future invocations of smp_call_function() and friends will automatically
>> prune that CPU out. Thus, we can guarantee that no CPU will end up
>> *inadvertently* sending IPIs to an offline CPU.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  kernel/stop_machine.c |   39 ++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 34 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
>> index 01fbae5..288f7fe 100644
>> --- a/kernel/stop_machine.c
>> +++ b/kernel/stop_machine.c
>> @@ -130,8 +130,10 @@ enum multi_stop_state {
>>  	MULTI_STOP_NONE,
>>  	/* Awaiting everyone to be scheduled. */
>>  	MULTI_STOP_PREPARE,
>> -	/* Disable interrupts. */
>> -	MULTI_STOP_DISABLE_IRQ,
>> +	/* Disable interrupts on CPUs not in ->active_cpus mask. */
>> +	MULTI_STOP_DISABLE_IRQ_INACTIVE,
>> +	/* Disable interrupts on CPUs in ->active_cpus mask. */
>> +	MULTI_STOP_DISABLE_IRQ_ACTIVE,
>>  	/* Run the function */
>>  	MULTI_STOP_RUN,
>>  	/* Exit */
>> @@ -189,12 +191,39 @@ static int multi_cpu_stop(void *data)
>>  	do {
>>  		/* Chill out and ensure we re-read multi_stop_state. */
>>  		cpu_relax();
>> +
>> +		/*
>> +		 * We use 2 separate stages to disable interrupts, namely
>> +		 * _INACTIVE and _ACTIVE, to ensure that the inactive CPUs
>> +		 * disable their interrupts first, followed by the active CPUs.
>> +		 *
>> +		 * This is done to avoid a race in the CPU offline path, which
>> +		 * can lead to receiving IPIs on the outgoing CPU *after* it
>> +		 * has gone offline.
>> +		 *
>> +		 * During CPU offline, we don't want the other CPUs to send
>> +		 * IPIs to the active_cpu (the outgoing CPU) *after* it has
>> +		 * disabled interrupts (because, then it will notice the IPIs
>> +		 * only after it has gone offline). We can prevent this by
>> +		 * making the other CPUs disable their interrupts first - that
>> +		 * way, they will run the stop-machine code with interrupts
>> +		 * disabled, and hence won't send IPIs after that point.
>> +		 */
>> +
>>  		if (msdata->state != curstate) {
>>  			curstate = msdata->state;
>>  			switch (curstate) {
>> -			case MULTI_STOP_DISABLE_IRQ:
>> -				local_irq_disable();
>> -				hard_irq_disable();
>> +			case MULTI_STOP_DISABLE_IRQ_INACTIVE:
>> +				if (!is_active) {
>> +					local_irq_disable();
>> +					hard_irq_disable();
>> +				}
>> +				break;
>> +			case MULTI_STOP_DISABLE_IRQ_ACTIVE:
>> +				if (is_active) {
>> +					local_irq_disable();
>> +					hard_irq_disable();
>> +				}
> 
> Do we actually need that now that we are flushing the ipi queue on CPU dying?
> 

Yes, we do. Flushing the IPI queue is one thing - it guarantees that a CPU
doesn't go offline without finishing its work. Not receiving IPIs after going
offline is a different thing - it helps avoid warnings from the IPI handling
code (although it will be harmless if the queue had been flushed earlier).

So I think it is good to have both, so that we can keep CPU offline very
clean - no pending work left around, as well as no possibility of (real or
spurious) warnings.

Regards,
Srivatsa S. Bhat

