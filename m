Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaFXKlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:41:50 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53815 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751407AbaFXKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:41:48 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: "Javi Merino" <javi.merino@arm.com>
Cc: "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [RFC PATCH 3/3] thermal: trace: Trace when temperature is above a trip point
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
	<1402486305-4017-4-git-send-email-punit.agrawal@arm.com>
	<20140620172442.GA22701@e104805>
Date: Tue, 24 Jun 2014 11:41:38 +0100
In-Reply-To: <20140620172442.GA22701@e104805> (Javi Merino's message of "Fri,
	20 Jun 2014 18:24:42 +0100")
Message-ID: <9hhionqvbbx.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Javi Merino" <javi.merino@arm.com> writes:

> Hi Punit,
>
> On Wed, Jun 11, 2014 at 12:31:44PM +0100, Punit Agrawal wrote:
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
>
> This should be outside the if condition.  You want to report when trip
> points have been hit, like in the step_wise code below.
>

It turned out to be a bit more subtle than moving the trace outside the
if. I have the below fixup with an added comment. Let me know if that
doesn't solve the problem.

-- >8 --
Subject: [PATCH] fixup! thermal: trace: Trace when temperature is above a
 trip point

---
 drivers/thermal/fair_share.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
index 2cddd68..6e0a3fb 100644
--- a/drivers/thermal/fair_share.c
+++ b/drivers/thermal/fair_share.c
@@ -42,12 +42,19 @@ static int get_trip_level(struct thermal_zone_device *tz)
 
 	for (count = 0; count < tz->trips; count++) {
 		tz->ops->get_trip_temp(tz, count, &trip_temp);
-		if (tz->temperature < trip_temp) {
-			tz->ops->get_trip_type(tz, count, &trip_type);
-			trace_thermal_zone_trip(tz, count, trip_type);
+		if (tz->temperature < trip_temp)
 			break;
-		}
 	}
+
+	/*
+	 * count > 0 only if temperature is greater than first trip
+	 * point, in which case, trip_point = count - 1
+	 */
+	if (count > 0) {
+		tz->ops->get_trip_type(tz, count - 1, &trip_type);
+		trace_thermal_zone_trip(tz, count - 1, trip_type);
+	}
+
 	return count;
 }
 
-- 
1.7.10.4

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
>
> Cheers,
> Javi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
