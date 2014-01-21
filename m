Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaAUOEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:04:36 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38878 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaAUOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:04:33 -0500
Message-ID: <52DE7E6A.90401@linaro.org>
Date: Tue, 21 Jan 2014 22:04:26 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: top-down balance purpose discussion -- resend
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current scheduler load balance is bottom-up mode, each CPU need
initiate the balance by self.

1, Like in a integrate computer system, it has smt/core/cpu/numa, 4
level scheduler domains. If there is just 2 tasks in whole system that
both running on cpu0. Current load balance need to pull task to another
smt in smt domain, then pull task to another core, then pull task to
another cpu, finally pull task to another numa. Totally it is need 4
times task moving to get system balance.

Generally, the task moving complexity is
	O(nm log n),  n := nr_cpus, m := nr_tasks

There is a excellent summary and explanation for this in
kernel/sched/fair.c:4605

Another weakness of current LB is that every cpu need to get the other
cpus' load info repeatedly and try to figure out busiest sched
group/queue on every sched domain level. But it just waste time, since
it may not conduct a task moving. One of reasons is that cpu can only
pull task, not pushing.

2, Consider huge cost of task moving: CS, tlb/cache refill, and the
useless remote cpu load info getting. If we can have better solution for
load balance, like reduce the balance times to.
	O(m) m := nr_tasks

It will be a great win on performance. like above example, we can move
task from cpu0 direct to another numa. that only need 1 task moving,
save 3 CS and tlb/cache refill.

To get this point, a rough idea is changing the load balance behaviour
to top-down mode. And only load balance just be done by on on cpu.
Like let each of cpu report self load status on per-cpu
memory. And a baby-sitter in system to collect these cpus load info,
then decide how to move task centralize, finally send IPI to each hungry
cpu to let them pull load quota from appointed cpus.

Like in above example, the baby-sitter will fetch each cpus' load info,
then send a pull task IPI to let a cpu in another numa pull one task
from cpu0. So in the task pulling, we still just involved 2 cpus, can
reuse move_tasks() functions.

3, From power saving POV, top-down can get the whole cpu power topology
info before balance. So we can start balance with the power
consideration firstly, instead of stop balance at last minute after
getting every remote cpu info.

4, One of concern of top-down mode is that we need to remote access top
level domain cpu info in large system while each cpu keep updates its
load. That may causes cache bouncing issue. (current LB also has this
problem, but it set a long load balance interval to reduce LB times)

Paul has given lots of excellent suggestion to resolve/relief this
issue. the following is his suggestions:
===
Might be -- key thing is to measure it on a big system.  If it is a
problem, here are some workarounds with varying degrees of sanity:

1.	Reduce cache misses by keeping three values:

	a.	Current load value.
	b.	Last exported value.  (Should be in same cache line
		as a.)
	c.	Exported value.  (Should be in separate cache line.)

	The avoid writing to c unless a has deviated sufficiently from a.
	If the load values stay constant for long time periods, this
	can reduce the number of cache misses.  On the other hand,
	it introduces an extra compare and branch -- though this should
	not be a problem if the load value is computed relatively
	infrequently.

2.	As above, but provide additional information to allow the
	other CPU to extrapolate values.  For example, if a CPU goes
	idle, some of its values will decay exponentially.  The
	remote CPU could compute the decay rate, removing the need
	for the subject CPU to wake up to recompute its value.
	(Maybe you already do this?)

	Similarly if a CPU remains CPU-bound with given runqueue
	loading for some time.

3.	Allow the exported values to become inaccurate, and resample
	the actual values remotely if extrapolated values indicate
	that action is warranted.

There are probably other approaches.  I am being quite general here
because I don't have the full picture of the scheduler statistics
in my head.  It is likely possible to obtain a much better approach
by considering the scheduler's specifics.

-- 
Thanks
    Alex
