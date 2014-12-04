Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbaLDN6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:58:13 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:65004 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaLDN6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:58:11 -0500
Message-ID: <5480686C.2070205@linaro.org>
Date: Thu, 04 Dec 2014 13:58:04 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v2 1/2] arm: perf: Prevent wraparound during overflow
References: <1416412346-8759-1-git-send-email-daniel.thompson@linaro.org> <1416587067-3220-1-git-send-email-daniel.thompson@linaro.org> <1416587067-3220-2-git-send-email-daniel.thompson@linaro.org> <20141204102612.GB14519@arm.com>
In-Reply-To: <20141204102612.GB14519@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/14 10:26, Will Deacon wrote:
> On Fri, Nov 21, 2014 at 04:24:26PM +0000, Daniel Thompson wrote:
>> If the overflow threshold for a counter is set above or near the
>> 0xffffffff boundary then the kernel may lose track of the overflow
>> causing only events that occur *after* the overflow to be recorded.
>> Specifically the problem occurs when the value of the performance counter
>> overtakes its original programmed value due to wrap around.
>>
>> Typical solutions to this problem are either to avoid programming in
>> values likely to be overtaken or to treat the overflow bit as the 33rd
>> bit of the counter.
>>
>> Its somewhat fiddly to refactor the code to correctly handle the 33rd bit
>> during irqsave sections (context switches for example) so instead we take
>> the simpler approach of avoiding values likely to be overtaken.
>>
>> We set the limit to half of max_period because this matches the limit
>> imposed in __hw_perf_event_init(). This causes a doubling of the interrupt
>> rate for large threshold values, however even with a very fast counter
>> ticking at 4GHz the interrupt rate would only be ~1Hz.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>
> 
> You'll probably need to refresh this at -rc1 as there are a bunch of
> changes queued for this file already. Then you can stick it into rmk's
> patch system.

I'll do that. Thanks.


> 
> Cheers,
> 
> Will
> 
>> ---
>>  arch/arm/kernel/perf_event.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
>> index 266cba46db3e..ab68833c1e31 100644
>> --- a/arch/arm/kernel/perf_event.c
>> +++ b/arch/arm/kernel/perf_event.c
>> @@ -115,8 +115,14 @@ int armpmu_event_set_period(struct perf_event *event)
>>  		ret = 1;
>>  	}
>>  
>> -	if (left > (s64)armpmu->max_period)
>> -		left = armpmu->max_period;
>> +	/*
>> +	 * Limit the maximum period to prevent the counter value
>> +	 * from overtaking the one we are about to program. In
>> +	 * effect we are reducing max_period to account for
>> +	 * interrupt latency (and we are being very conservative).
>> +	 */
>> +	if (left > (armpmu->max_period >> 1))
>> +		left = armpmu->max_period >> 1;
>>  
>>  	local64_set(&hwc->prev_count, (u64)-left);
>>  
>> -- 
>> 1.9.3
>>
>>

