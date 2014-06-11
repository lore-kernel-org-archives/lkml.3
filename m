Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaFKOyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:54:00 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54149 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751152AbaFKOx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:53:59 -0400
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
	<20140611084908.509a6950@gandalf.local.home> <9hhk38nedu1.fsf@arm.com>
	<20140611102006.27cc145e@gandalf.local.home>
Date: Wed, 11 Jun 2014 15:53:42 +0100
In-Reply-To: <20140611102006.27cc145e@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 11 Jun 2014 15:20:06 +0100")
Message-ID: <9hhfvjbebux.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Wed, 11 Jun 2014 15:11:02 +0100
> Punit Agrawal <punit.agrawal@arm.com> wrote:
>  
>> I do indeed see the value of trip_type and it matches what's being
>> traced.
>> 
>> ~# trace-cmd report | grep thermal_zone_trip | tail -n 5
>>      kworker/2:2-1014  [002]   125.623213: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
>>      kworker/2:2-1014  [002]   125.743174: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
>>      kworker/2:2-1014  [002]   125.863196: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
>>      kworker/2:2-1014  [002]   125.983175: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
>>      kworker/2:2-1014  [002]   126.103173: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
>> ~# trace-cmd report -R | grep thermal_zone_trip | tail -n 5
>>      kworker/2:2-1014  [002]   125.623213: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
>>      kworker/2:2-1014  [002]   125.743174: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
>>      kworker/2:2-1014  [002]   125.863196: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
>>      kworker/2:2-1014  [002]   125.983175: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
>>      kworker/2:2-1014  [002]   126.103173: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
>> 
>> Is there something I should be doing to enable the translation to the
>> string representation when reporting using trace-cmd?
>
> Out of curiosity, what does the format file for it look like?

I didn't know this was being exported. Thanks for the pointer.

>
> /sys/kernel/debug/thermal/thermal_zone_trip/format

I don't have this file but found the following which seems to contain
the format.

# pwd /sys/kernel/debug/tracing/events/thermal/thermal_zone_trip
# cat format
name: thermal_zone_trip
ID: 463
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:__data_loc char[] thermal_zone;   offset:8;       size:4; signed:0;
        field:int id;   offset:12;      size:4; signed:1;
        field:int trip; offset:16;      size:4; signed:1;
        field:enum thermal_trip_type trip_type; offset:20;      size:4; signed:0;

print fmt: "thermal_zone=%s id=%d trip=%d trip_type=%s", __get_str(thermal_zone), REC->id, REC->trip, __print_symbolic(REC->trip_type, { THERMAL_TRIP_ACTIVE, "active" }, { THERMAL_TRIP_PASSIVE, "passive" }, { THERMAL_TRIP_HOT, "hot" }, { THERMAL_TRIP_CRITICAL, "critical" })

Cheers,
Punit

>
> -- Steve
