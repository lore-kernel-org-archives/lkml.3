Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaFWIGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:06:46 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:41038 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaFWIGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:06:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140623071454.GI19860@laptop.programming.kicks-ass.net>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
	<1403193509-22393-2-git-send-email-eranian@google.com>
	<20140619180028.GU8178@tassilo.jf.intel.com>
	<20140623071454.GI19860@laptop.programming.kicks-ass.net>
Date: Mon, 23 Jun 2014 10:06:43 +0200
Message-ID: <CABPqkBTXNuKQKd-jFhAphmKnQ8PTdD7iQ66oYe7Uao_05rP8pw@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 9:14 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jun 19, 2014 at 11:00:28AM -0700, Andi Kleen wrote:
>> However these days I'm actually thinking of just getting
>> rid of the detailed table except for PREC_DIST. All the PEBS
>> controls should be noops if the event does not support PEBS
>
> I had something like the below stuck on the 'look more at later' list
> and later never really ever happened.
>
> ---
>  arch/x86/kernel/cpu/perf_event.c          |  3 +++
>  arch/x86/kernel/cpu/perf_event.h          |  1 +
>  arch/x86/kernel/cpu/perf_event_intel.c    | 19 ++++++++++++++--
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 38 +++++++++++++++++--------------
>  4 files changed, 42 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index ae407f7226c8..f42405c9868b 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1541,6 +1541,7 @@ static int __init init_hw_perf_events(void)
>         pr_cont("%s PMU driver.\n", x86_pmu.name);
>
>         x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
> +       x86_pmu.attr_strict_pebs = 1;
>
>         for (quirk = x86_pmu.quirks; quirk; quirk = quirk->next)
>                 quirk->func();
> @@ -1855,9 +1856,11 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
>  }
>
>  static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
> +static DEVICE_BOOL_ATTR(strict_pebs, S_IRUSR | S_IWUSR, x86_pmu.attr_strict_pebs);
>
>  static struct attribute *x86_pmu_attrs[] = {
>         &dev_attr_rdpmc.attr,
> +       &dev_attr_strict_pebs.attr.attr,
>         NULL,
>  };
>
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 3b2f9bdd974b..a11eeab9b611 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -413,6 +413,7 @@ struct x86_pmu {
>          */
>         int             attr_rdpmc_broken;
>         int             attr_rdpmc;
> +       bool            attr_strict_pebs;
>         struct attribute **format_attrs;
>         struct attribute **event_attrs;
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index aa333d966886..6e68f3dc9a30 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1729,6 +1729,12 @@ static void intel_pebs_aliases_snb(struct perf_event *event)
>         }
>  }
>
> +#define ARCH_PERFMON_STRICT_PEBS       \
> +       (ARCH_PERFMON_EVENTSEL_ANY   |  \
> +        ARCH_PERFMON_EVENTSEL_CMASK |  \
> +        ARCH_PERFMON_EVENTSEL_EDGE  |  \
> +        ARCH_PERFMON_EVENTSEL_INV)
> +
>  static int intel_pmu_hw_config(struct perf_event *event)
>  {
>         int ret = x86_pmu_hw_config(event);
> @@ -1736,8 +1742,17 @@ static int intel_pmu_hw_config(struct perf_event *event)
>         if (ret)
>                 return ret;
>
> -       if (event->attr.precise_ip && x86_pmu.pebs_aliases)
> -               x86_pmu.pebs_aliases(event);
> +       if (event->attr.precise_ip) {
> +               if ((event->attr.config & INTEL_ARCH_EVENT_MASK) == 0x0000)
> +                       return -EINVAL;
> +
> +               if ((event->attr.config & ARCH_PERFMON_STRICT_PEBS) &&
> +                   (x86_pmu.attr_strict_pebs || !capable(CAP_SYS_ADMIN)))
> +                       return -EINVAL;
> +
I don't think filters work with any PEBS events. The event captured
does not qualify
for any of the filters (root or non-root).

> +               if (x86_pmu.pebs_aliases)
> +                       x86_pmu.pebs_aliases(event);
> +       }
>
>         if (intel_pmu_needs_lbr_smpl(event)) {
>                 ret = intel_pmu_setup_lbr_filter(event);
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index ae96cfa5eddd..36b1f2afa61c 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -540,6 +540,7 @@ struct event_constraint intel_core2_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
>         INTEL_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
>         INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
> +       INTEL_UEVENT_CONSTRAINT(0x0000, 0x1), /* generic PEBS mask */
>         EVENT_CONSTRAINT_END
>  };
>
You probably need  to explain that 0x0000 MUST be the last event in
each table, i.e., catch all
event.

> @@ -547,6 +548,7 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
>         INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
>         INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
> +       INTEL_UEVENT_CONSTRAINT(0x0000, 0x1), /* generic PEBS mask */
>         EVENT_CONSTRAINT_END
>  };
>
> @@ -573,6 +575,7 @@ struct event_constraint intel_slm_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0xf7c5, 0x1), /* BR_INST_MISP_RETIRED.RETURN_PS */
>         INTEL_UEVENT_CONSTRAINT(0xfbc5, 0x1), /* BR_INST_MISP_RETIRED.IND_CALL_PS */
>         INTEL_UEVENT_CONSTRAINT(0xfec5, 0x1), /* BR_INST_MISP_RETIRED.TAKEN_JCC_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x0000, 0x1), /* generic PEBS mask */
>         EVENT_CONSTRAINT_END
>  };
>
> @@ -588,6 +591,7 @@ struct event_constraint intel_nehalem_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
>         INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
>         INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
> +       INTEL_UEVENT_CONSTRAINT(0x0000, 0xf), /* generic PEBS mask */
>         EVENT_CONSTRAINT_END
>  };
>
> @@ -603,6 +607,7 @@ struct event_constraint intel_westmere_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
>         INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
>         INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
> +       INTEL_UEVENT_CONSTRAINT(0x0000, 0xf), /* generic PEBS mask */
>         EVENT_CONSTRAINT_END
>  };
>
> @@ -619,6 +624,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
>         INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
>         INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
>         INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
> +       INTEL_UEVENT_CONSTRAINT(0x0000, 0xf), /* generic PEBS mask */
>         EVENT_CONSTRAINT_END
>  };
>
> @@ -634,42 +640,36 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
>          INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
>          INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
>          INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
> +       INTEL_UEVENT_CONSTRAINT(0x0000, 0xf), /* generic PEBS mask */
>          EVENT_CONSTRAINT_END
>  };
>
>  struct event_constraint intel_hsw_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
> -       INTEL_PST_HSW_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
> +       INTEL_PST_HSW_CONSTRAINT(0x01c2, 0xf),/* UOPS_RETIRED.ALL */
>         INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
>         INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
>         INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
>         INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
>         INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
>         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.* */
> -       /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
> -       INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf),
> -       /* MEM_UOPS_RETIRED.STLB_MISS_STORES */
> -       INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf),
> +       INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
> +       INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_STORES */
>         INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
>         INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
> -       /* MEM_UOPS_RETIRED.SPLIT_STORES */
> -       INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf),
> +       INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_STORES */
>         INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
> -       INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
> +       INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf),/* MEM_UOPS_RETIRED.ALL_STORES */
>         INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
>         INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
>         INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
> -       /* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
> -       INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf),
> -       /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
> -       INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf),
> -       /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
> -       INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf),
> -       /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
> -       INTEL_UEVENT_CONSTRAINT(0x01d3, 0xf),
> +       INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
> +       INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
> +       INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
> +       INTEL_UEVENT_CONSTRAINT(0x01d3, 0xf), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
>         INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
>         INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */
> -
> +       INTEL_UEVENT_CONSTRAINT(0x0000, 0xf), /* generic PEBS mask */
>         EVENT_CONSTRAINT_END
>  };
>
> @@ -686,6 +686,10 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
>                                 event->hw.flags |= c->flags;
>                                 return c;
>                         }
> +                       if (!x86_pmu.attr_strict_pebs &&
> +                           capable(CAP_SYS_ADMIN) &&
> +                           !c->code)
> +                               return c;
>                 }
>         }
>
