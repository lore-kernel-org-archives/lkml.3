Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab3LKSrC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:47:02 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41069 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3LKSq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:46:59 -0500
Message-ID: <52A8B159.4040700@wwwdotorg.org>
Date: Wed, 11 Dec 2013 11:39:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: bilhuang <bilhuang@nvidia.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com> <1386229462-3474-3-git-send-email-bilhuang@nvidia.com> <52A10681.4050906@wwwdotorg.org> <52A58305.3070902@nvidia.com> <52A5FEAF.4050001@wwwdotorg.org> <52A849E8.30107@nvidia.com>
In-Reply-To: <52A849E8.30107@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 04:18 AM, bilhuang wrote:
> On 12/10/2013 01:32 AM, Stephen Warren wrote:
>> On 12/09/2013 01:44 AM, bilhuang wrote:
>>> On 12/06/2013 07:04 AM, Stephen Warren wrote:
>>>> On 12/05/2013 12:44 AM, Bill Huang wrote:
>>>>> Re-model Tegra cpufreq driver to support all Tegra series of SoCs.
>>>>>
>>>>> * Make tegra-cpufreq.c a generic Tegra cpufreq driver.
>>>>> * Move Tegra20 specific codes into tegra20-cpufreq.c.
>>>>> * Bind Tegra cpufreq dirver with a fake device so defer probe would
>>>>> work
>>>>>     when we're going to get regulator in the driver to support voltage
>>>>>     scaling (DVFS).
>>>>
>>>>> diff --git a/drivers/cpufreq/tegra-cpufreq.c
>>>>> b/drivers/cpufreq/tegra-cpufreq.c
>>>>
>>>>> @@ -91,14 +40,10 @@ static int tegra_update_cpu_speed(struct
>>>>> cpufreq_policy *policy,
>>>> ...
>>>>> +    if (soc_config->vote_emc_on_cpu_rate)
>>>>> +        soc_config->vote_emc_on_cpu_rate(rate);
>>>>> +
>>>>> +    ret = soc_config->cpu_clk_set_rate(rate * 1000);
>>>>>        if (ret)
>>>>>            pr_err("cpu-tegra: Failed to set cpu frequency to %lu
>>>>> kHz\n",
>>>>>                rate);
>>>>
>>>> Is there any/much shared code left in this file after this patch? It
>>>> seems like all this file does now is make each cpufreq callback
>>>> function
>>>> call soc_config->the_same_function_name(). If so, wouldn't it be better
>>>> to simply implement completely separate tegar20-cpufreq and
>>>> tegra30-cpufreq drivers, and register them each directly with the
>>>> cpufreq core, to avoid this file doing all the indirection?
>>>
>>> I think this file is needed since we can shared the registration and
>>> probe logic for different SoCs.
>>
>> But there's basically nothing in probe() already, and if we have a
>> separate driver for each SoC, then there's even less code; just a call
>> to devm_kzalloc() for the device-specific data (which will be
>> SoC-specific in size anyway), and a call to cpufreq_register_driver(). I
>> don't think it's worth sharing that if it means that every other
>> function needs to be an indirect function call.
> OK that makes sense.
>>
>>>>> -int __init tegra_cpufreq_init(void)
>>>>> +static struct {
>>>>> +    char *compat;
>>>>> +    int (*init)(struct tegra_cpufreq_data *,
>>>>> +            const struct tegra_cpufreq_config **);
>>>>> +} tegra_init_funcs[] = {
>>>>> +    { "nvidia,tegra20", tegra20_cpufreq_init },
>>>>> +};
>>>>> +
>>>>> +static int tegra_cpufreq_probe(struct platform_device *pdev)
>>>> ...
>>>>> +    for (i = 0; i < ARRAY_SIZE(tegra_init_funcs); i++) {
>>>>> +        if (of_machine_is_compatible(tegra_init_funcs[i].compat)) {
>>>>> +            ret = tegra_init_funcs[i].init(tegra_data, &soc_config);
>>>>> +            if (!ret)
>>>>> +                break;
>>>>> +            else
>>>>> +                goto out;
>>>>> +        }
>>>>>        }
>>>>> +    if (i == ARRAY_SIZE(tegra_init_funcs))
>>>>> +        goto out;
>>>>
>>>> I think there are better ways of doing this than open-coding it.
>>>> Perhaps
>>>> of_match_device() or the platform-driver equivalent could be made to
>>>> work?
>>>
>>> Open coding is everywhere in OF helper functions actually. I doubt if we
>>> can use of_match_device() if we're not adding node in DT.
>>> If we're matching the platform device then we might need open coding,
>>> no?
>>
>> For platform devices, you can set up the id_table of struct
>> platform_driver, and then simply call platform_get_device_id(pdev)
>> inside probe() to find the matching entry. drivers/i2c/busses/i2c-at91.c
>> is an example of how this works (just some random driver I found using
>> grep).
>
> If we're going to have separate driver for each SoC, then we don't need
> platform_get_device_id(pdev) stuffs...

True.

> What I would like to do is creating platform cpufreq device with name
> "${root_compatible}-cpufreq" then each SoC cpufreq driver can bind to
> it, but the question is, which file is the best place to do this? Create
> a new file for this or use existing file like arch/arm/mach-tegra/tegra.c?

I think create the device in
drivers/cpufreq/cpufreq-tegra.c:tegra_cpufreq_init() (which is possibly
all that file would contain), and call that function from
arch/arm/mach-tegra/tegra.c. That way, we'll be able to share the
implementation of tegra_cpufreq_init() with any ARMv8 CPUs that might
appear.
