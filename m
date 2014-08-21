Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaHUHxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:53:50 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:43679 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaHUHxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:53:49 -0400
Message-ID: <53F5A587.9030200@collabora.com>
Date: Thu, 21 Aug 2014 09:53:43 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rabin Vincent <rabin@rab.in>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH v7 3/8] cpufreq: kirkwood: Remove use of the clk provider
 API
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com> <1408375833-10703-4-git-send-email-tomeu.vizoso@collabora.com> <20140820225513.5251.284@quantum>
In-Reply-To: <20140820225513.5251.284@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 12:55 AM, Mike Turquette wrote:
> Quoting Tomeu Vizoso (2014-08-18 08:30:29)
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> ---
>>   drivers/cpufreq/kirkwood-cpufreq.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
>> index 37a4806..f3d087f 100644
>> --- a/drivers/cpufreq/kirkwood-cpufreq.c
>> +++ b/drivers/cpufreq/kirkwood-cpufreq.c
>> @@ -12,7 +12,6 @@
>>   #include <linux/kernel.h>
>>   #include <linux/module.h>
>>   #include <linux/clk.h>
>> -#include <linux/clk-provider.h>
>>   #include <linux/cpufreq.h>
>>   #include <linux/of_device.h>
>>   #include <linux/platform_device.h>
>> @@ -50,7 +49,7 @@ static struct cpufreq_frequency_table kirkwood_freq_table[] = {
>>
>>   static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
>>   {
>> -       if (__clk_is_enabled(priv.powersave_clk))
>> +       if (clk_is_enabled(priv.powersave_clk))
>>                  return kirkwood_freq_table[1].frequency;
>>          return kirkwood_freq_table[0].frequency;
>>   }
>> --
>> 1.9.3
>>
>
> Tomeu,
>
> After taking a second look at clk_is_enabled and the Kirkwood driver, I
> would prefer to not implement clk_is_enabled. The main reason is that it
> is racey, since the clock's status could of course change as soon as as
> that call completes. Furthermore I am worried that drivers might do
> something like:
>
> if (!clk_is_enabled(clk))
> 	clk_enable(clk);
>
> Which is crap and the driver should just call clk_enable any time it
> needs the clock. To that end I propose to drop "clk: provide public
> clk_is_enabled function" and replace your update to kirkwood-cpufreq.c
> with the following patch. Let me know what you think.

Yep, this looks much better to me. I will replace 2/8 and 3/8 with this 
one for v8.

Reviewed-By: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Thanks!

Tomeu

> Regards,
> Mike
>
>
>
>  From 713b46fd66abd26a4e4d584a0b8a2a28c0459a60 Mon Sep 17 00:00:00 2001
> From: Mike Turquette <mturquette@linaro.org>
> Date: Mon, 18 Aug 2014 17:30:29 +0200
> Subject: [PATCH] cpufreq: kirkwood: Remove use of the clk provider API
>
> Instead of checking the clock framework to see if the clock is enabled,
> track the cpu frequency within the driver as the powersave_clk is
> enabled and disabled.
>
> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>   drivers/cpufreq/kirkwood-cpufreq.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
> index 37a4806..88f4641 100644
> --- a/drivers/cpufreq/kirkwood-cpufreq.c
> +++ b/drivers/cpufreq/kirkwood-cpufreq.c
> @@ -12,7 +12,6 @@
>   #include <linux/kernel.h>
>   #include <linux/module.h>
>   #include <linux/clk.h>
> -#include <linux/clk-provider.h>
>   #include <linux/cpufreq.h>
>   #include <linux/of_device.h>
>   #include <linux/platform_device.h>
> @@ -33,6 +32,8 @@ static struct priv
>   #define STATE_CPU_FREQ 0x01
>   #define STATE_DDR_FREQ 0x02
>
> +static unsigned long cpu_frequency = 0;
> +
>   /*
>    * Kirkwood can swap the clock to the CPU between two clocks:
>    *
> @@ -50,9 +51,7 @@ static struct cpufreq_frequency_table kirkwood_freq_table[] = {
>
>   static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
>   {
> -	if (__clk_is_enabled(priv.powersave_clk))
> -		return kirkwood_freq_table[1].frequency;
> -	return kirkwood_freq_table[0].frequency;
> +	return cpu_frequency;
>   }
>
>   static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
> @@ -71,9 +70,11 @@ static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
>   	switch (state) {
>   	case STATE_CPU_FREQ:
>   		clk_disable(priv.powersave_clk);
> +		cpu_frequency = kirkwood_freq_table[0].frequency;
>   		break;
>   	case STATE_DDR_FREQ:
>   		clk_enable(priv.powersave_clk);
> +		cpu_frequency = kirkwood_freq_table[1].frequency;
>   		break;
>   	}
>
> @@ -133,6 +134,7 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>
>   	clk_prepare_enable(priv.cpu_clk);
>   	kirkwood_freq_table[0].frequency = clk_get_rate(priv.cpu_clk) / 1000;
> +	cpu_frequency = kirkwood_freq_table[0].frequency;
>
>   	priv.ddr_clk = of_clk_get_by_name(np, "ddrclk");
>   	if (IS_ERR(priv.ddr_clk)) {
>

