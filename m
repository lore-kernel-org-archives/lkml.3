Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3BVBg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:36:28 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:62648 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab3BVBgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:36:21 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 1/2] irq: Remove IRQ_EXIT_OFFSET workaround
Date: Fri, 22 Feb 2013 02:36:10 +0100
Message-Id: <1361496971-16939-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361496971-16939-1-git-send-email-fweisbec@gmail.com>
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ_EXIT_OFFSET trick was used to make sure the irq
doesn't get preempted after we substract the HARDIRQ_OFFSET
until we are entirely done with any code in irq_exit().

This workaround was necessary because some archs may call
irq_exit() with irqs enabled and there is still some code
in the end of this function that is not covered by the
HARDIRQ_OFFSET but want to stay non-preemptible.

Now that irq are always disabled in irq_exit(), the whole code
is guaranteed not to be preempted. We can thus remove this hack.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/hardirq.h |    2 --
 kernel/softirq.c        |    3 +--
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 29eb805..c1d6555 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -118,10 +118,8 @@
 
 #ifdef CONFIG_PREEMPT_COUNT
 # define preemptible()	(preempt_count() == 0 && !irqs_disabled())
-# define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
 #else
 # define preemptible()	0
-# define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
 #endif
 
 #if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 24a921b..f42ff97 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -343,7 +343,7 @@ void irq_exit(void)
 
 	account_irq_exit_time(current);
 	trace_hardirq_exit();
-	sub_preempt_count(IRQ_EXIT_OFFSET);
+	sub_preempt_count(HARDIRQ_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
@@ -353,7 +353,6 @@ void irq_exit(void)
 		tick_nohz_irq_exit();
 #endif
 	rcu_irq_exit();
-	sched_preempt_enable_no_resched();
 #ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
 	local_irq_restore(flags);
 #endif
-- 
1.7.5.4

