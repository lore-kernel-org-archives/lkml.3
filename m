Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaBCGhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:37:06 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:39595 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaBCGhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:37:03 -0500
Message-ID: <52EF382E.4020003@linux.vnet.ibm.com>
Date: Mon, 03 Feb 2014 12:03:18 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>, nicolas.pitre@linaro.org,
        mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net> <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net> <52EA8B07.6020206@linaro.org> <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com> <52EB77C3.20704@linaro.org>
In-Reply-To: <52EB77C3.20704@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020306-7164-0000-0000-000005A559BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 01/31/2014 03:45 PM, Daniel Lezcano wrote:
> On 01/31/2014 09:45 AM, Preeti Murthy wrote:
>> Hi,
>>
>> On Thu, Jan 30, 2014 at 10:55 PM, Daniel Lezcano
>> <daniel.lezcano@linaro.org> wrote:
>>> On 01/30/2014 05:35 PM, Peter Zijlstra wrote:
>>>>
>>>> On Thu, Jan 30, 2014 at 05:27:54PM +0100, Daniel Lezcano wrote:
>>>>>
>>>>> struct cpuidle_state *state = &drv->states[rq->index];
>>>>>
>>>>> And from the state, we have the following informations:
>>>>>
>>>>> struct cpuidle_state {
>>>>>
>>>>>          [ ... ]
>>>>>
>>>>>           unsigned int    exit_latency; /* in US */
>>>>>           int             power_usage; /* in mW */
>>>>>           unsigned int    target_residency; /* in US */
>>>>>           bool            disabled; /* disabled on all CPUs */
>>>>>
>>>>>          [ ... ]
>>>>> };
>>>>
>>>>
>>>> Right, but can we say that a higher index will save more power and have
>>>> a higher exit latency? Or is a driver free to have a random mapping
>>>> from
>>>> idle_index to state?
>>>
>>>
>>> If the driver does its own random mapping that will break the governor
>>> logic. So yes, the states are ordered, the higher the index is, the
>>> more you
>>> save power and the higher the exit latency is.
>>
>> The above point holds true for only the ladder governor which sees the
>> idle
>> states indexed in the increasing order of target_residency/exit_latency.
> 
> The cpuidle framework has been modified for both governor, see commit
> 8aef33a7.
> 
> The power field was initially used to do the selection, but no power
> value was ever used to filled this field by any hardware. So the field
> was arbitrarily filled with a decreasing value (-1, -2, -3 ...), and
> used by the governor's select function. The patch above just removed
> this field and the condition on power for 'select' assuming the idle
> state are power ordered in the array.

Ok. Looking at commit id 71abbbf856a0, it looks like the primary
motivation for it was the power_usage numbers of each idle state. But if
that went unused, then it perhaps makes sense to revert that patch.

Commit 8aef33a7 pretty much did that. However I think it overlooked the
menu_select() function where the the search iterates through all the
idle states introduced by the above mentioned commit again. Since its
purpose is outdated as per what you say, its best if we correct this now
as per the below post that you have pointed to.

[RFC PATCH] cpuidle: reduce unnecessary loop in c-state selection
> 
>> However this is not true as far as I can see in the menu governor. It
>> acknowledges the dynamic ordering of idle states as can be seen in the
>> menu_select() function in the menu governor, where the idle state for the
>> CPU gets chosen.  You will notice that, even if it is found that the
>> predicted
>> idle time of the CPU is smaller than the target residency of an idle
>> state,
>> the governor continues to search for suitable idle states in the
>> higher indexed
>> states although it should have halted if the idle states' were ordered
>> according
>> to their target residency.. The same holds for exit_latency.
> 
> I am not sure to get the point. Actually, this loop should be just
> optimized to backward search the idle state like cpuidle_play_dead does
> 
> There is also a patch proposed by Alex Shi about this loop.
> 
> [RFC PATCH] cpuidle: reduce unnecessary loop in c-state selection
> 
> http://comments.gmane.org/gmane.linux.power-management.general/42124

But again if we are copying the exit_latency and target_residency
numbers of the idle state entered, into the rq as soon as the idle state
for the CPU is chosen, as per the discussion on this thread, then I
guess the ordering of the idle states in the cpuidle state table does
not matter.

Thanks

Regards
Preeti U Murthy

