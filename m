Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbaJVLbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:31:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:10298 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932474AbaJVLbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:31:10 -0400
X-IronPort-AV: E=Sophos;i="5.04,768,1406563200"; 
   d="scan'208";a="37725716"
Message-ID: <54479472.9060004@cn.fujitsu.com>
Date: Wed, 22 Oct 2014 19:26:42 +0800
From: Chai Wen <chaiw.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "yuichi.kusakabe@jp.fujitsu.com" <yuichi.kusakabe@jp.fujitsu.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH 1/2] ARM: perf: armv7 remove useless return and check
 of idx in counter handling
References: <1413966107-11881-1-git-send-email-chaiw.fnst@cn.fujitsu.com> <20141022104742.GD22642@leverpostej>
In-Reply-To: <20141022104742.GD22642@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 06:47 PM, Mark Rutland wrote:

> Hi,
> 
> On Wed, Oct 22, 2014 at 09:21:46AM +0100, chai wen wrote:
>> Idx sanity check was once implemented separately in these counter handling
>> functions and then return value was treated as a judgement.
>> 	armv7_pmnc_select_counter()
>> 	armv7_pmnc_enable_counter()
>> 	armv7_pmnc_disable_counter()
>> 	armv7_pmnc_enable_intens()
>> 	armv7_pmnc_disable_intens()
>> But we do not need to do this now, and the return of idx is useless.
>>
>> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
> 
> It looks like the validation was moved out of all of these functions in
> 7279adbd9bb8ef8f (ARM: perf: check ARMv7 counter validity on a per-pmu
> basis), and we just missed the opportunity to simplify callers at the
> time.
> 
> It would be nice if we mentioned that in the commit message -- it takes
> a while to figure out and it's handy for reference.
> 


Yeah, sorry for forgetting to point out that.

>> ---
>>  arch/arm/kernel/perf_event_v7.c |   32 ++++++++++++++------------------
>>  1 files changed, 14 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
>> index 116758b..f66a9b8 100644
>> --- a/arch/arm/kernel/perf_event_v7.c
>> +++ b/arch/arm/kernel/perf_event_v7.c
>> @@ -564,13 +564,11 @@ static inline int armv7_pmnc_counter_has_overflowed(u32 pmnc, int idx)
>>  	return pmnc & BIT(ARMV7_IDX_TO_COUNTER(idx));
>>  }
>>  
>> -static inline int armv7_pmnc_select_counter(int idx)
>> +static inline void armv7_pmnc_select_counter(int idx)
>>  {
>>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>>  	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (counter));
>>  	isb();
>> -
>> -	return idx;
>>  }
>>  
>>  static inline u32 armv7pmu_read_counter(struct perf_event *event)
>> @@ -585,8 +583,10 @@ static inline u32 armv7pmu_read_counter(struct perf_event *event)
>>  			smp_processor_id(), idx);
>>  	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
>>  		asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (value));
>> -	else if (armv7_pmnc_select_counter(idx) == idx)
>> +	else {
>> +		armv7_pmnc_select_counter(idx);
>>  		asm volatile("mrc p15, 0, %0, c9, c13, 2" : "=r" (value));
>> +	}
> 
> Please make the braces consistent -- if one branch in an if .. else
> chain needs them, they all do (see Documentation/CodingStyle).
> 
>>  
>>  	return value;
>>  }
>> @@ -602,40 +602,38 @@ static inline void armv7pmu_write_counter(struct perf_event *event, u32 value)
>>  			smp_processor_id(), idx);
>>  	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
>>  		asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" (value));
>> -	else if (armv7_pmnc_select_counter(idx) == idx)
>> +	else {
>> +		armv7_pmnc_select_counter(idx);
>>  		asm volatile("mcr p15, 0, %0, c9, c13, 2" : : "r" (value));
>> +	}
> 
> Likewise here.
> 
> Otherwise this looks like a nice cleanup to me, so with those changes:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>


Thanks for your review. I'll send a update version later.

thanks
chai wen

> 
> Thanks,
> Mark.
> 
>>  }
>>  
>>  static inline void armv7_pmnc_write_evtsel(int idx, u32 val)
>>  {
>> -	if (armv7_pmnc_select_counter(idx) == idx) {
>> -		val &= ARMV7_EVTYPE_MASK;
>> -		asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (val));
>> -	}
>> +	armv7_pmnc_select_counter(idx);
>> +	val &= ARMV7_EVTYPE_MASK;
>> +	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (val));
>>  }
>>  
>> -static inline int armv7_pmnc_enable_counter(int idx)
>> +static inline void armv7_pmnc_enable_counter(int idx)
>>  {
>>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>>  	asm volatile("mcr p15, 0, %0, c9, c12, 1" : : "r" (BIT(counter)));
>> -	return idx;
>>  }
>>  
>> -static inline int armv7_pmnc_disable_counter(int idx)
>> +static inline void armv7_pmnc_disable_counter(int idx)
>>  {
>>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>>  	asm volatile("mcr p15, 0, %0, c9, c12, 2" : : "r" (BIT(counter)));
>> -	return idx;
>>  }
>>  
>> -static inline int armv7_pmnc_enable_intens(int idx)
>> +static inline void armv7_pmnc_enable_intens(int idx)
>>  {
>>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>>  	asm volatile("mcr p15, 0, %0, c9, c14, 1" : : "r" (BIT(counter)));
>> -	return idx;
>>  }
>>  
>> -static inline int armv7_pmnc_disable_intens(int idx)
>> +static inline void armv7_pmnc_disable_intens(int idx)
>>  {
>>  	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
>>  	asm volatile("mcr p15, 0, %0, c9, c14, 2" : : "r" (BIT(counter)));
>> @@ -643,8 +641,6 @@ static inline int armv7_pmnc_disable_intens(int idx)
>>  	/* Clear the overflow flag in case an interrupt is pending. */
>>  	asm volatile("mcr p15, 0, %0, c9, c12, 3" : : "r" (BIT(counter)));
>>  	isb();
>> -
>> -	return idx;
>>  }
>>  
>>  static inline u32 armv7_pmnc_getreset_flags(void)
>> -- 
>> 1.7.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> .
> 



-- 
Regards

Chai Wen
