Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbaGXK1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:27:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47020 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044AbaGXK1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:27:31 -0400
Message-ID: <53D0DF90.3040307@linaro.org>
Date: Thu, 24 Jul 2014 12:27:28 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] cpuidle: coupled: Enable interrupts when early returning
 on invalid driver
References: <1406193999-20300-1-git-send-email-k.kozlowski@samsung.com> <53D0D348.406@linaro.org> <1406195191.21857.6.camel@AMDC1943>
In-Reply-To: <1406195191.21857.6.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 11:46 AM, Krzysztof Kozlowski wrote:
> On czw, 2014-07-24 at 11:35 +0200, Daniel Lezcano wrote:
>> On 07/24/2014 11:26 AM, Krzysztof Kozlowski wrote:
>>> cpuidle_enter_state is expected to return with interrupts enabled.
>>> However cpuidle_enter_state_coupled returned with interrupts disabled if
>>> the cpuidle driver was registered without mask of coupled cpus.
>>
>> Hi Krzysztof,
>>
>> may be your patch is right but I would like to clarify one thing. This
>> is the cpuidle driver for exynos. AFAICT, the coupled states shouldn't
>> be enabled for this driver, so how did you face this issue ?
>
> I faced this on cpuidle drivers on both Exynos and MSM. But these were
> not mainline cpuidle drivers.

Ok, I think the root problem is the FLAG_COUPLED is set for the state 
but without the cpumask. I don't think we should handle that in the 
enter_couple function but in the registering of the device and fail to 
register the driver/device if the informations are not properly set.

In this case, we know the sanity checks are done one time at the 
registering time and we don't need to do that each time when entering in 
the enter coupled function. Hence the "if (!coupled)" disappear and no 
need to re-enable the irq.


>>> This could be observed as a warning:
>>> [    1.613132] ------------[ cut here ]------------
>>> [    1.613244] WARNING: CPU: 0 PID: 0 at kernel/sched/idle.c:175 cpu_idle_loop+0x2dc/0x6d0()
>>> [    1.620268] Modules linked in:
>>> [    1.623311] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc4-00102-g7669ccdbf8af-dirty #81
>>> [    1.623619] dwmmc_exynos 12510000.mshc: 1 slots initialized
>>> [    1.624890] logger: created 256K log 'log_main'
>>> [    1.625483] logger: created 256K log 'log_events'
>>> [    1.626084] logger: created 256K log 'log_radio'
>>> [    1.626699] logger: created 256K log 'log_system'
>>> [    1.655960] [<c00167cc>] (unwind_backtrace) from [<c0012c28>] (show_stack+0x10/0x14)
>>> [    1.663679] [<c0012c28>] (show_stack) from [<c050ab00>] (dump_stack+0x70/0xbc)
>>> [    1.670883] [<c050ab00>] (dump_stack) from [<c0023ac8>] (warn_slowpath_common+0x68/0x8c)
>>> [    1.678954] [<c0023ac8>] (warn_slowpath_common) from [<c0023b08>] (warn_slowpath_null+0x1c/0x24)
>>> [    1.687720] [<c0023b08>] (warn_slowpath_null) from [<c006ddd4>] (cpu_idle_loop+0x2dc/0x6d0)
>>> [    1.696052] [<c006ddd4>] (cpu_idle_loop) from [<c006e1d4>] (cpupri_find+0x0/0xd4)
>>> [    1.703518] [<c006e1d4>] (cpupri_find) from [<c07cdd14>] (processor_id+0x0/0x2c)
>>> [    1.710917] ---[ end trace a85327313857296e ]---
>>>
>>> Enable the interrupts also when early returning from
>>> cpuidle_enter_state_coupled due to invalid coupled configuration.
>>>
>>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>> Fixes: 4126c0197bc8 ("cpuidle: add support for states that affect multiple cpus")
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>    drivers/cpuidle/coupled.c | 4 +++-
>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
>>> index 73fe2f8d7f96..2b57c267e855 100644
>>> --- a/drivers/cpuidle/coupled.c
>>> +++ b/drivers/cpuidle/coupled.c
>>> @@ -463,8 +463,10 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
>>>    	struct cpuidle_coupled *coupled = dev->coupled;
>>>    	int w;
>>>
>>> -	if (!coupled)
>>> +	if (!coupled) {
>>> +		local_irq_enable();
>>>    		return -EINVAL;
>>> +	}
>>>
>>>    	while (coupled->prevent) {
>>>    		cpuidle_coupled_clear_pokes(dev->cpu);
>>>
>>
>>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

