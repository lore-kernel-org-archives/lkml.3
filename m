Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636Ab3B0Rv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:51:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27217 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367Ab3B0RuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:50:00 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=OBYuowj7IigA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=IryrODqjSCcA:10 a=20KFwNOVAAAA:8 a=c2i_rLDQ25XsLQskbt4A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gv1UdxBBVWgODLv2:21 a=F1jOORvU8H2chsLO:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130227174958.689751925@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 27 Feb 2013 12:22:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 6/8] tracing: Make syscall events suitable for multiple buffers
References: <20130227172232.707306533@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Make-syscall-events-suitable-for-multiple-bu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the syscall events record into the global buffer. But if
multiple buffers are in place, then we need to have syscall events
record in the proper buffers.

By adding descriptors to pass to the syscall event functions, the
syscall events can now record into the buffers that have been assigned
to them (one event may be applied to mulitple buffers).

This will allow tracing high volume syscalls along with seldom occurring
syscalls without losing the seldom syscall events.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h          |   11 ++++++
 kernel/trace/trace_syscalls.c |   80 +++++++++++++++++++++++------------------
 2 files changed, 57 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 38a60e6..5b45688 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -13,6 +13,11 @@
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+#include <asm/unistd.h>		/* For NR_SYSCALLS	     */
+#include <asm/syscall.h>	/* some archs define it here */
+#endif
+
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
 
@@ -173,6 +178,12 @@ struct trace_array {
 	int			cpu;
 	int			buffer_disabled;
 	struct trace_cpu	trace_cpu;	/* place holder */
+#ifdef CONFIG_FTRACE_SYSCALLS
+	int			sys_refcount_enter;
+	int			sys_refcount_exit;
+	DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
+	DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
+#endif
 	int			stop_count;
 	int			clock_id;
 	struct tracer		*current_trace;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 7a809e3..a842783 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -12,10 +12,6 @@
 #include "trace.h"
 
 static DEFINE_MUTEX(syscall_trace_lock);
-static int sys_refcount_enter;
-static int sys_refcount_exit;
-static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 static int syscall_enter_register(struct ftrace_event_call *event,
 				 enum trace_reg type, void *data);
@@ -303,8 +299,9 @@ static int syscall_exit_define_fields(struct ftrace_event_call *call)
 	return ret;
 }
 
-static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
+static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 {
+	struct trace_array *tr = data;
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
@@ -315,7 +312,7 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, enabled_enter_syscalls))
+	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -324,7 +321,8 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
-	event = trace_current_buffer_lock_reserve(&buffer,
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer,
 			sys_data->enter_event->event.type, size, 0, 0);
 	if (!event)
 		return;
@@ -338,8 +336,9 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
+static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 {
+	struct trace_array *tr = data;
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
@@ -349,14 +348,15 @@ static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, enabled_exit_syscalls))
+	if (!test_bit(syscall_nr, tr->enabled_exit_syscalls))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
-	event = trace_current_buffer_lock_reserve(&buffer,
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer,
 			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
 	if (!event)
 		return;
@@ -370,8 +370,10 @@ static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-static int reg_event_syscall_enter(struct ftrace_event_call *call)
+static int reg_event_syscall_enter(struct ftrace_event_file *file,
+				   struct ftrace_event_call *call)
 {
+	struct trace_array *tr = file->tr;
 	int ret = 0;
 	int num;
 
@@ -379,33 +381,37 @@ static int reg_event_syscall_enter(struct ftrace_event_call *call)
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_refcount_enter)
-		ret = register_trace_sys_enter(ftrace_syscall_enter, NULL);
+	if (!tr->sys_refcount_enter)
+		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
 	if (!ret) {
-		set_bit(num, enabled_enter_syscalls);
-		sys_refcount_enter++;
+		set_bit(num, tr->enabled_enter_syscalls);
+		tr->sys_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
-static void unreg_event_syscall_enter(struct ftrace_event_call *call)
+static void unreg_event_syscall_enter(struct ftrace_event_file *file,
+				      struct ftrace_event_call *call)
 {
+	struct trace_array *tr = file->tr;
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
-	sys_refcount_enter--;
-	clear_bit(num, enabled_enter_syscalls);
-	if (!sys_refcount_enter)
-		unregister_trace_sys_enter(ftrace_syscall_enter, NULL);
+	tr->sys_refcount_enter--;
+	clear_bit(num, tr->enabled_enter_syscalls);
+	if (!tr->sys_refcount_enter)
+		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
 	mutex_unlock(&syscall_trace_lock);
 }
 
-static int reg_event_syscall_exit(struct ftrace_event_call *call)
+static int reg_event_syscall_exit(struct ftrace_event_file *file,
+				  struct ftrace_event_call *call)
 {
+	struct trace_array *tr = file->tr;
 	int ret = 0;
 	int num;
 
@@ -413,28 +419,30 @@ static int reg_event_syscall_exit(struct ftrace_event_call *call)
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_refcount_exit)
-		ret = register_trace_sys_exit(ftrace_syscall_exit, NULL);
+	if (!tr->sys_refcount_exit)
+		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
 	if (!ret) {
-		set_bit(num, enabled_exit_syscalls);
-		sys_refcount_exit++;
+		set_bit(num, tr->enabled_exit_syscalls);
+		tr->sys_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
-static void unreg_event_syscall_exit(struct ftrace_event_call *call)
+static void unreg_event_syscall_exit(struct ftrace_event_file *file,
+				     struct ftrace_event_call *call)
 {
+	struct trace_array *tr = file->tr;
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
-	sys_refcount_exit--;
-	clear_bit(num, enabled_exit_syscalls);
-	if (!sys_refcount_exit)
-		unregister_trace_sys_exit(ftrace_syscall_exit, NULL);
+	tr->sys_refcount_exit--;
+	clear_bit(num, tr->enabled_exit_syscalls);
+	if (!tr->sys_refcount_exit)
+		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -685,11 +693,13 @@ static void perf_sysexit_disable(struct ftrace_event_call *call)
 static int syscall_enter_register(struct ftrace_event_call *event,
 				 enum trace_reg type, void *data)
 {
+	struct ftrace_event_file *file = data;
+
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return reg_event_syscall_enter(event);
+		return reg_event_syscall_enter(file, event);
 	case TRACE_REG_UNREGISTER:
-		unreg_event_syscall_enter(event);
+		unreg_event_syscall_enter(file, event);
 		return 0;
 
 #ifdef CONFIG_PERF_EVENTS
@@ -711,11 +721,13 @@ static int syscall_enter_register(struct ftrace_event_call *event,
 static int syscall_exit_register(struct ftrace_event_call *event,
 				 enum trace_reg type, void *data)
 {
+	struct ftrace_event_file *file = data;
+
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return reg_event_syscall_exit(event);
+		return reg_event_syscall_exit(file, event);
 	case TRACE_REG_UNREGISTER:
-		unreg_event_syscall_exit(event);
+		unreg_event_syscall_exit(file, event);
 		return 0;
 
 #ifdef CONFIG_PERF_EVENTS
-- 
1.7.10.4


