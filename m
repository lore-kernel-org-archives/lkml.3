Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762376Ab3DDOzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:55:13 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:13331 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762241Ab3DDOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:55:09 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>
Subject: [PATCH RFC 2/3] mutex: restrict mutex spinning to only one task per mutex
Date: Thu,  4 Apr 2013 10:54:17 -0400
Message-Id: <1365087258-7169-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current mutex spinning code allow multiple tasks to spin on a
single mutex concurrently. There are two major problems with this
approach:

 1. This is not very energy efficient as the spinning tasks are not
    doing useful work. The spinning tasks may also block other more
    important or useful tasks from running as preemption is disabled.
    Only one of the spinners will get the mutex at any time. The
    other spinners will have to wait for much longer to get it.

 2. The mutex data structure on x86-64 should be 32 bytes. The spinning
    code spin on lock->owner which, in most cases, should be in the same
    64-byte cache line as the lock->wait_lock spinlock. As a result,
    the mutex spinners are contending the same cacheline with other
    CPUs trying to get the spinlock leading to increased time spent
    on the spinlock as well as on the mutex spinning.

These problems are worse on system with large number of CPUs. One way
to reduce the effect of these two problems is to allow only one task
to be spinning on a mutex at any time.

This patch adds a new spinner field in the mutex.h to limit the
number of spinner to only one task. That will increase the size of
the mutex by 8 bytes in a 64-bit environment (4 bytes in a 32-bit
environment).

The AIM7 benchmarks were run on 3.7.10 derived kernels to show the
performance changes with this patch on a 8-socket 80-core system
with hyperthreading off.  The table below shows the mean % change
in performance over a range of users for some AIM7 workloads with
just the less atomic operation patch (patch 1) vs the less atomic
operation patch plus this one (patches 1+2).

+--------------+-----------------+-----------------+-----------------+
|   Workload   | mean % change   | mean % change   | mean % change   |
|              | 10-100 users    | 200-1000 users  | 1100-2000 users |
+--------------+-----------------+-----------------+-----------------+
| alltests     |     -0.2%       |     -3.8%       |    -4.2%        |
| five_sec     |     -0.6%       |     -2.0%       |    -2.4%        |
| fserver      |     +2.2%       |    +16.2%       |    +2.2%        |
| high_systime |     -0.3%       |     -4.3%       |    -3.0%        |
| new_fserver  |     +3.9%       |    +16.0%       |    +9.5%        |
| shared       |     -1.7%       |     -5.0%       |    -4.0%        |
| short        |     -7.7%       |     +0.2%       |    +1.3%        |
+--------------+-----------------+-----------------+-----------------+

It can be seen that this patch improves performance for the fserver and
new_fserver workloads while suffering some slight drop in performance
for the other workloads.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 include/linux/mutex.h |    3 +++
 kernel/mutex.c        |   12 ++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 9121595..dd8fdb8 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -50,6 +50,9 @@ struct mutex {
 	atomic_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
+	struct task_struct	*spinner;
+#endif
 #if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
 	struct task_struct	*owner;
 #endif
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 5e5ea03..965f59f 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -158,7 +158,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 *
 	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
 	 * to serialize everything.
+	 *
+	 * Only first task is allowed to spin on a given mutex and that
+	 * task will put its task_struct pointer into the spinner field.
 	 */
+	if (lock->spinner || (cmpxchg(&lock->spinner, NULL, current) != NULL))
+		goto slowpath;
 
 	for (;;) {
 		struct task_struct *owner;
@@ -175,6 +180,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
 			mutex_set_owner(lock);
+			lock->spinner = NULL;
 			preempt_enable();
 			return 0;
 		}
@@ -196,6 +202,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 */
 		arch_mutex_cpu_relax();
 	}
+
+	/*
+	 * Done with spinning
+	 */
+	lock->spinner = NULL;
+slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
-- 
1.7.1

