Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaBFPJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:09:35 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:36299 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaBFPJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:09:33 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBRz0u1U9RDoS64S00D9B+Ruyw_xBnT5WukUhuuv2A7YWA@mail.gmail.com>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
	<1388728091-18564-10-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBRz0u1U9RDoS64S00D9B+Ruyw_xBnT5WukUhuuv2A7YWA@mail.gmail.com>
Date: Thu, 6 Feb 2014 16:09:32 +0100
Message-ID: <CABPqkBSk6X1khQZ9UtMXqQEt=grfLv6VL1=fUnrdd71tAZeeCg@mail.gmail.com>
Subject: Re: [PATCH 09/14] perf, x86: Save/resotre LBR stack during context switch
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 6:45 PM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Jan 3, 2014 at 6:48 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> When the LBR call stack is enabled, it is necessary to save/restore
>> the LBR stack on context switch. The solution is saving/restoring
>> the LBR stack to/from task's perf event context.
>>
>> The LBR stack is saved/restored only when there are events that use
>> the LBR call stack. If no event uses LBR call stack, the LBR stack
>> is reset when task is scheduled in.
>>
>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 80 ++++++++++++++++++++++++------
>>  1 file changed, 66 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> index 2137a9f..51e1842 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> @@ -187,18 +187,82 @@ void intel_pmu_lbr_reset(void)
>>                 intel_pmu_lbr_reset_64();
>>  }
>>
>> +/*
>> + * TOS = most recently recorded branch
>> + */
>> +static inline u64 intel_pmu_lbr_tos(void)
>> +{
>> +       u64 tos;
>> +       rdmsrl(x86_pmu.lbr_tos, tos);
>> +       return tos;
>> +}
>> +
>> +enum {
>> +       LBR_UNINIT,
>> +       LBR_NONE,
>> +       LBR_VALID,
>> +};
>> +
> I don't see where the x86_perf_task_context struct gets initialized with
> your task_ctx_data/task_ctx_size mechanism. You are relying on 0
> as a valid default value. But if later more fields are needed and they need
> non-zero init values, it will be easy to forget.....
>
> So I think you need to provide a callback from alloc_perf_context().
> Should have mentioned that in Patch 05/14.
>
>> +static void __intel_pmu_lbr_restore(struct x86_perf_task_context *task_ctx)
>> +{
>> +       int i;
>> +       unsigned lbr_idx, mask = x86_pmu.lbr_nr - 1;
>> +       u64 tos = intel_pmu_lbr_tos();
>> +
>> +       for (i = 0; i < x86_pmu.lbr_nr; i++) {
>> +               lbr_idx = (tos - i) & mask;
>> +               wrmsrl(x86_pmu.lbr_from + lbr_idx, task_ctx->lbr_from[i]);
>> +               wrmsrl(x86_pmu.lbr_to + lbr_idx, task_ctx->lbr_to[i]);
>> +       }
>> +       task_ctx->lbr_stack_state = LBR_NONE;
>> +}
>> +
>> +static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
>> +{
>> +       int i;
>> +       unsigned lbr_idx, mask = x86_pmu.lbr_nr - 1;
>> +       u64 tos = intel_pmu_lbr_tos();
>> +
>> +       for (i = 0; i < x86_pmu.lbr_nr; i++) {
>> +               lbr_idx = (tos - i) & mask;
>> +               rdmsrl(x86_pmu.lbr_from + lbr_idx, task_ctx->lbr_from[i]);
>> +               rdmsrl(x86_pmu.lbr_to + lbr_idx, task_ctx->lbr_to[i]);
>> +       }
>> +       task_ctx->lbr_stack_state = LBR_VALID;
>> +}
>> +
>> +
>>  void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
>>  {
>> +       struct cpu_hw_events *cpuc;
>> +       struct x86_perf_task_context *task_ctx;
>> +
>>         if (!x86_pmu.lbr_nr)
>>                 return;
>>
>> +       cpuc = &__get_cpu_var(cpu_hw_events);
>> +       task_ctx = ctx ? ctx->task_ctx_data : NULL;
>> +
>> +
>>         /*
>>          * It is necessary to flush the stack on context switch. This happens
>>          * when the branch stack does not tag its entries with the pid of the
>>          * current task.
>>          */
>> -       if (sched_in)
>> -               intel_pmu_lbr_reset();
>> +       if (sched_in) {
>> +               if (!task_ctx ||
>> +                   !task_ctx->lbr_callstack_users ||
>> +                   task_ctx->lbr_stack_state != LBR_VALID)
>> +                       intel_pmu_lbr_reset();
>> +               else
>> +                       __intel_pmu_lbr_restore(task_ctx);
>> +       } else if (task_ctx) {
>> +               if (task_ctx->lbr_callstack_users &&
>> +                   task_ctx->lbr_stack_state != LBR_UNINIT)
>> +                       __intel_pmu_lbr_save(task_ctx);
>> +               else
>> +                       task_ctx->lbr_stack_state = LBR_NONE;
>> +       }
>>  }
>>
> There ought to be a better way of structuring this if/else. It is
> ugly.
>
Second thought on this. I am not sure I understand why the
test has to be so complex including on the save() side.

if (sched_in) {
     if (task_ctx && lbr_callstack_users)
              restore()
    else
            reset
} else { /* sched_out */
     if (task_ctx && lbr_callstack_users)
               save()
}
If you have lbr_callstack_users, then you need to save/restore.
Looks like you are trying to prevent from double sched-in or
double sched-out. Can this happen?

In other words, I am not sure I understand the need for the
lbr_state here.


>>  static inline bool branch_user_callstack(unsigned br_sel)
>> @@ -267,18 +331,6 @@ void intel_pmu_lbr_disable_all(void)
>>                 __intel_pmu_lbr_disable();
>>  }
>>
>> -/*
>> - * TOS = most recently recorded branch
>> - */
>> -static inline u64 intel_pmu_lbr_tos(void)
>> -{
>> -       u64 tos;
>> -
>> -       rdmsrl(x86_pmu.lbr_tos, tos);
>> -
>> -       return tos;
>> -}
>> -
>>  static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
>>  {
>>         unsigned long mask = x86_pmu.lbr_nr - 1;
>> --
>> 1.8.4.2
>>
