Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab3GQQv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:51:58 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53987 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab3GQQox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:44:53 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 07/18] nohz: Selectively enable context tracking on full dynticks CPUs
Date: Wed, 17 Jul 2013 18:44:20 +0200
Message-Id: <1374079471-3129-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code is ready to do so in the context tracking subsystem, now
we just need to pass our cpu range selection to it from the
full dynticks subsystem.

This way we can spare the overhead of RCU user extended quiescent
state and vtime maintainance on these CPUs. Just keep in mind the
context tracking itself is still necessary everywhere.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
---
 include/linux/context_tracking.h |    2 ++
 init/Kconfig                     |    2 +-
 kernel/context_tracking.c        |    5 +++++
 kernel/time/Kconfig              |    1 -
 kernel/time/tick-sched.c         |    6 ++++++
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 12045ce..2c2b73aa 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -34,6 +34,8 @@ static inline bool context_tracking_active(void)
 	return __this_cpu_read(context_tracking.active);
 }
 
+extern void context_tracking_cpu_set(int cpu);
+
 extern void user_enter(void);
 extern void user_exit(void);
 
diff --git a/init/Kconfig b/init/Kconfig
index 247084b..914da3f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -527,7 +527,7 @@ config RCU_USER_QS
 config CONTEXT_TRACKING_FORCE
 	bool "Force context tracking"
 	depends on CONTEXT_TRACKING
-	default CONTEXT_TRACKING
+	default y if !NO_HZ_FULL
 	help
 	  Probe on user/kernel boundaries by default in order to
 	  test the features that rely on it such as userspace RCU extended
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 7b095de..72bcb25 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -26,6 +26,11 @@ DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 #endif
 };
 
+void context_tracking_cpu_set(int cpu)
+{
+	per_cpu(context_tracking.active, cpu) = true;
+}
+
 /**
  * user_enter - Inform the context tracking that the CPU is going to
  *              enter userspace mode.
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 70f27e8..747bbc7 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -105,7 +105,6 @@ config NO_HZ_FULL
 	select RCU_USER_QS
 	select RCU_NOCB_CPU
 	select VIRT_CPU_ACCOUNTING_GEN
-	select CONTEXT_TRACKING_FORCE
 	select IRQ_WORK
 	help
 	 Adaptively try to shutdown the tick whenever possible, even when
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 088c411..062759e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -23,6 +23,7 @@
 #include <linux/irq_work.h>
 #include <linux/posix-timers.h>
 #include <linux/perf_event.h>
+#include <linux/context_tracking.h>
 
 #include <asm/irq_regs.h>
 
@@ -344,11 +345,16 @@ static int tick_nohz_init_all(void)
 
 void __init tick_nohz_init(void)
 {
+	int cpu;
+
 	if (!have_nohz_full_mask) {
 		if (tick_nohz_init_all() < 0)
 			return;
 	}
 
+	for_each_cpu(cpu, nohz_full_mask)
+		context_tracking_cpu_set(cpu);
+
 	cpu_notifier(tick_nohz_cpu_down_callback, 0);
 	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), nohz_full_mask);
 	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
-- 
1.7.5.4

