Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaKLNxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:53:18 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34457 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaKLNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:53:16 -0500
Message-ID: <54636646.6080709@linaro.org>
Date: Wed, 12 Nov 2014 14:53:10 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 2/6] sched: idle: cpuidle: Check the latency req before
 idle
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org> <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org> <20141110124111.GN3337@twins.programming.kicks-ass.net> <5460D5EF.2000805@linaro.org> <20141110152803.GX10501@worktop.programming.kicks-ass.net> <5460E0A5.9040508@linaro.org> <20141110161530.GB10501@worktop.programming.kicks-ass.net> <5460F386.1050109@linaro.org> <20141110194820.GD10501@worktop.programming.kicks-ass.net> <54613A5F.7060107@linaro.org> <20141111102058.GI10501@worktop.programming.kicks-ass.net>
In-Reply-To: <20141111102058.GI10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 11:20 AM, Peter Zijlstra wrote:
> On Mon, Nov 10, 2014 at 11:21:19PM +0100, Daniel Lezcano wrote:
>> On 11/10/2014 08:48 PM, Peter Zijlstra wrote:
>>> On Mon, Nov 10, 2014 at 06:19:02PM +0100, Daniel Lezcano wrote:
>>>>> I really don't get why the governors should know about this though, its
>>>>> just another state, they should iterate all states and pick the best,
>>>>> given the power usage this state should really never be eligible unless
>>>>> we're QoS forced or whatnot.
>>>>
>>>> The governors just don't use the poll state at all, except for a couple of
>>>> cases in menu.c defined above in the previous email. What is the rational of
>>>> adding a state in the cpuidle driver and do everything we can to avoid using
>>>> it ? From my POV, the poll state is a special state, we should remove from
>>>> the driver's idle states like the arch_cpu_idle() is a specific idle state
>>>> only used in idle.c (but which may overlap with an idle state in different
>>>> archs eg. cpu_do_idle() and the 0th idle state).
>>>
>>> So I disagree, I think poll-idle is an idle mode just like all the
>>> others. It should be an available state to the governor and it should
>>> treat it like any other.
>>
>> The governors are just ignoring it, except for a small timer optimization in
>> menu.c (and I am still not convinced it is worth to have it). I don't see
>> the point to add a state we don't want to use.
>
> The ignoring it is _wrong_. Make that go away and you'll get rid of most
> of the STATE_START crap.
>
> The governors are the place where we combine the QoS constraints with
> idle predictors and pick an idle state, polling is a valid state to
> pick, and given QoS constraints it might be the only state to pick.

Well, I understand your point of view but I still disagree. IMO, the 
poll loop shouldn't be considered as a valid idle state for different 
reasons:

0. thermal issue if wrongly selected from any of the governor

1. a polling loop does not have a valid time measurements even if the 
TIME_VALID flag has been added

2. entering the idle governors is not free, especially the menu 
governor, which is contradictory with zero latency req

3. what is the meaning of having a zero latency (target + exit) idle 
state ? We know it will always succeed if the other fails

4. IIUC, you are suggesting to add the poll loop for all the cpuidle 
drivers. This is a *lot* of changes, I am not afraid about the work to 
do but there is a significant code impact and the entire behavior of the 
cpuidle framework for all the arch will be changed.

So given the points above, why not have one poll function, generic, and 
if we fail to find an idle state or if the req is zero, then fallback to 
the poll loop ?


>> Eg. on my server it was called 2 times over 1313856 times.
>>
>>> I don't tihnk the whole ARCH_HAS_CPU_RELAX thing makes any kind of
>>> sense, _every_ arch has some definition of it, the generic polling loop
>>> is always a valid idle implementation.
>>>
>>> What we can do is always populate the idle state table with it before
>>> calling the regular drivers.
>>
>> I am not sure to understand. You want to add the poll idle loop in all the
>> drivers ?
>>
>> What about "safe_halt()" ? (arch_cpu_idle() for x86). It is also an idle
>> state. Why not add it in the idle state table also ?
>
> Because the latter is actually arch specific, whereas the idle polling
> thing is not.
> You can _always_ poll idle, its generic, its valid, and
> its guaranteed the most responsive method.

I agree with this point but this kind of loop is hardware optimized for 
x86. On the other arch, where today this loop is never used, if we 
change the behavior of the cpuidle framework and introduces this loop, 
it may be selected and stay on this state for a long time (resulting 
from a bad prediction), I am afraid that can lead to some thermal issues.

> The arch drivers get to add arch specific idle states; if a x86 cpuidle
> driver wants to add hlt they can.




-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

