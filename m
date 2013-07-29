Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3G2Qnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:43:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:16206 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713Ab3G2Qln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,771,1367996400"; 
   d="scan'208";a="353690467"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v4 01/11] tracing: Add support for SOFT_DISABLE to syscall events
Date: Mon, 29 Jul 2013 11:40:57 -0500
Message-Id: <86c82034b47fb27e30555aaf6a4a962e49581c1d.1375111640.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1375111640.git.tom.zanussi@linux.intel.com>
References: <cover.1375111640.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1375111640.git.tom.zanussi@linux.intel.com>
References: <cover.1375111640.git.tom.zanussi@linux.intel.com>
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
 kernel/trace/trace_syscalls.c | 34 ++++++++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 8 deletions(-)

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
index 8fd0365..294cfe8 100644
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
@@ -314,7 +315,12 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
+
+	ftrace_file = rcu_dereference_raw(tr->enter_syscall_files[syscall_nr]);
+	if (!ftrace_file)
+		return;
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -345,6 +351,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 {
 	struct trace_array *tr = data;
+	struct ftrace_event_file *ftrace_file;
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
@@ -356,7 +363,12 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, tr->enabled_exit_syscalls))
+
+	ftrace_file = rcu_dereference_raw(tr->exit_syscall_files[syscall_nr]);
+	if (!ftrace_file)
+		return;
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -397,7 +409,7 @@ static int reg_event_syscall_enter(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
 	if (!ret) {
-		set_bit(num, tr->enabled_enter_syscalls);
+		rcu_assign_pointer(tr->enter_syscall_files[num], file);
 		tr->sys_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -415,9 +427,14 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
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
 
@@ -435,7 +452,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
 	if (!ret) {
-		set_bit(num, tr->enabled_exit_syscalls);
+		rcu_assign_pointer(tr->exit_syscall_files[num], file);
 		tr->sys_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -453,9 +470,14 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
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

