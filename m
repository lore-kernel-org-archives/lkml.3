Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaEOGz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:55:27 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:41983 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaEOGz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:55:26 -0400
Message-ID: <53746492.20701@linux.vnet.ibm.com>
Date: Thu, 15 May 2014 12:24:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, peterz@infradead.org, tglx@linutronix.de,
        mingo@kernel.org, rusty@rustcorp.com.au, akpm@linux-foundation.org,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
References: <20140511203617.17152.21133.stgit@srivatsabhat.in.ibm.com> <20140511203657.17152.79234.stgit@srivatsabhat.in.ibm.com> <20140512205757.GA18959@mtj.dyndns.org> <5371DF88.7020409@linux.vnet.ibm.com> <20140513155717.GE13828@localhost.localdomain>
In-Reply-To: <20140513155717.GE13828@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051506-5816-0000-0000-00000E05A215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 09:27 PM, Frederic Weisbecker wrote:
> On Tue, May 13, 2014 at 02:32:00PM +0530, Srivatsa S. Bhat wrote:
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
> 
> I have no idea about possible IPI latencies due to hardware. But are we sure that a stop
> machine transition state is enough to make sure we get a pending IPI? Shouldn't we have
> some sort of IPI flush in between, like polling on call_single_queue?
> 

That might not be actually required, but the concept of flushing out
all pending work before going offline (irrespective of whether the
outgoing CPU got the corresponding IPIs in time or not) sounds like
a good idea, because we can guarantee that any late IPIs landing on
the CPU (and thus generating the warning) will be completely harmless.

We can empty the call_single_queue after disabling interrupts in
the _ACTIVE stage. That way, we can guarantee that all pending IPI
functions have been executed by the outgoing CPU (even if the
corresponding IPIs come a bit later). Also, no new IPI work can be
assigned to that CPU beyond the _INACTIVE stage.

Thanks for the suggestion, Frederic!

Regards,
Srivatsa S. Bhat

