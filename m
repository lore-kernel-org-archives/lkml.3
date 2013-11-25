Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab3KYQim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:38:42 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54599 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3KYQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:38:39 -0500
Message-ID: <52937D0C.1020501@gmail.com>
Date: Mon, 25 Nov 2013 08:38:36 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, ceh@ti.com
Subject: Re: [PATCH V2] cpufreq: Make sure CPU is running on a freq from freq-table
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org>
In-Reply-To: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2013 08:23 PM, Viresh Kumar wrote:
> Sometimes boot loaders set CPU frequency to a value outside of frequency table
> present with cpufreq core. In such cases CPU might be unstable if it has to run
> on that frequency for long duration of time and so its better to set it to a
> frequency which is specified in freq-table. This also makes cpufreq stats
> inconsistent as cpufreq-stats would fail to register because current frequency
> of CPU isn't found in freq-table.
>

IMHO this issue should be fixed in the scaling driver for the platform.

The scaling driver sets policy->cur and fills in the frequency table and has the
abilty to adjust the frequency of the CPU.  Letting this leak up into the core
is wrong IMHO and just widens the window where the CPU will be running at the
wrong frequency set by the bootloader.

> Because we don't want this change to effect boot process badly, we go for the
> next freq which is >= policy->cur ('cur' must be set by now, otherwise we will
> end up setting freq to lowest of the table as 'cur' is initialized to zero).
>
> In case where CPU is already running on one of the frequencies present in
> freq-table, this would turn into a dummy call as __cpufreq_driver_target() would
> return early.
>
> Reported-by: Carlos Hernandez <ceh@ti.com>
> Reported-and-tested-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V1->V2
> - Set to (policy->cur - 1) instead of policy->cur.
> - return early in case __cpufreq_driver_target() fails.
>
>   drivers/cpufreq/cpufreq.c | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 02d534d..7be996c 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1038,6 +1038,38 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>   		}
>   	}
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
> +	 *
> +	 * We are passing target-freq as "policy->cur - 1" otherwise
> +	 * __cpufreq_driver_target() would simply fail, as policy->cur will be
> +	 * equal to target-freq.
> +	 */

Shouldn't there be a check to see if the problem exists at all?  Otherwise
the core is setting a policy for ALL platform even those where the issue does
not exist.

> +	if (has_target()) {
> +		ret = __cpufreq_driver_target(policy, policy->cur - 1,
> +				CPUFREQ_RELATION_L);
> +		if (ret) {
> +			pr_err("%s: Unable to set frequency from table: %d\n",
> +					__func__, ret);
> +			goto err_out_unregister;
> +		}
> +	}
> +
>   	/* related cpus should atleast have policy->cpus */
>   	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
>
>

