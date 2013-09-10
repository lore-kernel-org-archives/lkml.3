Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3IJMcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:32:17 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33580 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3IJMcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:32:16 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20130910115306.GA6091@gmail.com>
References: <20130903132933.GA24955@gmail.com>
	<CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
	<20130909100544.GI31370@twins.programming.kicks-ass.net>
	<CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
	<20130910115306.GA6091@gmail.com>
Date: Tue, 10 Sep 2013 05:32:13 -0700
Message-ID: <CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was: Re:
 [GIT PULL] perf changes for v3.12)
From: Stephane Eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ok, so I am able to reproduce the problem using a simpler
test case with a simple multithreaded program where
#threads >> #CPUs.

[ 2229.021934] WARNING: CPU: 6 PID: 17496 at
arch/x86/kernel/cpu/perf_event_intel_ds.c:1003
intel_pmu_drain_pebs_hsw+0xa8/0xc0()
[ 2229.021936] Unexpected number of pebs records 21

[ 2229.021966] Call Trace:
[ 2229.021967]  <NMI>  [<ffffffff8159dcd6>] dump_stack+0x46/0x58
[ 2229.021976]  [<ffffffff8108dfdc>] warn_slowpath_common+0x8c/0xc0
[ 2229.021979]  [<ffffffff8108e0c6>] warn_slowpath_fmt+0x46/0x50
[ 2229.021982]  [<ffffffff810646c8>] intel_pmu_drain_pebs_hsw+0xa8/0xc0
[ 2229.021986]  [<ffffffff810668f0>] intel_pmu_handle_irq+0x220/0x380
[ 2229.021991]  [<ffffffff810c1d35>] ? sched_clock_cpu+0xc5/0x120
[ 2229.021995]  [<ffffffff815a5a84>] perf_event_nmi_handler+0x34/0x60
[ 2229.021998]  [<ffffffff815a52b8>] nmi_handle.isra.3+0x88/0x180
[ 2229.022001]  [<ffffffff815a5490>] do_nmi+0xe0/0x330
[ 2229.022004]  [<ffffffff815a48f7>] end_repeat_nmi+0x1e/0x2e
[ 2229.022008]  [<ffffffff810652b3>] ? intel_pmu_pebs_enable_all+0x33/0x40
[ 2229.022011]  [<ffffffff810652b3>] ? intel_pmu_pebs_enable_all+0x33/0x40
[ 2229.022015]  [<ffffffff810652b3>] ? intel_pmu_pebs_enable_all+0x33/0x40
[ 2229.022016]  <<EOE>>  [<ffffffff810659f3>] intel_pmu_enable_all+0x23/0xa0
[ 2229.022021]  [<ffffffff8105ff84>] x86_pmu_enable+0x274/0x310
[ 2229.022025]  [<ffffffff81141927>] perf_pmu_enable+0x27/0x30
[ 2229.022029]  [<ffffffff81143219>] perf_event_context_sched_in+0x79/0xc0

Could be a HW race whereby the PEBS of each HT threads get mixed up.
I will add a couple more checks to verify that. The intr_thres should not
have changed. Yet looks like we have a sitation where the index is way
past the threshold.



On Tue, Sep 10, 2013 at 4:53 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@googlemail.com> wrote:
>
>> Hi,
>>
>>
>> And what was the perf record command line for this crash?
>
> AFAICS it wasn't a crash but the WARN_ON() in intel_pmu_drain_pebs_hsw(),
> at arch/x86/kernel/cpu/perf_event_intel_ds.c:1003.
>
>         at  = (struct pebs_record_hsw *)(unsigned long)ds->pebs_buffer_base;
>         top = (struct pebs_record_hsw *)(unsigned long)ds->pebs_index;
>
>         n = top - at;
>         if (n <= 0)
>                 return;
>
>         /*
>          * Should not happen, we program the threshold at 1 and do not
>          * set a reset value.
>          */
>         WARN_ONCE(n > x86_pmu.max_pebs_events,
>                   "Unexpected number of pebs records %d\n", n);
>
> The command line Linus used was probably close to:
>
>    perf record -e cycles:pp -g make -j64 bzImage
>
> i.e. PEBS precise profiling, call chains, LBR is used to figure out the
> real instruction, but no '-a' per CPU profiling option, i.e. high
> frequency per task PMU context switching.
>
> Note that AFAIK neither the kernel nor user-space used any TSX extensions,
> so this is the Haswell PMU in pure compatibility mode.
>
> My (wild) guess is that unless all of us missed some subtle race in the
> PEBS code it's an (unknown?) erratum: the hardware got confused by the
> high frequency PMU switches, in this particular case where we got a new
> PMI right after a very short interval was programmed:
>
>>>  Call Trace:
>>>   <NMI>  [<ffffffff815fc637>] dump_stack+0x45/0x56
>>>   [<ffffffff81051e78>] warn_slowpath_common+0x78/0xa0
>>>   [<ffffffff81051ee7>] warn_slowpath_fmt+0x47/0x50
>>>   [<ffffffff8101b051>] intel_pmu_drain_pebs_hsw+0x91/0xa0
>>>   [<ffffffff8101c5d0>] intel_pmu_handle_irq+0x210/0x390
>>>   [<ffffffff81604deb>] perf_event_nmi_handler+0x2b/0x50
>>>   [<ffffffff81604670>] nmi_handle.isra.3+0x80/0x180
>>>   [<ffffffff81604840>] do_nmi+0xd0/0x310
>>>   [<ffffffff81603d37>] end_repeat_nmi+0x1e/0x2e
>>>   <<EOE>>  [<ffffffff810167df>] perf_events_lapic_init+0x2f/0x40
>>>   [<ffffffff81016a50>] x86_pmu_enable+0x260/0x310
>>>   [<ffffffff81111d87>] perf_pmu_enable+0x27/0x30
>>>   [<ffffffff81112140>] perf_event_context_sched_in+0x80/0xc0
>>>   [<ffffffff811127eb>] __perf_event_task_sched_in+0x16b/0x180
>>>   [<ffffffff8107c300>] finish_task_switch+0x70/0xa0
>>>   [<ffffffff81600f48>] __schedule+0x368/0x7c0
>>>   [<ffffffff816013c4>] schedule+0x24/0x70
>
> Note that due to per task profiling the default (long, about 1 KHz)
> interval can get chopped up and can result in a very small period value
> being reprogrammed at PMU-sched-in time.
>
> That kind of high-freq back-to-back activity could, in theory, confuse the
> PEBS hardware. Or the kernel :-)
>
> Thanks,
>
>         Ingo
