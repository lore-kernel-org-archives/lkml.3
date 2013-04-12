Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3DLL3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:29:39 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58944 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3DLL3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:29:38 -0400
Message-ID: <5167EF69.8080802@linux.vnet.ibm.com>
Date: Fri, 12 Apr 2013 16:56:33 +0530
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
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <51670C17.8070608@linux.vnet.ibm.com> <alpine.LFD.2.02.1304112158040.21884@ionos> <516728F6.4090701@linux.vnet.ibm.com> <alpine.LFD.2.02.1304112347390.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304112347390.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041211-1618-0000-0000-000003AC1B2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 04/12/2013 04:29 PM, Thomas Gleixner wrote:
> Srivatsa,
> 
> On Fri, 12 Apr 2013, Srivatsa S. Bhat wrote:
>> On 04/12/2013 02:17 AM, Thomas Gleixner wrote:
>>>> +
>>>> +	/*
>>>> +	 * Wait for p->on_rq to be reset to 0, to ensure that the per-cpu
>>>> +	 * migration thread (which belongs to the stop_task sched class)
>>>> +	 * doesn't run until the cpu is actually onlined and the thread is
>>>> +	 * unparked.
>>>> +	 */
>>>> +	if (!wait_task_inactive(p, TASK_INTERRUPTIBLE))
>>>> +		WARN_ON(1);
>>>
>>> Yay, we rely on TASK_INTERRUPTIBLE state with a task which already has
>>> references outside the creation code.
>>
>> I doubt that. We have not even onlined the CPU, how would any else even
>> _know_ that we created this kthread??
> 
> The problem is not only at the thread creation time. We have the same
> issue at offline/online and there we have a reference to that very
> thread.
> 

Right. So our solutions differ in how that is handled, like this:
Yours: ensures that nobody can wakeup the parked thread, except the unpark
       code.
Mine:  ensures that nobody can make the parked thread leave its park loop
       (even if it is woken up), except the unpark code.

Apart from this, everything else is mostly same - for eg., both the patches
depend on that wait_task_inactive() call, in order to make the migration
thread behave.

Either way, the purpose is served, so I'm fine with your solution.

(One of the reasons why I was confident of coming up with a working solution
without adding a new state was because I've worked on the freezer code before,
and IIRC, we have more or less similar problems there and we manage to deal
with it without having a dedicated TASK_FROZEN state. Anyway, nevermind... )

>>>>  /**
>>>>   * kthread_unpark - unpark a thread created by kthread_create().
>>>>   * @k:		thread created by kthread_create().
>>>> @@ -337,18 +357,29 @@ void kthread_unpark(struct task_struct *k)
>>>>  	struct kthread *kthread = task_get_live_kthread(k);
>>>>  
>>>>  	if (kthread) {
>>>> +		/*
>>>> +		 * Per-cpu kthreads such as ksoftirqd can get woken up by
>>>> +		 * other events. So after binding the thread, ensure that
>>>> +		 * it goes off the CPU atleast once, by parking it again.
>>>> +		 * This way, we can ensure that it will run on the correct
>>>> +		 * CPU on subsequent wakeup.
>>>> +		 */
>>>> +		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags)) {
>>>> +			__kthread_bind(k, kthread->cpu);
>>>> +			clear_bit(KTHREAD_IS_PARKED, &kthread->flags);
>>>
>>> And how is that f*cking different from the previous code?
>>>
>>> CPU0	   		CPU1		       CPU2
>>> 				       	       wakeup(T) -> run on CPU1 (last cpu)
>>>
>>> 			switch_to(T)
>>>
>>> __kthread_bind(T, CPU2)
>>>
>>> clear(KTHREAD_IS_PARKED)
>>>
>>> 			leave loop due to !KTHREAD_IS_PARKED
>>
>> 			How?? The task will leave the loop only when we clear
>> 			SHOULD_PARK, not when we clear IS_PARKED. So it won't
>> 			leave the loop here. It will cause the kthread to
>> 			perform a fresh complete() for the waiting kthread_park()
>> 			on CPU0.
> 
> You are right on that, but you tricked me into misreading your
> patch. Why? Simply because it is too complex for no reason.
> 

;-)

>> No, the purpose of clear(IS_PARKED) followed by __kthread_park() is to
>> ensure that the task gets *descheduled* atleast once after we did the
>> kthread_bind(). And that's because we can't use set_cpus_allowed_ptr() to
>> migrate a running kthread (because the kthread could be the migration
>> thread). So instead, we use kthread_bind() and depend on sleep->wakeup
>> to put the task on the right CPU.
> 
> Yeah, it's a nice workaround, though I really prefer a guaranteed well
> defined state over this wakeup/sleep/wakeup trickery, which also adds
> the additional cost of a wakeup/sleep cycle to the online operation.
>

Sure, no objections from me!
 
>>> TASK_PARKED is the very obvious and robust solution which fixes _ALL_
>>> of the corner cases, at least as far as I can imagine them. And
>>> robustness rules at least in my world.
>>>
>>
>> Yes, I agree that it is robust and has clear semantics. No doubt about
>> that. So I won't insist on going with my suggestions.
> 
> I'm glad, that we can agree on the robust solution :)
>

I'm glad too :-) Thanks a lot!

Regards,
Srivatsa S. Bhat

