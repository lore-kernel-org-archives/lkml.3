Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaIJQjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:39:35 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50221 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIJQjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:39:33 -0400
From: Dirk Brandewie <dirk.brandewie@gmail.com>
X-Google-Original-From: Dirk Brandewie <dirk.j.brandewie@intel.com>
Message-ID: <54107EC2.1010501@intel.com>
Date: Wed, 10 Sep 2014 09:39:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Anup Chenthamarakshan <anupc@chromium.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Sameer Nanda <snanda@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats
 via sysfs.
References: <1410221424-20590-1-git-send-email-anupc@chromium.org> <540F1981.1090805@gmail.com> <20140909232229.GA28142@google.com>
In-Reply-To: <20140909232229.GA28142@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 04:22 PM, Anup Chenthamarakshan wrote:
> On Tue, Sep 09, 2014 at 08:15:13AM -0700, Dirk Brandewie wrote:
>> On 09/08/2014 05:10 PM, Anup Chenthamarakshan wrote:
>>> Exported stats appear in
>>> <sysfs>/devices/system/cpu/intel_pstate/time_in_state as follows:
>>>
>>> ## CPU 0
>>> 400000 3647
>>> 500000 24342
>>> 600000 144150
>>> 700000 202469
>>> ## CPU 1
>>> 400000 4813
>>> 500000 22628
>>> 600000 149564
>>> 700000 211885
>>> 800000 173890
>>>
>>> Signed-off-by: Anup Chenthamarakshan <anupc@chromium.org>
>>
>> What is this information being used for?
>
> I'm using P-state residency information in power consumption tests to calculate
> proportion of time spent in each P-state across all processors (one global set
> of percentages, corresponding to each P-state). This is used to validate new
> changes from the power perspective. Essentially, sanity checks to flag changes
> with large difference in P-state residency.
>
> So far, we've been using the data exported by acpi-cpufreq to track this.
>
>>
>> Tracking the current P state request for each core is only part of the
>> story.  The processor aggregates the requests from all cores and then decides
>> what frequency the package will run at, this evaluation happens at ~1ms time
>> frame.  If a core is idle then it loses its vote for that package frequency will
>> be and its frequency will be zero even though it may have been requesting
>> a high P state when it went idle.  Tracking the residency of the requested
>> P state doesn't provide much useful information other than ensuring the the
>> requests are changing over time IMHO.
>
> This is exactly why we're trying to track it.

My point is that you are tracking the residency of the request and not
the P state the package was running at.  On a lightly loaded system
it is not unusual for a core that was very busy and requesting a high
P state to go idle for several seconds.  In this case that core would
lose its vote for the package P state but the stats would show that
the P state was high for a very long time when its real frequency
was zero.

There are a couple of ways to get what I consider better information
about what is actually going on.

   The current turbostat provides C state residency and calculates the
   average/effective frequency of the core over its sample time.
   Turbostat will also measure the power consumption from the CPU point
   of view if your processor supports the RAPL registers.

   Reading MSR 0x198 MSR_IA32_PERF_STATUS will tell you what the core
   would run at if it not idle, this reflects the decision that the
   package made based on current requests.

   Using perf to collect power:pstate_sample event will give information
   about each sample on the core and give you timestamps to detect idle
   times.

   Using perf to collect power:cpu_frequency will show when the P state
   request was changed on each core and is triggered by intel_pstate and
   acpi_cpufreq.

   Powertop collects that same information as turbostat and a bunch of
   other information useful in seeing where you could be burning power
   for no good reason.

For getting an idea of real power turbostat is the easiest to use and
is available on most systems.  Using perf will give you a very fine grained
view of what is going on as well as point to the culprit for bad
behaviour in most cases.

>
>>
>> This interface will not be supportable with upcoming processors using
>> hardware P states as documented in volume 3 of the current SDM Section 14.4
>> http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf
>> The OS will have no way of knowing what the P state requests are for a
>> given core are.
>
> Will there be any means to determine the proportion of time spent in different
> HWP-states when HWP gets enabled (maybe at a package level)?
>
Not that I am aware of :-(  There is MSR_PPERF section 14.4.5.1 that will give
the CPUs view of the amount of productive work/scalability of the current load.

--Dirk
