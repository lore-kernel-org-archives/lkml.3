Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3DVVIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:08:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51098 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3DVVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:08:36 -0400
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
Subject: [PATCH 2/2] nohz: Add basic tracing
Date: Mon, 22 Apr 2013 23:08:25 +0200
Message-Id: <1366664905-21884-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366664905-21884-1-git-send-email-fweisbec@gmail.com>
References: <1366664905-21884-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not obvious to find out why the full dynticks subsystem
doesn't always stop the tick: whether this is due to kthreads,
posix timers, perf events, etc...

These new tracepoints are here to help the user diagnose
the failures and test this feature.

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
 include/trace/events/timer.h |   21 +++++++++++++++++++++
 kernel/time/tick-sched.c     |   19 +++++++++++++++----
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 425bcfe..f5eb53e 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -323,6 +323,27 @@ TRACE_EVENT(itimer_expire,
 		  (int) __entry->pid, (unsigned long long)__entry->now)
 );
 
+#ifdef CONFIG_NO_HZ_FULL
+TRACE_EVENT(tick_stop,
+
+	TP_PROTO(int success, char *error_msg),
+
+	TP_ARGS(success, error_msg),
+
+	TP_STRUCT__entry(
+		__field( int ,		success	)
+		__string( msg, 		error_msg )
+	),
+
+	TP_fast_assign(
+		__entry->success	= success;
+		__assign_str(msg, error_msg);
+	),
+
+	TP_printk("success=%s msg=%s",  __entry->success ? "yes" : "no", __get_str(msg))
+);
+#endif
+
 #endif /*  _TRACE_TIMER_H */
 
 /* This part must be outside protection */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 12a900d..85e05ab 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -28,6 +28,8 @@
 
 #include "tick-internal.h"
 
+#include <trace/events/timer.h>
+
 /*
  * Per cpu nohz control structure
  */
@@ -153,14 +155,20 @@ static bool can_stop_full_tick(void)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (!sched_can_stop_tick())
+	if (!sched_can_stop_tick()) {
+		trace_tick_stop(0, "more than 1 task in runqueue\n");
 		return false;
+	}
 
-	if (!posix_cpu_timers_can_stop_tick(current))
+	if (!posix_cpu_timers_can_stop_tick(current)) {
+		trace_tick_stop(0, "posix timers running\n");
 		return false;
+	}
 
-	if (!perf_event_can_stop_tick())
+	if (!perf_event_can_stop_tick()) {
+		trace_tick_stop(0, "perf events running\n");
 		return false;
+	}
 
 	/* sched_clock_tick() needs us? */
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
@@ -168,8 +176,10 @@ static bool can_stop_full_tick(void)
 	 * TODO: kick full dynticks CPUs when
 	 * sched_clock_stable is set.
 	 */
-	if (!sched_clock_stable)
+	if (!sched_clock_stable) {
+		trace_tick_stop(0, "unstable sched clock\n");
 		return false;
+	}
 #endif
 
 	return true;
@@ -631,6 +641,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
+			trace_tick_stop(1, " ");
 		}
 
 		/*
-- 
1.7.5.4

