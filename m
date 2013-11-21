Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3KUM7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:59:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64078 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752662Ab3KUM7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:59:17 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: nm@ti.com, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org, ceh@ti.com
Subject: Re: [PATCH] cpufreq: Make sure CPU is running on a freq from freq-table
Date: Thu, 21 Nov 2013 14:11:57 +0100
Message-ID: <3577662.BKCLJdcf18@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <de5c3ff26e9d06a6e0b06f8ba3da6d8c3ff82304.1385017369.git.viresh.kumar@linaro.org>
References: <de5c3ff26e9d06a6e0b06f8ba3da6d8c3ff82304.1385017369.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 21, 2013 12:39:02 PM Viresh Kumar wrote:
> Sometimes boot loaders set CPU frequency to a value outside of frequency table
> present with cpufreq core. In such cases CPU might be unstable if it has to run
> on that frequency for long duration of time and so its better to set it to a
> frequency which is specified in freq-table. This also makes cpufreq stats
> inconsistent as cpufreq-stats would fail to register because current frequency
> of CPU isn't found in freq-table.
> 
> Because we don't want this change to effect boot process badly, we go for the
> next freq which is >= policy->cur ('cur' must be set by now, otherwise we will
> end up setting freq to lowest of the table as 'cur' is initialized to zero).
> 
> In case where CPU is already running on one of the frequencies present in
> freq-table, this would turn into a dummy call as __cpufreq_driver_target() would
> return early.
> 
> Reported-by: Carlos Hernandez <ceh@ti.com>
> Reported-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> After lots of discussion with Nishanth and others, I feel something like this..
> 
> @Nishanth: Please see if this works for you and I hope we don't need any of
> these patches anymore:
> 
> - https://lkml.org/lkml/2013/11/15/569 : cpufreq: cpufreq-cpu0: Use a sane boot
> frequency when booting with a mismatched bootloader configuration
> - https://lkml.org/lkml/2013/11/15/503 : cpufreq: stats: Do not populate stats
>   when policy->cur has no exact match
> - https://lkml.org/lkml/2013/11/19/16 : cpufreq/stats: Add "unknown" frequency
>   field in stats tables
> 
>  drivers/cpufreq/cpufreq.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 02d534d..d55c843 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1038,6 +1038,32 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  		}
>  	}
>  
> +	/*
> +	 * Sometimes boot loaders set CPU frequency to a value outside of
> +	 * frequency table present with cpufreq core. In such cases CPU might be
> +	 * unstable if it has to run on that frequency for long duration of time
> +	 * and so its better to set it to a frequency which is specified in
> +	 * freq-table. This also makes cpufreq stats inconsistent as
> +	 * cpufreq-stats would fail to register because current frequency of CPU
> +	 * isn't found in freq-table.
> +	 *
> +	 * Because we don't want this change to effect boot process badly, we go
> +	 * for the next freq which is >= policy->cur ('cur' must be set by now,
> +	 * otherwise we will end up setting freq to lowest of the table as 'cur'
> +	 * is initialized to zero).
> +	 *
> +	 * In case where CPU is already running on one of the frequencies
> +	 * present in freq-table, this would turn into a dummy call as
> +	 * __cpufreq_driver_target() would return early.
> +	 */
> +	if (has_target()) {
> +		ret = __cpufreq_driver_target(policy, policy->cur,
> +				CPUFREQ_RELATION_L);
> +		if (ret)
> +			pr_err("%s: Unable to set frequency from table: %d\n",
> +					__func__, ret);

Should we continue in that case?

> +	}
> +
>  	/* related cpus should atleast have policy->cpus */
>  	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
