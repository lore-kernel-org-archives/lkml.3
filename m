Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3JGRzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:55:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:22120 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab3JGRzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1051,1371106800"; 
   d="scan'208";a="412875309"
Date: Mon, 7 Oct 2013 10:55:42 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com
Subject: Re: [PATCH v1 1/2] perf,x86: add Intel RAPL PMU support
Message-ID: <20131007175542.GB3363@tassilo.jf.intel.com>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
 <1381162158-24329-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381162158-24329-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick review. Thanks for working on this. It should work
nicely with ucevent -- people already asked for reporting 
power numbers there.

> diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> new file mode 100644
> index 0000000..f59dbd4
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> @@ -0,0 +1,580 @@

Having a comment at the beginning of each file with two sentences
what the file roughly does and what "RAPL" actually is would be useful.

Also a pointer to the SDM chapters is also useful.

> +static u64 rapl_event_update(struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc = &event->hw;
> +	u64 prev_raw_count, new_raw_count;
> +	s64 delta, sdelta;
> +	int shift = RAPL_CNTR_WIDTH;
> +
> +again:
> +	prev_raw_count = local64_read(&hwc->prev_count);
> +	rdmsrl(event->hw.event_base, new_raw_count);
> +
> +	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
> +			    new_raw_count) != prev_raw_count)

Add a cpu_relax()

> +		goto again;
> +
> +	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
> +
> +	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
> +		return;
> +
> +	event->hw.state = 0;
> +
> +	local64_set(&event->hw.prev_count, rapl_read_counter(event));
> +
> +	pmu->n_active++;

What lock protects this add? 

> +}
> +
> +static ssize_t rapl_get_attr_cpumask(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &rapl_cpu_mask);

Check n here in case it overflowed

> +
> +	buf[n++] = '\n';
> +	buf[n] = '\0';
> +	return n;



> +	for_each_online_cpu(i) {
> +		pmu2 = per_cpu(rapl_pmu, i);
> +
> +		if (!pmu2 || i == cpu)
> +			continue;
> +
> +		if (pmu2->phys_id == phys_id) {
> +			per_cpu(rapl_pmu, cpu) = pmu2;
> +			per_cpu(rapl_pmu_kfree, cpu) = pmu1;
> +			atomic_inc(&pmu2->refcnt);
> +			break;
> +		}
> +	}

Doesn't this need a lock of some form? AFAIK we can do parallel
CPU startup now.

Similar to the other code walking the CPUs.

> +static int __init rapl_pmu_init(void)
> +{
> +	struct rapl_pmu *pmu;
> +	int i, cpu, ret;

You need to check for Intel CPU here, as this is called unconditionally.

A more modern way to do this is to use x86_cpu_id. 
This would in principle allow making it a module later (if perf ever
supports that)

> +
> +	/* check supported CPU */
> +	switch (boot_cpu_data.x86_model) {
> +	case 42: /* Sandy Bridge */
> +	case 58: /* Ivy Bridge */
> +	case 60: /* Haswell */

Need more model numbers for Haswell (see the main perf driver) 

> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index abe69af..12bfd7d 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -895,7 +895,6 @@ int __perf_evsel__read(struct perf_evsel *evsel,
>  			if (readn(FD(evsel, cpu, thread),
>  				  &count, nv * sizeof(u64)) < 0)
>  				return -errno;
> -
>  			aggr->val += count.val;
>  			if (scale) {
>  				aggr->ena += count.ena;

Bogus hunk

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
