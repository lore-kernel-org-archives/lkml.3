Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab3GSPJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:09:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:39075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab3GSPJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:09:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,702,1367996400"; 
   d="scan'208";a="373218093"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v3 1/9] tracing: Add support for SOFT_DISABLE to syscall events
Date: Fri, 19 Jul 2013 10:09:28 -0500
Message-Id: <93b9f0a39401fb1d5a24ee57efeaf5ea9fcf49d9.1374245042.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1374245042.git.tom.zanussi@linux.intel.com>
References: <cover.1374245042.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1374245042.git.tom.zanussi@linux.intel.com>
References: <cover.1374245042.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original SOFT_DISABLE patches didn't add support for soft disable
of syscall events; this adds it and paves the way for future patches
allowing triggers to be added to syscall events, since triggers are
built on top of SOFT_DISABLE.

Add an array of ftrace_event_file pointers indexed by syscall number
to the trace array alongside the existing enabled bitmaps.  The
ftrace_event_file structs in turn contain the soft disable flags we
need for per-syscall soft disable accounting; later patches add
additional 'trigger' flags and per-syscall triggers and filters.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace.h          |  2 ++
 kernel/trace/trace_syscalls.c | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4a4f6e1..af6eb2c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -202,6 +202,8 @@ struct trace_array {
 	int			sys_refcount_exit;
 	DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
 	DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
+	struct ftrace_event_file *enter_syscall_files[NR_syscalls];
+	struct ftrace_event_file *exit_syscall_files[NR_syscalls];
 #endif
 	int			stop_count;
 	int			clock_id;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 322e164..4915b69 100644
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
@@ -317,6 +318,10 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
 		return;
 
+	ftrace_file = rcu_dereference_raw(tr->enter_syscall_files[syscall_nr]);
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
+
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
@@ -345,6 +350,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 {
 	struct trace_array *tr = data;
+	struct ftrace_event_file *ftrace_file;
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
@@ -359,6 +365,10 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!test_bit(syscall_nr, tr->enabled_exit_syscalls))
 		return;
 
+	ftrace_file = rcu_dereference_raw(tr->exit_syscall_files[syscall_nr]);
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
+
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
@@ -397,6 +407,7 @@ static int reg_event_syscall_enter(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
 	if (!ret) {
+		rcu_assign_pointer(tr->enter_syscall_files[num], file);
 		set_bit(num, tr->enabled_enter_syscalls);
 		tr->sys_refcount_enter++;
 	}
@@ -416,6 +427,7 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
 	clear_bit(num, tr->enabled_enter_syscalls);
+	rcu_assign_pointer(tr->enter_syscall_files[num], NULL);
 	if (!tr->sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
 	mutex_unlock(&syscall_trace_lock);
@@ -435,6 +447,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
 	if (!ret) {
+		rcu_assign_pointer(tr->exit_syscall_files[num], file);
 		set_bit(num, tr->enabled_exit_syscalls);
 		tr->sys_refcount_exit++;
 	}
@@ -454,6 +467,7 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
 	clear_bit(num, tr->enabled_exit_syscalls);
+	rcu_assign_pointer(tr->exit_syscall_files[num], NULL);
 	if (!tr->sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
 	mutex_unlock(&syscall_trace_lock);
-- 
1.7.11.4

