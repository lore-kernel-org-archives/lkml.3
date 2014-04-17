Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaDQQFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:05:20 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44892 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaDQQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:04:44 -0400
Message-ID: <534FFBB3.8050601@linaro.org>
Date: Thu, 17 Apr 2014 18:05:07 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        rjw@rjwysocki.net, linux-pm@vger.kernel.org, alex.shi@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose
 the idlest cpu
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org> <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr> <534FDCDC.6000806@linaro.org> <alpine.LFD.2.11.1404171138470.980@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1404171138470.980@knanqh.ubzr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 05:53 PM, Nicolas Pitre wrote:
> On Thu, 17 Apr 2014, Daniel Lezcano wrote:
>
>> Ok, refreshed the patchset but before sending it out I would to discuss about
>> the rational of the changes and the policy, and change the patchset
>> consequently.
>>
>> What order to choose if the cpu is idle ?
>>
>> Let's assume all cpus are idle on a dual socket quad core.
>>
>> Also, we can reasonably do the hypothesis if the cluster is in low power mode,
>> the cpus belonging to the same cluster are in the same idle state (putting
>> apart the auto-promote where we don't have control on).
>>
>> If the policy you talk above is 'aggressive power saving', we can follow the
>> rules with decreasing priority:
>>
>> 1. We want to prevent to wakeup the entire cluster
>> 	=> as the cpus are in the same idle state, by choosing a cpu in
>> 	=> shallow
>> state, we should have the guarantee we won't wakeup a cluster (except if no
>> shallowest idle cpu are found).
>
> This is unclear to me.  Obviously, if an entire cluster is down, that
> means all the CPUs it contains have been idle for a long time.  And
> therefore they shouldn't be subject to selection unless there is no
> other CPUs available.  Is that what you mean?

Yes, this is what I meant. But also what I meant is we can get rid for 
the moment of the cpu topology and the coupling idle state because if we 
do this described approach, as the idle state will be the same for the 
cpus belonging to the same cluster we won't select a cluster down 
(except if there is no other CPUs available).

>> 2. We want to prevent to wakeup a cpu which did not reach the target residency
>> time (will need some work to unify cpuidle idle time and idle task run time)
>> 	=> with the target residency and, as a first step, with the idle
>> 	=> stamp,
>> we can determine if the cpu slept enough
>
> Agreed. However, right now, the scheduler does not have any
> consideration for that.  So this should be done as a separate patch.

Yes, I thought as a very first step we can rely on the idle stamp until 
we unify the times with a big comment. Or I can first unify the idle 
times and then take into account the target residency. It is to comply 
with Rafael's request to have the 'big picture'.

>> 3. We want to prevent to wakeup a cpu in deep idle state
>> 	=> by looking for the cpu in shallowest idle state
>
> Obvious.
>
>> 4. We want to prevent to wakeup a cpu where the exit latency is longer than
>> the expected run time of the task (and the time to migrate the task ?)
>
> Sure.  That would be a case for using task packing even if the policy is
> set to performance rather than powersave whereas task packing is
> normally for powersave.

Yes, I agree, task packing improves also the performances and it makes 
really sense to prevent task migration under some circumstances for a 
better cache efficiency.

Thanks for the comments

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

