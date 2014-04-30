Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbaD3Mkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:40:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41097 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbaD3Mkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:40:31 -0400
Message-ID: <5360EF3F.1040003@linaro.org>
Date: Wed, 30 Apr 2014 14:40:31 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] cpuidle / menu: Return error code if there are no
 suitable states
References: <2471963.urOyfY8mOG@vostro.rjw.lan> <6832089.A5AOPipfbA@vostro.rjw.lan> <535E3818.2040905@linaro.org> <2000825.kO1es8ShkW@vostro.rjw.lan>
In-Reply-To: <2000825.kO1es8ShkW@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 01:28 AM, Rafael J. Wysocki wrote:
> On Monday, April 28, 2014 01:14:32 PM Daniel Lezcano wrote:
>> On 04/27/2014 02:55 PM, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> If there is a PM QoS latency limit and all of the sufficiently shallow
>>> C-states are disabled, the cpuidle menu governor returns 0 which on
>>> some systems is CPUIDLE_DRIVER_STATE_START and shouldn't be returned
>>> if that C-state has been disabled.
>>>
>>> Fix the issue by modifying the menu governor to return an error code
>>> in such situations.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> ---
>>>    drivers/cpuidle/governors/menu.c |    2 +-
>>>    include/linux/cpuidle.h          |    2 ++
>>>    2 files changed, 3 insertions(+), 1 deletion(-)
>>>
>>> Index: linux-pm/drivers/cpuidle/governors/menu.c
>>> ===================================================================
>>> --- linux-pm.orig/drivers/cpuidle/governors/menu.c
>>> +++ linux-pm/drivers/cpuidle/governors/menu.c
>>> @@ -296,7 +296,7 @@ static int menu_select(struct cpuidle_dr
>>>    		data->needs_update = 0;
>>>    	}
>>>
>>> -	data->last_state_idx = 0;
>>> +	data->last_state_idx = CPUIDLE_DRIVER_STATE_POLL;
>>>
>>>    	/* Special case when user has set very strict latency requirement */
>>>    	if (unlikely(latency_req == 0))
>>> Index: linux-pm/include/linux/cpuidle.h
>>> ===================================================================
>>> --- linux-pm.orig/include/linux/cpuidle.h
>>> +++ linux-pm/include/linux/cpuidle.h
>>> @@ -217,8 +217,10 @@ static inline int cpuidle_register_gover
>>>
>>>    #ifdef CONFIG_ARCH_HAS_CPU_RELAX
>>>    #define CPUIDLE_DRIVER_STATE_START	1
>>> +#define CPUIDLE_DRIVER_STATE_POLL	0
>>>    #else
>>>    #define CPUIDLE_DRIVER_STATE_START	0
>>> +#define CPUIDLE_DRIVER_STATE_POLL	(-ENXIO)
>>>    #endif
>>>
>>>    #endif /* _LINUX_CPUIDLE_H */
>>
>> Hi Rafael,
>>
>> CPUIDLE_DRIVER_STATE_START is only for x86. It introduces some confusion
>> in the code.
>
> I won't disagree with that.
>
>> As only two drivers are concerned by it, wouldn't make
>> sense to add the poll state to those driver directly instead of having
>> the code hacked around ? (eg. insert the poll state in the common
>> cpuidle code).
>
> Well, what about initializing data->last_state_idx to
> (CPUIDLE_DRIVER_STATE_START - 1) in menu_select() instead of introducing the
> new symbol for the time being and getting rid of CPUIDLE_DRIVER_STATE_START
> separately?

+1


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

