Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab3GWAbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:31:19 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:63484 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3GWAbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:31:17 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/8] perf: Gather event accounting code
Date: Tue, 23 Jul 2013 02:31:01 +0200
Message-Id: <1374539466-4799-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gather all the event accounting code to a single place,
once all the prerequisites are completed. This simplifies
the refcounting.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c |   79 +++++++++++++++++++++++++++++--------------------
 1 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c5f435f..3bb73af 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3128,6 +3128,21 @@ static void free_event_rcu(struct rcu_head *head)
 static void ring_buffer_put(struct ring_buffer *rb);
 static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
 
+static void __free_event(struct perf_event *event)
+{
+	if (!event->parent) {
+		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
+			put_callchain_buffers();
+	}
+
+	if (event->destroy)
+		event->destroy(event);
+
+	if (event->ctx)
+		put_ctx(event->ctx);
+
+	call_rcu(&event->rcu_head, free_event_rcu);
+}
 static void free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
@@ -3141,8 +3156,6 @@ static void free_event(struct perf_event *event)
 			atomic_dec(&nr_comm_events);
 		if (event->attr.task)
 			atomic_dec(&nr_task_events);
-		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
-			put_callchain_buffers();
 		if (is_cgroup_event(event)) {
 			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
 			static_key_slow_dec_deferred(&perf_sched_events);
@@ -3180,13 +3193,8 @@ static void free_event(struct perf_event *event)
 	if (is_cgroup_event(event))
 		perf_detach_cgroup(event);
 
-	if (event->destroy)
-		event->destroy(event);
-
-	if (event->ctx)
-		put_ctx(event->ctx);
 
-	call_rcu(&event->rcu_head, free_event_rcu);
+	__free_event(event);
 }
 
 int perf_event_release_kernel(struct perf_event *event)
@@ -6442,6 +6450,29 @@ unlock:
 	return pmu;
 }
 
+static void account_event(struct perf_event *event)
+{
+	if (event->attach_state & PERF_ATTACH_TASK)
+		static_key_slow_inc(&perf_sched_events.key);
+	if (event->attr.mmap || event->attr.mmap_data)
+		atomic_inc(&nr_mmap_events);
+	if (event->attr.comm)
+		atomic_inc(&nr_comm_events);
+	if (event->attr.task)
+		atomic_inc(&nr_task_events);
+	if (has_branch_stack(event)) {
+		static_key_slow_inc(&perf_sched_events.key);
+		if (!(event->attach_state & PERF_ATTACH_TASK))
+			atomic_inc(&per_cpu(perf_branch_stack_events,
+					    event->cpu));
+	}
+
+	if (is_cgroup_event(event)) {
+		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
+		static_key_slow_inc(&perf_sched_events.key);
+	}
+}
+
 /*
  * Allocate and initialize a event structure
  */
@@ -6555,21 +6586,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			if (err)
 				goto err_pmu;
 		}
-
-		if (event->attach_state & PERF_ATTACH_TASK)
-			static_key_slow_inc(&perf_sched_events.key);
-		if (event->attr.mmap || event->attr.mmap_data)
-			atomic_inc(&nr_mmap_events);
-		if (event->attr.comm)
-			atomic_inc(&nr_comm_events);
-		if (event->attr.task)
-			atomic_inc(&nr_task_events);
-		if (has_branch_stack(event)) {
-			static_key_slow_inc(&perf_sched_events.key);
-			if (!(event->attach_state & PERF_ATTACH_TASK))
-				atomic_inc(&per_cpu(perf_branch_stack_events,
-						    event->cpu));
-		}
 	}
 
 	return event;
@@ -6864,17 +6880,14 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	if (flags & PERF_FLAG_PID_CGROUP) {
 		err = perf_cgroup_connect(pid, event, &attr, group_leader);
-		if (err)
-			goto err_alloc;
-		/*
-		 * one more event:
-		 * - that has cgroup constraint on event->cpu
-		 * - that may need work on context switch
-		 */
-		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
-		static_key_slow_inc(&perf_sched_events.key);
+		if (err) {
+			__free_event(event);
+			goto err_task;
+		}
 	}
 
+	account_event(event);
+
 	/*
 	 * Special case software events and allow them to be part of
 	 * any hardware group.
@@ -7070,6 +7083,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err;
 	}
 
+	account_event(event);
+
 	ctx = find_get_context(event->pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
-- 
1.7.5.4

