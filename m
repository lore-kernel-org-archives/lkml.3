Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaHNVMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:12:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50329 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaHNVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:12:31 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <53ED263B.7030703@mit.edu>
Date: Thu, 14 Aug 2014 14:12:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Chuansheng Liu <chuansheng.liu@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, changcheng.liu@intel.com,
        xiaoming.wang@intel.com, souvik.k.chakravarty@intel.com
Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com> <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com> <20140814110040.GI16043@twins.programming.kicks-ass.net> <53EC9A29.8090408@linaro.org>
In-Reply-To: <53EC9A29.8090408@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 04:14 AM, Daniel Lezcano wrote:
> On 08/14/2014 01:00 PM, Peter Zijlstra wrote:
>>
>> So seeing how you're from @intel.com I'm assuming you're using x86 here.
>>
>> I'm not seeing how this can be possible, MWAIT is interrupted by IPIs
>> just fine, which means we'll fall out of the cpuidle_enter(), which
>> means we'll cpuidle_reflect(), and then leave cpuidle_idle_call().
>>
>> It will indeed not leave the cpu_idle_loop() function and go right back
>> into cpuidle_idle_call(), but that will then call cpuidle_select() which
>> should pick a new C state.
>>
>> So the interrupt _should_ work. If it doesn't you need to explain why.
> 
> I think the issue is related to the poll_idle state, in
> drivers/cpuidle/driver.c. This state is x86 specific and inserted in the
> cpuidle table as the state 0 (POLL). There is no mwait for this state.
> It is a bit confusing because this state is not listed in the acpi /
> intel idle driver but inserted implicitly at the beginning of the idle
> table by the cpuidle framework when the driver is registered.
> 
> static int poll_idle(struct cpuidle_device *dev,
>                 struct cpuidle_driver *drv, int index)
> {
>         local_irq_enable();
>         if (!current_set_polling_and_test()) {
>                 while (!need_resched())
>                         cpu_relax();
>         }
>         current_clr_polling();
> 
>         return index;
> }

As the most recent person to have modified this function, and as an
avowed hater of pointless IPIs, let me ask a rather different question:
why are you sending IPIs at all?  As of Linux 3.16, poll_idle actually
supports the polling idle interface :)

Can't you just do:

if (set_nr_if_polling(rq->idle)) {
	trace_sched_wake_idle_without_ipi(cpu);
} else {
	spin_lock_irqsave(&rq->lock, flags);
	if (rq->curr == rq->idle)
		smp_send_reschedule(cpu);
	// else the CPU wasn't idle; nothing to do
	raw_spin_unlock_irqrestore(&rq->lock, flags);
}

In the common case (wake from C0, i.e. polling idle), this will skip the
IPI entirely unless you race with idle entry/exit, saving a few more
precious electrons and all of the latency involved in poking the APIC
registers.

--Andy

P.S. "30mV" in the patch description is presumably a typo.
