Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaBIKIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 05:08:13 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:47190 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaBIKIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 05:08:11 -0500
Message-ID: <52F752AF.7000805@linux.vnet.ibm.com>
Date: Sun, 09 Feb 2014 15:34:31 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: tglx@linutronix.de, fengguang.wu@intel.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time/cpuidle:Fixup fallout from hrtimer broadcast mode
 inclusion
References: <20140207172924.8248.55002.stgit@preeti> <alpine.DEB.2.02.1402082329410.8686@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402082329410.8686@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020910-5140-0000-0000-00000487822B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I have sent out a revised patch on
https://lkml.org/lkml/2014/2/9/2. Can you let me
know if this works for you?

Thanks

Regards
Preeti U Murthy

On 02/09/2014 01:01 PM, David Rientjes wrote:
> On Fri, 7 Feb 2014, Preeti U Murthy wrote:
> 
>> The broadcast timer registration has to be done only when
>> GENERIC_CLOCKEVENTS_BROADCAST and TICK_ONESHOT config options are enabled.
>> Also fix max_delta_ticks value for the pseudo clock device.
>>
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> ---
>>
>>  kernel/time/tick-broadcast-hrtimer.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
>> index 5591aaa..bc383ac 100644
>> --- a/kernel/time/tick-broadcast-hrtimer.c
>> +++ b/kernel/time/tick-broadcast-hrtimer.c
>> @@ -81,7 +81,7 @@ static struct clock_event_device ce_broadcast_hrtimer = {
>>  	.min_delta_ns		= 1,
>>  	.max_delta_ns		= KTIME_MAX,
>>  	.min_delta_ticks	= 1,
>> -	.max_delta_ticks	= KTIME_MAX,
>> +	.max_delta_ticks	= ULONG_MAX,
>>  	.mult			= 1,
>>  	.shift			= 0,
>>  	.cpumask		= cpu_all_mask,
>> @@ -102,9 +102,11 @@ static enum hrtimer_restart bc_handler(struct hrtimer *t)
>>  	return HRTIMER_RESTART;
>>  }
>>  
>> +#if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
>>  void tick_setup_hrtimer_broadcast(void)
>>  {
>>  	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
>>  	bctimer.function = bc_handler;
>>  	clockevents_register_device(&ce_broadcast_hrtimer);
>>  }
>> +#endif
> 
> I see a build error in timers/core today:
> 
> kernel/time/tick-broadcast-hrtimer.c:101:6: error: redefinition of 'tick_setup_hrtimer_broadcast'
> include/linux/clockchips.h:194:20: note: previous definition of 'tick_setup_hrtimer_broadcast' was here
> 
> and I assume this is the intended fix for that, although it isn't 
> mentioned in the changelog.
> 
> After it's applied, this is left over:
> 
> kernel/time/tick-broadcast-hrtimer.c:91:29: warning: ‘bc_handler’ defined but not used [-Wunused-function]
> 

