Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbaDWIWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:22:48 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49602 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaDWIWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:22:41 -0400
MIME-Version: 1.0
In-Reply-To: <5356499A.20609@linaro.org>
References: <1398080958-21677-1-git-send-email-chander.kashyap@linaro.org>
	<1398080958-21677-5-git-send-email-chander.kashyap@linaro.org>
	<5356499A.20609@linaro.org>
Date: Wed, 23 Apr 2014 13:52:40 +0530
Message-ID: <CANuQgHEQ_G-fuT6_hyKQ+bT0dsnNW5QnTTLBvX+BZUr4w0Fg2Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] mcpm: exynos: populate suspend and powered_up callbacks
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2014 16:21, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> On 04/21/2014 01:49 PM, Chander Kashyap wrote:
>>
>> In order to support cpuidle through mcpm, suspend and powered-up
>> callbacks are required in mcpm platform code.
>> Hence populate the same callbacks.
>>
>> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> ---
>>   arch/arm/mach-exynos/mcpm-exynos.c |   53
>> ++++++++++++++++++++++++++++++++++++
>>   1 file changed, 53 insertions(+)
>>
>> diff --git a/arch/arm/mach-exynos/mcpm-exynos.c
>> b/arch/arm/mach-exynos/mcpm-exynos.c
>> index 46d4968..16af0bd 100644
>> --- a/arch/arm/mach-exynos/mcpm-exynos.c
>> +++ b/arch/arm/mach-exynos/mcpm-exynos.c
>> @@ -318,10 +318,63 @@ static int exynos_power_down_finish(unsigned int
>> cpu, unsigned int cluster)
>>         return 0; /* success: the CPU is halted */
>>   }
>>
>> +static void enable_coherency(void)
>> +{
>> +       unsigned long v, u;
>> +
>> +       asm volatile(
>> +               "mrc    p15, 0, %0, c1, c0, 1\n"
>> +               "orr    %0, %0, %2\n"
>> +               "ldr    %1, [%3]\n"
>> +               "and    %1, %1, #0\n"
>> +               "orr    %0, %0, %1\n"
>> +               "mcr    p15, 0, %0, c1, c0, 1\n"
>> +               : "=&r" (v), "=&r" (u)
>> +               : "Ir" (0x40), "Ir" (S5P_INFORM0)
>> +               : "cc");
>> +}
>
>
> Shouldn't this function to be used from hotplug.c also ?

Hotplug.c already taking care for this. And anyhow that will go away
for mcpm dependent SoCs

>
>
>> +
>> +void exynos_powered_up(void)
>> +{
>> +       unsigned int mpidr, cpu, cluster;
>> +
>> +       mpidr = read_cpuid_mpidr();
>> +       cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
>> +       cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
>> +
>> +       arch_spin_lock(&bl_lock);
>> +       if (cpu_use_count[cpu][cluster] == 0)
>> +               cpu_use_count[cpu][cluster] = 1;
>> +       arch_spin_unlock(&bl_lock);
>> +}
>> +
>> +static void exynos_suspend(u64 residency)
>> +{
>> +       unsigned int mpidr, cpunr;
>> +
>> +       mpidr = read_cpuid_mpidr();
>> +       cpunr = enynos_pmu_cpunr(mpidr);
>
>
> *enynos*_pmu_cpunr ?

oops, I will fix typo

>
>
>> +
>> +       __raw_writel(virt_to_phys(mcpm_entry_point), REG_ENTRY_ADDR);
>> +
>> +       exynos_power_down();
>> +
>> +       /*
>> +        * Execution reaches here only if cpu did not power down.
>> +        * Hence roll back the changes done in exynos_power_down function.
>> +       */
>> +       __raw_writel(EXYNOS_CORE_LOCAL_PWR_EN,
>> +                       EXYNOS_ARM_CORE_CONFIGURATION(cpunr));
>
>
> Why don't you use the functions defined in the
>
> patch 5/5 arm: exynos: Add MCPM call-back functions

In exynos_core_power_control it powerup the alreay powered down core.
But here i need to simply set this value as core never powered down.

>
> exynos_core_power_control() ?
>
>
>> +       set_cr(get_cr() | CR_C);
>> +       enable_coherency();
>> +}
>> +
>>   static const struct mcpm_platform_ops exynos_power_ops = {
>>         .power_up               = exynos_power_up,
>>         .power_down             = exynos_power_down,
>>         .power_down_finish      = exynos_power_down_finish,
>> +       .suspend                = exynos_suspend,
>> +       .powered_up             = exynos_powered_up,
>>   };
>>
>>   static void __init exynos_mcpm_usage_count_init(void)
>>
>
>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>



-- 
with warm regards,
Chander Kashyap
