Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbaDBI0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:26:24 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48297 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbaDBI0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:26:17 -0400
Message-ID: <533BC9B7.3010501@linaro.org>
Date: Wed, 02 Apr 2014 10:26:31 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle
 info
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <22904760.5rGZuP5nsx@vostro.rjw.lan>
In-Reply-To: <22904760.5rGZuP5nsx@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 01:01 AM, Rafael J. Wysocki wrote:
> On Friday, March 28, 2014 01:29:53 PM Daniel Lezcano wrote:
>> The following patchset provides an interaction between cpuidle and the scheduler.
>>
>> The first patch encapsulate the needed information for the scheduler in a
>> separate cpuidle structure. The second one stores the pointer to this structure
>> when entering idle. The third one, use this information to take the decision to
>> find the idlest cpu.
>>
>> After some basic testing with hackbench, it appears there is an improvement for
>> the performances (small) and for the duration of the idle states (which provides
>> a better power saving).
>>
>> The measurement has been done with the 'idlestat' tool previously posted in this
>> mailing list.
>>
>> So the benefit is good for both sides performance and power saving.
>>
>> The select_idle_sibling could be also improved in the same way.
>
> Well, quite frankly, I don't really like this series.  Not the idea itself, but
> the way it has been implemented.
>
> First off, if the scheduler is to access idle state data stored in struct
> cpuidle_state, I'm not sure why we need a separate new structure for that?
> Couldn't there be a pointer to a whole struct cpuidle_state from struct rq
> instead?  [->exit_latency is the only field that find_idlest_cpu() in your
> third patch seems to be using anyway.]

Hi Rafael,

thank you very much for reviewing the patchset.

I created a specific structure to encapsulate the informations needed 
for the scheduler and to prevent to export unneeded data. This is purely 
for code design. Also it was to separate the idle's energy 
characteristics from the cpuidle framework data (flags, name, etc ...).

The exit_latency field is only used in this patchset but the 
target_residency will be used also (eg. prevent to wakeup a cpu before 
the minimum idle time target residency).

The power field is ... hum ... not filled by any board (except for 
calxeda). Vendors do not like to share this information, so very likely 
that would be changed to a normalized value, I don't know.

I agree we can put a pointer to the struct cpuidle_state instead if that 
reduce the impact of the patchset.

> Second, is accessing the idle state information for all CPUs from find_idlest_cpu()
> guaranteed to be non-racy?  I mean, what if a CPU changes its state from idle to
> non-idle while another one is executing find_idlest_cpu()?  In other words,
> where's the read memory barrier corresponding to the write ones in the modified
> cpu_idle_call()?  And is the memory barrier actually sufficient?  After all,
> you need to guarantee that the CPU is still idle after you have evaluated
> idle_cpu() on it.

Well, as Nicolas mentioned it in another mail, we can live with races, 
the scheduler will take a wrong decision but nothing worth than what we 
have today. In any case we want to prevent any lock in the code.

> Finally, is really the heuristics used by find_idlest_cpu() to select the "idlest"
> CPU the best one?  What about deeper vs shallower idle states, for example?

I believe it is what is supposed to do the patchset. 1. if the cpu is 
idle, pick the shallower, 2. if the cpu is not idle pick the less 
loaded. But may be there is something wrong in the routine as pointed 
Nico, I have to double check it.

Thanks !

   -- Daniel




-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

