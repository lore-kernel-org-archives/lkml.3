Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3KFOzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:55:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32069 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932267Ab3KFOw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:52:58 -0500
Message-Id: <20131106145257.579377238@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 09:50:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [for-next][PATCH 4/8] ftrace: Have control op function callback only trace when RCU is
 watching
References: <20131106145041.904349372@goodmis.org>
Content-Disposition: inline; filename=0010-ftrace-Have-control-op-function-callback-only-trace-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Dave Jones reported that trinity would be able to trigger the following
back trace:

 ===============================
 [ INFO: suspicious RCU usage. ]
 3.10.0-rc2+ #38 Not tainted
 -------------------------------
 include/linux/rcupdate.h:771 rcu_read_lock() used illegally while idle!
 other info that might help us debug this:

 RCU used illegally from idle CPU!  rcu_scheduler_active = 1, debug_locks = 0
 RCU used illegally from extended quiescent state!
 1 lock held by trinity-child1/18786:
  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8113dd48>] __perf_event_overflow+0x108/0x310
 stack backtrace:
 CPU: 3 PID: 18786 Comm: trinity-child1 Not tainted 3.10.0-rc2+ #38
  0000000000000000 ffff88020767bac8 ffffffff816e2f6b ffff88020767baf8
  ffffffff810b5897 ffff88021de92520 0000000000000000 ffff88020767bbf8
  0000000000000000 ffff88020767bb78 ffffffff8113ded4 ffffffff8113dd48
 Call Trace:
  [<ffffffff816e2f6b>] dump_stack+0x19/0x1b
  [<ffffffff810b5897>] lockdep_rcu_suspicious+0xe7/0x120
  [<ffffffff8113ded4>] __perf_event_overflow+0x294/0x310
  [<ffffffff8113dd48>] ? __perf_event_overflow+0x108/0x310
  [<ffffffff81309289>] ? __const_udelay+0x29/0x30
  [<ffffffff81076054>] ? __rcu_read_unlock+0x54/0xa0
  [<ffffffff816f4000>] ? ftrace_call+0x5/0x2f
  [<ffffffff8113dfa1>] perf_swevent_overflow+0x51/0xe0
  [<ffffffff8113e08f>] perf_swevent_event+0x5f/0x90
  [<ffffffff8113e1c9>] perf_tp_event+0x109/0x4f0
  [<ffffffff8113e36f>] ? perf_tp_event+0x2af/0x4f0
  [<ffffffff81074630>] ? __rcu_read_lock+0x20/0x20
  [<ffffffff8112d79f>] perf_ftrace_function_call+0xbf/0xd0
  [<ffffffff8110e1e1>] ? ftrace_ops_control_func+0x181/0x210
  [<ffffffff81074630>] ? __rcu_read_lock+0x20/0x20
  [<ffffffff81100cae>] ? rcu_eqs_enter_common+0x5e/0x470
  [<ffffffff8110e1e1>] ftrace_ops_control_func+0x181/0x210
  [<ffffffff816f4000>] ftrace_call+0x5/0x2f
  [<ffffffff8110e229>] ? ftrace_ops_control_func+0x1c9/0x210
  [<ffffffff816f4000>] ? ftrace_call+0x5/0x2f
  [<ffffffff81074635>] ? debug_lockdep_rcu_enabled+0x5/0x40
  [<ffffffff81074635>] ? debug_lockdep_rcu_enabled+0x5/0x40
  [<ffffffff81100cae>] ? rcu_eqs_enter_common+0x5e/0x470
  [<ffffffff8110112a>] rcu_eqs_enter+0x6a/0xb0
  [<ffffffff81103673>] rcu_user_enter+0x13/0x20
  [<ffffffff8114541a>] user_enter+0x6a/0xd0
  [<ffffffff8100f6d8>] syscall_trace_leave+0x78/0x140
  [<ffffffff816f46af>] int_check_syscall_exit_work+0x34/0x3d
 ------------[ cut here ]------------

Perf uses rcu_read_lock() but as the function tracer can trace functions
even when RCU is not currently active, this makes the rcu_read_lock()
used by perf ineffective.

As perf is currently the only user of the ftrace_ops_control_func() and
perf is also the only function callback that actively uses rcu_read_lock(),
the quick fix is to prevent the ftrace_ops_control_func() from calling
its callbacks if RCU is not active.

With Paul's new "rcu_is_watching()" we can tell if RCU is active or not.

Reported-by: Dave Jones <davej@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 44e826a..080b7d4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4388,12 +4388,21 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 	 */
 	preempt_disable_notrace();
 	trace_recursion_set(TRACE_CONTROL_BIT);
+
+	/*
+	 * Control funcs (perf) uses RCU. Only trace if
+	 * RCU is currently active.
+	 */
+	if (!rcu_is_watching())
+		goto out;
+
 	do_for_each_ftrace_op(op, ftrace_control_list) {
 		if (!(op->flags & FTRACE_OPS_FL_STUB) &&
 		    !ftrace_function_local_disabled(op) &&
 		    ftrace_ops_test(op, ip, regs))
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
+ out:
 	trace_recursion_clear(TRACE_CONTROL_BIT);
 	preempt_enable_notrace();
 }
-- 
1.8.4.rc3


