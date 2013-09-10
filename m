Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3IJLxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:53:12 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:42181 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3IJLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:53:10 -0400
Date: Tue, 10 Sep 2013 13:53:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: eranian@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: PEBS bug on HSW: "Unexpected number of pebs records 10" (was: Re:
 [GIT PULL] perf changes for v3.12)
Message-ID: <20130910115306.GA6091@gmail.com>
References: <20130903132933.GA24955@gmail.com>
 <CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
 <20130909100544.GI31370@twins.programming.kicks-ass.net>
 <CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@googlemail.com> wrote:

> Hi,
> 
> 
> And what was the perf record command line for this crash?

AFAICS it wasn't a crash but the WARN_ON() in intel_pmu_drain_pebs_hsw(), 
at arch/x86/kernel/cpu/perf_event_intel_ds.c:1003.

        at  = (struct pebs_record_hsw *)(unsigned long)ds->pebs_buffer_base;
        top = (struct pebs_record_hsw *)(unsigned long)ds->pebs_index;

        n = top - at;
        if (n <= 0)
                return;

        /*
         * Should not happen, we program the threshold at 1 and do not
         * set a reset value.
         */
        WARN_ONCE(n > x86_pmu.max_pebs_events,
                  "Unexpected number of pebs records %d\n", n);

The command line Linus used was probably close to:

   perf record -e cycles:pp -g make -j64 bzImage

i.e. PEBS precise profiling, call chains, LBR is used to figure out the 
real instruction, but no '-a' per CPU profiling option, i.e. high 
frequency per task PMU context switching.

Note that AFAIK neither the kernel nor user-space used any TSX extensions, 
so this is the Haswell PMU in pure compatibility mode.

My (wild) guess is that unless all of us missed some subtle race in the 
PEBS code it's an (unknown?) erratum: the hardware got confused by the 
high frequency PMU switches, in this particular case where we got a new 
PMI right after a very short interval was programmed:

>>  Call Trace:
>>   <NMI>  [<ffffffff815fc637>] dump_stack+0x45/0x56
>>   [<ffffffff81051e78>] warn_slowpath_common+0x78/0xa0
>>   [<ffffffff81051ee7>] warn_slowpath_fmt+0x47/0x50
>>   [<ffffffff8101b051>] intel_pmu_drain_pebs_hsw+0x91/0xa0
>>   [<ffffffff8101c5d0>] intel_pmu_handle_irq+0x210/0x390
>>   [<ffffffff81604deb>] perf_event_nmi_handler+0x2b/0x50
>>   [<ffffffff81604670>] nmi_handle.isra.3+0x80/0x180
>>   [<ffffffff81604840>] do_nmi+0xd0/0x310
>>   [<ffffffff81603d37>] end_repeat_nmi+0x1e/0x2e
>>   <<EOE>>  [<ffffffff810167df>] perf_events_lapic_init+0x2f/0x40
>>   [<ffffffff81016a50>] x86_pmu_enable+0x260/0x310
>>   [<ffffffff81111d87>] perf_pmu_enable+0x27/0x30
>>   [<ffffffff81112140>] perf_event_context_sched_in+0x80/0xc0
>>   [<ffffffff811127eb>] __perf_event_task_sched_in+0x16b/0x180
>>   [<ffffffff8107c300>] finish_task_switch+0x70/0xa0
>>   [<ffffffff81600f48>] __schedule+0x368/0x7c0
>>   [<ffffffff816013c4>] schedule+0x24/0x70

Note that due to per task profiling the default (long, about 1 KHz) 
interval can get chopped up and can result in a very small period value 
being reprogrammed at PMU-sched-in time.

That kind of high-freq back-to-back activity could, in theory, confuse the 
PEBS hardware. Or the kernel :-)

Thanks,

	Ingo
