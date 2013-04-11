Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936511Ab3DKVWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:22:40 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:57888 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935697Ab3DKVWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:22:38 -0400
Message-ID: <516728F6.4090701@linux.vnet.ibm.com>
Date: Fri, 12 Apr 2013 02:49:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <51670C17.8070608@linux.vnet.ibm.com> <alpine.LFD.2.02.1304112158040.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304112158040.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041121-8878-0000-0000-000006AB13A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 02:17 AM, Thomas Gleixner wrote:
> Srivatsa,
> 
> On Fri, 12 Apr 2013, Srivatsa S. Bhat wrote:
>> On 04/09/2013 08:08 PM, Thomas Gleixner wrote:
>>> Add a new task state (TASK_PARKED) which prevents other wakeups and
>>> use this state explicitely for the unpark wakeup.
>>>
>>
>> Again, I think this is unnecessary. We are good as long as no one other
>> than the unpark code can kick the kthreads out of the loop in the park
>> code. Now that I understand the race you explained above, why not just
>> fix that race itself by reversing the ordering of clear(SHOULD_PARK)
>> and bind_to(CPU2)? That way, even if someone else wakes up the per-cpu
>> kthread, it will just remain confined to the park code, as intended.
> 
> In theory.
> 
>> A patch like below should do it IMHO. I guess I'm being a little too
>> persistent, sorry!
> 
> No it's not about being persistent, you're JUST too much into voodoo
> programming instead of going for the straight forward and robust
> solutions.
> 
> Darn, I hate it as much as everyone else to introduce a new task
> state, but that state allows us to make guarantees and gives us
> semantical clarity. A parked thread is parked and can only be woken up
> by the unpark code. That's clear semantics and not a magic construct
> which will work in most cases and for the remaining ones (See below)
> it will give us problems which are way harder to decode than the ones
> we tried to fix with that magic.
> 
>> diff --git a/kernel/kthread.c b/kernel/kthread.c
>> index 691dc2e..9512fc5 100644
>> --- a/kernel/kthread.c
>> +++ b/kernel/kthread.c
>> @@ -308,6 +308,15 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
>>  	to_kthread(p)->cpu = cpu;
>>  	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
>>  	kthread_park(p);
>> +
>> +	/*
>> +	 * Wait for p->on_rq to be reset to 0, to ensure that the per-cpu
>> +	 * migration thread (which belongs to the stop_task sched class)
>> +	 * doesn't run until the cpu is actually onlined and the thread is
>> +	 * unparked.
>> +	 */
>> +	if (!wait_task_inactive(p, TASK_INTERRUPTIBLE))
>> +		WARN_ON(1);
> 
> Yay, we rely on TASK_INTERRUPTIBLE state with a task which already has
> references outside the creation code.

I doubt that. We have not even onlined the CPU, how would any else even
_know_ that we created this kthread??

*per_cpu_ptr(ht->store, cpu) = tsk; is executed _after_ returning from
this function.

The problem with ksoftirqd is very clear - we unpark threads _after_ we
online the CPU. So, in between the 2 steps, somebody on that CPU can call
__do_softirq(), leading to the race you described in your cover-letter.
That's why I tried to fix that race.

> And then we _HOPE_ that nothing
> wakes it up _BEFORE_ we do something else.
> 

Nothing can wake it up, because no one is aware of the newly created
kthread.

> Aside of that, you are still insisting to enforce that for every per
> cpu thread even if the only one which needs that at this point are
> thos which have a create() callback (i.e. the migration thread). And
> next week you figure out that this is a performance impact on bringing
> up large machines....
> 

Making this wait call specific to those kthreads with the ->create callback
won't be that much of a big deal, IMHO. But see below, I'm not going to
insist on going with my suggestions.

>>  /**
>>   * kthread_unpark - unpark a thread created by kthread_create().
>>   * @k:		thread created by kthread_create().
>> @@ -337,18 +357,29 @@ void kthread_unpark(struct task_struct *k)
>>  	struct kthread *kthread = task_get_live_kthread(k);
>>  
>>  	if (kthread) {
>> +		/*
>> +		 * Per-cpu kthreads such as ksoftirqd can get woken up by
>> +		 * other events. So after binding the thread, ensure that
>> +		 * it goes off the CPU atleast once, by parking it again.
>> +		 * This way, we can ensure that it will run on the correct
>> +		 * CPU on subsequent wakeup.
>> +		 */
>> +		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags)) {
>> +			__kthread_bind(k, kthread->cpu);
>> +			clear_bit(KTHREAD_IS_PARKED, &kthread->flags);
> 
> And how is that f*cking different from the previous code?
> 
> CPU0	   		CPU1		       CPU2
> 				       	       wakeup(T) -> run on CPU1 (last cpu)
> 
> 			switch_to(T)
> 
> __kthread_bind(T, CPU2)
> 
> clear(KTHREAD_IS_PARKED)
> 
> 			leave loop due to !KTHREAD_IS_PARKED

			How?? The task will leave the loop only when we clear
			SHOULD_PARK, not when we clear IS_PARKED. So it won't
			leave the loop here. It will cause the kthread to
			perform a fresh complete() for the waiting kthread_park()
			on CPU0.
> 
> 			BUG(wrong cpu)  <--- VOODOO FAILURE
> 
> kthread_park(T) <-- VOODOO TOO LATE
> 

No, the purpose of clear(IS_PARKED) followed by __kthread_park() is to
ensure that the task gets *descheduled* atleast once after we did the
kthread_bind(). And that's because we can't use set_cpus_allowed_ptr() to
migrate a running kthread (because the kthread could be the migration
thread). So instead, we use kthread_bind() and depend on sleep->wakeup
to put the task on the right CPU.

> You can turn around the order of clearing/setting the flags as much as
> you want, I'm going to punch an hole in it.
> 
> TASK_PARKED is the very obvious and robust solution which fixes _ALL_
> of the corner cases, at least as far as I can imagine them. And
> robustness rules at least in my world.
> 

Yes, I agree that it is robust and has clear semantics. No doubt about
that. So I won't insist on going with my suggestions.

Regards,
Srivatsa S. Bhat


