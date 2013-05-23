Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab3EWCKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:10:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:49460 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab3EWCKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,725,1363158000"; 
   d="scan'208";a="341738539"
Message-ID: <1369275016.2036.3.camel@rzhang1-mobl4>
Subject: Re: [PATCH 3/3] Thermal:core: Handle trips focused on current trip
 point only.
From: Zhang Rui <rui.zhang@intel.com>
To: jonghwa3.lee@samsung.com
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Date: Thu, 23 May 2013 10:10:16 +0800
In-Reply-To: <519AECBD.9060202@samsung.com>
References: <1368870663-1225-1-git-send-email-jonghwa3.lee@samsung.com>
	 <744357E9AAD1214791ACBA4B0B90926301102442@SHSMSX101.ccr.corp.intel.com>
	 <519AECBD.9060202@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 12:40 +0900, jonghwa3.lee@samsung.com wrote:
> On 2013년 05월 21일 01:00, Zhang, Rui wrote:
> 
> > 
> > 
> >> -----Original Message-----
> >> From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
> >> Sent: Saturday, May 18, 2013 5:51 PM
> >> To: linux-pm@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org; Zhang, Rui; Eduardo Valentin; Amit
> >> Dinel Kachhap; Jonghwa Lee; MyungJoo Ham
> >> Subject: [PATCH 3/3] Thermal:core: Handle trips focused on current trip
> >> point only.
> >> Importance: High
> >>
> >> When thermal zone device is updated, it doesn't need to check every
> >> trip points and its handling mathod even current temperature doesn't
> >> exceed the trip's temperature. To modify those dissipatve mechanism,
> >> this patch introduces the way to get current thermal trip point to call
> >> only correspond trip point handling.
> >>
> >> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> >> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > 
> > NAK.
> > 
> >> ---
> >>  drivers/thermal/thermal_core.c |   28 +++++++++++++++++-----------
> >>  1 file changed, 17 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/drivers/thermal/thermal_core.c
> >> b/drivers/thermal/thermal_core.c index ce4384a..1cc4825 100644
> >> --- a/drivers/thermal/thermal_core.c
> >> +++ b/drivers/thermal/thermal_core.c
> >> @@ -333,14 +333,6 @@ static void handle_non_critical_trips(struct
> >> thermal_zone_device *tz,  static void handle_critical_trips(struct
> >> thermal_zone_device *tz,
> >>  				int trip, enum thermal_trip_type trip_type)  {
> >> -	long trip_temp;
> >> -
> >> -	tz->ops->get_trip_temp(tz, trip, &trip_temp);
> >> -
> >> -	/* If we have not crossed the trip_temp, we do not care. */
> >> -	if (tz->temperature < trip_temp)
> >> -		return;
> >> -
> >>  	if (tz->ops->notify)
> >>  		tz->ops->notify(tz, trip, trip_type);
> >>
> >> @@ -437,14 +429,28 @@ static void update_temperature(struct
> >> thermal_zone_device *tz)
> >>  	mutex_unlock(&tz->lock);
> >>  }
> >>
> >> +static int thermal_zone_get_current_trip(struct thermal_zone_device
> >> +*tz) {
> >> +	int trip;
> >> +	long trip_temp;
> >> +
> >> +	for (trip = tz->trips - 1; trip > 0; trip--) {
> >> +		tz->ops->get_trip_temp(tz, trip, &trip_temp);
> >> +		if (tz->temperature > trip_temp)
> >> +			continue;
> >> +	}
> >> +	return trip;
> >> +}
> >> +
> >>  void thermal_zone_device_update(struct thermal_zone_device *tz)  {
> >> -	int count;
> >> +	int trip;
> >>
> >>  	update_temperature(tz);
> >>
> >> -	for (count = 0; count < tz->trips; count++)
> >> -		handle_thermal_trip(tz, count);
> >> +	trip = thermal_zone_get_current_trip(tz);
> >> +
> >> +	handle_thermal_trip(tz, trip);
> > 
> > Say, trip point 1 for thermal zone 0 is 60C,
> > The system is running above 60C for somethime,
> > thus the thermal_instance for this trip point is running at upper_limit.
> > When the temperature suddenly drops below 60C,
> > we still need to handle trip point 1 to deactivate it.
> > 
> 
> 
> Okay, I understood. I missed the point that governor will handle a cooling
> device within certain trip point described in thermal instance.
> But still I don't think this is the best behaviour. Let say we were in trip
> level 2nd and moving to trip level 1st then we should call governor twice for
> applying trip 1 level.

Right.
IMO, the governor is used to get the next proper cooling state for each
referred thermal instance.
So I think it is okay to call it twice.

>  Why don't we just call once? And whenever we call
> handle_thermal_trip() with all trips, monitor_thermal_work() will also be called
> at the same time.

hmm, what is your question about this?

>  I think we can make this work more clearly and intuitively.
> let me think of it more,,,
> 
sure.

thanks,
rui

> Thanks,
> Jonghwa.
> 
> > Thanks,
> > rui
> >>  }
> >>  EXPORT_SYMBOL_GPL(thermal_zone_device_update);
> >>
> >> --
> >> 1.7.9.5
> > 
> > 
> 
> 


