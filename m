Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaHUOxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:53:10 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43349 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaHUOxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 2/9] nohz: Move nohz full init call to tick init
Date: Thu, 21 Aug 2014 16:52:50 +0200
Message-Id: <1408632777-3348-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we unbloat a bit main.c and more importantly we initialize
nohz full after init_IRQ(). This dependency will be needed in further
patches because nohz full depends on irq work to raise its own IRQ.
This ability, on ARM64, is obtained only after init_IRQ() which initialize
the pointer to __smp_call_function.

Cc: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Dave Jones <davej@redhat.com>
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
index 9a82c7d..595ee86 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -181,14 +181,12 @@ static inline bool tick_nohz_full_cpu(int cpu)
 	return cpumask_test_cpu(cpu, tick_nohz_full_mask);
 }
 
-extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_cpu(int cpu);
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
1.8.3.1

