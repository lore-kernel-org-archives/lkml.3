Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaBFOzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:55:12 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54684 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaBFOzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:55:10 -0500
MIME-Version: 1.0
In-Reply-To: <1388728091-18564-8-git-send-email-zheng.z.yan@intel.com>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
	<1388728091-18564-8-git-send-email-zheng.z.yan@intel.com>
Date: Thu, 6 Feb 2014 15:55:08 +0100
Message-ID: <CABPqkBSQ23iFC4vRaV2-MQudKsA3Yykom-y8_H_7UxOApR4GzA@mail.gmail.com>
Subject: Re: [PATCH 07/14] perf: track number of events that use LBR callstack
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
> Later patch will use it to decide if the LBR stack should be saved/restored
>
You should describe better what this patch does. It should be repeated from
the patch title at least.

> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index bdd8758..2137a9f 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -201,15 +201,27 @@ void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
>                 intel_pmu_lbr_reset();
>  }
>
> +static inline bool branch_user_callstack(unsigned br_sel)
> +{
> +       return (br_sel & X86_BR_USER) && (br_sel & X86_BR_CALL_STACK);
> +}
> +
>  void intel_pmu_lbr_enable(struct perf_event *event)
>  {
>         struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +       struct x86_perf_task_context *task_ctx;
>
>         if (!x86_pmu.lbr_nr)
>                 return;
>
> +       cpuc = &__get_cpu_var(cpu_hw_events);
> +       task_ctx = event->ctx ? event->ctx->task_ctx_data : NULL;
> +
>         cpuc->br_sel = event->hw.branch_reg.reg;
>
> +       if (branch_user_callstack(cpuc->br_sel))
> +               task_ctx->lbr_callstack_users++;
> +
>         cpuc->lbr_users++;
>         if (cpuc->lbr_users == 1)
>                 perf_sched_cb_enable(event->ctx->pmu);
> @@ -217,11 +229,18 @@ void intel_pmu_lbr_enable(struct perf_event *event)
>
>  void intel_pmu_lbr_disable(struct perf_event *event)
>  {
> -       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +       struct cpu_hw_events *cpuc;
> +       struct x86_perf_task_context *task_ctx;
>
>         if (!x86_pmu.lbr_nr)
>                 return;
>
> +       cpuc = &__get_cpu_var(cpu_hw_events);
> +       task_ctx = event->ctx ? event->ctx->task_ctx_data : NULL;
> +
> +       if (branch_user_callstack(cpuc->br_sel))
> +               task_ctx->lbr_callstack_users--;
> +
>         cpuc->lbr_users--;
>         WARN_ON_ONCE(cpuc->lbr_users < 0);
>
> --
> 1.8.4.2
>
