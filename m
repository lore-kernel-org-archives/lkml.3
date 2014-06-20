Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966844AbaFTSc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:32:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57956 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966270AbaFTSc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:32:56 -0400
Date: Fri, 20 Jun 2014 11:32:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/5] Fix for cond_resched performance regression
Message-ID: <20140620183249.GA6325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062018-1344-0000-0000-00000253DB0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains changes to address the performance regressions
introduced by commit ac1bea85781e (Make cond_resched() report RCU
quiescent states), which was in turn fixing a problem where tasks looping
in the kernel could delay RCU grace periods.  The changes in this series
are as follows:

1.	Reduce the overhead of checking added to cond_resched() and friends.

2.	Add a new cond_resched_rcu_qs() to provide RCU quiescent states
	even if cond_resched() should stop doing so.

3.	Add a new RCU_COND_RESCHED_QS to prevent cond_resched() from
	reporting RCU quiescent states.

4.	Prevent rcutorture testing from reporting spurious RCU CPU stall
	warnings, and also to test RCU_COND_RESCHED_QS.

5.	Provides a boot/sysfs rcutree.jiffies_till_cond_resched_qs
	parameter to replace the magic "7".

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/kernel-parameters.txt                   |    7 +
 b/fs/file.c                                             |    2 
 b/include/linux/rcupdate.h                              |   35 -----
 b/include/linux/rcutiny.h                               |   17 ++
 b/include/linux/rcutree.h                               |   44 ++++++
 b/init/Kconfig                                          |   26 +++
 b/kernel/rcu/rcutorture.c                               |    4 
 b/kernel/rcu/tree.c                                     |  111 +++++++++++++---
 b/kernel/rcu/tree.h                                     |    6 
 b/kernel/rcu/tree_plugin.h                              |    4 
 b/kernel/rcu/update.c                                   |   18 --
 b/mm/mlock.c                                            |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01 |    1 
 13 files changed, 201 insertions(+), 76 deletions(-)

