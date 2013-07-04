Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3GDRTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 13:19:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:29417 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab3GDRTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 13:19:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,996,1363158000"; 
   d="scan'208";a="364882328"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Lukasz Majewski <l.majewski@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "Zhang, Rui" <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "l.majewski@majess.pl" <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: RE: [PATCH v5 5/7] thermal:boost: Automatic enable/disable of BOOST
 feature
Thread-Topic: [PATCH v5 5/7] thermal:boost: Automatic enable/disable of
 BOOST feature
Thread-Index: AQHOeJQOJN+eWhBOA0aAeNlrBXx/0JlUwftQ
Date: Thu, 4 Jul 2013 17:19:04 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59CCF152@BGSMSX101.gar.corp.intel.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-6-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1372927830-2949-6-git-send-email-l.majewski@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukasz,

> -----Original Message-----
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Lukasz Majewski
> Sent: Thursday, July 04, 2013 2:20 PM
> To: Viresh Kumar; Rafael J. Wysocki; Zhang, Rui; Eduardo Valentin
> Cc: cpufreq@vger.kernel.org; Linux PM list; Jonghwa Lee; Lukasz Majewski;
> l.majewski@majess.pl; linux-kernel; Andre Przywara; Daniel Lezcano; Kukjin Kim;
> Myungjoo Ham
> Subject: [PATCH v5 5/7] thermal:boost: Automatic enable/disable of BOOST
> feature
> 
> This patch provides auto disable/enable operation for boost. When any
> defined trip point is passed, the boost is disabled.
> In that moment thermal monitor workqueue is woken up and it monitors
> if the device temperature drops below 75% of the smallest trip point.
> When device cools down, the boost is enabled again.
> 
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> 
> ---
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
>  drivers/thermal/thermal_core.c |   31 +++++++++++++++++++++++++++++++
>  include/linux/thermal.h        |    2 ++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index d755440..12adbad 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -33,6 +33,7 @@
>  #include <linux/idr.h>
>  #include <linux/thermal.h>
>  #include <linux/reboot.h>
> +#include <linux/cpufreq.h>
>  #include <net/netlink.h>
>  #include <net/genetlink.h>
> 
> @@ -326,6 +327,15 @@ static void monitor_thermal_zone(struct
> thermal_zone_device *tz)
>  static void handle_non_critical_trips(struct thermal_zone_device *tz,
>  			int trip, enum thermal_trip_type trip_type)
>  {
> +	if (cpufreq_boost_supported()) {
> +		tz->overheated = true;
> +		cpufreq_boost_trigger_state(0);
> +		if (!tz->polling_delay) {
> +			tz->boost_polling = true;
> +			tz->polling_delay = 1000;
> +		}
> +	}
> +
>  	if (tz->governor)
>  		tz->governor->throttle(tz, trip);
>  }
> @@ -453,6 +463,27 @@ static void thermal_zone_device_check(struct
> work_struct *work)
>  	struct thermal_zone_device *tz = container_of(work, struct
>  						      thermal_zone_device,
>  						      poll_queue.work);
> +	long trip_temp;
> +
> +	if (cpufreq_boost_supported() && tz->overheated) {

Not all thermal drivers support trip points. So, we first need a
if (tz->ops->get_trip_temp) check here.

> +		tz->ops->get_trip_temp(tz, 0, &trip_temp);
> +		/*
> +		 * Enable boost again only when current temperature is less
> +		 * than 75% of trip_temp[0]
> +		 */
> +		if ((tz->temperature + (trip_temp >> 2)) < trip_temp) {

Another way would be to use the get_trend APIs for this thermal zone.
If the trend is cooling we can re-enable boost otherwise not.

> +			tz->overheated = false;
> +			if (tz->boost_polling) {
> +				tz->boost_polling = false;
> +				tz->polling_delay = 0;
> +				monitor_thermal_zone(tz);
> +			}

Overall, I believe this will work well only if the thermal zone is CPU.

Another suggestion is: We tried hard to remove all throttling logic from
thermal_core.c. May be we should include this kind of logic in
step_wise.c ?  Rui/Eduardo: Any thoughts on this ?

Thanks,
Durga
> +
> +			cpufreq_boost_trigger_state(1);
> +			return;
> +		}
> +	}
> +
>  	thermal_zone_device_update(tz);
>  }
> 
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index a386a1c..f1aa3c2 100644
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
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
