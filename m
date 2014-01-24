Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaAXTwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:52:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64195 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751139AbaAXTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:52:04 -0500
Date: Fri, 24 Jan 2014 14:51:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <bitbucket@online.de>,
        Joakim Hernberg <jbh@alchemy.lu>, Joe Korty <joe.korty@ccur.com>,
        Muli Baron <muli.baron@gmail.com>
Subject: [PATCH RT] timer: Run irq_work() even if there are no active timers
Message-ID: <20140124145157.1f30d447@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After trying hard to figure out why my i7 box was locking up with the
new active_timers code, that does not run the timer softirq if there
are no active timers, I took an extra look at the softirq handler and
noticed that it doesn't just run timer softirqs, it also runs irq work.

This was the bug that was locking up the system. It wasn't missing a
timer, it was missing irq work. By always doing the irq work callbacks,
the system boots fine.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/timer.c b/kernel/timer.c
index 46467be..7c5026e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1464,8 +1464,12 @@ void run_local_timers(void)
 		raise_softirq(TIMER_SOFTIRQ);
 		return;
 	}
-	if (!base->active_timers)
+	if (!base->active_timers) {
+#if defined(CONFIG_IRQ_WORK) && defined(CONFIG_PREEMPT_RT_FULL)
+		irq_work_run();
+#endif
 		goto out;
+	}
 
 	/* Check whether the next pending timer has expired */
 	if (time_before_eq(base->next_timer, jiffies))
