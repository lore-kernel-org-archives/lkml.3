Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaGWL56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:57:58 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13980 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbaGWL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:57:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 23 Jul 2014 04:50:02 -0700
Message-ID: <53CFA33F.6030307@nvidia.com>
Date: Wed, 23 Jul 2014 14:57:51 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>	<1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com> <CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>
In-Reply-To: <CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/07/14 07:44, Viresh Kumar wrote:
> On 21 July 2014 21:09, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> 
>> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
>> index 7364a53..df3c73e 100644
>> --- a/drivers/cpufreq/Kconfig.arm
>> +++ b/drivers/cpufreq/Kconfig.arm
>> @@ -244,6 +244,7 @@ config ARM_SPEAR_CPUFREQ
>>  config ARM_TEGRA_CPUFREQ
>>         bool "TEGRA CPUFreq support"
>>         depends on ARCH_TEGRA
>> +       depends on GENERIC_CPUFREQ_CPU0
> 
> Wouldn't this also disturb the existing cpufreq driver for earlier
> tegra platforms? i.e. we don't need cpufreq-cpu0 for them
> atleast as of now.
> 
>>         default y
>>         help
>>           This adds the CPUFreq driver support for TEGRA SOCs.
>> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
>> index db6d9a2..3437d24 100644
>> --- a/drivers/cpufreq/Makefile
>> +++ b/drivers/cpufreq/Makefile
>> @@ -76,6 +76,7 @@ obj-$(CONFIG_ARM_SA1100_CPUFREQ)      += sa1100-cpufreq.o
>>  obj-$(CONFIG_ARM_SA1110_CPUFREQ)       += sa1110-cpufreq.o
>>  obj-$(CONFIG_ARM_SPEAR_CPUFREQ)                += spear-cpufreq.o
>>  obj-$(CONFIG_ARM_TEGRA_CPUFREQ)                += tegra-cpufreq.o
>> +obj-$(CONFIG_ARM_TEGRA_CPUFREQ)                += tegra124-cpufreq.o
> 
> Maybe, you can update the same line if you want.

Oh, right.

> 
>>  obj-$(CONFIG_ARM_VEXPRESS_SPC_CPUFREQ) += vexpress-spc-cpufreq.o
>>
>>  ##################################################################################
>> diff --git a/drivers/cpufreq/tegra124-cpufreq.c b/drivers/cpufreq/tegra124-cpufreq.c
> 
>> +static struct cpufreq_frequency_table *freq_table;
>> +
>> +static struct device *cpu_dev;
>> +static struct clk *cpu_clk;
>> +static struct clk *pllp_clk;
>> +static struct clk *pllx_clk;
>> +static struct clk *dfll_clk;
> 
> The routines in this file are going to be called just once at boot, right?
> In that case we are actually wasting some memory by creating globals.
> Probably just move all these in a struct and allocate it at runtime.
> 

Sure.

[...]
>> +
>> +       ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
>> +       if (ret)
>> +               goto out_put_pllp_clk;
> 
> Why do you need this? cpufreq-cpu0 also does it and this freq_table is
> just not getting used at all then.
> 

Oops, yes I forgot to remove that part when making the conversion.

>> +
>> +       pdev = platform_device_register_simple("cpufreq-tegra124", -1, NULL, 0);
>> +       if (IS_ERR(pdev)) {
>> +               platform_driver_unregister(&tegra124_cpufreq_platdrv);
>> +               return PTR_ERR(pdev);
>> +       }
> 
> Why create another unnecessary platform-device/driver here? If
> of_find_matching_node() passes and you really need to probe cpufreq-cpu0
> here, then just remove the other two calls and move probe's implementation
> here only.
> 

The platform device is required for the deferred probe that can happen if the
DFLL driver hasn't initialized yet, and module_init() callbacks don't seem to
respect -EPROBE_DEFER.

[...]

-- 
nvpublic
