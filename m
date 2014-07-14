Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbaGNWKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:10:09 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34995 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbaGNWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:10:05 -0400
MIME-Version: 1.0
In-Reply-To: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
Date: Tue, 15 Jul 2014 00:10:04 +0200
Message-ID: <CABPqkBTBa4jui0r562_MOXdoZNABMJ1jk3oZKHMkHrKuOR--XA@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf, x86: Revamp PEBS event selection
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 2:01 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> The basic idea is that it does not make sense to list all PEBS
> events individually. The list is very long, sometimes outdated
> and the hardware doesn't need it. If an event does not support
> PEBS it will just not count, there is no security issue.
>
> This vastly simplifies the PEBS event selection. It also
> speeds up the scheduling because the scheduler doesn't
> have to walk as many constraints.
>
> Bugs fixed:
> - We do not allow setting forbidden flags with PEBS anymore
> (SDM 18.9.4), except for the special cycle event.
> This is done using a new constraint macro that also
> matches on the event flags.
> - We now allow DataLA on all Haswell events, not just
> a small subset. In general all PEBS events that tag memory
> accesses support DataLA on Haswell. Otherwise the reported
> address is just zero. This allows address profiling
> on vastly more events.
> - We did not allow all PEBS events on Haswell:
> We were missing some valid subevents in d1-d2 (MEM_LOAD_UOPS_RETIRED.*,
> MEM_LOAD_UOPS_RETIRED_L3_HIT_RETIRED.*)
>
> This includes the changes proposed by Stephane earlier and obsoletes
> his patchkit (except for some changes on pre Sandy Bridge/Silvermont
> CPUs)
>
> I only did Sandy Bridge and Silvermont and later so far, mostly because these
> are the parts I could directly confirm the hardware behavior with hardware
> architects. Also I do not believe the older CPUs have any
> missing events in their PEBS list, so there's no pressing
> need to change them.
>
> I did not implement the flag proposed by Peter to allow
> setting forbidden flags. If really needed this could
> be implemented on to of this patch.
>
> Cc: eranian@google.com
> v2: Fix broken store events on SNB/IVB (Stephane Eranian)
> v3: More fixes. Rename some arguments (Stephane Eranian)
> Update description.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Works now for me on SNB/HSW.

Reviewed-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/include/asm/perf_event.h         |  8 +++
>  arch/x86/kernel/cpu/perf_event.h          | 18 +++++--
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 88 +++++++------------------------
>  3 files changed, 39 insertions(+), 75 deletions(-)
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
> index a22a34e9..8f32af0 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -262,16 +262,24 @@ struct cpu_hw_events {
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
> +/* Event constraint, but match on all event flags too. */
> +#define INTEL_FLAGS_EVENT_CONSTRAINT(c, n) \
> +       EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS)
> +
> +/* Check only flags, but allow all event/umask */
> +#define INTEL_ALL_EVENT_CONSTRAINT(code, n)    \
> +       EVENT_CONSTRAINT(code, n, X86_ALL_EVENT_FLAGS)
> +
> +/* Same as above, but enable DataLA */
> +#define INTEL_ALL_EVENT_CONSTRAINT_DATALA(code, n) \
> +       __EVENT_CONSTRAINT(code, n, X86_ALL_EVENT_FLAGS, \
>                           HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
>
>  /*
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 980970c..64b4be9 100644
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
> +       INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
>         EVENT_CONSTRAINT_END
>  };
>
> @@ -624,68 +606,34 @@ struct event_constraint intel_westmere_pebs_event_constraints[] = {
>
>  struct event_constraint intel_snb_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
> -       INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
> -       INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
> -       INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
>         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
>         INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
> -       INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> -       INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
> -       INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
> +       /* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
> +       /* Allow all events as PEBS with no flags */
> +       INTEL_ALL_EVENT_CONSTRAINT(0, 0xf),
>         EVENT_CONSTRAINT_END
>  };
>
>  struct event_constraint intel_ivb_pebs_event_constraints[] = {
>          INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
> -        INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
> -        INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
> -        INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
> -        INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
>          INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
>         INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
> -        INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
> -        INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
> -        INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> -        INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
> +       /* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
> +       INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
> +       /* Allow all events as PEBS with no flags */
> +       INTEL_ALL_EVENT_CONSTRAINT(0, 0xf),
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
> +       INTEL_ALL_EVENT_CONSTRAINT_DATALA(0, 0xf),
>         EVENT_CONSTRAINT_END
>  };
>
> --
> 1.9.3
>
