Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab3GZXrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:47:17 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:62642 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab3GZXnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:43:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 05/21] nohz: Only enable context tracking on full dynticks CPUs
Date: Sat, 27 Jul 2013 01:42:28 +0200
Message-Id: <1374882164-32519-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374882164-32519-1-git-send-email-fweisbec@gmail.com>
References: <1374882164-32519-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The context tracking subsystem has the ability to selectively
enable the tracking on any defined subset of CPU. This means that
we can define a CPU range that doesn't run the context tracking
and another range that does.

Now what we want in practice is to enable the tracking on full
dynticks CPUs only. In order to perform this, we just need to pass
our full dynticks CPU range selection from the full dynticks
subsystem to the context tracking.

This way we can spare the overhead of RCU user extended quiescent
state and vtime maintainance on the CPUs that are outside the
full dynticks range. Just keep in mind the raw context tracking
itself is still necessary everywhere.

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
 kernel/context_tracking.c        |    5 +++++
 kernel/time/tick-sched.c         |    4 ++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index d883ff0..1ae37c7 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -34,6 +34,8 @@ static inline bool context_tracking_active(void)
 	return __this_cpu_read(context_tracking.active);
 }
 
+extern void context_tracking_cpu_set(int cpu);
+
 extern void user_enter(void);
 extern void user_exit(void);
 
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
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e80183f..6d604fd 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -23,6 +23,7 @@
 #include <linux/irq_work.h>
 #include <linux/posix-timers.h>
 #include <linux/perf_event.h>
+#include <linux/context_tracking.h>
 
 #include <asm/irq_regs.h>
 
@@ -350,6 +351,9 @@ void __init tick_nohz_init(void)
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

