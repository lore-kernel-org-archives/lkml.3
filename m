Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896Ab3GCSW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:22:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab3GCSW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:22:26 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=iOqIF9DObZoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=B34Q1QjHyxkA:10 a=-e53cmuEBXkvV6LJiWQA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372875744.22688.114.camel@gandalf.local.home>
Subject: [PATCH stable 2.6.33+ ] tracing: Use current_uid() for critical
 time tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 03 Jul 2013 14:22:24 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

upstream commit f17a5194859a82afe4164e938b92035b86c55794

The irqsoff tracer records the max time that interrupts are disabled.
There are hooks in the assembly code that calls back into the tracer when
interrupts are disabled or enabled.

When they are enabled, the tracer checks if the amount of time they
were disabled is larger than the previous recorded max interrupts off
time. If it is, it creates a snapshot of the currently running trace
to store where the last largest interrupts off time was held and how
it happened.

During testing, this RCU lockdep dump appeared:

[ 1257.829021] ===============================
[ 1257.829021] [ INFO: suspicious RCU usage. ]
[ 1257.829021] 3.10.0-rc1-test+ #171 Tainted: G        W
[ 1257.829021] -------------------------------
[ 1257.829021] /home/rostedt/work/git/linux-trace.git/include/linux/rcupdate.h:780 rcu_read_lock() used illegally while idle!
[ 1257.829021]
[ 1257.829021] other info that might help us debug this:
[ 1257.829021]
[ 1257.829021]
[ 1257.829021] RCU used illegally from idle CPU!
[ 1257.829021] rcu_scheduler_active = 1, debug_locks = 0
[ 1257.829021] RCU used illegally from extended quiescent state!
[ 1257.829021] 2 locks held by trace-cmd/4831:
[ 1257.829021]  #0:  (max_trace_lock){......}, at: [<ffffffff810e2b77>] stop_critical_timing+0x1a3/0x209
[ 1257.829021]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff810dae5a>] __update_max_tr+0x88/0x1ee
[ 1257.829021]
[ 1257.829021] stack backtrace:
[ 1257.829021] CPU: 3 PID: 4831 Comm: trace-cmd Tainted: G        W    3.10.0-rc1-test+ #171
[ 1257.829021] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
[ 1257.829021]  0000000000000001 ffff880065f49da8 ffffffff8153dd2b ffff880065f49dd8
[ 1257.829021]  ffffffff81092a00 ffff88006bd78680 ffff88007add7500 0000000000000003
[ 1257.829021]  ffff88006bd78680 ffff880065f49e18 ffffffff810daebf ffffffff810dae5a
[ 1257.829021] Call Trace:
[ 1257.829021]  [<ffffffff8153dd2b>] dump_stack+0x19/0x1b
[ 1257.829021]  [<ffffffff81092a00>] lockdep_rcu_suspicious+0x109/0x112
[ 1257.829021]  [<ffffffff810daebf>] __update_max_tr+0xed/0x1ee
[ 1257.829021]  [<ffffffff810dae5a>] ? __update_max_tr+0x88/0x1ee
[ 1257.829021]  [<ffffffff811002b9>] ? user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff810dbf85>] update_max_tr_single+0x11d/0x12d
[ 1257.829021]  [<ffffffff811002b9>] ? user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff810e2b15>] stop_critical_timing+0x141/0x209
[ 1257.829021]  [<ffffffff8109569a>] ? trace_hardirqs_on+0xd/0xf
[ 1257.829021]  [<ffffffff811002b9>] ? user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff810e3057>] time_hardirqs_on+0x2a/0x2f
[ 1257.829021]  [<ffffffff811002b9>] ? user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff8109550c>] trace_hardirqs_on_caller+0x16/0x197
[ 1257.829021]  [<ffffffff8109569a>] trace_hardirqs_on+0xd/0xf
[ 1257.829021]  [<ffffffff811002b9>] user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff810029b4>] do_notify_resume+0x92/0x97
[ 1257.829021]  [<ffffffff8154bdca>] int_signal+0x12/0x17

What happened was entering into the user code, the interrupts were enabled
and a max interrupts off was recorded. The trace buffer was saved along with
various information about the task: comm, pid, uid, priority, etc.

The uid is recorded with task_uid(tsk). But this is a macro that uses rcu_read_lock()
to retrieve the data, and this happened to happen where RCU is blind (user_enter).

As only the preempt and irqs off tracers can have this happen, and they both
only have the tsk == current, if tsk == current, use current_uid() instead of
task_uid(), as current_uid() does not use RCU as only current can change its uid.

This fixes the RCU suspicious splat.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: stable-rt.git/kernel/trace/trace.c
===================================================================
--- stable-rt.git.orig/kernel/trace/trace.c	2013-07-03 14:00:56.713028912 -0400
+++ stable-rt.git/kernel/trace/trace.c	2013-07-03 14:00:56.685028248 -0400
@@ -672,7 +672,15 @@ __update_max_tr(struct trace_array *tr,
 
 	memcpy(max_data->comm, tsk->comm, TASK_COMM_LEN);
 	max_data->pid = tsk->pid;
-	max_data->uid = task_uid(tsk);
+	/*
+	 * If tsk == current, then use current_uid(), as that does not use
+	 * RCU. The irq tracer can be called out of RCU scope.
+	 */
+	if (tsk == current)
+		max_data->uid = current_uid();
+	else
+		max_data->uid = task_uid(tsk);
+
 	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
 	max_data->policy = tsk->policy;
 	max_data->rt_priority = tsk->rt_priority;


