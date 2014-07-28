Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaG1Deg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:34:36 -0400
Received: from one.firstfloor.org ([193.170.194.197]:39529 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaG1Dec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:34:32 -0400
Date: Mon, 28 Jul 2014 05:34:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS
 buffer
Message-ID: <20140728033429.GI18735@two.firstfloor.org>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
 <20140725081033.GV3935@laptop>
 <20140725150445.GG18735@two.firstfloor.org>
 <20140725155332.GC6758@twins.programming.kicks-ass.net>
 <20140725164041.GH18735@two.firstfloor.org>
 <53D5C174.80303@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D5C174.80303@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> how about following patch

Looks good to me. 

This will also solve the existing problem that perf record -e cycles:u
... gives kernel samples too.

-Andi

> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 33b4c0e..ea76507 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -1016,6 +1016,16 @@ static void setup_pebs_sample_data(struct perf_event *event,
>  		data->br_stack = &cpuc->lbr_stack;
>  }
>  
> +static inline bool intel_pmu_pebs_filter(struct perf_event *event,
> +					 struct pebs_record_nhm *record)
> +{
> +	if (event->attr.exclude_user && !kernel_ip(record->ip))
> +		return true;
> +	if (event->attr.exclude_kernel && kernel_ip(record->ip))
> +		return true;
> +	return false;
> +}
> +
>  static void __intel_pmu_pebs_event(struct perf_event *event,
>  				   struct pt_regs *iregs,
>  				   void *at, void *top, int count)
> @@ -1052,6 +1062,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  		struct pebs_record_nhm *p = at;
>  		if (!(p->status & (1 << event->hw.idx)))
>  			continue;
> +		if (intel_pmu_pebs_filter(event, p))
> +			continue;
>  
>  		setup_pebs_sample_data(event, iregs, at, &data, &regs);
>  		perf_output_sample(&handle, &header, &data, event);
> @@ -1139,6 +1151,8 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
>  			WARN_ON_ONCE(!event);
>  			if (!event->attr.precise_ip)
>  				continue;
> +			if (intel_pmu_pebs_filter(event, p))
> +				continue;
>  			counts[bit]++;
>  		}
>  	}
> @@ -1149,7 +1163,8 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
>  		event = cpuc->events[bit];
>  		for (at = base; at < top; at += x86_pmu.pebs_record_size) {
>  			struct pebs_record_nhm *p = at;
> -			if (p->status & (1 << bit))
> +			if ((p->status & (1 << bit)) &&
> +			    !intel_pmu_pebs_filter(event, p))
>  				break;
>  		}
>  
> ---
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
