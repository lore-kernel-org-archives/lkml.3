Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3HVT5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:57:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:48104 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab3HVT5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:57:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,935,1367996400"; 
   d="scan'208";a="391789251"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v5 01/10] tracing: Add support for SOFT_DISABLE to syscall events
Date: Thu, 22 Aug 2013 14:57:34 -0500
Message-Id: <ad2ef4501edb491f82ee2f45a95432205016be79.1377183739.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original SOFT_DISABLE patches didn't add support for soft disable
of syscall events; this adds it and paves the way for future patches
allowing triggers to be added to syscall events, since triggers are
built on top of SOFT_DISABLE.

Add an array of ftrace_event_file pointers indexed by syscall number
to the trace array and remove the existing enabled bitmaps, which as a
result are now redundant.  The ftrace_event_file structs in turn
contain the soft disable flags we need for per-syscall soft disable
accounting; later patches add additional 'trigger' flags and
per-syscall triggers and filters.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace.h          |  4 ++--
 kernel/trace/trace_syscalls.c | 36 ++++++++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index afaae41..3dd994e8 100644
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
index 8fd0365..4a47b6d 100644
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
+	/* Here we're inside the tp handler's rcu_read_lock (__DO_TRACE()) */
+	ftrace_file = rcu_dereference_raw(tr->enter_syscall_files[syscall_nr]);
+	if (!ftrace_file)
+		return;
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -345,6 +352,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 {
 	struct trace_array *tr = data;
+	struct ftrace_event_file *ftrace_file;
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
@@ -356,7 +364,13 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, tr->enabled_exit_syscalls))
+
+	/* Here we're inside the tp handler's rcu_read_lock (__DO_TRACE()) */
+	ftrace_file = rcu_dereference_raw(tr->exit_syscall_files[syscall_nr]);
+	if (!ftrace_file)
+		return;
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -397,7 +411,7 @@ static int reg_event_syscall_enter(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
 	if (!ret) {
-		set_bit(num, tr->enabled_enter_syscalls);
+		rcu_assign_pointer(tr->enter_syscall_files[num], file);
 		tr->sys_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -415,9 +429,14 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
-	clear_bit(num, tr->enabled_enter_syscalls);
+	rcu_assign_pointer(tr->enter_syscall_files[num], NULL);
 	if (!tr->sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
+	/*
+	 * Callers expect the event to be completely disabled on
+	 * return, so wait for current handlers to finish.
+	 */
+	synchronize_sched();
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -435,7 +454,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
 	if (!ret) {
-		set_bit(num, tr->enabled_exit_syscalls);
+		rcu_assign_pointer(tr->exit_syscall_files[num], file);
 		tr->sys_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -453,9 +472,14 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
-	clear_bit(num, tr->enabled_exit_syscalls);
+	rcu_assign_pointer(tr->exit_syscall_files[num], NULL);
 	if (!tr->sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
+	/*
+	 * Callers expect the event to be completely disabled on
+	 * return, so wait for current handlers to finish.
+	 */
+	synchronize_sched();
 	mutex_unlock(&syscall_trace_lock);
 }
 
-- 
1.7.11.4

