Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaJXHb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:31:29 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:46637 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755756AbaJXHb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:31:27 -0400
X-IronPort-AV: E=Sophos;i="5.04,778,1406563200"; 
   d="scan'208";a="38658295"
Message-ID: <5449FF3E.6080108@cn.fujitsu.com>
Date: Fri, 24 Oct 2014 15:26:54 +0800
From: Chai Wen <chaiw.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: <will.deacon@arm.com>
CC: chai wen <chaiw.fnst@cn.fujitsu.com>, <mark.rutland@arm.com>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <yuichi.kusakabe@jp.fujitsu.com>
Subject: Re: [PATCH resend] ARM: perf: remove useless return and check of
 idx in counter handling
References: <1413980209-14913-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
In-Reply-To: <1413980209-14913-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will

Ping...


thanks
chai wen

On 10/22/2014 08:16 PM, chai wen wrote:

> Idx sanity check was once implemented separately in these counter
> handling functions and then return value was treated as a judgement.
> 	armv7_pmnc_select_counter()
> 	armv7_pmnc_enable_counter()
> 	armv7_pmnc_disable_counter()
> 	armv7_pmnc_enable_intens()
> 	armv7_pmnc_disable_intens()
> But we do not need to do this now, as idx validation check was moved
> out all these functions by commit 7279adbd9bb8ef8f(ARM: perf: check ARMv7
> counter validity on a per-pmu basis).
> Let's remove the useless return of idx from these functions.
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
> ---
>  arch/arm/kernel/perf_event_v7.c |   40 +++++++++++++++++---------------------
>  1 files changed, 18 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
> index 116758b..aaf5314 100644
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
> @@ -580,13 +578,15 @@ static inline u32 armv7pmu_read_counter(struct perf_event *event)
>  	int idx = hwc->idx;
>  	u32 value = 0;
>  
> -	if (!armv7_pmnc_counter_valid(cpu_pmu, idx))
> +	if (!armv7_pmnc_counter_valid(cpu_pmu, idx)) {
>  		pr_err("CPU%u reading wrong counter %d\n",
>  			smp_processor_id(), idx);
> -	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
> +	} else if (idx == ARMV7_IDX_CYCLE_COUNTER) {
>  		asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (value));
> -	else if (armv7_pmnc_select_counter(idx) == idx)
> +	} else {
> +		armv7_pmnc_select_counter(idx);
>  		asm volatile("mrc p15, 0, %0, c9, c13, 2" : "=r" (value));
> +	}
>  
>  	return value;
>  }
> @@ -597,45 +597,43 @@ static inline void armv7pmu_write_counter(struct perf_event *event, u32 value)
>  	struct hw_perf_event *hwc = &event->hw;
>  	int idx = hwc->idx;
>  
> -	if (!armv7_pmnc_counter_valid(cpu_pmu, idx))
> +	if (!armv7_pmnc_counter_valid(cpu_pmu, idx)) {
>  		pr_err("CPU%u writing wrong counter %d\n",
>  			smp_processor_id(), idx);
> -	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
> +	} else if (idx == ARMV7_IDX_CYCLE_COUNTER) {
>  		asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" (value));
> -	else if (armv7_pmnc_select_counter(idx) == idx)
> +	} else {
> +		armv7_pmnc_select_counter(idx);
>  		asm volatile("mcr p15, 0, %0, c9, c13, 2" : : "r" (value));
> +	}
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



-- 
Regards

Chai Wen
