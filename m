Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3LPKwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:52:14 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19369 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3LPKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:52:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 16 Dec 2013 02:54:30 -0800
Message-ID: <52AEDB6A.2080501@nvidia.com>
Date: Mon, 16 Dec 2013 18:52:26 +0800
From: bilhuang <bilhuang@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] cpufreq: tegra: Re-model Tegra20 cpufreq driver
References: <1386840835-28751-1-git-send-email-bilhuang@nvidia.com> <52AB967F.9030900@wwwdotorg.org>
In-Reply-To: <52AB967F.9030900@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 07:21 AM, Stephen Warren wrote:
> On 12/12/2013 02:33 AM, Bill Huang wrote:
>> Re-model Tegra20 cpufreq driver as below.
>>
>> * Rename tegra-cpufreq.c to tegra20-cpufreq.c since this file supports
>>    only Tegra20.
>> * Add probe function so defer probe can be used when we're going to
>>    support DVFS.
>> * Create a fake cpufreq platform device with its name being
>>    "${root_compatible}-cpufreq" so SoC cpufreq driver can bind to it
>>    accordingly.
>
>> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
>
>> +config ARM_TEGRA20_CPUFREQ
>> +	bool "NVIDIA TEGRA20"
>> +	depends on ARM_TEGRA_CPUFREQ && ARCH_TEGRA_2x_SOC
>> +	default y
>> +	help
>> +	  This enables Tegra20 cpufreq functionality, it adds
>> +	  Tegra20 CPU frequency ladder and the call back functions
>> +	  to set CPU rate. All the non-SoC dependant codes are
>> +	  controlled by the config ARM_TEGRA20_CPUFREQ.
>
> I think that last sentence is no longer true in this patch version. Or,
> did you mean to write ARM_TEGRA_CPUFREQ rather than ARM_TEGRA20_CPUFREQ?

Right, should be ARM_TEGRA_CPUFREQ, thanks for catching this.
>
>> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
>
>> +static const char * const tegra_soc_compat[] = {
>> +	"nvidia,tegra124",
>> +	"nvidia,tegra114",
>> +	"nvidia,tegra30",
>> +	"nvidia,tegra20",
>> +	NULL
>>   };
>
> That table will need editing for each chip. I wonder if you can do
> something like always use the very last entry in /compatible. That would
> assume a particular ordering of the compatible entries, but they should
> be in the order $board, $soc anyway...

How do we get subset of a string and making sure it is the last? There 
must be some assumptions here (though they will possibly be true) I 
guess, for example, they should be in the order $board, $soc... and the 
last "nvidia" should be the start of the last compatible id we would 
like to get.
>
>> +int __init tegra_cpufreq_init(void)
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(tegra_soc_compat); i++) {
>> +		if (of_machine_is_compatible(tegra_soc_compat[i])) {
>> +			struct platform_device_info devinfo;
>> +			char buf[40];
>> +
>> +			memset(&devinfo, 0, sizeof(devinfo));
>> +			strcpy(buf, tegra_soc_compat[i]);
>> +			strcat(buf, "-cpufreq");
>
> kasprintf() might be simpler, and would avoid the arbitrary 39-character
> string limit and possibility of overflow.

Ah yeah, thanks.
>
>> +			devinfo.name = buf;
>> +			platform_device_register_full(&devinfo);
>
> Does the devinfo struct need to stick around, i.e. does
> platform_device_register_full keep the pointer, or take a copy of the
> struct? If it keeps the pointer, it'd be best to make devinfo a static
> global variable.

devinfo is used to provide dev info to create platform device structure, 
so I think it is OK here.
>
>> diff --git a/drivers/cpufreq/tegra20-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c
>
> Please pass the "-C" option to "git format-patch"; I assume that almost
> all the code in this file is simply cut/paste verbatim from
> tegra-cpufreq.c where it was deleted.

OK, thanks.
>
>> + * Copyright (C) 2010 Google, Inc.
>
> It's worth adding NV (c) here too.

OK.
>
>> +static int tegra20_cpufreq_remove(struct platform_device *pdev)
>> +{
>> +	cpufreq_unregister_driver(&tegra20_cpufreq_driver);
>> +	return 0;
>> +}
>
> That leaks all the clk_get_sys() calls. Does building this as a module
> work OK?

I should add back those clk_put here.
>
>> +MODULE_LICENSE("GPL");
>
> That should be "GPL v2".

OK.
>
>> diff --git a/include/linux/tegra-cpufreq.h b/include/linux/tegra-cpufreq.h
>
>> +#ifdef CONFIG_ARM_TEGRA_CPUFREQ
>> +int tegra_cpufreq_init(void);
>> +#else
>> +static inline int tegra_cpufreq_init(void)
>> +{ return; }
>> +#endif
>
> If you're going to wrap the { } onto one line, then I think it'd be best
> to wrap the whole thing (prototype and body) onto one line. Otherwise,
> write:
>
> {
> 	return;
> }
>
> Oh, and you need "return 0" not just "return".

Thanks for catching.
>

