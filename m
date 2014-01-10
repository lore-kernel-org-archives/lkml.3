Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaAJGf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:35:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:48784 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaAJGf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:35:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,636,1384329600"; 
   d="scan'208";a="464552480"
Message-ID: <1389335712.2411.16.camel@rzhang1-mobl4>
Subject: Re: [PATCH v12 7/7] thermal:exynos:boost: Automatic enable/disable
 of BOOST feature (at Exynos4412)
From: Zhang Rui <rui.zhang@intel.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        linux-samsung-soc@vger.kernel.org
Date: Fri, 10 Jan 2014 14:35:12 +0800
In-Reply-To: <1387549495-809-8-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	 <1387549495-809-1-git-send-email-l.majewski@samsung.com>
	 <1387549495-809-8-git-send-email-l.majewski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 15:24 +0100, Lukasz Majewski wrote:
> This patch provides auto disable/enable operation for boost. It uses already
> present thermal infrastructure to provide BOOST hysteresis.
> The TMU data has been modified to work properly with or without BOOST.
> Hence, the two first trip points with corresponding clip frequencies were
> adjusted.
> 
> The first one was reduced from 85 to 70 degrees and clip frequency was
> increased to 1.4 GHz from 800 MHz. This trip point is in fact responsible
> for providing BOOST hysteresis. When temperature exceeds 70 deg, the maximal
> non BOOST frequency for Exynos4412 is imposed.
> 
> Since the first trigger level has been "stolen" for BOOST, the second one
> needs to be a compromise for the previously used two for non BOOST
> configuration. The 95 deg with modified clip freq (to 400 MHz) shall provide
> a good balance between cooling down the overheated device and throughput on
> an acceptable level.
> 
> Two last trigger levels were not modified since, they cause platform shutdown
> on emergency overheat situation.
> Third trip point passage results in SW managed shut down of the system.
> If the last trip point is crossed, the PMU HW generates the power off
> signal.
> 
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

Reviewed-by: Zhang Rui <rui.zhang@intel.com>

thanks,
rui
> 
> ---
> Changes for v12:
>     - More verbose patch description to explain new TMU temperature assignment
>       for Exynos4412
> 
> Changes for v11:
>     - Use only one thermal data set
>     - Adjust Exynos4412 thermal data to work with or without BOOST
> 
> Changes for v10:
>     - Remove boost related code from thermal_core.c
>     - Use already present thermal infrastructure to provide thermal hysteresis
>     - Introduce special set of TMU data for BOOST
> 
> Changes for v9:
>     - None
> 
> Changes for v8:
>     - Move cpufreq_boost_* stub functions definition (needed when cpufreq
>       is not compiled in) to cpufreq.h at cpufreq core support commit
> 
> Changes for v7:
>     - None
> 
> Changes for v6:
>     - Disable boost only when supported and enabled
>     - Protect boost related thermal_zone_device struct fields with mutex
>     - Evaluate temperature trend during boost enable decision
>     - Create separate methods to handle boost enable/disable
>       (thermal_boost_{enable|disable}) operations
>     - Boost is disabled at any trip point passage (not only the non critical one)
>     - Add stub definitions for cpufreq boost functions used when
>       CONFIG_CPU_FREQ is NOT defined.
> 
> Changes for v5:
>     - Move boost disable code from cpu_cooling.c to thermal_core.c
>       (to handle_non_critical_trips)
>     - Extent struct thermal_zone_device by adding overheated bool flag
>     - Implement auto enable of boost after device cools down
>     - Introduce boost_polling flag, which indicates if thermal uses it's predefined
>       pool delay or has woken up thermal workqueue only to wait until device
>       cools down.
> 
> Changes for v4:
>     - New patch
> 
>  drivers/thermal/samsung/exynos_tmu_data.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index 073c292..476b768 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -131,8 +131,8 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
>  
>  #define EXYNOS4412_TMU_DATA \
>  	.threshold_falling = 10, \
> -	.trigger_levels[0] = 85, \
> -	.trigger_levels[1] = 103, \
> +	.trigger_levels[0] = 70, \
> +	.trigger_levels[1] = 95, \
>  	.trigger_levels[2] = 110, \
>  	.trigger_levels[3] = 120, \
>  	.trigger_enable[0] = true, \
> @@ -155,12 +155,12 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
>  	.second_point_trim = 85, \
>  	.default_temp_offset = 50, \
>  	.freq_tab[0] = { \
> -		.freq_clip_max = 800 * 1000, \
> -		.temp_level = 85, \
> +		.freq_clip_max = 1400 * 1000, \
> +		.temp_level = 70, \
>  	}, \
>  	.freq_tab[1] = { \
> -		.freq_clip_max = 200 * 1000, \
> -		.temp_level = 103, \
> +		.freq_clip_max = 400 * 1000, \
> +		.temp_level = 95, \
>  	}, \
>  	.freq_tab_count = 2, \
>  	.registers = &exynos4412_tmu_registers, \


