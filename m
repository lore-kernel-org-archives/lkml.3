Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaANI2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:28:41 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53586 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaANI2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:28:38 -0500
Message-ID: <52D4F464.5070707@linux.vnet.ibm.com>
Date: Tue, 14 Jan 2014 13:55:08 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, tuukka.tikkanen@linaro.org
Subject: Re: [PATCH] cpuidle/menu: Fail cpuidle_idle_call() if no idle state
 is acceptable
References: <20140114060516.6109.14901.stgit@preeti.in.ibm.com> <52D4E07E.204@linux.vnet.ibm.com>
In-Reply-To: <52D4E07E.204@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011408-3532-0000-0000-000004B8A619
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

On 01/14/2014 12:30 PM, Srivatsa S. Bhat wrote:
> On 01/14/2014 11:35 AM, Preeti U Murthy wrote:
>> On PowerPC, in a particular test scenario, all the cpu idle states were disabled.
>> Inspite of this it was observed that the idle state count of the shallowest
>> idle state, snooze, was increasing.
>>
>> This is because the governor returns the idle state index as 0 even in
>> scenarios when no idle state can be chosen. These scenarios could be when the
>> latency requirement is 0 or as mentioned above when the user wants to disable
>> certain cpu idle states at runtime. In the latter case, its possible that no
>> cpu idle state is valid because the suitable states were disabled
>> and the rest did not match the menu governor criteria to be chosen as the
>> next idle state.
>>
>> This patch adds the code to indicate that a valid cpu idle state could not be
>> chosen by the menu governor and reports back to arch so that it can take some
>> default action.
>>
> 
> That sounds fair enough. However, the "default" action of pseries idle loop
> (pseries_lpar_idle()) surprises me. It enters Cede, which is _deeper_ than doing
> a snooze! IOW, a user might "disable" cpuidle or set the PM_QOS_CPU_DMA_LATENCY
> to 0 hoping to prevent the CPUs from going to deep idle states, but then the
> machine would still end up going to Cede, even though that wont get reflected
> in the idle state counts. IMHO that scenario needs some thought as well...

Yes I did see this, but since the patch intends to only communicate
whether the cpuidle governor was successful in choosing an idle state on
its part, I wished to address the default action of pseries idle loop
separately. You are right we will need to understand the patch which
introduced this action. I will take a look at it.

> 
>> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/cpuidle/cpuidle.c        |    6 +++++-
>>  drivers/cpuidle/governors/menu.c |    7 ++++---
>>  2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index a55e68f..5bf06bb 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -131,8 +131,9 @@ int cpuidle_idle_call(void)
>>
>>  	/* ask the governor for the next state */
>>  	next_state = cpuidle_curr_governor->select(drv, dev);
>> +
>> +	dev->last_residency = 0;
>>  	if (need_resched()) {
>> -		dev->last_residency = 0;
>>  		/* give the governor an opportunity to reflect on the outcome */
>>  		if (cpuidle_curr_governor->reflect)
>>  			cpuidle_curr_governor->reflect(dev, next_state);
> 
> The comments on top of the .reflect() routines of the governors say that the
> second parameter is the index of the actual state entered. But after this patch,
> next_state can be negative, indicating an invalid index. So those comments need
> to be updated accordingly.

Right, I will take care of the comment in the next post.
> 
>> @@ -140,6 +141,9 @@ int cpuidle_idle_call(void)
>>  		return 0;
>>  	}
>>
>> +	if (next_state < 0)
>> +		return -EINVAL;
> 
> The exit path above (due to need_resched) returns with irqs enabled, but the new
> one you are adding (next_state < 0) returns with irqs disabled. This is correct,
> because in the latter case, "idle" is still in progress and the arch will choose
> a default handler to execute (unlike the former case where "idle" is over and
> hence its time to enable interrupts).

Correct.
> 
> IMHO it would be good to add comments around this code to explain this subtle
> difference. We can never be too careful with these things... ;-)

Ok, will do so.
> 
>> +
>>  	trace_cpu_idle_rcuidle(next_state, dev->cpu);
>>
>>  	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
>> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
>> index cf7f2f0..6921543 100644
>> --- a/drivers/cpuidle/governors/menu.c
>> +++ b/drivers/cpuidle/governors/menu.c
>> @@ -283,6 +283,7 @@ again:
>>   * menu_select - selects the next idle state to enter
>>   * @drv: cpuidle driver containing state data
>>   * @dev: the CPU
>> + * Returns -1 when no idle state is suitable
>>   */
>>  static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>>  {
>> @@ -292,17 +293,17 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>>  	int multiplier;
>>  	struct timespec t;
>>
>> -	if (data->needs_update) {
>> +	if (data->last_state_idx >= 0 && data->needs_update) {
>                ^^^^^
> Doesn't hurt, but actually unnecessary, since ->needs_update is set to 1
> only when index >= 0.

Right we do not need this check. I was assuming that needs_update would
be consistent with the index >= 0 only in the need_resched() case. But
needs_update will get unset each time the governor is invoked to be set
only if index >= 0 thereafter.

> 
>>  		menu_update(drv, dev);
>>  		data->needs_update = 0;
>>  	}
>>
>> -	data->last_state_idx = 0;
>> +	data->last_state_idx = -1;
>>  	data->exit_us = 0;
>>
>>  	/* Special case when user has set very strict latency requirement */
>>  	if (unlikely(latency_req == 0))
>> -		return 0;
>> +		return data->last_state_idx;
>>
>>  	/* determine the expected residency time, round up */
>>  	t = ktime_to_timespec(tick_nohz_get_sleep_length());
>>
> 
> What about the ladder governor? I know its not used that much in practice,
> but I think it would be good to update that as well, just to keep it
> consistent.

Yes this needs to be updated as well. But the ladder governor has a few
other details to take care of in addition to what is taken care of in
the menu governor by this patch. Hence I will be posting that separately.

Thanks

Regards
Preeti U Murthy
> 
> Regards,
> Srivatsa S. Bhat
> 

