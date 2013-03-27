Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3C0Jt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:49:29 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64184 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3C0Jt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:28 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 02/14] tracing: fix irqs-off tag display in syscall tracing
Date: Wed, 27 Mar 2013 17:48:44 +0800
Message-ID: <1364377737-10540-4-git-send-email-jovi.zhangwei@huawei.com>
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

Now all syscall tracing irqs-off tag is wrong,
syscall enter entry doesn't disable irq.

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
Fix this after this patch:

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

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace_syscalls.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8f2ac73..322e164 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -306,6 +306,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int syscall_nr;
 	int size;
 
@@ -321,9 +323,12 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
-			sys_data->enter_event->event.type, size, 0, 0);
+			sys_data->enter_event->event.type, size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -333,7 +338,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	if (!filter_current_check_discard(buffer, sys_data->enter_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -343,6 +349,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int syscall_nr;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
@@ -355,9 +363,13 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
-			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
+			sys_data->exit_event->event.type, sizeof(*entry),
+			irq_flags, pc);
 	if (!event)
 		return;
 
@@ -367,7 +379,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 
 	if (!filter_current_check_discard(buffer, sys_data->exit_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 static int reg_event_syscall_enter(struct ftrace_event_file *file,
-- 
1.7.9.7


