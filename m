Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaGARES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:04:18 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61334 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278AbaGAREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:04:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140627153744.GB19781@tassilo.jf.intel.com>
References: <1403876883-3059-1-git-send-email-eranian@google.com>
	<1403876883-3059-2-git-send-email-eranian@google.com>
	<20140627153744.GB19781@tassilo.jf.intel.com>
Date: Tue, 1 Jul 2014 19:04:16 +0200
Message-ID: <CABPqkBSYwTFDzWkNO13TyoozW6vWw-ukp9uLdRzrK0Prn44F3w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] perf/x86: simplify PEBS constraints
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 5:37 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> On Fri, Jun 27, 2014 at 03:48:02PM +0200, Stephane Eranian wrote:
> > This patches simplifies the management of PEBS constraints
> > for Intel processors.
>
> I implemented this slightly differently, also fixing some
> more issues on the way and checking the flags properly.
> Not yet fully tested.
>
> ---
>
> From a2db81ed6036b6bde04f82ff710aed03f4d5bf39 Mon Sep 17 00:00:00 2001
> From: Andi Kleen <ak@linux.intel.com>
> Date: Thu, 26 Jun 2014 17:21:33 -0700
> Subject: [PATCH] perf, x86: Revamp PEBS event selection
>
> As already discussed earlier in email.
>
> The basic idea is that it does not make sense to list all PEBS
> events individually. The list is very long, sometimes outdated
> and the hardware doesn't need it. If an event does not support
> PEBS it will just not count, there is no security issue.
>
> This vastly simplifies the PEBS event selection.
>
> Bugs fixed:
> - We do not allow setting forbidden flags with PEBS anymore
> (SDM 18.9.4), except for the special cycle event.
> This is done using a new constraint macro that also
> matches on the event flags.


I like the fact that you handle the event flags. Indeed, PEBS does not
work with filters.

>
> - We now allow DataLA on all Haswell events, not just
> a small subset. In general all PEBS events that tag memory
> accesses support DataLA on Haswell. Otherwise the reported
> address is just zero. This allows address profiling
> on vastly more events.
> - We did not allow all PEBS events on Haswell.
>
> This includes the changes proposed by Stephane earlier and obsoletes
> his patchkit.
>
It is missing NHM, WSM, Atom, mine did cover that.

>
> I only did Sandy Bridge and Silvermont and later so far, mostly because these
> are the parts I could directly confirm the hardware behavior with hardware
> architects.
>
The patch does not work as expected, unfortunately. See below.

>
> Cc: eranian@google.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 8249df4..8dfc9fd 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -51,6 +51,14 @@
>          ARCH_PERFMON_EVENTSEL_EDGE  |  \
>          ARCH_PERFMON_EVENTSEL_INV   |  \
>          ARCH_PERFMON_EVENTSEL_CMASK)
> +#define X86_ALL_EVENT_FLAGS                    \
> +       (ARCH_PERFMON_EVENTSEL_EDGE |           \
> +        ARCH_PERFMON_EVENTSEL_INV |            \
> +        ARCH_PERFMON_EVENTSEL_CMASK |          \
> +        ARCH_PERFMON_EVENTSEL_ANY |            \
> +        ARCH_PERFMON_EVENTSEL_PIN_CONTROL |    \
> +        HSW_IN_TX |                            \
> +        HSW_IN_TX_CHECKPOINTED)
>  #define AMD64_RAW_EVENT_MASK           \
>         (X86_RAW_EVENT_MASK          |  \
>          AMD64_EVENTSEL_EVENT)
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 3b2f9bd..37b2841 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -252,17 +252,20 @@ struct cpu_hw_events {
>         EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
>
>  #define INTEL_PLD_CONSTRAINT(c, n)     \
> -       __EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
> +       __EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
>                            HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
>
>  #define INTEL_PST_CONSTRAINT(c, n)     \
> -       __EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
> +       __EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
>                           HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
>
> -/* DataLA version of store sampling without extra enable bit. */
> -#define INTEL_PST_HSW_CONSTRAINT(c, n) \
> -       __EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
> -                         HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
> +/* Event constraint, but match on all event flags too. */
> +#define INTEL_FLAGS_EVENT_CONSTRAINT(c, n) \
> +       EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS)
> +
> +#define INTEL_FLAGS_EVENT_CONSTRAINT_DATALA(c, n) \
> +       __EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
> +                         HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
>
>  /*
>   * We define the end marker as having a weight of -1
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 980970c..053e7f2 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -567,28 +567,10 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
>  };
>
>  struct event_constraint intel_slm_pebs_event_constraints[] = {
> -       INTEL_UEVENT_CONSTRAINT(0x0103, 0x1), /* REHABQ.LD_BLOCK_ST_FORWARD_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x0803, 0x1), /* REHABQ.LD_SPLITS_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x0204, 0x1), /* MEM_UOPS_RETIRED.L2_HIT_LOADS_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x0404, 0x1), /* MEM_UOPS_RETIRED.L2_MISS_LOADS_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x0804, 0x1), /* MEM_UOPS_RETIRED.DTLB_MISS_LOADS_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x2004, 0x1), /* MEM_UOPS_RETIRED.HITM_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x00c4, 0x1), /* BR_INST_RETIRED.ALL_BRANCHES_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x7ec4, 0x1), /* BR_INST_RETIRED.JCC_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xbfc4, 0x1), /* BR_INST_RETIRED.FAR_BRANCH_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xebc4, 0x1), /* BR_INST_RETIRED.NON_RETURN_IND_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xf7c4, 0x1), /* BR_INST_RETIRED.RETURN_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xf9c4, 0x1), /* BR_INST_RETIRED.CALL_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xfbc4, 0x1), /* BR_INST_RETIRED.IND_CALL_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xfdc4, 0x1), /* BR_INST_RETIRED.REL_CALL_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xfec4, 0x1), /* BR_INST_RETIRED.TAKEN_JCC_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_MISP_RETIRED.ALL_BRANCHES_PS */
> -       INTEL_UEVENT_CONSTRAINT(0x7ec5, 0x1), /* BR_INST_MISP_RETIRED.JCC_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xebc5, 0x1), /* BR_INST_MISP_RETIRED.NON_RETURN_IND_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xf7c5, 0x1), /* BR_INST_MISP_RETIRED.RETURN_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xfbc5, 0x1), /* BR_INST_MISP_RETIRED.IND_CALL_PS */
> -       INTEL_UEVENT_CONSTRAINT(0xfec5, 0x1), /* BR_INST_MISP_RETIRED.TAKEN_JCC_PS */
> +       /* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
> +       /* Allow all events as PEBS with no flags */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(0xffff, 0x1),


This macro and EVENT_CONSTRAINT() as you have them will never any
event (even those with the
filters cleared). The similar macro was also wrong in Peter's patch. I
fixed that in mine. But now, you
also want to reject any event with filters. That cannot work as is.
The reason is that the matching
statement is:

              if ((attr->config & c->mask) == c->code)

You have a c->code = 0xffff. That does not match any event.
You need to the the mask to ~INTEL_ARCH_EVENT_MASK & X86_ALL_EVENT_FLAGS.
And c->code = 0x0, then I think it should work.
So I believe the correct code should be:

INTEL_FLAGS_EVENT_ALL_CONSTRAINT(0x0, 0x1),
With that new macro:
+/* Event constraint, but match on all event flags too. */
+#define INTEL_FLAGS_EVENT_ALL_CONSTRAINT(c, n) \
+       EVENT_CONSTRAINT(c, n, (~INTEL_ARCH_EVENT_MASK & X86_ALL_EVENT_FLAGS))

I checked that and it works with random event codes now!


>
> @@ -624,68 +606,34 @@ struct event_constraint intel_westmere_pebs_event_constraints[] = {
>
>  struct event_constraint intel_snb_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
> -       INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
> -       INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
> -       INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
> -       INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
> -       INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
> -       INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
> -       INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
> +       INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
> +       INTEL_PST_CONSTRAINT(0x02cd, 0xf),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
> +       /* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
> +       /* Allow all events as PEBS with no flags */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(0xffff, 0xf),
>         EVENT_CONSTRAINT_END
>  };
>
>  struct event_constraint intel_ivb_pebs_event_constraints[] = {
>          INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
> -        INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
> -        INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
> -        INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
> -        INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
> -        INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
> -       INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
> -        INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
> -        INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
> -        INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> -        INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
> +        INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
> +       INTEL_PST_CONSTRAINT(0x02cd, 0xf),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
> +       /* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
> +       /* Allow all events as PEBS with no flags */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(0xffff, 0xf),
>          EVENT_CONSTRAINT_END
>  };
>
>  struct event_constraint intel_hsw_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
> -       INTEL_PST_HSW_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
> -       INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
> -       INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
> -       INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
> -       INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
> -       INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
> -       INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.* */
> -       /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
> -       INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf),
> -       /* MEM_UOPS_RETIRED.STLB_MISS_STORES */
> -       INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf),
> -       INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
> -       INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
> -       /* MEM_UOPS_RETIRED.SPLIT_STORES */
> -       INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf),
> -       INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
> -       INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
> -       INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
> -       INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
> -       INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
> -       /* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
> -       INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf),
> -       /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
> -       INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf),
> -       /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
> -       INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf),
> -       /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
> -       INTEL_UEVENT_CONSTRAINT(0x01d3, 0xf),
> -       INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
> -       INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */
> -
> +       INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.* */
> +       /* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
> +       /* Allow all events as PEBS with no flags */
> +       /* We allow DATALA for all PEBS events, will be 0 if not supported */
> +       INTEL_FLAGS_EVENT_CONSTRAINT_DATALA(0xffff, 0xf),
>         EVENT_CONSTRAINT_END
>  };
>
>
>
