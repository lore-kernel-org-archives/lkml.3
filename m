Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3GaI47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:56:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41754 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185Ab3GaI4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:56:55 -0400
Date: Wed, 31 Jul 2013 01:56:19 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-766d6c076928191d75ad5b0d0f58f52b1e7682d8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1374539466-4799-4-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-4-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Factor out event accounting code to account_event()/__free_event()
Git-Commit-ID: 766d6c076928191d75ad5b0d0f58f52b1e7682d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:56:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  766d6c076928191d75ad5b0d0f58f52b1e7682d8
Gitweb:     http://git.kernel.org/tip/766d6c076928191d75ad5b0d0f58f52b1e7682d8
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 23 Jul 2013 02:31:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:29:12 +0200

perf: Factor out event accounting code to account_event()/__free_event()

Gather all the event accounting code to a single place,
once all the prerequisites are completed. This simplifies
the refcounting.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374539466-4799-4-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 79 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 32 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3b99862..158fd57 100644
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
@@ -6443,6 +6451,29 @@ unlock:
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
@@ -6556,21 +6587,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
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
@@ -6865,17 +6881,14 @@ SYSCALL_DEFINE5(perf_event_open,
 
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
@@ -7071,6 +7084,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err;
 	}
 
+	account_event(event);
+
 	ctx = find_get_context(event->pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
