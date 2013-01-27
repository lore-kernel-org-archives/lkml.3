Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3A0FTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 00:19:18 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:57676 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3A0FQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 00:16:06 -0500
Date: Sat, 26 Jan 2013 16:29:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/14] v2 RCU idle/no-CB changes for 3.9
Message-ID: <20130127002943.GA6067@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012705-7282-0000-0000-00001386F395
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains changes to RCU_FAST_NO_HZ idle entry/exit and also
removes restrictions on no-CBs CPUs.  This series contains some commits
that are still a bit on experimental side, so you should avoid using
these patches unless you would like to help debug them.  ;-)

1.	Remove restrictions on no-CBs CPUs.  This patch is probably the
	highest-risk of the group.
2.	Allow some control of no-CBs CPUs at kernel-build time.  The option
	of most interest is probably the one that makes -all- CPUs be
	no-CBs CPUs.
3.	Distinguish the no-CBs kthreads for the various RCU flavors.
	Without this patch, CPU 0 would have up to three kthreads all
	named "rcuo0", which is less than optimal.
4.	Export RCU_FAST_NO_HZ parameters to sysfs to allow run-time
	adjustment.
5.	Re-introduce callback acceleration during grace-period cleanup.
	Now that the callbacks are associated with specific grace periods,
	such acceleration is idempotent, and it is now safe to accelerate
	more than needed.  (In contrast, in the past, too-frequent callback
	acceleration resulted in infrequent RCU failures.)
6.	Use the newly numbered callbacks to greatly reduce the CPU overhead
	incurred at idle entry by RCU_FAST_NO_HZ.  The fact that the
	callbacks are now numbered means that instead of repeatedly
	cranking the RCU state machine to try to get all callbacks
	invoked, we can instead rely on the numbering so that the CPU
	can take full advantage of any grace periods that elapse while
	it is asleep.  CPUs with callbacks still have limited sleep times,
	especially if they have at least one non-lazy callback queued.
7-12.	Allow CPUs to make known their need for future grace periods,
	which is also used to reduce the need for frenetic RCU
	state-machine cranking upon RCU_FAST_NO_HZ entry to idle.
	7.	Move the release of the root rcu_node structure's ->lock
		to then end of rcu_start_gp().
	8.	Repurpose no-CB's grace-period event tracing to that of
		future grace periods, which share no-CB's grace-period
		mechanism.
	9.	Move the release of the root rcu_node structure's ->lock
		to rcu_start_gp()'s callers.
	10.	Rename the rcu_node ->n_nocb_gp_requests field to
		->need_future_gp.
	11.	Abstract rcu_start_future_gp() from rcu_nocb_wait_gp()
		to that RCU_FAST_NO_HZ can use the no-CB CPUs mechanism
		for allowing a CPU to record its need for future grace
		periods.
	12.	Make rcu_accelerate_cbs() note the need for future
		grace periods, thus avoiding delays in starting grace
		periods that currently happen due to the CPUs needing
		those grace periods being out of action when the previous
		grace period ends.

Changes since v1:

o	Fixed a deadlock in #1 spotted by Xie ChanglongX.
o	Updated #2 to bring the abbreviations in line with conventional
	per-CPU kthread naming.
o	Moved the first two patches into their own group.

								Thanx, Paul


 b/Documentation/kernel-parameters.txt |    7 
 b/include/linux/rcupdate.h            |    1 
 b/include/trace/events/rcu.h          |   71 ++
 b/init/Kconfig                        |   52 +-
 b/kernel/rcutree.c                    |  277 ++++++++--
 b/kernel/rcutree.h                    |   39 -
 b/kernel/rcutree_plugin.h             |  865 ++++++++++++++--------------------
 b/kernel/rcutree_trace.c              |    2 
 8 files changed, 710 insertions(+), 604 deletions(-)

