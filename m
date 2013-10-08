Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3JHPKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:10:37 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64908 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3JHPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:10:36 -0400
MIME-Version: 1.0
In-Reply-To: <87pprgzref.fsf@tassilo.jf.intel.com>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
	<1381162158-24329-2-git-send-email-eranian@google.com>
	<20131007175542.GB3363@tassilo.jf.intel.com>
	<CABPqkBRYCGumFo1JO6VKXUiVpoDdUW61X7cHJeyw3WDu-wxM8Q@mail.gmail.com>
	<87pprgzref.fsf@tassilo.jf.intel.com>
Date: Tue, 8 Oct 2013 17:10:35 +0200
Message-ID: <CABPqkBS+5sP6xSEHERWan+nt3bDku4qYgRxhmkhtm-4+TWuUEw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Mon, Oct 7, 2013 at 11:45 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Stephane Eranian <eranian@google.com> writes:
>>
>>>> +             goto again;
>>>> +
>>>> +     struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
>>>> +
>>>> +     if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
>>>> +             return;
>>>> +
>>>> +     event->hw.state = 0;
>>>> +
>>>> +     local64_set(&event->hw.prev_count, rapl_read_counter(event));
>>>> +
>>>> +     pmu->n_active++;
>>>
>>> What lock protects this add?
>>>
>> None. I will add one. Bu then I am wondering about if it is really
>> necessary given
>> that RAPL event are system-wide and this pinned to a CPU. If the call came
>> from another CPU, then it IPI there, and that means that CPU is executing that
>> code. Any other CPU will need IPI too, and that interrupt will be kept pending.
>> Am I missing a test case here? Are IPI reentrant?
>
> they can be if interrupts are enabled (likely here)
>
So, I spent some time trying to figure this out via instrumentation and it seems
it is never the case that this function or in fact __perf_event_enable() for a
syswide event is called with interrupts enabled. Why?

Well, it has to do with cpu_function_call() which is ALWAYS called for a syswide
event on the perf_event_enable() code path.

If you are calling for an event on the same CPU, you end up executing:
smp_call_function_single()
       if (cpu == this_cpu) {
                local_irq_save(flags);
                func(info);
                local_irq_restore(flags);

If you are calling a remote CPU, then you end up in the APIC code to send
an IPI. On the receiving side, I could not find the local_irq_save() call, but
I verified that upon entry, __perf_event_enable() has interrupts disabled.
And that's either because I missed the interrupt masking call OR because
the HW does it automatically for us. I could not yet figure this out.

In any case, looks like both the start() and stop() routine are protected
from interrupts and thus preemption, so we may not need a lock to
protect n_active.
