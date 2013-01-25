Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab3AYLPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:15:44 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:36513 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab3AYLPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:15:39 -0500
MIME-Version: 1.0
In-Reply-To: <1357847443-3878-5-git-send-email-jacob.shin@amd.com>
References: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
	<1357847443-3878-5-git-send-email-jacob.shin@amd.com>
Date: Fri, 25 Jan 2013 12:15:37 +0100
Message-ID: <CABPqkBR7KwJhPg2XJfO5d14Q4KiK7v0eqO_uyr_b6W3_nf-o-w@mail.gmail.com>
Subject: Re: [PATCH RESEND V5 4/6] perf, x86: Move MSR address offset
 calculation to architecture specific files
From: Stephane Eranian <eranian@google.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 8:50 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> Move counter index to MSR address offset calculation to architecture
> specific files. This prepares the way for perf_event_amd to enable
> counter addresses that are not contiguous -- for example AMD Family
> 15h processors have 6 core performance counters starting at 0xc0010200
> and 4 northbridge performance counters starting at 0xc0010240.
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event.h     |   21 ++++-------------
>  arch/x86/kernel/cpu/perf_event_amd.c |   42 ++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 115c1ea..4440218 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -325,6 +325,7 @@ struct x86_pmu {
>         int             (*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
>         unsigned        eventsel;
>         unsigned        perfctr;
> +       int             (*addr_offset)(int index, int eventsel);
>         u64             (*event_map)(int);
>         int             max_events;
>         int             num_counters;
> @@ -446,28 +447,16 @@ extern u64 __read_mostly hw_cache_extra_regs
>
>  u64 x86_perf_event_update(struct perf_event *event);
>
> -static inline int x86_pmu_addr_offset(int index)
> -{
> -       int offset;
> -
> -       /* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
> -       alternative_io(ASM_NOP2,
> -                      "shll $1, %%eax",
> -                      X86_FEATURE_PERFCTR_CORE,
> -                      "=a" (offset),
> -                      "a"  (index));
> -
> -       return offset;
> -}
> -
>  static inline unsigned int x86_pmu_config_addr(int index)
>  {
> -       return x86_pmu.eventsel + x86_pmu_addr_offset(index);
> +       return x86_pmu.eventsel +
> +               (x86_pmu.addr_offset ? x86_pmu.addr_offset(index, 1) : index);
>  }
>
>  static inline unsigned int x86_pmu_event_addr(int index)
>  {
> -       return x86_pmu.perfctr + x86_pmu_addr_offset(index);
> +       return x86_pmu.perfctr +
> +               (x86_pmu.addr_offset ? x86_pmu.addr_offset(index, 0) : index);
>  }
Would be better to use a constant name instead of 1 and 0 to name a event_sel
vs. a counter. It would help the reader understand what this is about
as that may
be useful for other processors as well.

>  int x86_setup_perfctr(struct perf_event *event);
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index 0c2cc51..ef1df38 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -132,6 +132,47 @@ static u64 amd_pmu_event_map(int hw_event)
>         return amd_perfmon_event_map[hw_event];
>  }
>
> +/*
> + * Previously calculated offsets
> + */
> +static unsigned int event_offsets[X86_PMC_IDX_MAX] __read_mostly;
> +static unsigned int count_offsets[X86_PMC_IDX_MAX] __read_mostly;
> +
> +/*
> + * Legacy CPUs:
> + *   4 counters starting at 0xc0010000 each offset by 1
> + *
> + * CPUs with core performance counter extensions:
> + *   6 counters starting at 0xc0010200 each offset by 2
> + */
> +static inline int amd_pmu_addr_offset(int index, int eventsel)
> +{
> +       int offset;
> +
> +       if (!index)
> +               return index;
> +
> +       if (eventsel)
> +               offset = event_offsets[index];
> +       else
> +               offset = count_offsets[index];
> +
> +       if (offset)
> +               return offset;
> +
> +       if (!cpu_has_perfctr_core)
> +               offset = index;
> +       else
> +               offset = index << 1;
> +
> +       if (eventsel)
> +               event_offsets[index] = offset;
> +       else
> +               count_offsets[index] = offset;
> +
> +       return offset;
> +}
> +
>  static int amd_pmu_hw_config(struct perf_event *event)
>  {
>         int ret;
> @@ -578,6 +619,7 @@ static __initconst const struct x86_pmu amd_pmu = {
>         .schedule_events        = x86_schedule_events,
>         .eventsel               = MSR_K7_EVNTSEL0,
>         .perfctr                = MSR_K7_PERFCTR0,
> +       .addr_offset            = amd_pmu_addr_offset,
>         .event_map              = amd_pmu_event_map,
>         .max_events             = ARRAY_SIZE(amd_perfmon_event_map),
>         .num_counters           = AMD64_NUM_COUNTERS,
> --
> 1.7.9.5
>
>
