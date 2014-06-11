Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaFKOL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:11:28 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51808 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932186AbaFKOLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:11:25 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javi Merino <Javi.Merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH 3/3] thermal: trace: Trace when temperature is above a trip point
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
	<1402486305-4017-4-git-send-email-punit.agrawal@arm.com>
	<20140611084908.509a6950@gandalf.local.home>
Date: Wed, 11 Jun 2014 15:11:02 +0100
In-Reply-To: <20140611084908.509a6950@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 11 Jun 2014 13:49:08 +0100")
Message-ID: <9hhk38nedu1.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the quick response.

Steven Rostedt <rostedt@goodmis.org> writes:

> On Wed, 11 Jun 2014 12:31:44 +0100
> Punit Agrawal <punit.agrawal@arm.com> wrote:
>
>> Create a new event to trace when the temperature is above a trip
>> point. Use the trace-point when handling non-critical and critical
>> trip pionts.
>> 
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: Eduardo Valentin <edubezval@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> ---
>> Hi Steven,
>> 
>> I am facing an issue with partial trace being emitted when using
>> __print_symbolic in this patch. 
>> 
>> When the trip_type is THERMAL_TRIP_ACTIVE (i.e., the first value in
>> the symbol map), the emitted trace contains the corresponding string
>> ("active"). But for other values of trip_type an empty string is
>> emitted in the trace.
>> 
>> I've looked at other uses of __print_symbolic in the kernel and don't
>> see any difference in usage. Do you know what could be causing this or
>> alternately have any pointers on how to debug this behaviour?
>> 
>
> If you can use trace-cmd to record your events then we can look at the
> raw data too.
>
> trace-cmd record -e thermal_zone_trip <some-command>
>
> where <some-command> would trigger your tracepoint.
>
> Then do: trace-cmd report -R
>
> You should see the raw value of trip_type.
>
> Make sure that it matches the enum values that you have listed.
>

I do indeed see the value of trip_type and it matches what's being
traced.

~# trace-cmd report | grep thermal_zone_trip | tail -n 5
     kworker/2:2-1014  [002]   125.623213: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
     kworker/2:2-1014  [002]   125.743174: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
     kworker/2:2-1014  [002]   125.863196: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
     kworker/2:2-1014  [002]   125.983175: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
     kworker/2:2-1014  [002]   126.103173: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
~# trace-cmd report -R | grep thermal_zone_trip | tail -n 5
     kworker/2:2-1014  [002]   125.623213: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
     kworker/2:2-1014  [002]   125.743174: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
     kworker/2:2-1014  [002]   125.863196: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
     kworker/2:2-1014  [002]   125.983175: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
     kworker/2:2-1014  [002]   126.103173: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1

Is there something I should be doing to enable the translation to the
string representation when reporting using trace-cmd?

Cheers,
Punit

> -- Steve
>
>
>> Thanks.
>> Punit
>> 
>>  drivers/thermal/fair_share.c   |    7 ++++++-
>>  drivers/thermal/step_wise.c    |    5 ++++-
>>  drivers/thermal/thermal_core.c |    2 ++
>>  include/trace/events/thermal.h |   30 ++++++++++++++++++++++++++++++
>>  4 files changed, 42 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
>> index 944ba2f..2cddd68 100644
>> --- a/drivers/thermal/fair_share.c
>> +++ b/drivers/thermal/fair_share.c
>> @@ -23,6 +23,7 @@
>>   */
>>  
>>  #include <linux/thermal.h>
>> +#include <trace/events/thermal.h>
>>  
>>  #include "thermal_core.h"
>>  
>> @@ -34,14 +35,18 @@ static int get_trip_level(struct thermal_zone_device *tz)
>>  {
>>  	int count = 0;
>>  	unsigned long trip_temp;
>> +	enum thermal_trip_type trip_type;
>>  
>>  	if (tz->trips == 0 || !tz->ops->get_trip_temp)
>>  		return 0;
>>  
>>  	for (count = 0; count < tz->trips; count++) {
>>  		tz->ops->get_trip_temp(tz, count, &trip_temp);
>> -		if (tz->temperature < trip_temp)
>> +		if (tz->temperature < trip_temp) {
>> +			tz->ops->get_trip_type(tz, count, &trip_type);
>> +			trace_thermal_zone_trip(tz, count, trip_type);
>>  			break;
>> +		}
>>  	}
>>  	return count;
>>  }
>> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
>> index f251521..3b54c2c 100644
>> --- a/drivers/thermal/step_wise.c
>> +++ b/drivers/thermal/step_wise.c
>> @@ -23,6 +23,7 @@
>>   */
>>  
>>  #include <linux/thermal.h>
>> +#include <trace/events/thermal.h>
>>  
>>  #include "thermal_core.h"
>>  
>> @@ -129,8 +130,10 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
>>  
>>  	trend = get_tz_trend(tz, trip);
>>  
>> -	if (tz->temperature >= trip_temp)
>> +	if (tz->temperature >= trip_temp) {
>>  		throttle = true;
>> +		trace_thermal_zone_trip(tz, trip, trip_type);
>> +	}
>>  
>>  	dev_dbg(&tz->device, "Trip%d[type=%d,temp=%ld]:trend=%d,throttle=%d\n",
>>  				trip, trip_type, trip_temp, trend, throttle);
>> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
>> index c74c78d..454884a 100644
>> --- a/drivers/thermal/thermal_core.c
>> +++ b/drivers/thermal/thermal_core.c
>> @@ -371,6 +371,8 @@ static void handle_critical_trips(struct thermal_zone_device *tz,
>>  	if (tz->temperature < trip_temp)
>>  		return;
>>  
>> +	trace_thermal_zone_trip(tz, trip, trip_type);
>> +
>>  	if (tz->ops->notify)
>>  		tz->ops->notify(tz, trip, trip_type);
>>  
>> diff --git a/include/trace/events/thermal.h b/include/trace/events/thermal.h
>> index 894a79e..5eeb1e7 100644
>> --- a/include/trace/events/thermal.h
>> +++ b/include/trace/events/thermal.h
>> @@ -51,6 +51,36 @@ TRACE_EVENT(cdev_update,
>>  	TP_printk("type=%s target=%lu", __get_str(type), __entry->target)
>>  );
>>  
>> +TRACE_EVENT(,
>> +
>> +	TP_PROTO(struct thermal_zone_device *tz, int trip,
>> +		enum thermal_trip_type trip_type),
>> +
>> +	TP_ARGS(tz, trip, trip_type),
>> +
>> +	TP_STRUCT__entry(
>> +		__string(thermal_zone, tz->type)
>> +		__field(int, id)
>> +		__field(int, trip)
>> +		__field(enum thermal_trip_type, trip_type)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__assign_str(thermal_zone, tz->type);
>> +		__entry->id = tz->id;
>> +		__entry->trip = trip;
>> +		__entry->trip_type = trip_type;
>> +	),
>> +
>> +	TP_printk("thermal_zone=%s id=%d trip=%d trip_type=%s",
>> +		__get_str(thermal_zone), __entry->id, __entry->trip,
>> +		__print_symbolic(__entry->trip_type,
>> +				{ THERMAL_TRIP_ACTIVE, "active" },
>> +				{ THERMAL_TRIP_PASSIVE, "passive" },
>> +				{ THERMAL_TRIP_HOT, "hot" },
>> +				{ THERMAL_TRIP_CRITICAL, "critical" }))
>> +);
>> +
>>  #endif /* _TRACE_THERMAL_H */
>>  
>>  /* This part must be outside protection */
