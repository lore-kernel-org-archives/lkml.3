Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaKGEXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:23:51 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56411 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaKGEXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:23:46 -0500
Message-ID: <545C4942.5020809@linux.vnet.ibm.com>
Date: Fri, 07 Nov 2014 09:53:30 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        patches@linaro.org
Subject: Re: [PATCH V2 1/5] sched: idle: cpuidle: Check the latency req before
 idle
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pOg1GFW82WD8b6Vas5xhYQrQtdP1STGxyzYtrBNSa+-Pw@mail.gmail.com> <544FE787.8090108@linaro.org> <54504A60.2090908@linux.vnet.ibm.com> <545A3414.7030500@linaro.org> <545AF424.2070302@linux.vnet.ibm.com> <545B6932.4010308@linaro.org>
In-Reply-To: <545B6932.4010308@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110704-0029-0000-0000-0000056F995F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 05:57 PM, Daniel Lezcano wrote:
> On 11/06/2014 05:08 AM, Preeti U Murthy wrote:
>> On 11/05/2014 07:58 PM, Daniel Lezcano wrote:
>>> On 10/29/2014 03:01 AM, Preeti U Murthy wrote:
>>>> On 10/29/2014 12:29 AM, Daniel Lezcano wrote:
>>>>> On 10/28/2014 04:51 AM, Preeti Murthy wrote:
>>>>>> Hi Daniel,
>>>>>>
>>>>>> On Thu, Oct 23, 2014 at 2:31 PM, Daniel Lezcano
>>>>>> <daniel.lezcano@linaro.org> wrote:
>>>>>>> When the pmqos latency requirement is set to zero that means
>>>>>>> "poll in
>>>>>>> all the
>>>>>>> cases".
>>>>>>>
>>>>>>> That is correctly implemented on x86 but not on the other archs.
>>>>>>>
>>>>>>> As how is written the code, if the latency request is zero, the
>>>>>>> governor will
>>>>>>> return zero, so corresponding, for x86, to the poll function, but
>>>>>>> for
>>>>>>> the
>>>>>>> others arch the default idle function. For example, on ARM this is
>>>>>>> wait-for-
>>>>>>> interrupt with a latency of '1', so violating the constraint.
>>>>>>
>>>>>> This is not true actually. On PowerPC the idle state 0 has an
>>>>>> exit_latency of 0.
>>>>>>
>>>>>>>
>>>>>>> In order to fix that, do the latency requirement check *before*
>>>>>>> calling the
>>>>>>> cpuidle framework in order to jump to the poll function without
>>>>>>> entering
>>>>>>> cpuidle. That has several benefits:
>>>>>>
>>>>>> Doing so actually hurts on PowerPC. Because the idle loop defined for
>>>>>> idle state 0 is different from what cpu_relax() does in
>>>>>> cpu_idle_loop().
>>>>>> The spinning is more power efficient in the former case. Moreover we
>>>>>> also set
>>>>>> certain register values which indicate an idle cpu. The ppc_runlatch
>>>>>> bits
>>>>>> do precisely this. These register values are being read by some user
>>>>>> space
>>>>>> tools.  So we will end up breaking them with this patch
>>>>>>
>>>>>> My suggestion is very well keep the latency requirement check in
>>>>>> kernel/sched/idle.c
>>>>>> like your doing in this patch. But before jumping to cpu_idle_loop
>>>>>> verify if the
>>>>>> idle state 0 has an exit_latency > 0 in addition to your check on the
>>>>>> latency_req == 0.
>>>>>> If not, you can fall through to the regular path of calling into the
>>>>>> cpuidle driver.
>>>>>> The scheduler can query the cpuidle_driver structure anyway.
>>>>>>
>>>>>> What do you think?
>>>>>
>>>>> Thanks for reviewing the patch and spotting this.
>>>>>
>>>>> Wouldn't make sense to create:
>>>>>
>>>>> void __weak_cpu_idle_poll(void) ?
>>>>>
>>>>> and override it with your specific poll function ?
>>>>>
>>>>
>>>> No this would become ugly as far as I can see. A weak function has
>>>> to be
>>>> defined under arch/* code. We will either need to duplicate the idle
>>>> loop that we already have in the drivers or point the weak function to
>>>> the first idle state defined by our driver. Both of which is not
>>>> desirable (calling into the driver from arch code is ugly). Another
>>>> reason why I don't like the idea of a weak function is that if you have
>>>> missed looking at a specific driver and they have an idle loop with
>>>> features similar to on powerpc, you will have to spot it yourself and
>>>> include the arch specific cpu_idle_poll() for them.
>>>
>>> Yes, I agree this is a fair point. But actually I don't see the interest
>>> of having the poll loop in the cpuidle driver. These cleanups are
>>
>> We can't do that simply because the idle poll loop has arch specific
>> bits on powerpc.
> 
> I am not sure.
> 
> Could you describe what is the difference between the arch_cpu_idle
> function in arch/arm/powerpc/kernel/idle.c and the 0th power PC idle
> state ?

arch_cpu_idle() is the arch specific idle routine. It goes into deeper
idle state. I am guessing you meant to ask the difference between
power pc 0th idle state and the polling logic in cpu_idle_poll().

The 0th idle state is also a polling loop. Additionally it sets a couple
of registers to indicate idleness.

> 
> Is it kind of duplicate ?
> 
> And for polling, do you really want to use while (...); cpu_relax(); as
> it is x86 specific ? instead of the powerpc's arch_idle ?
> 
> Today, if latency_req == 0, it returns the 0th idle state, so polling.
> 
> If we jump to the arch_cpu_idle_poll, the result will be the same for
> all architecture.


So you propose creating a weak arch_cpu_idle_poll()? Ok if it is going
to make the cleanup easier, go ahead. I can add arch_cpu_idle_poll() in
the core code on powerpc.

> 
>>> preparing the removal of the CPUIDLE_DRIVER_STATE_START macro which
>>> leads to a lot of mess in the cpuidle code.
>>
>> How is the suggestion to check the exit_latency of idle state 0 when
>> latency_req  == 0 going to hinder this removal?
> 
> It sounds a bit hackish. I prefer to sort out the current situation.
> 
> And by the way, what is the reasoning behind having a target_residency /
> exit_latency equal to zero for an idle state ?

Its a polling idle state, hence the exit_latency is 0.

Regards
Preeti U Murthy

