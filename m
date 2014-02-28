Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaB1Nha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:37:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:14162 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752315AbaB1Nfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:35:39 -0500
Message-Id: <20140228133535.654535597@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 28 Feb 2014 08:34:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 03/11] timer/rt: Always raise the softirq if theres irq_work to be done
References: <20140228133454.373761937@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-timer-rt-Always-raise-the-softirq-if-there-s-irq_wor.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.32-rt31-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

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

Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/timer.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 25a38c4..f63a793 100644
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
-- 
1.8.5.3


