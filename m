Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaJWBdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 21:33:24 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:26662 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752801AbaJWBdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 21:33:22 -0400
X-IronPort-AV: E=Sophos;i="5.04,772,1406563200"; 
   d="scan'208";a="37777973"
Message-ID: <544859D3.3000703@cn.fujitsu.com>
Date: Thu, 23 Oct 2014 09:28:51 +0800
From: Chai Wen <chaiw.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yuichi.kusakabe@jp.fujitsu.com" <yuichi.kusakabe@jp.fujitsu.com>
Subject: Re: [PATCH resend] ARM: perf: remove useless return and check of
 idx in counter handling
References: <1413980209-14913-1-git-send-email-chaiw.fnst@cn.fujitsu.com> <20141022123153.GH22642@leverpostej>
In-Reply-To: <20141022123153.GH22642@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 08:31 PM, Mark Rutland wrote:

> On Wed, Oct 22, 2014 at 01:16:49PM +0100, chai wen wrote:
>> Idx sanity check was once implemented separately in these counter
>> handling functions and then return value was treated as a judgement.
>> 	armv7_pmnc_select_counter()
>> 	armv7_pmnc_enable_counter()
>> 	armv7_pmnc_disable_counter()
>> 	armv7_pmnc_enable_intens()
>> 	armv7_pmnc_disable_intens()
>> But we do not need to do this now, as idx validation check was moved
>> out all these functions by commit 7279adbd9bb8ef8f(ARM: perf: check ARMv7
>> counter validity on a per-pmu basis).
>> Let's remove the useless return of idx from these functions.
> 
> In future when you fix up a patch, please send as "PATCHv2" (or v3, etc
> as appropriate), and only as "PATCH RESEND" if there are no changes. It
> makes it far easier to keep track of the stat of the patch. Don't worry
> about sending again this time, however.
> 


Thanks a lot for your exact description about difference between 'resend' and 'v1..v2..'.
(Sincerely speaking, I did not know the true meaning of the 'resend', although
I have done the 'resend' for times before :( )
Will follow up this in the future.

> Thanks for fixing up the braces since v1; this looks good to me.
> 



thanks
chai wen

> Mark.
> 
>>
>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
>> ---
>>  arch/arm/kernel/perf_event_v7.c |   40 +++++++++++++++++---------------------
>>  1 files changed, 18 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
>> index 116758b..aaf5314 100644
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
>> @@ -580,13 +578,15 @@ static inline u32 armv7pmu_read_counter(struct perf_event *event)
>>  	int idx = hwc->idx;
>>  	u32 value = 0;
>>  
>> -	if (!armv7_pmnc_counter_valid(cpu_pmu, idx))
>> +	if (!armv7_pmnc_counter_valid(cpu_pmu, idx)) {
>>  		pr_err("CPU%u reading wrong counter %d\n",
>>  			smp_processor_id(), idx);
>> -	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
>> +	} else if (idx == ARMV7_IDX_CYCLE_COUNTER) {
>>  		asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (value));
>> -	else if (armv7_pmnc_select_counter(idx) == idx)
>> +	} else {
>> +		armv7_pmnc_select_counter(idx);
>>  		asm volatile("mrc p15, 0, %0, c9, c13, 2" : "=r" (value));
>> +	}
>>  
>>  	return value;
>>  }
>> @@ -597,45 +597,43 @@ static inline void armv7pmu_write_counter(struct perf_event *event, u32 value)
>>  	struct hw_perf_event *hwc = &event->hw;
>>  	int idx = hwc->idx;
>>  
>> -	if (!armv7_pmnc_counter_valid(cpu_pmu, idx))
>> +	if (!armv7_pmnc_counter_valid(cpu_pmu, idx)) {
>>  		pr_err("CPU%u writing wrong counter %d\n",
>>  			smp_processor_id(), idx);
>> -	else if (idx == ARMV7_IDX_CYCLE_COUNTER)
>> +	} else if (idx == ARMV7_IDX_CYCLE_COUNTER) {
>>  		asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" (value));
>> -	else if (armv7_pmnc_select_counter(idx) == idx)
>> +	} else {
>> +		armv7_pmnc_select_counter(idx);
>>  		asm volatile("mcr p15, 0, %0, c9, c13, 2" : : "r" (value));
>> +	}
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
> .
> 



-- 
Regards

Chai Wen
