Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaCADwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 22:52:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:12219 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752134AbaCADwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 22:52:37 -0500
Message-Id: <20140301035236.228845249@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 28 Feb 2014 22:52:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>
Subject: [PATCH RT 03/14] timer: Raise softirq if theres irq_work
References: <20140301035209.031474616@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-timer-Raise-softirq-if-there-s-irq_work.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.32-rt31-rc2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Talking with Sebastian on IRC, it seems that doing the irq_work_run()
  from the interrupt in -rt is a bad thing. Here we simply raise the
  softirq if there's irq work to do. This too boots on my i7 ]

After trying hard to figure out why my i7 box was locking up with the
new active_timers code, that does not run the timer softirq if there
are no active timers, I took an extra look at the softirq handler and
noticed that it doesn't just run timer softirqs, it also runs irq work.

This was the bug that was locking up the system. It wasn't missing a
timer, it was missing irq work. By always doing the irq work callbacks,
the system boots fine. The missing irq work callback was the RCU's
sp_wakeup() function.

No need to check for defined(CONFIG_IRQ_WORK). When that's not set the
"irq_work_needs_cpu()" is a static inline that returns false.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/timer.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 3d7313c..25a38c4 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1466,8 +1466,13 @@ void run_local_timers(void)
 		return;
 	}
 #endif
-	if (!base->active_timers)
-		goto out;
+	if (!base->active_timers) {
+#ifdef CONFIG_PREEMPT_RT_FULL
+		/* On RT, irq work runs from softirq */
+		if (!irq_work_needs_cpu())
+#endif
+			goto out;
+	}
 
 	/* Check whether the next pending timer has expired */
 	if (time_before_eq(base->next_timer, jiffies))
-- 
1.8.5.3


