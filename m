Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3G3JcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:32:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52931 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643Ab3G3JcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 006/106] tracing: Fix irqs-off tag display in syscall tracing
Date: Tue, 30 Jul 2013 10:30:25 +0100
Message-Id: <1375176725-5825-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

commit 11034ae9c20f4057a6127fc965906417978e69b2 upstream.

All syscall tracing irqs-off tags are wrong, the syscall enter entry doesn't
disable irqs.

 [root@jovi tracing]#echo "syscalls:sys_enter_open" > set_event
 [root@jovi tracing]# cat trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 13/13   #P:2
 #
 #                              _-----=> irqs-off
 #                             / _----=> need-resched
 #                            | / _---=> hardirq/softirq
 #                            || / _--=> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
       irqbalance-513   [000] d... 56115.496766: sys_open(filename: 804e1a6, flags: 0, mode: 1b6)
       irqbalance-513   [000] d... 56115.497008: sys_open(filename: 804e1bb, flags: 0, mode: 1b6)
         sendmail-771   [000] d... 56115.827982: sys_open(filename: b770e6d1, flags: 0, mode: 1b6)

The reason is syscall tracing doesn't record irq_flags into buffer.
The proper display is:

 [root@jovi tracing]#echo "syscalls:sys_enter_open" > set_event
 [root@jovi tracing]# cat trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 14/14   #P:2
 #
 #                              _-----=> irqs-off
 #                             / _----=> need-resched
 #                            | / _---=> hardirq/softirq
 #                            || / _--=> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
       irqbalance-514   [001] ....    46.213921: sys_open(filename: 804e1a6, flags: 0, mode: 1b6)
       irqbalance-514   [001] ....    46.214160: sys_open(filename: 804e1bb, flags: 0, mode: 1b6)
            <...>-920   [001] ....    47.307260: sys_open(filename: 4e82a0c5, flags: 80000, mode: 0)

Link: http://lkml.kernel.org/r/1365564393-10972-3-git-send-email-jovi.zhangwei@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace_syscalls.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 96fc733..ed3f02b 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -303,6 +303,8 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int size;
 	int syscall_nr;
 
@@ -318,8 +320,11 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->enter_event->event.type, size, 0, 0);
+			sys_data->enter_event->event.type, size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -329,7 +334,8 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 
 	if (!filter_current_check_discard(buffer, sys_data->enter_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
@@ -338,6 +344,8 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
@@ -350,8 +358,12 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
+			sys_data->exit_event->event.type, sizeof(*entry),
+			irq_flags, pc);
 	if (!event)
 		return;
 
@@ -361,7 +373,8 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 
 	if (!filter_current_check_discard(buffer, sys_data->exit_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 int reg_event_syscall_enter(struct ftrace_event_call *call)
-- 
1.8.3.2

