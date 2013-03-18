Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab3CRVg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:36:27 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39700 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab3CRVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:36:22 -0400
Date: Mon, 18 Mar 2013 14:36:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/15] v3 RCU idle/no-CB changes for 3.10
Message-ID: <20130318213608.GA20296@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-2876-0000-0000-0000067435B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains changes to RCU_FAST_NO_HZ idle entry/exit and also
removes restrictions on no-CBs CPUs.

1.	Remove restrictions on no-CBs CPUs.
2.	Allow some control of no-CBs CPUs at kernel-build time.  The option
	of most interest is probably the one that makes -all- CPUs be
	no-CBs CPUs.
3.	Introduce proper blocking to grace-period waits for no-CBs CPUs.
4.	Add event tracing for no-CBs CPU callback registration.
5.	Add event tracing for no-CBs CPU grace periods.
6.	Distinguish the no-CBs kthreads for the various RCU flavors.
	Without this patch, CPU 0 would have up to three kthreads all
	named "rcuo0", which is less than optimal.  These kthreads
	are now named "rcuob/0", "rcuop/0", and "rcuos/0".
7.	Export RCU_FAST_NO_HZ parameters to sysfs to allow run-time
	adjustment.
8.	Re-introduce callback acceleration during grace-period cleanup.
	Now that the callbacks are associated with specific grace periods,
	such acceleration is idempotent, and it is now safe to accelerate
	more than needed.  (In contrast, in the past, too-frequent callback
	acceleration resulted in infrequent RCU failures.)
9.	Use the newly numbered callbacks to greatly reduce the CPU overhead
	incurred at idle entry by RCU_FAST_NO_HZ.  The fact that the
	callbacks are now numbered means that instead of repeatedly
	cranking the RCU state machine to try to get all callbacks
	invoked, we can instead rely on the numbering so that the CPU
	can take full advantage of any grace periods that elapse while
	it is asleep.  CPUs with callbacks still have limited sleep times,
	especially if they have at least one non-lazy callback queued.
10-15.	Allow CPUs to make known their need for future grace periods,
	which is also used to reduce the need for frenetic RCU
	state-machine cranking upon RCU_FAST_NO_HZ entry to idle.
	10.	Move the release of the root rcu_node structure's ->lock
		to then end of rcu_start_gp().
	11.	Repurpose no-CB's grace-period event tracing to that of
		future grace periods, which share no-CB's grace-period
		mechanism.
	12.	Move the release of the root rcu_node structure's ->lock
		to rcu_start_gp()'s callers.
	13.	Rename the rcu_node ->n_nocb_gp_requests field to
		->need_future_gp.
	14.	Abstract rcu_start_future_gp() from rcu_nocb_wait_gp()
		to that RCU_FAST_NO_HZ can use the no-CB CPUs mechanism
		for allowing a CPU to record its need for future grace
		periods.
	15.	Make rcu_accelerate_cbs() note the need for future
		grace periods, thus avoiding delays in starting grace
		periods that currently happen due to the CPUs needing
		those grace periods being out of action when the previous
		grace period ends.

Changes since v2:

o	Broke initial patch into smaller pieces.
o	Significant additional testing completed.

Changes since v1:

o	Fixed a deadlock in #1 spotted by Xie ChanglongX.
o	Updated #2 to bring the abbreviations in line with conventional
	per-CPU kthread naming.
o	Moved the first two patches into their own group.

								Thanx, Paul


 b/Documentation/kernel-parameters.txt |   35 -
 b/include/linux/rcupdate.h            |    1 
 b/include/trace/events/rcu.h          |   71 ++
 b/init/Kconfig                        |   71 ++
 b/kernel/rcutree.c                    |  279 +++++++---
 b/kernel/rcutree.h                    |   43 -
 b/kernel/rcutree_plugin.h             |  935 +++++++++++++---------------------
 b/kernel/rcutree_trace.c              |    2 
 8 files changed, 756 insertions(+), 681 deletions(-)

