Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3DFQqM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:46:12 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51280 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3DFQqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:46:10 -0400
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
Subject: [PATCH 1/7] sched: Update rq clock on nohz CPU before migrating tasks
Date: Sat,  6 Apr 2013 18:45:54 +0200
Message-Id: <1365266760-24725-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the sched_class::put_prev_task() callback of rt and fair
classes are referring to the rq clock to update their runtime
statistics. A CPU running in tickless mode may carry a stale value.
We need to update it there.

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
 kernel/sched/core.c  |    7 +++++++
 kernel/sched/sched.h |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e91ee58..1826e00 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4946,6 +4946,13 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
+	/*
+	 * put_prev_task() and pick_next_task() sched
+	 * class method both need to have an up-to-date
+	 * value of rq->clock[_task]
+	 */
+	update_nohz_rq_clock(rq);
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3bd15a4..96f7333 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -5,6 +5,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
+#include <linux/tick.h>
 
 #include "cpupri.h"
 
@@ -1115,6 +1116,12 @@ static inline void dec_nr_running(struct rq *rq)
 
 extern void update_rq_clock(struct rq *rq);
 
+static inline void update_nohz_rq_clock(struct rq *rq)
+{
+	if (tick_nohz_extended_cpu(cpu_of(rq)))
+		update_rq_clock(rq);
+}
+
 extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
 extern void deactivate_task(struct rq *rq, struct task_struct *p, int flags);
 
-- 
1.7.5.4

