Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3LQKsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:48:07 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15340 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3LQKsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:48:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Dec 2013 02:50:17 -0800
Message-ID: <52B02BF4.1060308@nvidia.com>
Date: Tue, 17 Dec 2013 18:48:20 +0800
From: bilhuang <bilhuang@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] cpufreq: tegra: Call tegra_cpufreq_init() specifically
 in machine code
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>	<1386229462-3474-2-git-send-email-bilhuang@nvidia.com> <CAKohpo=OAg96OUe_dmitd_OWThtZv6M+0fsx=4ngCez0MgDhLw@mail.gmail.com>
In-Reply-To: <CAKohpo=OAg96OUe_dmitd_OWThtZv6M+0fsx=4ngCez0MgDhLw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 02:31 PM, Viresh Kumar wrote:
> On 5 December 2013 13:14, Bill Huang <bilhuang@nvidia.com> wrote:
>> Move the call from module_init to Tegra machine codes so it won't be
>> called in a multi-platform kernel running on non-Tegra SoCs.
>>
>> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
>> ---
>>   arch/arm/mach-tegra/tegra.c     |    2 ++
>>   drivers/cpufreq/tegra-cpufreq.c |   13 ++-----------
>>   include/linux/tegra-soc.h       |   11 ++++++++++-
>>   3 files changed, 14 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
>> index 7336817..14490ad 100644
>> --- a/arch/arm/mach-tegra/tegra.c
>> +++ b/arch/arm/mach-tegra/tegra.c
>> @@ -34,6 +34,7 @@
>>   #include <linux/usb/tegra_usb_phy.h>
>>   #include <linux/clk/tegra.h>
>>   #include <linux/irqchip.h>
>> +#include <linux/tegra-soc.h>
>>
>>   #include <asm/hardware/cache-l2x0.h>
>>   #include <asm/mach-types.h>
>> @@ -160,6 +161,7 @@ static void __init tegra_dt_init_late(void)
>>   {
>>          int i;
>>
>> +       tegra_cpufreq_init();
>>          tegra_init_suspend();
>>          tegra_cpuidle_init();
>>          tegra_powergate_debugfs_init();
>> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
>> index 63f0059..ae1c0f1 100644
>> --- a/drivers/cpufreq/tegra-cpufreq.c
>> +++ b/drivers/cpufreq/tegra-cpufreq.c
>> @@ -155,7 +155,7 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
>>   #endif
>>   };
>
> Remove module.h as well ??
>
>> -static int __init tegra_cpufreq_init(void)
>> +int __init tegra_cpufreq_init(void)
>>   {
>>          cpu_clk = clk_get_sys(NULL, "cclk");
>>          if (IS_ERR(cpu_clk))
>> @@ -177,17 +177,8 @@ static int __init tegra_cpufreq_init(void)
>>
>>          return cpufreq_register_driver(&tegra_cpufreq_driver);
>>   }
>> -
>> -static void __exit tegra_cpufreq_exit(void)
>> -{
>> -        cpufreq_unregister_driver(&tegra_cpufreq_driver);
>> -       clk_put(emc_clk);
>> -       clk_put(cpu_clk);
>> -}
>> -
>> +EXPORT_SYMBOL(tegra_cpufreq_init);
>>
>>   MODULE_AUTHOR("Colin Cross <ccross@android.com>");
>>   MODULE_DESCRIPTION("cpufreq driver for Nvidia Tegra2");
>>   MODULE_LICENSE("GPL");
>
> Remove these as well? As they don't have a meaning for Tegra
> cpufreq driver which can't be compiled as module.
OK thanks.
>
>> -module_init(tegra_cpufreq_init);
>> -module_exit(tegra_cpufreq_exit);
>
> Rest as what Stephen suggested.
>

