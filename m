Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab3KFOxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:53:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32083 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932493Ab3KFOxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:53:03 -0500
Message-Id: <20131106145258.254926021@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 09:50:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 8/8] tracing: Add support for SOFT_DISABLE to syscall events
References: <20131106145041.904349372@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-Add-support-for-SOFT_DISABLE-to-syscall-even.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

The original SOFT_DISABLE patches didn't add support for soft disable
of syscall events; this adds it.

Add an array of ftrace_event_file pointers indexed by syscall number
to the trace array and remove the existing enabled bitmaps, which as a
result are now redundant.  The ftrace_event_file structs in turn
contain the soft disable flags we need for per-syscall soft disable
accounting.

Adding ftrace_event_files also means we can remove the USE_CALL_FILTER
bit, thus enabling multibuffer filter support for syscall events.

Link: http://lkml.kernel.org/r/6e72b566e85d8df8042f133efbc6c30e21fb017e.1382620672.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h      |  4 ++--
 kernel/trace/trace.h          |  4 ++--
 kernel/trace/trace_syscalls.c | 42 ++++++++++++++++++++++++++++++++----------
 3 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 10bafa9..2ef31bf 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -120,7 +120,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.class			= &event_class_syscall_enter,	\
 		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		.flags			= TRACE_EVENT_FL_CAP_ANY | TRACE_EVENT_FL_USE_CALL_FILTER,\
+		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
 	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((section("_ftrace_events")))			\
@@ -134,7 +134,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.class			= &event_class_syscall_exit,	\
 		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		.flags			= TRACE_EVENT_FL_CAP_ANY | TRACE_EVENT_FL_USE_CALL_FILTER,\
+		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
 	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((section("_ftrace_events")))			\
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 12d1a61..9c27cda 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -192,8 +192,8 @@ struct trace_array {
 #ifdef CONFIG_FTRACE_SYSCALLS
 	int			sys_refcount_enter;
 	int			sys_refcount_exit;
-	DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
-	DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
+	struct ftrace_event_file *enter_syscall_files[NR_syscalls];
+	struct ftrace_event_file *exit_syscall_files[NR_syscalls];
 #endif
 	int			stop_count;
 	int			clock_id;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 32644ee..e4b6d11 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -302,6 +302,7 @@ static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
 static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 {
 	struct trace_array *tr = data;
+	struct ftrace_event_file *ftrace_file;
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
@@ -314,7 +315,13 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
+
+	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE) */
+	ftrace_file = rcu_dereference_sched(tr->enter_syscall_files[syscall_nr]);
+	if (!ftrace_file)
+		return;
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -336,8 +343,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	if (!call_filter_check_discard(sys_data->enter_event, entry,
-				       buffer, event))
+	if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
 }
@@ -345,6 +351,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 {
 	struct trace_array *tr = data;
+	struct ftrace_event_file *ftrace_file;
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
@@ -356,7 +363,13 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, tr->enabled_exit_syscalls))
+
+	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE()) */
+	ftrace_file = rcu_dereference_sched(tr->exit_syscall_files[syscall_nr]);
+	if (!ftrace_file)
+		return;
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -377,8 +390,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	if (!call_filter_check_discard(sys_data->exit_event, entry,
-				       buffer, event))
+	if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
 }
@@ -397,7 +409,7 @@ static int reg_event_syscall_enter(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
 	if (!ret) {
-		set_bit(num, tr->enabled_enter_syscalls);
+		rcu_assign_pointer(tr->enter_syscall_files[num], file);
 		tr->sys_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -415,10 +427,15 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
-	clear_bit(num, tr->enabled_enter_syscalls);
+	rcu_assign_pointer(tr->enter_syscall_files[num], NULL);
 	if (!tr->sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
 	mutex_unlock(&syscall_trace_lock);
+	/*
+	 * Callers expect the event to be completely disabled on
+	 * return, so wait for current handlers to finish.
+	 */
+	synchronize_sched();
 }
 
 static int reg_event_syscall_exit(struct ftrace_event_file *file,
@@ -435,7 +452,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
 	if (!ret) {
-		set_bit(num, tr->enabled_exit_syscalls);
+		rcu_assign_pointer(tr->exit_syscall_files[num], file);
 		tr->sys_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -453,10 +470,15 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
-	clear_bit(num, tr->enabled_exit_syscalls);
+	rcu_assign_pointer(tr->exit_syscall_files[num], NULL);
 	if (!tr->sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
 	mutex_unlock(&syscall_trace_lock);
+	/*
+	 * Callers expect the event to be completely disabled on
+	 * return, so wait for current handlers to finish.
+	 */
+	synchronize_sched();
 }
 
 static int __init init_syscall_trace(struct ftrace_event_call *call)
-- 
1.8.4.rc3


