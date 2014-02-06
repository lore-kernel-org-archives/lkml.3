Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaBFPuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:50:20 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:33067 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaBFPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:50:18 -0500
MIME-Version: 1.0
In-Reply-To: <1388728091-18564-14-git-send-email-zheng.z.yan@intel.com>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
	<1388728091-18564-14-git-send-email-zheng.z.yan@intel.com>
Date: Thu, 6 Feb 2014 16:50:17 +0100
Message-ID: <CABPqkBS=tpqUG7EOGSB2cpA=YSBQVn-Ma=Si0W7bKPVW1u_vWg@mail.gmail.com>
Subject: Re: [PATCH 13/14] perf, x86: enable LBR callstack when recording callchain
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

On Fri, Jan 3, 2014 at 6:48 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> Try enabling the LBR callstack facility if user requests recording
> user space callchain. Also adds a cpu pmu attribute to enable/disable
> this feature. This feature is disabled by default because it may
> contend for the LBR with other events that explicitly require branch
> stack
>
We have discussed this patch before.
I think you need to describe cleary what's going on based on priv levels.

excl_user=0, excl_kernel=0 : user callstack via LBR, kernel via framepointer?
excl_user=0, excl_kernel=1 : user callstack via LBR
excl_user=1, excl_kernel=0 : kernel via framepointer?
excl_user=1, excl_kernel=1 : nothing

This does not come out clear from the code below.

> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c | 99 ++++++++++++++++++++++++++++------------
>  arch/x86/kernel/cpu/perf_event.h |  7 +++
>  2 files changed, 77 insertions(+), 29 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 1509340..3ea184a 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -399,37 +399,49 @@ int x86_pmu_hw_config(struct perf_event *event)
>
>                 if (event->attr.precise_ip > precise)
>                         return -EOPNOTSUPP;
> +       }
> +       /*
> +        * check that PEBS LBR correction does not conflict with
> +        * whatever the user is asking with attr->branch_sample_type
> +        */
> +       if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
> +               u64 *br_type = &event->attr.branch_sample_type;
> +
> +               if (has_branch_stack(event)) {
> +                       if (!precise_br_compat(event))
> +                               return -EOPNOTSUPP;
> +
> +                       /* branch_sample_type is compatible */
> +
> +               } else {
> +                       /*
> +                        * user did not specify  branch_sample_type
> +                        *
> +                        * For PEBS fixups, we capture all
> +                        * the branches at the priv level of the
> +                        * event.
> +                        */
> +                       *br_type = PERF_SAMPLE_BRANCH_ANY;
> +
> +                       if (!event->attr.exclude_user)
> +                               *br_type |= PERF_SAMPLE_BRANCH_USER;
> +
> +                       if (!event->attr.exclude_kernel)
> +                               *br_type |= PERF_SAMPLE_BRANCH_KERNEL;
> +               }
> +       } else if ((event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
> +                  !has_branch_stack(event) &&
> +                  x86_pmu.attr_lbr_callstack &&
> +                  !event->attr.exclude_user &&
> +                  (event->attach_state & PERF_ATTACH_TASK)) {
>                 /*
> -                * check that PEBS LBR correction does not conflict with
> -                * whatever the user is asking with attr->branch_sample_type
> +                * user did not specify branch_sample_type,
> +                * try using the LBR call stack facility to
> +                * record call chains of user program.
>                  */
> -               if (event->attr.precise_ip > 1 &&
> -                   x86_pmu.intel_cap.pebs_format < 2) {
> -                       u64 *br_type = &event->attr.branch_sample_type;
> -
> -                       if (has_branch_stack(event)) {
> -                               if (!precise_br_compat(event))
> -                                       return -EOPNOTSUPP;
> -
> -                               /* branch_sample_type is compatible */
> -
> -                       } else {
> -                               /*
> -                                * user did not specify  branch_sample_type
> -                                *
> -                                * For PEBS fixups, we capture all
> -                                * the branches at the priv level of the
> -                                * event.
> -                                */
> -                               *br_type = PERF_SAMPLE_BRANCH_ANY;
> -
> -                               if (!event->attr.exclude_user)
> -                                       *br_type |= PERF_SAMPLE_BRANCH_USER;
> -
> -                               if (!event->attr.exclude_kernel)
> -                                       *br_type |= PERF_SAMPLE_BRANCH_KERNEL;
> -                       }
> -               }
> +               event->attr.branch_sample_type =
> +                       PERF_SAMPLE_BRANCH_USER |
> +                       PERF_SAMPLE_BRANCH_CALL_STACK;
>         }
>
>         /*
> @@ -1828,10 +1840,39 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
>         return count;
>  }
>
> +static ssize_t get_attr_lbr_callstack(struct device *cdev,
> +                                     struct device_attribute *attr, char *buf)
> +{
> +       return snprintf(buf, 40, "%d\n", x86_pmu.attr_lbr_callstack);
> +}
> +
> +static ssize_t set_attr_lbr_callstack(struct device *cdev,
> +                                     struct device_attribute *attr,
> +                                     const char *buf, size_t count)
> +{
> +       unsigned long val;
> +       ssize_t ret;
> +
> +       ret = kstrtoul(buf, 0, &val);
> +       if (ret)
> +               return ret;
> +
> +       if (!!val != !!x86_pmu.attr_lbr_callstack) {
> +               if (val && !x86_pmu_has_lbr_callstack())
> +                       return -EOPNOTSUPP;
> +               x86_pmu.attr_lbr_callstack = !!val;
> +       }
> +       return count;
> +}
> +
>  static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
> +static DEVICE_ATTR(lbr_callstack, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
> +                  get_attr_lbr_callstack, set_attr_lbr_callstack);
> +
>
>  static struct attribute *x86_pmu_attrs[] = {
>         &dev_attr_rdpmc.attr,
> +       &dev_attr_lbr_callstack.attr,
>         NULL,
>  };
>
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 3ed9629..b45258c 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -400,6 +400,7 @@ struct x86_pmu {
>          * sysfs attrs
>          */
>         int             attr_rdpmc;
> +       int             attr_lbr_callstack;
>         struct attribute **format_attrs;
>         struct attribute **event_attrs;
>
> @@ -504,6 +505,12 @@ static struct perf_pmu_events_attr event_attr_##v = {                      \
>
>  extern struct x86_pmu x86_pmu __read_mostly;
>
> +static inline bool x86_pmu_has_lbr_callstack(void)
> +{
> +       return  x86_pmu.lbr_sel_map &&
> +               x86_pmu.lbr_sel_map[PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT] > 0;
> +}
> +
>  DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
>
>  int x86_perf_event_set_period(struct perf_event *event);
> --
> 1.8.4.2
>
