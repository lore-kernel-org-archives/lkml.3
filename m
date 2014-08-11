Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaHKWst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:48:49 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37318 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaHKWsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:48:46 -0400
Date: Mon, 11 Aug 2014 15:48:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/16] RCU-tasks implementation
Message-ID: <20140811224840.GA25594@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081122-0928-0000-0000-000003FE0158
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides v5 of a prototype of an RCU-tasks implementation,
which has been requested to assist with tramopoline removal.  This flavor
of RCU is task-based rather than CPU-based, and has voluntary context
switch, usermode execution, and the idle loops as its only quiescent
states.  This selection of quiescent states ensures that at the end
of a grace period, there will no longer be any tasks depending on a
trampoline that was removed before the beginning of that grace period.
This works because such trampolines do not contain function calls,
do not contain voluntary context switches, do not switch to usermode,
and do not switch to idle.

The patches in this series are as follows:

1.	Adds the basic call_rcu_tasks() functionality.

2.	Provides cond_resched_rcu_qs() to force quiescent states, including
	RCU-tasks quiescent states, in long loops.

3.	Adds synchronous APIs: synchronize_rcu_tasks() and
	rcu_barrier_tasks().

4.	Handle the possibility of tasks being preempted for extended
	periods of time after being removed from the task list.

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
	an RCU-tasks quiescent state.  (In previous versions, RCU-tasks
	would wait for a context switch or non-nohz_full operation in
	this case.)

13.	Allow preemption while looping over holdout tasks while waiting
	for grace-period to end.

14.	Remove redundant preempt_disable() from
	rcu_note_voluntary_context_switch().

15.	Make RCU-tasks grace periods wait for idle tasks.

16.	Add additional task-specific information on RCU-tasks stall-warning
	messages.

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

o	CPUs that would otherwise remain idle throughout an RCU-tasks
	grace period will be interrupted once.  (It might be possible
	to do without this, discussions in flight.)

o	There are concerns that use of this very special-purpose RCU
	API might grow unexpectedly large.  One idea under discussion
	is to export this API only to specific subsystems.

o	There are probably still bugs.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/stallwarn.txt                             |   33 
 b/Documentation/kernel-parameters.txt                         |    5 
 b/fs/file.c                                                   |    2 
 b/include/linux/init_task.h                                   |   12 
 b/include/linux/rcupdate.h                                    |   57 +
 b/include/linux/sched.h                                       |   25 
 b/init/Kconfig                                                |   10 
 b/kernel/exit.c                                               |    3 
 b/kernel/rcu/rcutorture.c                                     |   54 +
 b/kernel/rcu/tiny.c                                           |    2 
 b/kernel/rcu/tree.c                                           |   16 
 b/kernel/rcu/tree.h                                           |    2 
 b/kernel/rcu/tree_plugin.h                                    |   18 
 b/kernel/rcu/update.c                                         |  413 +++++++++-
 b/mm/mlock.c                                                  |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01      |    9 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02      |    5 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03      |   13 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot |    1 
 21 files changed, 618 insertions(+), 66 deletions(-)

