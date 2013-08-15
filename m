Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab3HOLk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:40:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50966 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3HOLk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:40:58 -0400
Date: Thu, 15 Aug 2013 13:40:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf x86: Make intel_pmu_enable_all to enable only
 active events
Message-ID: <20130815114040.GR24092@twins.programming.kicks-ass.net>
References: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
 <1376411952-16718-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376411952-16718-2-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 06:39:11PM +0200, Jiri Olsa wrote:
> Currently the intel_pmu_enable_all enables all possible
> events, which is not allways desired. One case (there'll
> be probably more) is:
> 
>   - event hits throttling threshold
>   - NMI stops event
>   - intel_pmu_enable_all starts it back on the NMI exit
> 


> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -912,11 +912,13 @@ static void intel_pmu_disable_all(void)
>  static void intel_pmu_enable_all(int added)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +	u64 active_mask = *((u64*) cpuc->active_mask);
>  
>  	intel_pmu_pebs_enable_all();
>  	intel_pmu_lbr_enable_all();
>  	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
> -			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask);
> +			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask
> +			& active_mask);

Garh.. you made my head hurt :-)

I think its a NOP; this is the global ctrl register but
intel_pmu_disable_event() writes PERFEVTSELx.EN = 0, so even if you
enable it in the global mask, the event should still be disabled.


