Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab3DFQqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:46:25 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40696 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3DFQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:46:22 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 7/7] sched: Debug nohz rq clock
Date: Sat,  6 Apr 2013 18:46:00 +0200
Message-Id: <1365266760-24725-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The runqueue clock progression is maintained in 3 ways:

* Periodically with the timer tick

* On an as needed basis through update_rq_clock() calls
when we want a fresh update or we want to update the rq
clock of a dynticks CPU

* On full dynticks CPUs with explicit calls to
update_nohz_rq_clock()

But it's easy to miss some rq clock updates in the middle
of the tricky scheduler code paths.

So let's add some automatic debug check for stale rq
clock values when we read these. For now this just
consists in warning when we read an rq clock that hasn't
been updated for more than 30 seconds. We need a bit of
an error margin due to wheezy rq clock updates on boot.

We can certainly do some more clever check, considering
rq->skip_clock_update for example, and perhaps the rq clock
doesn't always need a fresh update on every place so
that detection is perhaps not relevant in every case.

But we need to start somewhere.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched/sched.h |   30 ++++++++++++++++++++++++++++++
 lib/Kconfig.debug    |   11 +++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 529e318..fecaba3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -536,16 +536,46 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+/*
+ * Warn after 30 seconds elapsed since the last rq clock update.
+ * We define a large error margin because rq updates can take some
+ * time on boot.
+ */
+#define RQ_CLOCK_MAX_DELAY (NSEC_PER_SEC * 30)
+
+/*
+ * The rq clock is periodically updated by the tick. rq clock
+ * from nohz CPUs require some explicit updates before reading.
+ * This tries to detect the places where we are missing those.
+ */
+static inline void rq_clock_check(struct rq *rq)
+{
+#ifdef CONFIG_NO_HZ_DEBUG
+	unsigned long long clock;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	clock = sched_clock_cpu(cpu_of(rq));
+	local_irq_restore(flags);
+
+	if (abs(clock - rq->clock) > RQ_CLOCK_MAX_DELAY)
+		WARN_ON_ONCE(1);
+#endif
+}
+
 static inline u64 rq_clock(struct rq *rq)
 {
+	rq_clock_check(rq);
 	return rq->clock;
 }
 
 static inline u64 rq_clock_task(struct rq *rq)
 {
+	rq_clock_check(rq);
 	return rq->clock_task;
 }
 
+
 #ifdef CONFIG_SMP
 
 #define rcu_dereference_check_sched_domain(p) \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28be08c..54b6e08 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1099,6 +1099,17 @@ config DEBUG_PER_CPU_MAPS
 
 	  Say N if unsure.
 
+config NO_HZ_DEBUG
+	bool "Debug dynamic timer tick"
+	depends on DEBUG_KERNEL
+	depends on NO_HZ || NO_HZ_EXTENDED
+	help
+	  Perform some sanity checks when the dynticks infrastructure
+	  is enabled. This adds some runtime overhead that you don't
+	  want to have in production.
+
+	  Say N if unsure.
+
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_FS
-- 
1.7.5.4

