Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3FZRod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:44:33 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:38939 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3FZRny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:43:54 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v2 2/2] dcache: Locklessly update d_count whenever possible
Date: Wed, 26 Jun 2013 13:43:23 -0400
Message-Id: <1372268603-46748-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code takes the dentry's d_lock lock whenever the d_count
reference count is being updated. In reality, nothing big really
happens until d_count goes to 0 in dput(). So it is not necessary
to take the lock if the reference count won't go to 0. On the other
hand, there are cases where d_count should not be updated or was not
expected to be updated while d_lock was acquired by another thread.

The new mechanism for locklessly update a reference count in the
spinlock & reference count combo was used to ensure that the reference
count was updated locklessly as much as possible.

The offsets of the d_count/d_lock combo are at byte 72 and 88 for
32-bit and 64-bit SMP systems respectively. In both cases, they are
8-byte aligned and their combination into a single 8-byte word will
not introduce a hole that increase the size of the dentry structure.

This patch has a particular big impact on the short workload of the
AIM7 benchmark with ramdisk filesystem. The table below show the
performance improvement to the JPM (jobs per minutes) throughput due
to this patch on an 8-socket 80-core x86-64 system with a 3.10-rc4
kernel in a 1/2/4/8 node configuration by using numactl to restrict
the execution of the workload on certain nodes.

+-----------------+----------------+-----------------+----------+
|  Configuration  |    Mean JPM    |    Mean JPM     | % Change |
|                 | Rate w/o patch | Rate with patch |          |
+-----------------+---------------------------------------------+
|                 |              User Range 10 - 100            |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1596798     |     4721367     | +195.7%  |
| 4 nodes, HT off |    1653817     |     5020983     | +203.6%  |
| 2 nodes, HT off |    3802258     |     3813229     |   +0.3%  |
| 1 node , HT off |    2403297     |     2433240     |   +1.3%  |
+-----------------+---------------------------------------------+
|                 |              User Range 200 - 1000          |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1070992     |     5878321     | +448.9%  |
| 4 nodes, HT off |    1367668     |     7578718     | +454.1%  |
| 2 nodes, HT off |    4554370     |     4614674     |   +1.3%  |
| 1 node , HT off |    2534826     |     2540622     |   +0.2%  |
+-----------------+---------------------------------------------+
|                 |              User Range 1100 - 2000         |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1061322     |     6397776     | +502.8%  |
| 4 nodes, HT off |    1365111     |     6980558     | +411.3%  |
| 2 nodes, HT off |    4583947     |     4637919     |   +1.2%  |
| 1 node , HT off |    2563721     |     2587611     |   +0.9%  |
+-----------------+----------------+-----------------+----------+

It can be seen that with 40 CPUs (4 nodes) or more, this patch can
significantly improve the short workload performance. With only 1 or
2 nodes, the performance is similar with or without the patch. The
short workload also scales pretty well up to 4 nodes with this patch.

A perf call-graph report of the short workload at 1500 users
without the patch on the same 8-node machine indicates that about
78% of the workload's total time were spent in the _raw_spin_lock()
function. Almost all of which can be attributed to the following 2
kernel functions:
 1. dget_parent (49.91%)
 2. dput (49.89%)

The relevant perf report lines are:
+  78.37%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock
+   0.09%    reaim  [kernel.kallsyms]     [k] dput
+   0.05%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock_irq
+   0.00%    reaim  [kernel.kallsyms]     [k] dget_parent

With this patch installed, the new perf report lines are:
+  12.24%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
+   4.82%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock
+   3.26%    reaim  [kernel.kallsyms]     [k] dget_parent
+   1.08%    reaim  [kernel.kallsyms]     [k] dput

-   4.82%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock
   - _raw_spin_lock
      + 34.41% d_path
      + 33.22% SyS_getcwd
      + 4.38% prepend_path
      + 3.71% dget_parent
      + 2.54% inet_twsk_schedule
      + 2.44% complete_walk
      + 2.01% __rcu_process_callbacks
      + 1.78% dput
      + 1.36% unlazy_walk
      + 1.18% do_anonymous_page
      + 1.10% sem_lock
      + 0.82% process_backlog
      + 0.78% task_rq_lock
      + 0.67% selinux_inode_free_security
      + 0.60% unix_dgram_sendmsg
      + 0.54% enqueue_to_backlog

The dput used up only 1.78% of the _raw_spin_lock time while
dget_parent used only 3.71%. The time spent on dput and dget_parent
did increase because of busy waiting for unlock as well as the overhead
of doing cmpxchg operations.

This impact of this patch on other AIM7 workloads were much more
modest.  The table below show the mean %change due to this patch on
the same 8-socket system with a 3.10-rc4 kernel.

+--------------+---------------+----------------+-----------------+
|   Workload   | mean % change | mean % change  | mean % change   |
|              | 10-100 users  | 200-1000 users | 1100-2000 users |
+--------------+---------------+----------------+-----------------+
| alltests     |      0.0%     |     -0.8%      |     +0.1%       |
| five_sec     |     -2.4%     |     +1.7%      |     -0.1%       |
| fserver      |     -1.8%     |     -2.4%      |     -2.1%       |
| high_systime |     +0.1%     |     +0.7%      |     +2.1%       |
| new_fserver  |     +0.2%     |     -1.7%      |     -0.9%       |
| shared       |     -0.1%     |      0.0%      |     -0.1%       |
+--------------+---------------+----------------+-----------------+

There are slight drops in performance for fsever and new_fserver
workloads, but slight increase in the high_systime workload.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c            |   14 ++++++++++++--
 include/linux/dcache.h |    6 ++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f09b908..1f8f78d 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -515,6 +515,8 @@ void dput(struct dentry *dentry)
 repeat:
 	if (dentry->d_count == 1)
 		might_sleep();
+	else if (lockref_put(dentry, d_lock, d_count))
+		return;
 	spin_lock(&dentry->d_lock);
 	BUG_ON(!dentry->d_count);
 	if (dentry->d_count > 1) {
@@ -611,6 +613,8 @@ static inline void __dget_dlock(struct dentry *dentry)
 
 static inline void __dget(struct dentry *dentry)
 {
+	if (lockref_get(dentry, d_lock, d_count))
+		return;
 	spin_lock(&dentry->d_lock);
 	__dget_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -620,17 +624,23 @@ struct dentry *dget_parent(struct dentry *dentry)
 {
 	struct dentry *ret;
 
+	rcu_read_lock();
+	ret = rcu_dereference(dentry->d_parent);
+	if (lockref_get0(ret, d_lock, d_count)) {
+		rcu_read_unlock();
+		return ret;
+	}
 repeat:
 	/*
 	 * Don't need rcu_dereference because we re-check it was correct under
 	 * the lock.
 	 */
-	rcu_read_lock();
-	ret = dentry->d_parent;
+	ret = ACCESS_ONCE(dentry->d_parent);
 	spin_lock(&ret->d_lock);
 	if (unlikely(ret != dentry->d_parent)) {
 		spin_unlock(&ret->d_lock);
 		rcu_read_unlock();
+		rcu_read_lock();
 		goto repeat;
 	}
 	rcu_read_unlock();
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 1a6bb81..35d900a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -6,6 +6,7 @@
 #include <linux/rculist.h>
 #include <linux/rculist_bl.h>
 #include <linux/spinlock.h>
+#include <linux/spinlock_refcount.h>
 #include <linux/seqlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
@@ -112,8 +113,7 @@ struct dentry {
 	unsigned char d_iname[DNAME_INLINE_LEN];	/* small names */
 
 	/* Ref lookup also touches following */
-	unsigned int d_count;		/* protected by d_lock */
-	spinlock_t d_lock;		/* per dentry lock */
+	LOCK_WITH_REFCOUNT(d_lock, d_count);	/* per dentry lock & count */
 	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
 	unsigned long d_time;		/* used by d_revalidate */
@@ -359,6 +359,8 @@ static inline struct dentry *dget_dlock(struct dentry *dentry)
 static inline struct dentry *dget(struct dentry *dentry)
 {
 	if (dentry) {
+		if (lockref_get(dentry, d_lock, d_count))
+			return dentry;
 		spin_lock(&dentry->d_lock);
 		dget_dlock(dentry);
 		spin_unlock(&dentry->d_lock);
-- 
1.7.1

