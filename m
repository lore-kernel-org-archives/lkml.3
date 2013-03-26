Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3CZW4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:56:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3CZWw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 61/72] nohz: Make tick_nohz_irq_exit() irq safe
Date: Tue, 26 Mar 2013 15:51:44 -0700
Message-Id: <20130326224925.972873650@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Link: http://lkml.kernel.org/r/1361373336-11337-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-sched.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -496,12 +496,17 @@ void tick_nohz_idle_enter(void)
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


