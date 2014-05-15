Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaEOSru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:47:50 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:50056 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaEOSrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:47:47 -0400
Date: Thu, 15 May 2014 14:52:54 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com,
        rjw@rjwysocki.net
Subject: Re: [RFC PATCH 3/5] thermal: cpu_cooling: Add support to find nearby
 frequency levels.
Message-ID: <20140515185254.GC3138@developer>
References: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
 <1399559880-20562-4-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399559880-20562-4-git-send-email-amit.daniel@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Amit,

On Thu, May 08, 2014 at 08:07:58PM +0530, Amit Daniel Kachhap wrote:
> This patch adds suuport to get P state ceil/floor level for nearest frequency.
> This will be used for consolidating ACPI cpufreq cooling via the generic cpu
> cooling framework.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/cpu_cooling.c                   |   42 +++++++++++++++++------
>  drivers/thermal/samsung/exynos_thermal_common.c |    3 +-
>  include/linux/cpu_cooling.h                     |   23 ++++++++++++-
>  3 files changed, 55 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index e2aeb36..6f5430e 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -120,12 +120,7 @@ static int is_cpufreq_valid(int cpu)
>  	return !cpufreq_get_policy(&policy, cpu);
>  }
>  
> -enum cpufreq_cooling_property {
> -	GET_LEVEL,
> -	GET_FREQ,
> -	GET_MAXL,
> -};
> -
> +#define GET_FREQ (GET_MAXL + 1)

What happens if we add another level manipulating after GET_MAXL? say,
GET_MINL?

>  /**
>   * get_property - fetch a property of interest for a give cpu.
>   * @cpu: cpu for which the property is required
> @@ -207,15 +202,37 @@ static int get_property(unsigned int cpu, unsigned long input,
>  		/* now we have a valid frequency entry */
>  		freq = table[i].frequency;
>  
> -		if (property == GET_LEVEL && (unsigned int)input == freq) {
> +		if (property == GET_LEVEL_EXACT &&
> +					(unsigned int)input == freq) {
>  			/* get level by frequency */
>  			*output = descend ? j : (max_level - j);
>  			return 0;
> -		}
> -		if (property == GET_FREQ && level == j) {
> +		} else if (property == GET_FREQ && level == j) {
>  			/* get frequency by level */
>  			*output = freq;
>  			return 0;
> +		} else if (property == GET_LEVEL_FLOOR) {
> +			/* get minimum possible level by frequency */
> +			if (descend && freq <= input) {
> +				*output = j;
> +				return 0;
> +			} else if (!descend) {
> +				if (freq <= input)
> +					*output = (max_level - j);
> +				else
> +					return 0;
> +			}
> +		} else if (property == GET_LEVEL_CEIL) {
> +			/* get maximum possible level by frequency */
> +			if (!descend && freq >= input) {
> +				*output = (max_level - j);
> +				return 0;
> +			} else if (descend) {
> +				if (freq >= input)
> +					*output = j;
> +				else
> +					return 0;
> +			}
>  		}
>  		j++;
>  	}
> @@ -227,6 +244,8 @@ static int get_property(unsigned int cpu, unsigned long input,
>   * cpufreq_cooling_get_level - for a give cpu, return the cooling level.
>   * @cpu: cpu for which the level is required
>   * @freq: the frequency of interest
> + * @property: can be GET_LEVEL_CEIL, GET_LEVEL_FLOOR, GET_LEVEL_EXACT or
> + * GET_MAXL
>   *
>   * This function will match the cooling level corresponding to the
>   * requested @freq and return it.
> @@ -234,11 +253,12 @@ static int get_property(unsigned int cpu, unsigned long input,
>   * Return: The matched cooling level on success or THERMAL_CSTATE_INVALID
>   * otherwise.
>   */
> -unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq)
> +unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq,
> +			enum cpufreq_cooling_property property)
>  {
>  	unsigned int val;
>  
> -	if (get_property(cpu, (unsigned long)freq, &val, GET_LEVEL))
> +	if (get_property(cpu, (unsigned long)freq, &val, property))
>  		return THERMAL_CSTATE_INVALID;
>  
>  	return (unsigned long)val;
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
> index a7306fa..aa4696b 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -156,7 +156,8 @@ static int exynos_bind(struct thermal_zone_device *thermal,
>  	/* Bind the thermal zone to the cpufreq cooling device */
>  	for (i = 0; i < tab_size; i++) {
>  		clip_data = (struct freq_clip_table *)&(tab_ptr[i]);
> -		level = cpufreq_cooling_get_level(0, clip_data->freq_clip_max);
> +		level = cpufreq_cooling_get_level(0, clip_data->freq_clip_max,
> +						GET_LEVEL_EXACT);
>  		if (level == THERMAL_CSTATE_INVALID)
>  			return 0;
>  		switch (GET_ZONE(i)) {
> diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
> index f786935..f4d2b0e 100644
> --- a/include/linux/cpu_cooling.h
> +++ b/include/linux/cpu_cooling.h
> @@ -44,6 +44,13 @@ struct cpufreq_cooling_status {
>  	void *devdata;
>  };
>  
> +enum cpufreq_cooling_property {
> +	GET_LEVEL_CEIL,
> +	GET_LEVEL_FLOOR,
> +	GET_LEVEL_EXACT,
> +	GET_MAXL,
> +};

Please document this enum.

> +
>  #ifdef CONFIG_CPU_THERMAL
>  /**
>   * cpufreq_cooling_register - function to create cpufreq cooling device.
> @@ -77,7 +84,21 @@ of_cpufreq_cooling_register(struct device_node *np,
>   */
>  void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
>  
> -unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq);
> +/**
> + * cpufreq_cooling_get_level - for a give cpu, return the cooling level.
> + * @cpu: cpu for which the level is required
> + * @freq: the frequency of interest
> + * @property: can be GET_LEVEL_CEIL, GET_LEVEL_FLOOR, GET_LEVEL_EXACT or
> + * GET_MAXL
> + *
> + * This function will match the cooling level corresponding to the
> + * requested @freq and return it.
> + *
> + * Return: The matched cooling level on success or THERMAL_CSTATE_INVALID
> + * otherwise.
> + */
> +unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq,
> +					enum cpufreq_cooling_property);
>  
>  /**
>   * cpufreq_cooling_register_notifier - register a driver with cpufreq cooling.
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
