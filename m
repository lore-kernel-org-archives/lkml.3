Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3IKE3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3IKE3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:02 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=pliGZniVf0cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=teJ8EiUlAMoA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=z9odyffjMVvEqKmo1QkA:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042858.253466676@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [036/251] tracing: Fix irqs-off tag display in syscall tracing
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0036-tracing-Fix-irqs-off-tag-display-in-syscall-tracing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

[ Upstream commit 11034ae9c20f4057a6127fc965906417978e69b2 ]

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

Cc: stable@vger.kernel.org # 2.6.35
Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 6b245f64..52b2b9f 100644
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
1.7.10.4


