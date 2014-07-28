Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaG1W4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:56:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49155 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaG1W4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:56:02 -0400
Date: Mon, 28 Jul 2014 15:55:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/9] RCU-tasks implementation
Message-ID: <20140728225556.GA19493@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072822-9332-0000-0000-00000186F2F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a prototype of an RCU-tasks implementation, which has
been requested to assist with tramopoline removal.  This flavor of RCU
is task-based rather than CPU-based, and has voluntary context switch,
usermode execution, and the idle loops as its only quiescent states.
This selection of quiescent states ensures that at the end of a grace
period, there will no longer be any tasks depending on a trampoline that
was removed before the beginning of that grace period.  This works because
such trampolines do not contain function calls, do not contain voluntary
context switches, do not switch to usermode, and do not switch to idle.

The patches in this series are as follows:

1.	Adds the basic call_rcu_tasks() functionality.

2.	Provides cond_resched_rcu_qs() to force quiescent states, including
	RCU-tasks quiescent states, in long loops.

3.	Adds synchronous APIs: synchronize_rcu_tasks() and
	rcu_barrier_tasks().

4.	Adds GPL exports for the above APIs, courtesy of Steven Rostedt.

5.	Adds rcutorture tests for RCU-tasks.

6.	Adds RCU-tasks test cases to rcutorture scripting.

7.	Adds stall-warning checks for RCU-tasks.

8.	Adds synchronization with exiting tasks, preventing RCU-tasks from
	waiting on exited tasks.

9.	Improves RCU-tasks energy efficiency by replacing polling with
	wait/wakeup.

Remaining issues include:

o	The list locking is not yet set up for lockdep.

o	It is not clear that trampolines in functions called from the
	idle loop are correctly handled.  Or if anyone cares about
	trampolines in functions called from the idle loop.

o	The current implementation does not yet recognize tasks that start
	out executing is usermode.  Instead, it waits for the next
	scheduling-clock tick to note them.

o	As a result, the current implementation does not handle nohz_full=
	CPUs executing tasks running in usermode.  There are a couple of
	possible fixes under consideration.

o	If a task is preempted while executing in usermode, the RCU-tasks
	grace period will not end until that task resumes.  (Is there
	some reasonable way to determine that a given preempted task
	was preempted from usermode execution?)

o	RCU-tasks needs to be added to Documentation/RCU.

o	There are probably still bugs.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/kernel-parameters.txt                         |    5 
 b/fs/file.c                                                   |    2 
 b/include/linux/init_task.h                                   |   14 
 b/include/linux/rcupdate.h                                    |   60 
 b/include/linux/rcutiny.h                                     |    1 
 b/include/linux/sched.h                                       |   13 
 b/init/Kconfig                                                |   10 
 b/kernel/rcu/rcutorture.c                                     |   44 
 b/kernel/rcu/tiny.c                                           |    2 
 b/kernel/rcu/tree.c                                           |   14 
 b/kernel/rcu/tree_plugin.h                                    |    4 
 b/kernel/rcu/update.c                                         |  616 +++++++++-
 b/kernel/sched/core.c                                         |    2 
 b/mm/mlock.c                                                  |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01      |    7 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02      |    6 
 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot |    1 
 18 files changed, 749 insertions(+), 55 deletions(-)

