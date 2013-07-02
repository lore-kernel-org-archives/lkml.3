Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab3GBJgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:36:07 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50941 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3GBJgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:36:04 -0400
Message-ID: <51D29EE5.8080307@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 17:35:33 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com> <51D25A80.8090406@linux.vnet.ibm.com> <20130702085202.GA23916@twins.programming.kicks-ass.net>
In-Reply-To: <20130702085202.GA23916@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070209-8256-0000-0000-0000082DAF18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

Thanks for your review :)

On 07/02/2013 04:52 PM, Peter Zijlstra wrote:
[snip]
>> +static void record_wakee(struct task_struct *p)
>> +{
>> +	/*
>> +	 * Rough decay, don't worry about the boundary, really active
>> +	 * task won't care the loose.
>> +	 */
> 
> OK so we 'decay' once a second.
> 
>> +	if (jiffies > current->last_switch_decay + HZ) {
>> +		current->nr_wakee_switch = 0;
>> +		current->last_switch_decay = jiffies;
>> +	}
> 
> This isn't so much a decay as it is wiping state. Did you try an actual
> decay -- something like: current->nr_wakee_switch >>= 1; ?
> 
> I suppose you wanted to avoid something like:
> 
>   now = jiffies;
>   while (now > current->last_switch_decay + HZ) {
>   	current->nr_wakee_switch >>= 1;
> 	current->last_switch_decay += HZ;
>   }

Right, actually I have though about the decay problem with some testing,
including some similar implementations like this, but one issue I could
not solve is:

	the task waken up after dequeue 10secs and the task waken up
	after dequeue 1sec will suffer the same decay.

Thus, in order to keep fair, we have to do some calculation here to make
the decay correct, but that means cost...

So I pick this wiping method, and the cost performance is not so bad :)

> 
> ?
> 
> And we increment every time we wake someone else. Gaining a measure of
> how often we wake someone else.
> 
>> +	if (current->last_wakee != p) {
>> +		current->last_wakee = p;
>> +		current->nr_wakee_switch++;
>> +	}
>> +}
>> +
>> +static int nasty_pull(struct task_struct *p)
> 
> I've seen there's some discussion as to this function name.. good :-) It
> really wants to change. How about something like:
> 
> int wake_affine()
> {
>   ...
> 
>   /*
>    * If we wake multiple tasks be careful to not bounce
>    * ourselves around too much.
>    */
>   if (wake_wide(p))
>   	return 0;

Do you mean wake_wipe() here?

> 
> 
>> +{
>> +	int factor = cpumask_weight(cpu_online_mask);
> 
> We have num_cpus_online() for this.. however both are rather expensive.
> Having to walk and count a 4096 bitmap for every wakeup if going to get
> tiresome real quick.
> 
> I suppose the question is; to what level do we really want to scale?
> 
> One fair answer would be node size I suppose; do you really want to go
> bigger than that?

Agree, it sounds more reasonable, let me do some testing on it.

> 
> Also; you compare a size against a switching frequency, that's not
> really and apples to apples comparison.
> 
>> +
>> +	/*
>> +	 * Yeah, it's the switching-frequency, could means many wakee or
>> +	 * rapidly switch, use factor here will just help to automatically
>> +	 * adjust the loose-degree, so more cpu will lead to more pull.
>> +	 */
>> +	if (p->nr_wakee_switch > factor) {
>> +		/*
>> +		 * wakee is somewhat hot, it needs certain amount of cpu
>> +		 * resource, so if waker is far more hot, prefer to leave
>> +		 * it alone.
>> +		 */
>> +		if (current->nr_wakee_switch > (factor * p->nr_wakee_switch))
>> +			return 1;
> 
> Ah ok, this makes more sense; the first is simply a filter to avoid
> doing the second dereference I suppose.

Yeah, the first one is some kind of vague filter, the second one is the
core filter ;-)

> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>>  {
>>  	s64 this_load, load;
>> @@ -3118,6 +3157,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>>  	unsigned long weight;
>>  	int balanced;
>>  
>> +	if (nasty_pull(p))
>> +		return 0;
>> +
>>  	idx	  = sd->wake_idx;
>>  	this_cpu  = smp_processor_id();
>>  	prev_cpu  = task_cpu(p);
>> @@ -3410,6 +3452,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>>  		/* while loop will break here if sd == NULL */
>>  	}
>>  unlock:
>> +	if (sd_flag & SD_BALANCE_WAKE)
>> +		record_wakee(p);
> 
> if we put this in task_waking_fair() we can avoid an entire conditional!

Nice, will do it in next version :)

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

