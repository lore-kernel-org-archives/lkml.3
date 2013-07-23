Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3GWAbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:31:53 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:60875 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab3GWAbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:31:22 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 7/8] perf: Finer grained full dynticks kick
Date: Tue, 23 Jul 2013 02:31:05 +0200
Message-Id: <1374539466-4799-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the full dynticks subsystem keep the
tick alive as long as there are perf events running.

This prevents the tick from being stopped as long as features
such that the lockup detectors are running. As a temporary fix,
the lockup detector is disabled by default when full dynticks
is built but this is not a long term viable solution.

To fix this, only keep the tick alive when an event configured
with a frequency rather than a period is running on the CPU,
or when an event throttles on the CPU.

These are the only purposes of the perf tick, especially now that
the rotation of flexible events is handled from a seperate hrtimer.
The tick can be shutdown the rest of the time.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f9bd39b..61d70b7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -870,12 +870,8 @@ static void perf_pmu_rotate_start(struct pmu *pmu)
 
 	WARN_ON(!irqs_disabled());
 
-	if (list_empty(&cpuctx->rotation_list)) {
-		int was_empty = list_empty(head);
+	if (list_empty(&cpuctx->rotation_list))
 		list_add(&cpuctx->rotation_list, head);
-		if (was_empty)
-			tick_nohz_full_kick();
-	}
 }
 
 static void get_ctx(struct perf_event_context *ctx)
@@ -1875,6 +1871,9 @@ static int  __perf_install_in_context(void *info)
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, task_ctx);
 
+	if (atomic_read(&__get_cpu_var(perf_freq_events)))
+		tick_nohz_full_kick();
+
 	return 0;
 }
 
@@ -2812,10 +2811,11 @@ done:
 #ifdef CONFIG_NO_HZ_FULL
 bool perf_event_can_stop_tick(void)
 {
-	if (list_empty(&__get_cpu_var(rotation_list)))
-		return true;
-	else
+	if (atomic_read(&__get_cpu_var(perf_freq_events)) ||
+	    __this_cpu_read(perf_throttled_count))
 		return false;
+	else
+		return true;
 }
 #endif
 
@@ -5201,6 +5201,7 @@ static int __perf_event_overflow(struct perf_event *event,
 			__this_cpu_inc(perf_throttled_count);
 			hwc->interrupts = MAX_INTERRUPTS;
 			perf_log_throttle(event, 0);
+			tick_nohz_full_kick();
 			ret = 1;
 		}
 	}
-- 
1.7.5.4

