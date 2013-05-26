Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3EZS6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 14:58:08 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39155 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab3EZS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 14:58:04 -0400
Date: Sun, 26 May 2013 11:14:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] ftrace/rcu: Prevent function tracer from calling
 into rcu debug checks
Message-ID: <20130526181446.GA6172@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1369448547.6828.257.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369448547.6828.257.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052618-7606-0000-0000-00000BD048FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 10:22:27PM -0400, Steven Rostedt wrote:
> I was testing a config for one bug and triggered a livelock lockup. A
> NMI watchdog dump showed what was happening:
> 
> [   65.972000] NMI backtrace for cpu 2
> [   65.972000] CPU: 2 PID: 48 Comm: kworker/2:1 Not tainted 3.10.0-rc2-test+ #151
> [   65.972000] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
> [   65.972000] task: ffff880078dc2140 ti: ffff880078dc4000 task.ti: ffff880078dc4000
> [   65.972000] RIP: 0010:[<ffffffff810c2259>]  [<ffffffff810c2259>] ftrace_ops_list_func+0x144/0x151
> [   65.972000] RSP: 0000:ffff880078dc5ac8  EFLAGS: 00000006
> [   65.972000] RAX: 0000000000008000 RBX: 0000000000000001 RCX: 000000000000000f
> [   65.972000] RDX: 0000000000000002 RSI: ffffffff810c0e9f RDI: ffffffff810b73f7
> [   65.972000] RBP: ffff880078dc5af8 R08: ffff880078dc5be0 R09: ffff880078dc5bb0
> [   65.972000] R10: ffffffff81a3c730 R11: 0000000000000001 R12: 0000000000008000
> [   65.972000] R13: ffffffff810b73f7 R14: 0000000000000000 R15: ffffffff810c0e9f
> [   65.972000] FS:  0000000000000000(0000) GS:ffff88007aa00000(0000) knlGS:0000000000000000
> [   65.972000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   65.972000] CR2: 0000000000000168 CR3: 0000000001a0b000 CR4: 00000000000007e0
> [   65.972000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   65.972000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   65.972000] Stack:
> [   65.972000]  ffff880078d97480 0000000000000001 ffffffff810b9148 ffff880078d97480
> [   65.972000]  0000000000000000 ffffffff810bb6ba ffff880078dc5bd0 ffffffff814fa7c0
> [   65.972000]  0000000000000000 ffffffff810bb6ba ffff880078dc5c00 ffffffff814fa7c0
> [   65.972000] Call Trace:
> [   65.972000]  [<ffffffff810b9148>] ? check_for_new_grace_period+0x115/0x115
> [   65.972000]  [<ffffffff810bb6ba>] ? rcu_note_context_switch+0x20e/0x260
> [   65.972000]  [<ffffffff814fa7c0>] ftrace_call+0x5/0x2f
> [   65.972000]  [<ffffffff810bb6ba>] ? rcu_note_context_switch+0x20e/0x260
> [   65.972000]  [<ffffffff814fa7c0>] ? ftrace_call+0x5/0x2f
> [   65.972000]  [<ffffffff810b73fc>] ? rcu_is_cpu_idle+0x5/0x69
> [   65.972000]  [<ffffffff810558d3>] ? debug_lockdep_rcu_enabled+0x5/0x35
> [   65.972000]  [<ffffffff810b73fc>] ? rcu_is_cpu_idle+0x5/0x69
> [   65.972000]  [<ffffffff810c0e9f>] ? rcu_read_lock_held+0x19/0x3c
> [   65.972000]  [<ffffffff810c0f90>] ftrace_ops_test+0x47/0x93
> [   65.972000]  [<ffffffff810b9148>] ? check_for_new_grace_period+0x115/0x115
> [   65.972000]  [<ffffffff810c21e1>] ftrace_ops_list_func+0xcc/0x151
> [   65.972000]  [<ffffffff814fa7c0>] ftrace_call+0x5/0x2f
> [   65.972000]  [<ffffffff810c2234>] ? ftrace_ops_list_func+0x11f/0x151
> [   65.972000]  [<ffffffff810bb6b2>] ? rcu_note_context_switch+0x206/0x260
> [   65.972000]  [<ffffffff810b914d>] ? rcu_preempt_qs+0x5/0x53
> [   65.972000]  [<ffffffff81086f41>] ? trace_hardirqs_off+0xd/0xf
> [   65.972000]  [<ffffffff810b914d>] ? rcu_preempt_qs+0x5/0x53
> [   65.972000]  [<ffffffff810bb6ba>] ? rcu_note_context_switch+0x20e/0x260
> [   65.972000]  [<ffffffff814f2bca>] ? schedule+0x64/0x66
> [   65.972000]  [<ffffffff814f246e>] __schedule+0x67/0x710
> [   65.972000]  [<ffffffff81052e5e>] ? worker_thread+0x1e9/0x1f3
> [   65.972000]  [<ffffffff81052e5e>] ? worker_thread+0x1e9/0x1f3
> [   65.972000]  [<ffffffff814f2bca>] schedule+0x64/0x66
> [   65.972000]  [<ffffffff81052e63>] worker_thread+0x1ee/0x1f3
> [   65.972000]  [<ffffffff81052c75>] ? rescuer_thread+0x26c/0x26c
> [   65.972000]  [<ffffffff8105a8bf>] kthread+0xb1/0xb9
> [   65.972000]  [<ffffffff81064b3c>] ? finish_task_switch+0x7c/0xf8
> [   65.972000]  [<ffffffff8105a80e>] ? __init_kthread_worker+0x59/0x59
> [   65.972000]  [<ffffffff814faadc>] ret_from_fork+0x7c/0xb0
> [   65.972000]  [<ffffffff8105a80e>] ? __init_kthread_worker+0x59/0x59
> 
> 
> What happened was that ftrace's function tracer uses
> hlist_for_each_entry_rcu() which uses rcu_dereference_raw(), and also
> calls rcu_dereference_raw() directly. As this macro is defined as
> rcu_dereference_check() and will call rcu_read_lock_sched_held() which
> does various rcu checks as well as lockdep and such, when it happens for
> *every* function call in the kernel it slows the system down where it
> can live lock (interrupts taking too long to finish, before another
> interrupt is triggered).
> 
> To give an idea of the abuse that function tracing is taking, every
> function that is traced can do the following:
> 
> in __ftrace_ops_list_func() we have:
> 
> 	do_for_each_ftrace_op(op, ftrace_ops_list) {
> 		if (ftrace_ops_test(op, ip))
> 			op->func(ip, parent_ip, op, regs);
> 	} while_for_each_ftrace_op(op);
> 
> Where:
> 
> #define do_for_each_ftrace_op(op, list)			\
> 	op = rcu_dereference_raw(list);			\
> 	do
> 
> and
> 
> #define while_for_each_ftrace_op(op)				\
> 	while (likely(op = rcu_dereference_raw((op)->next)) &&	\
> 	       unlikely((op) != &ftrace_list_end))
> 
> 
> And ftrace_ops_test() has:
> 
> 	filter_hash = rcu_dereference_raw(ops->filter_hash);
> 	notrace_hash = rcu_dereference_raw(ops->notrace_hash);
> 
> 	if ((ftrace_hash_empty(filter_hash) ||
> 	     ftrace_lookup_ip(filter_hash, ip)) &&
> 	    (ftrace_hash_empty(notrace_hash) ||
> 	     !ftrace_lookup_ip(notrace_hash, ip)))
> 		ret = 1;
> 
> Where ftrace_lookup_ip() has:
> 
> 	hlist_for_each_entry_rcu(entry, hhd, hlist) {
> 
> Now that is 6 calls to rcu_dereference_raw() that happens for every
> single function that is traced! And this doesn't count possibly more by
> the callbacks that were registered by the function tracer, or multiple
> loops by while_for_each_ftrace_op(). When rcu debugging is on, that's 6
> calls to rcu_read_lock_sched_held() which not only does several calls
> that is traced by the function tracer (luckily the recursion protection
> catches those), but those calls also call preempt_disable/enable (that
> gets traced by the function tracer). Worse yet, lock_is_held() is called
> that disables and then re-enables interrupts, and does a search for
> locks held.
> 
> All this overhead that is done for every function call that is traced
> (which could be most of the functions in the kernel) and does it at
> least 6 times. This can drastically slow things down so much that we get
> a live lock in the system.
> 
> Now, we could put a bunch of notrace in the RCU code, but as RCU is a
> more critical subsystem than tracing, and used more often, I find that
> it is advantageous to be able to trace RCU. RCU is also a more complex
> subsystem than tracing, and having that ability to trace RCU is an asset
> to help debug it and give us better confidence that it works. Thus, I
> believe it is better to remove some of the debugability from the tracing
> infrastructure than to remove it from RCU. Not to mention, even
> eliminating the recursive calls by the RCU being traced, it doesn't
> remove the RCU functions being called or the lockdep function being
> called 6 times for every function traced.
> 
> Thus, by redefining rcu_dereference_raw() in the ftrace.c code to keep
> it from doing the debugging RCU checks, we can still keep the function
> tracer able to trace the workings of RCU itself, and prevent RCU from
> killing the function tracer.
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index b549b0f..fc258e9 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -40,6 +40,17 @@
>  #include "trace_output.h"
>  #include "trace_stat.h"
> 
> +/*
> + * Ftrace can trace RCU (we want that), but unfortunately some
> + * of the RCU checks causes ftrace to lock up the system, as
> + * ftrace will then be tracing itself.
> + *
> + * We need to override rcu_dereference_raw() to not do any
> + * rcu_read_lock_held() checks, otherwise the system can hang.
> + */
> +#undef rcu_dereference_raw
> +#define rcu_dereference_raw(p) __rcu_dereference_check((p), 1, __rcu)

rcu_dereference_raw_notrace(), please?  That way people won't get
confused about why a particular rcu_dereference_raw() isn't being
traced.

							Thanx, Paul

> +
>  #define FTRACE_WARN_ON(cond)			\
>  	({					\
>  		int ___r = cond;		\
> 
> 

