Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264Ab3GaOhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:37:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58200 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab3GaOhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:37:22 -0400
Message-ID: <51F92109.2060707@ti.com>
Date: Wed, 31 Jul 2013 09:36:57 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH RFC 2/3] clk: cpufreq helper for voltage scaling
References: <1373247868-21444-1-git-send-email-mturquette@linaro.org> <1373247868-21444-3-git-send-email-mturquette@linaro.org>
In-Reply-To: <1373247868-21444-3-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2013 08:44 PM, Mike Turquette wrote:
> This patch builds on "clk: notifier handler for dynamic voltage scaling"
> by adding a CPUfreq-specific helper function for registering a clock
> rate-change notifier to scale regulator voltage as a function of clock
> rate.
>
> In particular this patch creates an instance of struct
> cpufreq_frequency_table and also calculate the voltage scaling latency,
> both of which are returned to the caller for use in the CPUfreq driver.
>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>   drivers/clk/clk-voltage-notifier.c | 71 ++++++++++++++++++++++++++++++++++++++
>   include/linux/clk.h                |  6 ++++
>   2 files changed, 77 insertions(+)

As stage 1 of the transition, I dont have any complaints, but for SoC 
level, at least on OMAP, it is not just regulator and clock, we have 
additional tweaks to do - like ABB, AVS etc.

What would you suggest as the strategy to introduce SoC specific 
handlers for voltage notifiers that can co-exist with this?

>
> diff --git a/drivers/clk/clk-voltage-notifier.c b/drivers/clk/clk-voltage-notifier.c
> index cb6b85f..8e1707f 100644
> --- a/drivers/clk/clk-voltage-notifier.c
> +++ b/drivers/clk/clk-voltage-notifier.c
> @@ -10,6 +10,7 @@
>    */
>
>   #include <linux/clk.h>
> +#include <linux/cpufreq.h>

for example - we should not depend on cpufreq in a generic clock based 
dvfs approach. we would like to allow devfreq also to transition to this.

>   #include <linux/device.h>
>   #include <linux/module.h>
>   #include <linux/notifier.h>
> @@ -133,3 +134,73 @@ void of_clk_volt_notifier_unregister(struct notifier_block *nb)
>   	kfree(vsd);
>   }
>   EXPORT_SYMBOL_GPL(of_clk_volt_notifier_unregister);
> +
> +void of_clk_cpufreq_notifier_unregister(struct notifier_block *nb,
> +		struct cpufreq_frequency_table *freq_table)
> +{
> +	struct volt_scale_data *data = to_volt_scale_data(nb);
> +	struct device *dev = data->dev;
> +
> +	opp_free_cpufreq_table(dev, &freq_table);
> +	of_clk_volt_notifier_unregister(nb);
> +}
> +EXPORT_SYMBOL_GPL(of_clk_cpufreq_notifier_unregister);
> +
> +/**
> + * of_clk_cpufreq_notifer_register - register clock notifier to scale voltage
> + * @dev: device that owns this scaling operation
> + * @np: pointer to device's DT node
> + * @clk: clock whose rate-change notifier triggers voltage scaling
> + * @supply: regulator id string
> + * @freq_table: pointer to uninitialized CPUfreq frequency scaling table
> + * @voltage_latency: worst case voltage scaling latency
> + */
> +struct notifier_block *of_clk_cpufreq_notifier_register(struct device *dev,
> +		struct device_node *np, struct clk *clk, const char *supply,
> +		struct cpufreq_frequency_table **table,
> +		unsigned int *voltage_latency)
> +{
> +	struct notifier_block *nb;
> +	struct volt_scale_data *vsd;
> +	struct opp *opp;
> +	unsigned long min, max;
> +	int ret, i;
> +
> +	nb = of_clk_volt_notifier_register(dev, np, clk, supply,
> +			voltage_latency);
> +	if (IS_ERR(nb))
> +		return nb;
> +
> +	vsd = to_volt_scale_data(nb);
> +
> +	ret = opp_init_cpufreq_table(dev, table);
> +	if (ret) {
> +		pr_err("failed to init cpufreq table: %d\n", ret);
> +		goto err_unregister;
> +	}
> +
> +	/* find the min and max voltages and compute worst-case latency */
> +	for (i = 0; table[0][i].frequency != CPUFREQ_TABLE_END; i++)
> +		;
> +
> +	rcu_read_lock();
> +	opp = opp_find_freq_exact(dev,
> +			table[0][0].frequency * 1000, true);
> +	min = opp_get_voltage(opp);
> +	opp = opp_find_freq_exact(dev,
> +			table[0][i-1].frequency * 1000, true);
> +	max = opp_get_voltage(opp);
> +	rcu_read_unlock();
> +
> +	*voltage_latency = regulator_set_voltage_time(vsd->reg, min, max);
> +	if (*voltage_latency < 0)
> +		pr_warn("%s: failed to calculate voltage latency, %d\n",
> +				__func__, ret);
> +
> +	return nb;
> +
> +err_unregister:
> +	of_clk_volt_notifier_unregister(nb);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(of_clk_cpufreq_notifier_register);
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 85ea520..3104883 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -86,6 +86,12 @@ struct notifier_block *of_clk_volt_notifier_register(struct device *dev,
>   		struct device_node *np, struct clk *clk, const char *supply,
>   		int *voltage_latency);
>   void of_clk_volt_notifier_unregister(struct notifier_block *nb);
> +struct notifier_block *of_clk_cpufreq_notifier_register(struct device *dev,
> +		struct device_node *np, struct clk *clk, const char *supply,
> +		struct cpufreq_frequency_table **table,
> +		unsigned int *voltage_latency);
> +void of_clk_cpufreq_notifier_unregister(struct notifier_block *nb,
> +		struct cpufreq_frequency_table *freq_table);
>
>   #endif
>
>


-- 
Regards,
Nishanth Menon
