Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3KPAXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:23:31 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36458 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3KPAXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:23 -0500
Date: Fri, 15 Nov 2013 16:23:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/16] Fixes for 3.14
Message-ID: <20131116002316.GA29049@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1344-0000-0000-0000034C8CC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains miscellaneous fixes for RCU:

1.	Kick CPUs when they get halfway to the stall-warning timeout.

2.	Because wait_event() and wake_up() do not necessarily imply
	full memory barriers, supply them as needed.

3.	Fix a deadlock between RCU, scheduler, and perf by deferring
	wake-ups until locks are dropped.

4.	Allow task-level idle entry/exit nesting.

5.	Fix srcu_barrier()'s docbook header.

6.	Announce rcu_node geometry adjustment at boot time.

7.	Fix some bool-return bugs detected by coccinelle,
	courtesy of Fengguang Wu.

8.	Make CONFIG_RCU_FANOUT_EXACT work correctly for oddball
	CONFIG_RCU_FANOUT and CONFIG_RCU_FANOUT_LEAF values.
	(They were so oddball that even I wasn't testing them,
	but they still need to be fixed.)

9.	Provide function-header documentation of memory-barrier guarantees
	provided by synchronize_srcu() and call_srcu().

10.	Improve diagnostics for blocking in RCU callback functions.

11.	Warn on allegedly impossible rcu_read_unlock_special() from irq.
	And fix the first allegedly impossible warning that triggered. ;-)
	Courtesy of Lai Jiangshan.

12.	Add smp_mb__after_srcu_read_unlock() to force full barrier
	in conjunction with srcu_read_unlock(), courtesy of Michael
	S. Tsirkin.

13.	Refuse to activate RCU core on NO_HZ_FULL CPUs, at least until
	the grace period gets too long in the tooth.

14.	Dynamically allocate rcutorture buffer for SRCU output to avoid
	potential buffer overflows, courtesy of Chen Gang.

15-16:	Remove "extern" declarations, courtesy of Teodora Baluta.

							Thanx, Paul

 b/Documentation/RCU/trace.txt |   20 +++++----
 b/include/linux/rculist.h     |    4 -
 b/include/linux/rcupdate.h    |   81 +++++++++++++++++++-------------------
 b/include/linux/rcutiny.h     |    2 
 b/include/linux/rcutree.h     |   36 ++++++++--------
 b/include/linux/srcu.h        |   14 ++++++
 b/kernel/rcu/rcu.h            |    5 +-
 b/kernel/rcu/srcu.c           |   57 +++++++++++++++++++++++---
 b/kernel/rcu/torture.c        |   75 ++++++++++++++++++-----------------
 b/kernel/rcu/tree.c           |   79 ++++++++++++++++++++++++++++++-------
 b/kernel/rcu/tree.h           |   12 ++++-
 b/kernel/rcu/tree_plugin.h    |   89 +++++++++++++++++++++++++++++++++++-------
 b/kernel/rcu/tree_trace.c     |    3 -
 b/kernel/rcu/update.c         |    5 ++
 14 files changed, 339 insertions(+), 143 deletions(-)

