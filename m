Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaBXTE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:04:28 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39152 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaBXTE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:04:26 -0500
Message-ID: <530B97B9.8020502@linaro.org>
Date: Mon, 24 Feb 2014 20:04:25 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main
 function
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org> <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org> <20140224145912.GW27965@twins.programming.kicks-ass.net> <530B679C.6070204@linaro.org> <20140224160543.GZ9987@twins.programming.kicks-ass.net> <530B7B4E.50306@linaro.org> <20140224172207.GC9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140224172207.GC9987@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 06:22 PM, Peter Zijlstra wrote:
> On Mon, Feb 24, 2014 at 06:03:10PM +0100, Daniel Lezcano wrote:
>> Well there is the polling idle state for the x86 and ppc cpuidle drivers.
>> Except that, I think we have something more or less clean.
>
> Yeah, they have to set it back to polling again :/
>
> Ideally we'd sweep the entire tree and switch the default polling state
> to polling and add a current_clr_polling_and_test() to all WFI/HLT like
> ones that need the interrupt.
>
> But lots of work that.
>
>>> -	if (need_resched()) {
>>
>> Ok. The need_resched is now replaced by 'current_clr_polling_and_test', with
>> a call to '__current_set_polling()' to set the flag back, right ?
>
> Yah.
>
>> For my personal information, what is the subtlety with:
>>
>> if (tif_need_resched())
>> 	set_preempt_need_resched();
>>
>> ?
>
> Urgh, looks like something went wrong with: cf37b6b48428d
>
> That commit doesn't actually remove kernel/cpu/idle.c nor is the new
> code an exact replica of the old one.
>
> Ingo, any chance we can get that fixed?
>
> Daniel; does the below change/comment clarify?

Yes, I think so.

[ ... ]

> +
> +		/*
> +		 * Since we fell out of the loop above, we know
> +		 * TIF_NEED_RESCHED must be set, propagate it into
> +		 * PREEMPT_NEED_RESCHED.
> +		 *
> +		 * This is required because for polling idle loops we will
> +		 * not have had an IPI to fold the state for us.
> +		 */
> +		preempt_set_need_resched();
>   		tick_nohz_idle_exit();
>   		schedule_preempt_disabled();

So IIUC, the mainloop has two states: one where it is blocked on a 
HLT/WFI instruction (or about to enter/ exit this state) and another one 
outside of this blocking section.

When the idle task is blocked on HLT/WFI, it needs the IPI-reschedule in 
order to be woken up and rescheduled. But if it is outside this section, 
the idle task is not waiting for an interrupt and an expensive IPI can 
be saved by just setting the TS_POLLING flag, the scheduler will check 
this flag and won't send the IPI.

But 'set_preempt_need_resched' is called from the IPI handler. So if no 
IPI is sent because the idle task is in polling state, we have to set it 
ourself.

Now, the difference between the old code with 'tif_need_resched()' is 
because we don't need to check it because it is always true.

Am I right ?




-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

