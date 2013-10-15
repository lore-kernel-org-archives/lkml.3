Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab3JOPnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:43:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14401 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab3JOPnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:43:32 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-53-525d62a393cb
Date: Tue, 15 Oct 2013 17:43:24 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>
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
Subject: Re: [PATCH v9 3/7] thermal:boost: Automatic enable/disable of BOOST
 feature
Message-id: <20131015174324.0abda071@amdc308.digital.local>
In-reply-to: <1381829571.2080.34.camel@rzhang1-mobl4>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1381753070-2853-1-git-send-email-l.majewski@samsung.com>
 <1381753070-2853-4-git-send-email-l.majewski@samsung.com>
 <1381829571.2080.34.camel@rzhang1-mobl4>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xoO7ipNggg/UP2C02zljPavG06Qe7
	Rd/PK8wWa/b/ZLLoPPuE2eLNI26Ly7vmsFl87j3CaHG7cQWbxZnTl1gtnjzsY7PY+NXDgcdj
	8Z6XTB53ru1h81g37S2zx5ar7SwefVtWMXocv7GdyePzJrkA9igum5TUnMyy1CJ9uwSujM33
	O5gLXrtWnO+9ztzAeMCsi5GTQ0LARGLanbnMELaYxIV769m6GLk4hASmM0rMuXiSBcJpZ5LY
	0juFCaSKRUBVYte7P2A2m4CexOe7T8FsEQFliUXntjKCNDALPGaW+HfnC1hCWCBM4tSnRewg
	Nq+AtcTNR0/A4pwCphIdT1vYITa8YJTonTGdDSTBLyAp0f7vB9RNdhLnPm2AahaU+DH5HguI
	zSygJbF5WxMrhC0vsXnNW+YJjIKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBUfRMegfjqgaLQ4wCHIxKPLwnomKDhFgTy4orcw8xSnAwK4nwJsYChXhTEiurUovy
	44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTDKXFDaZ/sunPeYjV9M5Z5d
	FbZVAquKrdVPt4uLnfz0MffyA4ujs8WYduT/bWfzkktizecxSVRgfan3xliRPf335DUrrLau
	9NpTvbp0fWvbPD2ne2JxzwPWzmVqLBLfscSaafsMdYPJjx13yZn/P995m+GaQsjlkL2tN+wD
	GVhTXaolhS8WZCixFGckGmoxFxUnAgBLvoZangIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhang,

> Hi, Lukasz,
> 
> thanks for the patch, sorry that I didn't look into this one earlier.

Yes, I would _really_ appreciate _earlier_ feedback from thermal
maintainers :-)

> 
> On Mon, 2013-10-14 at 14:17 +0200, Lukasz Majewski wrote:
> > This patch provides auto disable/enable operation for boost. When
> > any defined trip point is passed, the boost is disabled.
> 
> Do you mean boost is disabled if the system is in a overheating state?

In short - Yes.


To be more precise - the thermal here is a "safe" valve. 

Its role is to provide hysteresis similar to the one available for
Intel processors.

Intel does it in HW. Here I'm trying to do the same with SW for ARM.

> 
> > In that moment thermal monitor workqueue is woken up and it monitors
> > if the device temperature drops below 75% of the smallest trip
> > point.
> 
> Just FYI, the smallest trip point does not equal the trip point with
> lowest temperature value.

Thermal processors to which I've looked (exynos 4/5, ste-snowball) had
trip points defined monotonically with smallest value defined first.

This was the rationale for choosing thermal trip point 0.


> 
> Say, here is a platform with an active trip point at 40C, and an
> critical trip point at 100C, you want to enable boost only if the
> temperature is under 30C, right?

In short: no (please read below explanation).


The boost rough idea:
1. I enable boost from cpufreq (no matter what is the state of thermal)
2. If temperature is too high, then thermal interrupt would trigger and
disable boost
3. If device cools down - I enable the boost again 


> 
> > When device cools down, the boost is enabled again.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> > 
> > ---
> > Changes for v9:
> > - None
> > 
> > Changes for v8:
> > - Move cpufreq_boost_* stub functions definition (needed when
> > cpufreq is not compiled in) to cpufreq.h at cpufreq core support
> > commit
> > 
> > Changes for v7:
> > - None
> > 
> > Changes for v6:
> > - Disable boost only when supported and enabled
> > - Protect boost related thermal_zone_device struct fields with mutex
> > - Evaluate temperature trend during boost enable decision
> > - Create separate methods to handle boost enable/disable
> >   (thermal_boost_{enable|disable}) operations
> > - Boost is disabled at any trip point passage (not only the non
> > critical one)
> > - Add stub definitions for cpufreq boost functions used when
> >   CONFIG_CPU_FREQ is NOT defined.
> > 
> > Changes for v5:
> > - Move boost disable code from cpu_cooling.c to thermal_core.c
> >   (to handle_non_critical_trips)
> > - Extent struct thermal_zone_device by adding overheated bool flag
> > - Implement auto enable of boost after device cools down
> > - Introduce boost_polling flag, which indicates if thermal uses
> > it's predefined pool delay or has woken up thermal workqueue only
> > to wait until device cools down.
> > 
> > Changes for v4:
> > - New patch
> > 
> >  drivers/thermal/thermal_core.c |   55
> > ++++++++++++++++++++++++++++++++++++++++
> > include/linux/thermal.h        |    2 ++ 2 files changed, 57
> > insertions(+)
> > 
> > diff --git a/drivers/thermal/thermal_core.c
> > b/drivers/thermal/thermal_core.c index 4962a6a..a167ab9 100644
> > --- a/drivers/thermal/thermal_core.c
> > +++ b/drivers/thermal/thermal_core.c
> > @@ -34,6 +34,7 @@
> >  #include <linux/thermal.h>
> >  #include <linux/reboot.h>
> >  #include <linux/string.h>
> > +#include <linux/cpufreq.h>
> 
> Actually, I do not like to see this as thermal_core.c.
> Because it is the platform thermal driver that owns the thermal
> policy, e.g. it tells the thermal core to take what action at what
> temperature. 
> And this cpufreq boost support should be part of the
> thermal policy.


Boost is defined as policy independent at cpufreq. So I believe that
it shall be also thermal policy independent. In the end thermal shall
help cpufreq to not burn the device.


> 
> For example, here is a platform that supports boost. And it has a
> passive trip point at 40C, which means the platform driver wants to
> reduce the processor frequency when the temperature at 40C.
> And what you're trying to add in this patch is to turn on boost mode
> when the temperature is under 30C, right?

In short: yes. 

I want to add code which would disable boost when detected temperature
is more than 40C.

First, boost must be enabled at cpufreq. Only then it can be disabled
(if temp > 40C) at thermal. 

During boost disablement I also setup the thermal zone for
polling (if we already poll it - no settings are changed).
 
The boost is re-enabled only when temperature drops to 30C AND the
tz->overheated is set (which means that we are at overheated state
caused by boost).


> If yes, then I'd prefer to
> 1. introduce a separate cpu cooling device that just has two cooling
> state, 0 means boost mode enabled, and 1 means boost mode disabled.
> 2. For any platform thermal driver that wants this support, introduce
> a new trip point (30C) to the platform thermal driver, 
> and bind the
> cpufreq boost cooling device to this trip point.

> 
> And IMO, Step 1 can be an enhancement of cpufreq cooling feature. You
> just need to introduce two new APIs for registering/unregistering an
> cpu boost cooling device, without changing the current cpufreq
> cooling code.
> 
> Further more, cpufreq_boost_trigger_state(1) just make it possible to
> enter boost mode, it does not mean the cpu will be put into boost mode
> immediately, right? 

Yes, correct.

> can we make it transparent to thermal core, say,
> always enable it when the cpu is in cooling state 0 (p0)?

Thanks for presenting possible solution.

I will investigate it for boost.

> 
> thanks,
> rui
> >  #include <net/netlink.h>
> >  #include <net/genetlink.h>
> >  
> > @@ -366,9 +367,59 @@ static void handle_critical_trips(struct
> > thermal_zone_device *tz, }
> >  }
> >  
> > +static int thermal_boost_enable(struct thermal_zone_device *tz)
> > +{
> > +	enum thermal_trend trend = get_tz_trend(tz, 0);
> > +	long trip_temp;
> > +
> > +	if (!tz->ops->get_trip_temp || !tz->overheated)
> > +		return -EPERM;
> > +	if (trend == THERMAL_TREND_RAISING || trend ==
> > THERMAL_TREND_RAISE_FULL)
> > +		return -EBUSY;
> > +
> > +	tz->ops->get_trip_temp(tz, 0, &trip_temp);
> > +	/*
> > +	 * Enable boost again only when current temperature is less
> > +	 * than 75% of trip_temp[0]
> > +	 */
> > +	if ((tz->temperature + (trip_temp >> 2)) < trip_temp) {
> > +		mutex_lock(&tz->lock);
> > +		tz->overheated = false;
> > +		if (tz->boost_polling) {
> > +			tz->boost_polling = false;
> > +			tz->polling_delay = 0;
> > +		}
> > +		mutex_unlock(&tz->lock);
> > +		cpufreq_boost_trigger_state(1);
> > +		return 0;
> > +	}
> > +	return -EBUSY;
> > +}
> > +
> > +static void thermal_boost_disable(struct thermal_zone_device *tz)
> > +{
> > +	cpufreq_boost_trigger_state(0);
> > +
> > +	/*
> > +	 * If no workqueue for monitoring is running - start one
> > with
> > +	 * 1000 ms monitoring period
> > +	 * If workqueue already running - do not change its period
> > and only
> > +	 * test if target CPU has cooled down
> > +	 */
> > +	mutex_lock(&tz->lock);
> > +	if (!tz->polling_delay) {
> > +		tz->boost_polling = true;
> > +		tz->polling_delay = 1000;
> > +	}
> > +	tz->overheated = true;
> > +	mutex_unlock(&tz->lock);
> > +}
> > +
> >  static void handle_thermal_trip(struct thermal_zone_device *tz,
> > int trip) {
> >  	enum thermal_trip_type type;
> > +	if (cpufreq_boost_supported() && cpufreq_boost_enabled())
> > +		thermal_boost_disable(tz);
> >  
> >  	tz->ops->get_trip_type(tz, trip, &type);
> >  
> > @@ -467,6 +518,10 @@ static void thermal_zone_device_check(struct
> > work_struct *work) struct thermal_zone_device *tz =
> > container_of(work, struct thermal_zone_device,
> >  						      poll_queue.work);
> > +	if (cpufreq_boost_supported())
> > +		if (!thermal_boost_enable(tz))
> > +			return;
> > +
> >  	thermal_zone_device_update(tz);
> >  }
> >  
> > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > index b268d3c..b316bdf 100644
> > --- a/include/linux/thermal.h
> > +++ b/include/linux/thermal.h
> > @@ -172,6 +172,8 @@ struct thermal_zone_device {
> >  	int emul_temperature;
> >  	int passive;
> >  	unsigned int forced_passive;
> > +	bool overheated;
> > +	bool boost_polling;
> >  	const struct thermal_zone_device_ops *ops;
> >  	const struct thermal_zone_params *tzp;
> >  	struct thermal_governor *governor;
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
