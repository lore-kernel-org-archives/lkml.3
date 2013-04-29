Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab3D2WQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:16:26 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:49015 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089Ab3D2WQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <1366844694-2770-2-git-send-email-andi@firstfloor.org>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
	<1366844694-2770-2-git-send-email-andi@firstfloor.org>
Date: Tue, 30 Apr 2013 00:16:23 +0200
Message-ID: <CABPqkBQSXWTd=ut+U-Mc8fEm+FaV7XAsWydTxQ7e+jSynpKU7w@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't allow unusual PEBS raw flags
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 1:04 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> The PEBS documentation in the Intel SDM 18.6.1.1 states:
>
> """
> PEBS events are only valid when the following fields of IA32_PERFEVTSELx are all
> zero: AnyThread, Edge, Invert, CMask.
> """
>
> Since we had problems with this earlier, don't allow cmask, any, edge, invert
> as raw events, except for the ones explicitly listed as pebs_aliases.
>
Yes, this is indeed needed. Those filters are otherwise ignored. So you are
not measuring what you think you are.

Could you explain why those listed in the aliases avoid that problem?

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.h       |    2 +-
>  arch/x86/kernel/cpu/perf_event_intel.c |   24 ++++++++++++++++++++----
>  2 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 7f5c75c..e46f932 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -386,7 +386,7 @@ struct x86_pmu {
>         int             pebs_record_size;
>         void            (*drain_pebs)(struct pt_regs *regs);
>         struct event_constraint *pebs_constraints;
> -       void            (*pebs_aliases)(struct perf_event *event);
> +       bool            (*pebs_aliases)(struct perf_event *event);
>         int             max_pebs_events;
>
>         /*
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index cc45deb..126c971 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1447,7 +1447,7 @@ static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
>         intel_put_shared_regs_event_constraints(cpuc, event);
>  }
>
> -static void intel_pebs_aliases_core2(struct perf_event *event)
> +static bool intel_pebs_aliases_core2(struct perf_event *event)
>  {
>         if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
>                 /*
> @@ -1472,10 +1472,12 @@ static void intel_pebs_aliases_core2(struct perf_event *event)
>
>                 alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
>                 event->hw.config = alt_config;
> +               return true;
>         }
> +       return false;
>  }
>
> -static void intel_pebs_aliases_snb(struct perf_event *event)
> +static bool intel_pebs_aliases_snb(struct perf_event *event)
>  {
>         if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
>                 /*
> @@ -1500,7 +1502,9 @@ static void intel_pebs_aliases_snb(struct perf_event *event)
>
>                 alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
>                 event->hw.config = alt_config;
> +               return true;
>         }
> +       return false;
>  }
>
>  static int intel_pmu_hw_config(struct perf_event *event)
> @@ -1510,8 +1514,20 @@ static int intel_pmu_hw_config(struct perf_event *event)
>         if (ret)
>                 return ret;
>
> -       if (event->attr.precise_ip && x86_pmu.pebs_aliases)
> -               x86_pmu.pebs_aliases(event);
> +       if (event->attr.precise_ip) {
> +               /*
> +                * Don't allow unusal flags with PEBS, as that
> +                * may confuse the CPU.
> +                *
> +                * The only exception are explicitely listed pebs_aliases
> +                */
> +               if ((!x86_pmu.pebs_aliases || !x86_pmu.pebs_aliases(event)) &&
> +                   (event->attr.config & (ARCH_PERFMON_EVENTSEL_CMASK|
> +                                          ARCH_PERFMON_EVENTSEL_EDGE|
> +                                          ARCH_PERFMON_EVENTSEL_INV|
> +                                          ARCH_PERFMON_EVENTSEL_ANY)))
> +                       return -EIO;
> +       }
>
>         if (intel_pmu_needs_lbr_smpl(event)) {
>                 ret = intel_pmu_setup_lbr_filter(event);
> --
> 1.7.7.6
>
