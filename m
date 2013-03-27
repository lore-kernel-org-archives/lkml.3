Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab3C0Jxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:53:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64319 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3C0Jth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:37 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 05/14] tracing: switch syscall tracing to use event_trace_ops backend
Date: Wed, 27 Mar 2013 17:48:47 +0800
Message-ID: <1364377737-10540-7-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Other tracepoints already switched to use event_trace_ops as
backend store mechanism, syscall tracing can use same backend.

This change would also expose syscall tracing to external modules
with same interface like other tracepoints.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace_syscalls.c |   49 ++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 322e164..72675b1 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -302,12 +302,10 @@ static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
 static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 {
 	struct trace_array *tr = data;
+	struct ftrace_event_file event_file;
+	struct trace_descriptor_t desc;
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
-	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
-	unsigned long irq_flags;
-	int pc;
 	int syscall_nr;
 	int size;
 
@@ -323,34 +321,26 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
-	local_save_flags(irq_flags);
-	pc = preempt_count();
-
-	buffer = tr->trace_buffer.buffer;
-	event = trace_buffer_lock_reserve(buffer,
-			sys_data->enter_event->event.type, size, irq_flags, pc);
-	if (!event)
+	event_file.tr = tr;
+	event_file.event_call = sys_data->enter_event;
+	event_file.flags = FTRACE_EVENT_FL_ENABLED;
+	entry = tr->ops->pre_trace(&event_file, size, &desc);
+	if (!entry)
 		return;
 
-	entry = ring_buffer_event_data(event);
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	if (!filter_current_check_discard(buffer, sys_data->enter_event,
-					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event,
-						   irq_flags, pc);
+	tr->ops->do_trace(&event_file, entry, size, &desc);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 {
 	struct trace_array *tr = data;
+	struct ftrace_event_file event_file;
+	struct trace_descriptor_t desc;
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
-	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
-	unsigned long irq_flags;
-	int pc;
 	int syscall_nr;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
@@ -363,24 +353,17 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	local_save_flags(irq_flags);
-	pc = preempt_count();
-
-	buffer = tr->trace_buffer.buffer;
-	event = trace_buffer_lock_reserve(buffer,
-			sys_data->exit_event->event.type, sizeof(*entry),
-			irq_flags, pc);
-	if (!event)
+	event_file.tr = tr;
+	event_file.event_call = sys_data->exit_event;
+	event_file.flags = FTRACE_EVENT_FL_ENABLED;
+	entry = tr->ops->pre_trace(&event_file, sizeof(*entry), &desc);
+	if (!entry)
 		return;
 
-	entry = ring_buffer_event_data(event);
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	if (!filter_current_check_discard(buffer, sys_data->exit_event,
-					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event,
-						   irq_flags, pc);
+	tr->ops->do_trace(&event_file, entry, sizeof(*entry), &desc);
 }
 
 static int reg_event_syscall_enter(struct ftrace_event_file *file,
-- 
1.7.9.7


