Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3GWAc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:32:28 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:53553 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3GWAbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:31:18 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/8] perf: Split per cpu event accounting code
Date: Tue, 23 Jul 2013 02:31:02 +0200
Message-Id: <1374539466-4799-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the per-cpu accounting part of the event
accounting code.

This way we can use the per-cpu handling seperately.
This is going to be used by to fix the event migration
code accounting.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c |   87 +++++++++++++++++++++++++++++++------------------
 1 files changed, 55 insertions(+), 32 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3bb73af..fd820a4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3128,6 +3128,40 @@ static void free_event_rcu(struct rcu_head *head)
 static void ring_buffer_put(struct ring_buffer *rb);
 static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
 
+static void unaccount_event_cpu(struct perf_event *event, int cpu)
+{
+	if (event->parent)
+		return;
+
+	if (has_branch_stack(event)) {
+		if (!(event->attach_state & PERF_ATTACH_TASK))
+			atomic_dec(&per_cpu(perf_branch_stack_events, cpu));
+	}
+	if (is_cgroup_event(event))
+		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
+}
+
+static void unaccount_event(struct perf_event *event)
+{
+	if (event->parent)
+		return;
+
+	if (event->attach_state & PERF_ATTACH_TASK)
+		static_key_slow_dec_deferred(&perf_sched_events);
+	if (event->attr.mmap || event->attr.mmap_data)
+		atomic_dec(&nr_mmap_events);
+	if (event->attr.comm)
+		atomic_dec(&nr_comm_events);
+	if (event->attr.task)
+		atomic_dec(&nr_task_events);
+	if (is_cgroup_event(event))
+		static_key_slow_dec_deferred(&perf_sched_events);
+	if (has_branch_stack(event))
+		static_key_slow_dec_deferred(&perf_sched_events);
+
+	unaccount_event_cpu(event, event->cpu);
+}
+
 static void __free_event(struct perf_event *event)
 {
 	if (!event->parent) {
@@ -3147,29 +3181,7 @@ static void free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
 
-	if (!event->parent) {
-		if (event->attach_state & PERF_ATTACH_TASK)
-			static_key_slow_dec_deferred(&perf_sched_events);
-		if (event->attr.mmap || event->attr.mmap_data)
-			atomic_dec(&nr_mmap_events);
-		if (event->attr.comm)
-			atomic_dec(&nr_comm_events);
-		if (event->attr.task)
-			atomic_dec(&nr_task_events);
-		if (is_cgroup_event(event)) {
-			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
-			static_key_slow_dec_deferred(&perf_sched_events);
-		}
-
-		if (has_branch_stack(event)) {
-			static_key_slow_dec_deferred(&perf_sched_events);
-			/* is system-wide event */
-			if (!(event->attach_state & PERF_ATTACH_TASK)) {
-				atomic_dec(&per_cpu(perf_branch_stack_events,
-						    event->cpu));
-			}
-		}
-	}
+	unaccount_event(event);
 
 	if (event->rb) {
 		struct ring_buffer *rb;
@@ -6450,8 +6462,24 @@ unlock:
 	return pmu;
 }
 
+static void account_event_cpu(struct perf_event *event, int cpu)
+{
+	if (event->parent)
+		return;
+
+	if (has_branch_stack(event)) {
+		if (!(event->attach_state & PERF_ATTACH_TASK))
+			atomic_inc(&per_cpu(perf_branch_stack_events, cpu));
+	}
+	if (is_cgroup_event(event))
+		atomic_inc(&per_cpu(perf_cgroup_events, cpu));
+}
+
 static void account_event(struct perf_event *event)
 {
+	if (event->parent)
+		return;
+
 	if (event->attach_state & PERF_ATTACH_TASK)
 		static_key_slow_inc(&perf_sched_events.key);
 	if (event->attr.mmap || event->attr.mmap_data)
@@ -6460,17 +6488,12 @@ static void account_event(struct perf_event *event)
 		atomic_inc(&nr_comm_events);
 	if (event->attr.task)
 		atomic_inc(&nr_task_events);
-	if (has_branch_stack(event)) {
+	if (has_branch_stack(event))
 		static_key_slow_inc(&perf_sched_events.key);
-		if (!(event->attach_state & PERF_ATTACH_TASK))
-			atomic_inc(&per_cpu(perf_branch_stack_events,
-					    event->cpu));
-	}
-
-	if (is_cgroup_event(event)) {
-		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
+	if (is_cgroup_event(event))
 		static_key_slow_inc(&perf_sched_events.key);
-	}
+
+	account_event_cpu(event, event->cpu);
 }
 
 /*
-- 
1.7.5.4

