Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab3DSI7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 04:59:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3DSI7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 04:59:08 -0400
Date: Fri, 19 Apr 2013 01:58:31 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-0dc8c730c98a06a4d927f8d08bd0dd6de973b8dd@git.kernel.org>
Cc: mingo@kernel.org, williams@redhat.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, akpm@linux-foundation.org, tglx@linutronix.de,
        scott.norton@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        davidlohr.bueso@hp.com, davej@redhat.com, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, aswin@hp.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, williams@redhat.com, peterz@infradead.org,
        riel@redhat.com, Waiman.Long@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, scott.norton@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, davidlohr.bueso@hp.com, davej@redhat.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, aswin@hp.com
In-Reply-To: <1366226594-5506-3-git-send-email-Waiman.Long@hp.com>
References: <1366226594-5506-3-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutex:
  Make more scalable by doing less atomic operations
Git-Commit-ID: 0dc8c730c98a06a4d927f8d08bd0dd6de973b8dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Apr 2013 01:58:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0dc8c730c98a06a4d927f8d08bd0dd6de973b8dd
Gitweb:     http://git.kernel.org/tip/0dc8c730c98a06a4d927f8d08bd0dd6de973b8dd
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Wed, 17 Apr 2013 15:23:12 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Apr 2013 09:33:35 +0200

mutex: Make more scalable by doing less atomic operations

In the __mutex_lock_common() function, an initial entry into
the lock slow path will cause two atomic_xchg instructions to be
issued. Together with the atomic decrement in the fast path, a
total of three atomic read-modify-write instructions will be
issued in rapid succession. This can cause a lot of cache
bouncing when many tasks are trying to acquire the mutex at the
same time.

This patch will reduce the number of atomic_xchg instructions
used by checking the counter value first before issuing the
instruction. The atomic_read() function is just a simple memory
read. The atomic_xchg() function, on the other hand, can be up
to 2 order of magnitude or even more in cost when compared with
atomic_read(). By using atomic_read() to check the value first
before calling atomic_xchg(), we can avoid a lot of unnecessary
cache coherency traffic. The only downside with this change is
that a task on the slow path will have a tiny bit less chance of
getting the mutex when competing with another task in the fast
path.

The same is true for the atomic_cmpxchg() function in the
mutex-spin-on-owner loop. So an atomic_read() is also performed
before calling atomic_cmpxchg().

The mutex locking and unlocking code for the x86 architecture
can allow any negative number to be used in the mutex count to
indicate that some tasks are waiting for the mutex. I am not so
sure if that is the case for the other architectures. So the
default is to avoid atomic_xchg() if the count has already been
set to -1. For x86, the check is modified to include all
negative numbers to cover a larger case.

The following table shows the jobs per minutes (JPM) scalability
data on an 8-node 80-core Westmere box with a 3.7.10 kernel. The
numactl command is used to restrict the running of the
high_systime workloads to 1/2/4/8 nodes with hyperthreading on
and off.

+-----------------+-----------+------------+----------+
|  Configuration  | Mean JPM  |  Mean JPM  | % Change |
|		  | w/o patch | with patch |	      |
+-----------------+-----------------------------------+
|		  |      User Range 1100 - 2000	      |
+-----------------+-----------------------------------+
| 8 nodes, HT on  |    36980   |   148590  | +301.8%  |
| 8 nodes, HT off |    42799   |   145011  | +238.8%  |
| 4 nodes, HT on  |    61318   |   118445  |  +51.1%  |
| 4 nodes, HT off |   158481   |   158592  |   +0.1%  |
| 2 nodes, HT on  |   180602   |   173967  |   -3.7%  |
| 2 nodes, HT off |   198409   |   198073  |   -0.2%  |
| 1 node , HT on  |   149042   |   147671  |   -0.9%  |
| 1 node , HT off |   126036   |   126533  |   +0.4%  |
+-----------------+-----------------------------------+
|		  |       User Range 200 - 1000	      |
+-----------------+-----------------------------------+
| 8 nodes, HT on  |   41525    |   122349  | +194.6%  |
| 8 nodes, HT off |   49866    |   124032  | +148.7%  |
| 4 nodes, HT on  |   66409    |   106984  |  +61.1%  |
| 4 nodes, HT off |  119880    |   130508  |   +8.9%  |
| 2 nodes, HT on  |  138003    |   133948  |   -2.9%  |
| 2 nodes, HT off |  132792    |   131997  |   -0.6%  |
| 1 node , HT on  |  116593    |   115859  |   -0.6%  |
| 1 node , HT off |  104499    |   104597  |   +0.1%  |
+-----------------+------------+-----------+----------+

At low user range 10-100, the JPM differences were within +/-1%.
So they are not that interesting.

AIM7 benchmark run has a pretty large run-to-run variance due to
random nature of the subtests executed. So a difference of less
than +-5% may not be really significant.

This patch improves high_systime workload performance at 4 nodes
and up by maintaining transaction rates without significant
drop-off at high node count.  The patch has practically no
impact on 1 and 2 nodes system.

The table below shows the percentage time (as reported by perf
record -a -s -g) spent on the __mutex_lock_slowpath() function
by the high_systime workload at 1500 users for 2/4/8-node
configurations with hyperthreading off.

+---------------+-----------------+------------------+---------+
| Configuration | %Time w/o patch | %Time with patch | %Change |
+---------------+-----------------+------------------+---------+
|    8 nodes    |      65.34%     |      0.69%       |  -99%   |
|    4 nodes    |       8.70%	  |      1.02%	     |  -88%   |
|    2 nodes    |       0.41%     |      0.32%       |  -22%   |
+---------------+-----------------+------------------+---------+

It is obvious that the dramatic performance improvement at 8
nodes was due to the drastic cut in the time spent within the
__mutex_lock_slowpath() function.

The table below show the improvements in other AIM7 workloads
(at 8 nodes, hyperthreading off).

+--------------+---------------+----------------+-----------------+
|   Workload   | mean % change | mean % change  | mean % change   |
|              | 10-100 users  | 200-1000 users | 1100-2000 users |
+--------------+---------------+----------------+-----------------+
| alltests     |     +0.6%     |   +104.2%      |   +185.9%       |
| five_sec     |     +1.9%     |     +0.9%      |     +0.9%       |
| fserver      |     +1.4%     |     -7.7%      |     +5.1%       |
| new_fserver  |     -0.5%     |     +3.2%      |     +3.1%       |
| shared       |    +13.1%     |   +146.1%      |   +181.5%       |
| short        |     +7.4%     |     +5.0%      |     +4.2%       |
+--------------+---------------+----------------+-----------------+

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chandramouleeswaran Aswin <aswin@hp.com>
Cc: Norton: Scott J <scott.norton@hp.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1366226594-5506-3-git-send-email-Waiman.Long@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/mutex.h | 10 ++++++++++
 kernel/mutex.c               | 19 ++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mutex.h b/arch/x86/include/asm/mutex.h
index 7d3a482..bc2a0b0 100644
--- a/arch/x86/include/asm/mutex.h
+++ b/arch/x86/include/asm/mutex.h
@@ -3,3 +3,13 @@
 #else
 # include <asm/mutex_64.h>
 #endif
+
+#ifndef	__ASM_MUTEX_H
+#define	__ASM_MUTEX_H
+/*
+ * For the x86 architecture, it allows any negative number (besides -1) in
+ * the mutex count to indicate that some other threads are waiting on the
+ * mutex.
+ */
+#define __ARCH_ALLOW_ANY_NEGATIVE_MUTEX_COUNT	1
+#endif
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 262d717..70ebd85 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -37,6 +37,17 @@
 # include <asm/mutex.h>
 #endif
 
+/*
+ * A mutex count of -1 indicates that waiters are sleeping waiting for the
+ * mutex. Some architectures can allow any negative number, not just -1, for
+ * this purpose.
+ */
+#ifdef __ARCH_ALLOW_ANY_NEGATIVE_MUTEX_COUNT
+#define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) >= 0)
+#else
+#define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) != -1)
+#endif
+
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
@@ -217,7 +228,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
-		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+		if ((atomic_read(&lock->count) == 1) &&
+		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
 			mutex_set_owner(lock);
 			preempt_enable();
@@ -251,7 +263,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
-	if (atomic_xchg(&lock->count, -1) == 1)
+	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, -1) == 1))
 		goto done;
 
 	lock_contended(&lock->dep_map, ip);
@@ -266,7 +278,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * that when we release the lock, we properly wake up the
 		 * other waiters:
 		 */
-		if (atomic_xchg(&lock->count, -1) == 1)
+		if (MUTEX_SHOW_NO_WAITER(lock) &&
+		   (atomic_xchg(&lock->count, -1) == 1))
 			break;
 
 		/*
