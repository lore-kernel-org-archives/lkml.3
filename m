Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3IJNiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:38:50 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:38427 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3IJNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:38:48 -0400
Date: Tue, 10 Sep 2013 15:38:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: eranian@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was:
 Re: [GIT PULL] perf changes for v3.12)
Message-ID: <20130910133845.GB7537@gmail.com>
References: <20130903132933.GA24955@gmail.com>
 <CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
 <20130909100544.GI31370@twins.programming.kicks-ass.net>
 <CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
 <20130910115306.GA6091@gmail.com>
 <CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@googlemail.com> wrote:

> Hi,
> 
> Ok, so I am able to reproduce the problem using a simpler
> test case with a simple multithreaded program where
> #threads >> #CPUs.

Does it go away if you use 'perf record --all-cpus'?

> [ 2229.021934] WARNING: CPU: 6 PID: 17496 at
> arch/x86/kernel/cpu/perf_event_intel_ds.c:1003
> intel_pmu_drain_pebs_hsw+0xa8/0xc0()
> [ 2229.021936] Unexpected number of pebs records 21
> 
> [ 2229.021966] Call Trace:
> [ 2229.021967]  <NMI>  [<ffffffff8159dcd6>] dump_stack+0x46/0x58
> [ 2229.021976]  [<ffffffff8108dfdc>] warn_slowpath_common+0x8c/0xc0
> [ 2229.021979]  [<ffffffff8108e0c6>] warn_slowpath_fmt+0x46/0x50
> [ 2229.021982]  [<ffffffff810646c8>] intel_pmu_drain_pebs_hsw+0xa8/0xc0
> [ 2229.021986]  [<ffffffff810668f0>] intel_pmu_handle_irq+0x220/0x380
> [ 2229.021991]  [<ffffffff810c1d35>] ? sched_clock_cpu+0xc5/0x120
> [ 2229.021995]  [<ffffffff815a5a84>] perf_event_nmi_handler+0x34/0x60
> [ 2229.021998]  [<ffffffff815a52b8>] nmi_handle.isra.3+0x88/0x180
> [ 2229.022001]  [<ffffffff815a5490>] do_nmi+0xe0/0x330
> [ 2229.022004]  [<ffffffff815a48f7>] end_repeat_nmi+0x1e/0x2e
> [ 2229.022008]  [<ffffffff810652b3>] ? intel_pmu_pebs_enable_all+0x33/0x40
> [ 2229.022011]  [<ffffffff810652b3>] ? intel_pmu_pebs_enable_all+0x33/0x40
> [ 2229.022015]  [<ffffffff810652b3>] ? intel_pmu_pebs_enable_all+0x33/0x40
> [ 2229.022016]  <<EOE>>  [<ffffffff810659f3>] intel_pmu_enable_all+0x23/0xa0
> [ 2229.022021]  [<ffffffff8105ff84>] x86_pmu_enable+0x274/0x310
> [ 2229.022025]  [<ffffffff81141927>] perf_pmu_enable+0x27/0x30
> [ 2229.022029]  [<ffffffff81143219>] perf_event_context_sched_in+0x79/0xc0
> 
> Could be a HW race whereby the PEBS of each HT threads get mixed up.

Yes, that seems plausible and would explain why the overrun is usually a 
small integer. We set up the DS with PEBS_BUFFER_SIZE == 4096, so with a 
record size of 192 bytes on HSW we should get index values of 0-21.

That fits within the indices range reported so far.

> [...] I will add a couple more checks to verify that. The intr_thres 
> should not have changed. Yet looks like we have a sitation where the 
> index is way past the threshold.

Btw., it would also be nice to add a check of ds->pebs_index against 
ds->pebs_absolute_maximum, to make sure the PEBS record index never goes 
outside the DS area. I.e. to protect against random corruption.

Right now we do only half a check:

        n = top - at;
        if (n <= 0)
                return;

this still allows an upwards overflow. We check x86_pmu.max_pebs_events 
but then let it continue:

        WARN_ONCE(n > x86_pmu.max_pebs_events,
                  "Unexpected number of pebs records %d\n", n);

        return __intel_pmu_drain_pebs_nhm(iregs, at, top);

Instead it should be something more robust, like:

	if (WARN_ONCE(n > max ...)) {
		/* Drain the PEBS buffer: */
		ds->pebs_index = ds->pebs_buffer_base;
		return;
	}

Thanks,

	Ingo
