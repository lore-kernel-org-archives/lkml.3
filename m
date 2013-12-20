Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3LTKZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:25:11 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7704 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab3LTKZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:25:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Dec 2013 02:26:18 -0800
Message-ID: <52B41B18.30302@nvidia.com>
Date: Fri, 20 Dec 2013 18:25:28 +0800
From: bilhuang <bilhuang@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v5 1/1] cpufreq: tegra: Re-model Tegra20 cpufreq driver
References: <1387451926-21373-1-git-send-email-bilhuang@nvidia.com> <CAKohpomCPJYd+d_NnM9gxwQ7bH6C6=iLxbiWZbfNcjZ8Bi+2wA@mail.gmail.com>
In-Reply-To: <CAKohpomCPJYd+d_NnM9gxwQ7bH6C6=iLxbiWZbfNcjZ8Bi+2wA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 05:31 PM, Viresh Kumar wrote:
> On 19 December 2013 16:48, Bill Huang <bilhuang@nvidia.com> wrote:
>> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
>> index ce52ed9..22dfc43 100644
>> --- a/drivers/cpufreq/Kconfig.arm
>> +++ b/drivers/cpufreq/Kconfig.arm
>> @@ -225,6 +225,18 @@ config ARM_TEGRA_CPUFREQ
>>          help
>>            This adds the CPUFreq driver support for TEGRA SOCs.
>>
>> +config ARM_TEGRA20_CPUFREQ
>> +       bool "NVIDIA TEGRA20"
>> +       depends on ARM_TEGRA_CPUFREQ && ARCH_TEGRA_2x_SOC
>
> Probably just in case you agree to my next comment:
>
>              depends on ARCH_TEGRA_2x_SOC
>
>
>> +       default y
>> +       help
>> +         This enables Tegra20 cpufreq functionality, it adds
>> +         Tegra20 CPU frequency ladder and the call back functions
>> +         to set CPU rate. All the non-SoC dependant codes are
>> +         controlled by the config ARM_TEGRA_CPUFREQ.
>> +
>> +         If in doubt, say N.
>
>
>> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
>>   /*
>> + * Copyright (c) 2013, NVIDIA Corporation. All rights reserved.
>>    *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>>    *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>>    */
>>
>>   #include <linux/kernel.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of.h>
>> +#include <linux/tegra-cpufreq.h>
>> +
>> +int __init tegra_cpufreq_init(void)
>> +{
>> +       struct device_node *root;
>> +
>> +       root = of_find_node_by_path("/");
>> +       if (root) {
>> +               struct platform_device_info devinfo;
>> +               const char *compat;
>> +               int i;
>> +
>> +               memset(&devinfo, 0, sizeof(devinfo));
>> +               i = of_property_count_strings(root, "compatible");
>> +               if (i > 0) {
>> +                       of_property_read_string_index(
>> +                               root, "compatible", i - 1, &compat);
>> +                       devinfo.name = kasprintf(
>> +                                       GFP_KERNEL, "%s-cpufreq", compat);
>> +                       platform_device_register_full(&devinfo);
>> +               }
>>          }
>> +EXPORT_SYMBOL(tegra_cpufreq_init);
>
> Probably above is all that is present in this file. This is just about adding
> the right cpufreq device so that right driver can get probed.
>
> I don't think this code is present at the right place. We don't need a file
> in cpufreq/ which is there just to add a device :) ..
>
> Probably move this piece of code to arch/mach-tegra where you are calling
> init.
>
> And so remove ARM_TEGRA_CPUFREQ config option completely.
>
Don't you think it worth creating a file here so this can be shared to 
arm64?
