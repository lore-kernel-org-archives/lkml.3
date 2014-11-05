Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaKERlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:41:18 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:46730 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbaKERlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:41:15 -0500
Date: Wed, 5 Nov 2014 09:41:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/10] Reduce latency impact of PREEMPT_RCU CPU
 offline
Message-ID: <20141105174109.GA1306@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110517-0029-0000-0000-000005661A9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series reduces worst-case CPU-hotplug latency for PREEMPT_RCU
by avoiding an O(N) list move, where N is the number of threads that
were preempted recently while in an RCU read-side critical section.
This situation is rare, occurring only when the last CPU corresponding
to a given rcu_node structure goes offline, for example, when CPUs 1-14
are all offline and CPU 15 goes offline.  In this case, all the tasks
that were recently preempted while running on one of CPUs 0-15 will be
moved to the root rcu_node structure.  Because this could be a very large
number of tasks, and because this moving is carried out with interrupts
disabled, a very large latency spike can result.  This series therefore
reworks RCU's CPU-hotplug code and grace-period computation to remove
the need for moving tasks.

Because there was an obscure bug in the task-move process, this change
also fixes that bug by annihilating the function containing it.  This bug
manifests only when RCU priority boosting is enabled, and even then occurs
only roughly once per hundred hours or so of focused rcutorture testing.
It was made somewhat more probable by a recent change to rcutorture
that registers 60,000 RCU callbacks in three batches of 20,000 each,
with one jiffy between each batch.

The individual commits in this series are as follows:

1.	Fix a comment: softirqs are disabled, not interrupts.

2.	Apply ACCESS_ONCE to rcu_boost().

3.	Change rcu_read_unlock_special()'s "empty" variable's name to
	"empty_norm" to make room for a new "empty" that will track
	the emptiness of the full list rather than just that part that
	is blocking the current normal (non-expedited) grace period.

4.	Abstract rcu_cleanup_dead_rnp() from rcu_cleanup_dead_cpu().
	The new rcu_cleanup_dead_rnp() function clears ->qsmaskinit bits
	up the rcu_node tree to allow for the last CPU in a given leaf
	rcu_node structure going offline.  This function will be called
	from rcu_read_unlock_special() when the last blocked task exits
	its outermost RCU read-side critical section.

5.	Make rcu_read_unlock_special() to propagate ->qsmaskinit bit
	clearing up the rcu_node tree once the last task has exited
	its RCU read-side critical section.

6.	Stop migrating the list of blocked tasks to the root rcu_node
	structure.

7.	Stop holding the irq-disabled ->orphan_lock across the
	->qsmaskinit bit-clearing process, thus reducing the length
	of time that interrupts are disabled.

8.	Make use of the new rcu_preempt_has_tasks() function.

9.	Stop creating an rcub kthread for the root rcu_node structure,
	which no longer has tasks in its ->blkd_tasks list (unless it
	is also the sole leaf rcu_node structure).

10.	Drop the code from force_qs_rnp() that attempts to awaken the
	now-nonexistent root rcu_node structure's rcub kthread.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/rcu/tree.c        |  103 ++++++++++++++++-------------
 b/kernel/rcu/tree.h        |   13 ---
 b/kernel/rcu/tree_plugin.h |  159 +++++++++++----------------------------------
 3 files changed, 98 insertions(+), 177 deletions(-)

