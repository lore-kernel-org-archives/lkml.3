Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab3GRMSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:18:16 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40552 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab3GRMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:18:13 -0400
MIME-Version: 1.0
In-Reply-To: <1374138144-17278-2-git-send-email-zheng.z.yan@intel.com>
References: <1374138144-17278-1-git-send-email-zheng.z.yan@intel.com>
	<1374138144-17278-2-git-send-email-zheng.z.yan@intel.com>
Date: Thu, 18 Jul 2013 14:18:12 +0200
Message-ID: <CABPqkBQkfcNq_BSn3BEgriiHSxhtS-=zjhD1sS=kPZA2nCiGrA@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86: Add Silvermont (22nm Atom) support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 11:02 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> Compare to old atom, Silvermont has offcore and has more events
> that support PEBS.
>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.h          |   2 +
>  arch/x86/kernel/cpu/perf_event_intel.c    | 158 ++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |  26 +++++
>  3 files changed, 186 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 97e557b..cc16faa 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -641,6 +641,8 @@ extern struct event_constraint intel_core2_pebs_event_constraints[];
>
>  extern struct event_constraint intel_atom_pebs_event_constraints[];
>
> +extern struct event_constraint intel_slm_pebs_event_constraints[];
> +
>  extern struct event_constraint intel_nehalem_pebs_event_constraints[];
>
>  extern struct event_constraint intel_westmere_pebs_event_constraints[];
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index d312edf..e4bb30a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -164,6 +164,15 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
>         EVENT_CONSTRAINT_END
>  };
>
> +static struct event_constraint intel_slm_event_constraints[] __read_mostly =
> +{
> +       FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> +       FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
> +       FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
> +       FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
> +       EVENT_CONSTRAINT_END
> +};
> +
>  static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
>         /* must define OFFCORE_RSP_X first, see intel_fixup_er() */
>         INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
> @@ -886,6 +895,140 @@ static __initconst const u64 atom_hw_cache_event_ids
>   },
>  };
>
> +static struct extra_reg intel_slm_extra_regs[] __read_mostly =
> +{
> +       /* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +       INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x768005ffff, RSP_0),
> +       INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0x768005ffff, RSP_1),
> +       EVENT_EXTRA_END
> +};
> +
> +#define SLM_DMND_READ          SNB_DMND_DATA_RD
> +#define SLM_DMND_WRITE         SNB_DMND_RFO
> +#define SLM_DMND_PREFETCH      (SNB_PF_DATA_RD|SNB_PF_RFO)
> +
> +#define SLM_SNP_ANY            (SNB_SNP_NONE|SNB_SNP_MISS|SNB_NO_FWD|SNB_HITM)
> +#define SLM_LLC_ACCESS         SNB_RESP_ANY
> +#define SLM_LLC_MISS           (SLM_SNP_ANY|SNB_NON_DRAM)
> +
> +static __initconst const u64 slm_hw_cache_extra_regs
> +                               [PERF_COUNT_HW_CACHE_MAX]
> +                               [PERF_COUNT_HW_CACHE_OP_MAX]
> +                               [PERF_COUNT_HW_CACHE_RESULT_MAX] =
> +{
> + [ C(LL  ) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = SLM_DMND_READ|SLM_LLC_ACCESS,
> +               [ C(RESULT_MISS)   ] = SLM_DMND_READ|SLM_LLC_MISS,
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = SLM_DMND_WRITE|SLM_LLC_ACCESS,
> +               [ C(RESULT_MISS)   ] = SLM_DMND_WRITE|SLM_LLC_MISS,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = SLM_DMND_PREFETCH|SLM_LLC_ACCESS,
> +               [ C(RESULT_MISS)   ] = SLM_DMND_PREFETCH|SLM_LLC_MISS,
> +       },
> + },
> +};
> +
> +static __initconst const u64 slm_hw_cache_event_ids
> +                               [PERF_COUNT_HW_CACHE_MAX]
> +                               [PERF_COUNT_HW_CACHE_OP_MAX]
> +                               [PERF_COUNT_HW_CACHE_RESULT_MAX] =
> +{
> + [ C(L1D) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0,
> +               [ C(RESULT_MISS)   ] = 0x0104, /* LD_DCU_MISS */
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = 0,
> +               [ C(RESULT_MISS)   ] = 0,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = 0,
> +               [ C(RESULT_MISS)   ] = 0,
> +       },
> + },
> + [ C(L1I ) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x0380, /* ICACHE.ACCESSES */
> +               [ C(RESULT_MISS)   ] = 0x0280, /* ICACGE.MISSES */
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = 0,
> +               [ C(RESULT_MISS)   ] = 0,
> +       },
> + },
> + [ C(LL  ) ] = {
> +       [ C(OP_READ) ] = {
> +               /* OFFCORE_RESPONSE.ANY_DATA.LOCAL_CACHE */
> +               [ C(RESULT_ACCESS) ] = 0x01b7,
> +               /* OFFCORE_RESPONSE.ANY_DATA.ANY_LLC_MISS */
> +               [ C(RESULT_MISS)   ] = 0x01b7,
> +       },
> +       [ C(OP_WRITE) ] = {
> +               /* OFFCORE_RESPONSE.ANY_RFO.LOCAL_CACHE */
> +               [ C(RESULT_ACCESS) ] = 0x01b7,
> +               /* OFFCORE_RESPONSE.ANY_RFO.ANY_LLC_MISS */
> +               [ C(RESULT_MISS)   ] = 0x01b7,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               /* OFFCORE_RESPONSE.PREFETCH.LOCAL_CACHE */
> +               [ C(RESULT_ACCESS) ] = 0x01b7,
> +               /* OFFCORE_RESPONSE.PREFETCH.ANY_LLC_MISS */
> +               [ C(RESULT_MISS)   ] = 0x01b7,
> +       },
> + },
> + [ C(DTLB) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0,
> +               [ C(RESULT_MISS)   ] = 0x0804, /* LD_DTLB_MISS */
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = 0,
> +               [ C(RESULT_MISS)   ] = 0,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = 0,
> +               [ C(RESULT_MISS)   ] = 0,
> +       },
> + },
> + [ C(ITLB) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x00c0, /* INST_RETIRED.ANY_P */
> +               [ C(RESULT_MISS)   ] = 0x0282, /* ITLB.MISSES */
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> + },
> + [ C(BPU ) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ANY */
> +               [ C(RESULT_MISS)   ] = 0x00c5, /* BP_INST_RETIRED.MISPRED */
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> + },
> +};
> +
>  static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
>  {
>         /* user explicitly requested branch sampling */
> @@ -2180,6 +2323,21 @@ __init int intel_pmu_init(void)
>                 pr_cont("Atom events, ");
>                 break;
>
> +       case 55: /* Atom 22nm "Silvermont" */
> +               memcpy(hw_cache_event_ids, slm_hw_cache_event_ids,
> +                       sizeof(hw_cache_event_ids));
> +               memcpy(hw_cache_extra_regs, slm_hw_cache_extra_regs,
> +                      sizeof(hw_cache_extra_regs));
> +
> +               intel_pmu_lbr_init_atom();
> +
> +               x86_pmu.event_constraints = intel_slm_event_constraints;
> +               x86_pmu.pebs_constraints = intel_slm_pebs_event_constraints;
> +               x86_pmu.extra_regs = intel_slm_extra_regs;
> +               x86_pmu.er_flags |= ERF_HAS_RSP_1;
> +               pr_cont("Silvermont events, ");
> +               break;
> +
>         case 37: /* 32 nm nehalem, "Clarkdale" */
>         case 44: /* 32 nm nehalem, "Gulftown" */
>         case 47: /* 32 nm Xeon E7 */
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 3065c57..442fcc2 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -517,6 +517,32 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
>         EVENT_CONSTRAINT_END
>  };
>
> +struct event_constraint intel_slm_pebs_event_constraints[] = {
> +       INTEL_UEVENT_CONSTRAINT(0x0103, 0x1), /* REHABQ.LD_BLOCK_ST_FORWARD_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x0803, 0x1), /* REHABQ.LD_SPLITS_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x0204, 0x1), /* MEM_UOPS_RETIRED.L2_HIT_LOADS_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x0404, 0x1), /* MEM_UOPS_RETIRED.L2_MISS_LOADS_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x0804, 0x1), /* MEM_UOPS_RETIRED.DTLB_MISS_LOADS_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x2004, 0x1), /* MEM_UOPS_RETIRED.HITM_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x00c4, 0x1), /* BR_INST_RETIRED.ALL_BRANCHES_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x7ec4, 0x1), /* BR_INST_RETIRED.JCC_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xbfc4, 0x1), /* BR_INST_RETIRED.FAR_BRANCH_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xebc4, 0x1), /* BR_INST_RETIRED.NON_RETURN_IND_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xf7c4, 0x1), /* BR_INST_RETIRED.RETURN_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xf9c4, 0x1), /* BR_INST_RETIRED.CALL_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xfbc4, 0x1), /* BR_INST_RETIRED.IND_CALL_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xfdc4, 0x1), /* BR_INST_RETIRED.REL_CALL_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xfec4, 0x1), /* BR_INST_RETIRED.TAKEN_JCC_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_MISP_RETIRED.ALL_BRANCHES_PS */
> +       INTEL_UEVENT_CONSTRAINT(0x7ec5, 0x1), /* BR_INST_MISP_RETIRED.JCC_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xebc5, 0x1), /* BR_INST_MISP_RETIRED.NON_RETURN_IND_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xf7c5, 0x1), /* BR_INST_MISP_RETIRED.RETURN_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xfbc5, 0x1), /* BR_INST_MISP_RETIRED.IND_CALL_PS */
> +       INTEL_UEVENT_CONSTRAINT(0xfec5, 0x1), /* BR_INST_MISP_RETIRED.TAKEN_JCC_PS */
> +       EVENT_CONSTRAINT_END
> +};
> +
Drop those _PS (PEBS) suffixes, they are Intel tool specific and are
being deprecated.
That will make the lines shorter too.

>  struct event_constraint intel_nehalem_pebs_event_constraints[] = {
>         INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
>         INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
> --
> 1.8.1.4
>
