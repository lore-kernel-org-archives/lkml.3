Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaBXPjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:39:10 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46817 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaBXPjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:39:08 -0500
Message-ID: <530B679C.6070204@linaro.org>
Date: Mon, 24 Feb 2014 16:39:08 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main
 function
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org> <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org> <20140224145912.GW27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140224145912.GW27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 03:59 PM, Peter Zijlstra wrote:
> On Mon, Feb 24, 2014 at 02:55:50PM +0100, Daniel Lezcano wrote:
>> @@ -136,25 +155,8 @@ static void cpu_idle_loop(void)
>>   			local_irq_disable();
>>   			arch_cpu_idle_enter();
>>
>> -			/*
>> -			 * In poll mode we reenable interrupts and spin.
>> -			 *
>> -			 * Also if we detected in the wakeup from idle
>> -			 * path that the tick broadcast device expired
>> -			 * for us, we don't want to go deep idle as we
>> -			 * know that the IPI is going to arrive right
>> -			 * away
>> -			 */
>> -			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
>> -				cpu_idle_poll();
>> -			} else {
>> -				if (!current_clr_polling_and_test()) {
>> -					cpuidle_idle_call();
>> -				} else {
>> -					local_irq_enable();
>> -				}
>> -				__current_set_polling();
>> -			}
>> +			cpuidle_idle_call();
>> +
>
> Yeah, not liking that much; you can make it look like:
>
> 	if (cpu_idle_force_poll || tick_check_broadcast_expired())
> 		cpu_idle_poll();
> 	else
> 		cpu_idle_call();
>
> Though. That keeps the polling case separate from the actual idle
> function.

Yes, you are right, it looks better.

> And when you do that; you can also push down the
> current_clr_polling_and_test() muck so it doesn't cover the actual
> cpuidle policy code.

I am not getting it. Where do you suggest to move it ?

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

