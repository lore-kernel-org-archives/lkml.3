Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3ISLMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:12:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:18285 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab3ISLMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:12:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,936,1371106800"; 
   d="scan'208";a="380504284"
Message-ID: <523ADD8D.1030607@intel.com>
Date: Thu, 19 Sep 2013 14:18:37 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, eranian@googlemail.com
Subject: Re: [PATCH, v3] perf: Always set bit 0 in the capabilities field
 of 'struct perf_event_mmap_page' to 0, to maintain the ABI
References: <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy> <20130918085722.GL12926@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy> <20130918154224.GK9326@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy> <20130919081642.GL9326@twins.programming.kicks-ass.net> <20130919091452.GB14112@gmail.com> <20130919101240.GN9326@twins.programming.kicks-ass.net> <20130919102818.GA23487@gmail.com> <20130919103550.GO9326@twins.programming.kicks-ass.net> <20130919104056.GA18991@gmail.com>
In-Reply-To: <20130919104056.GA18991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/13 13:40, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Thu, Sep 19, 2013 at 12:28:18PM +0200, Ingo Molnar wrote:
>>
>> You really don't like version fields do you ;-)
> 
> Indeed they are a horrible concept.
> 
>> Would it make sense to do something like s/cap_usr/cap_user/ and drop 
>> the _available, _used postfixes? It results in different names but 
>> avoids these terribly long ones.
> 
> Absolutely! Find updated patch below.
> 
> Thanks,
> 
> 	Ingo
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 8355c84..a9c606b 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1883,9 +1883,9 @@ static struct pmu pmu = {
>  
>  void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>  {
> -	userpg->cap_usr_time = 0;
> -	userpg->cap_usr_time_zero = 0;
> -	userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
> +	userpg->cap_user_time = 0;
> +	userpg->cap_user_time_zero = 0;
> +	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
>  	userpg->pmc_width = x86_pmu.cntval_bits;
>  
>  	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> @@ -1894,13 +1894,13 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>  	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
>  		return;
>  
> -	userpg->cap_usr_time = 1;
> +	userpg->cap_user_time = 1;
>  	userpg->time_mult = this_cpu_read(cyc2ns);
>  	userpg->time_shift = CYC2NS_SCALE_FACTOR;
>  	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
>  
>  	if (sched_clock_stable && !check_tsc_disabled()) {
> -		userpg->cap_usr_time_zero = 1;
> +		userpg->cap_user_time_zero = 1;
>  		userpg->time_zero = this_cpu_read(cyc2ns_offset);
>  	}
>  }
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 40a1fb8..dd4c903 100644
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
> +			__u64	cap_bit0		: 1, /* Always 0, deprecated, see commit 860f085b74e9 */
> +				cap_bit0_is_deprecated	: 1, /* Always 1, signals that bit 0 is zero */
> +
> +				cap_user_rdpmc		: 1, /* The RDPMC instruction can be used to read counts */
> +				cap_user_time		: 1, /* The time_* fields are used */
> +				cap_user_time_zero	: 1, /* The time_zero field is used */
> +				cap_____res		: 59;
>  		};
>  	};
>  
> @@ -442,12 +445,13 @@ struct perf_event_mmap_page {
>  	 *               ((rem * time_mult) >> time_shift);
>  	 */
>  	__u64	time_zero;
> +	__u32	size;			/* Header size up to __reserved[] fields. */
>  
>  		/*
>  		 * Hole for extension of the self monitor capabilities
>  		 */
>  
> -	__u64	__reserved[119];	/* align to 1k */
> +	__u8	__reserved[118*8+4];	/* align to 1k. */
>  
>  	/*
>  	 * Control data for the mmap() data buffer.
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index dd236b6..cb4238e 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3660,6 +3660,26 @@ static void calc_timer_values(struct perf_event *event,
>  	*running = ctx_time - event->tstamp_running;
>  }
>  
> +static void perf_event_init_userpage(struct perf_event *event)
> +{
> +	struct perf_event_mmap_page *userpg;
> +	struct ring_buffer *rb;
> +
> +	rcu_read_lock();
> +	rb = rcu_dereference(event->rb);
> +	if (!rb)
> +		goto unlock;
> +
> +	userpg = rb->user_page;
> +
> +	/* Allow new userspace to detect that bit 0 is deprecated */
> +	userpg->cap_bit0_is_deprecated = 1;
> +	userpg->size = offsetof(struct perf_event_mmap_page, __reserved);
> +
> +unlock:
> +	rcu_read_unlock();
> +}
> +
>  void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>  {
>  }
> @@ -4044,6 +4064,7 @@ again:
>  	ring_buffer_attach(event, rb);
>  	rcu_assign_pointer(event->rb, rb);
>  
> +	perf_event_init_userpage(event);
>  	perf_event_update_userpage(event);
>  
>  unlock:
> 
> 

Please consider adding:


diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index 9570c2b..b2519e4 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -32,7 +32,7 @@ u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc)
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc)
 {
-	bool cap_usr_time_zero;
+	bool cap_user_time_zero;
 	u32 seq;
 	int i = 0;

@@ -42,7 +42,7 @@ int perf_read_tsc_conversion(const struct
perf_event_mmap_page *pc,
 		tc->time_mult = pc->time_mult;
 		tc->time_shift = pc->time_shift;
 		tc->time_zero = pc->time_zero;
-		cap_usr_time_zero = pc->cap_usr_time_zero;
+		cap_user_time_zero = pc->cap_user_time_zero;
 		rmb();
 		if (pc->lock == seq && !(seq & 1))
 			break;
@@ -52,7 +52,7 @@ int perf_read_tsc_conversion(const struct
perf_event_mmap_page *pc,
 		}
 	}

-	if (!cap_usr_time_zero)
+	if (!cap_user_time_zero)
 		return -EOPNOTSUPP;

 	return 0;

