Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbaAaRIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:08:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:62759 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932633AbaAaRH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:07:59 -0500
Date: Fri, 31 Jan 2014 12:07:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work to
 do
Message-ID: <20140131120757.594e24d6@gandalf.local.home>
In-Reply-To: <1391178845-15837-2-git-send-email-bigeasy@linutronix.de>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
	<1391178845-15837-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 15:34:05 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> from looking at the code, it seems that the softirq is only raised (in
> the !base->active_timers case) if we have also an expired timer
> (time_before_eq() is true). This patch ensures that the timer softirq is
> also raised in the !base->active_timers && no timer expired.

A couple of things. If there is no active timers, we do not need to
check the expired timers. That may contain a deferred timer that does
not need to be raised if the system is idle. This will just
re-introduce the problems that other people have been seeing.

The bug that I found is that if there *are* active timers, but they
have not expired yet. Why is this a problem? Because in that case we do
not check if there is irq_work to be done. That means the irq_work will
have to wait till the timer expires, and since RCU depends on this,
that can take a while. I've had a synchronize_sched() take up to 5
seconds to complete due to this!


The real fix is the following:

timer/rt: Always raise the softirq if there's irq_work to be done

It was previously discovered that some systems would hang on boot up
with a previous version of 3.12-rt. This was due to RCU using irq_work,
and RT defers the irq_work to a softirq. But if there's no active
timers, the softirq will not be raised, and RCU work will not get done,
causing the system to hang.  The fix was to check that if there was no
active timers but irq_work to be done, then we should raise the softirq.

But this fix was not 100% correct. It left out the case that there were
active timers that were not expired yet. This would have the softirq
not get raised even if there was irq work to be done.

If there is irq_work to be done, then we must raise the timer softirq
regardless of if there is active timers or whether they are expired or
not. The softirq can handle those cases. But we can never ignore
irq_work.

As it is only PREEMPT_RT_FULL that requires irq_work to be done in the
softirq, we can pull out the check in the active_timers condition, and
make the code a bit cleaner by having the irq_work check separate, and
put the code in with the other #ifdef PREEMPT_RT. If there is irq_work
to be done, there's no need to check the active timers or if they are
expired. Just raise the time softirq and be done with it. Otherwise, we
can do the timer checks just like we do with non -rt.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/timer.c b/kernel/timer.c
index 106968f..426d114 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1461,18 +1461,20 @@ void run_local_timers(void)
 	 * the timer softirq.
 	 */
 #ifdef CONFIG_PREEMPT_RT_FULL
+	/* On RT, irq work runs from softirq */
+	if (irq_work_needs_cpu()) {
+		raise_softirq(TIMER_SOFTIRQ);
+		return;
+	}
+
 	if (!spin_do_trylock(&base->lock)) {
 		raise_softirq(TIMER_SOFTIRQ);
 		return;
 	}
 #endif
-	if (!base->active_timers) {
-#ifdef CONFIG_PREEMPT_RT_FULL
-		/* On RT, irq work runs from softirq */
-		if (!irq_work_needs_cpu())
-#endif
-			goto out;
-	}
+
+	if (!base->active_timers)
+		goto out;
 
 	/* Check whether the next pending timer has expired */
 	if (time_before_eq(base->next_timer, jiffies))
