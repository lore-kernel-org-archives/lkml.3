Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbbASO2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:28:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:25480 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbbASO2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:28:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442280841"
From: "Liang, Kan" <kan.liang@intel.com>
To: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "eranian@google.com" <eranian@google.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V2 1/1] perf, core: Use sample period avg as child
 event's initial period
Thread-Topic: [PATCH V2 1/1] perf, core: Use sample period avg as child
 event's initial period
Thread-Index: AQHQGWkZzmFCxc1lG0KLVSVMTyWYFpzHsFfQ
Date: Mon, 19 Jan 2015 14:28:46 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016A14E3@SHSMSX103.ccr.corp.intel.com>
References: <1418757918-27893-1-git-send-email-kan.liang@intel.com>
In-Reply-To: <1418757918-27893-1-git-send-email-kan.liang@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

The patch is month old. I checked that it still apply to current tip.
Could you please take a look?

Thanks,
Kan

> 
> From: Kan Liang <kan.liang@intel.com>
> 
> For perf record frequency mode, the initial sample_period is 1. That's
> because perf doesn't know what period should be set. It uses the
> minimum period 1 as the first period. It will trigger an interrupt soon. Then
> there will be enough data to calculate the period for the given frequency.
> But too many very short period like 1 may cause various problems and
> increase the overhead. It's better to limit the 1 period to just the first
> several period setting.
> 
> However, for some workload, 1 period is frequently set. For example, perf
> record a busy loop for 10 seconds.
> 
> perf record ./finity_busy_loop.sh 10
> 
> while [ "A" != "B" ]
> do
> date > /dev/null
> done
> 
> Period was changed 150503 times in 10 seconds. 22.5% (33861 times) of the
> period is set to 1. That's because, in the inherit_event, the period for child
> event is inherit from parent's parent's event, which is usually the default
> sample_period 1. Each child event has to recalculate the period from 1
> everytime. That brings high overhead.
> 
> This patch keeps the sample period average in parent event. Each new
> child event can use it as its initial sample period.
> The avg_sample_period was introduced in struct perf_event to track the
> average sample period information. The information is kept in the parent
> event, since it's the only node everyone knows. For reducing the
> contention of updating parent event, the value is updated every tick.
> We also need to get rid of 1 period as earlier as possible. So the value is
> also updated in the first period adjustment.
> For each new child event, the average sample period of parent event will
> be assigned to the child as its first sample period.
> For each new child event, the parent event refcount++. Parent will not go
> away until all children go away. So it's safe to access its parent.
> 
> After applying this patch, the 1 period rate reduces to 0.1%.
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> 
> ---
> 
> Changes since V1
>  - The average sample period will be kept in parent event
>  - Use atomic64_t to replace local64_t
>  - Only update the AVG every tick or the first time
> 
>  include/linux/perf_event.h |  2 ++
>  kernel/events/core.c       | 21 +++++++++++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h index
> 486e84c..bb886f0 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -403,6 +403,8 @@ struct perf_event {
>  	struct list_head		child_list;
>  	struct perf_event		*parent;
> 
> +	atomic64_t			avg_sample_period;
> +
>  	int				oncpu;
>  	int				cpu;
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c index
> af0a5ba..3404d52 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2796,6 +2796,7 @@ static void perf_adjust_period(struct perf_event
> *event, u64 nsec, u64 count, bo
>  	struct hw_perf_event *hwc = &event->hw;
>  	s64 period, sample_period;
>  	s64 delta;
> +	struct perf_event *head_event = (event->parent != NULL) ?
> +event->parent : event;
> 
>  	period = perf_calculate_period(event, nsec, count);
> 
> @@ -2809,6 +2810,17 @@ static void perf_adjust_period(struct
> perf_event *event, u64 nsec, u64 count, bo
> 
>  	hwc->sample_period = sample_period;
> 
> +	/*
> +	 * Update the AVG sample period in first period adjustment
> +	 * Then update it every tick to reduce contention.
> +	 */
> +	if (!disable || (atomic64_read(&head_event->avg_sample_period)
> == 1)) {
> +		s64 avg_period;
> +
> +		avg_period = (atomic64_read(&head_event-
> >avg_sample_period) + sample_period) / 2;
> +		atomic64_set(&head_event->avg_sample_period,
> avg_period);
> +	}
> +
>  	if (local64_read(&hwc->period_left) > 8*sample_period) {
>  		if (disable)
>  			event->pmu->stop(event, PERF_EF_UPDATE); @@
> -7030,8 +7042,13 @@ perf_event_alloc(struct perf_event_attr *attr, int
> cpu,
> 
>  	hwc = &event->hw;
>  	hwc->sample_period = attr->sample_period;
> -	if (attr->freq && attr->sample_freq)
> +	if (attr->freq && attr->sample_freq) {
>  		hwc->sample_period = 1;
> +		if (parent_event)
> +			hwc->sample_period =
> atomic64_read(&parent_event->avg_sample_period);
> +		else
> +			atomic64_set(&event->avg_sample_period, hwc-
> >sample_period);
> +	}
>  	hwc->last_period = hwc->sample_period;
> 
>  	local64_set(&hwc->period_left, hwc->sample_period); @@ -
> 7902,7 +7919,7 @@ inherit_event(struct perf_event *parent_event,
>  		child_event->state = PERF_EVENT_STATE_OFF;
> 
>  	if (parent_event->attr.freq) {
> -		u64 sample_period = parent_event->hw.sample_period;
> +		u64 sample_period = atomic64_read(&parent_event-
> >avg_sample_period);
>  		struct hw_perf_event *hwc = &child_event->hw;
> 
>  		hwc->sample_period = sample_period;
> --
> 1.8.3.2

