Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab3BSTY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:24:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab3BSTYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:24:55 -0500
Date: Tue, 19 Feb 2013 20:24:03 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v4 2/2] perf: add sysfs entry to adjust multiplexing
 interval per PMU
Message-ID: <20130219192403.GA17767@krava.redhat.com>
References: <1361210084-14409-1-git-send-email-eranian@google.com>
 <1361210084-14409-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361210084-14409-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 06:54:44PM +0100, Stephane Eranian wrote:

SNIP

> +perf_event_mux_interval_ms_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t count)
> +{
> +	struct pmu *pmu = dev_get_drvdata(dev);
> +	int timer, cpu, ret;
> +
> +	ret = kstrtoint(buf, 0, &timer);
> +	if (ret)
> +		return ret;
> +
> +	if (timer < 1)
> +		return -EINVAL;
> +
> +	pmu->hrtimer_interval_ms = timer;
> +
> +	/* update all cpuctx for this PMU */
> +	for_each_possible_cpu(cpu) {
> +		struct perf_cpu_context *cpuctx;
> +		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
> +		cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
> +	}

If we set the timer to some big value like few minutes,
then run the meassurements and then set the value back to 1,
we actually need to wait till the big timer is expired before
the new value takes place.

I think we need to cancel the possible running timer in here
like in the atached patch, but maybe consider some locking.

jirka


diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7c3f00f..ce9cd54 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6038,6 +6038,9 @@ perf_event_mux_interval_ms_store(struct device *dev,
 		struct perf_cpu_context *cpuctx;
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
+
+		if (hrtimer_active(&cpuctx->hrtimer))
+			hrtimer_cancel(&cpuctx->hrtimer);
 	}
 
 	return count;
