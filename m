Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934971Ab3BTT7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:59:49 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:37651 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934002Ab3BTT7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:59:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130219192403.GA17767@krava.redhat.com>
References: <1361210084-14409-1-git-send-email-eranian@google.com>
	<1361210084-14409-3-git-send-email-eranian@google.com>
	<20130219192403.GA17767@krava.redhat.com>
Date: Wed, 20 Feb 2013 20:59:45 +0100
Message-ID: <CABPqkBTYjqwKD-yG2ib=WC8JVT3sqqYaZy9yAAf0WA5Lg-wYug@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] perf: add sysfs entry to adjust multiplexing
 interval per PMU
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 8:24 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Feb 18, 2013 at 06:54:44PM +0100, Stephane Eranian wrote:
>
> SNIP
>
>> +perf_event_mux_interval_ms_store(struct device *dev,
>> +                              struct device_attribute *attr,
>> +                              const char *buf, size_t count)
>> +{
>> +     struct pmu *pmu = dev_get_drvdata(dev);
>> +     int timer, cpu, ret;
>> +
>> +     ret = kstrtoint(buf, 0, &timer);
>> +     if (ret)
>> +             return ret;
>> +
>> +     if (timer < 1)
>> +             return -EINVAL;
>> +
>> +     pmu->hrtimer_interval_ms = timer;
>> +
>> +     /* update all cpuctx for this PMU */
>> +     for_each_possible_cpu(cpu) {
>> +             struct perf_cpu_context *cpuctx;
>> +             cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
>> +             cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
>> +     }
>
> If we set the timer to some big value like few minutes,
> then run the meassurements and then set the value back to 1,
> we actually need to wait till the big timer is expired before
> the new value takes place.
>
> I think we need to cancel the possible running timer in here
> like in the atached patch, but maybe consider some locking.
>
I will fix that. Thanks for pointing this out.

> jirka
>
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 7c3f00f..ce9cd54 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6038,6 +6038,9 @@ perf_event_mux_interval_ms_store(struct device *dev,
>                 struct perf_cpu_context *cpuctx;
>                 cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
>                 cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
> +
> +               if (hrtimer_active(&cpuctx->hrtimer))
> +                       hrtimer_cancel(&cpuctx->hrtimer);
>         }
>
>         return count;
