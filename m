Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936550Ab3DHKUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:20:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935505Ab3DHJva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 019/102] nohz: Make tick_nohz_irq_exit() irq safe
Date: Mon,  8 Apr 2013 10:49:34 +0100
Message-Id: <1365414657-29191-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit e5ab012c3271990e8457055c25cafddc1ae8aa6b upstream.

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
[ luis: backported to 3.5 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/tick-sched.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4a08472..cc1825f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -500,12 +500,17 @@ void tick_nohz_idle_enter(void)
  */
 void tick_nohz_irq_exit(void)
 {
+	unsigned long flags;
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
 	if (!ts->inidle)
 		return;
 
+	local_irq_save(flags);
+
 	tick_nohz_stop_sched_tick(ts);
+
+	local_irq_restore(flags);
 }
 
 /**
-- 
1.8.1.2

