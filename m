Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab3JOJdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:33:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:23001 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab3JOJc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:32:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="419301495"
Message-ID: <1381829571.2080.34.camel@rzhang1-mobl4>
Subject: Re: [PATCH v9 3/7] thermal:boost: Automatic enable/disable of BOOST
 feature
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
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Date: Tue, 15 Oct 2013 17:32:51 +0800
In-Reply-To: <1381753070-2853-4-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	 <1381753070-2853-1-git-send-email-l.majewski@samsung.com>
	 <1381753070-2853-4-git-send-email-l.majewski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lukasz,

thanks for the patch, sorry that I didn't look into this one earlier.

On Mon, 2013-10-14 at 14:17 +0200, Lukasz Majewski wrote:
> This patch provides auto disable/enable operation for boost. When any
> defined trip point is passed, the boost is disabled.

Do you mean boost is disabled if the system is in a overheating state?

> In that moment thermal monitor workqueue is woken up and it monitors
> if the device temperature drops below 75% of the smallest trip point.

Just FYI, the smallest trip point does not equal the trip point with
lowest temperature value.

Say, here is a platform with an active trip point at 40C, and an
critical trip point at 100C, you want to enable boost only if the
temperature is under 30C, right?

> When device cools down, the boost is enabled again.
> 
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> 
> ---
> Changes for v9:
> - None
> 
> Changes for v8:
> - Move cpufreq_boost_* stub functions definition (needed when cpufreq
>   is not compiled in) to cpufreq.h at cpufreq core support commit
> 
> Changes for v7:
> - None
> 
> Changes for v6:
> - Disable boost only when supported and enabled
> - Protect boost related thermal_zone_device struct fields with mutex
> - Evaluate temperature trend during boost enable decision
> - Create separate methods to handle boost enable/disable
>   (thermal_boost_{enable|disable}) operations
> - Boost is disabled at any trip point passage (not only the non critical one)
> - Add stub definitions for cpufreq boost functions used when
>   CONFIG_CPU_FREQ is NOT defined.
> 
> Changes for v5:
> - Move boost disable code from cpu_cooling.c to thermal_core.c
>   (to handle_non_critical_trips)
> - Extent struct thermal_zone_device by adding overheated bool flag
> - Implement auto enable of boost after device cools down
> - Introduce boost_polling flag, which indicates if thermal uses it's predefined
>   pool delay or has woken up thermal workqueue only to wait until device
>   cools down.
> 
> Changes for v4:
> - New patch
> 
>  drivers/thermal/thermal_core.c |   55 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/thermal.h        |    2 ++
>  2 files changed, 57 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 4962a6a..a167ab9 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -34,6 +34,7 @@
>  #include <linux/thermal.h>
>  #include <linux/reboot.h>
>  #include <linux/string.h>
> +#include <linux/cpufreq.h>

Actually, I do not like to see this as thermal_core.c.
Because it is the platform thermal driver that owns the thermal policy,
e.g. it tells the thermal core to take what action at what temperature.
And this cpufreq boost support should be part of the thermal policy.

For example, here is a platform that supports boost. And it has a
passive trip point at 40C, which means the platform driver wants to
reduce the processor frequency when the temperature at 40C.
And what you're trying to add in this patch is to turn on boost mode
when the temperature is under 30C, right?
If yes, then I'd prefer to
1. introduce a separate cpu cooling device that just has two cooling
state, 0 means boost mode enabled, and 1 means boost mode disabled.
2. For any platform thermal driver that wants this support, introduce a
new trip point (30C) to the platform thermal driver, and bind the
cpufreq boost cooling device to this trip point.

And IMO, Step 1 can be an enhancement of cpufreq cooling feature. You
just need to introduce two new APIs for registering/unregistering an cpu
boost cooling device, without changing the current cpufreq cooling code.

Further more, cpufreq_boost_trigger_state(1) just make it possible to
enter boost mode, it does not mean the cpu will be put into boost mode
immediately, right? can we make it transparent to thermal core, say,
always enable it when the cpu is in cooling state 0 (p0)?

thanks,
rui
>  #include <net/netlink.h>
>  #include <net/genetlink.h>
>  
> @@ -366,9 +367,59 @@ static void handle_critical_trips(struct thermal_zone_device *tz,
>  	}
>  }
>  
> +static int thermal_boost_enable(struct thermal_zone_device *tz)
> +{
> +	enum thermal_trend trend = get_tz_trend(tz, 0);
> +	long trip_temp;
> +
> +	if (!tz->ops->get_trip_temp || !tz->overheated)
> +		return -EPERM;
> +	if (trend == THERMAL_TREND_RAISING || trend == THERMAL_TREND_RAISE_FULL)
> +		return -EBUSY;
> +
> +	tz->ops->get_trip_temp(tz, 0, &trip_temp);
> +	/*
> +	 * Enable boost again only when current temperature is less
> +	 * than 75% of trip_temp[0]
> +	 */
> +	if ((tz->temperature + (trip_temp >> 2)) < trip_temp) {
> +		mutex_lock(&tz->lock);
> +		tz->overheated = false;
> +		if (tz->boost_polling) {
> +			tz->boost_polling = false;
> +			tz->polling_delay = 0;
> +		}
> +		mutex_unlock(&tz->lock);
> +		cpufreq_boost_trigger_state(1);
> +		return 0;
> +	}
> +	return -EBUSY;
> +}
> +
> +static void thermal_boost_disable(struct thermal_zone_device *tz)
> +{
> +	cpufreq_boost_trigger_state(0);
> +
> +	/*
> +	 * If no workqueue for monitoring is running - start one with
> +	 * 1000 ms monitoring period
> +	 * If workqueue already running - do not change its period and only
> +	 * test if target CPU has cooled down
> +	 */
> +	mutex_lock(&tz->lock);
> +	if (!tz->polling_delay) {
> +		tz->boost_polling = true;
> +		tz->polling_delay = 1000;
> +	}
> +	tz->overheated = true;
> +	mutex_unlock(&tz->lock);
> +}
> +
>  static void handle_thermal_trip(struct thermal_zone_device *tz, int trip)
>  {
>  	enum thermal_trip_type type;
> +	if (cpufreq_boost_supported() && cpufreq_boost_enabled())
> +		thermal_boost_disable(tz);
>  
>  	tz->ops->get_trip_type(tz, trip, &type);
>  
> @@ -467,6 +518,10 @@ static void thermal_zone_device_check(struct work_struct *work)
>  	struct thermal_zone_device *tz = container_of(work, struct
>  						      thermal_zone_device,
>  						      poll_queue.work);
> +	if (cpufreq_boost_supported())
> +		if (!thermal_boost_enable(tz))
> +			return;
> +
>  	thermal_zone_device_update(tz);
>  }
>  
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index b268d3c..b316bdf 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -172,6 +172,8 @@ struct thermal_zone_device {
>  	int emul_temperature;
>  	int passive;
>  	unsigned int forced_passive;
> +	bool overheated;
> +	bool boost_polling;
>  	const struct thermal_zone_device_ops *ops;
>  	const struct thermal_zone_params *tzp;
>  	struct thermal_governor *governor;


