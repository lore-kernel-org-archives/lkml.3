Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaHNVXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:23:09 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43864 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaHNVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:23:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140814211656.GV19379@twins.programming.kicks-ass.net>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
 <20140814110040.GI16043@twins.programming.kicks-ass.net> <53EC9A29.8090408@linaro.org>
 <53ED263B.7030703@mit.edu> <20140814211656.GV19379@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 14 Aug 2014 14:22:45 -0700
Message-ID: <CALCETrUEWAbzk3S=T93qh-j4xhwoVrUCqhybr_rr1n-uynQTvw@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, changcheng.liu@intel.com,
        xiaoming.wang@intel.com, souvik.k.chakravarty@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 2:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Aug 14, 2014 at 02:12:27PM -0700, Andy Lutomirski wrote:
>> On 08/14/2014 04:14 AM, Daniel Lezcano wrote:
>> > On 08/14/2014 01:00 PM, Peter Zijlstra wrote:
>> >>
>> >> So seeing how you're from @intel.com I'm assuming you're using x86 here.
>> >>
>> >> I'm not seeing how this can be possible, MWAIT is interrupted by IPIs
>> >> just fine, which means we'll fall out of the cpuidle_enter(), which
>> >> means we'll cpuidle_reflect(), and then leave cpuidle_idle_call().
>> >>
>> >> It will indeed not leave the cpu_idle_loop() function and go right back
>> >> into cpuidle_idle_call(), but that will then call cpuidle_select() which
>> >> should pick a new C state.
>> >>
>> >> So the interrupt _should_ work. If it doesn't you need to explain why.
>> >
>> > I think the issue is related to the poll_idle state, in
>> > drivers/cpuidle/driver.c. This state is x86 specific and inserted in the
>> > cpuidle table as the state 0 (POLL). There is no mwait for this state.
>> > It is a bit confusing because this state is not listed in the acpi /
>> > intel idle driver but inserted implicitly at the beginning of the idle
>> > table by the cpuidle framework when the driver is registered.
>> >
>> > static int poll_idle(struct cpuidle_device *dev,
>> >                 struct cpuidle_driver *drv, int index)
>> > {
>> >         local_irq_enable();
>> >         if (!current_set_polling_and_test()) {
>> >                 while (!need_resched())
>> >                         cpu_relax();
>> >         }
>> >         current_clr_polling();
>> >
>> >         return index;
>> > }
>>
>> As the most recent person to have modified this function, and as an
>> avowed hater of pointless IPIs, let me ask a rather different question:
>> why are you sending IPIs at all?  As of Linux 3.16, poll_idle actually
>> supports the polling idle interface :)
>>
>> Can't you just do:
>>
>> if (set_nr_if_polling(rq->idle)) {
>>       trace_sched_wake_idle_without_ipi(cpu);
>> } else {
>>       spin_lock_irqsave(&rq->lock, flags);
>>       if (rq->curr == rq->idle)
>>               smp_send_reschedule(cpu);
>>       // else the CPU wasn't idle; nothing to do
>>       raw_spin_unlock_irqrestore(&rq->lock, flags);
>> }
>>
>> In the common case (wake from C0, i.e. polling idle), this will skip the
>> IPI entirely unless you race with idle entry/exit, saving a few more
>> precious electrons and all of the latency involved in poking the APIC
>> registers.
>
> They could and they probably should, but that logic should _not_ live in
> the cpuidle driver.

Sure.  My point is that fixing the IPI handler is, I think, totally
bogus, because the IPI API isn't the right way to do this at all.

It would be straightforward to add a new function wake_if_idle(int
cpu) to sched/core.c.

--Andy
