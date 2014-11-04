Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaKDNtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:49:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:30948 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754029AbaKDNtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:49:17 -0500
Message-Id: <20141104134916.253131217@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 08:48:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/4] tracing: Move tracing_sched_{switch,wakeup}() into wakeup tracer
References: <20141104134847.978505265@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-tracing-Move-tracing_sched_-switch-wakeup-into-wakeu.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The only code that references tracing_sched_switch_trace() and
tracing_sched_wakeup_trace() is the wakeup latency tracer. Those
two functions use to belong to the sched_switch tracer which has
long been removed. These functions were left behind because the
wakeup latency tracer used them. But since the wakeup latency tracer
is the only one to use them, they should be static functions inside
that code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h              |  9 -------
 kernel/trace/trace_sched_switch.c | 56 ---------------------------------------
 kernel/trace/trace_sched_wakeup.c | 56 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 65 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a3a82d5f25dc..3376de623ea0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -569,15 +569,6 @@ void trace_init_global_iter(struct trace_iterator *iter);
 
 void tracing_iter_reset(struct trace_iterator *iter, int cpu);
 
-void tracing_sched_switch_trace(struct trace_array *tr,
-				struct task_struct *prev,
-				struct task_struct *next,
-				unsigned long flags, int pc);
-
-void tracing_sched_wakeup_trace(struct trace_array *tr,
-				struct task_struct *wakee,
-				struct task_struct *cur,
-				unsigned long flags, int pc);
 void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index f7c7f4f1544c..2e293beb186e 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -17,34 +17,6 @@
 static int			sched_ref;
 static DEFINE_MUTEX(sched_register_mutex);
 
-void
-tracing_sched_switch_trace(struct trace_array *tr,
-			   struct task_struct *prev,
-			   struct task_struct *next,
-			   unsigned long flags, int pc)
-{
-	struct ftrace_event_call *call = &event_context_switch;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
-	struct ring_buffer_event *event;
-	struct ctx_switch_entry *entry;
-
-	event = trace_buffer_lock_reserve(buffer, TRACE_CTX,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->prev_pid			= prev->pid;
-	entry->prev_prio		= prev->prio;
-	entry->prev_state		= prev->state;
-	entry->next_pid			= next->pid;
-	entry->next_prio		= next->prio;
-	entry->next_state		= next->state;
-	entry->next_cpu	= task_cpu(next);
-
-	if (!call_filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, flags, pc);
-}
-
 static void
 probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *next)
 {
@@ -55,34 +27,6 @@ probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *n
 	tracing_record_cmdline(next);
 }
 
-void
-tracing_sched_wakeup_trace(struct trace_array *tr,
-			   struct task_struct *wakee,
-			   struct task_struct *curr,
-			   unsigned long flags, int pc)
-{
-	struct ftrace_event_call *call = &event_wakeup;
-	struct ring_buffer_event *event;
-	struct ctx_switch_entry *entry;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
-
-	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->prev_pid			= curr->pid;
-	entry->prev_prio		= curr->prio;
-	entry->prev_state		= curr->state;
-	entry->next_pid			= wakee->pid;
-	entry->next_prio		= wakee->prio;
-	entry->next_state		= wakee->state;
-	entry->next_cpu			= task_cpu(wakee);
-
-	if (!call_filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, flags, pc);
-}
-
 static void
 probe_sched_wakeup(void *ignore, struct task_struct *wakee, int success)
 {
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 19bd8928ce94..8fb84b362816 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -365,6 +365,62 @@ probe_wakeup_migrate_task(void *ignore, struct task_struct *task, int cpu)
 	wakeup_current_cpu = cpu;
 }
 
+static void
+tracing_sched_switch_trace(struct trace_array *tr,
+			   struct task_struct *prev,
+			   struct task_struct *next,
+			   unsigned long flags, int pc)
+{
+	struct ftrace_event_call *call = &event_context_switch;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
+
+	event = trace_buffer_lock_reserve(buffer, TRACE_CTX,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->prev_pid			= prev->pid;
+	entry->prev_prio		= prev->prio;
+	entry->prev_state		= prev->state;
+	entry->next_pid			= next->pid;
+	entry->next_prio		= next->prio;
+	entry->next_state		= next->state;
+	entry->next_cpu	= task_cpu(next);
+
+	if (!call_filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, flags, pc);
+}
+
+static void
+tracing_sched_wakeup_trace(struct trace_array *tr,
+			   struct task_struct *wakee,
+			   struct task_struct *curr,
+			   unsigned long flags, int pc)
+{
+	struct ftrace_event_call *call = &event_wakeup;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+
+	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->prev_pid			= curr->pid;
+	entry->prev_prio		= curr->prio;
+	entry->prev_state		= curr->state;
+	entry->next_pid			= wakee->pid;
+	entry->next_prio		= wakee->prio;
+	entry->next_state		= wakee->state;
+	entry->next_cpu			= task_cpu(wakee);
+
+	if (!call_filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, flags, pc);
+}
+
 static void notrace
 probe_wakeup_sched_switch(void *ignore,
 			  struct task_struct *prev, struct task_struct *next)
-- 
2.1.1


