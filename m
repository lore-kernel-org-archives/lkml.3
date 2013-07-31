Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab3GaI5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:57:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab3GaI5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:57:02 -0400
Date: Wed, 31 Jul 2013 01:56:28 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-4beb31f3657348a8b702dd014d01c520e522012f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1374539466-4799-5-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-5-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Split the per-cpu accounting part of the event accounting code
Git-Commit-ID: 4beb31f3657348a8b702dd014d01c520e522012f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:56:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4beb31f3657348a8b702dd014d01c520e522012f
Gitweb:     http://git.kernel.org/tip/4beb31f3657348a8b702dd014d01c520e522012f
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 23 Jul 2013 02:31:02 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:29:13 +0200

perf: Split the per-cpu accounting part of the event accounting code

This way we can use the per-cpu handling seperately.
This is going to be used by to fix the event migration
code accounting.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374539466-4799-5-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 87 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 55 insertions(+), 32 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 158fd57..3a4b73a 100644
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
@@ -6451,8 +6463,24 @@ unlock:
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
@@ -6461,17 +6489,12 @@ static void account_event(struct perf_event *event)
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
