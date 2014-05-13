Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbaEMLne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:43:34 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:47767 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365AbaEMLnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:43:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140509153206.GB5040@e102568-lin.cambridge.arm.com>
References: <1399278444-8312-3-git-send-email-chander.kashyap@linaro.org>
	<1399282040-8995-1-git-send-email-chander.kashyap@linaro.org>
	<1399282040-8995-6-git-send-email-chander.kashyap@linaro.org>
	<20140509153206.GB5040@e102568-lin.cambridge.arm.com>
Date: Tue, 13 May 2014 17:13:31 +0530
Message-ID: <CANuQgHG9tGzi2rSOwREAxVu4BQoprDg9om62AybgW5v31fpbTQ@mail.gmail.com>
Subject: Re: [Patch v4 5/5] mcpm: exynos: populate suspend and powered_up callbacks
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo

On 9 May 2014 21:02, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> On Mon, May 05, 2014 at 10:27:20AM +0100, Chander Kashyap wrote:
>> In order to support cpuidle through mcpm, suspend and powered-up
>> callbacks are required in mcpm platform code.
>> Hence populate the same callbacks.
>>
>> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> ---
>> Changes in v4: None
>> Changes in v3:
>>       1. Removed coherancy enablement after suspend failure.
>
> coherency
>
>>       2. Use generic function to poweron cpu.
>> changes in v2:
>>       1. Fixed typo: enynos_pmu_cpunr to exynos_pmu_cpunr
>>  arch/arm/mach-exynos/mcpm-exynos.c |   34 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 34 insertions(+)
>>
>> diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
>> index d0f7461..6d4a907 100644
>> --- a/arch/arm/mach-exynos/mcpm-exynos.c
>> +++ b/arch/arm/mach-exynos/mcpm-exynos.c
>> @@ -256,10 +256,44 @@ static int exynos_power_down_finish(unsigned int cpu, unsigned int cluster)
>>       return -ETIMEDOUT; /* timeout */
>>  }
>>
>> +void exynos_powered_up(void)
>
> static ?

Ok, done

>
>> +{
>> +     unsigned int mpidr, cpu, cluster;
>> +
>> +     mpidr = read_cpuid_mpidr();
>> +     cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
>> +     cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
>> +
>> +     arch_spin_lock(&exynos_mcpm_lock);
>> +     if (cpu_use_count[cpu][cluster] == 0)
>> +             cpu_use_count[cpu][cluster] = 1;
>> +     arch_spin_unlock(&exynos_mcpm_lock);
>> +}
>> +
>> +static void exynos_suspend(u64 residency)
>> +{
>> +     unsigned int mpidr, cpunr;
>> +
>> +     mpidr = read_cpuid_mpidr();
>> +     cpunr = exynos_pmu_cpunr(mpidr);
>
> If I were to be picky, I would compute these values only if they
> are needed, ie move the computation after exynos_power_down().

Yes thats make sense. I will realign it.

>
> There is another quite horrible issue here. We know this code works
> because the processors A15/A7 hit the caches with C bit in SCTLR cleared.
>
> On processors where this is not true, this sequence would explode
> if power down fails (in case core is gated but L2 is still powered on,
> the stack is stuck in L2) since it is going to read stack data that is
> in L2 but can't be read.
>
> It is not related to this sequence only, but it is an issue in general
> and wanted to mention that on the lists for public awareness.
>

Can you please elaborate. I didn't understand.

> The gist of what I am saying is, please add a comment to that extent,
> here and it should be added in exynos_power_down() too.
>
>> +     __raw_writel(virt_to_phys(mcpm_entry_point), ns_sram_base_addr + 0x1c);
>
> No magic numbers please (0x1c). You can add a macro/wrapper, as TC2 does.

Yes i will remove it.

>
>> +     exynos_power_down();
>> +
>> +     /*
>> +      * Execution reaches here only if cpu did not power down.
>> +      * Hence roll back the changes done in exynos_power_down function.
>> +     */
>> +     exynos_cpu_powerup(cpunr);
>
> Please be aware that if this function returns MCPM will soft reboot, and
> the CPUidle driver will have no way to detect a state entry failure.
>
> I am just flagging this up, since fixing this behaviour is not easy, and
> honestly, since power down failure should be the exception not the rule,
> the idle stats should not be affected much.
>
> I think this is the proper way of implementing the sequence but please
> all keep in mind what I wrote above.
>
> Lorenzo
>
>> +}
>> +
>>  static const struct mcpm_platform_ops exynos_power_ops = {
>>       .power_up               = exynos_power_up,
>>       .power_down             = exynos_power_down,
>>       .power_down_finish      = exynos_power_down_finish,
>> +     .suspend                = exynos_suspend,
>> +     .powered_up             = exynos_powered_up,
>>  };
>>
>>  static void __init exynos_mcpm_usage_count_init(void)
>> --
>> 1.7.9.5
>>
>>
>



-- 
with warm regards,
Chander Kashyap
