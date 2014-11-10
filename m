Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaKJWVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:21:24 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55389 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKJWVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:21:23 -0500
Message-ID: <54613A5F.7060107@linaro.org>
Date: Mon, 10 Nov 2014 23:21:19 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 2/6] sched: idle: cpuidle: Check the latency req before
 idle
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org> <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org> <20141110124111.GN3337@twins.programming.kicks-ass.net> <5460D5EF.2000805@linaro.org> <20141110152803.GX10501@worktop.programming.kicks-ass.net> <5460E0A5.9040508@linaro.org> <20141110161530.GB10501@worktop.programming.kicks-ass.net> <5460F386.1050109@linaro.org> <20141110194820.GD10501@worktop.programming.kicks-ass.net>
In-Reply-To: <20141110194820.GD10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 08:48 PM, Peter Zijlstra wrote:
> On Mon, Nov 10, 2014 at 06:19:02PM +0100, Daniel Lezcano wrote:
>>> I really don't get why the governors should know about this though, its
>>> just another state, they should iterate all states and pick the best,
>>> given the power usage this state should really never be eligible unless
>>> we're QoS forced or whatnot.
>>
>> The governors just don't use the poll state at all, except for a couple of
>> cases in menu.c defined above in the previous email. What is the rational of
>> adding a state in the cpuidle driver and do everything we can to avoid using
>> it ? From my POV, the poll state is a special state, we should remove from
>> the driver's idle states like the arch_cpu_idle() is a specific idle state
>> only used in idle.c (but which may overlap with an idle state in different
>> archs eg. cpu_do_idle() and the 0th idle state).
>
> So I disagree, I think poll-idle is an idle mode just like all the
> others. It should be an available state to the governor and it should
> treat it like any other.

The governors are just ignoring it, except for a small timer 
optimization in menu.c (and I am still not convinced it is worth to have 
it). I don't see the point to add a state we don't want to use.

Eg. on my server it was called 2 times over 1313856 times.

> I don't tihnk the whole ARCH_HAS_CPU_RELAX thing makes any kind of
> sense, _every_ arch has some definition of it, the generic polling loop
> is always a valid idle implementation.
>
> What we can do is always populate the idle state table with it before
> calling the regular drivers.

I am not sure to understand. You want to add the poll idle loop in all 
the drivers ?

What about "safe_halt()" ? (arch_cpu_idle() for x86). It is also an idle 
state. Why not add it in the idle state table also ?

> If the arch drivers have a 'better' latency_req==0 idle routine -- note
> my argument on the ppc issue, I think its wrong -- it can replace the
> existing one.
>
> We should further remove all the special casing in the governors, its
> always a valid state, but it should hardly ever be the most desirable
> state.
>
> I think the whole arch specific idle loop is a mistake, we already have
> an (arch) interface into the idle routines, we don't need yet another.



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

