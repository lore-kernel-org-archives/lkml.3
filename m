Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3A1Wc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:32:59 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33058 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3A1Wc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:32:57 -0500
MIME-Version: 1.0
In-Reply-To: <1359151245-13179-8-git-send-email-andi@firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
	<1359151245-13179-8-git-send-email-andi@firstfloor.org>
Date: Mon, 28 Jan 2013 23:32:56 +0100
Message-ID: <CABPqkBTM8w_RVrQNiyhBprMBjL5a0Q7Y9KQsKP3Ld62EZPSufQ@mail.gmail.com>
Subject: Re: [PATCH 07/12] perf, x86: Avoid checkpointed counters causing
 excessive TSX aborts v3
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:00 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> With checkpointed counters there can be a situation where the counter
> is overflowing, aborts the transaction, is set back to a non overflowing
> checkpoint, causes interupt. The interrupt doesn't see the overflow
> because it has been checkpointed.  This is then a spurious PMI, typically with a
> ugly NMI message.  It can also lead to excessive aborts.
>
> Avoid this problem by:
> - Using the full counter width for counting counters (previous patch)
> - Forbid sampling for checkpointed counters. It's not too useful anyways,
> checkpointing is mainly for counting.
> - On a PMI always set back checkpointed counters to zero.
>
> v2: Add unlikely. Add comment
> v3: Allow large sampling periods with CP for KVM
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |   34 ++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index bc21bce..9b4dda5 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1079,6 +1079,17 @@ static void intel_pmu_enable_event(struct perf_event *event)
>  int intel_pmu_save_and_restart(struct perf_event *event)
>  {
>         x86_perf_event_update(event);
> +       /*
> +        * For a checkpointed counter always reset back to 0.  This
> +        * avoids a situation where the counter overflows, aborts the
> +        * transaction and is then set back to shortly before the
> +        * overflow, and overflows and aborts again.
> +        */
> +       if (unlikely(event->hw.config & HSW_INTX_CHECKPOINTED)) {
> +               /* No race with NMIs because the counter should not be armed */
> +               wrmsrl(event->hw.event_base, 0);
> +               local64_set(&event->hw.prev_count, 0);
> +       }
>         return x86_perf_event_set_period(event);
>  }
>
> @@ -1162,6 +1173,15 @@ again:
>                 x86_pmu.drain_pebs(regs);
>         }
>
> +       /*
> +        * To avoid spurious interrupts with perf stat always reset checkpointed
> +        * counters.
> +        *
> +        * XXX move somewhere else.
> +        */
> +       if (cpuc->events[2] && (cpuc->events[2]->hw.config & HSW_INTX_CHECKPOINTED))
> +               status |= (1ULL << 2);
> +
I don't buy really this workaround. You are assuming you're always
measuring INTC_CHECKPOINTED
event by itself. So what if you get into the handler because of an PMI
due to an overflow
of another counter which is active at the same time as counter2?
You're going to artificially
add an overflow to counter2. Unless you're enforcing only counter2 in use.

I understand what you are trying to do, but looks to me something is
missing in HW.
The counter is reinstated to its state before the critical section but
the PMI cannot be
cancelled and there is no state left behind to tell what to do with it.

Also I think the code would gain in readability if you were to define
a inline function:

static inline bool is_event_intx_cp(struct perf_event *event)
{
   return event && (event->hw.config & HSW_INTX_CHECKPOINTED);
}


>         for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
>                 struct perf_event *event = cpuc->events[bit];
>
> @@ -1615,6 +1635,20 @@ static int hsw_hw_config(struct perf_event *event)
>              ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) ||
>               event->attr.precise_ip > 0))
>                 return -EIO;
> +       if (event->hw.config & HSW_INTX_CHECKPOINTED) {
> +               /*
> +                * Sampling of checkpointed events can cause situations where
> +                * the CPU constantly aborts because of a overflow, which is
> +                * then checkpointed back and ignored. Forbid checkpointing
> +                * for sampling.
> +                *
> +                * But still allow a long sampling period, so that perf stat
> +                * from KVM works.
> +                */

What has perf stat have to do with sample_period?

> +               if (event->attr.sample_period > 0 &&
> +                   event->attr.sample_period < 0x7fffffff)
> +                       return -EIO;
> +       }
same comment about -EIO vs. EOPNOTSUPP. sample_period is u64
so, it's always >= 0. Where does this 31-bit limit come from? Experimentation?
Could be written:
      if (event->attr.sample_period && event->attr.sample_period < 0x7fffffff)
