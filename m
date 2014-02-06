Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaBFBwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:52:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:43866 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbaBFBwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:52:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,790,1384329600"; 
   d="scan'208";a="478815867"
Message-ID: <52F2EADC.7070709@intel.com>
Date: Thu, 06 Feb 2014 09:52:28 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 04/14] perf, x86: Basic Haswell LBR call stack support
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>	<1388728091-18564-5-git-send-email-zheng.z.yan@intel.com> <CABPqkBRCKR8O1WHx3BJEio_POTmaX0M08d0c9v41v_Dj6hbFUA@mail.gmail.com>
In-Reply-To: <CABPqkBRCKR8O1WHx3BJEio_POTmaX0M08d0c9v41v_Dj6hbFUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 11:40 PM, Stephane Eranian wrote:
> On Fri, Jan 3, 2014 at 6:48 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> When the call stack feature is enabled, the LBR stack will capture
>> unfiltered call data normally, but as return instructions are executed,
>> the last captured branch record is flushed from the on-chip registers
>> in a last-in first-out (LIFO) manner. Thus, branch information relative
>> to leaf functions will not be captured, while preserving the call stack
>> information of the main line execution path.
>>
> This is a generic description of the LBR call stack feature. It does not
> describe what the patch actually does which is implement the basic
> internal infrastructure for CALL_STACK mode using LBR callstack.
> 
>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event.h           |  7 ++-
>>  arch/x86/kernel/cpu/perf_event_intel.c     |  2 +-
>>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 98 +++++++++++++++++++++++-------
>>  3 files changed, 82 insertions(+), 25 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
>> index 80b8e83..3ef4b79 100644
>> --- a/arch/x86/kernel/cpu/perf_event.h
>> +++ b/arch/x86/kernel/cpu/perf_event.h
>> @@ -460,7 +460,10 @@ struct x86_pmu {
>>  };
>>
>>  enum {
>> -       PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE = PERF_SAMPLE_BRANCH_MAX_SHIFT,
>> +       PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = PERF_SAMPLE_BRANCH_MAX_SHIFT,
>> +       PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
>> +
>> +       PERF_SAMPLE_BRANCH_CALL_STACK = 1U << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
>>  };
>>
>>  #define x86_add_quirk(func_)                                           \
>> @@ -697,6 +700,8 @@ void intel_pmu_lbr_init_atom(void);
>>
>>  void intel_pmu_lbr_init_snb(void);
>>
>> +void intel_pmu_lbr_init_hsw(void);
>> +
>>  int intel_pmu_setup_lbr_filter(struct perf_event *event);
>>
>>  int p4_pmu_init(void);
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
>> index 4325bae..84a1c09 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>> @@ -2494,7 +2494,7 @@ __init int intel_pmu_init(void)
>>                 memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
>>                 memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
>>
>> -               intel_pmu_lbr_init_snb();
>> +               intel_pmu_lbr_init_hsw();
>>
>>                 x86_pmu.event_constraints = intel_hsw_event_constraints;
>>                 x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> index 7ff2a99..bdd8758 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> @@ -39,6 +39,7 @@ static enum {
>>  #define LBR_IND_JMP_BIT                6 /* do not capture indirect jumps */
>>  #define LBR_REL_JMP_BIT                7 /* do not capture relative jumps */
>>  #define LBR_FAR_BIT            8 /* do not capture far branches */
>> +#define LBR_CALL_STACK_BIT     9 /* enable call stack */
>>
>>  #define LBR_KERNEL     (1 << LBR_KERNEL_BIT)
>>  #define LBR_USER       (1 << LBR_USER_BIT)
>> @@ -49,6 +50,7 @@ static enum {
>>  #define LBR_REL_JMP    (1 << LBR_REL_JMP_BIT)
>>  #define LBR_IND_JMP    (1 << LBR_IND_JMP_BIT)
>>  #define LBR_FAR                (1 << LBR_FAR_BIT)
>> +#define LBR_CALL_STACK (1 << LBR_CALL_STACK_BIT)
>>
>>  #define LBR_PLM (LBR_KERNEL | LBR_USER)
>>
>> @@ -74,24 +76,25 @@ static enum {
>>   * x86control flow changes include branches, interrupts, traps, faults
>>   */
>>  enum {
>> -       X86_BR_NONE     = 0,      /* unknown */
>> -
>> -       X86_BR_USER     = 1 << 0, /* branch target is user */
>> -       X86_BR_KERNEL   = 1 << 1, /* branch target is kernel */
>> -
>> -       X86_BR_CALL     = 1 << 2, /* call */
>> -       X86_BR_RET      = 1 << 3, /* return */
>> -       X86_BR_SYSCALL  = 1 << 4, /* syscall */
>> -       X86_BR_SYSRET   = 1 << 5, /* syscall return */
>> -       X86_BR_INT      = 1 << 6, /* sw interrupt */
>> -       X86_BR_IRET     = 1 << 7, /* return from interrupt */
>> -       X86_BR_JCC      = 1 << 8, /* conditional */
>> -       X86_BR_JMP      = 1 << 9, /* jump */
>> -       X86_BR_IRQ      = 1 << 10,/* hw interrupt or trap or fault */
>> -       X86_BR_IND_CALL = 1 << 11,/* indirect calls */
>> -       X86_BR_ABORT    = 1 << 12,/* transaction abort */
>> -       X86_BR_IN_TX    = 1 << 13,/* in transaction */
>> -       X86_BR_NO_TX    = 1 << 14,/* not in transaction */
>> +       X86_BR_NONE             = 0,      /* unknown */
>> +
>> +       X86_BR_USER             = 1 << 0, /* branch target is user */
>> +       X86_BR_KERNEL           = 1 << 1, /* branch target is kernel */
>> +
>> +       X86_BR_CALL             = 1 << 2, /* call */
>> +       X86_BR_RET              = 1 << 3, /* return */
>> +       X86_BR_SYSCALL          = 1 << 4, /* syscall */
>> +       X86_BR_SYSRET           = 1 << 5, /* syscall return */
>> +       X86_BR_INT              = 1 << 6, /* sw interrupt */
>> +       X86_BR_IRET             = 1 << 7, /* return from interrupt */
>> +       X86_BR_JCC              = 1 << 8, /* conditional */
>> +       X86_BR_JMP              = 1 << 9, /* jump */
>> +       X86_BR_IRQ              = 1 << 10,/* hw interrupt or trap or fault */
>> +       X86_BR_IND_CALL         = 1 << 11,/* indirect calls */
>> +       X86_BR_ABORT            = 1 << 12,/* transaction abort */
>> +       X86_BR_IN_TX            = 1 << 13,/* in transaction */
>> +       X86_BR_NO_TX            = 1 << 14,/* not in transaction */
>> +       X86_BR_CALL_STACK       = 1 << 15,/* call stack */
>>  };
>>
>>  #define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
>> @@ -135,7 +138,14 @@ static void __intel_pmu_lbr_enable(void)
>>                 wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
>>
>>         rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
>> -       debugctl |= (DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
>> +       debugctl |= DEBUGCTLMSR_LBR;
>> +       /*
>> +        * LBR callstack does not work well with FREEZE_LBRS_ON_PMI.
>> +        * If FREEZE_LBRS_ON_PMI is set, PMI near call/return instructions
>> +        * may cause superfluous increase/decrease of LBR_TOS.
>> +        */
> Is that a bug or a feature?

hardware bug of haswell

> 
> That prevent any use of the call-stack mode in the kernel because by the
> time you get to perf_events code, the stack will have been overwritten. you
> can get by if you are only interested in user level execution, the LBR priv
> level filtering will cause a freeze, though with some skid. I assume you are
> limiting this feature to user priv level by enforcing that users pass the
> PERF_SAMPLE_BRANCH_USER flag.

yes, this feature is limited to user priv level

> 
> 
>> +       if (!cpuc->lbr_sel || !(cpuc->lbr_sel->config & LBR_CALL_STACK))
>> +               debugctl |= DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
>>         wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
>>  }
>>
>> @@ -354,7 +364,7 @@ void intel_pmu_lbr_read(void)
>>   * - in case there is no HW filter
>>   * - in case the HW filter has errata or limitations
>>   */
>> -static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
>> +static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
>>  {
>>         u64 br_type = event->attr.branch_sample_type;
>>         int mask = 0;
>> @@ -388,11 +398,21 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
>>         if (br_type & PERF_SAMPLE_BRANCH_NO_TX)
>>                 mask |= X86_BR_NO_TX;
>>
>> +       if (br_type & PERF_SAMPLE_BRANCH_CALL_STACK) {
>> +               if (!x86_pmu.lbr_sel_map)
>> +                       return -EOPNOTSUPP;
> 
> I am not sure checking lbr_sel_map here is enough. You need to
> check if the CALL_STACK entry is populated, meaning the HW feature
> exists.
> 
>> +               if (mask & ~(X86_BR_USER | X86_BR_KERNEL))
>> +                       return -EINVAL;
>> +               mask |= X86_BR_CALL | X86_BR_IND_CALL | X86_BR_RET |
>> +                       X86_BR_CALL_STACK;
> 
> Why have BR_RET here?

the doc says NEAR_REL_CALL, NEAR-IND_CALL and NEAR_RET must be cleared when LBR callstack is enabled.

Regards
Yan, Zheng

> 
>> +       }
>> +
>>         /*
>>          * stash actual user request into reg, it may
>>          * be used by fixup code for some CPU
>>          */
>>         event->hw.branch_reg.reg = mask;
>> +       return 0;
>>  }
>>
>>  /*
>> @@ -421,8 +441,11 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
>>         reg = &event->hw.branch_reg;
>>         reg->idx = EXTRA_REG_LBR;
>>
>> -       /* LBR_SELECT operates in suppress mode so invert mask */
>> -       reg->config = ~mask & x86_pmu.lbr_sel_mask;
>> +       /*
>> +        * the first 8 bits (LBR_SEL_MASK) in LBR_SELECT operates
>> +        * in suppress mode so invert mask
>> +        */
>> +       reg->config = mask ^ x86_pmu.lbr_sel_mask;
>>
>>         return 0;
>>  }
>> @@ -440,7 +463,9 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
>>         /*
>>          * setup SW LBR filter
>>          */
>> -       intel_pmu_setup_sw_lbr_filter(event);
>> +       ret = intel_pmu_setup_sw_lbr_filter(event);
>> +       if (ret)
>> +               return ret;
>>
>>         /*
>>          * setup HW LBR filter, if any
>> @@ -695,6 +720,19 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
>>         [PERF_SAMPLE_BRANCH_IND_CALL_SHIFT]     = LBR_IND_CALL,
>>  };
>>
>> +static const int hsw_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
>> +       [PERF_SAMPLE_BRANCH_ANY_SHIFT]          = LBR_ANY,
>> +       [PERF_SAMPLE_BRANCH_USER_SHIFT]         = LBR_USER,
>> +       [PERF_SAMPLE_BRANCH_KERNEL_SHIFT]       = LBR_KERNEL,
>> +       [PERF_SAMPLE_BRANCH_HV_SHIFT]           = LBR_IGN,
>> +       [PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT]   = LBR_RETURN | LBR_FAR,
>> +       [PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT]     = LBR_REL_CALL | LBR_IND_CALL
>> +                                               | LBR_FAR,
>> +       [PERF_SAMPLE_BRANCH_IND_CALL_SHIFT]     = LBR_IND_CALL,
>> +       [PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT]   = LBR_REL_CALL | LBR_IND_CALL
>> +                                               | LBR_RETURN | LBR_CALL_STACK,
>> +};
>> +
>>  /* core */
>>  void intel_pmu_lbr_init_core(void)
>>  {
>> @@ -751,6 +789,20 @@ void intel_pmu_lbr_init_snb(void)
>>         pr_cont("16-deep LBR, ");
>>  }
>>
>> +/* haswell */
>> +void intel_pmu_lbr_init_hsw(void)
>> +{
>> +       x86_pmu.lbr_nr   = 16;
>> +       x86_pmu.lbr_tos  = MSR_LBR_TOS;
>> +       x86_pmu.lbr_from = MSR_LBR_NHM_FROM;
>> +       x86_pmu.lbr_to   = MSR_LBR_NHM_TO;
>> +
>> +       x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
>> +       x86_pmu.lbr_sel_map  = hsw_lbr_sel_map;
>> +
>> +       pr_cont("16-deep LBR, ");
>> +}
>> +
>>  /* atom */
>>  void intel_pmu_lbr_init_atom(void)
>>  {
>> --
>> 1.8.4.2
>>

