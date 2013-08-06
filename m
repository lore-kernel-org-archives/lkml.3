Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3HFDNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:13:23 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:46683 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3HFDNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:13:09 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v7 4/4] dcache: Enable lockless update of dentry's refcount
Date: Mon,  5 Aug 2013 23:12:39 -0400
Message-Id: <1375758759-29629-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code takes the dentry's d_lock lock whenever the refcnt
is being updated. In reality, nothing big really happens until refcnt
goes to 0 in dput(). So it is not necessary to take the lock if the
reference count won't go to 0. On the other hand, there are cases
where refcnt should not be updated or was not expected to be updated
while d_lock was acquired by another thread.

This patch changes the code in dput(), dget(), __dget() and
dget_parent() to use lockless reference count update function calls.

This patch has a particular big impact on the short workload of the
AIM7 benchmark with ramdisk filesystem. The table below show the
performance improvement to the JPM (jobs per minutes) throughput due
to this patch on an 8-socket 80-core x86-64 system with a 3.11-rc3
kernel in a 1/2/4/8 node configuration by using numactl to restrict
the execution of the workload on certain nodes.

+-----------------+----------------+-----------------+----------+
|  Configuration  |    Mean JPM    |    Mean JPM     | % Change |
|                 | Rate w/o patch | Rate with patch |          |
+-----------------+---------------------------------------------+
|                 |              User Range 10 - 100            |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1760523     |     4225737     | +140.0%  |
| 4 nodes, HT off |    2020076     |     3206202     |  +58.7%  |
| 2 nodes, HT off |    2391359     |     2654701     |  +11.0%  |
| 1 node , HT off |    2302912     |     2302433     |    0.0%  |
+-----------------+---------------------------------------------+
|                 |              User Range 200 - 1000          |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1078421     |     7380760     | +584.4%  |
| 4 nodes, HT off |    1371040     |     4212007     | +207.2%  |
| 2 nodes, HT off |    2844720     |     2783442     |   -2.2%  |
| 1 node , HT off |    2433443     |     2415590     |   -0.7%  |
+-----------------+---------------------------------------------+
|                 |              User Range 1100 - 2000         |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1055626     |     7118985     | +574.4%  |
| 4 nodes, HT off |    1352329     |     4512914     | +233.7%  |
| 2 nodes, HT off |    2793037     |     2758652     |   -1.2%  |
| 1 node , HT off |    2458125     |     2445069     |   -0.5%  |
+-----------------+----------------+-----------------+----------+

With 4 nodes and above, there are significant performance improvement
with this patch. With only 1 or 2 nodes, the performance is very close.
Because of variability of the AIM7 benchmark, a few percent difference
may not indicate a real performance gain or loss.

A perf call-graph report of the short workload at 1500 users
without the patch on the same 8-node machine indicates that about
79% of the workload's total time were spent in the _raw_spin_lock()
function. Almost all of which can be attributed to the following 2
kernel functions:
 1. dget_parent (49.92%)
 2. dput (49.84%)

The relevant perf report lines are:
+  78.76%      reaim  [kernel.kallsyms]   [k] _raw_spin_lock
+   0.05%      reaim  [kernel.kallsyms]   [k] dput
+   0.01%      reaim  [kernel.kallsyms]   [k] dget_parent

With this patch installed, the new perf report lines are:
+  19.66%      reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
+   2.46%      reaim  [kernel.kallsyms]   [k] _raw_spin_lock
+   2.23%      reaim  [kernel.kallsyms]   [k] lockref_get_not_zero
+   0.50%      reaim  [kernel.kallsyms]   [k] dput
+   0.32%      reaim  [kernel.kallsyms]   [k] lockref_put_or_lock
+   0.30%      reaim  [kernel.kallsyms]   [k] lockref_get
+   0.01%      reaim  [kernel.kallsyms]   [k] dget_parent

-   2.46%      reaim  [kernel.kallsyms]   [k] _raw_spin_lock
   - _raw_spin_lock
      + 23.89% sys_getcwd
      + 23.60% d_path
      + 8.01% prepend_path
      + 5.18% complete_walk
      + 4.21% __rcu_process_callbacks
      + 3.08% inet_twsk_schedule
      + 2.36% do_anonymous_page
      + 2.24% unlazy_walk
      + 2.02% sem_lock
      + 1.82% process_backlog
      + 1.62% selinux_inode_free_security
      + 1.54% task_rq_lock
      + 1.45% unix_dgram_sendmsg
      + 1.18% enqueue_to_backlog
      + 1.06% unix_stream_sendmsg
      + 0.94% tcp_v4_rcv
      + 0.87% unix_create1
      + 0.71% scheduler_tick
      + 0.60% unix_release_sock
      + 0.59% do_wp_page
      + 0.59% unix_stream_recvmsg
      + 0.58% handle_pte_fault
      + 0.57% __do_fault
      + 0.53% unix_peer_get

The dput() and dget_parent() functions didn't show up in the
_raw_spin_lock callers at all.

This impact of this patch on other AIM7 workloads were much more
modest. Besides short, the other AIM7 workload that showed consistent
improvement is the high_systime workload. For the other workloads,
the changes were so minor that they are no significant difference
with and without the patch.

+--------------+---------------+----------------+-----------------+
|   Workload   | mean % change | mean % change  | mean % change   |
|              | 10-100 users  | 200-1000 users | 1100-2000 users |
+--------------+---------------+----------------+-----------------+
| high_systime |     +0.1%     |     +1.1%      |     +3.4%       |
+--------------+---------------+----------------+-----------------+

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c            |   26 ++++++++++++++++++--------
 include/linux/dcache.h |    7 ++-----
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 3adb6aa..9a4cf30 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -513,9 +513,15 @@ void dput(struct dentry *dentry)
 		return;
 
 repeat:
-	if (d_count(dentry) == 1)
-		might_sleep();
-	spin_lock(&dentry->d_lock);
+	if (d_count(dentry) > 1) {
+		if (lockref_put_or_lock(&dentry->d_lockcnt))
+			return;
+		/* dentry's lock taken */
+	} else {
+		if (d_count(dentry) == 1)
+			might_sleep();
+		spin_lock(&dentry->d_lock);
+	}
 	BUG_ON(!d_count(dentry));
 	if (d_count(dentry) > 1) {
 		dentry->d_lockcnt.refcnt--;
@@ -611,26 +617,30 @@ static inline void __dget_dlock(struct dentry *dentry)
 
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
index 20e6f2e..ec9206e 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -367,11 +367,8 @@ static inline struct dentry *dget_dlock(struct dentry *dentry)
 
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

