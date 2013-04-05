Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161728Ab3DEKEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:04:11 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38406 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3DEKEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:04:09 -0400
Message-ID: <515EA195.4010307@arm.com>
Date: Fri, 05 Apr 2013 11:04:05 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH] ARM: arch_timer: Silence debug preempt warnings
References: <1364934672-31554-1-git-send-email-sboyd@codeaurora.org> <515E5CFC.4090900@codeaurora.org>
In-Reply-To: <515E5CFC.4090900@codeaurora.org>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 05 Apr 2013 10:04:06.0030 (UTC) FILETIME=[E851C2E0:01CE31E4]
X-MC-Unique: 113040511040701201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 05/04/13 06:11, Stephen Boyd wrote:
> On 4/2/2013 1:31 PM, Stephen Boyd wrote:
>> Hot-plugging with CONFIG_DEBUG_PREEMPT=y on a device with arm
>> architected timers causes a slew of "using smp_processor_id() in
>> preemptible" warnings:
>>
>>   BUG: using smp_processor_id() in preemptible [00000000] code: sh/111
>>   caller is arch_timer_cpu_notify+0x14/0xc8
>>
>> This happens because sometimes the cpu notifier, arch_timer_cpu_notify(),
>> is called in preemptible context but we use this_cpu_ptr()
>> to retrieve the clockevent unconditionally. We're only going to
>> actually use the pointer in non-preemptible context though,
>> so use __this_cpu_ptr() instead to avoid the preemptible checks
>> and silence the warning.
>>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
> 
> Anyone else seeing this one?

Haven't seen this one occurring yet. I suspect my compiler is optimizing
the code in ways that prevent the breakage from being seen.

> 
>>  drivers/clocksource/arm_arch_timer.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>> index d7ad425..5928c29 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -248,7 +248,7 @@ static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
>>  static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
>>  					   unsigned long action, void *hcpu)
>>  {
>> -	struct clock_event_device *evt = this_cpu_ptr(arch_timer_evt);
>> +	struct clock_event_device *evt = __this_cpu_ptr(arch_timer_evt);
>>  
>>  	switch (action & ~CPU_TASKS_FROZEN) {
>>  	case CPU_STARTING:

I'm afraid this would hide bugs if we start using the notifier for other
purposes than exclusivity non-preemptible contexts.

How about moving the this_cpu_ptr() down to the cases themselves, maybe
with a nice comment?

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...

