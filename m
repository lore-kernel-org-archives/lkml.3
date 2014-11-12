Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaKLQn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:43:29 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45406 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbaKLQn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:43:27 -0500
Message-ID: <54638E28.6050304@linaro.org>
Date: Wed, 12 Nov 2014 17:43:20 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Colin Cross <ccross@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH 2/2] cpuidle: exynos: add coupled cpuidle support for
 Exynos4210
References: <1415383252-20118-1-git-send-email-b.zolnierkie@samsung.com> <1415383252-20118-3-git-send-email-b.zolnierkie@samsung.com> <545F8EFF.7030704@linaro.org> <3813280.9hNcruz8Q6@amdc1032>
In-Reply-To: <3813280.9hNcruz8Q6@amdc1032>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 04:13 PM, Bartlomiej Zolnierkiewicz wrote:
>

Hi Bartlomiej,

[ cut ]

>>> - using arch_send_wakeup_ipi_mask() instead of dsb_sev()
>>>     (this matches CPU hotplug code in arch/arm/mach-exynos/platsmp.c)
>>
>> I am curious. You experienced very rare hangs after running the tests a
>> few hours, right ? Is the SEV replaced by the IPI solving the issue ? If
>> yes, how did you catch it ?
>
> Rare hangs showed up after about 30-40 minutes of testing with the attached
> app and script (running of "./cpuidle_state1_test.sh script 2 500" has never
> completed on the umodified driver).
>
> The problem turned out to be in the following loop waiting for CPU1 to get
> stuck in the BOOT ROM:
>
> 		/*
> 		 * Wait for cpu1 to get stuck in the boot rom
> 		 */
> 		while ((__raw_readl(BOOT_VECTOR) != 0) &&
> 		       !atomic_read(&cpu1_wakeup))
> 			cpu_relax();
>
> [ Removal of the loop fixed the problem. ]

Just for my personal information, do you know why ?

> Using the SEV instead of the IPI was not a issue but it was changed to
> match the existing Exynos platform code (exynos_boot_secondary() in
> arch/arm/mach-exynos/platsmp.c) and as preparation for Exynos4412 (quad
> core) support.

Ah, ok. Thanks for the info.

[ cut ]

>>> +#ifdef CONFIG_ARM_EXYNOS_CPUIDLE
>>> +	if (of_machine_is_compatible("samsung,exynos4210"))
>>> +		exynos_cpuidle.dev.platform_data = &cpuidle_coupled_exynos_data;
>>> +#endif
>>
>> You should not add those #ifdef.
>
> Without those #ifdef I get:
>
>    LD      init/built-in.o
> arch/arm/mach-exynos/built-in.o: In function `exynos_dt_machine_init':
> /home/bzolnier/sam/linux-sprc/arch/arm/mach-exynos/exynos.c:334: undefined reference to `cpuidle_coupled_exynos_data'
> make: *** [vmlinux] Error 1
>
> when CONFIG_EXYNOS_CPU_SUSPEND is disabled.

Here, we are introducing some dependencies I tried to drop in the 
different drivers.

I looked more closely at the code and especially the 
'cpuidle_coupled_exynos_data'. I don't think it is worth to have it 
because it adds more complexity and you have to define this structure to 
be visible from the drivers/cpuidle files.

I suggest you create an simple function in "pm.c"

int exynos_coupled_aftr(int cpu)
{
	pre_enter...

	if (!cpu)
		cpu0_enter_aftr()
	else
		cpu1_powerdown()

	post_enter...
}

and in the cpuidle driver itself, you just use the already existing 
anonymous callback 'exynos_enter_aftr' (and mutate it to conform the 
parameters).

You won't have to share any structure between the arch code and the 
cpuidle driver.


>>>    	if (of_machine_is_compatible("samsung,exynos4210") ||
>>>    	    of_machine_is_compatible("samsung,exynos4212") ||
>>>    	    (of_machine_is_compatible("samsung,exynos4412") &&
>>> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c

[ cut ]

>>> -	exynos_enter_aftr = (void *)(pdev->dev.platform_data);
>>> +	if (of_machine_is_compatible("samsung,exynos4210")) {
>>> +		exynos_cpuidle_pdata = pdev->dev.platform_data;
>>> +
>>> +		exynos_idle_driver.states[1].enter =
>>> +						exynos_enter_coupled_lowpower;
>>> +		exynos_idle_driver.states[1].exit_latency = 5000;
>>> +		exynos_idle_driver.states[1].target_residency = 10000;
>>> +		exynos_idle_driver.states[1].flags |= CPUIDLE_FLAG_COUPLED |
>>> +						      CPUIDLE_FLAG_TIMER_STOP;
>>
>> I tried to remove those dynamic state allocation everywhere in the
>> different drivers. I would prefer to have another cpuidle_driver to be
>> registered with its states instead of overwriting the existing idle state.
>>
>> struct cpuidle_driver exynos4210_idle_driver = {
>> 	.name = "exynos4210_idle",
>> 	.owner = THIS_MODULE,
>> 	.states = {
>> 		[0] = ARM_CPUIDLE_WFI_STATE,
>>                   [1] = {
>>                           .enter = exynos_enter_coupled_lowpower,
>>                           .exit_latency = 5000,
>>                           .target_residency = 10000,
>> 			.flags = CPUIDLE_FLAG_TIME_VALID |
>> 				CPUIDLE_FLAG_COUPLED |
>> 				CPUIDLE_FLAG_TIMER_STOP,
>>                           .name = "C1",
>>                           .desc = "ARM power down",
>>                   },
>> 	}
>> };
>>
>>
>> and then:
>>
>> if (of_machine_is_compatible("samsung,exynos4210")) {
>> 	...
>> 	ret = cpuidle_register(&exynos4210_idle_driver,
>> 				cpu_online_mask);
>> 	...
>> }
>> ...
>
> OK, I will fix it but (if you are OK with it) I will make the code use
> "exynos_coupled" naming instead of "exynos4210" one to not have to change
> it later.
>
>> If we can reuse this mechanism, which I believe it is possible to, for
>> 4420 and 5250. Then we will be able to refactor this out again.

Ok, sounds good.

> I plan to add support for Exynos3250 next as it should be the simplest
> (it is also dual core) and I need it for other reasons anyway.  Exynos4412
> (quad core) support requires more work but should also be doable.
>
> When it comes to Exynos5250 I was thinking about disabling normal AFTR
> mode support for it as according to my testing (on Arndale board) it has
> never worked (at least in upstream kernels, I don't know about Linaro or
> internal ones).

The AFTR state worked on my 5250 very well. It is a Arndale board.


Thanks for resurrecting the patch and providing the multi core idle 
support. I am too busy to refocus on that right now.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

