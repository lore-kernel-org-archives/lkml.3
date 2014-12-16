Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaLPWtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:49:31 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56703 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaLPWt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:49:29 -0500
Date: Tue, 16 Dec 2014 12:19:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arun KS <arunks.linux@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RCU] kernel hangs in wait_rcu_gp during suspend path
Message-ID: <20141216201909.GP5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAKZGPAN6Ct_+FY1khP4AMSJ1RgP0zKdJ2pkczjhe-Q5HxTzsrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKZGPAN6Ct_+FY1khP4AMSJ1RgP0zKdJ2pkczjhe-Q5HxTzsrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121622-0013-0000-0000-000007213EB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:34:58PM +0530, Arun KS wrote:
> Hi,
> 
> Here is the backtrace of the process hanging in wait_rcu_gp,
> 
> PID: 247    TASK: e16e7380  CPU: 4   COMMAND: "kworker/u16:5"
>  #0 [<c09fead0>] (__schedule) from [<c09fcab0>]
>  #1 [<c09fcab0>] (schedule_timeout) from [<c09fe050>]
>  #2 [<c09fe050>] (wait_for_common) from [<c013b2b4>]
>  #3 [<c013b2b4>] (wait_rcu_gp) from [<c0142f50>]
>  #4 [<c0142f50>] (atomic_notifier_chain_unregister) from [<c06b2ab8>]
>  #5 [<c06b2ab8>] (cpufreq_interactive_disable_sched_input) from [<c06b32a8>]
>  #6 [<c06b32a8>] (cpufreq_governor_interactive) from [<c06abbf8>]
>  #7 [<c06abbf8>] (__cpufreq_governor) from [<c06ae474>]
>  #8 [<c06ae474>] (__cpufreq_remove_dev_finish) from [<c06ae8c0>]
>  #9 [<c06ae8c0>] (cpufreq_cpu_callback) from [<c0a0185c>]
> #10 [<c0a0185c>] (notifier_call_chain) from [<c0121888>]
> #11 [<c0121888>] (__cpu_notify) from [<c0121a04>]
> #12 [<c0121a04>] (cpu_notify_nofail) from [<c09ee7f0>]
> #13 [<c09ee7f0>] (_cpu_down) from [<c0121b70>]
> #14 [<c0121b70>] (disable_nonboot_cpus) from [<c016788c>]
> #15 [<c016788c>] (suspend_devices_and_enter) from [<c0167bcc>]
> #16 [<c0167bcc>] (pm_suspend) from [<c0167d94>]
> #17 [<c0167d94>] (try_to_suspend) from [<c0138460>]
> #18 [<c0138460>] (process_one_work) from [<c0138b18>]
> #19 [<c0138b18>] (worker_thread) from [<c013dc58>]
> #20 [<c013dc58>] (kthread) from [<c01061b8>]
> 
> Will this patch helps here,
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d1d74d14e98a6be740a6f12456c7d9ad47be9c9c

Looks to me like it will help.  Why don't you give it a try?

> I couldn't really understand why it got struck in  synchronize_rcu().
> Please give some pointers to debug this further.

If this patch does work, I suggest looking at the related discussion on LKML.
Perhaps your system is suffering from the audio/irq bug mentioned in the
commit log.

For a list of reasons why synchronize_rcu() might get stuck, please take
a look at Documentation/RCU/stallwarn.txt, near the end, which I have added
to the end of this email.  Search for "What Causes RCU CPU Stall Warnings".

> Below are the configs enable related to RCU.
> 
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_FANOUT=32
> CONFIG_RCU_FANOUT_LEAF=16
> CONFIG_RCU_FAST_NO_HZ=y
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_CPU_STALL_VERBOSE=y
> 
> Kernel version is 3.10.28
> Architecture is ARM

People familiar with distros based on 3.10 might have additional information.

							Thanx, Paul

------------------------------------------------------------------------

Using RCU's CPU Stall Detector

The rcu_cpu_stall_suppress module parameter enables RCU's CPU stall
detector, which detects conditions that unduly delay RCU grace periods.
This module parameter enables CPU stall detection by default, but
may be overridden via boot-time parameter or at runtime via sysfs.
The stall detector's idea of what constitutes "unduly delayed" is
controlled by a set of kernel configuration variables and cpp macros:

CONFIG_RCU_CPU_STALL_TIMEOUT

	This kernel configuration parameter defines the period of time
	that RCU will wait from the beginning of a grace period until it
	issues an RCU CPU stall warning.  This time period is normally
	21 seconds.

	This configuration parameter may be changed at runtime via the
	/sys/module/rcupdate/parameters/rcu_cpu_stall_timeout, however
	this parameter is checked only at the beginning of a cycle.
	So if you are 10 seconds into a 40-second stall, setting this
	sysfs parameter to (say) five will shorten the timeout for the
	-next- stall, or the following warning for the current stall
	(assuming the stall lasts long enough).  It will not affect the
	timing of the next warning for the current stall.

	Stall-warning messages may be enabled and disabled completely via
	/sys/module/rcupdate/parameters/rcu_cpu_stall_suppress.

CONFIG_RCU_CPU_STALL_INFO

	This kernel configuration parameter causes the stall warning to
	print out additional per-CPU diagnostic information, including
	information on scheduling-clock ticks and RCU's idle-CPU tracking.

RCU_STALL_DELAY_DELTA

	Although the lockdep facility is extremely useful, it does add
	some overhead.  Therefore, under CONFIG_PROVE_RCU, the
	RCU_STALL_DELAY_DELTA macro allows five extra seconds before
	giving an RCU CPU stall warning message.  (This is a cpp
	macro, not a kernel configuration parameter.)

RCU_STALL_RAT_DELAY

	The CPU stall detector tries to make the offending CPU print its
	own warnings, as this often gives better-quality stack traces.
	However, if the offending CPU does not detect its own stall in
	the number of jiffies specified by RCU_STALL_RAT_DELAY, then
	some other CPU will complain.  This delay is normally set to
	two jiffies.  (This is a cpp macro, not a kernel configuration
	parameter.)

rcupdate.rcu_task_stall_timeout

	This boot/sysfs parameter controls the RCU-tasks stall warning
	interval.  A value of zero or less suppresses RCU-tasks stall
	warnings.  A positive value sets the stall-warning interval
	in jiffies.  An RCU-tasks stall warning starts wtih the line:

		INFO: rcu_tasks detected stalls on tasks:

	And continues with the output of sched_show_task() for each
	task stalling the current RCU-tasks grace period.

For non-RCU-tasks flavors of RCU, when a CPU detects that it is stalling,
it will print a message similar to the following:

INFO: rcu_sched_state detected stall on CPU 5 (t=2500 jiffies)

This message indicates that CPU 5 detected that it was causing a stall,
and that the stall was affecting RCU-sched.  This message will normally be
followed by a stack dump of the offending CPU.  On TREE_RCU kernel builds,
RCU and RCU-sched are implemented by the same underlying mechanism,
while on PREEMPT_RCU kernel builds, RCU is instead implemented
by rcu_preempt_state.

On the other hand, if the offending CPU fails to print out a stall-warning
message quickly enough, some other CPU will print a message similar to
the following:

INFO: rcu_bh_state detected stalls on CPUs/tasks: { 3 5 } (detected by 2, 2502 jiffies)

This message indicates that CPU 2 detected that CPUs 3 and 5 were both
causing stalls, and that the stall was affecting RCU-bh.  This message
will normally be followed by stack dumps for each CPU.  Please note that
PREEMPT_RCU builds can be stalled by tasks as well as by CPUs,
and that the tasks will be indicated by PID, for example, "P3421".
It is even possible for a rcu_preempt_state stall to be caused by both
CPUs -and- tasks, in which case the offending CPUs and tasks will all
be called out in the list.

Finally, if the grace period ends just as the stall warning starts
printing, there will be a spurious stall-warning message:

INFO: rcu_bh_state detected stalls on CPUs/tasks: { } (detected by 4, 2502 jiffies)

This is rare, but does happen from time to time in real life.  It is also
possible for a zero-jiffy stall to be flagged in this case, depending
on how the stall warning and the grace-period initialization happen to
interact.  Please note that it is not possible to entirely eliminate this
sort of false positive without resorting to things like stop_machine(),
which is overkill for this sort of problem.

If the CONFIG_RCU_CPU_STALL_INFO kernel configuration parameter is set,
more information is printed with the stall-warning message, for example:

	INFO: rcu_preempt detected stall on CPU
	0: (63959 ticks this GP) idle=241/3fffffffffffffff/0 softirq=82/543
	   (t=65000 jiffies)

In kernels with CONFIG_RCU_FAST_NO_HZ, even more information is
printed:

	INFO: rcu_preempt detected stall on CPU
	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 softirq=82/543 last_accelerate: a345/d342 nonlazy_posted: 25 .D
	   (t=65000 jiffies)

The "(64628 ticks this GP)" indicates that this CPU has taken more
than 64,000 scheduling-clock interrupts during the current stalled
grace period.  If the CPU was not yet aware of the current grace
period (for example, if it was offline), then this part of the message
indicates how many grace periods behind the CPU is.

The "idle=" portion of the message prints the dyntick-idle state.
The hex number before the first "/" is the low-order 12 bits of the
dynticks counter, which will have an even-numbered value if the CPU is
in dyntick-idle mode and an odd-numbered value otherwise.  The hex
number between the two "/"s is the value of the nesting, which will
be a small positive number if in the idle loop and a very large positive
number (as shown above) otherwise.

The "softirq=" portion of the message tracks the number of RCU softirq
handlers that the stalled CPU has executed.  The number before the "/"
is the number that had executed since boot at the time that this CPU
last noted the beginning of a grace period, which might be the current
(stalled) grace period, or it might be some earlier grace period (for
example, if the CPU might have been in dyntick-idle mode for an extended
time period.  The number after the "/" is the number that have executed
since boot until the current time.  If this latter number stays constant
across repeated stall-warning messages, it is possible that RCU's softirq
handlers are no longer able to execute on this CPU.  This can happen if
the stalled CPU is spinning with interrupts are disabled, or, in -rt
kernels, if a high-priority process is starving RCU's softirq handler.

For CONFIG_RCU_FAST_NO_HZ kernels, the "last_accelerate:" prints the
low-order 16 bits (in hex) of the jiffies counter when this CPU last
invoked rcu_try_advance_all_cbs() from rcu_needs_cpu() or last invoked
rcu_accelerate_cbs() from rcu_prepare_for_idle().  The "nonlazy_posted:"
prints the number of non-lazy callbacks posted since the last call to
rcu_needs_cpu().  Finally, an "L" indicates that there are currently
no non-lazy callbacks ("." is printed otherwise, as shown above) and
"D" indicates that dyntick-idle processing is enabled ("." is printed
otherwise, for example, if disabled via the "nohz=" kernel boot parameter).


Multiple Warnings From One Stall

If a stall lasts long enough, multiple stall-warning messages will be
printed for it.  The second and subsequent messages are printed at
longer intervals, so that the time between (say) the first and second
message will be about three times the interval between the beginning
of the stall and the first message.


What Causes RCU CPU Stall Warnings?

So your kernel printed an RCU CPU stall warning.  The next question is
"What caused it?"  The following problems can result in RCU CPU stall
warnings:

o	A CPU looping in an RCU read-side critical section.
	
o	A CPU looping with interrupts disabled.  This condition can
	result in RCU-sched and RCU-bh stalls.

o	A CPU looping with preemption disabled.  This condition can
	result in RCU-sched stalls and, if ksoftirqd is in use, RCU-bh
	stalls.

o	A CPU looping with bottom halves disabled.  This condition can
	result in RCU-sched and RCU-bh stalls.

o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the
	kernel without invoking schedule().  Note that cond_resched()
	does not necessarily prevent RCU CPU stall warnings.  Therefore,
	if the looping in the kernel is really expected and desirable
	behavior, you might need to replace some of the cond_resched()
	calls with calls to cond_resched_rcu_qs().

o	Anything that prevents RCU's grace-period kthreads from running.
	This can result in the "All QSes seen" console-log message.
	This message will include information on when the kthread last
	ran and how often it should be expected to run.

o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
	happen to preempt a low-priority task in the middle of an RCU
	read-side critical section.   This is especially damaging if
	that low-priority task is not permitted to run on any other CPU,
	in which case the next RCU grace period can never complete, which
	will eventually cause the system to run out of memory and hang.
	While the system is in the process of running itself out of
	memory, you might see stall-warning messages.

o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
	is running at a higher priority than the RCU softirq threads.
	This will prevent RCU callbacks from ever being invoked,
	and in a CONFIG_PREEMPT_RCU kernel will further prevent
	RCU grace periods from ever completing.  Either way, the
	system will eventually run out of memory and hang.  In the
	CONFIG_PREEMPT_RCU case, you might see stall-warning
	messages.

o	A hardware or software issue shuts off the scheduler-clock
	interrupt on a CPU that is not in dyntick-idle mode.  This
	problem really has happened, and seems to be most likely to
	result in RCU CPU stall warnings for CONFIG_NO_HZ_COMMON=n kernels.

o	A bug in the RCU implementation.

o	A hardware failure.  This is quite unlikely, but has occurred
	at least once in real life.  A CPU failed in a running system,
	becoming unresponsive, but not causing an immediate crash.
	This resulted in a series of RCU CPU stall warnings, eventually
	leading the realization that the CPU had failed.

The RCU, RCU-sched, RCU-bh, and RCU-tasks implementations have CPU stall
warning.  Note that SRCU does -not- have CPU stall warnings.  Please note
that RCU only detects CPU stalls when there is a grace period in progress.
No grace period, no CPU stall warnings.

To diagnose the cause of the stall, inspect the stack traces.
The offending function will usually be near the top of the stack.
If you have a series of stall warnings from a single extended stall,
comparing the stack traces can often help determine where the stall
is occurring, which will usually be in the function nearest the top of
that portion of the stack which remains the same from trace to trace.
If you can reliably trigger the stall, ftrace can be quite helpful.

RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE
and with RCU's event tracing.  For information on RCU's event tracing,
see include/trace/events/rcu.h.

