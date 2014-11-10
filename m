Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaKJPTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:19:50 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36052 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaKJPTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:19:49 -0500
Message-ID: <5460D5EF.2000805@linaro.org>
Date: Mon, 10 Nov 2014 16:12:47 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 2/6] sched: idle: cpuidle: Check the latency req before
 idle
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org> <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org> <20141110124111.GN3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141110124111.GN3337@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 01:41 PM, Peter Zijlstra wrote:
> On Fri, Nov 07, 2014 at 03:31:23PM +0100, Daniel Lezcano wrote:
>> @@ -216,19 +219,26 @@ static void cpu_idle_loop(void)
>>   			local_irq_disable();
>>   			arch_cpu_idle_enter();
>>
>> +			latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
>> +
>>   			/*
>>   			 * In poll mode we reenable interrupts and spin.
>>   			 *
>> +			 * If the latency req is zero, we don't want to
>> +			 * enter any idle state and we jump to the poll
>> +			 * function directly
>> +			 *
>>   			 * Also if we detected in the wakeup from idle
>>   			 * path that the tick broadcast device expired
>>   			 * for us, we don't want to go deep idle as we
>>   			 * know that the IPI is going to arrive right
>>   			 * away
>>   			 */
>> -			if (cpu_idle_force_poll || tick_check_broadcast_expired())
>> +			if (!latency_req || cpu_idle_force_poll ||
>> +			    tick_check_broadcast_expired())
>>   				cpu_idle_poll();
>
> Is this why you wanted that weak poll function?

Not only there, it will be added in the next patchset in the 
cpu_idle_call function.

> Should we not instead allow an arch to deal with !latency_req and only
> fall back to this polling if there is no actual way for it to implement
> this better?

All this is to remove the poll idle state from the x86 cpuidle driver in 
order to remove the CPUIDLE_DRIVER_STATE_START (this one forces to write 
always ugly code in the cpuidle framework).

This poll state introduces the CPUIDLE_DRIVER_STATE_START macro. If you 
look at the different governors and the code, you can checkout what kind 
of tricks this macro introduces and how that makes the code ugly.

For the sake of what ? Just a small optimization in the menu governor.

I suppose that has been introduce and then evolved on a wrong basis. So 
now we have to deal with that.

This patchset provides a first round of cleanup around the poll 
function, the next patchset will move the 5us timer optimization from 
the menu governor and the last patchset will remove the 
CPUIDLE_DRIVER_STATE_START ugly macro.





-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

