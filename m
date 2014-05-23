Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaEWPZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:25:54 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:41222 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaEWPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:25:53 -0400
Message-ID: <537F6821.6050104@linux.vnet.ibm.com>
Date: Fri, 23 May 2014 20:54:17 +0530
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
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com> <20140523101216.17924.62447.stgit@srivatsabhat.in.ibm.com> <20140523132250.GA1768@localhost.localdomain> <537F5F0F.5050802@linux.vnet.ibm.com> <20140523150447.GG1768@localhost.localdomain>
In-Reply-To: <20140523150447.GG1768@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052315-2674-0000-0000-00000009E2A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 08:34 PM, Frederic Weisbecker wrote:
> On Fri, May 23, 2014 at 08:15:35PM +0530, Srivatsa S. Bhat wrote:
>> On 05/23/2014 06:52 PM, Frederic Weisbecker wrote:
>>> On Fri, May 23, 2014 at 03:42:20PM +0530, Srivatsa S. Bhat wrote:
>>>> During CPU offline, stop-machine is used to take control over all the online
>>>> CPUs (via the per-cpu stopper thread) and then run take_cpu_down() on the CPU
>>>> that is to be taken offline.
>>>>
[...]
>>>>  kernel/stop_machine.c |   39 ++++++++++++++++++++++++++++++++++-----
>>>>  1 file changed, 34 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
>>>> index 01fbae5..288f7fe 100644
>>>> --- a/kernel/stop_machine.c
>>>> +++ b/kernel/stop_machine.c
>>>> @@ -130,8 +130,10 @@ enum multi_stop_state {
>>>>  	MULTI_STOP_NONE,
>>>>  	/* Awaiting everyone to be scheduled. */
>>>>  	MULTI_STOP_PREPARE,
>>>> -	/* Disable interrupts. */
>>>> -	MULTI_STOP_DISABLE_IRQ,
>>>> +	/* Disable interrupts on CPUs not in ->active_cpus mask. */
>>>> +	MULTI_STOP_DISABLE_IRQ_INACTIVE,
>>>> +	/* Disable interrupts on CPUs in ->active_cpus mask. */
>>>> +	MULTI_STOP_DISABLE_IRQ_ACTIVE,
>>>>  	/* Run the function */
>>>>  	MULTI_STOP_RUN,
>>>>  	/* Exit */
>>>> @@ -189,12 +191,39 @@ static int multi_cpu_stop(void *data)
>>>>  	do {
>>>>  		/* Chill out and ensure we re-read multi_stop_state. */
>>>>  		cpu_relax();
>>>> +
>>>> +		/*
>>>> +		 * We use 2 separate stages to disable interrupts, namely
>>>> +		 * _INACTIVE and _ACTIVE, to ensure that the inactive CPUs
>>>> +		 * disable their interrupts first, followed by the active CPUs.
>>>> +		 *
>>>> +		 * This is done to avoid a race in the CPU offline path, which
>>>> +		 * can lead to receiving IPIs on the outgoing CPU *after* it
>>>> +		 * has gone offline.
>>>> +		 *
>>>> +		 * During CPU offline, we don't want the other CPUs to send
>>>> +		 * IPIs to the active_cpu (the outgoing CPU) *after* it has
>>>> +		 * disabled interrupts (because, then it will notice the IPIs
>>>> +		 * only after it has gone offline). We can prevent this by
>>>> +		 * making the other CPUs disable their interrupts first - that
>>>> +		 * way, they will run the stop-machine code with interrupts
>>>> +		 * disabled, and hence won't send IPIs after that point.
>>>> +		 */
>>>> +
>>>>  		if (msdata->state != curstate) {
>>>>  			curstate = msdata->state;
>>>>  			switch (curstate) {
>>>> -			case MULTI_STOP_DISABLE_IRQ:
>>>> -				local_irq_disable();
>>>> -				hard_irq_disable();
>>>> +			case MULTI_STOP_DISABLE_IRQ_INACTIVE:
>>>> +				if (!is_active) {
>>>> +					local_irq_disable();
>>>> +					hard_irq_disable();
>>>> +				}
>>>> +				break;
>>>> +			case MULTI_STOP_DISABLE_IRQ_ACTIVE:
>>>> +				if (is_active) {
>>>> +					local_irq_disable();
>>>> +					hard_irq_disable();
>>>> +				}
>>>
>>> Do we actually need that now that we are flushing the ipi queue on CPU dying?
>>>
>>
>> Yes, we do. Flushing the IPI queue is one thing - it guarantees that a CPU
>> doesn't go offline without finishing its work. Not receiving IPIs after going
>> offline is a different thing - it helps avoid warnings from the IPI handling
>> code (although it will be harmless if the queue had been flushed earlier).
> 
> I'm confused. Perhaps I don't understand well how things mix up. How does it avoid the warning.
> Isn't there still a risk that some IPI don't fire due to hardware latency.
> 
> I mean either we do:
> 
>     local_irq_enable()
>     wait_for_pending_ipi()
>     local_irq_disable()
> 
> Or we do
> 
>     hotplug_cpu_down {
>         flush_ipi()
>     }
> 
> But something in between looks broken:
> 
>     local_irq_disable()
>     local_irq_enable()
> 
>     flush_ipi()
> 
> 
>>
>> So I think it is good to have both, so that we can keep CPU offline very
>> clean - no pending work left around, as well as no possibility of (real or
>> spurious) warnings.
> 
> Ah may be what you want to avoid is this:
> 
>     CPU 0               CPU 1
>     -------------------------
> 
>     send IPI to 1
> 
>                         flush_ipi()
>                         set_cpu_offline()
>                         get_ipi()
>                         //get late IPI but queue is flushed already
>                         smp_single_function_interrupt() {
>                                WARN()
> 
> Yeah but still, your patch doesn't deal with late hardware IPI.
> How about we move the warning to the IPI callback iterator:
> 
> -       WARN_ON_ONCE(cpu_is_offline())
> 
>         llist_for_each(...) {
> +            WARN_ON_ONCE(cpu_is_offline())
>              csd->func()
>         }
> 
> Since what matters is that all functions are executed before going offline.
> 

Right, we can't do anything about getting late IPIs, but we need to warn
only if there really was work to be done and the CPU is already offline.
What you suggested above will take care of that. I'll incorporate this in
an updated patch, thank you!

Regards,
Srivatsa S. Bhat

