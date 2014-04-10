Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965542AbaDJOjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:39:10 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39893 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965356AbaDJOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:39:07 -0400
Date: Thu, 10 Apr 2014 16:39:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
Message-ID: <20140410143857.GA27654@localhost.localdomain>
References: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
 <CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 04:19:44PM +0530, Viresh Kumar wrote:
> On 9 April 2014 16:03, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > Hi Frederic,
> >
> > File: kernel/time/tick-sched.c
> > Function: tick_nohz_full_stop_tick()
> >
> > We are doing this:
> >
> > if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
> >         return;
> >
> > Which means: if a FULL_NO_HZ cpu is running idle task currently,
> > don't stop its tick..
> >
> > I couldn't understand why. Can you please help here?
> 
> Is it because of this code ? :
> 
> void tick_nohz_irq_exit(void)
> {
>         struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> 
>         if (ts->inidle)
>                 __tick_nohz_idle_enter(ts);
>         else
>                 tick_nohz_full_stop_tick(ts);
> }
> 
> i.e. tick_nohz_full_stop_tick() would never be called while we have
> 'inidle' set or we are running idle task?
> 
> In this case as well, we don't really need that check to be present.

So I did that to avoid full dynticks to mess up with idle dynticks which
has special requirement, accounting and stuff that full dynticks doesn't
have.

For example in tick_nohz_irq_exit(), if we are in dyntick idle (ts->inidle && ts->tick_stopped)
and we call the above tick_nohz_full_stop_tick() instead of __tick_nohz_idle_enter(), we'll
bug the idle time accounting.

So I kept the tick_nohz_full_stop_tick() function away when the task is idle. But I've
been lazy by using is_idle_task(current) instead of ts->inidle.

Note that this also match __tick_nohz_full_check() that also doesn't restart the tick
when we are idle so to avoid messing up with dynticks idle. And it does that also because
it knows that full dyticks doesn't happen when we idle.

But yeah this is all suboptimal. We should rely on ts->inidle instead.
See below (untested):

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9f8af69..1e2d6b7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -202,13 +202,16 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now);
 void __tick_nohz_full_check(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	unsigned long flags;
 
+	local_irq_save(flags);
 	if (tick_nohz_full_cpu(smp_processor_id())) {
-		if (ts->tick_stopped && !is_idle_task(current)) {
+		if (ts->tick_stopped && !ts->inidle)) {
 			if (!can_stop_full_tick())
 				tick_nohz_restart_sched_tick(ts, ktime_get());
 		}
 	}
+	local_irq_restore(flags);
 }
 
 static void nohz_full_kick_work_func(struct irq_work *work)
@@ -681,7 +684,9 @@ static void tick_nohz_full_stop_tick(struct tick_sched *ts)
 #ifdef CONFIG_NO_HZ_FULL
 	int cpu = smp_processor_id();
 
-	if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
+	WARN_ON_ONCE(ts->inidle);
+
+	if (!tick_nohz_full_cpu(cpu))
 		return;
 
 	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)



---

There is a risk that ts->idle_jiffies snaphots get missed if tick_nohz_idle_enter()
is called when full dynticks is already on. But this was already possible if full
dynticks was already armed from a previous task. So nothing new.

If you like it I'll push it to Ingo.

Thanks.
