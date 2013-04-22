Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3DVTAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:00:18 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:64399 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3DVTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 15:00:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/10] nohz: Re-evaluate the tick from the scheduler IPI
Date: Mon, 22 Apr 2013 20:59:42 +0200
Message-Id: <1366657186-20556-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler IPI is used by the scheduler to kick
full dynticks CPUs asynchronously when more than one
task are running or when a new timer list timer is
enqueued. This way the destination CPU can decide
to restart the tick to handle this new situation.

Now let's call that kick in the scheduler IPI.

(Reusing the scheduler IPI rather than implementing
a new IPI was suggested by Peter Zijlstra a while ago)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/tick.h     |    2 ++
 kernel/sched/core.c      |    4 +++-
 kernel/time/tick-sched.c |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index d290168..e31e676 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -160,11 +160,13 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 #ifdef CONFIG_NO_HZ_FULL
 extern void tick_nohz_init(void);
 extern int tick_nohz_full_cpu(int cpu);
+extern void tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_all(void);
 #else
 static inline void tick_nohz_init(void) { }
 static inline int tick_nohz_full_cpu(int cpu) { return 0; }
+static inline void tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 69f7133..9ad3500 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1398,7 +1398,8 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
-	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
+	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
+	    && !tick_nohz_full_cpu(smp_processor_id()))
 		return;
 
 	/*
@@ -1415,6 +1416,7 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
+	tick_nohz_full_check();
 	sched_ttwu_pending();
 
 	/*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 884a9f3..4d74a68 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -151,7 +151,7 @@ bool have_nohz_full_mask;
  * Re-evaluate the need for the tick on the current CPU
  * and restart it if necessary.
  */
-static void tick_nohz_full_check(void)
+void tick_nohz_full_check(void)
 {
 	/*
 	 * STUB for now, will be filled with the full tick stop/restart
-- 
1.7.5.4

