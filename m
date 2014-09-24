Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaIXMx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:53:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaIXMx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:53:56 -0400
Date: Wed, 24 Sep 2014 14:53:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 08/16] perf, x86: track number of events that use LBR
 callstack
Message-ID: <20140924125349.GB2805@worktop.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-9-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358153-421-9-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:09:05AM -0400, kan.liang@intel.com wrote:
> @@ -204,9 +204,15 @@ void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
>  	}
>  }
>  
> +static inline bool branch_user_callstack(unsigned br_sel)
> +{
> +	return (br_sel & X86_BR_USER) && (br_sel & X86_BR_CALL_STACK);
> +}
> +
>  void intel_pmu_lbr_enable(struct perf_event *event)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +	struct x86_perf_task_context *task_ctx;
>  
>  	if (!x86_pmu.lbr_nr)
>  		return;
> @@ -220,6 +226,10 @@ void intel_pmu_lbr_enable(struct perf_event *event)
>  	}
>  	cpuc->br_sel = event->hw.branch_reg.reg;
>  
> +	task_ctx = event->ctx ? event->ctx->task_ctx_data : NULL;
> +	if (task_ctx && branch_user_callstack(cpuc->br_sel))
> +		task_ctx->lbr_callstack_users++;
> +

Does it make sense to flip those conditions to avoid a potentially
useless dereference?
