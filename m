Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaKFM1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:27:38 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46471 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaKFM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:27:34 -0500
Message-ID: <545B6932.4010308@linaro.org>
Date: Thu, 06 Nov 2014 13:27:30 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        patches@linaro.org
Subject: Re: [PATCH V2 1/5] sched: idle: cpuidle: Check the latency req before
 idle
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pOg1GFW82WD8b6Vas5xhYQrQtdP1STGxyzYtrBNSa+-Pw@mail.gmail.com> <544FE787.8090108@linaro.org> <54504A60.2090908@linux.vnet.ibm.com> <545A3414.7030500@linaro.org> <545AF424.2070302@linux.vnet.ibm.com>
In-Reply-To: <545AF424.2070302@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 05:08 AM, Preeti U Murthy wrote:
> On 11/05/2014 07:58 PM, Daniel Lezcano wrote:
>> On 10/29/2014 03:01 AM, Preeti U Murthy wrote:
>>> On 10/29/2014 12:29 AM, Daniel Lezcano wrote:
>>>> On 10/28/2014 04:51 AM, Preeti Murthy wrote:
>>>>> Hi Daniel,
>>>>>
>>>>> On Thu, Oct 23, 2014 at 2:31 PM, Daniel Lezcano
>>>>> <daniel.lezcano@linaro.org> wrote:
>>>>>> When the pmqos latency requirement is set to zero that means "poll in
>>>>>> all the
>>>>>> cases".
>>>>>>
>>>>>> That is correctly implemented on x86 but not on the other archs.
>>>>>>
>>>>>> As how is written the code, if the latency request is zero, the
>>>>>> governor will
>>>>>> return zero, so corresponding, for x86, to the poll function, but for
>>>>>> the
>>>>>> others arch the default idle function. For example, on ARM this is
>>>>>> wait-for-
>>>>>> interrupt with a latency of '1', so violating the constraint.
>>>>>
>>>>> This is not true actually. On PowerPC the idle state 0 has an
>>>>> exit_latency of 0.
>>>>>
>>>>>>
>>>>>> In order to fix that, do the latency requirement check *before*
>>>>>> calling the
>>>>>> cpuidle framework in order to jump to the poll function without
>>>>>> entering
>>>>>> cpuidle. That has several benefits:
>>>>>
>>>>> Doing so actually hurts on PowerPC. Because the idle loop defined for
>>>>> idle state 0 is different from what cpu_relax() does in
>>>>> cpu_idle_loop().
>>>>> The spinning is more power efficient in the former case. Moreover we
>>>>> also set
>>>>> certain register values which indicate an idle cpu. The ppc_runlatch
>>>>> bits
>>>>> do precisely this. These register values are being read by some user
>>>>> space
>>>>> tools.  So we will end up breaking them with this patch
>>>>>
>>>>> My suggestion is very well keep the latency requirement check in
>>>>> kernel/sched/idle.c
>>>>> like your doing in this patch. But before jumping to cpu_idle_loop
>>>>> verify if the
>>>>> idle state 0 has an exit_latency > 0 in addition to your check on the
>>>>> latency_req == 0.
>>>>> If not, you can fall through to the regular path of calling into the
>>>>> cpuidle driver.
>>>>> The scheduler can query the cpuidle_driver structure anyway.
>>>>>
>>>>> What do you think?
>>>>
>>>> Thanks for reviewing the patch and spotting this.
>>>>
>>>> Wouldn't make sense to create:
>>>>
>>>> void __weak_cpu_idle_poll(void) ?
>>>>
>>>> and override it with your specific poll function ?
>>>>
>>>
>>> No this would become ugly as far as I can see. A weak function has to be
>>> defined under arch/* code. We will either need to duplicate the idle
>>> loop that we already have in the drivers or point the weak function to
>>> the first idle state defined by our driver. Both of which is not
>>> desirable (calling into the driver from arch code is ugly). Another
>>> reason why I don't like the idea of a weak function is that if you have
>>> missed looking at a specific driver and they have an idle loop with
>>> features similar to on powerpc, you will have to spot it yourself and
>>> include the arch specific cpu_idle_poll() for them.
>>
>> Yes, I agree this is a fair point. But actually I don't see the interest
>> of having the poll loop in the cpuidle driver. These cleanups are
>
> We can't do that simply because the idle poll loop has arch specific
> bits on powerpc.

I am not sure.

Could you describe what is the difference between the arch_cpu_idle 
function in arch/arm/powerpc/kernel/idle.c and the 0th power PC idle state ?

Is it kind of duplicate ?

And for polling, do you really want to use while (...); cpu_relax(); as 
it is x86 specific ? instead of the powerpc's arch_idle ?

Today, if latency_req == 0, it returns the 0th idle state, so polling.

If we jump to the arch_cpu_idle_poll, the result will be the same for 
all architecture.

>> preparing the removal of the CPUIDLE_DRIVER_STATE_START macro which
>> leads to a lot of mess in the cpuidle code.
>
> How is the suggestion to check the exit_latency of idle state 0 when
> latency_req  == 0 going to hinder this removal?

It sounds a bit hackish. I prefer to sort out the current situation.

And by the way, what is the reasoning behind having a target_residency / 
exit_latency equal to zero for an idle state ?

All this sounds really fuzzy for me.

>> With the removal of this macro, we should be able to move the select
>> loop from the menu governor and use it everywhere else. Furthermore,
>> this state which is flagged with TIME_VALID, isn't because the local
>> interrupt are enabled so we are measuring the interrupt time processing.
>> Beside that the idle loop for x86 is mostly not used.
>>
>> So the idea would be to extract those idle loop from the drivers and use
>> them directly when:
>>   1. the idle selection fails (use the poll loop under certain
>> circumstances we have to redefine)
>
> This behavior will not change as per my suggestion.
>
>>   2. when the latency req is zero
>
> Its only here that I suggested you also verify state 0's exit_latency.
> For the reason that the arch may have a more optimized idle poll loop,
> which we cannot override with the generic cpuidle poll loop.
>
> Regards
> Preeti U Murthy
>>
>> That will result in a cleaner code in cpuidle and in the governor.
>>
>> Do you agree with that ?
>>
>>> But by having a check on the exit_latency, you are claiming that since
>>> the driver's 0th idle state is no better than the generic idle loop in
>>> cases of 0 latency req, we are better off calling the latter, which
>>> looks reasonable. That way you don't have to bother about worsening the
>>> idle loop behavior on any other driver.
>>
>>
>>
>>
>>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

