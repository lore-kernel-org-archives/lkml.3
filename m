Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbaEIP2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:28:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370AbaEIP2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:28:02 -0400
Message-ID: <536CF346.6080009@redhat.com>
Date: Fri, 09 May 2014 11:24:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com
Subject: Re: [PATCH] sched: wake up task on prev_cpu if not in SD_WAKE_AFFINE
 domain with cpu
References: <20140502004237.79dd3de6@annuminas.surriel.com>	 <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com>	 <1399016273.5233.94.camel@marge.simpson.net> <536379D0.8070306@redhat.com>	 <1399030032.5233.142.camel@marge.simpson.net> <5363B793.9010208@redhat.com>	 <20140506115448.GH11096@twins.programming.kicks-ass.net>	 <536943C9.4030502@redhat.com>	 <20140506203916.GQ17778@laptop.programming.kicks-ass.net>	 <536C3B69.1000208@redhat.com>	 <20140509012743.67d4006d@annuminas.surriel.com>	 <1399620873.5200.68.camel@marge.simpson.net> <536CE48E.2060305@redhat.com> <1399649042.31219.47.camel@marge.simpson.net>
In-Reply-To: <1399649042.31219.47.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 11:24 AM, Mike Galbraith wrote:
> On Fri, 2014-05-09 at 10:22 -0400, Rik van Riel wrote:
>> On 05/09/2014 03:34 AM, Mike Galbraith wrote:
>>> On Fri, 2014-05-09 at 01:27 -0400, Rik van Riel wrote:
>>>> On Thu, 08 May 2014 22:20:25 -0400
>>>> Rik van Riel <riel@redhat.com> wrote:
>>>>
>>>>> Looks like SD_BALANCE_WAKE is not gotten from the sd flags at
>>>>> all, but passed into select_task_rq by try_to_wake_up, as a
>>>>> hard coded sd_flags argument.
>>>>
>>>>> Should we do that, if SD_WAKE_BALANCE is not set for any sched domain?
>>>>
>>>> I answered my own question. The sd_flag SD_WAKE_BALANCE simply means
>>>> "this is a wakeup of a previously existing task, please place it
>>>> properly".
>>>>
>>>> However, it appears that the current code will fall back to the large
>>>> loop with select_idlest_group and friends, if prev_cpu and cpu are not
>>>> part of the same SD_WAKE_AFFINE sched domain. That is a bug...
>>>
>>> ttwu(): cpu = select_task_rq(p, p->wake_cpu, SD_BALANCE_WAKE, wake_flags);
>>>
>>> We pass SD_BALANCE_WAKE for a normal wakeup, so sd will only be set if
>>> we encounter a domain during traversal where Joe User has told us to do
>>> (expensive) wake balancing before we hit a domain shared by waker/wakee.
>>>
>>> The user can turn SD_WAKE_AFFINE off beyond socket, and we'll not pull
>>> cross node on wakeup.
>>>
>>> Or, you could create an override button to say despite SD_WAKE_AFFINE
>>> perhaps having been set during domain construction (because of some
>>> pseudo-random numbers), don't do that if we have a preferred node, or
>>> just make that automatically part of having numa scheduling enabled, and
>>> don't bother wasting cycles if preferred && this != preferred.
>>
>> That's not the problem.
>>
>> The problem is that if we do not do an affine wakeup, due to
>> SD_WAKE_AFFINE not being set on a top level domain, we will
>> not try to run p on prev_cpu, but we will fall through into
>> the loop with find_idlest_group, etc...
>
> If no ->flags & SD_BALANCE_WAKE is encountered during traversal, sd
> remains NULL, we fall through to return prev_cpu.

We do fall through, but into this loop:

         while (sd) {
                 struct sched_group *group;
                 int weight;

                 if (!(sd->flags & sd_flag)) {
                         sd = sd->child;
                         continue;
                 }

                 group = find_idlest_group(sd, p, cpu, sd_flag);
                 if (!group) {
                         sd = sd->child;
                         continue;
                 }

                 new_cpu = find_idlest_cpu(group, p, cpu);
                 if (new_cpu == -1 || new_cpu == cpu) {
                         /* Now try balancing at a lower domain level of 
cpu */
                         sd = sd->child;
                         continue;
                 }

                 /* Now try balancing at a lower domain level of new_cpu */
                 cpu = new_cpu;
                 weight = sd->span_weight;
                 sd = NULL;
                 for_each_domain(cpu, tmp) {
                         if (weight <= tmp->span_weight)
                                 break;
                         if (tmp->flags & sd_flag)
                                 sd = tmp;
                 }
                 /* while loop will break here if sd == NULL */
         }



