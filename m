Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3JGU6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:58:47 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:64500 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3JGU6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:58:45 -0400
MIME-Version: 1.0
In-Reply-To: <20131007175542.GB3363@tassilo.jf.intel.com>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
	<1381162158-24329-2-git-send-email-eranian@google.com>
	<20131007175542.GB3363@tassilo.jf.intel.com>
Date: Mon, 7 Oct 2013 22:58:44 +0200
Message-ID: <CABPqkBRYCGumFo1JO6VKXUiVpoDdUW61X7cHJeyw3WDu-wxM8Q@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 7:55 PM, Andi Kleen <ak@linux.intel.com> wrote:
> Quick review. Thanks for working on this. It should work
> nicely with ucevent -- people already asked for reporting
> power numbers there.
>
Yes, got some requests myself too. So I implemented this.

>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
>> new file mode 100644
>> index 0000000..f59dbd4
>> --- /dev/null
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
>> @@ -0,0 +1,580 @@
>
> Having a comment at the beginning of each file with two sentences
> what the file roughly does and what "RAPL" actually is would be useful.
>
> Also a pointer to the SDM chapters is also useful.
>
Forgot to add that. Will do in V2.

>> +static u64 rapl_event_update(struct perf_event *event)
>> +{
>> +     struct hw_perf_event *hwc = &event->hw;
>> +     u64 prev_raw_count, new_raw_count;
>> +     s64 delta, sdelta;
>> +     int shift = RAPL_CNTR_WIDTH;
>> +
>> +again:
>> +     prev_raw_count = local64_read(&hwc->prev_count);
>> +     rdmsrl(event->hw.event_base, new_raw_count);
>> +
>> +     if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
>> +                         new_raw_count) != prev_raw_count)
>
> Add a cpu_relax()
>
But then it should be in perf_event_*.c as well.
It's a verbatim copy of the existing code. Now given that RAPL does not
interrupt, the only risk here would be preemption. I did not verify whether
this function was always called with interrupts disabled. So I left the retry
loop.


>> +             goto again;
>> +
>> +     struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
>> +
>> +     if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
>> +             return;
>> +
>> +     event->hw.state = 0;
>> +
>> +     local64_set(&event->hw.prev_count, rapl_read_counter(event));
>> +
>> +     pmu->n_active++;
>
> What lock protects this add?
>
None. I will add one. Bu then I am wondering about if it is really
necessary given
that RAPL event are system-wide and this pinned to a CPU. If the call came
from another CPU, then it IPI there, and that means that CPU is executing that
code. Any other CPU will need IPI too, and that interrupt will be kept pending.
Am I missing a test case here? Are IPI reentrant?

>> +}
>> +
>> +static ssize_t rapl_get_attr_cpumask(struct device *dev,
>> +                             struct device_attribute *attr, char *buf)
>> +{
>> +     int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &rapl_cpu_mask);
>
> Check n here in case it overflowed
>
But isn't that what the -2 and the below \n\0 are for?

>> +
>> +     buf[n++] = '\n';
>> +     buf[n] = '\0';
>> +     return n;
>
>
>
>> +     for_each_online_cpu(i) {
>> +             pmu2 = per_cpu(rapl_pmu, i);
>> +
>> +             if (!pmu2 || i == cpu)
>> +                     continue;
>> +
>> +             if (pmu2->phys_id == phys_id) {
>> +                     per_cpu(rapl_pmu, cpu) = pmu2;
>> +                     per_cpu(rapl_pmu_kfree, cpu) = pmu1;
>> +                     atomic_inc(&pmu2->refcnt);
>> +                     break;
>> +             }
>> +     }
>
> Doesn't this need a lock of some form? AFAIK we can do parallel
> CPU startup now.
>
Did not know about this change? But then that means all the other
perf_event *_starting() and maybe even _*prepare() routines must also
use locks. I can add that to RAPL.

> Similar to the other code walking the CPUs.
>
>> +static int __init rapl_pmu_init(void)
>> +{
>> +     struct rapl_pmu *pmu;
>> +     int i, cpu, ret;
>
> You need to check for Intel CPU here, as this is called unconditionally.
>
> A more modern way to do this is to use x86_cpu_id.
> This would in principle allow making it a module later (if perf ever
> supports that)
>
Forgot that, will fix it.

>> +
>> +     /* check supported CPU */
>> +     switch (boot_cpu_data.x86_model) {
>> +     case 42: /* Sandy Bridge */
>> +     case 58: /* Ivy Bridge */
>> +     case 60: /* Haswell */
>
> Need more model numbers for Haswell (see the main perf driver)
>
Don't have all the models to test...

>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index abe69af..12bfd7d 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -895,7 +895,6 @@ int __perf_evsel__read(struct perf_evsel *evsel,
>>                       if (readn(FD(evsel, cpu, thread),
>>                                 &count, nv * sizeof(u64)) < 0)
>>                               return -errno;
>> -
>>                       aggr->val += count.val;
>>                       if (scale) {
>>                               aggr->ena += count.ena;
>
> Bogus hunk
>
Arg, yes. It should not be here.


Thanks for the review.
