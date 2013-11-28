Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3K1Udm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:33:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53444 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751652Ab3K1Udk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 15:33:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, ceh@ti.com
Subject: Re: [PATCH V3] cpufreq: Make sure CPU is running on a freq from freq-table
Date: Thu, 28 Nov 2013 21:46:30 +0100
Message-ID: <1415633.hVIJGiCZ0n@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <ad0a09012f3621024deb51120c3d4ef97ffcbd0f.1385649767.git.viresh.kumar@linaro.org>
References: <ad0a09012f3621024deb51120c3d4ef97ffcbd0f.1385649767.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 08:14:11 PM Viresh Kumar wrote:
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
> In case current frequency doesn't match any frequency from freq-table, we throw
> warnings to user, so that user can get this fixed in their bootloaders or
> freq-tables.
> 
> On some systems we can't really say what frequency we're running at the moment
> and so for these we have added another flag: CPUFREQ_SKIP_INITIAL_FREQ_CHECK.
> 
> Reported-by: Carlos Hernandez <ceh@ti.com>
> Reported-and-tested-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Well, this looks more and more complicated from version to version ...

> ---
> V2->V3:
> - Added BUG_ON()
> - Added another flag: CPUFREQ_SKIP_INITIAL_FREQ_CHECK
> 
>  drivers/cpufreq/cpufreq.c    | 38 ++++++++++++++++++++++++++++++++++++++
>  drivers/cpufreq/freq_table.c | 24 ++++++++++++++++++++++++
>  include/linux/cpufreq.h      | 11 +++++++++++
>  3 files changed, 73 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 02d534d..1a8bf5d 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1038,6 +1038,44 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
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
> +	 * We are passing target-freq as "policy->cur - 1" otherwise
> +	 * __cpufreq_driver_target() would simply fail, as policy->cur will be
> +	 * equal to target-freq.
> +	 */
> +	if (!(cpufreq_driver->flags & CPUFREQ_SKIP_INITIAL_FREQ_CHECK)
> +			&& has_target()) {

Please set that flag for all x86 cpufreq drivers to start with.

And the usual notation for if()s that span multiple lines is:

	if (!(cpufreq_driver->flags & CPUFREQ_SKIP_INITIAL_FREQ_CHECK)
	   && has_target()) {

i.e. 4 extra spaces after the tab in the continuation lines.

> +		/* Are we running at unknown frequency ? */
> +		ret = cpufreq_frequency_table_get_index(policy, policy->cur);
> +		if (ret == -EINVAL) {
> +			/* Warn user and fix it */
> +			pr_warn("%s: CPU%d: running at invalid freq: %u KHz\n",
> +					__func__, policy->cpu, policy->cur);

You don't have to increment the indentation level by 2 for the continuation
lines (here and below).  +1 is enough usually.

> +			/*
> +			 * Reaching here after boot in a few seconds may not
> +			 * mean that system will remain stable at "unknown"
> +			 * frequency for longer duration. Hence, a BUG_ON().
> +			 */
> +			BUG_ON(__cpufreq_driver_target(policy, policy->cur - 1,
> +					CPUFREQ_RELATION_L));

Write this as

			ret = __cpufreq_driver_target(policy, policy->cur - 1,
						      CPUFREQ_RELATION_L);
			BUG_ON(ret);

And move the comment right before the BUG_ON().

> +			pr_warn("%s: CPU%d: frequency changed to: %u KHz\n",

			pr_warn("%s: CPU%d: Unlisted initial frequency changed to: %u KHz\n",

> +					__func__, policy->cpu, policy->cur);
> +		}
> +	}
> +
>  	/* related cpus should atleast have policy->cpus */
>  	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
>  
> diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
> index 3458d27..0d6cc0e 100644
> --- a/drivers/cpufreq/freq_table.c
> +++ b/drivers/cpufreq/freq_table.c
> @@ -178,7 +178,31 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
>  
> +int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
> +		unsigned int freq)
> +{
> +	struct cpufreq_frequency_table *table;
> +	int index = -EINVAL, i = 0;
> +
> +	table = cpufreq_frequency_get_table(policy->cpu);
> +	if (unlikely(!table)) {
> +		pr_debug("%s: Unable to find freq_table\n", __func__);

		pr_debug("%s: Unable to find frequency table\n", __func__);

> +		return -ENOENT;
> +	}
> +
> +	for (; table[i].frequency != CPUFREQ_TABLE_END; i++) {

	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {

(and don't initialize i upfront).

> +		if (table[i].frequency == freq) {
> +			index = i;
> +			break;
> +		}

I would do

		if (table[i].frequency == freq)
			return i;

> +	}
> +
> +	return index;

	return -EINVAL;

and then the index variable wouldn't be necessary I think?

> +}
> +EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_index);
> +
>  static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
> +
>  /**
>   * show_available_freqs - show available frequencies for the specified CPU
>   */
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index dc196bb..7109c62 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -252,6 +252,15 @@ struct cpufreq_driver {
>   */
>  #define CPUFREQ_ASYNC_NOTIFICATION  (1 << 4)
>  
> +/*
> + * Set by drivers which don't want cpufreq core to check if CPU is running at a
> + * frequency present in freq-table exposed by the driver. For other drivers if
> + * CPU is found running at an out of table freq, we will try to set it to a freq
> + * from the table. And if that fails, we will stop further boot process by
> + * issuing a BUG_ON().
> + */
> +#define CPUFREQ_SKIP_INITIAL_FREQ_CHECK	(1 << 5)
> +
>  int cpufreq_register_driver(struct cpufreq_driver *driver_data);
>  int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
>  
> @@ -439,6 +448,8 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
>  				   unsigned int target_freq,
>  				   unsigned int relation,
>  				   unsigned int *index);
> +int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
> +		unsigned int freq);
>  
>  void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy);
>  ssize_t cpufreq_show_cpus(const struct cpumask *mask, char *buf);

Overall, this looks like code written in a hurry.  Please avoid doing that.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
