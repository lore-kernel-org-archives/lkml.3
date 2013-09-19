Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3ISKgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:36:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34930 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3ISKgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:36:00 -0400
Date: Thu, 19 Sep 2013 12:35:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Vince Weaver <vince@deater.net>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        eranian@googlemail.com
Subject: Re: [PATCH] perf: Always set bit 0 in the capabilities field of
 'struct perf_event_mmap_page' to 0, to maintain the ABI
Message-ID: <20130919103550.GO9326@twins.programming.kicks-ass.net>
References: <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
 <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
 <20130918085722.GL12926@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
 <20130918154224.GK9326@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy>
 <20130919081642.GL9326@twins.programming.kicks-ass.net>
 <20130919091452.GB14112@gmail.com>
 <20130919101240.GN9326@twins.programming.kicks-ass.net>
 <20130919102818.GA23487@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919102818.GA23487@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 12:28:18PM +0200, Ingo Molnar wrote:

You really don't like version fields do you ;-)

> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 8355c84..3ab624c 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1883,9 +1883,9 @@ static struct pmu pmu = {
>  
>  void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>  {
> -	userpg->cap_usr_time = 0;
> -	userpg->cap_usr_time_zero = 0;
> -	userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
> +	userpg->cap_usr_time_used = 0;
> +	userpg->cap_usr_time_zero_used = 0;
> +	userpg->cap_usr_rdpmc_available = x86_pmu.attr_rdpmc;
>  	userpg->pmc_width = x86_pmu.cntval_bits;
>  
>  	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> @@ -1894,13 +1894,13 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>  	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
>  		return;
>  
> -	userpg->cap_usr_time = 1;
> +	userpg->cap_usr_time_used = 1;
>  	userpg->time_mult = this_cpu_read(cyc2ns);
>  	userpg->time_shift = CYC2NS_SCALE_FACTOR;
>  	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
>  
>  	if (sched_clock_stable && !check_tsc_disabled()) {
> -		userpg->cap_usr_time_zero = 1;
> +		userpg->cap_usr_time_zero_used = 1;
>  		userpg->time_zero = this_cpu_read(cyc2ns_offset);
>  	}
>  }
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 40a1fb8..e3514d1 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -380,10 +380,13 @@ struct perf_event_mmap_page {
>  	union {
>  		__u64	capabilities;
>  		struct {
> -			__u64	cap_usr_time		: 1,
> -				cap_usr_rdpmc		: 1,
> -				cap_usr_time_zero	: 1,
> -				cap_____res		: 61;
> +			__u64	cap_bit0		: 1, /* Deprecated, always zero, see commit 860f085b74e9 */
> +				cap_bit0_is_deprecated	: 1, /* Always 1, signals that bit 0 is zero */
> +
> +				cap_usr_rdpmc_available	: 1, /* The RDPMC instruction can be used to read counts */
> +				cap_usr_time_used	: 1, /* The time_* fields are uses */
> +				cap_usr_time_zero_used	: 1, /* The time_zero field is used */
> +				cap_____res		: 59;
>  		};
>  	};

Would it make sense to do something like s/cap_usr/cap_user/ and drop
the _available, _used postfixes? It results in different names but
avoids these terribly long ones.
