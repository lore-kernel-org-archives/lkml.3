Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaBAAVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 19:21:48 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36848 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaBAAVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 19:21:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAME+o4=iz+gRoQ_PxDuzXgpQVbWNOYc_n9BLEPj8PAU0bHLi6g@mail.gmail.com>
References: <1379715336-22620-1-git-send-email-zoran.markovic@linaro.org>
	<CAME+o4myuSVwc=8mpk9x6tKZoskG6i2djrHSBGmVhKqaHqYwMA@mail.gmail.com>
	<CAME+o4m+1O4pMYa8jNoSuVtmtbkRC2H-9YZj+hnDwsd=Ex0wmw@mail.gmail.com>
	<52989FCA.2010107@ti.com>
	<CAME+o4mbtbDV+tZ6itEBqGp5Xy=6a0CsAZ+Kuvu3+oa-TR=_dw@mail.gmail.com>
	<52A5D3F1.9040301@ti.com>
	<CAME+o4=GESy7jseDXKx6f_DykRYP72kCdM5D3RMkKkybMDzmmg@mail.gmail.com>
	<CAHLCerMCjtXNDRceG2u6kuyTrjV=j6S3mUViVMQJyDAwp_6pgA@mail.gmail.com>
	<52AEF5AD.5000506@ti.com>
	<CAME+o4=iz+gRoQ_PxDuzXgpQVbWNOYc_n9BLEPj8PAU0bHLi6g@mail.gmail.com>
Date: Fri, 31 Jan 2014 16:21:45 -0800
Message-ID: <CAME+o4=zphotWQ2L2FXOXadyZT9aZXL8d6tQMeV8=gjm3wiybw@mail.gmail.com>
Subject: Re: [RFC PATCH] thermal: add generic cpu hotplug cooling device
From: Zoran Markovic <zoran.markovic@linaro.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Christian Daudt <bcm@fixthebug.org>,
        James King <james.king@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,
The merge window for 3.14 is now open and I'm wondering if you had a
chance to look at these numbers?
Thanks,
Zoran

On 30 December 2013 12:48, Zoran Markovic <zoran.markovic@linaro.org> wrote:
> Eduardo,
>
>>> What is the workload you're running besides the proprietary heater code?
> I re-did experiments from Linaro's site pointed by Amit while
> profiling _cpu_down() and _cpu_up() times:
>>> [1] https://wiki.linaro.org/WorkingGroups/PowerManagement/Archives/Hotplug
>
> I am attaching a spreadsheet with some results and graphs:
>
> Sheet 1 (thermal_ramp) has three plots. Topmost is an unbound thermal
> ramp that levels off at ~48C. Middle plot is a thermal ramp with cpu
> hotplug kicking in as a cooling device at 38C. Bottom plot is a
> thermal ramp with cpu hotplug kicking in at 38C and cpufreq kicking in
> at 40C. One interesting thing to note is that the middle plot slowly
> drifts towards 40C even though cooling is set to 38C. I attribute this
> to the logic of step-wise governor combined with polling mode: if
> temperature is dropping above trip point, cooling is reduced. Adding
> another cooling device at 40C as a back-stop seems to keep temperature
> in check. In all cases running code was ARM's max_power test that
> maximizes CPU usage, as evidenced by results of 'top':
>   PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
>    33 root      20   0     0    0    0 R 100.0  0.0  45:46.43 thread1
>    32 root      20   0     0    0    0 R  91.4  0.0  44:48.14 thread0
>  1344 root      20   0     0    0    0 R   8.6  0.0   0:03.64 kworker/u4:1
>  1380 root      20   0  2476  996  712 R   0.3  0.1   0:00.07 top
>
> Sheet 2 (idle) has two plots. Top one represents latency of
> _cpu_down() while gradually adding instances of cyclictest process,
> from 0 to 10; 20 samples were captured in each case. Bottom one
> represents latency of _cpu_up() in the same test. Other than running
> cyclictest, the system was mostly idle.
>
> Sheet 3 (max_power) repeated the same test as in sheet 2, but it was
> running ARM's max_power test in the background.
>
> A quick look at the latency graphs shows that loading the system
> causes a stochastic - but not deterministic - component added to
> latencies. Minimum latency times appear unchanged.
>
>> - Homogeneous dual core Cortex-A9 environment.
>> - They go up to 48C when fully loaded. Can you explain where is your
>> sensor location? Gradient to hotspot, etc? 48C at A9s or board temperature?
> Thermal sensor is located at L2 cache, with gradient to sensor likely
> smaller than sensor inaccuracy.
>
>> - This code looks promising on embedded dual core system. However, it
>> does not necessarily mean it works fine on, say server side. How about a
>> system with 8/16/32 cores? How about a more heterogeneous workload? Not
>> to talk about heterogeneous cores. I think in more complicated scenarios
>> the data you provided above might even change. The difference between
>> your minimum and maximum shutdown/startup times are quite considerable,
>> so I am assuming your variance is not negligible, imaging if we scale
>> this up, what happens?
> Agreed that this is difficult to characterize across all platform
> types. Maybe other list members could comment the behaviour on their
> platforms? Passing in a cpu mask defines CPUs that contribute to
> cooling of a single zone, so there is some flexibility in defining
> cooling strategy. Hopefully this is good enough for a start...
>
>>
>> - The other point is that this type of cooling device must be taken in
>> very sensible way. Shutting down circuitry may not be the best strategy
>> for thermal. In fact, if you think about it, given you have a workload
>> well balanced between, say, two cores, as same of your environment,
>> turning one off it means you need to deal the very same load in only one
>> CPU. In other words, turning of circuitry means, from thermal standpoint
>> that you are increasing you heat/area ratio. Sometimes, you actually
>> want to increase this ratio in order to properly cool down your system.
> In this particular test case since both CPUs are fully loaded,
> temperature is reduced at the expense of parallelism (i.e. execution
> time), so overall heat/area is still reduced. If particular areas are
> heat-sensitive, then it makes sense to define a separate thermal zone
> (and sensor) for each of them. Just a thought.
>
> Looking forward to further discussion.
>
> Regards,
> Zoran
