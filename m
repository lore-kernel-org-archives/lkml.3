Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3F2FI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 01:08:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:15815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3F2FIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 01:08:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,963,1363158000"; 
   d="scan'208";a="361494128"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v2 03/11] tracing: add soft disable for syscall events
Date: Sat, 29 Jun 2013 00:08:06 -0500
Message-Id: <d7a32766817e9050997629b195676e357e410726.1372479499.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for SOFT_DISABLE to syscall events.

The original SOFT_DISABLE patches didn't add support for soft disable
of syscall events; this adds it and paves the way for future patches
allowing triggers to be added to syscall events, since triggers are
built on top of SOFT_DISABLE.

The existing code grabs the trace_array from the ftrace_file passed to
the event registration functions and passes that to the probe
functions.  Passing the file instead allows the probe functions to
access not only the trace_array attached to the file but the flags as
well.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace_syscalls.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8f2ac73..1765088 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -301,7 +301,8 @@ static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
 
 static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 {
-	struct trace_array *tr = data;
+	struct ftrace_event_file *ftrace_file = data;
+	struct trace_array *tr = ftrace_file->tr;
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
@@ -319,6 +320,9 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!sys_data)
 		return;
 
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
+
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
 	buffer = tr->trace_buffer.buffer;
@@ -338,7 +342,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 {
-	struct trace_array *tr = data;
+	struct ftrace_event_file *ftrace_file = data;
+	struct trace_array *tr = ftrace_file->tr;
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
@@ -355,6 +360,9 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
+
 	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
 			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
@@ -382,7 +390,7 @@ static int reg_event_syscall_enter(struct ftrace_event_file *file,
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!tr->sys_refcount_enter)
-		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
+		ret = register_trace_sys_enter(ftrace_syscall_enter, file);
 	if (!ret) {
 		set_bit(num, tr->enabled_enter_syscalls);
 		tr->sys_refcount_enter++;
@@ -404,7 +412,7 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
 	tr->sys_refcount_enter--;
 	clear_bit(num, tr->enabled_enter_syscalls);
 	if (!tr->sys_refcount_enter)
-		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
+		unregister_trace_sys_enter(ftrace_syscall_enter, file);
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -420,7 +428,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!tr->sys_refcount_exit)
-		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
+		ret = register_trace_sys_exit(ftrace_syscall_exit, file);
 	if (!ret) {
 		set_bit(num, tr->enabled_exit_syscalls);
 		tr->sys_refcount_exit++;
@@ -442,7 +450,7 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
 	tr->sys_refcount_exit--;
 	clear_bit(num, tr->enabled_exit_syscalls);
 	if (!tr->sys_refcount_exit)
-		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
+		unregister_trace_sys_exit(ftrace_syscall_exit, file);
 	mutex_unlock(&syscall_trace_lock);
 }
 
-- 
1.7.11.4

