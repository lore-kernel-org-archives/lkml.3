Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaJXNju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:39:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbaJXNjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:39:48 -0400
Date: Fri, 24 Oct 2014 15:39:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Kan Liang <kan.liang@intel.com>
Cc: a.p.zijlstra@chello.nl, eranian@google.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, paulus@samba.org, acme@kernel.org,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V6 13/17] perf, x86: enable LBR callstack when recording
 callchain
Message-ID: <20141024133936.GD1036@krava.brq.redhat.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
 <1413755712-8259-14-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413755712-8259-14-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 05:55:08PM -0400, Kan Liang wrote:
> Only enable LBR callstack when user requires fp callgraph. The feature
> is not available when PERF_SAMPLE_BRANCH_STACK or PERF_SAMPLE_STACK_USER
> is required.
> Also, this feature only affects how to get user callchain. The kernel
> callchain is always got by frame pointers.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 9656b9e..b3256a3 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -424,10 +424,24 @@ int x86_pmu_hw_config(struct perf_event *event)
>  			if (!event->attr.exclude_kernel)
>  				*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
>  		}
> -	}
> +	} else if (x86_pmu_has_lbr_callstack() &&
> +		   (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
> +		   !(event->attr.sample_type & PERF_SAMPLE_STACK_USER) &&
> +		   !has_branch_stack(event) &&
> +		   !event->attr.exclude_user &&
> +		   (event->attach_state & PERF_ATTACH_TASK)) {
> +		/*
> +		 * user did not specify branch_sample_type,
> +		 * try using the LBR call stack facility to
> +		 * record call chains of user program.
> +		 */
> +		event->attr.branch_sample_type =
> +			PERF_SAMPLE_BRANCH_USER |
> +			PERF_SAMPLE_BRANCH_CALL_STACK;
>  

I dont see PERF_SAMPLE_BRANCH_CALL_STACK being defind in uapi.. any reason
why I cant enable this feature explicitly?

thanks,
jirka
