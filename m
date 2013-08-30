Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab3H3N36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:29:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3H3NYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:24:06 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=UQIB_RUhMw4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=g709AaezvKMA:10 a=ZNLnrkk5w_ufnbcbQcYA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130830130205.504335754@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 30 Aug 2013 09:02:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Dave Jones <davej@redhat.com>
Subject: [RFC][PATCH 0/8] ftrace/rcu: Handle unsafe RCU functions and ftrace callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function tracing of RCU is extremely helpful in debugging, as RCU is
quite complex, especially with the new dynamic ticks code.

There are some kernel functions that are called when RCU is ignoring
the given CPU. For example, when coming out of userspace, the
"rcu_user_exit()" call is the function that tells RCU to start tracking
the given CPU again. But as the function tracer traces rcu_user_exit()
if a callback uses a rcu_read_lock() it will not do what is expected
as RCU is ignoring the given CPU and the rcu_read_lock() will not extend
the current grace period. You can see debug splats from RCU because
of this:

[53693.297516] ===============================
[53693.298109] [ INFO: suspicious RCU usage. ]
[53693.298562] 3.10.0-rc2+ #38 Not tainted
[53693.299017] -------------------------------
[53693.299474] include/linux/rcupdate.h:771 rcu_read_lock() used illegally while idle!
[53693.299959] 
other info that might help us debug this:

[53693.301420] RCU used illegally from idle CPU!  rcu_scheduler_active = 1, debug_locks = 0
[53693.302918] RCU used illegally from extended quiescent state!
[53693.303462] 1 lock held by trinity-child1/18786:
[53693.303966]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8113dd48>] __perf_event_overflow+0x108/0x310
[53693.304557] stack backtrace:
[53693.305608] CPU: 3 PID: 18786 Comm: trinity-child1 Not tainted 3.10.0-rc2+ #38 
[53693.306790]  0000000000000000 ffff88020767bac8 ffffffff816e2f6b ffff88020767baf8
[53693.307408]  ffffffff810b5897 ffff88021de92520 0000000000000000 ffff88020767bbf8
[53693.308035]  0000000000000000 ffff88020767bb78 ffffffff8113ded4 ffffffff8113dd48
[53693.308671] Call Trace:
[53693.309301]  [<ffffffff816e2f6b>] dump_stack+0x19/0x1b
[53693.309943]  [<ffffffff810b5897>] lockdep_rcu_suspicious+0xe7/0x120
[53693.310596]  [<ffffffff8113ded4>] __perf_event_overflow+0x294/0x310
[53693.311256]  [<ffffffff8113dd48>] ? __perf_event_overflow+0x108/0x310
[53693.311923]  [<ffffffff81309289>] ? __const_udelay+0x29/0x30
[53693.312596]  [<ffffffff81076054>] ? __rcu_read_unlock+0x54/0xa0
[53693.313275]  [<ffffffff816f4000>] ? ftrace_call+0x5/0x2f
[53693.313958]  [<ffffffff8113dfa1>] perf_swevent_overflow+0x51/0xe0
[53693.314650]  [<ffffffff8113e08f>] perf_swevent_event+0x5f/0x90
[53693.315347]  [<ffffffff8113e1c9>] perf_tp_event+0x109/0x4f0
[53693.316059]  [<ffffffff8113e36f>] ? perf_tp_event+0x2af/0x4f0
[53693.316773]  [<ffffffff81074630>] ? __rcu_read_lock+0x20/0x20
[53693.317485]  [<ffffffff8112d79f>] perf_ftrace_function_call+0xbf/0xd0
[53693.318207]  [<ffffffff8110e1e1>] ? ftrace_ops_control_func+0x181/0x210
[53693.318921]  [<ffffffff81074630>] ? __rcu_read_lock+0x20/0x20
[53693.319621]  [<ffffffff81100cae>] ? rcu_eqs_enter_common+0x5e/0x470
[53693.320330]  [<ffffffff8110e1e1>] ftrace_ops_control_func+0x181/0x210
[53693.321046]  [<ffffffff816f4000>] ftrace_call+0x5/0x2f
[53693.321763]  [<ffffffff8110e229>] ? ftrace_ops_control_func+0x1c9/0x210
[53693.322490]  [<ffffffff816f4000>] ? ftrace_call+0x5/0x2f
[53693.323221]  [<ffffffff81074635>] ? debug_lockdep_rcu_enabled+0x5/0x40
[53693.323988]  [<ffffffff81074635>] ? debug_lockdep_rcu_enabled+0x5/0x40
[53693.324728]  [<ffffffff81100cae>] ? rcu_eqs_enter_common+0x5e/0x470
[53693.325489]  [<ffffffff8110112a>] rcu_eqs_enter+0x6a/0xb0
[53693.326273]  [<ffffffff81103673>] rcu_user_enter+0x13/0x20
[53693.327025]  [<ffffffff8114541a>] user_enter+0x6a/0xd0
[53693.327783]  [<ffffffff8100f6d8>] syscall_trace_leave+0x78/0x140
[53693.328551]  [<ffffffff816f46af>] int_check_syscall_exit_work+0x34/0x3d
 
The above splat comes from tracing rcu_eqs_enter_common, and the
perf callback uses rcu_read_lock(), but at this moment, RCU is not
tracking the current CPU.

Instead of adding notrace to all these locations and lose the ability
to trace these critical RCU functions for the few users that use RCU,
this patch set creates an infrastructure to disable tracing of these
"unsafe" RCU functions by ftrace callbacks that do not explicitly tell
ftrace it does not use RCU.

A new macro is created called "FTRACE_UNSAFE_RCU()" which is used just
like EXPORT_SYMBOL(). For example:

static void rcu_eqs_enter(bool user)
{
	[...]
}
FTRACE_UNSAFE_RCU(rcu_eqs_enter);

Then the rcu_eqs_enter() function will not be traced by perf or any
other ftrace callback that does not explicitly state it does not use
RCU.

The last patch of the series is not complete. I only added a few
RCU unsafe functions to test the code. It is not a complete list.
I'll be adding another CONFIG test that adds a rcu unsafe callback
that traces everything, and will trigger the RCU warnings if something
is not covered by the FTRACE_UNSAFE_RCU(). This will help in catching
all functions that need this macro.

-- Steve

Steven Rostedt (Red Hat) (8):
      ftrace: Add hash list to save RCU unsafe functions
      ftrace: Do not set ftrace records for unsafe RCU when not allowed
      ftrace: Set ftrace internal function tracing RCU safe
      ftrace: Add test for ops against unsafe RCU functions in callback
      ftrace: Do not display non safe RCU functions in available_filter_functions
      ftrace: Add rcu_unsafe_filter_functions file
      ftrace: Add selftest to check if RCU unsafe functions are filtered properly
      rcu/ftrace: Add FTRACE_UNSAFE_RCU() to unsafe RCU functions

----
 include/asm-generic/vmlinux.lds.h     |   10 ++
 include/linux/ftrace.h                |   40 ++++++++
 kernel/rcutree.c                      |    4 +
 kernel/trace/ftrace.c                 |  165 ++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h                  |    2 +
 kernel/trace/trace_selftest.c         |   94 +++++++++++++++++++
 kernel/trace/trace_selftest_dynamic.c |    7 ++
 7 files changed, 319 insertions(+), 3 deletions(-)
