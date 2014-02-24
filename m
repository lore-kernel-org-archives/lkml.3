Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaBXTZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:25:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaBXTZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:25:08 -0500
Date: Mon, 24 Feb 2014 20:25:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main
 function
Message-ID: <20140224192501.GO6835@laptop.programming.kicks-ass.net>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
 <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org>
 <20140224145912.GW27965@twins.programming.kicks-ass.net>
 <530B679C.6070204@linaro.org>
 <20140224160543.GZ9987@twins.programming.kicks-ass.net>
 <530B7B4E.50306@linaro.org>
 <20140224172207.GC9987@twins.programming.kicks-ass.net>
 <530B97B9.8020502@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B97B9.8020502@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 08:04:25PM +0100, Daniel Lezcano wrote:
> >+		/*
> >+		 * Since we fell out of the loop above, we know
> >+		 * TIF_NEED_RESCHED must be set, propagate it into
> >+		 * PREEMPT_NEED_RESCHED.
> >+		 *
> >+		 * This is required because for polling idle loops we will
> >+		 * not have had an IPI to fold the state for us.
> >+		 */
> >+		preempt_set_need_resched();
> >  		tick_nohz_idle_exit();
> >  		schedule_preempt_disabled();
> 
> So IIUC, the mainloop has two states: one where it is blocked on a HLT/WFI
> instruction (or about to enter/ exit this state) and another one outside of
> this blocking section.

Almost; on x86 we have an monitor/mwait construct that blocks waiting
for a cacheline write. We point it at the thread_info->flags line. So
the TIF_NEED_RESCHED write from the other CPU wakes us up.

So no need to send an IPI after we write that flag.

> When the idle task is blocked on HLT/WFI, it needs the IPI-reschedule in
> order to be woken up and rescheduled. But if it is outside this section, the
> idle task is not waiting for an interrupt and an expensive IPI can be saved
> by just setting the TS_POLLING flag, the scheduler will check this flag and
> won't send the IPI.
> 
> But 'set_preempt_need_resched' is called from the IPI handler. So if no IPI
> is sent because the idle task is in polling state, we have to set it
> ourself.
> 
> Now, the difference between the old code with 'tif_need_resched()' is
> because we don't need to check it because it is always true.
> 
> Am I right ?

Yah, also it closes a very narrow window where TIF_NEED_RESCHED wasn't
set at the end of the while (!need_resched()) but is at the top.

