Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3JZRHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 13:07:09 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51568 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3JZRHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 13:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131025174448.GD7024@krava.brq.redhat.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
	<1382533085-7166-5-git-send-email-eranian@google.com>
	<20131025174448.GD7024@krava.brq.redhat.com>
Date: Sat, 26 Oct 2013 19:07:06 +0200
Message-ID: <CABPqkBTKec0T0NDFUoC8qDVO9stACkzc2xnUqwx6yODHXKaYTg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] perf,x86: add RAPL hrtimer support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 7:44 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Oct 23, 2013 at 02:58:05PM +0200, Stephane Eranian wrote:
>> The RAPL PMU counters do not interrupt on overflow.
>> Therefore, the kernel needs to poll the counters
>> to avoid missing an overflow. This patch adds
>> the hrtimer code to do this.
>>
>> The timer internval is calculated at boot time
>> based on the power unit used by the HW.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_rapl.c |   75 +++++++++++++++++++++++++--
>>  1 file changed, 70 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
>> index 3d71d39..ed0566a 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
>> @@ -92,11 +92,13 @@ static struct kobj_attribute format_attr_##_var =         \
>>
>>  struct rapl_pmu {
>>       spinlock_t      lock;
>> -     atomic_t        refcnt;
>>       int             hw_unit;  /* 1/2^hw_unit Joule */
>> -     int             phys_id;
>> -     int             n_active; /* number of active events */
>> +     struct hrtimer  hrtimer;
>>       struct list_head active_list;
>> +     ktime_t         timer_interval; /* in ktime_t unit */
>> +     int             n_active; /* number of active events */
>> +     int             phys_id;
>> +     atomic_t        refcnt;
>>  };
>>
>>  static struct pmu rapl_pmu_class;
>> @@ -161,6 +163,47 @@ static u64 rapl_event_update(struct perf_event *event)
>>       return new_raw_count;
>>  }
>>
>> +static void rapl_start_hrtimer(struct rapl_pmu *pmu)
>> +{
>> +     __hrtimer_start_range_ns(&pmu->hrtimer,
>> +                     pmu->timer_interval, 0,
>> +                     HRTIMER_MODE_REL_PINNED, 0);
>> +}
>> +
>> +static void rapl_stop_hrtimer(struct rapl_pmu *pmu)
>> +{
>> +     hrtimer_cancel(&pmu->hrtimer);
>> +}
>> +
>> +static enum hrtimer_restart rapl_hrtimer_handle(struct hrtimer *hrtimer)
>> +{
>> +     struct rapl_pmu *pmu = container_of(hrtimer, struct rapl_pmu, hrtimer);
>> +     struct perf_event *event;
>> +     unsigned long flags;
>> +
>> +     if (!pmu->n_active)
>> +             return HRTIMER_NORESTART;
>> +
>> +     spin_lock_irqsave(&pmu->lock, flags);
>> +
>> +     list_for_each_entry(event, &pmu->active_list, active_entry) {
>> +             rapl_event_update(event);
>> +     }
>
> hi,
> I dont fully understand the reason for the timer,
> I'm probably missing something..
>
The reason is rather simple and is similar to what happens with uncore.
The counter are narrow, 32-bit and there is no interrupt capability. We
need to poll the counters and accumulate in the sw counter to avoid missing
an overflow.

> - the timer calls rapl_event_update for all defined events

No, only for the defined RAPL events which is what we want.

> - but rapl_pmu_event_read calls rapl_event_update any time the
>   event is read (sys_read)
>
Yes, but we want to prevent missing a counter overflow. It may happen
if the counter counts in a unit which increments fast.

> The rapl_event_update only read msr and updates
> event->count|hw,prev_count.
No, it does update the count:
        local64_add(sdelta, &event->count);
