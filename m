Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaA3Q14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:27:56 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36970 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaA3Q1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:27:55 -0500
Message-ID: <52EA7D8A.6080604@linaro.org>
Date: Thu, 30 Jan 2014 17:27:54 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: nicolas.pitre@linaro.org, mingo@redhat.com, tglx@linutronix.de,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net>
In-Reply-To: <20140130153150.GD5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 04:31 PM, Peter Zijlstra wrote:
> On Thu, Jan 30, 2014 at 03:09:22PM +0100, Daniel Lezcano wrote:
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index 90aef084..130debf 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -654,6 +654,9 @@ struct rq {
>>   #endif
>>
>>   	struct sched_avg avg;
>> +#ifdef CONFIG_CPU_IDLE
>> +	int idle_index;
>> +#endif
>>   };
>
> So my 'problem' with this is that I've no ff'ing clue what the
> idle_index is and what I can do with it.

The cpuidle framework works with index corresponding to the index in the 
idle states array. This array contains all the idle states the backend 
driver supports. The cpuidle framework will ask for the governor what 
idle state it should uses for the cpu, the governor will look at the 
different characteristics of the idle states + timing information and 
returns an index corresponding to the idle state the governor thinks 
suit better. This step is the 'cpuidle_select'.

Then the cpuidle framework calls the idle callback associated with the 
idle state at the index location. The cpu will stay blocked on this 
callback until an interrupt occurs. This step is the 'cpuidle_enter'.

Between the 'cpuidle_select' and 'cpuidle_enter', this patch stores the 
current idle state the cpu is about to enter (it stores the index). So 
from the scheduler and the current cpuidle api it is easy to get 
information about the idle state a cpu is:

struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);

struct cpuidle_state *state = &drv->states[rq->index];

And from the state, we have the following informations:

struct cpuidle_state {

	[ ... ]

         unsigned int    exit_latency; /* in US */
         int             power_usage; /* in mW */
         unsigned int    target_residency; /* in US */
         bool            disabled; /* disabled on all CPUs */

	[ ... ]
};

IIRC, Alex Shi sent a patchset to improve the choosing of the idlest cpu 
and the exit_latency was needed.



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

