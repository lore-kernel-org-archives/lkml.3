Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937000Ab3DIOzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:55:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54363 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761809Ab3DIOza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:55:30 -0400
Message-ID: <51642BD5.4030803@ti.com>
Date: Tue, 9 Apr 2013 10:55:17 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <eduardo.valentin@ti.com>
Subject: Re: [PATCH] thermal: fix frequency table lookup bugs
References: <1365465287-24530-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1365465287-24530-1-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 08-04-2013 19:54, Andrew Bresticker wrote:
> The loops which are used to perform lookups in CPU frequency tables in
> cpu_cooling and the Exynos thermal driver do not update the loop counter
> if they encounter an invalid table entry, leading to an infinite loop in
> that case.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>   drivers/thermal/cpu_cooling.c    | 19 ++++++++++---------
>   drivers/thermal/exynos_thermal.c |  8 ++++----
>   2 files changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 836828e..e6db441 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -124,14 +124,14 @@ static int is_cpufreq_valid(int cpu)
>   static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>   {
>   	int ret = 0, i = 0;
> -	unsigned long level_index;
> +	unsigned long level_index = 0;
>   	bool descend = false;
>   	struct cpufreq_frequency_table *table =
>   					cpufreq_frequency_get_table(cpu);
>   	if (!table)
>   		return ret;
>
> -	while (table[i].frequency != CPUFREQ_TABLE_END) {
> +	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>   		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>   			continue;
Wouldn't be easier to just increase the index i before doing a continue?

>
> @@ -143,24 +143,25 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>   		}
>
>   		/*return if level matched and table in descending order*/
> -		if (descend && i == level)
> +		if (descend && level_index == level)
>   			return table[i].frequency;

What this has to do with the patch description? Besides why would you be 
comparing level against 0 all the time (you have initialized level_index 
to 0 at this point).

> -		i++;
> +		level_index++;

level_index wont be updated in case of INVALID entry.

>   	}
>   	i--;
> +	level_index--;
>
> -	if (level > i || descend)
> +	if (level > level_index || descend)
>   		return ret;
> -	level_index = i - level;
> +	level = level_index - level;
>
>   	/*Scan the table in reverse order and match the level*/
> -	while (i >= 0) {
> +	for (; i >= 0; i--) {
>   		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>   			continue;
>   		/*return if level matched*/
> -		if (i == level_index)
> +		if (level_index == level)
>   			return table[i].frequency;
> -		i--;
> +		level_index--;
>   	}

I believe you do more than what you have described in your intention 
under you patch description

Can you please split your patch into smaller changes?
>   	return ret;
>   }
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> index d5e6267..524b2a0 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -237,7 +237,7 @@ static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
>
>   static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>   {
> -	int i = 0, ret = -EINVAL;
> +	int i, level = 0, ret = -EINVAL;
>   	struct cpufreq_frequency_table *table = NULL;
>   #ifdef CONFIG_CPU_FREQ
>   	table = cpufreq_frequency_get_table(cpu);
> @@ -245,12 +245,12 @@ static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>   	if (!table)
>   		return ret;
>
> -	while (table[i].frequency != CPUFREQ_TABLE_END) {
> +	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>   		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>   			continue;
>   		if (table[i].frequency == freq)
> -			return i;
> -		i++;
> +			return level;
> +		level++;

Can you please send a separate patch on this driver instead?



>   	}
>   	return ret;
>   }
>

