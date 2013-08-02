Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3HBQaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:30:09 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39368 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3HBQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:30:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf: Account freq events globally
Date: Fri,  2 Aug 2013 18:29:55 +0200
Message-Id: <1375460996-16329-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375460996-16329-1-git-send-email-fweisbec@gmail.com>
References: <1375460996-16329-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freq events may not always be affine to a particular CPU. As such,
account_event_cpu() may crash if we account per cpu a freq event
that has event->cpu == -1.

To solve this, lets account freq events globally. In practice
this doesn't change much the picture because perf tools create
per-task perf events with one event per CPU by default. Profiling a
single CPU is usually a corner case so there is no much point in
optimizing things that way.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Suggested-by: Peter Zijlstra <peterz@infradead.or>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 916cf1f..617f980 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -141,11 +141,11 @@ enum event_type_t {
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
-static DEFINE_PER_CPU(atomic_t, perf_freq_events);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
+static atomic_t nr_freq_events __read_mostly;
 
 static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
@@ -1871,9 +1871,6 @@ static int  __perf_install_in_context(void *info)
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, task_ctx);
 
-	if (atomic_read(&__get_cpu_var(perf_freq_events)))
-		tick_nohz_full_kick();
-
 	return 0;
 }
 
@@ -2811,7 +2808,7 @@ done:
 #ifdef CONFIG_NO_HZ_FULL
 bool perf_event_can_stop_tick(void)
 {
-	if (atomic_read(&__get_cpu_var(perf_freq_events)) ||
+	if (atomic_read(&nr_freq_events) ||
 	    __this_cpu_read(perf_throttled_count))
 		return false;
 	else
@@ -3140,9 +3137,6 @@ static void unaccount_event_cpu(struct perf_event *event, int cpu)
 	}
 	if (is_cgroup_event(event))
 		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
-
-	if (event->attr.freq)
-		atomic_dec(&per_cpu(perf_freq_events, cpu));
 }
 
 static void unaccount_event(struct perf_event *event)
@@ -3158,6 +3152,8 @@ static void unaccount_event(struct perf_event *event)
 		atomic_dec(&nr_comm_events);
 	if (event->attr.task)
 		atomic_dec(&nr_task_events);
+	if (event->attr.freq)
+		atomic_dec(&nr_freq_events);
 	if (is_cgroup_event(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
 	if (has_branch_stack(event))
@@ -6479,9 +6475,6 @@ static void account_event_cpu(struct perf_event *event, int cpu)
 	}
 	if (is_cgroup_event(event))
 		atomic_inc(&per_cpu(perf_cgroup_events, cpu));
-
-	if (event->attr.freq)
-		atomic_inc(&per_cpu(perf_freq_events, cpu));
 }
 
 static void account_event(struct perf_event *event)
@@ -6497,6 +6490,10 @@ static void account_event(struct perf_event *event)
 		atomic_inc(&nr_comm_events);
 	if (event->attr.task)
 		atomic_inc(&nr_task_events);
+	if (event->attr.freq) {
+		if (atomic_inc_return(&nr_freq_events) == 1)
+			tick_nohz_full_kick_all();
+	}
 	if (has_branch_stack(event))
 		static_key_slow_inc(&perf_sched_events.key);
 	if (is_cgroup_event(event))
-- 
1.7.5.4

