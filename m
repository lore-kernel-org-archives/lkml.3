Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3CDJuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:50:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:57513 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab3CDJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:50:39 -0500
Date: Mon, 4 Mar 2013 10:50:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] irq urgent updates for 3.9-rc1
Message-ID: <alpine.LFD.2.02.1303041046380.22263@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

* "e5ab012: nohz: Make tick_nohz_irq_exit() irq safe" is the first
  commit in the series and the minimal necessary bugfix, which needs
  to go back into stable.

* The remanining commits enforce irq disabling in irq_exit(), sanitize
  the hardirq/softirq preempt count transition and remove a bunch of
  not longer necessary conditionals.

Thanks,

	tglx

------------------>
Frederic Weisbecker (3):
      nohz: Make tick_nohz_irq_exit() irq safe
      irq: Remove IRQ_EXIT_OFFSET workaround
      irq: Don't re-enable interrupts at the end of irq_exit

Thomas Gleixner (3):
      irq: Ensure irq_exit() code runs with interrupts disabled
      irq: Sanitize invoke_softirq
      Revert "nohz: Make tick_nohz_irq_exit() irq safe"


 include/linux/hardirq.h |    2 --
 kernel/softirq.c        |   21 +++++++++------------
 2 files changed, 9 insertions(+), 14 deletions(-)

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
index f5cc25f..dce38fa 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -322,18 +322,10 @@ void irq_enter(void)
 
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads) {
-#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
+	if (!force_irqthreads)
 		__do_softirq();
-#else
-		do_softirq();
-#endif
-	} else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
+	else
 		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
 }
 
 /*
@@ -341,9 +333,15 @@ static inline void invoke_softirq(void)
  */
 void irq_exit(void)
 {
+#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
+	local_irq_disable();
+#else
+	WARN_ON_ONCE(!irqs_disabled());
+#endif
+
 	account_irq_exit_time(current);
 	trace_hardirq_exit();
-	sub_preempt_count(IRQ_EXIT_OFFSET);
+	sub_preempt_count(HARDIRQ_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
@@ -353,7 +351,6 @@ void irq_exit(void)
 		tick_nohz_irq_exit();
 #endif
 	rcu_irq_exit();
-	sched_preempt_enable_no_resched();
 }
 
 /*
