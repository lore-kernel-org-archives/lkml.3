Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbaFYN0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:26:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43001 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaFYN0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:26:32 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Wed, 25 Jun 2014 14:26:28 +0100
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [RFC PATCH 3/3] thermal: trace: Trace when temperature is above
 a trip point
Message-ID: <20140625132628.GB2723@e104805>
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
 <1402486305-4017-4-git-send-email-punit.agrawal@arm.com>
 <20140620172442.GA22701@e104805>
 <9hhionqvbbx.fsf@arm.com>
MIME-Version: 1.0
In-Reply-To: <9hhionqvbbx.fsf@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 25 Jun 2014 13:26:19.0478 (UTC) FILETIME=[0CA77F60:01CF9079]
X-MC-Unique: 114062514263000101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:41:38AM +0100, Punit Agrawal wrote:
> "Javi Merino" <javi.merino@arm.com> writes:
> 
> > Hi Punit,
> >
> > On Wed, Jun 11, 2014 at 12:31:44PM +0100, Punit Agrawal wrote:
> >> Create a new event to trace when the temperature is above a trip
> >> point. Use the trace-point when handling non-critical and critical
> >> trip pionts.
> >> 
> >> Cc: Zhang Rui <rui.zhang@intel.com>
> >> Cc: Eduardo Valentin <edubezval@gmail.com>
> >> Cc: Steven Rostedt <rostedt@goodmis.org>
> >> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> >> ---
> >> Hi Steven,
> >> 
> >> I am facing an issue with partial trace being emitted when using
> >> __print_symbolic in this patch. 
> >> 
> >> When the trip_type is THERMAL_TRIP_ACTIVE (i.e., the first value in
> >> the symbol map), the emitted trace contains the corresponding string
> >> ("active"). But for other values of trip_type an empty string is
> >> emitted in the trace.
> >> 
> >> I've looked at other uses of __print_symbolic in the kernel and don't
> >> see any difference in usage. Do you know what could be causing this or
> >> alternately have any pointers on how to debug this behaviour?
> >> 
> >> Thanks.
> >> Punit
> >> 
> >>  drivers/thermal/fair_share.c   |    7 ++++++-
> >>  drivers/thermal/step_wise.c    |    5 ++++-
> >>  drivers/thermal/thermal_core.c |    2 ++
> >>  include/trace/events/thermal.h |   30 ++++++++++++++++++++++++++++++
> >>  4 files changed, 42 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
> >> index 944ba2f..2cddd68 100644
> >> --- a/drivers/thermal/fair_share.c
> >> +++ b/drivers/thermal/fair_share.c
> >> @@ -23,6 +23,7 @@
> >>   */
> >>  
> >>  #include <linux/thermal.h>
> >> +#include <trace/events/thermal.h>
> >>  
> >>  #include "thermal_core.h"
> >>  
> >> @@ -34,14 +35,18 @@ static int get_trip_level(struct thermal_zone_device *tz)
> >>  {
> >>  	int count = 0;
> >>  	unsigned long trip_temp;
> >> +	enum thermal_trip_type trip_type;
> >>  
> >>  	if (tz->trips == 0 || !tz->ops->get_trip_temp)
> >>  		return 0;
> >>  
> >>  	for (count = 0; count < tz->trips; count++) {
> >>  		tz->ops->get_trip_temp(tz, count, &trip_temp);
> >> -		if (tz->temperature < trip_temp)
> >> +		if (tz->temperature < trip_temp) {
> >> +			tz->ops->get_trip_type(tz, count, &trip_type);
> >> +			trace_thermal_zone_trip(tz, count, trip_type);
> >
> > This should be outside the if condition.  You want to report when trip
> > points have been hit, like in the step_wise code below.
> >
> 
> It turned out to be a bit more subtle than moving the trace outside the
> if.

True, it was more difficult than what I said.  

>     I have the below fixup with an added comment. Let me know if that
> doesn't solve the problem.

I don't have a reproducer, I just spotted it while reading the code.
The below fix seems to be the right thing.

> -- >8 --
> Subject: [PATCH] fixup! thermal: trace: Trace when temperature is above a
>  trip point
> 
> ---
>  drivers/thermal/fair_share.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
> index 2cddd68..6e0a3fb 100644
> --- a/drivers/thermal/fair_share.c
> +++ b/drivers/thermal/fair_share.c
> @@ -42,12 +42,19 @@ static int get_trip_level(struct thermal_zone_device *tz)
>  
>  	for (count = 0; count < tz->trips; count++) {
>  		tz->ops->get_trip_temp(tz, count, &trip_temp);
> -		if (tz->temperature < trip_temp) {
> -			tz->ops->get_trip_type(tz, count, &trip_type);
> -			trace_thermal_zone_trip(tz, count, trip_type);
> +		if (tz->temperature < trip_temp)
>  			break;
> -		}
>  	}
> +
> +	/*
> +	 * count > 0 only if temperature is greater than first trip
> +	 * point, in which case, trip_point = count - 1
> +	 */
> +	if (count > 0) {
> +		tz->ops->get_trip_type(tz, count - 1, &trip_type);
> +		trace_thermal_zone_trip(tz, count - 1, trip_type);
> +	}
> +
>  	return count;
>  }
>  
> -- 
> 1.7.10.4

