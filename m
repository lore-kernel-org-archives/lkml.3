Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaE1ALJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:11:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59686 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaE1ALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:11:07 -0400
Message-ID: <53852999.7060907@codeaurora.org>
Date: Tue, 27 May 2014 17:11:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with irqsoff
 tracers
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org> <17051981.niWmA6MIgX@wuerfel> <20140527174847.7b405b5c@gandalf.local.home> <53850FF3.8050107@codeaurora.org> <20140527193050.4606a014@gandalf.local.home>
In-Reply-To: <20140527193050.4606a014@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/14 16:30, Steven Rostedt wrote:
> On Tue, 27 May 2014 15:21:39 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>
>>> Arnd brings up a good point. 
>> Hrm.. still not getting Arnd's mails.
> Strange. What mail service do you have. Could they be blocking him?
>
>>> If we disable irqs off tracing completely,
>>> we may be missing places in the idle path that disable interrupts for
>>> long periods of time. We may want to move the stop down further.
>>>
>>> The way it works (IIRC), and why tracing can start again is that it can
>>> nest. Perhaps we need to stop it further down if we can't move it
>>> completely.
>>>
>> I'm not sure how much deeper it can go and I'm afraid it will become a
>> game of whack-a-mole. I already see two places that disable and reenable
>> irqs after stop_critical_timings() is called (first in rcu_idle_enter()
>> and second in clockevents_notify()). Should rcu_idle_enter() move to
>> raw_local_irq_save()? It looks like that path calls rcu_sched_qs() and
>> on tiny RCU that again needs the raw_ treatement. We can probably call
>> stop_critical_timings() after rcu_idle_enter() to fix this.
> I don't think we need to whack-a-mole. The start stop should be around
> where it goes to sleep.
>
>> What about clockevents_notify? __raw_spin_lock_irqsave() should probably
>> use raw_local_irqsave().
> No that solution is even worse. We need lockdep working here.
>
>> If we go the raw route, do we even need stop/start_critical_timings()?
>> Can't we just use raw accessors in the idle paths
>> (tick_nohz_idle_{enter,exit}(), cpuidle_enter(), etc.) and get rid of
>> the stop/start stuff completely? I admit this patch is pretty much a big
>> sledge hammer that tries to make things simple, but if there is some
>> benefit to the raw accessors I'm willing to send patches to fix all the
>> call sites.
>>
> How about the following. I don't see any reason stop_critical_timings()
> can't be called from within rcu_idle code, as it doesn't use any rcu.
>
> Paul, Peter, see anything wrong with this?
>

cpuidle_enter_state() calls ktime_get() which on lockdep enabled builds
calls seqcount_lockdep_reader_access() which calls local_irq_save() that
then turns on the tracer again. Perhaps the problem is that irqsoff
tracer is triggered even when we aren't transitioning between irqs on
and irqs off? What about this patch? I assume there is a reason that
this is wrong, but I don't know what it is.

---8<-----

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index d176d658fe25..ac8e0a4968bd 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -93,7 +93,8 @@
 #define local_irq_save(flags)				\
 	do {						\
 		raw_local_irq_save(flags);		\
-		trace_hardirqs_off();			\
+		if (!raw_irqs_disabled_flags(flags))	\
+			trace_hardirqs_off();		\
 	} while (0)
 
 
@@ -101,7 +102,6 @@
 	do {						\
 		if (raw_irqs_disabled_flags(flags)) {	\
 			raw_local_irq_restore(flags);	\
-			trace_hardirqs_off();		\
 		} else {				\
 			trace_hardirqs_on();		\
 			raw_local_irq_restore(flags);	\

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

