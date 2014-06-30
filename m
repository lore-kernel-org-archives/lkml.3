Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaF3QUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:20:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbaF3QU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:20:28 -0400
Date: Mon, 30 Jun 2014 18:18:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] rcu: uninline rcu_lock_acquire() and
	rcu_lock_release()
Message-ID: <20140630161849.GA15887@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630161837.GA15873@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uninline rcu_lock_acquire() and rcu_lock_release() to shrink .text/data.
The difference in "size vmlinux" looks good,

with CONFIG_DEBUG_LOCK_ALLOC

	- 5377829 3018320 14757888 23154037
	+ 5352229 3010160 14757888 23120277

33760 bytes saved.

with CONFIG_DEBUG_LOCK_ALLOC + CONFIG_PROVE_RCU + CONFIG_TREE_RCU_TRACE

	- 5678315 3027032 14757888 23463235
	+ 5578795 3026776 14757888 23363459

saves 99776 bytes.

However, this obviously means that the "warn once" logic is moved from
the current callers of rcu_lockdep_assert(rcu_is_watching()) to update.c.

Also, with this patch we do not bother to report which function abused
rcu_is_watching(), this should be clear from dump_stack().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/rcupdate.h |   60 +++++++++++++++++++++++----------------------
 include/linux/srcu.h     |    4 +-
 kernel/rcu/rcu.h         |    6 ++--
 kernel/rcu/update.c      |   53 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 34 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d231aa1..b82d1d6 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -355,21 +355,28 @@ static inline bool rcu_lockdep_current_cpu_online(void)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-static inline void rcu_lock_acquire(struct lockdep_map *map)
+extern struct lockdep_map rcu_lock_map;
+extern struct lockdep_map rcu_bh_lock_map;
+extern struct lockdep_map rcu_sched_lock_map;
+extern struct lockdep_map rcu_callback_map;
+int debug_lockdep_rcu_enabled(void);
+
+static inline void __rcu_lock_acquire(struct lockdep_map *map, unsigned long ip)
 {
-	lock_acquire(map, 0, 0, 2, 0, NULL, _THIS_IP_);
+	lock_acquire(map, 0, 0, 2, 0, NULL, ip);
 }
 
-static inline void rcu_lock_release(struct lockdep_map *map)
+static inline void __rcu_lock_release(struct lockdep_map *map, unsigned long ip)
 {
-	lock_release(map, 1, _THIS_IP_);
+	lock_release(map, 1, ip);
 }
 
-extern struct lockdep_map rcu_lock_map;
-extern struct lockdep_map rcu_bh_lock_map;
-extern struct lockdep_map rcu_sched_lock_map;
-extern struct lockdep_map rcu_callback_map;
-int debug_lockdep_rcu_enabled(void);
+extern void rcu_lock_acquire(void);
+extern void rcu_lock_release(void);
+extern void rcu_lock_acquire_bh(void);
+extern void rcu_lock_release_bh(void);
+extern void rcu_lock_acquire_sched(void);
+extern void rcu_lock_release_sched(void);
 
 /**
  * rcu_read_lock_held() - might we be in RCU read-side critical section?
@@ -463,8 +470,15 @@ static inline int rcu_read_lock_sched_held(void)
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
-# define rcu_lock_acquire(a)		do { } while (0)
-# define rcu_lock_release(a)		do { } while (0)
+#define __rcu_lock_acquire(map, ip)	do { } while (0)
+#define __rcu_lock_release(map, ip)	do { } while (0)
+
+#define rcu_lock_acquire()		do { } while (0)
+#define rcu_lock_release()		do { } while (0)
+#define rcu_lock_acquire_bh()		do { } while (0)
+#define rcu_lock_release_bh()		do { } while (0)
+#define rcu_lock_acquire_sched()	do { } while (0)
+#define rcu_lock_release_sched()	do { } while (0)
 
 static inline int rcu_read_lock_held(void)
 {
@@ -839,9 +853,7 @@ static inline void rcu_read_lock(void)
 {
 	__rcu_read_lock();
 	__acquire(RCU);
-	rcu_lock_acquire(&rcu_lock_map);
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_lock() used illegally while idle");
+	rcu_lock_acquire();
 }
 
 /*
@@ -889,9 +901,7 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_unlock() used illegally while idle");
-	rcu_lock_release(&rcu_lock_map);
+	rcu_lock_release();
 	__release(RCU);
 	__rcu_read_unlock();
 }
@@ -917,9 +927,7 @@ static inline void rcu_read_lock_bh(void)
 {
 	local_bh_disable();
 	__acquire(RCU_BH);
-	rcu_lock_acquire(&rcu_bh_lock_map);
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_lock_bh() used illegally while idle");
+	rcu_lock_acquire_bh();
 }
 
 /*
@@ -929,9 +937,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_unlock_bh() used illegally while idle");
-	rcu_lock_release(&rcu_bh_lock_map);
+	rcu_lock_release_bh();
 	__release(RCU_BH);
 	local_bh_enable();
 }
@@ -953,9 +959,7 @@ static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
 	__acquire(RCU_SCHED);
-	rcu_lock_acquire(&rcu_sched_lock_map);
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_lock_sched() used illegally while idle");
+	rcu_lock_acquire_sched();
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -972,9 +976,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_unlock_sched() used illegally while idle");
-	rcu_lock_release(&rcu_sched_lock_map);
+	rcu_lock_release_sched();
 	__release(RCU_SCHED);
 	preempt_enable();
 }
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index a2783cb..5c06289 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -219,7 +219,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 {
 	int retval = __srcu_read_lock(sp);
 
-	rcu_lock_acquire(&(sp)->dep_map);
+	__rcu_lock_acquire(&(sp)->dep_map, _THIS_IP_);
 	return retval;
 }
 
@@ -233,7 +233,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
-	rcu_lock_release(&(sp)->dep_map);
+	__rcu_lock_release(&(sp)->dep_map, _THIS_IP_);
 	__srcu_read_unlock(sp, idx);
 }
 
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index ff1a6de..4782d2f 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -107,16 +107,16 @@ static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
 
-	rcu_lock_acquire(&rcu_callback_map);
+	__rcu_lock_acquire(&rcu_callback_map, _THIS_IP_);
 	if (__is_kfree_rcu_offset(offset)) {
 		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
 		kfree((void *)head - offset);
-		rcu_lock_release(&rcu_callback_map);
+		__rcu_lock_release(&rcu_callback_map, _THIS_IP_);
 		return true;
 	} else {
 		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
 		head->func(head);
-		rcu_lock_release(&rcu_callback_map);
+		__rcu_lock_release(&rcu_callback_map, _THIS_IP_);
 		return false;
 	}
 }
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 4056d79..c2209eb 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -163,6 +163,59 @@ int rcu_read_lock_bh_held(void)
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
+static void rcu_lockdep_assert_watching(void)
+{
+	rcu_lockdep_assert(rcu_is_watching(), "RCU used illegally while idle");
+}
+
+static void rcu_acquire_map(struct lockdep_map *map, unsigned long ip)
+{
+	__rcu_lock_acquire(map, ip);
+	rcu_lockdep_assert_watching();
+}
+
+static void rcu_release_map(struct lockdep_map *map, unsigned long ip)
+{
+	rcu_lockdep_assert_watching();
+	__rcu_lock_release(map, ip);
+}
+
+void rcu_lock_acquire(void)
+{
+	rcu_acquire_map(&rcu_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_acquire);
+
+void rcu_lock_release(void)
+{
+	rcu_release_map(&rcu_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_release);
+
+void rcu_lock_acquire_bh(void)
+{
+	rcu_acquire_map(&rcu_bh_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_acquire_bh);
+
+void rcu_lock_release_bh(void)
+{
+	rcu_release_map(&rcu_bh_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_release_bh);
+
+void rcu_lock_acquire_sched(void)
+{
+	rcu_acquire_map(&rcu_sched_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_acquire_sched);
+
+void rcu_lock_release_sched(void)
+{
+	rcu_release_map(&rcu_sched_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_release_sched);
+
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 struct rcu_synchronize {
-- 
1.5.5.1

