Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaJUPxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:53:23 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:43491 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbaJUPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:53:21 -0400
MIME-Version: 1.0
In-Reply-To: <20141021091434.GN23531@worktop.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net> <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
 <20141019213534.GG23531@worktop.programming.kicks-ass.net>
 <CALCETrX3XYGd+2x_W89wq5tkuMBNF5NxDa02ha=UzQhU2r6Khg@mail.gmail.com>
 <20141020084813.GB3219@twins.programming.kicks-ass.net> <20141020105110.GA5002@linux.vnet.ibm.com>
 <20141021091434.GN23531@worktop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 21 Oct 2014 08:52:59 -0700
Message-ID: <CALCETrX8Y-PGBxU+tcCy7s-8KmYY3SVGHUWmvhBimgmwri+4uw@mail.gmail.com>
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        mpe@ellerman.id.au, anton@samba.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 2:14 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Oct 20, 2014 at 12:51:10PM +0200, Hendrik Brueckner wrote:
>> I think it would makes sense to return 0 as default in the
>> perf_event_idx_default() and let each PMU/arch that actually supports
>> reading PMCs from user space return the proper index.  And according
>> to tools/perf/design.txt, index must be non-zero to trigger a user space
>> read.
>
> OK, I've got something like the below. Michael/Anton, would you please
> clarify the ppc book3s capabilities?
>
> ---
> Subject: perf: Clean up pmu::event_idx
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue Oct 21 11:10:21 CEST 2014
>
> Andy reported that the current state of event_idx is rather confused.
> So remove all but the x86_pmu implementation and change the default to
> return 0 (the safe option).

I wrote essentially the same patch yesterday, so looks good to me :)

>
> Reported-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/powerpc/perf/hv-24x7.c     |    6 ------
>  arch/powerpc/perf/hv-gpci.c     |    6 ------
>  arch/s390/kernel/perf_cpum_sf.c |    6 ------
>  kernel/events/core.c            |   15 +--------------
>  kernel/events/hw_breakpoint.c   |    7 -------
>  5 files changed, 1 insertion(+), 39 deletions(-)
>
> --- a/arch/powerpc/perf/hv-24x7.c
> +++ b/arch/powerpc/perf/hv-24x7.c
> @@ -417,11 +417,6 @@ static int h_24x7_event_add(struct perf_
>         return 0;
>  }
>
> -static int h_24x7_event_idx(struct perf_event *event)
> -{
> -       return 0;
> -}
> -
>  static struct pmu h_24x7_pmu = {
>         .task_ctx_nr = perf_invalid_context,
>
> @@ -433,7 +428,6 @@ static struct pmu h_24x7_pmu = {
>         .start       = h_24x7_event_start,
>         .stop        = h_24x7_event_stop,
>         .read        = h_24x7_event_update,
> -       .event_idx   = h_24x7_event_idx,
>  };
>
>  static int hv_24x7_init(void)
> --- a/arch/powerpc/perf/hv-gpci.c
> +++ b/arch/powerpc/perf/hv-gpci.c
> @@ -246,11 +246,6 @@ static int h_gpci_event_init(struct perf
>         return 0;
>  }
>
> -static int h_gpci_event_idx(struct perf_event *event)
> -{
> -       return 0;
> -}
> -
>  static struct pmu h_gpci_pmu = {
>         .task_ctx_nr = perf_invalid_context,
>
> @@ -262,7 +257,6 @@ static struct pmu h_gpci_pmu = {
>         .start       = h_gpci_event_start,
>         .stop        = h_gpci_event_stop,
>         .read        = h_gpci_event_update,
> -       .event_idx   = h_gpci_event_idx,
>  };
>
>  static int hv_gpci_init(void)
> --- a/arch/s390/kernel/perf_cpum_sf.c
> +++ b/arch/s390/kernel/perf_cpum_sf.c
> @@ -1411,11 +1411,6 @@ static void cpumsf_pmu_del(struct perf_e
>         perf_pmu_enable(event->pmu);
>  }
>
> -static int cpumsf_pmu_event_idx(struct perf_event *event)
> -{
> -       return event->hw.idx;
> -}
> -
>  CPUMF_EVENT_ATTR(SF, SF_CYCLES_BASIC, PERF_EVENT_CPUM_SF);
>  CPUMF_EVENT_ATTR(SF, SF_CYCLES_BASIC_DIAG, PERF_EVENT_CPUM_SF_DIAG);
>
> @@ -1458,7 +1453,6 @@ static struct pmu cpumf_sampling = {
>         .stop         = cpumsf_pmu_stop,
>         .read         = cpumsf_pmu_read,
>
> -       .event_idx    = cpumsf_pmu_event_idx,
>         .attr_groups  = cpumsf_pmu_attr_groups,
>  };
>
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6071,11 +6071,6 @@ static int perf_swevent_init(struct perf
>         return 0;
>  }
>
> -static int perf_swevent_event_idx(struct perf_event *event)
> -{
> -       return 0;
> -}
> -
>  static struct pmu perf_swevent = {
>         .task_ctx_nr    = perf_sw_context,
>
> @@ -6085,8 +6080,6 @@ static struct pmu perf_swevent = {
>         .start          = perf_swevent_start,
>         .stop           = perf_swevent_stop,
>         .read           = perf_swevent_read,
> -
> -       .event_idx      = perf_swevent_event_idx,
>  };
>
>  #ifdef CONFIG_EVENT_TRACING
> @@ -6204,8 +6197,6 @@ static struct pmu perf_tracepoint = {
>         .start          = perf_swevent_start,
>         .stop           = perf_swevent_stop,
>         .read           = perf_swevent_read,
> -
> -       .event_idx      = perf_swevent_event_idx,
>  };
>
>  static inline void perf_tp_register(void)
> @@ -6431,8 +6422,6 @@ static struct pmu perf_cpu_clock = {
>         .start          = cpu_clock_event_start,
>         .stop           = cpu_clock_event_stop,
>         .read           = cpu_clock_event_read,
> -
> -       .event_idx      = perf_swevent_event_idx,
>  };
>
>  /*
> @@ -6511,8 +6500,6 @@ static struct pmu perf_task_clock = {
>         .start          = task_clock_event_start,
>         .stop           = task_clock_event_stop,
>         .read           = task_clock_event_read,
> -
> -       .event_idx      = perf_swevent_event_idx,
>  };
>
>  static void perf_pmu_nop_void(struct pmu *pmu)
> @@ -6542,7 +6529,7 @@ static void perf_pmu_cancel_txn(struct p
>
>  static int perf_event_idx_default(struct perf_event *event)
>  {
> -       return event->hw.idx + 1;
> +       return 0;
>  }
>
>  /*
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -605,11 +605,6 @@ static void hw_breakpoint_stop(struct pe
>         bp->hw.state = PERF_HES_STOPPED;
>  }
>
> -static int hw_breakpoint_event_idx(struct perf_event *bp)
> -{
> -       return 0;
> -}
> -
>  static struct pmu perf_breakpoint = {
>         .task_ctx_nr    = perf_sw_context, /* could eventually get its own */
>
> @@ -619,8 +614,6 @@ static struct pmu perf_breakpoint = {
>         .start          = hw_breakpoint_start,
>         .stop           = hw_breakpoint_stop,
>         .read           = hw_breakpoint_pmu_read,
> -
> -       .event_idx      = hw_breakpoint_event_idx,
>  };
>
>  int __init init_hw_breakpoint(void)



-- 
Andy Lutomirski
AMA Capital Management, LLC
