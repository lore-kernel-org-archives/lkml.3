Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaAaIpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:45:50 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:58830 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaAaIps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:45:48 -0500
MIME-Version: 1.0
In-Reply-To: <52EA8B07.6020206@linaro.org>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
	<1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org>
	<20140130153150.GD5002@laptop.programming.kicks-ass.net>
	<52EA7D8A.6080604@linaro.org>
	<20140130163501.GG5002@laptop.programming.kicks-ass.net>
	<52EA8B07.6020206@linaro.org>
Date: Fri, 31 Jan 2014 14:15:47 +0530
Message-ID: <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: nicolas.pitre@linaro.org, mingo@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 30, 2014 at 10:55 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 01/30/2014 05:35 PM, Peter Zijlstra wrote:
>>
>> On Thu, Jan 30, 2014 at 05:27:54PM +0100, Daniel Lezcano wrote:
>>>
>>> struct cpuidle_state *state = &drv->states[rq->index];
>>>
>>> And from the state, we have the following informations:
>>>
>>> struct cpuidle_state {
>>>
>>>         [ ... ]
>>>
>>>          unsigned int    exit_latency; /* in US */
>>>          int             power_usage; /* in mW */
>>>          unsigned int    target_residency; /* in US */
>>>          bool            disabled; /* disabled on all CPUs */
>>>
>>>         [ ... ]
>>> };
>>
>>
>> Right, but can we say that a higher index will save more power and have
>> a higher exit latency? Or is a driver free to have a random mapping from
>> idle_index to state?
>
>
> If the driver does its own random mapping that will break the governor
> logic. So yes, the states are ordered, the higher the index is, the more you
> save power and the higher the exit latency is.

The above point holds true for only the ladder governor which sees the idle
states indexed in the increasing order of target_residency/exit_latency.

However this is not true as far as I can see in the menu governor. It
acknowledges the dynamic ordering of idle states as can be seen in the
menu_select() function in the menu governor, where the idle state for the
CPU gets chosen.  You will notice that, even if it is found that the predicted
idle time of the CPU is smaller than the target residency of an idle state,
the governor continues to search for suitable idle states in the higher indexed
states although it should have halted if the idle states' were ordered according
to their target residency.. The same holds for exit_latency.

Hence I think this patch would make sense only with additional information
like exit_latency or target_residency is present for the scheduler. The idle
state index alone will not be sufficient.

Thanks

Regards
Preeti U Murthy

>
>
>> Also, we should probably create a pretty function to get that state,
>> just like you did in patch 1.
>
>
> Yes, right.
>
>
>>> IIRC, Alex Shi sent a patchset to improve the choosing of the idlest cpu
>>> and
>>> the exit_latency was needed.
>>
>>
>> Right. However if we have a 'natural' order in the state array the index
>> itself might often be sufficient to find the least idle state, in this
>> specific case the absolute exit latency doesn't matter, all we want is
>> the lowest one.
>
>
> Indeed. It could be simple as that. I feel we may need more informations in
> the future but comparing the indexes could be a nice simple and efficient
> solution.
>
>
>> Not dereferencing the state array saves hitting cold cachelines.
>
>
> Yeah, always good to remind that. Should keep in mind for later.
>
> Thanks for your comments.
>
>   -- Daniel
>
>
>
>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
