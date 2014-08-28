Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaH1TTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:19:37 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59627 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaH1TTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:19:35 -0400
Date: Thu, 28 Aug 2014 12:19:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/17] RCU-tasks implementation for 3.18
Message-ID: <20140828191929.GA31795@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-7164-0000-0000-0000042C7CCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides v7 of a prototype of an RCU-tasks implementation,
which has been requested to assist with tramopoline removal.  This
flavor of RCU is task-based rather than CPU-based, and has voluntary
context switch, and usermode execution as its only quiescent states.
This selection of quiescent states ensures that at the end of a grace
period, there will no longer be any tasks depending on a trampoline
that was removed before the beginning of that grace period.  This works
because such trampolines do not contain function calls, do not contain
voluntary context switches and do not switch to usermode.  Note that if
you need to put trampolines in the idle loop, you will need to separately
schedule on each CPU.

The patches in this series are as follows:

1.	Adds the basic call_rcu_tasks() functionality.

2.	Provides cond_resched_rcu_qs() to force quiescent states, including
	RCU-tasks quiescent states, in long loops.

3.	Adds synchronous APIs: synchronize_rcu_tasks() and
	rcu_barrier_tasks().

4.	Handle the possibility of exiting tasks being preempted for
	extended periods of time after being removed from the task list.

5.	Adds GPL exports for the above APIs, courtesy of Steven Rostedt.

6.	Adds rcutorture tests for RCU-tasks.

7.	Adds RCU-tasks test cases to rcutorture scripting.

8.	Adds stall-warning checks for RCU-tasks.

9.	Improves RCU-tasks energy efficiency by replacing polling with
	wait/wakeup.

10.	Document RCU-tasks stall-warning messages.

11.	Defer rcu_tasks_kthread() creation until first call_rcu_tasks()
	to avoid populating systems with unneeded kthreads.

12.	Treat nohz_full= operation by a given task on a given CPU as
	an RCU-tasks quiescent state.

13.	Allow preemption while looping over holdout tasks while waiting
	for grace-period to end.

14.	Remove redundant preempt_disable() from
	rcu_note_voluntary_context_switch().

15.	Add additional task-specific information on RCU-tasks stall-warning
	messages.

16.	Improve context-switch latency by removing local_irq_disable()
	in rcu_preempt_note_context_switch().

17.	Move rcu_*_qs() functions to the new-style per-CPU operations,
	also adding the requirement that they be invoked on the indicated
	CPU (met by all callers).

Changes from v6:

o	Forward-port to v3.17-rc2.

Changes from v5:

o	Drop tracking of idle tasks.  Steven Rostedt is willing to
	handle this by scheduling on all the CPUs.  There is some
	discussion of reworking the idle-loop code to allow more
	straightforward tracking of idle tasks, which might allow
	idle-tracking to be re-introduced.

o	Added #16 and #17 to clean up RCU's context-switch code.

o	Incorporated feedback from Pranith Kumar.

Changes from v4:

o       CONFIG_PROVE_RCU added to one of the test scenarios.

o	Moved from srcu_read_lock() and srcu_read_unlock to __srcu_read_lock()
	and __srcu_read_unlock() to avoid CONFIG_PROVE_RCU false positives
	in do_exit().

o	Added tracking of idle tasks.

o	Improved tracking of nohz_full tasks (and by extension, idle tasks)
	by having RCU's dyntick-idle transitions store the CPU number into
	the task structure instead of the previous choice of storing the
	task pointer into the per-CPU rcu_dynticks data structure.

o	Changed timings to reduce overhead.  The loop scanning the list
	of holdout tasks is now done once per second instead of ten times
	a second, and stall warnings are emitted ten minutes into the
	grace period instead of three minutes into the grace period.

o	Added more task-state information on stall warnings.

Changes from v3:

o	Add do_exit() SRCU hooks to handle tasks being preempted after
	having removed themselves from the task list.  The need for this
	was pointed out by Oleg Nesterov, and the implmentation suggested
	by Lai Jiangshan.

o	Create rcu_tasks_kthread only if call_rcu_tasks() is invoked.

Changes from v2:

o	Use get_task_struct() instead of do_exit() hooks to synchronize
	with exiting tasks, as suggested by Lai Jiangshan.

o	Add checks of ->on_rq to the grace-period-wait polling, again
	as suggested by Lai Jiangshan.

o	Repositioned synchronize_sched() calls and improved their
	comments.

Changes from v1:

o	The lockdep issue with list locking was finessed by ditching
	list locking in favor of having the list manipulated by a single
	kthread.  This change trimmed about 150 highly concurrent lines
	from the implementation.

o	Get rid of the scheduler hooks in favor of polling the
	per-task count of voluntary context switches, in response
	to Peter Zijlstra's concerns about scheduler overhead.

o	Passes more aggressive rcutorture runs, which indicates that
	an increase in rcutorture's aggression is called for.

o	Handled review comments from Peter Zijlstra, Lai Jiangshan,
	Frederic Weisbecker, and Oleg Nesterov.

o	Added RCU-tasks stall-warning documentation.

Remaining issues include:

o	The current implementation does not yet recognize tasks that start
	out executing is usermode.  Instead, it waits for the next
	scheduling-clock tick to note them.

o	If a task is preempted while executing in usermode, the RCU-tasks
	grace period will not end until that task resumes.

o	More about RCU-tasks needs to be added to Documentation/RCU.

o	Idle tasks are not tracked, so callers who care about idle tasks
	should handle this themselves, for example, by scheduling on all
	idle CPUs.

o	There are probably still bugs, though long-term rcutorture tests
	are passing, so this is getting reasonably robust.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/stallwarn.txt                             |   33 
 b/Documentation/kernel-parameters.txt                         |    5 
 b/fs/file.c                                                   |    2 
 b/include/linux/init_task.h                                   |   14 
 b/include/linux/rcupdate.h                                    |   61 +
 b/include/linux/rcutiny.h                                     |    2 
 b/include/linux/sched.h                                       |   41 -
 b/init/Kconfig                                                |   10 
 b/kernel/exit.c                                               |    3 
 b/kernel/rcu/rcutorture.c                                     |   54 +
 b/kernel/rcu/tiny.c                                           |   12 
 b/kernel/rcu/tree.c                                           |   50 -
 b/kernel/rcu/tree.h                                           |    2 
 b/kernel/rcu/tree_plugin.h                                    |   77 +-
 b/kernel/rcu/update.c                                         |  351 +++++++++-
 b/kernel/softirq.c                                            |    2 
 b/mm/mlock.c                                                  |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01      |    9 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02      |    5 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03      |   13 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot |    1 
 23 files changed, 634 insertions(+), 117 deletions(-)

