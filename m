Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaDQPJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:09:08 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43436 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDQPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:04:48 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v9 06/19] qspinlock: prolong the stay in the pending bit path
Date: Thu, 17 Apr 2014 11:03:58 -0400
Message-Id: <1397747051-15401-7-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a problem in the current trylock_pending() function.  When the
lock is free, but the pending bit holder hasn't grabbed the lock &
cleared the pending bit yet, the trylock_pending() function will fail.
As a result, the regular queuing code path will be used most of
the time even when there is only 2 tasks contending for the lock.
Assuming that the pending bit holder is going to get the lock and
clear the pending bit soon, it is actually better to wait than to be
queued up which has a higher overhead.

This patch modified the trylock_pending() function to wait until the
pending bit holder gets the lock and clears the pending bit. In case
both the lock and pending bits are set, the new code will also wait
a bit to see if either one is cleared. If they are not, it will quit
and be queued.

The following tables show the before-patch execution time (in ms)
of a micro-benchmark where 5M iterations of the lock/unlock cycles
were run on a 10-core Westere-EX x86-64 CPU with 2 different types of
loads - standalone (lock and protected data in different cachelines)
and embedded (lock and protected data in the same cacheline).

		  [Standalone/Embedded - same node]
  # of tasks	Ticket lock	Queue lock	 %Change
  ----------	-----------	----------	 -------
       1	  135/ 111	 135/ 101	   0%/  -9%
       2	  890/ 779	1885/1990	+112%/+156%
       3	 1932/1859	2333/2341	 +21%/ +26%
       4	 2829/2726	2900/2923	  +3%/  +7%
       5	 3834/3761	3655/3648	  -5%/  -3%
       6	 4963/4976	4336/4326	 -13%/ -13%
       7	 6299/6269	5057/5064	 -20%/ -19%
       8	 7691/7569	5786/5798	 -25%/ -23%

With 1 task per NUMA node, the execution times are:

		[Standalone - different nodes]
  # of nodes	Ticket lock	Queue lock	%Change
  ----------	-----------	----------	-------
       1	   135		  135		  0%
       2	  4604		 5087		+10%
       3	 10940		12224		+12%
       4	 21555		10555		-51%

It can be seen that the queue spinlock is slower than the ticket
spinlock when there are 2 or 3 contending tasks. In all the other case,
the queue spinlock is either equal or faster than the ticket spinlock.

With this patch, the performance data for 2 contending tasks are:

		  [Standalone/Embedded]
  # of tasks	Ticket lock	Queue lock	%Change
  ----------	-----------	----------	-------
       2	  890/779	 984/871	+11%/+12%

		[Standalone - different nodes]
  # of nodes	Ticket lock	Queue lock	%Change
  ----------	-----------	----------	-------
       2	  4604		   1364		  -70%

It can be seen that the queue spinlock performance for 2 contending
tasks is now comparable to ticket spinlock on the same node, but much
faster when in different nodes. With 3 contending tasks, however,
the ticket spinlock is still quite a bit faster.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/qspinlock.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 55601b4..497da24 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -216,6 +216,7 @@ xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
 static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 {
 	u32 old, new, val = *pval;
+	int retry = 1;
 
 	/*
 	 * trylock || pending
@@ -225,11 +226,38 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 	 */
 	for (;;) {
 		/*
-		 * If we observe any contention; queue.
+		 * If we observe that the queue is not empty,
+		 * return and be queued.
 		 */
-		if (val & ~_Q_LOCKED_MASK)
+		if (val & _Q_TAIL_MASK)
 			return 0;
 
+		if ((val & _Q_LOCKED_PENDING_MASK) ==
+		    (_Q_LOCKED_VAL|_Q_PENDING_VAL)) {
+			/*
+			 * If both the lock and pending bits are set, we wait
+			 * a while to see if that either bit will be cleared.
+			 * If that is no change, we return and be queued.
+			 */
+			if (!retry)
+				return 0;
+			retry--;
+			cpu_relax();
+			cpu_relax();
+			*pval = val = atomic_read(&lock->val);
+			continue;
+		} else if ((val & _Q_LOCKED_PENDING_MASK) == _Q_PENDING_VAL) {
+			/*
+			 * Pending bit is set, but not the lock bit.
+			 * Assuming that the pending bit holder is going to
+			 * set the lock bit and clear the pending bit soon,
+			 * it is better to wait than to exit at this point.
+			 */
+			cpu_relax();
+			*pval = val = atomic_read(&lock->val);
+			continue;
+		}
+
 		new = _Q_LOCKED_VAL;
 		if (val == new)
 			new |= _Q_PENDING_VAL;
-- 
1.7.1

