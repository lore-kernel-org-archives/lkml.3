Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab3AYQBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:01:03 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:39883 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab3AYQBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:01:00 -0500
Message-ID: <5102AB9D.20000@linux.vnet.ibm.com>
Date: Fri, 25 Jan 2013 21:28:21 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi.kivity@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH V3 RESEND RFC 1/2] sched: Bail out of yield_to when source
 and target runqueue has one task
References: <20130122073854.24731.9426.sendpatchset@codeblue.in.ibm.com> <20130122073913.24731.65118.sendpatchset@codeblue.in.ibm.com> <20130124103213.GD27602@gmail.com> <20130125104025.GA14978@linux.vnet.ibm.com> <20130125110549.GA4220@hawk.usersys.redhat.com>
In-Reply-To: <20130125110549.GA4220@hawk.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012515-6102-0000-0000-000002EAC5AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 04:35 PM, Andrew Jones wrote:
> On Fri, Jan 25, 2013 at 04:10:25PM +0530, Raghavendra K T wrote:
>> * Ingo Molnar <mingo@kernel.org> [2013-01-24 11:32:13]:
>>
>>>
>>> * Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
>>>
>>>> From: Peter Zijlstra <peterz@infradead.org>
>>>>
>>>> In case of undercomitted scenarios, especially in large guests
>>>> yield_to overhead is significantly high. when run queue length of
>>>> source and target is one, take an opportunity to bail out and return
>>>> -ESRCH. This return condition can be further exploited to quickly come
>>>> out of PLE handler.
>>>>
>>>> (History: Raghavendra initially worked on break out of kvm ple handler upon
>>>>   seeing source runqueue length = 1, but it had to export rq length).
>>>>   Peter came up with the elegant idea of return -ESRCH in scheduler core.
>>>>
>>>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>>>> Raghavendra, Checking the rq length of target vcpu condition added.(thanks Avi)
>>>> Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>>>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>>>> Acked-by: Andrew Jones <drjones@redhat.com>
>>>> Tested-by: Chegu Vinod <chegu_vinod@hp.com>
>>>> ---
>>>>
>>>>   kernel/sched/core.c |   25 +++++++++++++++++++------
>>>>   1 file changed, 19 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>>> index 2d8927f..fc219a5 100644
>>>> --- a/kernel/sched/core.c
>>>> +++ b/kernel/sched/core.c
>>>> @@ -4289,7 +4289,10 @@ EXPORT_SYMBOL(yield);
>>>>    * It's the caller's job to ensure that the target task struct
>>>>    * can't go away on us before we can do any checks.
>>>>    *
>>>> - * Returns true if we indeed boosted the target task.
>>>> + * Returns:
>>>> + *	true (>0) if we indeed boosted the target task.
>>>> + *	false (0) if we failed to boost the target.
>>>> + *	-ESRCH if there's no task to yield to.
>>>>    */
>>>>   bool __sched yield_to(struct task_struct *p, bool preempt)
>>>>   {
>>>> @@ -4303,6 +4306,15 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
>>>>
>>>>   again:
>>>>   	p_rq = task_rq(p);
>>>> +	/*
>>>> +	 * If we're the only runnable task on the rq and target rq also
>>>> +	 * has only one task, there's absolutely no point in yielding.
>>>> +	 */
>>>> +	if (rq->nr_running == 1 && p_rq->nr_running == 1) {
>>>> +		yielded = -ESRCH;
>>>> +		goto out_irq;
>>>> +	}
>>>
>>> Looks good to me in principle.
>>>
>>> Would be nice to get more consistent benchmark numbers. Once
>>> those are unambiguously showing that this is a win:
>>>
>>>    Acked-by: Ingo Molnar <mingo@kernel.org>
>>>
>>
>> I ran the test with kernbench and sysbench again on 32 core mx3850
>> machine with 32 vcpu guests. Results shows definite improvements.
>>
>> ebizzy and dbench show similar improvement for 1x overcommit
>> (note that stdev for 1x in dbench is lesser improvemet is now seen at
>> only 20%)
>>
>> [ all the experiments are taken out of 8 run averages ].
>>
>> The patches benefit large guest undercommit scenarios, so I believe
>> with large guest performance improvemnt is even significant. [ Chegu
>> Vinod results show performance near to no ple cases ].
>
> The last results you posted for dbench for the patched 1x case were
> showing much better throughput than the no-ple 1x case, which is what
> was strange. Is that still happening? You don't have the no-ple 1x
> data here this time. The percent errors look a lot better.

I re-ran the experiment and almost got 4% (13500 vs 14100) less 
throughput compared to patched for no-ple case. ( I believe this 
variation may be due to having 4 guest with 3 idle.. as no-ple is very 
sensitive after 1x).



