Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3BURqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:46:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab3BURqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:46:30 -0500
Date: Thu, 21 Feb 2013 09:43:53 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-493c60613d2d0b2fa6b3f7e2d3299ee4fef52b76@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, torvalds@linuxfoundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, torvalds@linuxfoundation.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <1361373336-11337-1-git-send-email-fweisbec@gmail.com>
References: <1361373336-11337-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] nohz: Make tick_nohz_irq_exit() irq safe
Git-Commit-ID: 493c60613d2d0b2fa6b3f7e2d3299ee4fef52b76
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Feb 2013 09:43:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  493c60613d2d0b2fa6b3f7e2d3299ee4fef52b76
Gitweb:     http://git.kernel.org/tip/493c60613d2d0b2fa6b3f7e2d3299ee4fef52b76
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 20 Feb 2013 16:15:36 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 21 Feb 2013 18:32:44 +0100

nohz: Make tick_nohz_irq_exit() irq safe

As it stands, irq_exit() may or may not be called with
irqs disabled, depending on __ARCH_IRQ_EXIT_IRQS_DISABLED
that the arch can define.

It makes tick_nohz_irq_exit() unsafe. For example two
interrupts can race in tick_nohz_stop_sched_tick(): the inner
most one computes the expiring time on top of the timer list,
then it's interrupted right before reprogramming the
clock. The new interrupt enqueues a new timer list timer,
it reprogram the clock to take it into account and it exits.
The CPUs resumes the inner most interrupt and performs the clock
reprogramming without considering the new timer list timer.

This regression has been introduced by:
     280f06774afedf849f0b34248ed6aff57d0f6908
     ("nohz: Separate out irq exit and idle loop dyntick logic")

Let's fix it right now with the appropriate protections.

A saner long term solution will be to remove
__ARCH_IRQ_EXIT_IRQS_DISABLED and mandate that irq_exit() is called
with interrupts disabled.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: <stable@vger.kernel.org> #v3.2+
Link: http://lkml.kernel.org/r/1361373336-11337-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 314b9ee..520592a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -565,14 +565,19 @@ void tick_nohz_idle_enter(void)
  */
 void tick_nohz_irq_exit(void)
 {
+	unsigned long flags;
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
 	if (!ts->inidle)
 		return;
 
-	/* Cancel the timer because CPU already waken up from the C-states*/
+	local_irq_save(flags);
+
+	/* Cancel the timer because CPU already waken up from the C-states */
 	menu_hrtimer_cancel();
 	__tick_nohz_idle_enter(ts);
+
+	local_irq_restore(flags);
 }
 
 /**
