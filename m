Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbbAGRwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:52:34 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:59548 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbbAGRwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:32 -0500
Date: Wed, 7 Jan 2015 09:52:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/9] Stall-warning changes for 3.20
Message-ID: <20150107175225.GA4237@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0021-0000-0000-00000793C72D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains stall-warning changes, mostly inspired by the
long-running "frequent lockups in 3.18rc4" LKML thread, which may
be found at https://lkml.org/lkml/2014/11/14/656.  Those who denigrate
testing clearly have not been up against trinity.  ;-)

1.	Set default to RCU_CPU_STALL_INFO=y.  This is in preparation for
	eliminating this Kconfig variable entirely in a release or two.

2.	Add rcutorture scripting checks for stall ending before dump start.

3.	Make RCU_CPU_STALL_INFO include number of attempts to force
	quiescent states (which mostly identifies idle CPUs).

4.	Improve diagnostics for spurious RCU CPU stall warnings, for
	example, identifying when RCU's grace-period kthreads have
	been prevented from running.

5.	Handle gpnum/completed wrap while dyntick idle.  This is a
	long-standing known bug, but one that requires a CPU to remain
	idle for 4,294,967,296 grace periods on 32-bit systems, and
	lots more on 64-bit systems.  However, with the advent of
	NO_HZ_FULL, this sort of thing becomes more likely, so time
	to fix it.

6.	Run grace-period kthreads at real-time priority.  Not yet ready
	for mainline, but the 0day test robot reports that it greatly
	reduces the number of hangs seen in testing, so something sort
	of like it is needed.  This patch also reduced the number of
	stalls in the 3.18-rc4 efforts.

7.	Make cond_resched_rcu_qs() apply to normal RCU flavors, allowing
	it to be placed in long-running loops that would otherwise result
	in RCU CPU stall warnings.

8.	Add GP-kthread-starvation checks to CPU stall warnings, making
	previous encoded warnings more human-readable.

9.	Fix RCU CPU stall detection in tiny implementation, courtesy of
	Miroslav Benes.

10.	Initialize tiny RCU stall-warning timeouts at boot.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/stallwarn.txt                         |   14 +
 b/Documentation/RCU/trace.txt                             |   32 +--
 b/include/linux/rcupdate.h                                |    3 
 b/include/linux/rcutiny.h                                 |    5 
 b/include/linux/rcutree.h                                 |    2 
 b/init/Kconfig                                            |    1 
 b/kernel/rcu/tiny.c                                       |    2 
 b/kernel/rcu/tiny_plugin.h                                |    7 
 b/kernel/rcu/tree.c                                       |  119 ++++++++++++--
 b/kernel/rcu/tree.h                                       |    7 
 b/kernel/rcu/tree_plugin.h                                |   10 -
 b/kernel/rcu/tree_trace.c                                 |    8 
 b/lib/Kconfig.debug                                       |    2 
 b/tools/testing/selftests/rcutorture/bin/parse-console.sh |    2 
 14 files changed, 164 insertions(+), 50 deletions(-)

