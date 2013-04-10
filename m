Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935724Ab3DJCG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 22:06:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:28950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762266Ab3DJCG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 22:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="316937046"
Message-ID: <1365559613.2183.7.camel@rzhang1-mobl4>
Subject: Re: [PATCH] thermal: exynos: fix handling of invalid frequency
 table entries
From: Zhang Rui <rui.zhang@intel.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Date: Wed, 10 Apr 2013 10:06:53 +0800
In-Reply-To: <1365544758-15245-1-git-send-email-abrestic@chromium.org>
References: <1365544758-15245-1-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

can you please verify
commit 	fc35b35cbe24ef021ea9acfba21e54da958df747
commit 57df8106932b57427df1eaaa13871857f75b1194
at
http://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/log/?h=thermal
fixes the problem for you?

thanks,
rui 
    
On Tue, 2013-04-09 at 14:59 -0700, Andrew Bresticker wrote:
> Similar to the error described in "thermal: cpu_cooling: fix handling
> of invalid frequency table entries," exynos_get_frequency_level() will
> enter an infinite loop if any CPU frequency table entries are invalid.
> This patch fixes the handling of invalid frequency entries so that
> there is no infinite loop and the correct level is returned.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  drivers/thermal/exynos_thermal.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> index d5e6267..524b2a0 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -237,7 +237,7 @@ static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
>  
>  static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>  {
> -	int i = 0, ret = -EINVAL;
> +	int i, level = 0, ret = -EINVAL;
>  	struct cpufreq_frequency_table *table = NULL;
>  #ifdef CONFIG_CPU_FREQ
>  	table = cpufreq_frequency_get_table(cpu);
> @@ -245,12 +245,12 @@ static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>  	if (!table)
>  		return ret;
>  
> -	while (table[i].frequency != CPUFREQ_TABLE_END) {
> +	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>  		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>  			continue;
>  		if (table[i].frequency == freq)
> -			return i;
> -		i++;
> +			return level;
> +		level++;
>  	}
>  	return ret;
>  }


