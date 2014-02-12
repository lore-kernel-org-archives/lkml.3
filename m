Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaBLMh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:37:59 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36494 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaBLMh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:37:57 -0500
Message-ID: <52FB6B23.5090901@linaro.org>
Date: Wed, 12 Feb 2014 13:37:55 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] idle/cpuidle: Split cpuidle_idle_call main function
 into smaller functions
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org> <52FB4F1D.9030303@linux.vnet.ibm.com>
In-Reply-To: <52FB4F1D.9030303@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 11:38 AM, Preeti U Murthy wrote:
> Hi Daniel,
>
> On 02/11/2014 08:41 PM, Daniel Lezcano wrote:
>> In order to allow better integration between the cpuidle framework and the
>> scheduler, reducing the distance between these two sub-components will
>> facilitate this integration by moving part of the cpuidle code in the idle
>> task file and, because idle.c is in the sched directory, we have access to
>> the scheduler's private structures.
>>
>> This patch splits the cpuidle_idle_call main entry function into 3 calls
>> to a newly added API:
>>   1. select the idle state
>>   2. enter the idle state
>>   3. reflect the idle state
>>
>> The cpuidle_idle_call calls these three functions to implement the main
>> idle entry function.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>   drivers/cpuidle/cpuidle.c |  102 ++++++++++++++++++++++++++++++++-------------
>>   include/linux/cpuidle.h   |   14 +++++++
>>   2 files changed, 87 insertions(+), 29 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index a55e68f..172ab6a 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -108,6 +108,71 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>>   }
>>
>>   /**
>> + * cpuidle_select - ask the cpuidle framework to choose an idle state
>> + *
>> + * @drv: the cpuidle driver
>> + * @dev: the cpuidle device
>> + *
>> + * Returns the index of the idle state. On error it returns:
>> + * -NODEV : the cpuidle framework is not available
>> + * -EBUSY : the cpuidle framework is not initialized
>> + */
>> +int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>> +{
>> +	if (off || !initialized)
>> +		return -ENODEV;
>> +
>> +	if (!drv || !dev || !dev->enabled)
>> +		return -EBUSY;
>
> I would suggest moving the above two conditions under another function,
> cpuidle_enabled() maybe? The reason is, cpuidle_select() indicates that,
> it is invoked to select an idle state. While you are expecting this
> function to return an idle state, it seems counter-intuitive to return a
> ENODEV/EBUSY. This function is expected to be a call into the governor
> specific code and the same function should not be used to verify if
> cpuidle is enabled/not IMHO.

Yes, I fully agree. I will fix that.

>> +
>> +	return cpuidle_curr_governor->select(drv, dev);
>> +}
>> +
>> +/**
>> + * cpuidle_enter - enter into the specified idle state
>> + *
>> + * @drv:   the cpuidle driver tied with the cpu
>> + * @dev:   the cpuidle device
>> + * @index: the index in the idle state table
>> + *
>> + * Returns the index in the idle state, < 0 in case of error.
>> + * The error code depends on the backend driver
>> + */
>> +int cpuidle_enter(struct cpuidle_driver *drv, struct cpuidle_device *dev,
>> +		  int index)
>> +{
>> +	int entered_state;
>> +	bool broadcast = !!(drv->states[index].flags & CPUIDLE_FLAG_TIMER_STOP);
>> +
>> +	if (broadcast)
>> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
>> +
>> +	if (cpuidle_state_is_coupled(dev, drv, index))
>> +		entered_state = cpuidle_enter_state_coupled(dev, drv, index);
>> +	else
>> +		entered_state = cpuidle_enter_state(dev, drv, index);
>> +
>> +	if (broadcast)
>> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
>
> The tip tree, timers/core branch has the patch,
> tick: Introduce hrtimer based broadcast. In the problem scenario that
> this patchset is addressing, the call to broadcast framework may return
> an error indicating that the idle state in question cannot be entered
> into. I wanted to bring it to your notice, so that early on you can take
> care of this. You will need to add code below in the invocation of
> cpuidle_enter() to verify if the idle state was entered into or not. If
> it was not, then you will need to skip tracing and reflecting of the
> idle state and directly exit the cpuidle loop with a failed status.

Ok.

Thanks !


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

