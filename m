Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaAQRXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:23:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:54981 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAQRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:23:22 -0500
Date: Fri, 17 Jan 2014 18:23:19 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
Cc: paulmck@linux.vnet.ibm.com, linux-rt-users@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
Message-ID: <20140117172319.GH5785@linutronix.de>
References: <20131221193900.GA8427@linutronix.de>
 <1387681647.5412.25.camel@marge.simpson.net>
 <1387702631.5412.101.camel@marge.simpson.net>
 <1387773533.5369.16.camel@marge.simpson.net>
 <20131224193636.GD19211@linux.vnet.ibm.com>
 <1387940854.5373.8.camel@marge.simpson.net>
 <1388052212.5420.4.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1388052212.5420.4.camel@marge.simpson.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith | 2013-12-26 11:03:32 [+0100]:

>On Wed, 2013-12-25 at 04:07 +0100, Mike Galbraith wrote:
>> On Tue, 2013-12-24 at 11:36 -0800, Paul E. McKenney wrote: 
>
>> > So which code do you think deserves the big lump of coal?  ;-)
>> 
>> Sebastian's NO_HZ_FULL locking fixes.
>
>Whack-a-mole hasn't yet dug up any new moles.
>
>---
> kernel/timer.c |    4 ++++
> 1 file changed, 4 insertions(+)
>
>Index: linux-2.6/kernel/timer.c
>===================================================================
>--- linux-2.6.orig/kernel/timer.c
>+++ linux-2.6/kernel/timer.c
>@@ -764,7 +764,9 @@ __mod_timer(struct timer_list *timer, un
> 	timer_stats_timer_set_start_info(timer);
> 	BUG_ON(!timer->function);
> 
>+	local_irq_disable_rt();
> 	base = lock_timer_base(timer, &flags);
>+	local_irq_enable_rt();
> 
> 	ret = detach_if_pending(timer, base, false);
> 	if (!ret && pending_only)
>@@ -1198,7 +1200,9 @@ static inline void __run_timers(struct t
> {
> 	struct timer_list *timer;
> 
>+	local_irq_disable_rt();
> 	spin_lock_irq(&base->lock);
>+	local_irq_enable_rt();
> 	while (time_after_eq(jiffies, base->timer_jiffies)) {
> 		struct list_head work_list;
> 		struct list_head *head = &work_list;
>---
> kernel/time/tick-sched.c |    2 ++
> 1 file changed, 2 insertions(+)

So I had rtmutex-take-the-waiter-lock-with-irqs-off.patch in my queue
which took the waiter lock with irqs off. This should be the same thing
you try do here.

>Index: linux-2.6/kernel/time/tick-sched.c
>===================================================================
>--- linux-2.6.orig/kernel/time/tick-sched.c
>+++ linux-2.6/kernel/time/tick-sched.c
>@@ -216,7 +216,9 @@ void __tick_nohz_full_check(void)
> 
> static void nohz_full_kick_work_func(struct irq_work *work)
> {
>+	local_irq_disable_rt();
> 	__tick_nohz_full_check();
>+	local_irq_enable_rt();
> }

and this should be fixed differently. Since we come from a thread and
check "is current running" but by current we mean a user task and not a
kernel thread.

> 
> static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
>

Sebastian
