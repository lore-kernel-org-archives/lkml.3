Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaIJVdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:33:38 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44885 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaIJVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:33:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 1/8] nohz: Move nohz full init call to tick init
Date: Wed, 10 Sep 2014 23:33:21 +0200
Message-Id: <1410384808-14760-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we unbloat a bit main.c and more importantly we initialize
nohz full after init_IRQ(). This dependency will be needed in further
patches because nohz full needs irq work to raise its own IRQ.
Information about the support for this ability on ARM64 is obtained on
init_IRQ() which initialize the pointer to __smp_call_function.

Since tick_init() is called right after init_IRQ(), this is a good place
to call tick_nohz_init() and prepare for that dependency.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/tick.h        | 2 --
 init/main.c                 | 1 -
 kernel/time/tick-common.c   | 1 +
 kernel/time/tick-internal.h | 7 +++++++
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0590523..97fb83e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -181,7 +181,6 @@ static inline bool tick_nohz_full_cpu(int cpu)
 	return cpumask_test_cpu(cpu, tick_nohz_full_mask);
 }
 
-extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick_cpu(int cpu);
 
@@ -193,7 +192,6 @@ static inline void tick_nohz_full_kick(void)
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 #else
-static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void __tick_nohz_full_check(void) { }
diff --git a/init/main.c b/init/main.c
index bb1aed9..8af2f1a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -577,7 +577,6 @@ asmlinkage __visible void __init start_kernel(void)
 		local_irq_disable();
 	idr_init_cache();
 	rcu_init();
-	tick_nohz_init();
 	context_tracking_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 0a0608e..052b4b5 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -400,4 +400,5 @@ void tick_resume(void)
 void __init tick_init(void)
 {
 	tick_broadcast_init();
+	tick_nohz_init();
 }
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index c19c1d8..366aeb4 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -99,6 +99,13 @@ static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline bool tick_broadcast_oneshot_available(void) { return false; }
 #endif /* !TICK_ONESHOT */
 
+/* NO_HZ_FULL internal */
+#ifdef CONFIG_NO_HZ_FULL
+extern void tick_nohz_init(void);
+# else
+static inline void tick_nohz_init(void) { }
+#endif
+
 /*
  * Broadcasting support
  */
-- 
2.1.0

