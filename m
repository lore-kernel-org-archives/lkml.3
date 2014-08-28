Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaH1SiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:38:05 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40087 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaH1SiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:01 -0400
Date: Thu, 28 Aug 2014 11:37:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/14] NOCBs and NO_HZ_FULL changes for 3.18
Message-ID: <20140828183754.GA25488@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-7164-0000-0000-0000042C1C9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series includes changes affecting NOCBs and NO_HZ_FULL operation.

1.	Fix for bug in earlier patch (b58cc46c5f6b, Don't offload
	callbacks unless specifically requested) that properly handles
	early-boot callbacks.  (This bug affects unusual configurations,
	see commit log for more information.)

2.	Properly check the return value of zalloc_cpumask_var(), courtesy
	of Pranith Kumar.

3.	Use bool constant for __call_rcu_nocb() return value, courtesy
	of Pranith Kumar.

4.	Use bool constant for rcu_nocb_adopt_orphan_cbs() return value,
	courtesy of Pranith Kumar.

5.	Use bool constant for __call_rcu_nocb() return value in the case
	where callbacks are not offloaded, courtesy of Pranith Kumar.

6.	Use bool constant for rcu_nocb_adopt_orphan_cbs() return value in
	the case where callbacks are not offloaded, courtesy of Pranith
	Kumar.

7.	Aggregate RCU's kthread creation so that it is all done from a
	single early_initcall() function.

8.	Create rcuo kthreads only for CPUs that actually have come online
	at least once since boot.

9.	Check have_rcu_nocb_mask instead of for a NULL rcu_nocb_mask,
	given that this latter is not necessarily a pointer, courtesy
	of Pranith Kumar.

10.	Eliminate redundant rcu_sysidle_state variable.

11.	Don't bother tracking sysidle state if there are no nohz_full=
	CPUs in the system.

12.	Avoid misordering in __call_rcu_nocb_enqueue().

13.	Handle NOCB callbacks from irq-disabled idle code.

14.	Avoid misordering in nocb_leader_wait().

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcupdate.h |    8 +
 b/init/Kconfig             |    4 
 b/init/main.c              |    1 
 b/kernel/rcu/tree.c        |    4 
 b/kernel/rcu/tree.h        |    1 
 b/kernel/rcu/tree_plugin.h |   92 +++++++++++++++-------
 kernel/rcu/tree.c          |    3 
 kernel/rcu/tree.h          |    6 +
 kernel/rcu/tree_plugin.h   |  182 ++++++++++++++++++++++++++++++++-------------
 9 files changed, 216 insertions(+), 85 deletions(-)

