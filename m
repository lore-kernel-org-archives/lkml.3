Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3DVTBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:01:12 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:55053 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab3DVTAK (ORCPT
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
Subject: [PATCH 08/10] nohz: Prepare to stop the tick on irq exit
Date: Mon, 22 Apr 2013 20:59:44 +0200
Message-Id: <1366657186-20556-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt exit is a natural place to stop the tick: it happens
after all events happening before and during the irq which
are liable to update the dependency on the tick occured. Also
it makes sure that any check on tick dependency is well ordered
against dynticks kick IPIs.

Bring in the infrastructure that performs the tick dependency
checks on irq exit and shut it down if these checks show that we
can do it safely.

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
 kernel/time/tick-sched.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 95d79ae..d0ed190 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -647,6 +647,24 @@ out:
 	return ret;
 }
 
+static void tick_nohz_full_stop_tick(struct tick_sched *ts)
+{
+#ifdef CONFIG_NO_HZ_FULL
+       int cpu = smp_processor_id();
+
+       if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
+               return;
+
+       if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
+	       return;
+
+       if (!can_stop_full_tick())
+               return;
+
+       tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
+#endif
+}
+
 static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 {
 	/*
@@ -773,12 +791,13 @@ void tick_nohz_irq_exit(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
-	if (!ts->inidle)
-		return;
-
-	/* Cancel the timer because CPU already waken up from the C-states*/
-	menu_hrtimer_cancel();
-	__tick_nohz_idle_enter(ts);
+	if (ts->inidle) {
+		/* Cancel the timer because CPU already waken up from the C-states*/
+		menu_hrtimer_cancel();
+		__tick_nohz_idle_enter(ts);
+	} else {
+		tick_nohz_full_stop_tick(ts);
+	}
 }
 
 /**
-- 
1.7.5.4

