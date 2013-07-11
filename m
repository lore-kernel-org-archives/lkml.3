Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab3GKIIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:08:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58488 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab3GKIIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:08:48 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-18-51de680943bb
Date: Thu, 11 Jul 2013 10:08:32 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 5/7] thermal:boost: Automatic enable/disable of BOOST
 feature
Message-id: <20130711100832.48fe3b33@amdc308.digital.local>
In-reply-to: <1372927830-2949-6-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-6-git-send-email-l.majewski@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgC5nxr1Ag7dHuS2eNv1gt+j7eYXZ
	Ys3+n0wWnWefMFu8ecRt8ebhZkaLy7vmsFl87j3CaHG7cQWbRf/CXiaLJw/72Cw2fvVw4PFY
	vOclk8eda3vYPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6APYrLJiU1J7MstUjfLoEr4+25
	lSwF92QqLr5dx9LA2CDexcjJISFgIvF68npmCFtM4sK99WxdjFwcQgKLGCWaZ81jhHDamSRW
	HznKDlLFIqAqcXbyEyYQm01AT+Lz3adANgeHiIC/RH+LMkg9s8A8ZonFO26xgdQIC4RJrNrR
	DVbPK2Atcar9JwuIzSngJnG66y3YTCGBvYwSyx+agdj8ApIS7f9+QF1kJ3Hu0wZ2iF5BiR+T
	74H1MgtoSWze1sQKYctLbF7zlnkCo+AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZwBD2T2sG4ssHiEKMAB6MSD29D/N1AIdbEsuLK3EOMEhzMSiK8Tj73AoV4UxIr
	q1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUw2rx7uJKT8bhKhKd8
	m5z//i3dLHZHzU98VW+d3ldz9mdyeq7ppAnTjSZ/eiLCvH3VN//Ny9mUL7GdtLRftcs0fZFz
	1JlLje8fvufd1uNoVXD+547X7xlWHzR/3q25QWPXZNum24Zn8ve8PN65i2/+KcuoJS2zWtbN
	fL1/37lDh8XvHPE76RF+l1+JpTgj0VCLuag4EQDcLB+QnAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Zhang, Eduardo

Do you have any comments/feedback for me regarding this thermal
framework related patch?

I've already received some feedback from Durga for this patch, but I
think that maintainers are most welcome to express their opinion :-)

Thanks in advance.

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
> - Introduce boost_polling flag, which indicates if thermal uses it's
> predefined pool delay or has woken up thermal workqueue only to wait
> until device cools down.
> 
> Changes for v4:
> - New patch
> 
>  drivers/thermal/thermal_core.c |   31 +++++++++++++++++++++++++++++++
>  include/linux/thermal.h        |    2 ++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_core.c
> b/drivers/thermal/thermal_core.c index d755440..12adbad 100644
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
> thermal_zone_device *tz) static void handle_non_critical_trips(struct
> thermal_zone_device *tz, int trip, enum thermal_trip_type trip_type)
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
> work_struct *work) struct thermal_zone_device *tz =
> container_of(work, struct thermal_zone_device,
>  						      poll_queue.work);
> +	long trip_temp;
> +
> +	if (cpufreq_boost_supported() && tz->overheated) {
> +		tz->ops->get_trip_temp(tz, 0, &trip_temp);
> +		/*
> +		 * Enable boost again only when current temperature
> is less
> +		 * than 75% of trip_temp[0]
> +		 */
> +		if ((tz->temperature + (trip_temp >> 2)) <
> trip_temp) {
> +			tz->overheated = false;
> +			if (tz->boost_polling) {
> +				tz->boost_polling = false;
> +				tz->polling_delay = 0;
> +				monitor_thermal_zone(tz);
> +			}
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


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
