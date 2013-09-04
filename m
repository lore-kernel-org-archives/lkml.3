Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663Ab3IDASf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:18:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761521Ab3IDASd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:18:33 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6vL9NhcTi7YA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Lu4-lkDicUYA:10 a=4cbNiiPmtluNAAarHe0A:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 3 Sep 2013 20:18:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 01/18 v2] ftrace: Add hash list to save RCU unsafe
 functions
Message-ID: <20130903201831.2ae872e4@gandalf.local.home>
In-Reply-To: <20130903195705.3ba3442f@gandalf.local.home>
References: <20130831051117.884125230@goodmis.org>
	<20130831051700.601365837@goodmis.org>
	<20130903171516.16290c47@gandalf.local.home>
	<20130903221808.GH3871@linux.vnet.ibm.com>
	<20130903195705.3ba3442f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013 19:57:05 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> I was also chasing down a nasty bug that looked to be a pointer
> corruption somewhere. Still never found exactly where it happened, but
> it always happened with the following conditions:
> 
> synchronize_sched() was in progress
> 
> The ftrace_unsafe_callback() was preempted by an interrupt
> 
> lockdep was processing a lock
> 
> 
> A crash would happen which had memory corruption involved. But the
> above seemed always to be in play.
> 

Now putting back the context level recursion checks, and also adding a
check for "oops_in_progress" to have the unsafe callback not call
rcu_read_lock() on oops, I can get decent backtraces.

This seems to be what I get consistently now:

[   28.583983] Testing kprobe tracing: [   28.609714] ------------[ cut here ]------------
[   28.610050] WARNING: CPU: 2 PID: 0 at /home/rostedt/work/git/linux-trace.git/kernel/lockdep.c:960 __bfs+0xe8/0x1d5()

[   28.610050] Modules linked in:
[   28.610050] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.11.0-rc3-test+ #220
[   28.610050] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
[   28.610050]  00000000000003c0 ffff88007d503a18 ffffffff81548e29 0000000000000000
[   28.610050]  0000000000000000 ffff88007d503a58 ffffffff810427b1 ffffffff817fc1ba
[   28.610050]  ffffffff810944f6 0000000000000000 0000000000000002 ffffffff81093d06
[   28.610050] Call Trace:
[   28.610050]  <IRQ>  [<ffffffff81548e29>] dump_stack+0x52/0x89
[   28.610050]  [<ffffffff810427b1>] warn_slowpath_common+0x81/0x9b
[   28.610050]  [<ffffffff810944f6>] ? __bfs+0xe8/0x1d5
[   28.610050]  [<ffffffff81093d06>] ? noop_count+0xb/0xb
[   28.610050]  [<ffffffff810427e5>] warn_slowpath_null+0x1a/0x1c
[   28.610050]  [<ffffffff810944f6>] __bfs+0xe8/0x1d5
[   28.610050]  [<ffffffff81550c77>] ? sub_preempt_count+0xe/0xe0
[   28.610050]  [<ffffffff81095fa2>] ? print_irq_inversion_bug+0x1d2/0x1d2
[   28.610050]  [<ffffffff81095ff0>] check_usage_forwards+0x4e/0x87
[   28.610050]  [<ffffffff810965d0>] ? valid_state+0x2b/0x235
[   28.610050]  [<ffffffff810968d9>] mark_lock+0xff/0x1d8
[   28.610050]  [<ffffffff81096caa>] __lock_acquire+0x2f8/0xf57
[   28.610050]  [<ffffffff810df575>] ? ftrace_unsafe_callback+0x1f1/0x203
[   28.610050]  [<ffffffff810df465>] ? ftrace_unsafe_callback+0xe1/0x203
[   28.610050]  [<ffffffff81553dfc>] ? ftrace_call+0x5/0x2f
[   28.610050]  [<ffffffff810554dc>] ? __lock_task_sighand+0x9f/0xe9
[   28.610050]  [<ffffffff81097e70>] lock_acquire+0xf2/0x138
[   28.610050]  [<ffffffff810554dc>] ? __lock_task_sighand+0x9f/0xe9
[   28.610050]  [<ffffffff81053824>] ? task_pid_vnr+0xf/0xf
[   28.610050]  [<ffffffff8154cd40>] _raw_spin_lock+0x3b/0x4a
[   28.610050]  [<ffffffff810554dc>] ? __lock_task_sighand+0x9f/0xe9
[   28.610050]  [<ffffffff8105376a>] ? rcu_read_lock_held+0x37/0x3f
[   28.610050]  [<ffffffff81053824>] ? task_pid_vnr+0xf/0xf
[   28.610050]  [<ffffffff810554dc>] __lock_task_sighand+0x9f/0xe9
[   28.610050]  [<ffffffff81062e24>] ? __rcu_read_lock+0x4/0x1a
[   28.610050]  [<ffffffff81067f79>] run_posix_cpu_timers+0x141/0x4a8
[   28.610050]  [<ffffffff81062e24>] ? __rcu_read_lock+0x4/0x1a
[   28.610050]  [<ffffffff8107b97a>] ? trigger_load_balance+0x10/0x264
[   28.610050]  [<ffffffff81052aad>] update_process_times+0x6a/0x72
[   28.610050]  [<ffffffff810925b2>] ? tick_sched_handle.clone.9+0xc/0x55
[   28.610050]  [<ffffffff810925ec>] tick_sched_handle.clone.9+0x46/0x55
[   28.610050]  [<ffffffff810926d8>] tick_sched_timer+0x42/0x62
[   28.610050]  [<ffffffff81068b38>] __run_hrtimer+0xeb/0x1dc
[   28.610050]  [<ffffffff81092696>] ? tick_nohz_handler+0x9b/0x9b
[   28.610050]  [<ffffffff810693e4>] hrtimer_interrupt+0xed/0x1f3
[   28.610050]  [<ffffffff8102a160>] local_apic_timer_interrupt+0x57/0x5b
[   28.610050]  [<ffffffff8155629a>] smp_apic_timer_interrupt+0x2f/0x41
[   28.610050]  [<ffffffff81554e2f>] apic_timer_interrupt+0x6f/0x80
[   28.610050]  <EOI>  [<ffffffff810df575>] ? ftrace_unsafe_callback+0x1f1/0x203
[   28.610050]  [<ffffffff810df465>] ? ftrace_unsafe_callback+0xe1/0x203
[   28.610050]  [<ffffffff8100b2df>] ? default_idle+0x21/0x32
[   28.610050]  [<ffffffff8100b2dd>] ? default_idle+0x1f/0x32
[   28.610050]  [<ffffffff8100ba5c>] arch_cpu_idle+0x18/0x22
[   28.610050]  [<ffffffff81089b59>] cpu_startup_entry+0x109/0x16c
[   28.610050]  [<ffffffff81028ba0>] start_secondary+0x251/0x258
[   28.610050] ---[ end trace 19765ef14295ecea ]---

Oh yes, and it always happens on testing kprobes. But it happens when
that test does a synchronize_sched().

-- Steve
