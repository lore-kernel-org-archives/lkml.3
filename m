Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3KDQAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:00:12 -0500
Received: from mail-oa0-f65.google.com ([209.85.219.65]:51310 "EHLO
	mail-oa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3KDQAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:00:11 -0500
MIME-Version: 1.0
Date: Tue, 5 Nov 2013 00:00:10 +0800
Message-ID: <CAP+bzvVjW-AbFrHmQ0mqQZ9bn8yfrR4D3FGzovtbEcspGRsVxg@mail.gmail.com>
Subject: [PATCH] arm: add save_stack_trace_regs() support
From: ivan lam <ivan.lam2014@gmail.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ivan lam <ivan.lam2014@gmail.com>
Date: Mon, 4 Nov 2013 23:35:55 +0800
Subject: [PATCH] arm: add save_stack_trace_regs() support

When configure kprobe events of ftrace with stacktrace option enabled
in arm, not stacktrace was recorded after the kprobe was triggered.

Implement the save_stack_trace_regs() function in arm.

After this fix, stacktrace can be recorded, for example:

# mount -t debugfs nodev /sys/kernel/debug
# echo "p:netrx net_rx_action" >> /sys/kernel/debug/tracing/kprobe_events
# echo 1 > /sys/kernel/debug/tracing/events/kprobes/netrx/enable
# echo 1 > /sys/kernel/debug/tracing/options/stacktrace
# echo 1 > /sys/kernel/debug/tracing/tracing_on
# ping 127.0.0.1 -c 1
# echo 0 > /sys/kernel/debug/tracing/tracing_on

# cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 12/12   #P:1
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
            ping-1200  [000] dNs1   667.603250: netrx: (net_rx_action+0x0/0x1f8)
            ping-1200  [000] dNs1   667.604738: <stack trace>
 => net_rx_action
 => do_softirq
 => local_bh_enable
 => ip_finish_output
 => ip_output
 => ip_local_out
 => ip_send_skb
 => ip_push_pending_frames
 => raw_sendmsg
 => inet_sendmsg
 => sock_sendmsg
 => SyS_sendto
 => ret_fast_syscall

Signed-off-by: ivan lam <ivan.lam2014@gmail.com>
---
 arch/arm/kernel/stacktrace.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 00f79e5..2b52fac0 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -123,6 +123,25 @@ void save_stack_trace_tsk(struct task_struct
*tsk, struct stack_trace *trace)
         trace->entries[trace->nr_entries++] = ULONG_MAX;
 }

+void save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
+{
+    struct stack_trace_data data;
+    struct stackframe frame;
+
+    data.trace = trace;
+    data.skip = trace->skip;
+    data.no_sched_functions = 1;
+
+    frame.fp = regs->ARM_fp;
+    frame.sp = regs->ARM_sp;
+    frame.lr = regs->ARM_lr;
+    frame.pc = regs->ARM_pc;
+
+    walk_stackframe(&frame, save_trace, &data);
+    if (trace->nr_entries < trace->max_entries)
+        trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+
 void save_stack_trace(struct stack_trace *trace)
 {
     save_stack_trace_tsk(current, trace);
-- 
1.7.9.5
