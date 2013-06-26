Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3FZMpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:45:44 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57520 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3FZMpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBR7L0xp1Lk8CArtB0gYk2Z3E-EqP0O3H5OqxfRhmGDh+Q@mail.gmail.com>
References: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
	<1372150039-15151-7-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBR7L0xp1Lk8CArtB0gYk2Z3E-EqP0O3H5OqxfRhmGDh+Q@mail.gmail.com>
Date: Wed, 26 Jun 2013 14:45:42 +0200
Message-ID: <CABPqkBQQVvCJX2sWhUE5RtMsmgezNYeBem7h0HBMjzbsSowgtA@mail.gmail.com>
Subject: Re: [PATCH 6/7] perf, x86: Use LBR call stack to get user callchain
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

And I think the reason why kernel is not possible deserves
a full explanation in the changelog and in the code.
It is still not clear to me whether this is a hw bug or a
limitation.


On Wed, Jun 26, 2013 at 2:42 PM, Stephane Eranian <eranian@google.com> wrote:
> On Tue, Jun 25, 2013 at 10:47 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> Try enabling the LBR call stack feature if event request recording
>> callchain. Try utilizing the LBR call stack to get user callchain
>> in case of there is no frame pointer.
>>
>> This patch also adds a cpu pmu attribute to enable/disable this
>> feature.
>>
>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event.c           | 128 +++++++++++++++++++++--------
>>  arch/x86/kernel/cpu/perf_event.h           |   7 ++
>>  arch/x86/kernel/cpu/perf_event_intel.c     |  20 ++---
>>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   3 +
>>  include/linux/perf_event.h                 |   6 ++
>>  kernel/events/core.c                       |  11 ++-
>>  6 files changed, 126 insertions(+), 49 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index 639aa4d..a07eb03 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -399,37 +399,49 @@ int x86_pmu_hw_config(struct perf_event *event)
>>
>>                 if (event->attr.precise_ip > precise)
>>                         return -EOPNOTSUPP;
>> +       }
>> +       /*
>> +        * check that PEBS LBR correction does not conflict with
>> +        * whatever the user is asking with attr->branch_sample_type
>> +        */
>> +       if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
>> +               u64 *br_type = &event->attr.branch_sample_type;
>> +
>> +               if (has_branch_stack(event)) {
>> +                       if (!precise_br_compat(event))
>> +                               return -EOPNOTSUPP;
>> +
>> +                       /* branch_sample_type is compatible */
>> +
>> +               } else {
>> +                       /*
>> +                        * user did not specify  branch_sample_type
>> +                        *
>> +                        * For PEBS fixups, we capture all
>> +                        * the branches at the priv level of the
>> +                        * event.
>> +                        */
>> +                       *br_type = PERF_SAMPLE_BRANCH_ANY;
>> +
>> +                       if (!event->attr.exclude_user)
>> +                               *br_type |= PERF_SAMPLE_BRANCH_USER;
>> +
>> +                       if (!event->attr.exclude_kernel)
>> +                               *br_type |= PERF_SAMPLE_BRANCH_KERNEL;
>> +               }
>> +       } else if ((event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
>> +                  !has_branch_stack(event) &&
>> +                  x86_pmu.attr_lbr_callstack &&
>> +                  !event->attr.exclude_user &&
>> +                  (event->attach_state & PERF_ATTACH_TASK)) {
>
> Yes, that's the test but it is wrong. I can pass the test if
> I have exclude_user = exclude_kernel = 0.
>
> You want:
>                  !event->attr.exclude_user && event->attr.exclude_kernel &&
>
> I tested that and it works.
>
>>                 /*
>> -                * check that PEBS LBR correction does not conflict with
>> -                * whatever the user is asking with attr->branch_sample_type
>> +                * user did not specify branch_sample_type,
>> +                * try using the LBR call stack facility to
>> +                * record call chains of user program.
>>                  */
>> -               if (event->attr.precise_ip > 1 &&
>> -                   x86_pmu.intel_cap.pebs_format < 2) {
>> -                       u64 *br_type = &event->attr.branch_sample_type;
>> -
>> -                       if (has_branch_stack(event)) {
>> -                               if (!precise_br_compat(event))
>> -                                       return -EOPNOTSUPP;
>> -
>> -                               /* branch_sample_type is compatible */
>> -
>> -                       } else {
>> -                               /*
>> -                                * user did not specify  branch_sample_type
>> -                                *
>> -                                * For PEBS fixups, we capture all
>> -                                * the branches at the priv level of the
>> -                                * event.
>> -                                */
>> -                               *br_type = PERF_SAMPLE_BRANCH_ANY;
>> -
>> -                               if (!event->attr.exclude_user)
>> -                                       *br_type |= PERF_SAMPLE_BRANCH_USER;
>> -
>> -                               if (!event->attr.exclude_kernel)
>> -                                       *br_type |= PERF_SAMPLE_BRANCH_KERNEL;
>> -                       }
>> -               }
>> +               event->attr.branch_sample_type =
>> +                       PERF_SAMPLE_BRANCH_USER |
>> +                       PERF_SAMPLE_BRANCH_CALL_STACK;
>>         }
>>
>>         /*
>> @@ -1825,10 +1837,34 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
>>         return count;
>>  }
>>
>> +static ssize_t get_attr_lbr_callstack(struct device *cdev,
>> +                                     struct device_attribute *attr, char *buf)
>> +{
>> +       return snprintf(buf, 40, "%d\n", x86_pmu.attr_lbr_callstack);
>> +}
>> +
>> +static ssize_t set_attr_lbr_callstack(struct device *cdev,
>> +                                     struct device_attribute *attr,
>> +                                     const char *buf, size_t count)
>> +{
>> +       unsigned long val = simple_strtoul(buf, NULL, 0);
>> +
>> +       if (x86_pmu.attr_lbr_callstack != !!val) {
>> +               if (val && !x86_pmu_has_lbr_callstack())
>> +                       return -EOPNOTSUPP;
>> +               x86_pmu.attr_lbr_callstack = !!val;
>> +       }
>> +       return count;
>> +}
>> +
>>  static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
>> +static DEVICE_ATTR(lbr_callstack, S_IRUSR | S_IWUSR,
>> +                  get_attr_lbr_callstack, set_attr_lbr_callstack);
>> +
>>
>>  static struct attribute *x86_pmu_attrs[] = {
>>         &dev_attr_rdpmc.attr,
>> +       &dev_attr_lbr_callstack.attr,
>>         NULL,
>>  };
>>
>> @@ -1955,12 +1991,29 @@ static unsigned long get_segment_base(unsigned int segment)
>>         return get_desc_base(desc + idx);
>>  }
>>
>> +static inline void
>> +perf_callchain_lbr_callstack(struct perf_callchain_entry *entry,
>> +                            struct perf_sample_data *data)
>> +{
>> +       struct perf_branch_stack *br_stack = data->br_stack;
>> +
>> +       if (br_stack && br_stack->user_callstack &&
>> +           x86_pmu.attr_lbr_callstack) {
>> +               int i = 0;
>> +               while (i < br_stack->nr && entry->nr < PERF_MAX_STACK_DEPTH) {
>> +                       perf_callchain_store(entry, br_stack->entries[i].from);
>> +                       i++;
>> +               }
>> +       }
>> +}
>> +
>>  #ifdef CONFIG_COMPAT
>>
>>  #include <asm/compat.h>
>>
>>  static inline int
>> -perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
>> +perf_callchain_user32(struct perf_callchain_entry *entry,
>> +                     struct pt_regs *regs, struct perf_sample_data *data)
>>  {
>>         /* 32-bit process in 64-bit kernel. */
>>         unsigned long ss_base, cs_base;
>> @@ -1989,11 +2042,16 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
>>                 perf_callchain_store(entry, cs_base + frame.return_address);
>>                 fp = compat_ptr(ss_base + frame.next_frame);
>>         }
>> +
>> +       if (fp == compat_ptr(regs->bp))
>> +               perf_callchain_lbr_callstack(entry, data);
>> +
>>         return 1;
>>  }
>>  #else
>>  static inline int
>> -perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
>> +perf_callchain_user32(struct perf_callchain_entry *entry,
>> +                     struct pt_regs *regs, struct perf_sample_data *data)
>>  {
>>      return 0;
>>  }
>> @@ -2023,12 +2081,12 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
>>         if (!current->mm)
>>                 return;
>>
>> -       if (perf_callchain_user32(regs, entry))
>> +       if (perf_callchain_user32(entry, regs, data))
>>                 return;
>>
>>         while (entry->nr < PERF_MAX_STACK_DEPTH) {
>>                 unsigned long bytes;
>> -               frame.next_frame             = NULL;
>> +               frame.next_frame = NULL;
>>                 frame.return_address = 0;
>>
>>                 bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
>> @@ -2041,6 +2099,10 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
>>                 perf_callchain_store(entry, frame.return_address);
>>                 fp = frame.next_frame;
>>         }
>> +
>> +       /* try LBR callstack if there is no frame pointer */
>> +       if (fp == (void __user *)regs->bp)
>> +               perf_callchain_lbr_callstack(entry, data);
>>  }
>>
>>  /*
>> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
>> index 0116970..536470d 100644
>> --- a/arch/x86/kernel/cpu/perf_event.h
>> +++ b/arch/x86/kernel/cpu/perf_event.h
>> @@ -390,6 +390,7 @@ struct x86_pmu {
>>          * sysfs attrs
>>          */
>>         int             attr_rdpmc;
>> +       int             attr_lbr_callstack;
>>         struct attribute **format_attrs;
>>         struct attribute **event_attrs;
>>
>> @@ -496,6 +497,12 @@ static struct perf_pmu_events_attr event_attr_##v = {                      \
>>
>>  extern struct x86_pmu x86_pmu __read_mostly;
>>
>> +static inline bool x86_pmu_has_lbr_callstack(void)
>> +{
>> +       return  x86_pmu.lbr_sel_map &&
>> +               x86_pmu.lbr_sel_map[PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT] > 0;
>> +}
>> +
>>  DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
>>
>>  int x86_perf_event_set_period(struct perf_event *event);
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
>> index f59b46e..baa8384 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>> @@ -882,15 +882,10 @@ static __initconst const u64 atom_hw_cache_event_ids
>>   },
>>  };
>>
>> -static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
>> +static inline bool intel_pmu_needs_lbr_callstack(struct perf_event *event)
>>  {
>> -       /* user explicitly requested branch sampling */
>> -       if (has_branch_stack(event))
>> -               return true;
>> -
>> -       /* implicit branch sampling to correct PEBS skid */
>> -       if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
>> -           x86_pmu.intel_cap.pebs_format < 2)
>> +       if ((event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
>> +           (event->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK))
>>                 return true;
>>
>>         return false;
>> @@ -1054,7 +1049,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
>>          * must disable before any actual event
>>          * because any event may be combined with LBR
>>          */
>> -       if (intel_pmu_needs_lbr_smpl(event))
>> +       if (needs_branch_stack(event))
>>                 intel_pmu_lbr_disable(event);
>>
>>         if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
>> @@ -1115,7 +1110,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
>>          * must enabled before any actual event
>>          * because any event may be combined with LBR
>>          */
>> -       if (intel_pmu_needs_lbr_smpl(event))
>> +       if (needs_branch_stack(event))
>>                 intel_pmu_lbr_enable(event);
>>
>>         if (event->attr.exclude_host)
>> @@ -1237,7 +1232,8 @@ again:
>>
>>                 perf_sample_data_init(&data, 0, event->hw.last_period);
>>
>> -               if (has_branch_stack(event))
>> +               if (has_branch_stack(event) ||
>> +                   (event->ctx->task && intel_pmu_needs_lbr_callstack(event)))
>>                         data.br_stack = &cpuc->lbr_stack;
>>
>>                 if (perf_event_overflow(event, &data, regs))
>> @@ -1568,7 +1564,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
>>         if (event->attr.precise_ip && x86_pmu.pebs_aliases)
>>                 x86_pmu.pebs_aliases(event);
>>
>> -       if (intel_pmu_needs_lbr_smpl(event)) {
>> +       if (needs_branch_stack(event)) {
>>                 ret = intel_pmu_setup_lbr_filter(event);
>>                 if (ret)
>>                         return ret;
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> index 43b16b4..3be2d7b 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> @@ -709,6 +709,8 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
>>         int i, j, type;
>>         bool compress = false;
>>
>> +       cpuc->lbr_stack.user_callstack = branch_user_callstack(br_sel);
>> +
>>         /* if sampling all branches, then nothing to filter */
>>         if ((br_sel & X86_BR_ALL) == X86_BR_ALL)
>>                 return;
>> @@ -861,6 +863,7 @@ void intel_pmu_lbr_init_hsw(void)
>>
>>         x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
>>         x86_pmu.lbr_sel_map  = hsw_lbr_sel_map;
>> +       x86_pmu.attr_lbr_callstack = 1;
>>
>>         pr_cont("16-deep LBR, ");
>>  }
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index fa4c1bf..168e66e 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -97,6 +97,7 @@ struct perf_branch_entry {
>>   * recent branch.
>>   */
>>  struct perf_branch_stack {
>> +       unsigned                        user_callstack:1;
>>         __u64                           nr;
>>         struct perf_branch_entry        entries[0];
>>  };
>> @@ -759,6 +760,11 @@ static inline bool has_branch_stack(struct perf_event *event)
>>         return event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK;
>>  }
>>
>> +static inline bool needs_branch_stack(struct perf_event *event)
>> +{
>> +       return event->attr.branch_sample_type != 0;
>> +}
>> +
>>  extern int perf_output_begin(struct perf_output_handle *handle,
>>                              struct perf_event *event, unsigned int size);
>>  extern void perf_output_end(struct perf_output_handle *handle);
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 4aad901..38eaa2b 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -1117,7 +1117,7 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
>>         if (is_cgroup_event(event))
>>                 ctx->nr_cgroups++;
>>
>> -       if (has_branch_stack(event))
>> +       if (needs_branch_stack(event))
>>                 ctx->nr_branch_stack++;
>>
>>         list_add_rcu(&event->event_entry, &ctx->event_list);
>> @@ -1274,7 +1274,7 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
>>                         cpuctx->cgrp = NULL;
>>         }
>>
>> -       if (has_branch_stack(event)) {
>> +       if (needs_branch_stack(event)) {
>>                 if (ctx->is_active)
>>                         __get_cpu_var(perf_branch_stack_events)--;
>>                 ctx->nr_branch_stack--;
>> @@ -3155,7 +3155,7 @@ static void free_event(struct perf_event *event)
>>                         static_key_slow_dec_deferred(&perf_sched_events);
>>                 }
>>
>> -               if (has_branch_stack(event))
>> +               if (needs_branch_stack(event))
>>                         static_key_slow_dec_deferred(&perf_sched_events);
>>         }
>>
>> @@ -6545,6 +6545,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>>         if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
>>                 goto done;
>>
>> +       if (!has_branch_stack(event))
>> +               event->attr.branch_sample_type = 0;
>> +
>>         pmu = perf_init_event(event);
>>
>>  done:
>> @@ -6577,7 +6580,7 @@ done:
>>                                 return ERR_PTR(err);
>>                         }
>>                 }
>> -               if (has_branch_stack(event))
>> +               if (needs_branch_stack(event))
>>                         static_key_slow_inc(&perf_sched_events.key);
>>         }
>>
>> --
>> 1.8.1.4
>>
