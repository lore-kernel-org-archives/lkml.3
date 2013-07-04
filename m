Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242Ab3GDDfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:35:07 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43418 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819Ab3GDDfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:35:03 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 12/12] dcache: Enable lockless update of refcount in dentry structure
Date: Wed,  3 Jul 2013 23:34:47 -0400
Message-Id: <1372908887-33585-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code takes the dentry's d_lock lock whenever the
d_refcount is being updated. In reality, nothing big really happens
until d_refcount goes to 0 in dput(). So it is not necessary to take
the lock if the reference count won't go to 0. On the other hand,
there are cases where refcount should not be updated or was not
expected to be updated while d_lock was acquired by another thread.

To use the new lockref infrastructure to do lockless reference count
update, the d_lock and d_refcount field of the dentry structure was
combined into a new d_lockcnt field.

The offsets of the new d_lockcnt field are at byte 72 and 88 for
32-bit and 64-bit SMP systems respectively. In both cases, they are
8-byte aligned and their combination into a single 8-byte word will
not introduce a hole that increase the size of the dentry structure.

This patch has a particular big impact on the short workload of the
AIM7 benchmark with ramdisk filesystem. The table below show the
performance improvement to the JPM (jobs per minutes) throughput
due to this patch on an 8-socket 80-core x86-64 system with a 3.10
kernel in a 1/2/4/8 node configuration by using numactl to restrict
the execution of the workload on certain nodes.

+-----------------+----------------+-----------------+----------+
|  Configuration  |    Mean JPM    |    Mean JPM     | % Change |
|                 | Rate w/o patch | Rate with patch |          |
+-----------------+---------------------------------------------+
|                 |              User Range 10 - 100            |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1650355     |     5191497     | +214.6%  |
| 4 nodes, HT off |    1665137     |     5204267     | +212.5%  |
| 2 nodes, HT off |    1667552     |     3815637     | +128.8%  |
| 1 node , HT off |    2442998     |     2352103     |   -3.7%  |
+-----------------+---------------------------------------------+
|                 |              User Range 200 - 1000          |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1008604     |     5972142     | +492.1%  |
| 4 nodes, HT off |    1317284     |     7190302     | +445.8%  |
| 2 nodes, HT off |    1048363     |     4516400     | +330.8%  |
| 1 node , HT off |    2461802     |     2466583     |   +0.2%  |
+-----------------+---------------------------------------------+
|                 |              User Range 1100 - 2000         |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |     995149     |     6424182     | +545.6%  |
| 4 nodes, HT off |    1313386     |     7012193     | +433.9%  |
| 2 nodes, HT off |    1041411     |     4478519     | +330.0%  |
| 1 node , HT off |    2511186     |     2482650     |   -1.1%  |
+-----------------+----------------+-----------------+----------+

It can be seen that with 20 CPUs (2 nodes) or more, this patch can
significantly improve the short workload performance. With only 1
node, the performance is similar with or without the patch. The short
workload also scales pretty well up to 4 nodes with this patch.

The following table shows the short workload performance difference
of the original 3.10 kernel versus the one with the patch but have
SPINLOCK_REFCOUNT config variable disabled.

+-----------------+----------------+-----------------+----------+
|  Configuration  |    Mean JPM    |    Mean JPM     | % Change |
|                 | Rate w/o patch | Rate with patch |          |
+-----------------+---------------------------------------------+
|                 |              User Range 10 - 100            |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1650355     |     1634232     |   -1.0%  |
| 4 nodes, HT off |    1665137     |     1675791     |   +0.6%  |
| 2 nodes, HT off |    1667552     |     2985552     |  +79.0%  |
| 1 node , HT off |    2442998     |     2396091     |   -1.9%  |
+-----------------+---------------------------------------------+
|                 |              User Range 200 - 1000          |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1008604     |     1005153     |   -0.3%  |
| 4 nodes, HT off |    1317284     |     1330782     |   +1.0%  |
| 2 nodes, HT off |    1048363     |     2056871     |  +96.2%  |
| 1 node , HT off |    2461802     |     2463877     |   +0.1%  |
+-----------------+---------------------------------------------+
|                 |              User Range 1100 - 2000         |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |     995149     |      991157     |   -0.4%  |
| 4 nodes, HT off |    1313386     |     1321806     |   +0.6%  |
| 2 nodes, HT off |    1041411     |     2032808     |  +95.2%  |
| 1 node , HT off |    2511186     |     2483815     |   -1.1%  |
+-----------------+----------------+-----------------+----------+

There are some abnormalities in the original 3.10 2-node data. Ignoring
that, the performance difference for the other node counts, if any,
is insignificant.

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
+  19.65%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
+   3.94%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock
+   2.47%    reaim  [kernel.kallsyms]     [k] lockref_get_not_zero
+   0.62%    reaim  [kernel.kallsyms]     [k] lockref_put_or_locked
+   0.36%    reaim  [kernel.kallsyms]     [k] dput
+   0.31%    reaim  [kernel.kallsyms]     [k] lockref_get
+   0.02%    reaim  [kernel.kallsyms]     [k] dget_parent

-   3.94%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock
   - _raw_spin_lock
      + 32.86% SyS_getcwd
      + 31.99% d_path
      + 4.81% prepend_path
      + 4.14% __rcu_process_callbacks
      + 3.73% complete_walk
      + 2.31% dget_parent
      + 1.99% unlazy_walk
      + 1.44% do_anonymous_page
      + 1.22% lockref_put_or_locked
      + 1.16% sem_lock
      + 0.95% task_rq_lock
      + 0.89% selinux_inode_free_security
      + 0.89% process_backlog
      + 0.79% enqueue_to_backlog
      + 0.72% unix_dgram_sendmsg
      + 0.69% unix_stream_sendmsg

The lockref_put_or_locked used up only 1.22% of the _raw_spin_lock
time while dget_parent used only 2.31%.

This impact of this patch on other AIM7 workloads were much more
modest.  The table below show the mean %change due to this patch on
the same 8-socket system with a 3.10 kernel.

+--------------+---------------+----------------+-----------------+
|   Workload   | mean % change | mean % change  | mean % change   |
|              | 10-100 users  | 200-1000 users | 1100-2000 users |
+--------------+---------------+----------------+-----------------+
| alltests     |     -0.2%     |     +0.5%      |     -0.3%       |
| five_sec     |     +2.5%     |     -4.2%      |     -4.7%       |
| fserver      |     +1.7%     |     +1.6%      |     +0.3%       |
| high_systime |     +0.1%     |     +1.4%      |     +5.5%       |
| new_fserver  |     +0.4%     |     +1.2%      |     +0.3%       |
| shared       |     +0.8%     |     -0.3%      |      0.0%       |
+--------------+---------------+----------------+-----------------+

There are slight drops in performance for the five_sec workload,
but slight increase in the high_systime workload.

The checkpatch.pl scripts reported errors in the d_lock and d_refcount
macros as it wanted to have parentheses around the actual names.
That won't work for those macros and so the errors should be ignored.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c            |   18 ++++++++++++------
 include/linux/dcache.h |   17 ++++++++++-------
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 61d2f11..7bc1022 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -515,7 +515,9 @@ void dput(struct dentry *dentry)
 repeat:
 	if (dentry->d_refcount == 1)
 		might_sleep();
-	spin_lock(&dentry->d_lock);
+	if (lockref_put_or_locked(&dentry->d_lockcnt))
+		return;
+	/* dentry's lock taken */
 	BUG_ON(!dentry->d_refcount);
 	if (dentry->d_refcount > 1) {
 		dentry->d_refcount--;
@@ -611,26 +613,30 @@ static inline void __dget_dlock(struct dentry *dentry)
 
 static inline void __dget(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
-	__dget_dlock(dentry);
-	spin_unlock(&dentry->d_lock);
+	lockref_get(&dentry->d_lockcnt);
 }
 
 struct dentry *dget_parent(struct dentry *dentry)
 {
 	struct dentry *ret;
 
+	rcu_read_lock();
+	ret = rcu_dereference(dentry->d_parent);
+	if (lockref_get_not_zero(&ret->d_lockcnt)) {
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
index f0fd214..aebb09e 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -9,6 +9,7 @@
 #include <linux/seqlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock_refcount.h>
 
 struct nameidata;
 struct path;
@@ -112,8 +113,7 @@ struct dentry {
 	unsigned char d_iname[DNAME_INLINE_LEN];	/* small names */
 
 	/* Ref lookup also touches following */
-	unsigned int d_refcount;	/* protected by d_lock */
-	spinlock_t d_lock;		/* per dentry lock */
+	struct lockref d_lockcnt;	/* per dentry lock & count */
 	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
 	unsigned long d_time;		/* used by d_revalidate */
@@ -132,6 +132,12 @@ struct dentry {
 };
 
 /*
+ * Define macros to access the now hidden spinlock and reference count
+ */
+#define d_lock		d_lockcnt.lock
+#define d_refcount	d_lockcnt.refcnt
+
+/*
  * dentry->d_lock spinlock nesting subclasses:
  *
  * 0: normal
@@ -358,11 +364,8 @@ static inline struct dentry *dget_dlock(struct dentry *dentry)
 
 static inline struct dentry *dget(struct dentry *dentry)
 {
-	if (dentry) {
-		spin_lock(&dentry->d_lock);
-		dget_dlock(dentry);
-		spin_unlock(&dentry->d_lock);
-	}
+	if (dentry)
+		lockref_get(&dentry->d_lockcnt);
 	return dentry;
 }
 
-- 
1.7.1

