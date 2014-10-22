Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbaJVKst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:48:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37404 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932450AbaJVKss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:48:48 -0400
Date: Wed, 22 Oct 2014 11:47:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: chai wen <chaiw.fnst@cn.fujitsu.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "yuichi.kusakabe@jp.fujitsu.com" <yuichi.kusakabe@jp.fujitsu.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH 1/2] ARM: perf: armv7 remove useless return and check of
 idx in counter handling
Message-ID: <20141022104742.GD22642@leverpostej>
References: <1413966107-11881-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413966107-11881-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
Thread-Topic: [PATCH 1/2] ARM: perf: armv7 remove useless return and check of
 idx in counter handling
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 22, 2014 at 09:21:46AM +0100, chai wen wrote:
> Idx sanity check was once implemented separately in these counter handling
> functions and then return value was treated as a judgement.
> 	armv7_pmnc_select_counter()
> 	armv7_pmnc_enable_counter()
> 	armv7_pmnc_disable_counter()
> 	armv7_pmnc_enable_intens()
> 	armv7_pmnc_disable_intens()
> But we do not need to do this now, and the return of idx is useless.
>
> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>

It looks like the validation was moved out of all of these functions in
7279adbd9bb8ef8f (ARM: perf: check ARMv7 counter validity on a per-pmu
basis), and we just missed the opportunity to simplify callers at the
time.

It would be nice if we mentioned that in the commit message -- it takes
a while to figure out and it's handy for reference.

> ---
>  arch/arm/kernel/perf_event_v7.c |   32 ++++++++++++++------------------
>  1 files changed, 14 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
> index 116758b..f66a9b8 100644
> --- a/arch/arm/kernel/perf_event_v7.c
> +++ b/arch/arm/kernel/perf_event_v7.c
> @@ -564,13 +564,11 @@ static inline int armv7_pmnc_counter_has_overflowed(u32 pmnc, int idx)
>  	return pmnc & BIT(ARMV7_IDX_TO_COUNTER(idx));
>  }
>  
> -static inline int armv7_pmnc_select_counter(int idx)
> +static inline void armv7_pmnc_select_counter(int idx)
>  {
>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>  	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (counter));
>  	isb();
> -
> -	return idx;
>  }
>  
>  static inline u32 armv7pmu_read_counter(struct perf_event *event)
> @@ -585,8 +583,10 @@ static inline u32 armv7pmu_read_counter(struct perf_event *event)
>  			smp_processor_id(), idx);
>  	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
>  		asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (value));
> -	else if (armv7_pmnc_select_counter(idx) == idx)
> +	else {
> +		armv7_pmnc_select_counter(idx);
>  		asm volatile("mrc p15, 0, %0, c9, c13, 2" : "=r" (value));
> +	}

Please make the braces consistent -- if one branch in an if .. else
chain needs them, they all do (see Documentation/CodingStyle).

>  
>  	return value;
>  }
> @@ -602,40 +602,38 @@ static inline void armv7pmu_write_counter(struct perf_event *event, u32 value)
>  			smp_processor_id(), idx);
>  	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
>  		asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" (value));
> -	else if (armv7_pmnc_select_counter(idx) == idx)
> +	else {
> +		armv7_pmnc_select_counter(idx);
>  		asm volatile("mcr p15, 0, %0, c9, c13, 2" : : "r" (value));
> +	}

Likewise here.

Otherwise this looks like a nice cleanup to me, so with those changes:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

>  }
>  
>  static inline void armv7_pmnc_write_evtsel(int idx, u32 val)
>  {
> -	if (armv7_pmnc_select_counter(idx) == idx) {
> -		val &= ARMV7_EVTYPE_MASK;
> -		asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (val));
> -	}
> +	armv7_pmnc_select_counter(idx);
> +	val &= ARMV7_EVTYPE_MASK;
> +	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (val));
>  }
>  
> -static inline int armv7_pmnc_enable_counter(int idx)
> +static inline void armv7_pmnc_enable_counter(int idx)
>  {
>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>  	asm volatile("mcr p15, 0, %0, c9, c12, 1" : : "r" (BIT(counter)));
> -	return idx;
>  }
>  
> -static inline int armv7_pmnc_disable_counter(int idx)
> +static inline void armv7_pmnc_disable_counter(int idx)
>  {
>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>  	asm volatile("mcr p15, 0, %0, c9, c12, 2" : : "r" (BIT(counter)));
> -	return idx;
>  }
>  
> -static inline int armv7_pmnc_enable_intens(int idx)
> +static inline void armv7_pmnc_enable_intens(int idx)
>  {
>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>  	asm volatile("mcr p15, 0, %0, c9, c14, 1" : : "r" (BIT(counter)));
> -	return idx;
>  }
>  
> -static inline int armv7_pmnc_disable_intens(int idx)
> +static inline void armv7_pmnc_disable_intens(int idx)
>  {
>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>  	asm volatile("mcr p15, 0, %0, c9, c14, 2" : : "r" (BIT(counter)));
> @@ -643,8 +641,6 @@ static inline int armv7_pmnc_disable_intens(int idx)
>  	/* Clear the overflow flag in case an interrupt is pending. */
>  	asm volatile("mcr p15, 0, %0, c9, c12, 3" : : "r" (BIT(counter)));
>  	isb();
> -
> -	return idx;
>  }
>  
>  static inline u32 armv7_pmnc_getreset_flags(void)
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
